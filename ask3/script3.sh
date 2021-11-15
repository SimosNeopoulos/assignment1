#! /usr/bin/bash


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

# The upper limit of the file
start="*** START OF THIS PROJECT GUTENBERG EBOOK"

# The down limit of the file
end="*** END OF THIS PROJECT GUTENBERG EBOOK"

# Veriables that represent the upper and down limits of the text file
firstLine="$(grep -n "$start" $1 | head -n 1 | cut -d: -f1)"
lastLine="$(grep -n "$end" $1 | head -n 1 | cut -d: -f1)"

# Creates a temporary text file that only contains the words that concern us
awk -v a=$firstLine -v b=$lastLine 'NR==a+1, NR==b-1 {print $0}' $1 >> wordFile.txt

# Stores the words of the file without duplicates
words=$(grep -o -E "(\w|')+" wordFile.txt | sed -e "s/'.*\$//" | sort -u -f)

# Accessing all the words from the file
for word in $words
do
    # Number of apperences of the word in the text file (wordFile.txt)
    apearences=`grep -o -i "$word" wordFile.txt | wc -l`

    # Printing each word and the number of it's appearences in the data.txt file
    printf "%s %s\n" $apearences $word >> data.txt
done

# Deleting the temp text file
rm wordFile.txt

# Appending the sorted text from data.txt to sorted.txt
sort -nr data.txt >> sorted.txt

# Deleting data text file
rm data.txt

# Printing 
awk -v end=$2 'NR==1, NR==end {print $2, $1}' sorted.txt

# Deleting sorted text file
rm sorted.txt

exit 0