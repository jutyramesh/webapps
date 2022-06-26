<#
.DESCRIPTION
Performs resource deployments for a given environment based on the provided DeploymentList
which should be a transport formated CcpDeploymentList object with details about the
staged changes in the form of parameter files

.PARAMETER DeploymentList
A serialized CcpDeploymentList object with changes for the environment that need to be handled

.PARAMETER WorkingDirectory
To allow you to provide an explicit working directory and override the default
in the event that is necessary (ADO can act strange with the working directories between tasks)
#>
Using module .\Class.CcpDeploymentList.psm1
Using module .\Class.CcpDeploymentResult.psm1
Using module .\Class.CcpLocalDeployment.psm1

[CmdletBinding()]
param(
    [string]$DeploymentList,
    [string]$WorkingDirectory
)


if( $WorkingDirectory -ne "" )
{
  Write-Host "Writing explicit working directory provided"
  Set-Location $WorkingDirectory
}
else
{
    $WorkingDirectory = (Get-Location).Path
}

Write-Host "Working Directory [ $($WorkingDirectory) ]"

$DeploymentDetails = [CcpDeploymentList]::new($DeploymentList)

Write-Host "Environment: [$($DeploymentDetails.Environment)]"
Write-Host "Changes:"
Write-Host $DeploymentDetails.ParameterFiles

if( $DeploymentDetails.ParameterFiles.Count -lt 1 )
{
    # there arent any updates for this environment
    # log and exit cleanly here
    Write-Host "No changes pending for this environment, exiting"
    exit 0
}

ForEach( $ParameterFile in $DeploymentDetails.ParameterFiles )
{
    # If the resource does not exist, that would mean it is a delete operation
    # (unless it was moved, that would be bad), i'm not going to implement that yet either way
    if ( -not (Test-Path -Path $WorkingDirectory/$ParameterFile -PathType leaf)) {
        Write-Host "Resource deletion event found for [ $($ParameterFile) ]"
        Write-Host "Deletions are not yet supported, please remove the resource by other means"
    }
    else
    {
        Write-Host "Modified resource detected [ $($ParameterFile) ]"
        $CcpDeployer = [CcpLocalDeployment]::new($WorkingDirectory, $ParameterFile)

        #Write-Host "performing deployment validation"
        #$ValidationResult = $CcpDeployer.validate()

        #if( $ValidationResult.Valid -eq $false )
        #{
        #    Write-Host "Failed validation"
        #    continue
        #}
        #if( $ValidationResult.ResourceGroupExists )
        #{
        #    Write-Host "Change Prediction"
        #    Write-Host $ValidationResult.ChangePrediction -Separator "`n"
        #}

        Write-Host "Performing resource deployment..."
        $DeployResult = $CcpDeployer.deploy()

        if( $DeployResult.Success -eq $false )
        {
            Write-Host "Deployment of resource failed!"
            Write-Host $DeployResult.DeploymentResult
        }
        Write-Host "Deployment completed"
        Write-Host "Outputs"
        Write-Host $DeployResult.Outputs
    }
}
