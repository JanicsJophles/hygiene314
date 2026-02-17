# CS314 Hygiene Linter

A simple CLI tool to check your Java code against the CS314 "Program Hygiene" guidelines.

## Installation

1. Clone this repository.
2. Open your terminal in the repo folder.
3. do this: chmod +x install.sh
4. Run the installer:
   ```bash
   ./install.sh
   ```
5. Restart your terminal (or run the `source` command as instructed).

## Usage

Navigate to any directory containing your assignment's `.java` files and run:

```bash
cs314
```

This will scan all Java files in the current folder and report any style violations.

### Ignoring Files
To skip specific files (like tests), create a `.lintignore` file in your assignment directory and list the filenames to exclude, one per line.

## How It Works

- **`install.sh`**: Downloads the official Checkstyle JAR and adds a `cs314` alias to your shell configuration.
- **`lint.py`**: The script that runs when you type `cs314`. It finds your Java files and executes Checkstyle on them.
- **`cs314_checks.xml`**: Contains the specific hygiene rules (e.g., max 25 lines per method, no `break`/`continue` statements, no magic numbers).
