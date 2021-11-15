#! /usr/bin/bash

#Bubble Sort function
function bubble_sort()
{   
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

#Stores the words of the file without dublicates
WORDS="$(grep -o -E '\w+' $1 | sort -u -f)"

#Array that will contain the words
WORD_ARRAY=()
#Array that will contain the number of appearnces for each word 
NUM_ARRAY=()

#Accessing all the words from the file
for WORD in $WORDS
do
    #Number of apperences of the WORD in the text file ($1)
    APEARENCES="$(grep -o -i "$WORD" $1 | wc -l)"

    #Appending each word and the number of it's appearnces
    #to the coresponding array
    WORD_ARRAY+=( $WORD )
    NUM_ARRAY+=( $APEARENCES )
done

#Sorting the arrays
bubble_sort "${NUM_ARRAY[@]}" "${WORD_ARRAY[@]}"

#Printing the top ($2) words with most appearences
for((i=0; i<$2; i++))
do
    echo "${NUM_ARRAY[$i]} ${WORD_ARRAY[$i]}"
done