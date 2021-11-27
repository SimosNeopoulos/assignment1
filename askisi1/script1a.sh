#! /usr/bin/bash

# Function that prints error mesage and terminates the program
function error {
    echo "$1 FAILED" >/dev/stderr
}

# Function that prints the url if a change has occured
function compare {
    if [[ "$1" != "$2" ]]
    then
    echo "$3"
    fi
}

# Checks if a command line argument was provided
if [ -z "$1" ]
then
    echo "Command line parameters not provided or incorect. Program terminated"
    exit 1
# Checks whether text file provided in the command line exists
elif [ ! -r "$1" ]
then
    echo "Could not find a text file. Program terminated"
    exit 1
fi


# If the data1a directory doesn't exist it is created here
[ ! -d "./data1a" ] && mkdir data1a

# A while loop that goes through all the lines from the text file in the
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
        
        # Iterating through the text files in the data1a directory
        for file in ./data1a/URL*.txt
        do
            # The url from the current file that was stored in the first line of the text file
            url=$(head -n 1 "$file")
            if [[ "$line" == "$url" ]]
            then
                found=true
            
                # Getting the hash from the file before it's contents are refreshed
                prevHash=$(md5sum "$file")

                # Reriting the url to the text file
                echo "$url" > "$file"

                # Veriable that indicated whether there was an error with the url or not
                failed=false

                # Getting the content from the current url ($url) and appends it to "$file"
                # If an error occurs during the execution the veriable "failed" is set to "true"
                wget -q -O - "$url" >> "$file" || failed=true

                # Getting the hash from the file after it's contents are refreshed
                newHash=$(md5sum "$file")

                # If an error was raised with the url download then an error message is printed.
                # If not the old hash, from the url's page, and the new are compered and an appropriate
                # message is printed.
                if $failed
                then
                    error "$line"
                else
                    compare "$prevHash" "$newHash" "$line"
                fi
                break
            fi
        done
    fi
    
    # If the html from the current url was't stored already it is being initialised here
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

