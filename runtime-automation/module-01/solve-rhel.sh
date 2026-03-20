#!/bin/sh
echo "Module-01 commands:" >> /tmp/progress.log
systemctl status mariadb >> /tmp/progress.log 2>&1
echo "Module-01 solved" >> /tmp/progress.log
