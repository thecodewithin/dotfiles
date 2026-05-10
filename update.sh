#!/usr/bin/env bash
set -euo pipefail

# -------------------------------------------------------------------
# update.sh – refresh submodules and reapply stow links
# -------------------------------------------------------------------
# Usage: ./update.sh [--skip-repo-pull]
#   --skip-repo-pull   Do not run 'git pull' on the top‑level repo.
# -------------------------------------------------------------------

# Helper function for errors
echo_err() { echo "[ERROR] $*" >&2; }

# Verify required commands
for cmd in git stow; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo_err "Required command '$cmd' not found. Install it and retry."
    exit 1
  fi
done

# Optional: pull latest changes for the dotfiles repository itself
if [[ "${1:-}" != "--skip-repo-pull" ]]; then
  echo "Pulling latest changes for the dotfiles repository…"
  git pull --ff-only
fi

# Update all plugin submodules
echo "Updating plugin submodules…"
git submodule foreach "git pull origin master"

# Re‑stow configurations (idempotent)
echo "Re‑applying stow for Vim…"
stow vim

# Re‑stow tmux configuration (defaults to $HOME)
echo "Re‑applying stow for tmux…"
stow tmux

echo "Re‑applying stow for Neovim…"
stow nvim

echo "✅ Update complete. All plugins are up‑to‑date and configuration symlinks refreshed."
