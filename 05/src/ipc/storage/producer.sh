#!/bin/bash

# producer.sh

STORAGE_FILE="./storage"

rm -f "${STORAGE_FILE}"

while true; do
    for (( i=1; i<=10; i++ )); do
        uid="$(uuidgen)"
        echo "${uid}"
        echo "${uid}" >> "${STORAGE_FILE}"
    done
    sleep 5s
done