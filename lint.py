#!/usr/bin/env python3
import os
import sys
import subprocess

def main():
    # 1. Start setup
    current_dir = os.getcwd()
    script_dir = os.path.dirname(os.path.realpath(__file__))
    
    # Define paths to resources relative to this script
    checkstyle_jar = os.path.join(script_dir, "checkstyle-10.13.0-all.jar")
    checkstyle_config = os.path.join(script_dir, "cs314_checks.xml")

    # verify resources exist
    if not os.path.exists(checkstyle_jar):
        print(f"Error: Checkstyle JAR not found at {checkstyle_jar}")
        print("Please run install.sh first.")
        sys.exit(1)
    
    if not os.path.exists(checkstyle_config):
        print(f"Error: Config file not found at {checkstyle_config}")
        sys.exit(1)

    # 2. Find .java files in current directory (flat scan)
    java_files = [f for f in os.listdir(current_dir) if f.endswith(".java") and os.path.isfile(os.path.join(current_dir, f))]

    if not java_files:
        print("No .java files found in the current directory.")
        sys.exit(0)

    # 3. Check for .lintignore and filter
    lintignore_path = os.path.join(current_dir, ".lintignore")
    ignored_files = set()
    if os.path.exists(lintignore_path):
        with open(lintignore_path, "r") as f:
            for line in f:
                line = line.strip()
                if line and not line.startswith("#"):
                    ignored_files.add(line)
    
    files_to_check = [f for f in java_files if f not in ignored_files]

    if not files_to_check:
        print("All .java files are ignored via .lintignore.")
        sys.exit(0)

    # 4. Construct command
    # java -jar checkstyle.jar -c config.xml file1.java ...
    command = ["java", "-jar", checkstyle_jar, "-c", checkstyle_config] + files_to_check

    print(f"Linting {len(files_to_check)} Java file(s)...")
    
    # 5. Run command
    try:
        result = subprocess.run(command)
        if result.returncode == 0:
            print("\n✅ No hygiene issues found!")
        else:
            print("\n❌ Hygiene issues found. Please fix them.")
            sys.exit(result.returncode)
    except FileNotFoundError:
        print("Error: 'java' command not found. Is Java installed?")
        sys.exit(1)
    except KeyboardInterrupt:
        print("\nLinting cancelled.")
        sys.exit(130)

if __name__ == "__main__":
    main()
