#!/bin/bash

IP=$1
WHITELIST=("127.0.0.1" "192.168.1.10")

for safe in "${WHITELIST[@]}"; do
    if [ "$IP" == "$safe" ]; then
        exit 0
    fi
done

iptables -C INPUT -s "$IP" -j DROP 2>/dev/null

if [ $? -ne 0 ]; then
    iptables -A INPUT -s "$IP" -j DROP
fi
