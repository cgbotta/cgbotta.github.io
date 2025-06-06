#!/bin/bash

set -e

echo "Ensuring submodules are initialized and updated..."
git submodule update --init
git submodule update --remote

# Navigate to the submodule directory
SUBMODULE_DIR=".submodule/scholar-collector"
if [ -d "$SUBMODULE_DIR" ]; then
    echo "Navigating to submodule directory: $SUBMODULE_DIR"
    cd "$SUBMODULE_DIR"
else
    echo "Error: Submodule directory '$SUBMODULE_DIR' does not exist."
    exit 1
fi

# Run the Python script with the specified path
SCRIPT="collect_publications.py"
TARGET_PATH="../../content/publications/"

if [ -f "$SCRIPT" ]; then
    echo "Executing $SCRIPT with path $TARGET_PATH"
    # Check if we have a virtual environment in the user's scholar-collector directory
    USER_VENV="/Users/coltonbotta/Documents/Development/Personal Website/scholar-collector/venv"
    if [ -d "$USER_VENV" ]; then
        echo "Using virtual environment from scholar-collector directory"
        source "$USER_VENV/bin/activate"
        python3 "$SCRIPT" "$TARGET_PATH"
        deactivate
    else
        echo "No virtual environment found, trying with system Python"
        python3 "$SCRIPT" "$TARGET_PATH"
    fi
else
    echo "Error: Script '$SCRIPT' not found in the submodule directory."
    exit 1
fi
