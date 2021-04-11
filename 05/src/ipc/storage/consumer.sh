#!/bin/bash

# consumer.sh

STORAGE_FILE="./storage"

while true; do
    while IFS= read -r line; do
        echo "${line}"
    done < "${STORAGE_FILE}"
    sleep 1s
done