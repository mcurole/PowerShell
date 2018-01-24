# PowerShell profile
# Updated 1/23/2018 - Update profile to work with Windows PowerShell and PowerShell Core
# Revision History
# 1.0 - Unknown - Original Version
# 1.1 - 1/24/2018 - Updated for support of cloud shell
# 1.2 - 1/24/2018 - Updated prompt for Cloud Shell and PSVersion

$IsACS = Test-Path Env:\ACC_CLOUD

if ($IsACS -and -not (Test-Path $home\Documents\PowerShell\Modules)) {
    New-Item -ItemType SymbolicLink -Path $home\Documents\PowerShell -Name Modules -Value $home\CloudDrive\.pscloudshell\PowerShell\Modules | Out-Null 
}

If ($PSVersionTable.PSEdition -eq "Core") {
    if (Get-Module -Name WindowsPSModulePath -ListAvailable) { Add-WindowsPSModulePath }
}

If (($PSVersionTable.PSEdition -eq "Desktop") -or $IsWindows ) {
    New-PSDrive -Name Docs -PSProvider FileSystem -Root ([environment]::GetFolderPath('MyDocuments')) | Out-Null
    New-PSDrive -Name Downloads -PSProvider FileSystem -Root ([environment]::GetFolderPath('UserProfile') + "\Downloads") | Out-Null
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

    Write-Host

    if ($IsACS) {
        Write-Host "Azure CS" -NoNewline -ForegroundColor Green
    }
    else {
        if (Test-Administrator) {
            # Use different username if elevated
            Write-Host "(Elevated) " -NoNewline -ForegroundColor White
        }

        Write-Host "$ENV:USERNAME@" -NoNewline -ForegroundColor DarkYellow
        Write-Host "$ENV:COMPUTERNAME" -NoNewline -ForegroundColor Magenta
    }

    Write-Host " : " -NoNewline -ForegroundColor DarkGray
    Write-Host $($(Get-Location) -replace ($env:USERPROFILE).Replace('\','\\'), "~") -NoNewline -ForegroundColor Blue
    Write-Host " : " -NoNewline -ForegroundColor DarkGray
    Write-Host (Get-Date -Format G) -NoNewline -ForegroundColor Magenta
    Write-Host " : " -NoNewline -ForegroundColor DarkGray
    Write-Host "PSver $($PSVersionTable.PSVersion)" -NoNewline 

    $global:LASTEXITCODE = $realLASTEXITCODE

    Write-VcsStatus

    Write-Host ""

    return "> "
}
