#! /usr/bin/bash

# Bubble Sort function
function bubble_sort {   
    local max=${#numArray[@]}
    size=${#numArray[@]}
    while ((max > 0))
    do
        local i=0
        while ((i < max))
        do
            if [ "$i" != "$(($size-1))" ] 
            then
                if [ ${numArray[$i]} \< ${numArray[$((i + 1))]} ]
                   then
                   local temp=${numArray[$i]}
                   numArray[$i]=${numArray[$((i + 1))]}
                   numArray[$((i + 1))]=$temp
                    
                   local temp2=${wordArray[$i]}
                   wordArray[$i]=${wordArray[$((i + 1))]}
                  wordArray[$((i + 1))]=$temp2
                 fi
             fi
            ((i += 1))
        done
        ((max -= 1))
    done
}

#function bubble_sort {
#    local size=${#numArray[@]}
#    for ((i=0; i<$((size-1)); i++ ))
#    do
#        for ((j=0; j<$((size-i-1)); j++))
#        do
#            if [ ${numArray[$j]} \< ${numArray[$((j + 1))]} ]
#            then
#                local temp=${numArray[$j]}
#                numArray[$j]=${numArray[$((j + 1))]}
#                numArray[$((j + 1))]=$temp#
#
#                local temp2=${wordArray[$j]}
#                wordArray[$j]=${wordArray[$((j + 1))]}
 #               wordArray[$((j + 1))]=$temp2
 ##           fi
#        done
 #   done
#}

# Function that prints help message to command line and then terminates the program
function help {
    echo "To excecute this script, provide the name of the text file,"
    echo "you want to access and the number of the words that you"
    echo "wish to see."
    echo "It should look like this:"
    echo
    echo "./script3.sh text.txt 8"
    echo
    exit 0
}


# Checks wheter the user is asking for help
if [ "$1" == "-h" ] || [ "$1" == "--help" ] 
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
start="*** START OF THIS PROJECT GUTENBERG EBOOK"

# Stop reading the file
end="*** END OF THIS PROJECT GUTENBERG EBOOK"

# Veriables that represent the upper and down limits of the text file
firstLine="$(grep -n "$start" $1 | head -n 1 | cut -d: -f1)"
lastLine="$(grep -n "$end" $1 | head -n 1 | cut -d: -f1)"

# Creates a temporary text file that only contains the words that concern us
awk -v a=$firstLine -v b=$lastLine 'NR==a+1, NR==b-1 {print $0}' $1 >> textFileTemp.txt

# Stores the words of the file without duplicates
words=$(grep -o -E "(\w|')+" textFileTemp.txt | sed -e "s/'.*\$//" | sort -u -f)

# Array that will contain the words
wordArray=()
# Array that will contain the number of appearnces for each word 
numArray=()

# Accessing all the words from the file
for word in $words
do
    # Number of apperences of the word in the text file ($1)
    apearences=`grep -o -i "$word" textFileTemp.txt | wc -l`

    # Appending each word and the number of it's appearnces
    # to the coresponding array
    wordArray+=( $word )
    numArray+=( $apearences )
done

# Deleting the temp text file
rm textFileTemp.txt

# Sorting the arrays
bubble_sort "${numArray[@]}" "${wordArray[@]}"

# Printing the top ($LEN) words with most appearences
if [ $2 -lt ${#wordArray[@]} ]
then
    LEN=$2
else
    LEN=${#wordArray[@]}
    
fi

for ((i=0; i<$LEN; i++))
do
    echo "${numArray[$i]} ${wordArray[$i]}"
done