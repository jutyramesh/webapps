<#
.DESCRIPTION
A list of parameter files to be deployed and the environment that they are part of

Pass a transport string to the constructor to deserialize back to a working object
Example: $DeploymentList = [CcpDeploymentList]::new($Transport)

.PROPERTY Environment
(string) The name of the environment that the list of parameter files belong to

.PROPERTY ParameterFiles
(string[]) A list of parameter files to be deployed for the environment, generally because they have changed, were added, or removed

.METHOD toTransport()
Converts the object to a string encoded form for transport
#>
class CcpDeploymentList {
    [string]$Environment
    [string[]]$ParameterFiles

    CcpDeploymentList()
    { }
    CcpDeploymentList( $Transport )
    {
        $decodedTransport = [System.Text.Encoding]::Unicode.GetString([System.Convert]::FromBase64String($Transport))
        $JsonCopy = $decodedTransport | ConvertFrom-Json

        $properties = Get-Member -InputObject $JsonCopy -MemberType NoteProperty
        $propertyNames = @()
        ForEach( $property in $properties )
        {
            $propertyNames += $property.Name
        }

        #
        # Environment
        #
        if( $propertyNames -NotContains 'Environment' )
        {
            throw "Malformed Input: the provided transport object did not contain a Environment property"
        }
        if( $JsonCopy.Environment -IsNot [string] )
        {
            throw "Malformed Input: the Environment property of the provided transport object is not a string"
        }
        $this.Environment = $JsonCopy.Environment


        #
        # ParameterFiles
        #
        if( $propertyNames -NotContains 'ParameterFiles' )
        {
            throw "Malformed Input: the provided transport object did not contain a ParameterFiles property"
        }
        if( $JsonCopy.ParameterFiles -IsNot [array] )
        {
            throw "Malformed Input: the ParameterFiles property of the provided transport object is not an array"
        }
        ForEach( $ParameterFile in $JsonCopy.ParameterFiles )
        {
            if( $ParameterFile -IsNot [string] )
            {
                throw "Malformed Input: A member of the ParameterFile property in the provided transport object is not a string"
            }
            $this.ParameterFiles += $ParameterFile
        }
    }

    <#
    .DESCRIPTION
    Converts the object to a string encoded form for transport
    .OUTPUTS
    (string) a base 64 encoded JSON structure for passing between tasks
    #>
    [string]toTransport()
    {
        $thisJson = $this | ConvertTo-Json
        $thisBytes = [System.Text.Encoding]::Unicode.GetBytes($thisJson)
        $thisTransport =[Convert]::ToBase64String($thisBytes)
        return $thisTransport
    }
  }
