#! /usr/bin/bash


while IFS= read -r line || [[ -n "$line" ]]
do
    if [ "$line" == "#"* ]; then
        continue
    fi
done < "$1"