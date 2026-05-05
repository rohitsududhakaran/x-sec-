#!/bin/bash

while true; do

echo "[*] Monitoring..."
bash /app/scripts/monitor.sh

echo "[*] Collecting data..."
SYSTEM_DATA=$(cat /app/logs/system_metrics.json)
LOG_DATA=$(python3 /app/scripts/log_analyser.py)

COMBINED=$(jq -n \
  --argjson sys "$SYSTEM_DATA" \
  --argjson log "$LOG_DATA" \
  '{system:$sys, logs:$log}')

echo "[*] AI analysis..."
AI_RESULT=$(echo "$COMBINED" | python3 /app/scripts/ai.py)

echo "$AI_RESULT"

ACTION=$(echo "$AI_RESULT" | jq -r '.action')
SEVERITY=$(echo "$AI_RESULT" | jq -r '.severity')
IPS=$(echo "$LOG_DATA" | jq -r '.ips[]' 2>/dev/null)

echo "[*] Decision: $ACTION | Severity: $SEVERITY"

# 🔥 Fail-safe rule
if [[ "$SEVERITY" == "CRITICAL" && -n "$IPS" ]]; then
    for ip in $IPS; do
        bash /app/scripts/ip_block.sh "$ip"
    done
fi

# Restart if needed
if [[ "$ACTION" == "restart_service" ]]; then
    bash /app/scripts/resover.sh
fi

# Alert
if [[ "$SEVERITY" != "LOW" ]]; then
    python3 /app/scripts/alert.py "$AI_RESULT"
fi

sleep 30

done
