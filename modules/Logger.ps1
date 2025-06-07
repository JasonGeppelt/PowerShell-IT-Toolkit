function Write-LogEntry {
    param (
        [string]$Message
    )

    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logEntry = "$timestamp - $Message"

    $logPath = "$PSScriptRoot\..\logs\actions.log"
    if (-not (Test-Path $logPath)) {
        New-Item -ItemType File -Path $logPath -Force | Out-Null
    }

    Add-Content -Path $logPath -Value $logEntry
}
