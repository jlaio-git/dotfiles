#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

# --- Configuration ---
# List of dotfiles to symlink.
# Format: "source_path_in_dotfiles:target_path_in_home"
# Example: "zshrc:.zshrc" will symlink dotfiles/zshrc to ~/.zshrc
# Example: "nvim:.config/nvim" will symlink dotfiles/nvim to ~/.config/nvim
declare -a DOTFILES_MAP=(
    "zshrc:.zshrc"
    "nvim:.config/nvim"
    "tmux:.config/tmux"
    "./applescripts/:.config/applescripts"
    "./aerospace:.config/aerospace"
)

# --- Script Logic ---

# Get the directory where this script is located.
# This allows the script to be run from anywhere.
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Function to create a symlink.
# It handles existing files by creating a backup.
create_symlink() {
    local source_file="$1"
    local target_file="$2"

    # Construct the full source path
    local full_source_path="$DOTFILES_DIR/$source_file"

    # Check if the source file exists
    if [ ! -e "$full_source_path" ]; then
        echo "ERROR: Source file $full_source_path does not exist. Skipping."
        return
    fi

    # Check if the target is already a symlink to the correct source
    if [ -L "$target_file" ] && [ "$(readlink "$target_file")" == "$full_source_path" ]; then
        echo "Symlink already exists and is correct: $target_file"
        return
    fi

    # If the target file/directory exists, create a backup
    if [ -e "$target_file" ]; then
        echo "Warning: $target_file already exists."
        read -p "Do you want to back it up and replace it? (y/n) " -n 1 -r
        echo # Move to a new line
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            mv "$target_file" "$target_file.backup"
            echo "Moved existing $target_file to $target_file.backup"
        else
            echo "Skipping $target_file."
            return
        fi
    fi

    # Create the parent directory for the target if it doesn't exist
    mkdir -p "$(dirname "$target_file")"

    # Create the symbolic link
    echo "Creating symlink: $target_file -> $full_source_path"
    ln -s "$full_source_path" "$target_file"
}

# --- Main Execution ---
echo "Installing dotfiles from $DOTFILES_DIR..."

# Loop through the map and create symlinks
for entry in "${DOTFILES_MAP[@]}"; do
    # Split the entry into source and target
    source_path="${entry%%:*}"
    target_path="${entry##*:}"

    # Expand ~ to $HOME for the target path
    full_target_path="$HOME/$target_path"

    create_symlink "$source_path" "$full_target_path"
done

echo ""
echo "Dotfile installation complete!"
echo "Any replaced files have been backed up with a .backup extension."

