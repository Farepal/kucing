#!/usr/bin/bash

fileName="${1%%.*}"

nasm -f elf64 ${fileName}".s"
ld ${fileName}".o" -o ${fileName}
# shellcheck disable=SC2015
[ "$2" == "-g" ] && gdb -q ${fileName} || ./${fileName}