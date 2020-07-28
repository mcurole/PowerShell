# PowerShell profile
# Updated 1/23/2018 - Update profile to work with Windows PowerShell and PowerShell Core
# Revision History
# 1.0 - Unknown - Original Version
# 1.1 - 1/24/2018 - Updated for support of cloud shell
# 1.2 - 1/24/2018 - Updated prompt for Cloud Shell and PSVersion
# 1.3 - 2/1/2018  - Updated prompt for Ubuntu support
# 1.4 - 2/7/2018  - Update to support .ssh key folder persistance in Azure Cloud Shell
# 1.5 - 3/28/2018 - Update to remove curl alias on Windows when curl.exe is present
# 1.6 - 6/26/2018 - Update to sync via github.com
# 1.7 - 7/10/2018 - Update to use WindowsCompatibility module
# 1.8 - 7/10/2018 - Update for new Azure Cloud Shell

If ($PSVersionTable.PSEdition -eq "Core") {
    if (Get-Module -Name WindowsCompatibility -ListAvailable) { Add-WindowsPSModulePath }
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
if (Get-Module oh-my-posh -ListAvailable) { Import-Module oh-my-posh}
Set-Theme Paradox

New-Alias -Name cvis -Value Clear-VIServers -Force 
New-Alias -Name sde -Value Switch-DockerEngine -Force
New-Alias -Name rds -Value Connect-RdServer -Force
New-Alias -Name rh -Value Resolve-DnsName -Force
New-Alias -Name zip -Value Microsoft.PowerShell.Archive\Compress-Archive -Force
New-Alias -Name unzip -Value Microsoft.PowerShell.Archive\Expand-Archive -Force
New-Alias -name ocb -Value Microsoft.PowerShell.Management\Set-Clipboard -Force
New-Alias -name gcb -Value Microsoft.PowerShell.Management\Get-Clipboard -Force

if (Test-Path env:\ACC_CLOUD) { Set-Location $home }

Function Test-Administrator {
    If (($PSVersionTable.PSEdition -eq "Desktop") -or $IsWindows ) {
        $user = [Security.Principal.WindowsIdentity]::GetCurrent();
        (New-Object Security.Principal.WindowsPrincipal $user).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
    } else { $false }
}

# Function prompt {
#     $realLASTEXITCODE = $LASTEXITCODE

#     $p = "`n"

#     if (Test-Path env:\ACC_CLOUD) {
#         $p += "Azure CS"
#     }
#     else {
#         if (Test-Administrator) {
#             # Use different username if elevated
#             $p += "(Elevated) "
#         }

#         $p += (whoami)
#         $p += "@"
#         $p += (hostname)
#     }

#     $p += " : "
#     $p += $($(Get-Location) -replace ($env:HOME).Replace('\', '\\'), "~")
#     $p += " : "
#     $p += (Get-Date -Format G)
#     $p += " : " 
#     $p += "PSver $($PSVersionTable.PSVersion)`n> "

#     $global:LASTEXITCODE = $realLASTEXITCODE

#     if ( Get-Module posh-git -ListAvailable) {
#         $p += Write-VcsStatus        
#     }

#     return $p 

# }
