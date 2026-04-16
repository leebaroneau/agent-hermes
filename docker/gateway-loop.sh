#!/bin/bash
# Gateway loop: keeps the container alive even if the gateway crashes.
# This handles the chicken-and-egg problem where WhatsApp needs to be
# paired before the gateway can stay connected.
#
# Usage: exec into the container and run `hermes whatsapp` to pair.
# The gateway will auto-recover on the next loop iteration.

set -u

RETRY_DELAY=30

echo "Starting Hermes gateway loop (retry every ${RETRY_DELAY}s on failure)..."

while true; do
    echo "[$(date -Iseconds)] Starting gateway..."
    hermes gateway run
    EXIT_CODE=$?

    if [ "$EXIT_CODE" -eq 0 ]; then
        echo "[$(date -Iseconds)] Gateway exited cleanly."
    else
        echo "[$(date -Iseconds)] Gateway exited with code $EXIT_CODE. Retrying in ${RETRY_DELAY}s..."
    fi

    sleep "$RETRY_DELAY"
done
