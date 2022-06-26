<#
.DESCRIPTION
Reads the incoming git commit delta and builds the environment specific change lists that will be used for deployments
in other stages

Pass in a comma separated list of environment folder names which will be translated into
transportable CcpDeploymentList objects set as matching VSO variables to be read in environment specific stages

This is to allow for a generic an largely pipeline controlled translation.

.PARAMETER Environments
An array of environment folder names that will be used for filtering and sorting
changes to be carried out in other stages.
Example: -Environments "sandbox", "development", "test", "production"

.PARAMETER WorkingDirectory
To allow you to provide an explicit working directory and override the default
in the event that is necessary (ADO can act strange with the working directories between tasks)

.OUTPUTS
(Not returns)
named VSO variables for each of the environments provided
#>
Using module .\Class.CcpDeploymentList.psm1

[CmdletBinding()]
param(
    [string[]]$Environments,
    [string]$WorkingDirectory
)

if( $WorkingDirectory -ne "" )
{
  Write-Host "Writing explicit working directory provided"
  Set-Location $WorkingDirectory
}


# will need to dress up the environment names
# for each one we will need to ensure the folder exists so that filtering can be done
# and create the name
# i will need to do some sanity on them, i might get them as filepaths
# i think it would be best to operate on the environment list not the change list
# and then filter out the changes based on folder
$environmentList = @()
# we don't know if we got file paths or what, but i guess we can assume
# i'll sanitize this later
$environmentList = $Environments



#Write-Host (Get-Location).Path
# this would put it into a comma separated string
#$changedFiles = @( git diff HEAD HEAD~ --name-only ) -Join ","
$changedFiles = @( git diff HEAD HEAD~ --name-only )
#Write-Host "Changed files:"
#Write-Host $changedFiles
#Write-Output "##vso[task.setvariable variable=changedFiles]${changedFiles}"

ForEach( $environment in $environmentList )
{
    $environmentDeployments = [CcpDeploymentList]::new()

    $environmentDeployments.Environment = $environment
    $environmentDeployments.ParameterFiles = @()

    ForEach( $changedFile in $changedFiles )
    {
        # $FileExists = $false
        # if ( -not (Test-Path -Path $WorkingDirectory/$changedFile -PathType leaf)) {
        #     Write-Host "Skipping deleted file"
        #     continue
        # }

        if( -not $changedFile.StartsWith("$($environment)/") -or -not $changedFile.EndsWith(".json"))
        {
            # Verbose for now
            Write-Host "Skipping [$($changedFile)]"
            continue
        }

        Write-Host "Adding [$($changedFile)] to environment list"
        $environmentDeployments.ParameterFiles += $changedFile
    }

    Write-Host "Generating VSO variable for environment [$($environment)]"
    if( $environmentDeployments.ParameterFiles.Count -gt 0 )
    {
        Write-Output "##vso[task.setvariable variable=$($environment)Changed]true"
    }
    else
    {
        Write-Output "##vso[task.setvariable variable=$($environment)Changed]false"
    }
    $envTransport = $environmentDeployments.toTransport()
    Write-Output "##vso[task.setvariable variable=$environment]${envTransport}"
}

Write-Host "Completed environment change registration"