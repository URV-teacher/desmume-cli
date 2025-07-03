#!/bin/bash

TARGET_CONTAINER="runner-cli"
CONDITION_FILE="output.txt"
IMG_PATH="/fs/fat.img"

echo "[Watchdog] Monitoring for condition..."

while true; do
    mkdir -p "/tmp/mountpoint"
    mount "${IMG_PATH}" "/tmp/mountpoint"
    if [ -f "/tmp/mountpoint/${CONDITION_FILE}" ]; then
        echo "Watchdog Condition met. Killing container: ${TARGET_CONTAINER}"
        docker kill "${TARGET_CONTAINER}"
        umount "/tmp/mountpoint"
        break
    fi
    umount "/tmp/mountpoint"
    sleep 3
done
