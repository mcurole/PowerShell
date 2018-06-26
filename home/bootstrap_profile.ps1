# File bootstrap_profile.ps1
# cd $home/Documents/Projects 
# git clone https://github.com/mcurole/PowerShell-Profile.git
# copy-item PowerShell-Profile/home/bootstrap_profile.ps1 $profile.CurrentUserAllHosts
# copy this to your PowerShell profile.ps1 script to download full profile.ps1 from GitHub
$IsACS = Test-Path Env:\ACC_CLOUD

if ($IsACS) {
    if (-not (Test-Path $home\CloudDrive\Projects)) {
        New-item -ItemType Directory -Path $home\CloudDrive\Projects
    }
    if (-not (Test-Path $home\Documents\Projects)) {
        New-Item -ItemType SymbolicLink -Path $home\Documents -Name Projects -Value $home\CloudDrive\Projects | Out-Null 
    }
}

. $home/Documents/Projects/powershell-profile/home/profile.ps1