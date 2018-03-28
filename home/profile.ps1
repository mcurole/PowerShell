# PowerShell profile
# Updated 1/23/2018 - Update profile to work with Windows PowerShell and PowerShell Core
# Revision History
# 1.0 - Unknown - Original Version
# 1.1 - 1/24/2018 - Updated for support of cloud shell
# 1.2 - 1/24/2018 - Updated prompt for Cloud Shell and PSVersion
# 1.3 - 2/1/2018  - Updated prompt for Ubuntu support
# 1.4 - 2/7/2018  - Update to support .ssh key folder persistance in Azure Cloud Shell
# 1.5 - 3/28/2018 - Update to remove curl alias on Windows when curl.exe is present

$IsACS = Test-Path Env:\ACC_CLOUD

if ($IsACS) {
    if (-not (Test-Path $home\CloudDrive\.pscloudshell\PowerShell\Modules)) {
        New-item -ItemType Directory -Path $home\CloudDrive\.pscloudshell\PowerShell\Modules
    }
    if (-not (Test-Path $home\Documents\PowerShell\Modules)) {
        New-Item -ItemType SymbolicLink -Path $home\Documents\PowerShell -Name Modules -Value $home\CloudDrive\.pscloudshell\PowerShell\Modules | Out-Null 
    }

    if (-not (Test-Path $home\CloudDrive\.ssh)) {
        New-Item -ItemType Directory -Path  $home\CloudDrive\.ssh
    }
    if (-not (Test-Path $home\.ssh)) {
        New-Item -ItemType SymbolicLink -Path $home -Name .ssh -Value $home\CloudDrive\.ssh | Out-Null 
    }
}

If ($PSVersionTable.PSEdition -eq "Core") {
    if (Get-Module -Name WindowsPSModulePath -ListAvailable) { Add-WindowsPSModulePath }
}

If (($PSVersionTable.PSEdition -eq "Desktop") -or $IsWindows ) {
    New-PSDrive -Name Docs -PSProvider FileSystem -Root ([environment]::GetFolderPath('MyDocuments')) | Out-Null
    New-PSDrive -Name Downloads -PSProvider FileSystem -Root ([environment]::GetFolderPath('UserProfile') + "\Downloads") | Out-Null
    if ((Test-Path "$env:systemroot\system32\curl.exe") -and (Test-Path alias:\curl)) {
        Remove-Item -Path alias:\curl
    }
}

$PSDefaultParameterValues = @{
    "Set-AuthenticodeSignature:TimestampServer" = "http://timestamp.verisign.com/scripts/timstamp.dll"
    }

if (Get-Module -Name posh-docker -ListAvailable) { Import-Module posh-docker }
if (Get-Module -name posh-git -ListAvailable) { Import-Module posh-git }

New-Alias -Name cvis -Value Clear-VIServers -Force 
New-Alias -Name sde -Value Switch-DockerEngine -Force
New-Alias -Name rds -Value Connect-RdServer -Force
New-Alias -Name rh -Value Resolve-DnsName -Force
New-Alias -Name zip -Value Microsoft.PowerShell.Archive\Compress-Archive -Force
New-Alias -Name unzip -Value Microsoft.PowerShell.Archive\Expand-Archive -Force
New-Alias -name ocb -Value Microsoft.PowerShell.Management\Set-Clipboard -Force
New-Alias -name gcb -Value Microsoft.PowerShell.Management\Get-Clipboard -Force

Function Test-Administrator {
    If (($PSVersionTable.PSEdition -eq "Desktop") -or $IsWindows ) {
        $user = [Security.Principal.WindowsIdentity]::GetCurrent();
        (New-Object Security.Principal.WindowsPrincipal $user).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
    } else { $false }
}

Function prompt {
    $realLASTEXITCODE = $LASTEXITCODE

    $p = "`n"

    if ($IsACS) {
        $p += "Azure CS"
    }
    else {
        if (Test-Administrator) {
            # Use different username if elevated
            $p += "(Elevated) "
        }

        $p += (whoami)
        $p += "@"
        $p += (hostname)
    }

    $p += " : "
    $p += $($(Get-Location) -replace ($env:HOME).Replace('\', '\\'), "~")
    $p += " : "
    $p += (Get-Date -Format G)
    $p += " : " 
    $p += "PSver $($PSVersionTable.PSVersion)`n> "

    $global:LASTEXITCODE = $realLASTEXITCODE

    if ( Get-Module posh-git -ListAvailable) {
        $p += Write-VcsStatus        
    }

    return $p 

}
