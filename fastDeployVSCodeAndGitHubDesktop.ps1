# Simple PowerShell Code to Install multiple components on your Windows Machine
# Install: PowerShell Get Module, PIP, choco, Python 3, VSCode and GitHub Desktop
# Disclaimer: Code is providede as is. This is a sample code and should be run at the user's own risk.
# Future implementations should scan the OS for installed components and allow the user to install the missing ones only.
# Collaboration is always appreciated!

# Tested on Windows 10 Version	10.0.22621 Build 22621
# Tested with PowerShell PSVersion 5.1
# To get your PowerShell Version, run the command: $PSVersionTable

# This code consists of x Sections

# Section 1 - Get the Execution Policy, as this will be changed, it will return you back to the state where you were when the code begin.
# Section 2 - As this code is provided "as is", the user will be prompted about this fact and confirmation to proceed will be asked.
# Section 3 - Check if the applications are already installed. And lists which are pending to install
# Note on Section 3: Please bear in mind that some applications might need you to re-open the terminal to have the system environment variables updated, including the ones added when python 
# was installed. 
# Section 4 - Install Dependencies

#
# Section 1 - Get the Execution Policy:
#
# Function to get the current execution policy and set it to allow installations
function Set-ExecutionPolicyForInstallations {
    $policy = Get-ExecutionPolicy
    Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
}

#
# Section 2 - User confirmation to proceed
#
Write-Host "Dear user, this code is provided 'as is', you will be executing it at your own discretion and tech expertise, please avoid applying this code unless comfortable with its implications"

# Prompt user to confirm
$confirmation = Read-Host "This script will install dependencies on your System. Do you want to proceed? (Y/N)"

while ($confirmation -ne "Y") {
    $confirmation = Read-Host "Invalid input. Do you want to proceed? (Y/N)"
    if ($confirmation -eq "N") {
        Write-Host "Quitting the code..."
        return
    }else{
        # If the confirmation is "Y", the script will continue here
        Write-Host "Proceeding with the script..."
    }
}

#
# Section 3 - Check if the applications are already installed
#

# Check if PowerShell Get Module is installed
$isPowerShellGetModuleInstalled = if (Get-Module -Name PowerShellGet -ListAvailable) { $true } else { $false }

# What about Chocolatey? 
$isChocinstalled = Test-Path "C:\ProgramData\chocolatey\bin\choco.exe"

# Is Python V3 installed?
$isPython3Version = if (Get-Command python3) { 
    Write-Host "Python version: $(python --version)" ; $isPython3Installed = "True" }else{$false}

# And about what Python V2, maybe?
$isPython2Installed = Get-Command python -ErrorAction SilentlyContinue | Where-Object { $_.FileVersionInfo.ProductMajorPart -eq 2 } | Select-Object -First 1

# is Pip intalled?
$isPipInstalled = Test-Path -Path "$env:ProgramFiles\Python*\Scripts\pip.exe"

# And last, but not least, is Git Desktop installed? 
$isGitInstalled = Test-Path "$env:userprofile\appdata\local\GitHubDesktop\GitHubDesktop.exe"

# Report of Dependencies already installed
#if ($isPowerShellGetModuleInstalled) { Write-Host "PowerShell Get Module found" } else { Write-Host "PowerShell Get Module Missing"}

#Installation Report 
# 
Write-Host "PowerShell install Status:" $isPowerShellGetModuleInstalled
Write-Host "Chocolatey install Status:" $isChocinstalled
Write-Host "Python v3 install Status:" $isPython3Installed
Write-Host "Python v2 install Status:" $isPython2Installed
Write-Host "Pip install Status:"  $isPipInstalled
Write-Host "GitHub Desktop install Status:" $isGitInstalled

# Will walk through the vector later: 
# $vectorOfResults = @($isChocinstalled,$isPython3Installed,$isPython2Installed,$isPipInstalled,$isGitInstalled) 
# for ($i = 0; $i -lt $vectorOfResults.Length; $i++) {
#    Write-Host "${vectorOfResults[$i]}"
# }

#
# Section 4 - Install Dependencies
#

Write-Host "Dependencies install will begin now"

$confirmation = Read-Host "Do you want to proceed? (Y/N)"
while ($confirmation -ne "Y") {
    $confirmation = Read-Host "Invalid input or not accept. Do you want to proceed? (Y/N)"
    if ($confirmation -eq "N") {
        Write-Host "Quitting the code..."
        exit
    }
}


# If the confirmation is "Y", the code will continue here
Write-Host "Proceeding with the code..."

# Set the execution policy to unrestricted to install pip
Set-ExecutionPolicy Unrestricted -Scope CurrentUser -Force

# Install PowerShell Get Module
Install-Module -Name PowerShellGet -Force

# Install pip
Invoke-Expression (Invoke-WebRequest https://bootstrap.pypa.io/get-pip.py -UseBasicParsing).Content

# Install choco
choco feature enable -n allowGlobalConfirmation
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# Install Python 3
choco install python

# Install VSCode
choco install vscode

# Install GitHub Desktop
choco install github-desktop

# Function to change the execution policy back to its previous state
function Set-ExecutionPolicyToPreviousState {
    Set-ExecutionPolicy $policy -Scope CurrentUser
}
