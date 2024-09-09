#!/usr/bin/bash

array=()
while true; do
    read -r line
    if [ -z "$line" ]; then
        break
    fi
    array+=("$line")
done

#output the length of the array

for i in "${array[@]}"; do
    awk -F $'{print $1  $2, $3 $4}' <<<"$i"
done
