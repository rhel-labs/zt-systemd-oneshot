#!/bin/sh
echo "Validating module-03" >> /tmp/progress.log

# Check if service has Requires directive
if ! grep -q "Requires=mariadb.service" /etc/systemd/system/db-backup.service; then
    echo "FAIL: Service does not require mariadb.service" >> /tmp/progress.log
    echo "FAIL: Service does not require mariadb.service"
    echo "HINT: Add 'Requires=mariadb.service' to the [Unit] section"
    exit 1
fi

# Check if service has After directive
if ! grep -q "After=mariadb.service" /etc/systemd/system/db-backup.service; then
    echo "FAIL: Service does not have After=mariadb.service" >> /tmp/progress.log
    echo "FAIL: Service does not have After=mariadb.service"
    echo "HINT: Add 'After=mariadb.service' to the [Unit] section"
    exit 1
fi

# Ensure MariaDB is running for the test
systemctl start mariadb >> /tmp/progress.log 2>&1

echo "PASS: Service dependencies configured correctly" >> /tmp/progress.log
echo "PASS: Service dependencies configured correctly"
exit 0
