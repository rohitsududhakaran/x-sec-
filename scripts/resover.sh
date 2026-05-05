#!/bin/bash

base_dir=/app
LOG="/app/logs/system.log"
alert_script="$base_dir/scripts/alert.py"

# Apache
if ! systemctl is-active --quiet apache2; then
    APCONF_TEST=$(apache2ctl configtest 2>&1)

    if echo "$APCONF_TEST" | grep -q "Syntax OK"; then
        systemctl restart apache2
        echo "$(date) Apache restarted" >> $LOG
        python3 $alert_script "✅ Apache restarted"
    else
        python3 $alert_script "❌ Apache config error:\n$APCONF_TEST"
    fi
fi

# MySQL
if ! systemctl is-active --quiet mysql; then
    MYSQL_TEST=$(mysqld --validate-config 2>&1)

    if [ $? -eq 0 ]; then
        systemctl restart mysql
        echo "$(date) MySQL restarted" >> $LOG
        python3 $alert_script "✅ MySQL restarted"
    else
        python3 $alert_script "❌ MySQL config error:\n$MYSQL_TEST"
    fi
fi

# Disk
DISK=$(df -h | awk 'NR==3 {print $5}' | sed 's/%//')

if [ "$DISK" -gt 85 ]; then
    python3 $alert_script "⚠️ Disk critical: $DISK%"
fi
