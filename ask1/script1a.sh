#! /usr/bin/bash

function error {
    echo "$1 FAILED" >/dev/stderr
    exit 1
}

function compare {
    if [[ "$1" != "$2" ]]
    then
    echo "$3"
    fi
}

while IFS= read -r line || [[ -n "$line" ]]
do
    if [[ "$line" == *"#"* ]]
    then
        continue
    fi 
    found=false
    if [ ! -z "$(ls -A ./data1a)" ]; then
        
        for file in ./data1a/URL*.txt
        do
        url=$(head -n 1 "$file")
        if [[ "$line" == "$url" ]]
        then
            found=true
            prevHash=$(md5sum "$file")
            echo "$url" > "$file"
            wget -q -O - "$url" >> "$file" || error "$line"
            newHash=$(md5sum "$file")
            compare "$prevHash" "$newHash" "$line"
            break
        fi
        done
    fi
    if ! $found
    then
        num=$(($(ls ./data1a| wc -l)+1))
        echo "$line" > "./data1a/URL$num.txt"
        wget -q -O - "$line" >> "./data1a/URL$num.txt" && echo "$line INIT" || error "$line"
        
    fi
done < "$1"

