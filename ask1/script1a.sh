#! /usr/bin/bash


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
            prevHash=$(md5sum "$file")
            echo "$url" > "$file"
            wget -q -O - "$url" >> "$file"
            newHash=$(md5sum "$file")
            found=true
            break
        fi
        done
    fi
    if ! $found
    then
        num=$(($(ls ./data1a| wc -l)+1))
        echo "$line" > "./data1a/URL$num.txt"
        wget -q -O - "$line" >> "./data1a/URL$num.txt"
        echo "$line INIT"
    fi
done < "$1"

