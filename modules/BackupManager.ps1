function RunBackups {
    Clear-Host
    Write-Host "=== Backup Manager ===" -ForegroundColor Yellow

    $source = Read-Host "Enter the full path of the folder to back up (e.g., C:\Users\Jason\Documents)"
    $destination = Read-Host "Enter the full path of the backup destination (e.g., D:\Backups\Documents)"

    if (-not (Test-Path $source)) {
        Write-Host "Source folder does not exist." -ForegroundColor Red
        Log-Action "Backup failed: source path '${source}' does not exist"
        Pause
        return
    }

    Try {
        Copy-Item -Path $source -Destination $destination -Recurse -Force
        Write-Host "Backup completed successfully." -ForegroundColor Green
        Log-Action "Backup completed: ${source} -> ${destination}"
    } Catch {
        Write-Host "Error during backup: $($_.Exception.Message)" -ForegroundColor Red
        Log-Action "Backup failed from ${source} to ${destination}: $($_.Exception.Message)"
    }

    Pause
}
