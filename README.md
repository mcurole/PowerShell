# PowerShell Profile

---
This is my default powershell profile. It is designed to be multiplatform - tested on Windows Powershell 5.1 and PowerShell Core 6.0 on WSL, Ubuntu. It also has support for Azure Cloud Shell.

## Installation

Execute the following commands to install.

    New-Item $home/Documents/Projects
    Set-Location $home/Documents/Projects
    git clone https://github.com/mcurole/PowerShell-Profile.git
    Copy-Item PowerShell-Profile/home/bootstrap_profile.ps1 $profile.CurrentUserAllHosts
