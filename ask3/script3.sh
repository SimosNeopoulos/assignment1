#! /usr/bin/bash

function bubble_sort()
{   
    local max=${#NUM_ARRAY[@]}
    size=${#NUM_ARRAY[@]}
    while ((max > 0))
    do
        local i=0
        while ((i < max))
        do
            if [ "$i" != "$(($size-1))" ] #array will not be out of bound
            then
                if [ ${NUM_ARRAY[$i]} \< ${NUM_ARRAY[$((i + 1))]} ]
                   then
                   local t=${NUM_ARRAY[$i]}
                   NUM_ARRAY[$i]=${NUM_ARRAY[$((i + 1))]}
                   NUM_ARRAY[$((i + 1))]=$t
                    
                   local tf=${WORD_ARRAY[$i]}
                   WORD_ARRAY[$i]=${WORD_ARRAY[$((i + 1))]}
                  WORD_ARRAY[$((i + 1))]=$tf
                 fi
             fi
            ((i += 1))
        done
        ((max -= 1))
    done
}


WORDS="$(grep -o -E '\w+' test.txt | sort -u -f)"

WORD_ARRAY=()
NUM_ARRAY=()

for WORD in $WORDS
do
    APEARENCES="$(grep -o -i "$WORD" test.txt | wc -l)"
    WORD_ARRAY+=( $WORD )
    NUM_ARRAY+=( $APEARENCES )
done
bubble_sort "${NUM_ARRAY[@]}" "${WORD_ARRAY[@]}"