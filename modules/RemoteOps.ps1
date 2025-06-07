function RunRemoteOps {
    Clear-Host
    Write-Host "=== Remote Operations ===" -ForegroundColor Yellow
    Write-Host "1. Reboot Remote Machine"
    Write-Host "2. Get Remote System Info"
    Write-Host "3. Back to Main Menu"

    $choice = Read-Host "Choose an option (1-3)"
    switch ($choice) {
        "1" { Reboot-RemoteMachine }
        "2" { Get-RemoteSystemInfo }
        "3" { return }
        default { Write-Host "Invalid selection. Press Enter to try again."; Read-Host; RunRemoteOps }
    }
}

function Reboot-RemoteMachine {
    $remote = Read-Host "Enter the name or IP of the remote machine"

    Try {
        Invoke-Command -ComputerName $remote -ScriptBlock { Restart-Computer -Force } -ErrorAction Stop
        Write-Host "Reboot command sent to '$remote'." -ForegroundColor Green
        Log-Action "Sent reboot command to ${remote}"
    } Catch {
        Write-Host "Failed to reboot ${remote}: $($_.Exception.Message)" -ForegroundColor Red
        Log-Action "Failed to reboot ${remote}: $($_.Exception.Message)"
    }

    Pause
    RunRemoteOps
}

function Get-RemoteSystemInfo {
    $remote = Read-Host "Enter the name or IP of the remote machine"

    Try {
        $info = Invoke-Command -ComputerName $remote -ScriptBlock {
            @{
                ComputerName = $env:COMPUTERNAME
                OS = (Get-CimInstance Win32_OperatingSystem).Caption
                LastBoot = (Get-CimInstance Win32_OperatingSystem).LastBootUpTime
            }
        } -ErrorAction Stop

        Write-Host "`n--- Remote System Info ---" -ForegroundColor Cyan
        Write-Host "Computer Name: $($info.ComputerName)"
        Write-Host "OS: $($info.OS)"
        Write-Host "Last Boot: $($info.LastBoot)"
        Log-Action "Retrieved system info from ${remote}"
    } Catch {
        Write-Host "Failed to get info from ${remote}: $($_.Exception.Message)" -ForegroundColor Red
        Log-Action "Failed to get system info from ${remote}: $($_.Exception.Message)"
    }

    Pause
    RunRemoteOps
}
