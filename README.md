# IT Automation Toolkit (PowerShell)

## Overview

This PowerShell-based toolkit helps automate common IT tasks on Windows systems. It includes a menu that allows technicians to manage users, monitor system health, install software, perform backups, run remote actions, and generate system inventory reports. Each feature is organized into its own script module for easier maintenance and expansion.

---

## Features

- **User Management**  
  Create, disable, or reset local user accounts.

- **Software Management**  
  Install, uninstall, or update software using Winget.

- **System Health Checks**  
  View current disk usage, memory usage, CPU load, and system uptime.

- **Backup Tool**  
  Copy all files from a selected folder to another location.

- **Remote Operations**  
  Reboot or collect system information from remote machines using PowerShell Remoting.

- **System Inventory Report**  
  Export a full report with hardware details, disk stats, and complete network information, including inactive adapters.

- **Logging**  
  All actions are saved with timestamps in the `logs/actions.log` file.

---

## Requirements

- Windows 10 or 11
- PowerShell 7 or later
- Administrator access for some features (user management and remote commands)
- Winget must be installed for software functions

---

## How to Use

1. Download or extract the toolkit folder.
2. Open PowerShell as Administrator.
3. Run the script `MainMenu.ps1`.
4. Use the menu to access each feature.

---

## Folder Structure

```
IT-Automation-Toolkit/
├── MainMenu.ps1
├── modules/
│   ├── UserManagement.ps1
│   ├── SystemHealth.ps1
│   ├── SoftwareManager.ps1
│   ├── BackupManager.ps1
│   ├── RemoteOps.ps1
│   ├── Inventory.ps1
│   └── Logger.ps1
├── logs/
│   └── actions.log
├── reports/
│   └── inventory_YYYYMMDD_HHMMSS.txt
```

---

## Example Log Entry

```
2025-06-07 15:42:01 - Reset password for user "admin"
```

---

## Notes

- Reports are saved in the `reports/` folder with timestamps in the filename.
- The backup tool performs a full recursive copy without filters.
- Remote actions require remoting to be enabled on the target machine.
- The script handles missing data and offline adapters without crashing.

---

## Author

Jason Geppelt  
CSE 499 Senior Project  
Brigham Young University - Idaho
