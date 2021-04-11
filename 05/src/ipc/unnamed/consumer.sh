#!/bin/bash

# consumer.sh

echo "Consumer data:"
echo "--------------"

if [ -t 0 ]; then
    data="$*"
else
    data=$(cat)
fi

echo "${data}"