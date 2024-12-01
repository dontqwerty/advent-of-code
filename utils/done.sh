#!/bin/bash

# Function to push solution for Advent of Code
push_solution() {
    # Check if correct number of arguments is provided
    if [[ $# -ne 2 ]]; then
        echo "Usage: $0 <level> <solution>"
        return 1
    fi

    # Get current date components
    current_month=$(date +%m)
    current_day=$(date +%d)
    current_year=$(date +%Y)

    # Check if it's December and between 1st and 24th
    if [[ "$current_month" != "12" || "$current_day" -lt 1 || "$current_day" -gt 24 ]]; then
        echo "Not in Advent of Code period (December 1-24). Exiting."
        return 1
    fi

    # Pad single-digit days with a leading zero
    current_day=$(printf "%d" "$current_day")

    # Get level and solution from arguments
    level="$1"
    solution="$2"

    # Call push_solution.sh
    bash push_solution.sh "$current_year" "$current_day" "$level" "$solution"
}

# Run the push solution function with provided arguments
push_solution "$@"
