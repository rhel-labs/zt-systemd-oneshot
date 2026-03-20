#!/bin/sh
echo "Module-02 solve starting" >> /tmp/progress.log

# Create backup directory
mkdir -p /var/backups/mariadb >> /tmp/progress.log 2>&1

# Create backup script
cat > /usr/local/bin/backup-database.sh << 'EOF'
#!/bin/bash

# Database backup script
BACKUP_DIR="/var/backups/mariadb"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="${BACKUP_DIR}/backup_${TIMESTAMP}.sql"

echo "Starting database backup at $(date)"

# Perform the backup
mysqldump --all-databases > "${BACKUP_FILE}"

if [ $? -eq 0 ]; then
    echo "Backup successful: ${BACKUP_FILE}"

    # Keep only the 5 most recent backups
    cd "${BACKUP_DIR}"
    ls -t backup_*.sql | tail -n +6 | xargs -r rm

    echo "Cleanup complete. Current backups:"
    ls -lh backup_*.sql 2>/dev/null || echo "No backups found"
else
    echo "Backup failed!"
    exit 1
fi

echo "Backup completed at $(date)"
EOF

chmod +x /usr/local/bin/backup-database.sh >> /tmp/progress.log 2>&1

# Test the script
/usr/local/bin/backup-database.sh >> /tmp/progress.log 2>&1

# Create systemd service
cat > /etc/systemd/system/db-backup.service << 'EOF'
[Unit]
Description=Database Backup Service
Documentation=man:mysqldump(1)

[Service]
Type=oneshot
ExecStart=/usr/local/bin/backup-database.sh
User=root
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload >> /tmp/progress.log 2>&1
systemctl start db-backup.service >> /tmp/progress.log 2>&1

echo "Module-02 solved" >> /tmp/progress.log
