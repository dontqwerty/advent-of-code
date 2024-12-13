import subprocess
import time
import argparse
import os
import pandas as pd
from tqdm import tqdm


def find_venv_interpreter(dir_path):
    # Potential virtual environment folder names
    venv_folders = [".venv", ".env"]

    # Potential interpreter location patterns
    interpreter_paths = [
        "bin/python",
        "bin/python3",
    ]

    # Normalize the directory path
    base_path = os.path.abspath(dir_path)

    # Check each potential virtual environment folder
    for venv_folder in venv_folders:
        for interpreter_path in interpreter_paths:
            # Construct full path to potential interpreter
            potential_interpreter = os.path.join(
                base_path, venv_folder, interpreter_path
            )

            # Check if the interpreter exists and is executable
            if os.path.isfile(potential_interpreter) and os.access(
                potential_interpreter, os.X_OK
            ):
                return potential_interpreter

    # If no interpreter found
    return None


def execute_script(interpreter, script_name, iterations=10):
    durations_ms = []
    progress_bar = tqdm(total=iterations, desc="Running script")
    for i in range(iterations):
        start_time_ns = time.time_ns()
        try:
            # Execute the script using subprocess
            subprocess.run(
                [
                    interpreter,
                    script_name,
                ],
                check=True,
                stdout=subprocess.DEVNULL,
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

    # Change the working directory to the script's directory
    script_directory = os.path.dirname(os.path.abspath(args.script_path))
    script_name = os.path.basename(args.script_path)
    os.chdir(script_directory)

    venv_interpreter = find_venv_interpreter(script_directory)
    interpreter = "python3" if venv_interpreter is None else venv_interpreter
    print(f"Script: {script_directory}/{script_name}")
    print(f"Interpreter: {interpreter}")
    execute_script(
        interpreter=interpreter, script_name=script_name, iterations=args.iterations
    )
