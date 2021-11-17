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

function create {
    randName=$(tr -dc A-Za-z0-9 </dev/urandom | head -c 5)
    echo "$1" > "./data1b/URL$randName.txt" 
    wget -q -O - "$1" >> "./data1b/URL$randName.txt" && echo "$1 INIT" || error "$1"
}

function initialise {

    local -n _urls=$1
    for _url in ${_urls[@]}   
    do
        create "$_url" &
    done
    wait
    
}


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


newURLs=()
oldURLs=()
oldFileName=()

# A while loop that goes threw all the lines from the text file in the
# command line argument. If the line doesn't have a url (the line starts with "#")
# it skips this line
while IFS= read -r line || [[ -n "$line" ]]
do
    # If the data1b directory doesn't exist it is created here
    found=false
    if [[ "$line" == *"#"* ]]
    then
        continue
    else
        if [ ! -z "$(ls -A ./data1b)" ]
        then
            for file in ./data1b/URL*.txt
            do
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
        if ! $found
        then
            newURLs+=( "$line" )
        fi
    fi
done < "$1"


if ((${#oldURLs[@]})); then
    check oldURLs oldFileName &
fi

if ((${#newURLs[@]})); then
    initialise newURLs &
fi

wait

exit 0