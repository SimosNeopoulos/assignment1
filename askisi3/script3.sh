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
if [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
    help
    exit 0
# Checks if both command line arguments were provided
elif [ -z "$1" ] || [ -z "$2" ]; then
    echo "Command line parameters not provided or incorect. Program terminated"
    exit 1
# Checks whether text file provided in the command line exists
elif [ ! -r "$1" ]; then
    echo "Could not find a text file. Program terminated"
    exit 1
fi

# The upper limit of the file
start="*** START OF THIS PROJECT GUTENBERG EBOOK"

# The down limit of the file
end="*** END OF THIS PROJECT GUTENBERG EBOOK"

# Boolean veriable that is preset as "false" and indicates
# whether we are within the set bounds in the text file
read=false

# Reads the text file that has been passed as argument in the command line
# and appends all the lines that are within bounds to the __wordFile.txt file..
while IFS= read -r line || [[ -n "$line" ]]; do
    if $read; then
        # When we reach the down bounds the loop breaks.
        # Else the current line is appended to the __wordFile.txt file
        if [[ "$line" == *"$end"* ]]; then
            break
        else
            echo "$line" >> __wordFile.txt
            continue
        fi
  fi
  
    # If the read veriable is false and "$start" is a substring of
    # "$line" then we are now within bounds and $read is set to true
    if ! $read; then
        if [[ "$line" == *"$start"* ]]; then
            read=true
        fi
  fi

done < "$1"


# Stores the words of the file without duplicates
words=$(grep -o -E "(\w|')+" __wordFile.txt | sed -e "s/'.*\$//" | sort -u -f)

# Accessing all the words from the file
for word in $words; do
    # Number of apperences of the word in the text file (__wordFile.txt)
    apearences=`grep -w -o -i "$word" __wordFile.txt | wc -l`

    # Printing each word and the number of it's appearences in the __dataFile.txt file
    printf "%s %s\n" $apearences $word >> __dataFile.txt
done

# Deleting the temp text file
rm __wordFile.txt

# Appending the __sortedFile text from __dataFile.txt to __sortedFile.txt
sort -nr __dataFile.txt >> __sortedFile.txt

# Deleting __dataFile text file
rm __dataFile.txt

# Counter that breaks the while loop once enought lines have been printed
count=0

# Printing the results
while IFS= read -r line || [[ -n "$line" ]]; do
    message=$(tac -s " " <<< "$line" )
    echo  $message
    count=$(($count+1))
    if [ $count -ge $2 ]; then
        break
    fi
done < __sortedFile.txt

# Deleting __sortedFile text file
rm __sortedFile.txt

exit 0