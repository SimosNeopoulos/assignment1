#! /usr/bin/bash

# Function that prints error mesage and terminates the program
function error {
    echo "$1 FAILED" >/dev/stderr
    exit 1
}

# Function that prints the url if a change has occured
function compare {
    if [[ "$1" != "$2" ]]
    then
    echo "$3"
    fi
}

# A while loop that goes threw all the lines from the text file in the
# command line argument. If the line doesn't have a url (the line starts with "#")
# it skips this line
while IFS= read -r line || [[ -n "$line" ]]
do  
    # If the line starts with a "#" it skips it
    if [[ "$line" == *"#"* ]]
    then
        continue
    fi

    # Boolean veriable that indivates whether a url with the same name
    # as the one intereted now is already stored
    found=false

    # Checks if the "data1a" directory is empty
    if [ ! -z "$(ls -A ./data1a)" ]; then
        
        # Iterating threw the text files in the data1a directory
        for file in ./data1a/URL*.txt
        do

        # The url from the current file
        url=$(head -n 1 "$file")
        if [[ "$line" == "$url" ]]
        then
            found=true
            # Getting the hash from the file before it's contents are refreshed
            prevHash=$(md5sum "$file")
            # Reriting the url to the text file
            echo "$url" > "$file"

            # Getting the content from the current url ($url) and appends it to "$file"
            # If an error occurs during the execution an error message occurs
            wget -q -O - "$url" >> "$file" || error "$line"

            # Getting the hash from the file after it's contents are refreshed
            newHash=$(md5sum "$file")

            # Calling the compare function for these 3 veriables
            compare "$prevHash" "$newHash" "$line"
            break
        fi
        done
    fi
    if ! $found
    then
        # The number of files+1 in the data1a directory
        num=$(($(ls ./data1a| wc -l)+1))

        # Creating file "URL$num.txt" and writes the current url
        echo "$line" > "./data1a/URL$num.txt"

        # Getting the content from the current url ($line) and appends it to "./data1a/URL$num.txt"
        # If an error occurs during the execution an error message occurs
        wget -q -O - "$line" >> "./data1a/URL$num.txt" && echo "$line INIT" || error "$line"
        
    fi
done < "$1"

