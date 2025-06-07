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

function GenerateInventoryReport {
    Clear-Host
    Write-Host "=== Inventory Report ===" -ForegroundColor Yellow

    $reportFolder = "$PSScriptRoot\..\reports"
    if (-not (Test-Path $reportFolder)) {
        New-Item -ItemType Directory -Path $reportFolder | Out-Null
    }

    $timestamp = Get-Date -Format 'yyyyMMdd_HHmmss'
    $outputPath = "$reportFolder\inventory_$timestamp.txt"
    $lines = @()

    Try {
        # ── System Info ──
        $lines += "=== System Information ==="
        $lines += "Computer Name: $env:COMPUTERNAME"
        $lines += "Logged In User: $env:USERNAME"

        $os = Get-CimInstance Win32_OperatingSystem
        $lines += "OS Version: $($os.Caption)"
        $lines += "Architecture: $($os.OSArchitecture)"
        $lines += "Last Boot: $($os.LastBootUpTime)"
        $lines += "OS Install Date: $($os.InstallDate)"
        $lines += ""

        # ── Hardware Info ──
        $lines += "=== Hardware Information ==="
        $cpu = Get-CimInstance Win32_Processor | Select-Object -First 1
        $gpu = Get-CimInstance Win32_VideoController | Select-Object -First 1
        $bios = Get-CimInstance Win32_BIOS
        $ramGB = [math]::Round($os.TotalVisibleMemorySize / 1MB, 2)

        $lines += "CPU: $($cpu.Name)"
        $lines += "GPU: $($gpu.Name)"
        $lines += "RAM (GB): $ramGB"
        $lines += "Serial Number: $($bios.SerialNumber)"
        $lines += ""

        # ── Drives ──
        $lines += "=== Logical Drive Information ==="

        $logicalDisks = Get-CimInstance Win32_LogicalDisk
        $physicalDisks = Get-CimInstance Win32_DiskDrive

        foreach ($disk in $logicalDisks) {
            $type = switch ($disk.DriveType) {
                1 { "No Root Directory" }
                2 { "Removable" }
                3 { "Fixed" }
                4 { "Network" }
                5 { "CD-ROM" }
                6 { "RAM Disk" }
                Default { "Unknown" }
            }

            $totalGB = [math]::Round($disk.Size / 1GB, 1)
            $freePercent = if ($disk.Size -gt 0) { [math]::Round(($disk.FreeSpace / $disk.Size) * 100, 1) } else { "N/A" }

            $lines += "$($disk.DeviceID): $totalGB GB total, $freePercent% free, Type: $type"
        }

        $lines += ""
        $lines += "=== Physical Disk Information ==="

        foreach ($pd in $physicalDisks) {
            $lines += "$($pd.DeviceID): Model: $($pd.Model), MediaType: $($pd.MediaType), Interface: $($pd.InterfaceType)"
        }

        $lines += ""
        $lines += ""

        # ── Network Interfaces (All) ──
        $lines += "=== Network Interfaces ==="
        $adapters = Get-NetAdapter | Sort-Object Name

        foreach ($adapter in $adapters) {
            $alias = $adapter.Name
            $lines += "`n--- $alias ($($adapter.InterfaceDescription)) ---"
            $lines += "Status: $($adapter.Status)"
            $lines += "MAC Address: $($adapter.MacAddress)"

            $ip = Get-NetIPAddress -InterfaceAlias $alias -AddressFamily IPv4 -ErrorAction SilentlyContinue | Where-Object { $_.IPAddress -notlike '169.*' }
            if ($ip) {
                $lines += "IP Address: $($ip.IPAddress)"
            }

            $gateway = Get-NetRoute -InterfaceAlias $alias -DestinationPrefix '0.0.0.0/0' -ErrorAction SilentlyContinue | Select-Object -ExpandProperty NextHop -Unique
            if ($gateway) {
                $lines += "Default Gateway: $gateway"
            }

            $dns = Get-DnsClientServerAddress -InterfaceAlias $alias -AddressFamily IPv4 -ErrorAction SilentlyContinue | ForEach-Object { $_.ServerAddresses } | Where-Object { $_ }
            if ($dns) {
                $lines += "DNS Servers: $($dns -join ', ')"
            }

            $dhcp = Get-NetIPInterface -InterfaceAlias $alias -ErrorAction SilentlyContinue | Select-Object -First 1
            if ($dhcp) {
                $lines += "DHCP Enabled: $($dhcp.Dhcp)"
            }
        }

        # ── Network Profiles ──
        $lines += "`n=== Network Profiles ==="
        $profiles = Get-NetConnectionProfile
        foreach ($profile in $profiles) {
            $lines += "$($profile.Name) - $($profile.NetworkCategory)"
        }

        # Write to file
        $lines | Out-File -FilePath $outputPath -Encoding UTF8

        Write-Host "Inventory report saved to:`n$outputPath" -ForegroundColor Green
        Write-LogEntry "Generated inventory report to ${outputPath}"
    } Catch {
        Write-Host "Error creating inventory report: $($_.Exception.Message)" -ForegroundColor Red
        Write-LogEntry "Failed to generate inventory report: $($_.Exception.Message)"
    }

    Pause
}
