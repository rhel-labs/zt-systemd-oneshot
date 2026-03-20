#!/bin/bash
USER=rhel

echo "Adding wheel" > /root/post-run.log
usermod -aG wheel rhel

echo "Setup vm rhel" > /tmp/progress.log

chmod 666 /tmp/progress.log

# Start and enable MariaDB
systemctl enable --now mariadb >> /tmp/progress.log 2>&1

# Create a test database with some data
mysql -e "CREATE DATABASE IF NOT EXISTS testdb;" >> /tmp/progress.log 2>&1
mysql -e "USE testdb; CREATE TABLE IF NOT EXISTS employees (id INT AUTO_INCREMENT PRIMARY KEY, name VARCHAR(100), department VARCHAR(100));" >> /tmp/progress.log 2>&1
mysql -e "USE testdb; INSERT INTO employees (name, department) VALUES ('Alice', 'Engineering'), ('Bob', 'Sales'), ('Carol', 'Marketing');" >> /tmp/progress.log 2>&1

# Create backup directory
mkdir -p /var/backups/mariadb >> /tmp/progress.log 2>&1

echo "Lab setup complete" >> /tmp/progress.log
