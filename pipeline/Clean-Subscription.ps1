<#
.DESCRIPTION
This utility will run as part of a scheduled pipeline to check the sandbox scope subscription(s)
and remove resources that have existed beyond a specific threshold unless otherwise marked for retention.

This operates on a single subscription, and can be called multiple times to cover additional subscriptions
as necessary.

It looks for two tags on resources to determine the appropriate actions to take and acts accordingly based on what
is found

Tags:
* Persistent: The value of this tag is not checked, though by convention we give it the string value 'true'
* ExpireOn: This holds a date value in the format of "yyyy-MM-dd" for conversion and interpretation

Resources tagged 'Persistent' = 'true' are logged in the output of the execution and noted that they will not be cleaned up
All persistent entries will be printed to the log under the header "The following resources are marked for persistence and will not be deleted:"

Resources that are not tagged 'Persistent' and do not have an 'ExpireOn' tag are picked up next.
These resources get marked with an 'ExpireOn' = 'yyyy-MM-dd' tag where 'yyyy-MM-dd' is the current run time.

Resources tagged in this phase are logged under the header "New resources detected since last run:"

Next the list of resources that have an 'ExpireOn' tag with a date that is more than 14 days ago at run time are processed.
These resources are all deleted, and an entry is written to the log with details about the resource, resource group, and type.

Resources deleted are listed under the header "Expired resources:"

In the event that any resources cannot be cleaned, which happens from time to time due to the order in which they are processed
where one resource cannot be deleted before another, they will be captured and logged under the header "The following resources could not be cleaned up:"
These types of errors do occur, and will self resolve within a day or two since the cycle continues and moves on to the dependency and removes it
meaning the dependent resource can be cleaned up successfully the following day/run.

In the final phase of execution, any empty resource groups are detected and deleted

This cleanup utility has the following prerequisite requirements:
* To execute on compute with a managed identity that has deletion permissions over the subscription being processed
* The 'Az' module
* The 'Az.ResourceGraph' module

.PARAMETER SubscriptionName
* Type: String
* Required: True
* Default: NONE

The name of the subscription to process for automatic cleanup

THIS DELETES STUFF! make sure you want to automatically delete stuff in the specified subsription or you're going to have a bad time

.PARAMETER WorkingDirectory
* Type: String
* Required: False
* Default: NONE

The working directory for exection. This is not strictly necessary unless you are running into execution issues. some tasks in ADO do some
strange things with the working directory and it needs to be explicitly set.

.PARAMETER LocalMode
* Type: Boolean
* Requried: False
* Default: $false

This is a local debug execution flag for overriding the automatic login attempt for a managed identity when running it from a development
workstation or anywhere else that "isn't the pipeline"

.OUTPUTS
None, all outputs are logged to the host output
#>
[CmdletBinding()]
param(
    [string]$SubscriptionName,
    [string]$WorkingDirectory,
    [boolean]$LocalMode = $false
)

#
# This script leverages the ResourceGraph module from the Az provider (which is not included by default)
#
#Requires -Modules Az.ResourceGraph

if( $WorkingDirectory -ne "" )
{
  Write-Host "Writing explicit working directory provided"
  Set-Location $WorkingDirectory
}

# In a pipeline, depending on the task type the login may or may not have taken place automatically
# (i'm finding it does not, so this protects against that)
if( $LocalMode -eq $false )
{
    Login-AzAccount -Identity
}


$Subscription = Get-AzSubscription -SubscriptionName $SubscriptionName
$SubscriptionId = $Subscription.Id

Set-AzContext -Subscription $SubscriptionId


#
# Persistent Resource Listing
#
$PersistentResources = Search-AzGraph -Query "where subscriptionId == '$($SubscriptionId)' and tags contains 'Persistent'"
Write-Host "The following resources are marked for persistence and will not be deleted:"
foreach( $PersistentResource in $PersistentResources )
{
    Write-Host "[ $($PersistentResource.name) ] Resource Group [ $($PersistentResource.resourceGroup) ] Type [ $($PersistentResource.type) ]"
}



#
# New Resources (need to be marked for future deletion in 2 weeks)
# There is a chance some resources may get updated and reset the tag, this is not a major concern
#
Write-Host "Searching for new resources within subscription [ $($SubscriptionId) ]..."
$NewResources = Search-AzGraph -Query "where subscriptionId == '$($SubscriptionId)' and tags !contains 'Persistent' and tags !contains 'ExpireOn'"
$ExpireDate = ((Get-Date).AddDays(14)).ToString("yyyy-MM-dd")

# Need to collect failures to tag
$Untaggable = @()


Write-Host "New resources detected since last run:"
foreach( $Resource in $NewResources )
{
    try 
    {
        Update-AzTag -ResourceId $Resource.ResourceId -Tag @{"ExpireOn"=$ExpireDate} -Operation Merge
        Write-Host "[ $($Resource.name) ] Resource Group [ $($Resource.resourceGroup) ] Type [ $($Resource.type) ]. Marking for deletion on [ $($ExpireDate) ]"
    }
    catch 
    {
        $Untaggable += "[ $($Resource.name) ] Resource Group [ $($Resource.resourceGroup) ] Type [ $($Resource.type) ]"
    }
}

Write-Host "All new resources marked for future deletion"


Write-Host "The following resources could not be tagged for expiration:"
foreach( $Untagged in $Untaggable )
{
    Write-Host $Untagged
}


#
# Expired Resources
#
Write-Host "Searching for expired resources to clean up..."
$ExpiredResources = Search-AzGraph -Query "where subscriptionId == '$($SubscriptionId)' and todatetime(tags.ExpireOn) < now()"
$CleanupFailed = @()

Write-Host "Cleaning up expired resources..."

Write-Host "Expired resources:"
foreach( $ExpiredResource in $ExpiredResources )
{
    try
    {
        # Remove-AzResource -ResourceId $ExpiredResource.ResourceId -Force
        Write-Host "[ $($ExpiredResource.name) ] Resource Group [ $($ExpiredResource.resourceGroup) ] Type [ $($ExpiredResource.type) ] Cleanup completed"
    }
    catch
    {
        $CleanupFailed += "[ $($ExpiredResource.name) ] Resource Group [ $($ExpiredResource.resourceGroup) ] Type [ $($ExpiredResource.type) ] Cleanup failed!"
    }
}

Write-Host "All expired resources processed"

Write-Host "The following resources could not be cleaned up:"
foreach( $CleanupFailure in $CleanupFailed )
{
    Write-Host $CleanupFailure
}


#
# Empty Resource Groups
#
Write-Host "Cleaning empty resource groups"
$ResourceGroups = Get-AzResourceGroup
foreach( $ResourceGroup in $ResourceGroups )
{
    $Count = (Get-AzResource -ResourceGroupName $ResourceGroup.ResourceGroupName).Count
    if( $Count -eq 0 )
    {
        Write-Host "Empty Resource Group [ $($ResourceGroup.ResourceGroupName) ]"
        # Remove-AzResourceGroup -Name $ResourceGroup.ResourceGroupName
    }
}


Write-Host "Completed subscription cleanup task"
