#!/bin/bash

# Export the AOC_TOKEN env variable before running this script

if [ -z $AOC_TOKEN ]; then
    echo "Export the session token to AOC_TOKEN env variable first"
    exit 1
fi

if [ -z $1 ]; then
    echo "Specify a year to pull the data from"
    exit 2
fi
YEAR="$1"

if [ -z $2 ]; then
    echo "Specify a day to pull the data from"
    exit 3
fi
DAY="$2"

if [ -z $3 ]; then
    echo "Specify a filepath for the data to go"
    exit 4
fi
TARGET="$3"

curl -s -X $'GET' --compressed \
    -b $'session='"$AOC_TOKEN"'' \
    $'https://adventofcode.com/'"$YEAR"'/day/'"$DAY"'/input' > "$TARGET"
