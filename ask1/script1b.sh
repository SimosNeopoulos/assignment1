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

# This function gets the hash code from the file it is that has been passed as argument,
# before and after it appends the new content from the url's web page.
# It then calls the "compare" function to find whether somethinf has change or not.
function append {
    local _url="$1"
    local _fileName="$2"
    failed=false
    prevHash=$(md5sum "$_fileName")
    echo "$_url" > "$_fileName"
    wget -q -O - "$_url" >> "$_fileName" || failed=true
    newHash=$(md5sum "$_fileName")
    if $failed
    then
        error "$_url"
    else
        compare "$prevHash" "$newHash" "$_url"
    fi
}

# Function that stores the data for the new urls
function create {
    randName=$(tr -dc A-Za-z0-9 </dev/urandom | head -c 5)
    echo "$1" > "./data1b/URL$randName.txt" 
    wget -q -O - "$1" >> "./data1b/URL$randName.txt" && echo "$1 INIT" || error "$1"
}

# Function that initialises
function initialise {
    # local array veriable that contains all the urls that are to be initialised
    local -n _urls=$1

    # Iterting through _urls array and storing their data
    for _url in ${_urls[@]}   
    do 
        create "$_url" &
    done
    wait
}

# Function that iterates trough each stored url and it's file location
# passing them as arguments for the "append" function.
function check {
    local -n _urls=$1
    local -n _fileNames=$2
    local -i _num=${#_urls[@]}
    for ((i=0; i<$_num; i++))
    do
        append "${_urls[$i]}" "${_fileNames[$i]}" &
    done
    wait
}

# If the data1b directory doesn't exist it is created here
[ ! -d "./data1b" ] && mkdir data1b

# Arrays that will store the urls for the arrays that are to be initilised
# and the urls that are already stored and the file names with their location
newURLs=()
oldURLs=()
oldFileName=()

# A while loop that goes through all the lines from the text file in the
# command line argument. If the line doesn't have a url (the line starts with "#")
# it skips this line
while IFS= read -r line || [[ -n "$line" ]]
do
    # Boolean veriable that indivates whether a url with the same name
    # as the one intereted now is already stored
    found=false

    # If the line starts with a "#" it skips it
    if [[ "$line" == *"#"* ]]
    then
        continue
    else
        # Checks if the "data1b" directory is empty
        if [ ! -z "$(ls -A ./data1b)" ]
        then
            # Iterating through the text files in the data1a directory
            for file in ./data1b/URL*.txt
            do
                # The url from the current file that was stored in the first line of the text file
                url=$(head -n 1 "$file")
                if [[ "$line" == "$url" ]]
                then
                    found=true
                    oldURLs+=( "$line" )
                    oldFileName+=( "$file" )
                    break
                fi
            done
        fi
        # If the html from the current url was't stored already it's url address is added to "newURLs" array
        if ! $found
        then
            newURLs+=( "$line" )
        fi
    fi
done < "$1"

# Comparing the old web page instant with the new
if ((${#oldURLs[@]})); then
    check oldURLs oldFileName &
fi

# Initialising the new urls
if ((${#newURLs[@]})); then
    initialise newURLs &
fi

wait

exit 0