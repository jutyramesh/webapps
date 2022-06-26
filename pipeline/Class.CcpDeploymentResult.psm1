<#
.DESCRIPTION
Results data structure from a deployment operation with details about it

Only some of the properties would be set in a validation run

this could be used as a return structure for a validation as well
i would need a separate class / module for populating this object
or i could do it right in the invoke function, i want to try and keep
the logic for performing the deployment and the validation of it close together though

should i make this generic enough to work in the future?

i could have a deploy() method and validate() method
and deploy() could call validate() and take the result object and build on it

validate() by itself would return a result object too, but it would not be fully
populated

.NOTES
This class is built to fit the light weight deployment model
there would be some modifications necessary in the future if this
is expanded to handle Ccp Deployment offloading
#>
class CcpDeploymentResult {
    <#
    .DESCRIPTION
    Indicator for if a deployment took place
    #>
    [boolean]$Deployed

    <#
    .DESCRIPTION
    The type of the deployment that will/did occur of type DeploymentType
    #>
    [DeploymentType]$Type

    <#
    .DESCRIPTION
    Indicator for if a validation took place
    #>
    [boolean]$Validated

    <#
    .DESCRIPTION
    Indicator for if the validation step passed
    #>
    [boolean]$Valid

    <#
    .DESCRIPTION
    Human readable output from the validation process
    #>
    [string]$ValidationMessage

    <#
    .DESCRIPTION
    The output from a what-if execution performed in the validation
    that shows the expected events when the deployment occurs
    #>
    [string[]]$ChangePrediction

    <#
    .DESCRIPTION
    Indicates if the resource group already exists
    #>
    [boolean]$ResourceGroupExists
    <#
    .DESCRIPTION
    Indicates if the resource group was created or not as part of the deployment
    (i cant think of a reason i would care here.. but i have to set the other thing so why not)
    #>
    [boolean]$ResourceGroupCreated

    <#
    .DESCRIPTION
    The resolved path to the parameter file used for the deployment
    #>
    [string]$ParameterFile

    <#
    .DESCRIPTION
    The resolved path for the template file used for the deployment
    #>
    [string]$TemplateFile

    <#
    .DESCRIPTION
    The full translated object returned from the deployment operation
    #>
    [object]$DeploymentResult

    <#
    .DESCRIPTION
    The captured outputs from the deployment in object form
    #>
    [object]$Outputs

    <#
    .DESCRIPTION
    Indicator for if the deployment was successful or not
    #>
    [boolean]$Success
  }

<#
.DESCRIPTION
Deployment type indicator for classifying what took place
#>
enum DeploymentType {
    Unknown = 0
    Create = 1
    Update = 2
    Delete = 3
}
