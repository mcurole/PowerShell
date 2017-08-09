If (-not (Test-IsAdmin)) {
    . "C:\Program Files (x86)\VMware\Infrastructure\PowerCLI\Scripts\Initialize-PowerCLIEnvironment.ps1"

    Import-Module Hyper-V
    Remove-Module Hyper-V

}

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