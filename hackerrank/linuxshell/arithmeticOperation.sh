#!/usr/bin/bash
read x
echo $x | bc -l | xargs printf "%.3f\n"
for i in {+,-,*,/}
do
    echo $x$i'5' | bc -l | xargs printf "%.3f\n"
done