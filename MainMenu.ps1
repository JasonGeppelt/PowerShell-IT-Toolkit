# MainMenu.ps1
Clear-Host
Write-Host "=== IT Automation Toolkit ===" -ForegroundColor Cyan

# Load modules (dot-sourcing)
. "$PSScriptRoot\modules\UserManagement.ps1"
. "$PSScriptRoot\modules\SystemHealth.ps1"
. "$PSScriptRoot\modules\SoftwareManager.ps1"
. "$PSScriptRoot\modules\BackupManager.ps1"
. "$PSScriptRoot\modules\RemoteOps.ps1"
. "$PSScriptRoot\modules\Inventory.ps1"
. "$PSScriptRoot\modules\Logger.ps1"

function Show-Menu {
    Write-Host ""
    Write-Host "1. Manage User Accounts"
    Write-Host "2. Check System Health"
    Write-Host "3. Software Management"
    Write-Host "4. Run Backups"
    Write-Host "5. Remote Operations"
    Write-Host "6. Generate Inventory Report"
    Write-Host "7. Exit"
    Write-Host ""
}

do {
    Show-Menu
    $choice = Read-Host "Enter your choice (1-7)"
    switch ($choice) {
        "1" { ManageUsers }
        "2" { CheckSystemHealth }
        "3" { ManageSoftware }
        "4" { RunBackups }
        "5" { RunRemoteOps }
        "6" { GenerateInventoryReport }
        "7" { Write-Host "Exiting..."; break }
        default { Write-Host "Invalid selection. Please try again." -ForegroundColor Red }
    }
} while ($true)
