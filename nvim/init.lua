-- =============================================================================
-- NEOVIM init.lua
-- Plugin manager: lazy.nvim
-- Plugins: catppuccin, telescope, treesitter, NERDTree, vim-markdown
-- =============================================================================
--
-- ⚠️  IMPORTANT — READ BEFORE INSTALLING
-- NeoVim will error on startup if BOTH init.lua and init.vim exist.
-- You must rename your existing init.vim before using this file:
--
--   mv ~/.config/nvim/init.vim ~/.config/nvim/settings.vim
--
-- Then add this line near the top of THIS file (after the mapleader line):
--
--   vim.cmd("source ~/.config/nvim/settings.vim")
--
-- That way, all your existing options, keymaps and autocommands
-- stay active while lazy.nvim manages your plugins from init.lua.
--
-- =============================================================================

-- -----------------------------------------------------------------------------
-- STEP 1: Leader key
-- Must be set BEFORE lazy.nvim loads, so plugin keymaps inherit it correctly.
-- If you set this after require("lazy").setup(), leader-based plugin keys break.
-- -----------------------------------------------------------------------------
vim.g.mapleader      = " "
vim.g.maplocalleader = "\\"
vim.o.autoread = true  -- automatically reload modified files

-- -----------------------------------------------------------------------------
-- STEP 2: Source your existing settings
-- Uncomment the line below after renaming init.vim to settings.vim.
-- -----------------------------------------------------------------------------
-- vim.cmd("source " .. vim.fn.stdpath("config") .. "/settings.vim")
vim.cmd("source ~/.config/nvim/settings.vim")

-- -----------------------------------------------------------------------------
-- STEP 3: Bootstrap lazy.nvim
-- This block checks if lazy.nvim is already installed. If not, it clones it
-- from GitHub automatically. You never need to install it manually.
-- lazy.nvim lives in NeoVim's data dir (~/.local/share/nvim/lazy/lazy.nvim),
-- NOT in your config dir — keeping config and data cleanly separated.
-- -----------------------------------------------------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not (vim.uv or vim.loop).fs_stat(lazypath) then
  -- lazy.nvim is not yet installed — clone it now
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({
    "git", "clone",
    "--filter=blob:none",   -- partial clone: skip blobs, only get what's needed
    "--branch=stable",      -- pin to the latest stable release
    lazyrepo,
    lazypath,
  })
  -- Abort with a clear error if the clone failed (no network, no git, etc.)
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out,                            "WarningMsg" },
      { "\nPress any key to exit...",   "" },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end

-- Add lazy.nvim to NeoVim's runtime path so it can be required
vim.opt.rtp:prepend(lazypath)

