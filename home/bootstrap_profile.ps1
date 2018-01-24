# File bootstrap_profile.ps1
# copy this to your PowerShell profile.ps1 script to download full profile.ps1 from GitHub
$ProfileUrl = 'https://raw.githubusercontent.com/mcurole/PowerShell/master/home/profile.ps1'
Invoke-WebRequest -UseBasicParsing -Uri $ProfileUrl -OutFile ($PROFILE.CurrentUserAllHosts + "/../.profile.ps1")
. (($PROFILE.CurrentUserAllHosts + "/../.profile.ps1"))