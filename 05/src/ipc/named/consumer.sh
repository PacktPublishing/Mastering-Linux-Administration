#!/bin/bash

# consumer.sh

PIPE="pipe.fifo"

if [[ ! -p ${PIPE} ]]; then mkfifo ${PIPE}; fi

while true; do
    if read line <${PIPE}; then
        echo "${line}"
    fi
done