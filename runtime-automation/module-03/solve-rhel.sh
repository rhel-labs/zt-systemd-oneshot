#!/bin/sh
echo "Module-03 solve starting" >> /tmp/progress.log

# Update service with dependencies
cat > /etc/systemd/system/db-backup.service << 'EOF'
[Unit]
Description=Database Backup Service
Documentation=man:mysqldump(1)
Requires=mariadb.service
After=mariadb.service

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

# Test dependencies by stopping and starting
systemctl stop mariadb >> /tmp/progress.log 2>&1
systemctl start db-backup.service >> /tmp/progress.log 2>&1
systemctl status mariadb >> /tmp/progress.log 2>&1

echo "Module-03 solved" >> /tmp/progress.log
