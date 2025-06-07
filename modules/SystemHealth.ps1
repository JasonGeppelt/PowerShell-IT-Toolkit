function CheckSystemHealth {
    Clear-Host
    Write-Host "=== System Health Check ===" -ForegroundColor Yellow

    Show-DiskUsage
    Show-MemoryUsage
    Show-CPUUsage
    Show-Uptime

    Pause
}

function Show-DiskUsage {
    Write-Host "`n--- Disk Usage ---" -ForegroundColor Cyan
    Get-PSDrive -PSProvider 'FileSystem' | ForEach-Object {
        $used = ($_.Used / 1GB).ToString("0.00")
        $free = ($_.Free / 1GB).ToString("0.00")
        $total = ($_.Used + $_.Free) / 1GB
        $percentFree = ($_.Free / $total) * 100
        Write-Host "$($_.Name): Used ${used}GB, Free ${free}GB (${percentFree.ToString("0.0")}%)"
    }
    Write-LogEntry "Checked disk usage"
}

function Show-MemoryUsage {
    Write-Host "`n--- Memory Usage ---" -ForegroundColor Cyan
    $os = Get-CimInstance Win32_OperatingSystem
    $total = [math]::Round($os.TotalVisibleMemorySize / 1MB, 2)
    $free = [math]::Round($os.FreePhysicalMemory / 1MB, 2)
    $used = [math]::Round($total - $free, 2)
    Write-Host "Total: ${total}GB | Used: ${used}GB | Free: ${free}GB"
    Write-LogEntry "Checked memory usage"
}

function Show-CPUUsage {
    Write-Host "`n--- CPU Usage ---" -ForegroundColor Cyan
    $cpu = Get-Counter '\Processor(_Total)\% Processor Time'
    $usage = [math]::Round($cpu.CounterSamples.CookedValue, 2)
    Write-Host "Current CPU Usage: ${usage}%"
    Write-LogEntry "Checked CPU usage"
}

function Show-Uptime {
    Write-Host "`n--- System Uptime ---" -ForegroundColor Cyan
    $lastBoot = (Get-CimInstance Win32_OperatingSystem).LastBootUpTime
    $uptime = (Get-Date) - $lastBoot
    $days = [math]::Floor($uptime.TotalDays)
    $hours = $uptime.Hours
    $minutes = $uptime.Minutes
    Write-Host "Last Boot: $lastBoot"
    Write-Host "Uptime: ${days}d ${hours}h ${minutes}m"
    Write-LogEntry "Checked system uptime"
}
