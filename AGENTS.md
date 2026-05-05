**AGENTS.md – Repository Quick‑Start**

- **Initialize submodules**
  ```bash
  git submodule update --init --recursive   # pull all plugin submodules
  ```
- **Apply configuration** (GNU stow)
  ```bash
  stow vim                     # symlinks ./vim into $HOME
  mkdir -p "$HOME/.config/nvim"   # ensure target exists
  stow -t "$HOME/.config/nvim" nvim  # symlinks ./nvim into $HOME/.config/nvim
  ```
- **Adding new plugins** – add them as git submodules under `submodules/`; run the init command above on fresh clones.
- **Updating plugins**
  ```bash
  git submodule foreach git pull origin master
  ```
- **No build / test / lint steps** – the repo is pure configuration.
- **Licensing** – top‑level `LICENSE` applies to dotfiles; each plugin retains its own license (see each submodule’s README).
