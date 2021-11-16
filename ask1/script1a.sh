#! /usr/bin/bash


while IFS= read -r line || [[ -n "$line" ]]
do
    if [[ "$line" == *"#"* ]]
    then
            continue
    fi
    i=1
    for file in ./data1a/URL*.txt
    do
        
        i=$(($i+1))
    done
done < "$1"