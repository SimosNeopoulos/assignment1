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

# Prints appropriate error message and deletes the repo folder that was created
function failed_clone {
    echo "$2: Cloning FAILED" >/dev/stderr
    rm -r "$1"
}

# Creates "assignments" directory if it doesn't already exits.
# It then adds the repositories to a folder and prints an appropriate message
function add_repoes {
    # Array with the repository urls
    local -n __repo_urls=$1

    # Checking if "asignments" directory exists. It then creates it if it doesn't
    [ ! -d "./assignments" ] && mkdir assignments

    # Iterating trough the repositories urls
    for repo in "${__repo_urls[@]}"; do

        # Cutting the string to get the name of the repository
        name=${repo%.git}
        name=${name##*/}

        mkdir ./assignments/$name
        git clone "$repo" ./assignments/$name &>/dev/null && echo "$repo: Cloning OK" || failed_clone "./assignments/$name" "$repo"
    done

}

# Prints the number of directories, .txt and other files, 
# along side with whether the repository format is correct
function printNums {
    echo "$5:"
    echo "Number of directories : $1"
    echo "Number of txt files : $2"
    echo "Number of other files : $3"

    if $4; then
        echo "Directory structure is OK"
    else
        echo "Directory structure is NOT OK"
    fi
}

# Checks if a command line argument was provided
if [ -z "$1" ]; then
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

# Calling "add_repoes" to create and add repositories
add_repoes repo_urls

# Arrays that contain the correct format for the repositories
content_main=( . .. dataA.txt .git more )
more_content=( . .. dataB.txt dataC.txt )

# Itearing through all the stored repositories
for repo in ./assignments/*; do

    # Boolean veriable that indicates whether the format of the repository is correct
    stracture=true

    # Veriables that represent the number of directories, .txt files and other files inside the $repo repository
    dir_num=$(($(find $repo -name .git -prune -o -type d -print| wc -l)-1))
    text_num=$(find $repo -name .git -prune -o -type f -name "*.txt" -print| wc -l)
    non_text_num=$(find $repo -name .git -prune -o -type f ! -name '*.txt' -print| wc -l)
    
    # Checking to see if the repository has the right number if directories and files
    if [ $dir_num -ne 1 ] || [ $text_num -ne 3 ] || [ $non_text_num -ne 0 ]; then
        stracture=false
    fi
    
    # If the format isn't correct it calls "printNums" to print the apropriate message
    if ! $stracture; then
        printNums "$dir_num" "$text_num" "$non_text_num" "$stracture" "${repo##*/}"
        continue
    fi

    i=0

    # Sotring the content of the current $repo and the content of the "more" directory inside the $repo
    contentA=$(ls -a $repo)
    contentB=$(ls -a $repo/more)

    # Itareting through the $repo directory to check if the format is correct
    for file in $contentA; do
        if [[ "$file" != "${content_main[i]}" ]]; then
            stracture=false
            break
        fi
        ((i=i+1))
    done

    # Itareting through $repo's more directory to check if the format is correct
    if $stracture; then
        i=0
        for file in $contentB; do
            if [[ "$file" != "${more_content[i]}" ]]; then
                stracture=false
                break
            fi
            ((i=i+1))
        done
    fi

    # Calling "printNums" to print the apropriate message
    printNums "$dir_num" "$text_num" "$non_text_num" "$stracture" "${repo##*/}"
done