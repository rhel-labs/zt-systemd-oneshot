#!/bin/sh
echo "Validating module-02" >> /tmp/progress.log

# Check if backup script exists and is executable
if [ ! -x /usr/local/bin/backup-database.sh ]; then
    echo "FAIL: Backup script not found or not executable" >> /tmp/progress.log
    echo "FAIL: Backup script not found or not executable"
    echo "HINT: Create /usr/local/bin/backup-database.sh and make it executable"
    exit 1
fi

# Check if service file exists
if [ ! -f /etc/systemd/system/db-backup.service ]; then
    echo "FAIL: Service file not found" >> /tmp/progress.log
    echo "FAIL: Service file not found"
    echo "HINT: Create /etc/systemd/system/db-backup.service"
    exit 1
fi

# Check if service uses Type=oneshot
if ! grep -q "Type=oneshot" /etc/systemd/system/db-backup.service; then
    echo "FAIL: Service does not use Type=oneshot" >> /tmp/progress.log
    echo "FAIL: Service does not use Type=oneshot"
    echo "HINT: Add 'Type=oneshot' to the [Service] section"
    exit 1
fi

# Check if at least one backup exists
if [ ! -d /var/backups/mariadb ] || [ -z "$(ls -A /var/backups/mariadb/backup_*.sql 2>/dev/null)" ]; then
    echo "FAIL: No backup files found" >> /tmp/progress.log
    echo "FAIL: No backup files found"
    echo "HINT: Run the backup service with: systemctl start db-backup.service"
    exit 1
fi

echo "PASS: Backup service configured correctly" >> /tmp/progress.log
echo "PASS: Backup service configured correctly"
exit 0
