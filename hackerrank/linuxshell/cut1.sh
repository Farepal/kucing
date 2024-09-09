#!/usr/bin/bash

# enter two times to exit the loop
for i in $(seq 1 100)
do
    read line
    if [ -z "$line" ]
    then
        break
    fi
    echo $line | cut -c3
done