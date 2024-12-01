import subprocess
import time
import argparse
import os
import pandas as pd
from tqdm import tqdm


def execute_script(script_path, iterations=10):
    durations = []

    # Change the working directory to the script's directory
    script_directory = os.path.dirname(os.path.abspath(script_path))
    script_name = os.path.basename(script_path)
    os.chdir(script_directory)

    progress_bar = tqdm(total=iterations, desc="Running script")
    for i in range(iterations):
        start_time = time.time()
        try:
            # Execute the script using subprocess
            subprocess.run(
                ["python3", script_name], check=True, stdout=subprocess.DEVNULL
            )
        except subprocess.CalledProcessError as e:
            print(f"Execution failed on iteration {i+1}: {e}")
            continue
        end_time = time.time()

        duration = (end_time - start_time) * 1000
        durations.append(duration)
        progress_bar.update()
    progress_bar.close()

    if durations:
        print(pd.Series(data=durations, name="Durations (ms)").describe())
    else:
        print("\nNo successful executions to compute statistics.")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        description="Execute a Python script multiple times and measure execution time."
    )
    parser.add_argument("script_path", help="Path to the Python script to execute.")
    parser.add_argument(
        "iterations",
        nargs="?",
        default=10,
        type=int,
        help="Number of times to execute the script (default: 10).",
    )
    args = parser.parse_args()

    execute_script(args.script_path, args.iterations)
