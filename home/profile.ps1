Import-Module Pscx -arg "$(Split-Path $profile -parent)\Pscx.UserPreferences.ps1"

New-PSDrive -Name Docs -PSProvider FileSystem -Root ([environment]::GetFolderPath('MyDocuments')) | Out-Null
New-PSDrive -Name Mod -PSProvider FileSystem -Root ([environment]::GetFolderPath('MyDocuments') + "\WindowsPowerShell\Modules") | Out-Null
New-PSDrive -Name GDrive -PSProvider FileSystem -Root ([environment]::GetFolderPath('UserProfile') + "\Google Drive") | Out-Null
New-PSDrive -Name Downloads -PSProvider FileSystem -Root ([environment]::GetFolderPath('UserProfile') + "\Downloads") | Out-Null
New-PSDrive -Name ISOs -PSProvider FileSystem -Root ("C:\ISOs") | Out-Null

$PSDefaultParameterValues = @{
    "Enter-PSSession:Authentication" = "Credssp"
    "Set-AuthenticodeSignature:TimestampServer" = "http://timestamp.verisign.com/scripts/timstamp.dll"
    }

Import-Module posh-docker
Import-Module posh-git

New-Alias -Name cvis -Value Clear-VIServers
New-Alias -Name sde -Value Switch-DockerEngine
New-Alias -Name rds -Value Connect-RdServer
New-Alias -Name rh -Value Resolve-DnsName
New-Alias -Name zip -Value Microsoft.PowerShell.Archive\Compress-Archive
New-Alias -Name unzip -Value Microsoft.PowerShell.Archive\Expand-Archive
