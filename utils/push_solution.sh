#!/bin/bash

# Export the AOC_TOKEN env variable before running this script and optionally
# export the AOC_NICKNAME env variable for the user agent

if [ -z $AOC_TOKEN ]; then
    echo "Export the AoC token to AOC_TOKEN env variable first"
    exit 1
fi

if [ -z $1 ]; then
    echo "Specify a year"
    exit 2
fi
YEAR="$1"

if [ -z $2 ]; then
    echo "Specify a day to send the solution to"
    exit 3
fi
DAY="$2"

if [ -z $3 ]; then
    echo "Specify the level"
    exit 4
fi
LEVEL="$3"

if [ -z $4 ]; then
    echo "Specify your solution"
    exit 5
fi
SOLUTION="$4"

curl -i -s -k -X $'POST' \
    -H $'User-Agent: '"$AOC_NICKNAME"' manually executed push solution script' \
    -H $'Content-Type: application/x-www-form-urlencoded' \
    -b $'session='"$AOC_TOKEN"'' \
    --data-binary $'level='"$LEVEL"'&answer='"$SOLUTION"'' \
    $'https://adventofcode.com/2023/day/'"$DAY"'/answer'
