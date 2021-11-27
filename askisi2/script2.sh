#! /usr/bin/bash

# Unziping the compressed file that has been passed as an argument
# and echoing all the .txt files it contained.
function unzip {

    # Creating the directory in which all the contents from the 
    # zipped file will be unziped
    mkdir _unzipingLocation

    # Unziping the contents into "./_unzipingLocation"
    tar -xf "$1" -C ./_unzipingLocation

    # Finding all the ".txt" files and outputing them with "echo"
    textFiles=$(find ./_unzipingLocation -name "*.txt")
    echo "$textFiles"

    
}


# Checks if a command line argument was provided
if [ -z "$1" ]
then
    echo "Command line parameters not provided or incorect. Program terminated"
    exit 1
fi

# Getting all the ".txt" files from the "$1" compressed file
textFiles=$(unzip "$1")

# Array that stores the urls for the git repositories
repo_urls=()

# Iterating trough all the ".txt" files
for file in $textFiles; do

    # Reading the ".txt" file line by line,
    # skiping the lines that don't start with "https", until the end of the file
    # If a line starts with "https" we store the content of the line in "repo_urls" and exit the loop
    while IFS= read -r line || [[ -n "$line" ]]; do

        # If the line doesn't start with a "https" it skips it
        if [[ "$line" != "https"* ]]; then
            continue
        else
            repo_urls+=( "$line" )
            break
        fi
    done < "$file"
done

# Deleting the directory in which all the contents from the 
# zipped file were unziped and it's contents
rm -r _unzipingLocation

for repo in "${repo_urls[@]}"; do
    # Add code to iterate the repositories and clone them here
    echo "$repo"
done