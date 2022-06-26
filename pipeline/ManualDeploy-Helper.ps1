<#
.SYNOPSIS
This is a helper script for getting values out of the parameter file you may be using
based on the convension we tend to follow for setting up relationships between parameters
and templates and storing additional details in them.

If you are not following those convesions this will probably be somewhere between unhelpful to down right anti-helpful
#>
[CmdletBinding()]
param (
  [string]$ParameterFile,
  [switch]$GetResourceGroup,
  [switch]$GetSubscription,
  [switch]$GetTemplateFile,
  [switch]$GetAzCliDeployCmd,
  [switch]$GetAzCliRgCmd
)

$ParameterObject = Get-Content -Raw -Path $ParameterFile | ConvertFrom-Json

$SubscriptionString = $ParameterObject.deploymentParameters.subscription
$ResourceGroupString = $ParameterObject.deploymentParameters.resourceGroup
$TemplateFileString = $ParameterObject.deploymentParameters.templateFile
$LocationString = $ParameterObject.parameters.location.value

if( $GetAzCliRgCmd )
{
    return "az group create --name $($ResourceGroupString) --location $($LocationString)"
}

if( $GetAzCliDeployCmd )
{
    return "az deployment group create --name '$(Get-Date -Format "yyyy-MM-dd-HH-mm")' --resource-group $($ResourceGroupString) --template-file $($TemplateFileString) --parameters '@$($ParameterFile)'"
}

if( $GetResourceGroup )
{
    return $ResourceGroupString
}

if( $GetSubscription )
{
    return $SubscriptionString
} 

if( $GetTemplateFile )
{
    # This one needs some more work, we should look for it maybe and get a real absolute path from the CWD
    $TemplateFileString
}
