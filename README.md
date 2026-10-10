# Lab2_Antivirusn
# Simple Antivirus Daemon

A Bash script that monitors a folder, detects suspicious files, and moves them to quarantine.

## Files
- `antivirusd.sh`: Monitors files.
- `restore.sh`: Restores or deletes quarantined files.
- `antivirus-cron.sh`: Performs a single scan using cron.
- `Makefile`: Runs the scripts.

## Requirements
Install Make if needed:
```bash
sudo apt install make
```

## How to Run
1. Create the monitored folder:
   ```bash
   mkdir -p dir
   ```
2. Start the daemon:
   ```bash
   make run
   ```
   Press `Ctrl+C` to stop.
3. Review quarantined files:
   ```bash
   make restore
   ```
   - `1`: Restore
   - `2`: Delete permanently
   - `3`: Leave in quarantine

Change the folders or interval:
```bash
make run DIR=mydir MALICIOUS_DIR=quarantine INTERVAL=10
```

## Detection Rules
**Extensions:** `exe`, `bat`, `vbs`, `scr`, `ps1`

**Keywords:** `virus`, `trojan`, `malware`, `worm`, `ransomware`

## Bonus 1: Cron
Make the script executable:
```bash
chmod +x antivirus-cron.sh
crontab -e
```

Add this line, replacing the paths:
```bash
* * * * * sleep 23; /path/to/project/antivirus-cron.sh /path/to/project/dir /path/to/project/malicious_dir
```

## Bonus 2: Whitelist
Restored files are added to `whitelist.txt` and skipped in future scans. Remove a filename from this file to remove it from the whitelist.
