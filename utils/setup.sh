#!/bin/bash

# Function to check and set up Advent of Code directory
setup_advent_of_code() {
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
    formatted_day=$(printf "%02d" "$current_day")

    # Create the Advent of Code directory path
    advent_dir="../advent-of-code-${current_year}"
    day_dir="${advent_dir}/day_${formatted_day}"
    input_filepath="${day_dir}/input"
    solution_filepath="${day_dir}/solution.py"

    # Create the directory
    mkdir -p "$day_dir"

    # Check if directory creation was successful
    if [[ $? -ne 0 ]]; then
        echo "Failed to create directory ${day_dir}"
        return 1
    fi

    # Create Python script to read input only if it doesn't exist
    python_script="${day_dir}/solution.py"
    if [[ ! -f "$python_script" ]]; then
        cat <<'EOF' >"$python_script"
with open("input", "r") as f:
    lines = f.readlines()
    print(lines[:10])
EOF
        echo "Created ${solution_filepath}"
    else
        echo "${solution_filepath} already exists. Skipping creation."
    fi

    # Call pull_data function from pull_data.sh
    echo "Calling pull_data.sh ${current_year} ${current_day} ${input_filepath}"
    bash pull_data.sh "$current_year" "$current_day" "$input_filepath"
}

# Run the setup function
setup_advent_of_code
