#!/bin/sh
echo "Validating module-04" >> /tmp/progress.log

# Check if timer file exists
if [ ! -f /etc/systemd/system/db-backup.timer ]; then
    echo "FAIL: Timer file not found" >> /tmp/progress.log
    echo "FAIL: Timer file not found"
    echo "HINT: Create /etc/systemd/system/db-backup.timer"
    exit 1
fi

# Check if timer has OnCalendar directive
if ! grep -q "OnCalendar=" /etc/systemd/system/db-backup.timer; then
    echo "FAIL: Timer does not have OnCalendar directive" >> /tmp/progress.log
    echo "FAIL: Timer does not have OnCalendar directive"
    echo "HINT: Add 'OnCalendar=daily' to the [Timer] section"
    exit 1
fi

# Check if timer is enabled
if ! systemctl is-enabled --quiet db-backup.timer; then
    echo "FAIL: Timer is not enabled" >> /tmp/progress.log
    echo "FAIL: Timer is not enabled"
    echo "HINT: Enable the timer with: systemctl enable db-backup.timer"
    exit 1
fi

# Check if timer is active
if ! systemctl is-active --quiet db-backup.timer; then
    echo "FAIL: Timer is not active" >> /tmp/progress.log
    echo "FAIL: Timer is not active"
    echo "HINT: Start the timer with: systemctl start db-backup.timer"
    exit 1
fi

echo "PASS: Timer configured and active" >> /tmp/progress.log
echo "PASS: Timer configured and active"
exit 0
