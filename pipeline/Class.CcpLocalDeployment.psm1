<#
.DESCRIPTION
A light-weight local deployment logic handler leveraging the AZ CLI with input / output normalization

.NOTES
This could easily be replaced with a CcpCentralDeployment class following the same interface
that would otherwise function the same

Becaue why not over-engineer things?
This will establish an interface of two primary functions and a common result type

.validate() will perform a prevalidation
.deploy() will call validate and then carry out the deployment
both will return a CcpDeploymentResult object

This could be expanded to include parameter translation for customization pretty easily too
this way the parameters could be loaded from file, manipulated and then translated back for the deployment
operation which would allow for pretty easy deployment event chaining
#>
Using module .\Class.CcpDeploymentResult.psm1

class CcpLocalDeployment {
    [string]$_ParameterPath
    [string]$_WorkingDirectory

    [boolean]$_Debug = $false

    <#
    .DESCRIPTION
    The deserialized parameter object taken from the source method provided
    .NOTES
    This could recieve dynamic updates pretty easily which would make it easier to
    do client side linking, i could potentially move the outputs up here
    in the deploy method as well for even easier stuff, but the return object
    works too
    #>
    [object]$ParameterObject

    CcpLocalDeployment( [string]$WorkingDirectory, [string]$ParameterPath )
    {
        $this._WorkingDirectory = $WorkingDirectory
        $this._ParameterPath = $ParameterPath

        $ParameterAbsolutePath = Join-Path -Path $this._WorkingDirectory -ChildPath $this._ParameterPath
        if( -not (Test-Path $ParameterAbsolutePath -PathType leaf) )
        {
            throw new exception "Parameter file could not be found @ [ $ParameterAbsolutePath ]"
        }

        # this will throw an exception if it can't load the JSON correctly
        $this.ParameterObject = Get-Content -Raw $ParameterAbsolutePath | ConvertFrom-Json
    }

    <#
    .DESCRIPTION
    Performs a validation of the deployment that will take place

    .NOTES
    This is a significantly lighter-weight validation sequence than what would
    take place in the central deployment validation

