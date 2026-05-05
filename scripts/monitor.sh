#!/bin/bash

LOG_FILE="/app/logs/system.log"
JSON_FILE="/app/logs/system_metrics.json"

CPU=$(top -bn1 | grep -i "cpu(s)" | awk '{print 100 - $8}')
RAM=$(free | grep -i "Mem" | awk '{print (($2-$7)/$2 *100)}')
DISK=$(df -h | awk 'NR==3 {print $5}' | sed 's/%//')

echo "$(date) CPU=$CPU RAM=$RAM DISK=$DISK" >> $LOG_FILE

cat <<EOF > $JSON_FILE
{
  "cpu": $CPU,
  "ram": $RAM,
  "disk": $DISK
}
EOF
