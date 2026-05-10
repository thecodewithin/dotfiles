#!/usr/bin/env bash
set -euo pipefail

# -------------------------------------------------------------------
# install.sh – bootstrap this dotfiles repository
# -------------------------------------------------------------------
# This script assumes it is executed from the root of the cloned repo.
# It performs the following actions:
#   1) Initialise all git submodules (plugins).
#   2) Stow the Vim configuration (defaults to $HOME).
#   3) Stow the Neovim configuration directly to $HOME (source: nvim/.config/nvim).
#   4) Stow the tmux configuration directly to $HOME.
#   5) Print a success message.
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

# Step 2: (No explicit target directory needed – stow defaults to $HOME)
# The Neovim configuration lives under nvim/.config/nvim and will be stowed directly to $HOME.
# (No directory creation required.)

# Step 3: Stow Vim configuration (defaults to $HOME)
echo "Stowing Vim configuration…"
stow vim

# Step 4: Stow tmux configuration (defaults to $HOME)
echo "Stowing tmux configuration…"
stow tmux

# Step 4: Stow Neovim configuration directly to $HOME
echo "Stowing Neovim configuration…"
stow nvim

echo "✅ Installation complete. Your Vim and Neovim configs are now active."