    .OUTPUTS
    A populated CcpDeploymentResult object with details about the deployment
    #>
    [CcpDeploymentResult]validate()
    {
        $ValidationResults = [CcpDeploymentResult]::new()
        $ValidationResults.Validated = $true
        $ValidationResults.Valid = $false
        $ValidationResults.Type = "Unknown"

        do
        {
            # This isn't strictly necessary but it is fast enough and it feels wrong not to check it
            $ParameterAbsolutePath = Join-Path -Path $this._WorkingDirectory -ChildPath $this._ParameterPath
            if( -not (Test-Path $ParameterAbsolutePath -PathType leaf) )
            {
                $ValidationResults.Valid = $false
                $ValidationResults.ValidationMessage = "Parameter file not found [ $($ParameterAbsolutePath) ]"
                break
            }
            $ValidationResults.ParameterFile = $ParameterAbsolutePath

            # # if the parameter file is invalid this would cause a parsing exception, should we catch that?
            # $this.ParameterObject = Get-Content -Raw $ParameterAbsolutePath | ConvertFrom-Json

            if( $null -eq $this.ParameterObject.deploymentParameters.templateFile )
            {
                $ValidationResults.Valid = $false
                $ValidationResults.ValidationMessage = "Template file reference not found @ [OBJECT].deploymentParameters.templateFile"
                break
            }

            $TemplateAbsolutePath = Join-Path -Path $this._WorkingDirectory -ChildPath $this.ParameterObject.deploymentParameters.templateFile
            if( -not (Test-Path $TemplateAbsolutePath -PathType leaf) )
            {
                $ValidationResults.Valid = $false
                $ValidationResults.ValidationMessage = "Template file not found [ $($TemplateAbsolutePath) ]"
                break
            }
            $ValidationResults.TemplateFile = $TemplateAbsolutePath


            if( $null -eq $this.ParameterObject.deploymentParameters.subscription )
            {
                $ValidationResults.Valid = $false
                $ValidationResults.ValidationMessage = "subscription reference not found @ [OBJECT].deploymentParameters.subscription"
                break
            }


            az account set --subscription "$($this.ParameterObject.deploymentParameters.subscription)"
            if( $? -eq $false )
            {
                $ValidationResults.Valid = $false
                $ValidationResults.ValidationMessage = "subscription [ $($this.ParameterObject.deploymentParameters.subscription) ] not found, check the name or id and identity permissions"
                break
            }


            if( $null -eq $this.ParameterObject.deploymentParameters.resourceGroup )
            {
                $ValidationResults.Valid = $false
                $ValidationResults.ValidationMessage = "resourceGroup reference not found @ [OBJECT].deploymentParameters.resourceGroup"
                break
            }

            if( (az group exists --name "$($this.ParameterObject.deploymentParameters.resourceGroup)") -eq 'false' )
            { # This one isn't a failure
                $ValidationResults.ResourceGroupExists = $false
                $ValidationResults.Type = "Create"

                # But now we need a location for the resource group
                if( $null -eq $this.ParameterObject.parameters.location.value )
                {
                    $ValidationResults.Valid = $false
                    $ValidationResults.ValidationMessage = "location reference not found @ [OBJECT].parameters.location.value"
                    break
                }
            }
            else 
            {
                $ValidationResults.ResourceGroupExists = $true
            }
            
            
            $ValidationResults.Valid = $true
            $ValidationResults.ValidationMessage = "Validation completed"

            # now we want to run a what-if? but if its a new creation we can't i assume, maybe?
            # no if we need to create the resource group we cant do the what if
            if( $ValidationResults.ResourceGroupExists -eq $false )
            {   # this isnt a failure but we don't need to do the next check
                break
            }

            $WhatIfOutput = az deployment group what-if --resource-group "$($this.ParameterObject.deploymentParameters.resourceGroup)" `
                                                        --name "$(Get-Date -Format "yyyy-MM-dd-HH-mm")" `
                                                        --template-file "$($ValidationResults.TemplateFile)" `
                                                        --parameters "@$($ValidationResults.ParameterFile)"
            # can we tell if this is an existing resource from the template? there may be more than one
            $ValidationResults.ChangePrediction = $WhatIfOutput

            $TypeCheckLine = $ValidationResults.ChangePrediction[-1]

            # last line with new
            # Resource changes: 2 to create, 2 to ignore.
            # last line with change
            # Resource changes: 2 to modify, 1 to ignore.
            # last line with no change
            # Resource changes: 1 to modify, 1 no change, 1 to ignore.

        } while ($false)

        return $ValidationResults
    }

    <#
    .DESCRIPTION
    Executes the deployment operation including running a validation first
    If the validation fails the deployment will not run and the results are returned

    .OUTPUTS
    A populated CcpDeploymentResult object with details about the deployment
    #>
    [CcpDeploymentResult]deploy()
    {
        $Results = $this.validate()

        if( -not $Results.ResourceGroupExists )
        {
            az group create --name "$($this.ParameterObject.deploymentParameters.resourceGroup)" `
                            --location "$($this.ParameterObject.parameters.location.value)"

            if( $? -eq $false )
            {
                throw new Exception "Failed to create resource group"
            }

            $Results.ResourceGroupCreated = $true
        }

        $CmdOutput = az deployment group create --resource-group "$($this.ParameterObject.deploymentParameters.resourceGroup)" `
                                                --name "$(Get-Date -Format "yyyy-MM-dd-HH-mm")" `
                                                --template-file "$($Results.TemplateFile)" `
                                                --parameters "@$($Results.ParameterFile)"

        # probably need to check out if this was good or bad and maybe do something about it in output
        $Results.Deployed = $true
        $Results.DeploymentResult = $CmdOutput | ConvertFrom-Json
        $Results.Success = $Results.DeploymentResult.properties.provisioningState -eq 'Succeeded'

        if( $Results.Success )
        {
            $Results.Outputs = $Results.DeploymentResult.outputs
        }

        return $Results
    }
  }
