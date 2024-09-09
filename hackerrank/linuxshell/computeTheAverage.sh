#!/usr/bin/bash

read -r n
sum=0
while [ "$n" -gt 0 ]
do
    read num
    sum=$((sum + num))
done

printf "%.3f" "$(echo "$sum / $n" | bc -l)"