-- -----------------------------------------------------------------------------
-- STEP 4: Plugin specifications
-- Each plugin is a Lua table. The first string is the GitHub "owner/repo".
-- lazy.nvim reads these specs and installs/loads plugins accordingly.
-- Run :Lazy inside NeoVim to open the plugin manager UI.
-- -----------------------------------------------------------------------------
require("lazy").setup({

  -- ===========================================================================
  -- COLORSCHEME — catppuccin
  -- https://github.com/catppuccin/nvim
  --
  -- priority = 1000 ensures this loads before all other plugins, so the
  -- colorscheme is applied first and other plugins inherit the correct colours.
  --
  -- ⚠️  BREAKING CHANGE NOTE (catppuccin recent release):
  -- The colorscheme name is now "catppuccin-nvim" (not "catppuccin").
  -- NeoVim 0.12+ ships a built-in catppuccin that uses the "catppuccin" name,
  -- which would conflict. The plugin name remains "catppuccin/nvim" in the spec.
  --
  -- Flavours available: latte (light), frappe, macchiato, mocha (darkest)
  -- ===========================================================================
  {
    "catppuccin/nvim",
    name     = "catppuccin",   -- local alias used by other plugins' integrations
    priority = 1000,           -- load before everything else
    config   = function()
      require("catppuccin").setup({
        flavour = "mocha",     -- darkest flavour, pairs well with dark terminals

        -- As of catppuccin v2.0, these integrations are enabled by default
        -- and no longer need to be listed manually:
        --   treesitter, native_lsp, semantic_tokens, markdown
        --
        -- auto_integrations detects your installed plugins and enables their
        -- catppuccin support automatically — no manual list needed.
        auto_integrations = true,
        -- translparent_background = true,
        color_overrides = {
          mocha = {
            base   = "#000000",  -- main background
            mantle = "#000000",  -- slightly darker surfaces (statusline, etc.)
            crust  = "#000000",  -- darkest surfaces (borders, etc.)
          },
        },

        styles = {
          comments    = { "italic" },
          conditionals = { "italic" },
          functions   = {},
          keywords    = {},
          strings     = {},
          variables   = {},
        },
      })

      -- Apply the colorscheme.
      -- Use "catppuccin-nvim" to avoid conflict with NeoVim's built-in scheme.
      -- You can also use: catppuccin-latte, catppuccin-frappe, catppuccin-macchiato
      vim.cmd.colorscheme("catppuccin-nvim")
    end,
  },

  -- ===========================================================================
  -- FUZZY FINDER — telescope.nvim
  -- https://github.com/nvim-telescope/telescope.nvim
  --
  -- Telescope is a highly extensible fuzzy-finder UI.
  -- It lets you search files, buffers, grep results, git history, and more.
  --
  -- Dependencies:
  --   plenary.nvim        — Lua utility library, required by telescope
  --   telescope-fzf-native — compiled C sorter, makes results much faster
  --
  -- ⚠️  telescope-fzf-native requires a C compiler and `make` on your system:
  --   sudo apt install build-essential
  -- If you don't have these, remove the fzf-native block — telescope still works
  -- without it, just slightly slower on large projects.
  --
  -- Key bindings defined below (under keys):
  --   <leader>ff  — find files
  --   <leader>fg  — live grep (search inside files)
  --   <leader>fb  — open buffers
  --   <leader>fh  — help tags
  -- ===========================================================================
  {
    "nvim-telescope/telescope.nvim",
    version      = "*",           -- pin to latest stable release tag
    cmd          = "Telescope",   -- lazy-load: only load when :Telescope is called
    dependencies = {
      "nvim-lua/plenary.nvim",    -- required Lua utilities

      -- Optional but strongly recommended: native FZF sorter (much faster)
      -- Requires: sudo apt install build-essential
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",           -- compiles the C extension on install
      },
    },

    -- keys: lazy.nvim loads telescope only when one of these is pressed
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<cr>",  desc = "Find Files" },
      { "<leader>fg", "<cmd>Telescope live_grep<cr>",   desc = "Live Grep" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>",     desc = "Buffers" },
      { "<leader>fh", "<cmd>Telescope help_tags<cr>",   desc = "Help Tags" },
      { "<leader>fr", "<cmd>Telescope oldfiles<cr>",    desc = "Recent Files" },
    },

    config = function()
      local telescope = require("telescope")

      telescope.setup({
        defaults = {
          -- Use ripgrep (rg) as the grep backend — faster than system grep
          -- Install with: sudo apt install ripgrep
          -- Telescope falls back gracefully if rg is not installed.
          vimgrep_arguments = {
            "rg", "--color=never", "--no-heading",
            "--with-filename", "--line-number",
            "--column", "--smart-case",
          },
          -- Open the file preview on the right side
          layout_config = {
            horizontal = { preview_width = 0.55 },
          },
        },
      })

      -- Load the fzf extension for faster sorting (only if it compiled)
      pcall(telescope.load_extension, "fzf")
      -- pcall = "protected call" — if fzf-native wasn't compiled, this fails
      -- silently instead of crashing NeoVim on startup
    end,
  },

  -- ===========================================================================
  -- SYNTAX — nvim-treesitter
  -- https://github.com/nvim-treesitter/nvim-treesitter
  --
  -- Treesitter provides context-aware, accurate syntax highlighting by actually
  -- parsing your code (rather than using regex patterns like classic Vim syntax).
  -- It also powers smarter indenting and code folding.
  --
  -- lazy = false: treesitter MUST NOT be lazy-loaded — the treesitter docs
  -- explicitly state this plugin does not support lazy-loading.
  --
  -- build = ":TSUpdate": keeps all installed language parsers up to date
  -- whenever the plugin itself is updated. Run manually with :TSUpdate.
  --
  -- ensure_installed: these parsers will be downloaded and installed on first
  -- launch. Add or remove languages as needed.
  -- Full list of supported languages: :TSInstallInfo
  -- ===========================================================================
  {
    "nvim-treesitter/nvim-treesitter",
    lazy  = false,          -- do not lazy-load (required by treesitter)
    build = ":TSUpdate",    -- update parsers when the plugin updates
    priority = 100,         -- load early among plugins, but after colorscheme

    -- ⚠️  Use config = function() not opts = {}
    -- Treesitter must be configured by calling require("nvim-treesitter.configs").setup()
    -- Using opts alone does NOT call that function, so ensure_installed won't work.
    config = function()
      require("nvim-treesitter").setup({

        -- Languages to install automatically on first launch
        ensure_installed = {
          "bash",
          "go",
          "html",
          "javascript",
          "json",
          "lua",
          "markdown",
          "markdown_inline",   -- inline code inside markdown
          "python",
          "ruby",
          "typescript",
          "vim",               -- Vimscript (for your init.vim / plugins)
          "vimdoc",            -- NeoVim help docs
          "yaml",
        },

        -- sync_install = false,  -- install parsers in the background (async)
        -- auto_install = false,  -- don't auto-install unknown parsers on file open

        highlight = {
          enable = true,       -- replace Vim's regex syntax with treesitter
        },

        indent = {
          enable = true,       -- treesitter-based indenting (experimental)
        },
      })
    end,
  },

  -- ===========================================================================
  -- FILE TREE — NERDTree
  -- https://github.com/preservim/nerdtree
  --
  -- Classic sidebar file explorer. Your existing keymaps from init.vim
  -- (<leader>u for undotree, <leader>pv for netrw) are unaffected.
  -- Your NERDTree config variables (NERDTreeIgnore, NERDTreeWinSize) from
  -- init.vim will still apply if you source that file from init.lua.
  --
  -- Open/close with :NERDTreeToggle or the keymap below (<leader>n).
  -- ===========================================================================
  {
    "preservim/nerdtree",
    cmd  = { "NERDTree", "NERDTreeToggle", "NERDTreeFind" }, -- lazy-load on command
    keys = {
      { "<leader>n", "<cmd>NERDTreeToggle<cr>", desc = "Toggle NERDTree" },
    },
    init = function()
      -- These are Vimscript global variables — set them with vim.g in Lua.
      -- They match the settings from your original vimrc.
      vim.g.NERDTreeIgnore   = { "\\~$", "\\.o$", "bower_components", "node_modules", "__pycache__" }
      vim.g.NERDTreeWinSize  = 30
      vim.g.NERDTreeShowHidden = 1   -- show dotfiles (toggle with I inside NERDTree)
    end,
  },

  -- ===========================================================================
  -- MARKDOWN — vim-markdown
  -- https://github.com/preservim/vim-markdown
  --
  -- Provides better Markdown syntax support including:
  --   - fenced code block highlighting (using treesitter languages)
  --   - folding, concealing, TOC generation (:Toc)
  --   - header navigation with ]] and [[
  --
  -- The fenced language list matches your original vimrc setting.
  -- ===========================================================================
  {
    "preservim/vim-markdown",
    ft   = { "markdown" },    -- lazy-load: only when opening a .md file
    init = function()
      -- Enable syntax highlighting inside fenced code blocks.
      -- These are Vimscript globals — must use vim.g in Lua.
      vim.g.markdown_fenced_languages = {
        "html", "python", "ruby", "yaml", "haml", "bash=sh",
      }

      -- Optional quality-of-life settings for vim-markdown:
      vim.g.vim_markdown_folding_disabled = 1   -- disable markdown folding
                                                 -- (treesitter handles folding)
      vim.g.vim_markdown_conceal          = 0   -- show raw markdown syntax
      vim.g.vim_markdown_frontmatter      = 1   -- highlight YAML front matter
    end,
  },

  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    },
    keys = {
      {
        "<leader>H",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer Local Keymaps (which-key)",
      },
    },
  },

  -- Undo history visualiser
  { "mbbill/undotree",
    cmd  = "UndotreeToggle",
    keys = { { "<leader>u", "<cmd>UndotreeToggle<cr>", desc = "Undo Tree" } },
  },

  -- Ansible filetype support (remove if you don't write Ansible)
  { "pearofducks/ansible-vim",
    ft = { "yaml", "yaml.ansible" },
  },

  -- JSON text objects and pretty-printing (remove if you don't use JSON)
  { "tpope/vim-jdaddy",
    ft = { "json" },
  },

  -- Required by vim-surround — makes . repeat plugin actions
  { "tpope/vim-repeat" },

  -- Surround text objects: cs, ds, ys
  { "tpope/vim-surround" },

  -- opencode chat interface
  {
    "sudo-tee/opencode.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      -- Optional: For completion
      -- "saghen/blink.cmp", -- or
      -- "hrsh7th/nvim-cmp",
      -- Optional: For file picker
      "folke/snacks.nvim", -- or "nvim-telescope/telescope.nvim"
    },
    config = function()
      require("opencode").setup({
        ui = {
          icons = {
            preset = 'text', --switch all icons to text
          },
        },
        -- Default configuration options
        default_global_keymaps = true,
        keymap_prefix = "<leader>o",
      })
    end,
  },

  -- ===========================================================================
  -- Add more plugins here following the same pattern:
  --   { "owner/repo", ... }
  -- ===========================================================================

}, {
  -- ===========================================================================
  -- 1
  -- lazy.nvim global options
  -- ===========================================================================
  install = {
    -- Colorscheme to use while plugins are being installed for the first time.
    -- habamax is a built-in NeoVim theme — safe to use before catppuccin loads.
    colorscheme = { "habamax" },
  },

  checker = {
    enabled = true,   -- automatically check for plugin updates in the background
    notify  = false,  -- don't show a notification on every startup
                      -- check manually with :Lazy update
  },

  ui = {
    -- Border style for the lazy.nvim UI window
    border = "rounded",
  },

  rocks = {
    enabled = false, -- disable luarocks, we don't need it
  },
})
