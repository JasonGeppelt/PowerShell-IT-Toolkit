function ManageUsers {
    Clear-Host
    Write-Host "=== User Management ===" -ForegroundColor Yellow
    Write-Host "1. Create User"
    Write-Host "2. Disable User"
    Write-Host "3. Reset Password"
    Write-Host "4. Back to Main Menu"

    $input = Read-Host "Choose an option (1-4)"
    switch ($input) {
        "1" { Create-LocalUser }
        "2" { Disable-LocalUser }
        "3" { Reset-UserPassword }
        "4" { return }
        default { Write-Host "Invalid choice. Press Enter to try again."; Read-Host; ManageUsers }
    }
}

function Create-LocalUser {
    $username = Read-Host "Enter new username"
    $password = Read-Host "Enter password for $username" -AsSecureString

    Try {
        New-LocalUser -Name $username -Password $password -FullName $username -Description "Created by IT Toolkit"
        Add-LocalGroupMember -Group "Users" -Member $username
        Write-Host "User '$username' created successfully." -ForegroundColor Green
        Log-Action "Created user $username"
    } Catch {
        Write-Host "Error creating user: $($_.Exception.Message)" -ForegroundColor Red
        Log-Action "Failed to create user ${username}: $($_.Exception.Message)"
    }

    Pause
    ManageUsers
}

function Disable-LocalUser {
    $username = Read-Host "Enter username to disable"

    Try {
        Disable-LocalUser -Name $username
        Write-Host "User '$username' has been disabled." -ForegroundColor Green
        Log-Action "Disabled user $username"
    } Catch {
        Write-Host "Error disabling user: $($_.Exception.Message)" -ForegroundColor Red
        Log-Action "Failed to disable user ${username}: $($_.Exception.Message)"
    }

    Pause
    ManageUsers
}

function Reset-UserPassword {
    $username = Read-Host "Enter username to reset password"
    $password = Read-Host "Enter new password for $username" -AsSecureString

    Try {
        Set-LocalUser -Name $username -Password $password
        Write-Host "Password for '$username' has been reset." -ForegroundColor Green
        Log-Action "Reset password for $username"
    } Catch {
        Write-Host "Error resetting password: $($_.Exception.Message)" -ForegroundColor Red
        Log-Action "Failed to reset password for ${username}: $($_.Exception.Message)"
    }

    Pause
    ManageUsers
}
