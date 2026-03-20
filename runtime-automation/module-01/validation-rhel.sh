#!/bin/sh
echo "Validating module-01" >> /tmp/progress.log

# Check if MariaDB is running
if systemctl is-active --quiet mariadb; then
    echo "PASS: MariaDB is running" >> /tmp/progress.log
    echo "PASS: MariaDB is running"
    exit 0
else
    echo "FAIL: MariaDB is not running" >> /tmp/progress.log
    echo "FAIL: MariaDB is not running"
    exit 1
fi
