#!/usr/bin/bash

for i in $(seq 1 100)
do
    read line
    if [ -z "$line" ]
    then
        break
    fi
    echo $line | cut -c1-4
done