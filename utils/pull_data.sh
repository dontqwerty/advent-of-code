#!/bin/bash

# Export the AOC_SESSION_TOKEN env variable before running this script and optionally
# export the AOC_NICKNAME env variable for the user agent

if [ -z $AOC_SESSION_TOKEN ]; then
    echo "Export the session token to AOC_SESSION_TOKEN env variable first"
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

INPUT_URL="https://adventofcode.com/$YEAR/day/$DAY/input"

echo "Getting input from $INPUT_URL"

curl -s -X $'GET' \
    -H $'User-Agent: '"$AOC_NICKNAME"' manually executed pull input script' \
    -b $'session='"$AOC_SESSION_TOKEN"'' \
    --compressed \
    $''"$INPUT_URL"'' >"$TARGET"
