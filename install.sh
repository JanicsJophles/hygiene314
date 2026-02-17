#!/bin/bash

# 1. Determine the absolute path to the directory containing this script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
JAR_NAME="checkstyle-10.13.0-all.jar"
JAR_URL="https://github.com/checkstyle/checkstyle/releases/download/checkstyle-10.13.0/${JAR_NAME}"
LINT_SCRIPT="${SCRIPT_DIR}/lint.py"

echo "Installing CS314 Hygiene Linter..."

# 2. Download Checkstyle JAR
if [ ! -f "${SCRIPT_DIR}/${JAR_NAME}" ]; then
    echo "Downloading Checkstyle 10.13.0..."
    curl -L -o "${SCRIPT_DIR}/${JAR_NAME}" "${JAR_URL}"
    if [ $? -ne 0 ]; then
        echo "Error: Failed to download Checkstyle JAR."
        exit 1
    fi
else
    echo "Checkstyle JAR already exists. Skipping download."
fi

# 3. Make the lint script executable
chmod +x "${LINT_SCRIPT}"
echo "Made lint.py executable."

# 4. Detect Shell Config and Add Alias
SHELL_CONFIG=""
case "$SHELL" in
    */zsh)
        SHELL_CONFIG="${HOME}/.zshrc"
        ;;
    */bash)
        if [ -f "${HOME}/.bash_profile" ]; then
            SHELL_CONFIG="${HOME}/.bash_profile"
        elif [ -f "${HOME}/.bashrc" ]; then
            SHELL_CONFIG="${HOME}/.bashrc"
        else
            SHELL_CONFIG="${HOME}/.bash_profile"
        fi
        ;;
    *)
        echo "Warning: Could not detect shell configuration file for $SHELL."
        echo "Please manually add the alias to your shell configuration."
        SHELL_CONFIG=""
        ;;
esac

if [ -n "${SHELL_CONFIG}" ]; then
    # logical path to lint script
    ALIAS_CMD="alias cs314=\"python3 '${LINT_SCRIPT}'\""
    
    # check if alias already exists
    if grep -q "alias cs314=" "${SHELL_CONFIG}"; then
        echo "Alias 'cs314' already exists in ${SHELL_CONFIG}. Please update it manually if needed."
    else
        echo "" >> "${SHELL_CONFIG}"
        echo "# CS314 Hygiene Linter" >> "${SHELL_CONFIG}"
        echo "${ALIAS_CMD}" >> "${SHELL_CONFIG}"
        echo "Added 'cs314' alias to ${SHELL_CONFIG}"
    fi
fi

# 5. Success Message
echo ""
echo "✅ Installation Complete!"
if [ -n "${SHELL_CONFIG}" ]; then
    echo "Please restart your terminal or run: source ${SHELL_CONFIG}"
else
    echo "Please add the following alias manually to your shell config:"
    echo "alias cs314=\"python3 '${LINT_SCRIPT}'\""
fi
echo "Usage: cs314 (in your assignment directory)"
