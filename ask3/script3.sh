#! /usr/bin/bash

# Bubble Sort function
function bubble_sort {   
    local MAX=${#NUM_ARRAY[@]}
    SIZE=${#NUM_ARRAY[@]}
    while ((MAX > 0))
    do
        local i=0
        while ((i < MAX))
        do
            if [ "$i" != "$(($SIZE-1))" ] 
            then
                if [ ${NUM_ARRAY[$i]} \< ${NUM_ARRAY[$((i + 1))]} ]
                   then
                   local TEMP=${NUM_ARRAY[$i]}
                   NUM_ARRAY[$i]=${NUM_ARRAY[$((i + 1))]}
                   NUM_ARRAY[$((i + 1))]=$TEMP
                    
                   local TEMP2=${WORD_ARRAY[$i]}
                   WORD_ARRAY[$i]=${WORD_ARRAY[$((i + 1))]}
                  WORD_ARRAY[$((i + 1))]=$TEMP2
                 fi
             fi
            ((i += 1))
        done
        ((MAX -= 1))
    done
}

# Function that prints help message to command line and then terminates the program
function help() {
    echo "Help script to write"
    exit 0
}


# Checks wheter the user is asking for help
if [ "$1" == "-h" ]
then
    help
    exit 0
# Checks if both command line arguments where provided
elif [ -z "$1" ] || [ -z "$2" ]
then
    echo "Command line parameters not provided or incorect. Program terminated"
    exit 1
# Checks whether text file provided in the command line exists
elif [ ! -f "$1" ]
then
    echo "Could not find a text file. Program terminated"
    exit 1
fi

# Start reading the file
START="*** START OF THIS PROJECT GUTENBERG EBOOK"

# Stop reading the file
END="*** END OF THIS PROJECT GUTENBERG EBOOK"

FIRST_LINE="$(grep -n "$START" $1 | head -n 1 | cut -d: -f1)"
LAST_LINE="$(grep -n "$END" $1 | head -n 1 | cut -d: -f1)"
awk -v a=$FIRST_LINE -v b=$LAST_LINE 'NR==a+1, NR==b-1 {print $0}' $1 >> textFileTemp.txt


# Stores the words of the file without duplicates
WORDS=$(grep -o -E "(\w|')+" textFileTemp.txt | sed -e "s/'.*\$//" | sort -u -f)

# Array that will contain the words
WORD_ARRAY=()
# Array that will contain the number of appearnces for each word 
NUM_ARRAY=()

# Accessing all the words from the file
for WORD in $WORDS
do
    # Number of apperences of the WORD in the text file ($1)
    APEARENCES=`grep -o -i "$WORD" textFileTemp.txt | wc -l`

    # Appending each word and the number of it's appearnces
    # to the coresponding array
    WORD_ARRAY+=( $WORD )
    NUM_ARRAY+=( $APEARENCES )
done

# Deleting the temp text file
rm textFileTemp.txt

# Sorting the arrays
bubble_sort "${NUM_ARRAY[@]}" "${WORD_ARRAY[@]}"

# Printing the top ($LEN) words with most appearences
if [ $2 -lt ${#WORD_ARRAY[@]} ]
then
    LEN=$2
else
    LEN=${#WORD_ARRAY[@]}
    
fi

for ((i=0; i<$LEN; i++))
do
    echo "${NUM_ARRAY[$i]} ${WORD_ARRAY[$i]}"
done