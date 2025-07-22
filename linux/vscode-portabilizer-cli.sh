#!/bin/bash

# VS Code Portabilizer CLI - Interactive command-line interface
# This script provides a user-friendly CLI wrapper for the vscode-portabilizer tool

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PORTABILIZER="$SCRIPT_DIR/vscode-portabilizer"

echo "VS Code Portabilizer - Interactive CLI"
echo "======================================"
echo

# Check if the portabilizer exists
if [ ! -f "$PORTABILIZER" ]; then
    echo "Error: vscode-portabilizer not found at: $PORTABILIZER"
    exit 1
fi

# Make sure it's executable
chmod +x "$PORTABILIZER"

echo "Available commands:"
echo "1. Create portable VS Code (auto-migrate if system installation exists)"
echo "2. Create fresh portable VS Code (no migration)"
echo "3. Upgrade an existing portable installation"
echo

read -p "Enter your choice (1-3): " choice

case $choice in
    1)
        read -p "Enter destination folder (e.g., /tmp/vscode-portable-test): " dest_folder
        if [ -z "$dest_folder" ]; then
            echo "Error: Destination folder cannot be empty"
            exit 1
        fi
        echo "Creating portable VS Code (auto-migrate if system installation exists) at: $dest_folder"
        "$PORTABILIZER" create "$dest_folder"
        ;;
    2)
        read -p "Enter destination folder (e.g., /tmp/vscode-fresh): " dest_folder
        if [ -z "$dest_folder" ]; then
            echo "Error: Destination folder cannot be empty"
            exit 1
        fi
        echo "Creating fresh portable VS Code at: $dest_folder"
        "$PORTABILIZER" create --no-migrate "$dest_folder"
        ;;
    3)
        read -p "Enter existing portable folder path: " portable_folder
        if [ -z "$portable_folder" ]; then
            echo "Error: Portable folder path cannot be empty"
            exit 1
        fi
        echo "Upgrading portable VS Code at: $portable_folder"
        "$PORTABILIZER" upgrade "$portable_folder"
        ;;
    *)
        echo "Invalid choice. Please run the script again."
        exit 1
        ;;
esac

echo
echo "Operation completed!"
