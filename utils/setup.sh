#!/bin/bash

# Function to check and set up Advent of Code directory
setup_advent_of_code() {
    # Get current date components
    current_month=$(date +%m)
    if [ -z $1 ]; then
        current_day=$(date +%e)
        current_day=$(printf "%d" "$current_day")
        current_formatted_day=$(date +%d)
    else
        current_day=$1
        current_formatted_day=$(printf "%02d" "$current_day")
    fi
    echo $current_formatted_day
    current_year=$(date +%Y)

    if [[ "$current_month" != "12" || "$current_day" -lt 1 || "$current_day" -gt 24 ]]; then
        echo "Not in Advent of Code period (December 1-24). Exiting."
        return 1
    fi

    # Create the Advent of Code directory path
    advent_dir="../advent-of-code-${current_year}"
    day_dir="${advent_dir}/day_${current_formatted_day}"
    input_filepath="${day_dir}/input"

    # Create the directory
    mkdir -p "$day_dir"

    # Check if directory creation was successful
    if [[ $? -ne 0 ]]; then
        echo "Failed to create directory ${day_dir}"
        return 1
    fi

    # Create common.py
    python_script_path="${day_dir}/common.py"
    if [[ ! -f "$python_script_path" ]]; then
        cat <<'EOF' >"$python_script_path"
def parse_input():
    return open("input").read()
EOF
        echo "Created ${python_script_path}"
    else
        echo "${python_script_path} already exists. Skipping creation."
    fi

    # Create one.py
    python_script_path="${day_dir}/one.py"
    if [[ ! -f "$python_script_path" ]]; then
        cat <<'EOF' >"$python_script_path"
from common import parse_input

myinput = parse_input()
print(myinput[:5])
EOF
        echo "Created ${python_script_path}"
    else
        echo "${python_script_path} already exists. Skipping creation."
    fi

    # Create two.py
    python_script_path="${day_dir}/two.py"
    if [[ ! -f "$python_script_path" ]]; then
        cat <<'EOF' >"$python_script_path"
from common import parse_input

myinput = parse_input()
print(myinput[:5])
EOF
        echo "Created ${python_script_path}"
    else
        echo "${python_script_path} already exists. Skipping creation."
    fi

    # Call pull_data function from pull_data.sh
    if [ -z $2 ]; then
        echo "Calling pull_data.sh ${current_year} ${current_day} ${input_filepath}"
        bash pull_data.sh "$current_year" "$current_day" "$input_filepath"
    fi
}

setup_advent_of_code "$@"
