#!/bin/bash

# consumer.sh

SOCKET="/var/tmp/ipc.sock"

nc -U "${SOCKET}"