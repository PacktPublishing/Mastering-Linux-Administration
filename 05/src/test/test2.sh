#!/bin/bash

trap sig_handler SIGUSR1

function sig_handler() {
    echo "Signal caught!"
}

while true; do
    echo "Waiting..."
    sleep 3s
done
