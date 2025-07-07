#!/bin/bash

set -e

TARGET_CONTAINER="runner-cli"
CONDITION_FILE="EXIT_CODE"
IMG_PATH="/fs/fat.img"

echo "[Watchdog] Monitoring for existence of file /tmp/mountpoint/${CONDITION_FILE}..."

while true; do
    mkdir -p "/tmp/mountpoint"
    mount "${IMG_PATH}" "/tmp/mountpoint"
    echo "Current content in /tmp/mountpoint:"
    ls -la /tmp/mountpoint
    if [ -f "/tmp/mountpoint/${CONDITION_FILE}" ]; then
        echo "Watchdog Condition met. Killing container: ${TARGET_CONTAINER}"
        docker kill "${TARGET_CONTAINER}"
        rm -f "/tmp/mountpoint/${CONDITION_FILE}"
        umount "/tmp/mountpoint"
        break
    fi
    umount "/tmp/mountpoint"
    sleep 3
done
