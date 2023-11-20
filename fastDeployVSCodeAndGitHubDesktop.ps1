Write-Host "Dear user, this code is provided 'as is', you will be executing it at your own discretion and tech expertise, please avoid applying this code unless comfortable with its implications"

$confirmation = Read-Host "This script will install dependencies on your System. Do you want to proceed? (Y/N)"

if ($confirmation -ne "Y") {
    Write-Host "Quitting the code..."
    return
}else{
    Write-Host "Proceeding with the script..."

    function Set-ExecutionPolicyForInstallations {
        $policy = Get-ExecutionPolicy
        Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
    }

    $isPowerShellGetModuleInstalled = if (Get-Module -Name PowerShellGet -ListAvailable) { $true } else { $false }
    #$isChocinstalled = Test-Path "C:\ProgramData\chocolatey\bin\choco.exe"
    $isChocinstalled = (Get-Command choco).Path
    $isPython3Version = if (Get-Command python3) { 
        Write-Host "Python version: $(python --version)" ; $isPython3Installed = "True" }else{$false}
    $isPython2Installed = Get-Command python -ErrorAction SilentlyContinue | Where-Object {
        $_.FileVersionInfo.ProductMajorPart -eq 2 } | Select-Object -First 1
    $isGitInstalled = Test-Path "$env:userprofile\appdata\local\GitHubDesktop\GitHubDesktop.exe"

    Write-Host "PowerShell install Status:" $isPowerShellGetModuleInstalled
    Write-Host "Chocolatey install Status:" $isChocinstalled
    Write-Host "Python v3 install Status:" $isPython3Installed
    Write-Host "Python v2 install Status:" $isPython2Installed
    Write-Host "Pip install Status:"  $isPipInstalled
    Write-Host "GitHub Desktop install Status:" $isGitInstalled

    Write-Host "Dependencies install will begin now"

    Set-ExecutionPolicy Unrestricted -Scope CurrentUser -Force

    Install-Module -Name PowerShellGet -Force

    choco feature enable -n allowGlobalConfirmation
    Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

    choco install python

    choco install vscode

    choco install github-desktop

    function Set-ExecutionPolicyToPreviousState {
        Set-ExecutionPolicy $policy -Scope CurrentUser
    }
}