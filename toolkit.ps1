# =============================
# IT Automation Toolkit - Toolkit.ps1
# =============================

# Logging Function
function Write-Log {
    param (
        [string]$Message,
        [string]$LogPath = "$PSScriptRoot\Toolkit.log"
    )
    $Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    "$Timestamp - $Message" | Out-File -FilePath $LogPath -Append
}

# User Account Management Functions
function Create-LocalUser {
    param (
        [string]$Username,
        [string]$Password
    )
    try {
        $SecurePass = ConvertTo-SecureString $Password -AsPlainText -Force
        New-LocalUser -Name $Username -Password $SecurePass -FullName $Username -Description "Toolkit Created User"
        Add-LocalGroupMember -Group "Users" -Member $Username
        Write-Host "User '$Username' created." -ForegroundColor Green
        Write-Log "User '$Username' created successfully."
    } catch {
        Write-Host "Failed to create user: $_" -ForegroundColor Red
        Write-Log "Error creating user '$Username': $_"
    }
}

function Disable-LocalUserAccount {
    param ([string]$Username)
    try {
        Disable-LocalUser -Name $Username
        Write-Host "User '$Username' disabled." -ForegroundColor Yellow
        Write-Log "User '$Username' disabled."
    } catch {
        Write-Host "Failed to disable user: $_" -ForegroundColor Red
        Write-Log "Error disabling user '$Username': $_"
    }
}

function Reset-UserPassword {
    param (
        [string]$Username,
        [string]$NewPassword
    )
    try {
        $SecurePass = ConvertTo-SecureString $NewPassword -AsPlainText -Force
        Set-LocalUser -Name $Username -Password $SecurePass
        Write-Host "Password reset for '$Username'." -ForegroundColor Green
        Write-Log "Password reset for '$Username'."
    } catch {
        Write-Host "Failed to reset password: $_" -ForegroundColor Red
        Write-Log "Error resetting password for '$Username': $_"
    }
}

function Manage-Users {
    Clear-Host
    Write-Host "=== User Account Management ===" -ForegroundColor Cyan
    Write-Host "1. Create User"
    Write-Host "2. Disable User"
    Write-Host "3. Reset User Password"
    Write-Host "4. Back to Main Menu"
    $choice = Read-Host "Choose an option (1-4)"
    switch ($choice) {
        '1' {
            $username = Read-Host "Enter username"
            $password = Read-Host "Enter password"
            Create-LocalUser -Username $username -Password $password
        }
        '2' {
            $username = Read-Host "Enter username to disable"
            Disable-LocalUserAccount -Username $username
        }
        '3' {
            $username = Read-Host "Enter username"
            $password = Read-Host "Enter new password"
            Reset-UserPassword -Username $username -NewPassword $password
        }
        default { return }
    }
    Pause
}

# Placeholder Functions
function Install-Software { Write-Host "Software module coming soon..." }
function Check-SystemHealth { Write-Host "System health module coming soon..." }
function Get-RemoteInfo { Write-Host "Remote system info module coming soon..." }

# Menu
function Show-Menu {
    Clear-Host
    Write-Host "=== IT Automation Toolkit ===" -ForegroundColor Cyan
    Write-Host "1. Manage User Accounts"
    Write-Host "2. Install Software"
    Write-Host "3. System Health Check"
    Write-Host "4. Remote System Info"
    Write-Host "5. Exit"
}

function Main {
    do {
        Show-Menu
        $choice = Read-Host "Select an option (1-5)"
        switch ($choice) {
            '1' { Manage-Users }
            '2' { Install-Software; Pause }
            '3' { Check-SystemHealth; Pause }
            '4' { Get-RemoteInfo; Pause }
            '5' { Write-Host "Exiting toolkit..." }
            default {
                Write-Host "Invalid choice. Please select 1-5." -ForegroundColor Red
                Pause
            }
        }
    } while ($choice -ne '5')
}

# Run the main menu
Main
