#! /usr/bin/bash

WORDS="$(grep -o -E '\w+' test.txt | sort -u -f)"

WORD_ARRAY=()
NUM_ARRAY=()

for WORD in $WORDS
do
    APEARENCES="$(grep -o -i "$WORD" test.txt | wc -l)"
    WORD_ARRAY+=( $WORD )
    NUM_ARRAY+=( $APEARENCES )
done