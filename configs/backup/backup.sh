#!/bin/bash

# You will use this file with cron
# crontab -e
# 0 13 * * 3 bash /home/USERNAME/backup_logs/backup.sh
# This will run backup.sh at 01:00 PM, only on Wednesday

# Path to log file
LOG_FILE="/home/USERNAME/backup_logs/snapraid_restic_$(date +%Y-%m-%d).log"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# SNAPRAID
log "Starting snapraid sync..."
if snapraid sync >> "$LOG_FILE" 2>&1; then
    log "snapraid sync was successful"
else
    log "snapraid sync exit with error"
    exit 1
fi

# RESTIC
export AWS_ACCESS_KEY_ID=
export AWS_SECRET_ACCESS_KEY=
export RESTIC_REPOSITORY=
export RESTIC_PASSWORD=

log "Starting restic backup gitea..."
if  restic backup --tag homelab-gitea /data/share/gitea/gitea/git >> "$LOG_FILE" 2>&1; then
    log "restic backup /data/share/gitea/gitea/git was successful."
else
    log "restic backup /data/share/gitea/gitea/git exit with error."
    exit 1
fi

log "Starting restic backup photos..."
if  restic backup --tag homelab-photos /data/photos >> "$LOG_FILE" 2>&1; then
    log "restic backup /data/photos was successful."
else
    log "restic backup /data/photos exit with error."
    exit 1
fi

log "All operations were successful."
exit 0
