#!/bin/bash

# producer.sh

SOCKET="/var/tmp/ipc.sock"

rm -f "${SOCKET}"

while true; do
    uuidgen;
    sleep 1s;
done \
| tee /dev/tty \
| nc -lU "${SOCKET}"