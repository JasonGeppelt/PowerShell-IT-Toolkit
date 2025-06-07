function ManageSoftware {
    Clear-Host
    Write-Host "=== Software Management ===" -ForegroundColor Yellow
    Write-Host "1. Install Software (via Winget)"
    Write-Host "2. Uninstall Software (via Winget)"
    Write-Host "3. Update All Installed Software (via Winget)"
    Write-Host "4. Back to Main Menu"

    $choice = Read-Host "Choose an option (1-4)"
    switch ($choice) {
        "1" { Install-Software }
        "2" { Uninstall-Software }
        "3" { Update-AllSoftware }
        "4" { return }
        default { Write-Host "Invalid selection. Press Enter to try again."; Read-Host; ManageSoftware }
    }
}

function Install-Software {
    $package = Read-Host "Enter the name of the software to install (e.g., vscode, firefox, 7zip)"

    Try {
        winget install --id "$package" --silent --accept-package-agreements --accept-source-agreements
        Write-Host "Installed $package successfully." -ForegroundColor Green
        Write-LogEntry "Installed software ${package}"
    } Catch {
        Write-Host "Error installing ${package}: $($_.Exception.Message)" -ForegroundColor Red
        Write-LogEntry "Failed to install ${package}: $($_.Exception.Message)"
    }

    Pause
    ManageSoftware
}

function Uninstall-Software {
    $package = Read-Host "Enter the name of the software to uninstall"

    Try {
        winget uninstall --name "$package"
        Write-Host "Uninstalled $package successfully." -ForegroundColor Green
        Write-LogEntry "Uninstalled software ${package}"
    } Catch {
        Write-Host "Error uninstalling ${package}: $($_.Exception.Message)" -ForegroundColor Red
        Write-LogEntry "Failed to uninstall ${package}: $($_.Exception.Message)"
    }

    Pause
    ManageSoftware
}

function Update-AllSoftware {
    Try {
        winget upgrade --all --silent --accept-package-agreements --accept-source-agreements
        Write-Host "All eligible software has been updated." -ForegroundColor Green
        Write-LogEntry "Updated all software via Winget"
    } Catch {
        Write-Host "Error updating software: $($_.Exception.Message)" -ForegroundColor Red
        Write-LogEntry "Failed to update software: $($_.Exception.Message)"
    }

    Pause
    ManageSoftware
}
