#!/usr/bin/env bash
set -euo pipefail

# -------------------------------------------------------------------
# install.sh – bootstrap this dotfiles repository
# -------------------------------------------------------------------
# This script assumes it is executed from the root of the cloned repo.
# It performs the following actions:
#   1) Initialize all git submodules (Vim plugins).
#   2) Ensure the Neovim configuration target directory exists.
#   3) Stow the Vim and Neovim configuration using GNU stow.
#   4) Print a success message.
# -------------------------------------------------------------------

# Helper: print error and exit
echo_err() { echo "[ERROR] $*" >&2; }

# Verify required commands are available
for cmd in git stow; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo_err "Required command '$cmd' not found. Install it and retry."
    exit 1
  fi
done

# Step 1: Initialize submodules (plugins)
echo "Initializing git submodules…"
git submodule update --init --recursive

# Step 2: Create Neovim target directory if missing
NVIM_TARGET="$HOME/.config/nvim"
if [ ! -d "$NVIM_TARGET" ]; then
  echo "Creating Neovim config directory: $NVIM_TARGET"
  mkdir -p "$NVIM_TARGET"
fi

# Step 3: Stow Vim configuration (defaults to $HOME)
echo "Stowing Vim configuration…"
stow vim

# Step 4: Stow Neovim configuration into the proper target
echo "Stowing Neovim configuration…"
stow -t "$NVIM_TARGET" nvim

echo "✅ Installation complete. Your Vim and Neovim configs are now active."
