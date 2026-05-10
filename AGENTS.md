**AGENTS.md – Repository Quick‑Start**

- **Initialize submodules**
  ```bash
  git submodule update --init --recursive   # pull all plugin submodules
  ```
- **Apply configuration** (GNU stow)
  - Run `./install.sh` for a full bootstrap (initialises submodules, stows Vim, Neovim, and tmux configs directly to `$HOME`).
  - Run `./update.sh` to refresh plugins and re‑apply stow links.
  ```bash
  stow vim                     # symlinks ./vim into $HOME
  stow nvim                    # symlinks Neovim config directly to $HOME
  stow tmux                    # symlinks tmux config directly to $HOME
  ```
- **Undo directories** – `vim/.undodir/` and `nvim/.undodir/` are tracked (contain a `.gitkeep` file) so they are created on clone, but all other files inside them are ignored via `.gitignore`.
- **Adding new plugins** – add them as git submodules under `submodules/`; run the init command above on fresh clones.
- **Updating plugins**
  ```bash
  git submodule foreach git pull origin master
  ```
- **No build / test / lint steps** – the repo is pure configuration.
- **Licensing** – top‑level `LICENSE` applies to dotfiles; each plugin retains its own license (see each submodule’s README).
