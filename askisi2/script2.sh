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

    # Deleting the directory in which all the contents from the 
    # zipped file were unziped and it's contents
    rm -r _unzipingLocation
}


# Checks if a command line argument was provided
if [ -z "$1" ]
then
    echo "Command line parameters not provided or incorect. Program terminated"
    exit 1
fi

# Getting all the ".txt" files from the "$1" compressed file
textFiles=$(unzip "$1")

