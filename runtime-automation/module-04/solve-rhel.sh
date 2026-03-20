#!/bin/sh
echo "Module-04 solve starting" >> /tmp/progress.log

# Create the timer
cat > /etc/systemd/system/db-backup.timer << 'EOF'
[Unit]
Description=Daily Database Backup Timer
Documentation=man:systemd.timer(5)

[Timer]
OnCalendar=daily
Persistent=true
RandomizedDelaySec=1h

[Install]
WantedBy=timers.target
EOF

# Create test timer
cat > /etc/systemd/system/db-backup-test.timer << 'EOF'
[Unit]
Description=Test Database Backup Timer
Documentation=man:systemd.timer(5)

[Timer]
OnBootSec=30sec
OnUnitActiveSec=2min

[Install]
WantedBy=timers.target
EOF

# Create test service (symlink)
ln -sf /etc/systemd/system/db-backup.service /etc/systemd/system/db-backup-test.service

systemctl daemon-reload >> /tmp/progress.log 2>&1
systemctl enable --now db-backup.timer >> /tmp/progress.log 2>&1
systemctl enable --now db-backup-test.timer >> /tmp/progress.log 2>&1

# Wait for test timer to fire
sleep 35

systemctl list-timers >> /tmp/progress.log 2>&1

echo "Module-04 solved" >> /tmp/progress.log
