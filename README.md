# Dotfiles Repository

A personal collection of Vim, NeoVim and Tmux configuration files managed with GNU stow. The repository also bundles a curated set of Vim plugins as Git submodules.

---

## Repository Layout

```
.
├─ .gitignore              # Ignored generated files (undo history, lazy-lock, …)
├─ AGENTS.md               # Short OpenCode instructions (already present)
├─ README.md               # Short collection description
├─ install.sh              # One‑click bootstrap script (see below)
├─ update.sh               # Refresh plugins and re‑apply stow links
├─ vim/                    # Vim runtime files (vimrc, plugin configs, …)
│   └─ .undodir/.gitkeep   # placeholder to keep undo dir tracked
├─ nvim/                   # Neovim configuration (lives under nvim/.config/nvim)
│   └─ undodir/.gitkeep    # placeholder to keep undo dir tracked
├─ tmux/                   # Tmux configuration
└─ submodules/             # Third‑party Vim plugins added as git submodules
```

* `vim/` → symlinked into `$HOME`.
* `nvim/` → symlinked into `$HOME` (the config lives under `nvim/.config/nvim`).
* `tmux/` → symlinked into `$HOME`.
* All plugins live under `submodules/` and are version‑controlled via Git submodules.

---

## Quick Start (One‑Command Bootstrap)

```bash
# Clone the repository into $HOME/.dotfiles
git clone https://github.com/<your-username>/dotfiles.git "$HOME/.dotfiles"

# Enter the repo and run the installer
cd "$HOME/.dotfiles"
./install.sh
```

The installer will:
1. Initialise every submodule (plugins).
2. Stow the Vim config into `$HOME`, the Neovim config into `$HOME`, and the tmux config into `$HOME`.

After it finishes, your `$HOME` should contain the expected symlinks (e.g., `~/.vimrc`, `~/.vim/`, `~/.undodir`, `~/.tmux.conf`, `~/.tmux/` and `~/.config/nvim/`).

---

## Manual Installation (If You Prefer Explicit Commands)

```bash
# 1 Initialise submodules (plugins)
git submodule update --init --recursive

# 2 Stow Vim configuration
stow vim

# 3 Stow NeoVim configuration
stow nvim

# 4 Stow Tmux configuration
stow tmux
```

---

## Updating Your Dotfiles

To pull the latest changes for both the repository itself and all plugin submodules, run:

```bash
./update.sh
```

If you only want to refresh the submodules without pulling a new commit of the dotfiles repo (e.g., when you have local uncommitted changes), use:

```bash
./update.sh --skip-repo-pull
```

---

## Adding a New Plugin

1. Add the plugin as a git submodule under `submodules/`:
   ```bash
   git submodule add <plugin-git-url> submodules/<plugin-name>
   ```
2. Re‑run the installer or simply stow again:
   ```bash
   ./install.sh   # or `stow vim && stow nvim && stow tmux`
   ```

The submodule will be tracked automatically and updated via `./update.sh`.

---

## Prerequisites

- Git – to clone the repo and manage submodules.
- GNU stow – the symlink manager. Install with your OS package manager, for example:
  - macOS: `brew install stow`
  - Ubuntu/Debian: `sudo apt-get install stow`
  - Arch Linux: `sudo pacman -S stow`

---

## License

The top‑level `LICENSE` file applies to the dotfiles themselves. Each plugin submodule retains its own license (see the plugin’s README inside `submodules/`).

---

## Contributing

1. Fork the repository.
2. Make your changes (e.g., edit files under `vim/`, `nvim/` or `tmux/`, or add a new plugin submodule).
3. Run `./install.sh` locally to verify that everything links correctly.
4. Commit the changes and open a Pull Request.

---

## Troubleshooting

- `stow` command not found – Install GNU stow via your package manager.
- Symlink conflicts – Remove any stray files that clash with the expected links before re‑running `install.sh`.

---

Enjoy a clean, reproducible development environment!

