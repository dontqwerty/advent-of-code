import subprocess
import time
import argparse
import os
import pandas as pd
from tqdm import tqdm


def execute_script(script_path, iterations=10):
    # Change the working directory to the script's directory
    script_directory = os.path.dirname(os.path.abspath(script_path))
    script_name = os.path.basename(script_path)
    os.chdir(script_directory)

    durations_ms = []
    progress_bar = tqdm(total=iterations, desc="Running script")
    for i in range(iterations):
        start_time_ns = time.time_ns()
        try:
            # Execute the script using subprocess
            subprocess.run(
                ["python3", script_name], check=True, stdout=subprocess.DEVNULL
            )
        except subprocess.CalledProcessError as e:
            print(f"Execution failed on iteration {i+1}: {e}")
            continue
        end_time_ns = time.time_ns()

        duration_ms = (end_time_ns - start_time_ns) / 1_000_000
        durations_ms.append(duration_ms)
        progress_bar.update()
    progress_bar.close()

    if durations_ms:
        print(pd.Series(data=durations_ms, name="Durations (ms)").describe())
    else:
        print("No successful executions to compute statistics.")


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
