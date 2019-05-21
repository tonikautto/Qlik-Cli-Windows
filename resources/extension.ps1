function Get-QlikExtension {
  [CmdletBinding()]
  param (
    [parameter(Position=0)]
    [string]$Id,
    [string]$Filter,
    [switch]$Full,
    [switch]$raw
  )

  PROCESS {
    $Path = "/qrs/extension"
    If( $Id ) { $Path += "/$Id" }
    If( $Full ) { $Path += "/full" }
    If( $raw ) { $rawOutput = $true }
    return Invoke-QlikGet -Path $Path -Filter $Filter
  }
}

function Import-QlikExtension {
  [CmdletBinding()]
  [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingPlainTextForPassword", "password")]
  param (
    [String]$ExtensionPath,
    $Password
  )

  PROCESS {
    $Path = "/qrs/extension/upload"
    if ($Password -is [System.Security.SecureString]) {
      $Password = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($Password))
    } else {
      Write-Warning -Message "Use of string password is deprecated, please use SecureString instead."
    }
    if($Password) {
      $Password = [System.Web.HttpUtility]::UrlEncode($Password)
      $Path += "?password=$Password"
    }
    return Invoke-QlikUpload $Path $ExtensionPath
  }
}

function Remove-QlikExtension {
  [CmdletBinding()]
  param (
    [parameter(Position=0,ValueFromPipelinebyPropertyName=$true)]
    [string]$ename
  )

  PROCESS {
    return Invoke-QlikDelete "/qrs/extension/name/$ename"
  }
}