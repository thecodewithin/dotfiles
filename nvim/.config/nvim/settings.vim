" =============================================================================
" NEOVIM CONFIGURATION
" Adapted from thecodewithin's .vimrc
" Place this file at: ~/.config/nvim/init.vim
"
" Folds:
" vim: fdm=marker foldenable sw=2 ts=2 sts=2
" "zo" to open folds, "zc" to close, "zn" to disable
" =============================================================================

" Before launching NeoVim, make sure the undo directory exists:
"   mkdir -p ~/.config/nvim/undodir

" =============================================================================
" Environment Variables {{{
" =============================================================================
" $RTP points to the first entry in NeoVim's runtimepath (~/.config/nvim)
let $RTP = split(&runtimepath, ',')[0]

" NeoVim config file lives here — updated from the original ~/.vim/vimrc path
let $NVIMRC = "$HOME/.config/nvim/init.vim"

" Uncomment and update this if you use a keywordprg directory:
"let $KP_DIR = "$HOME/profile.d/util/vim/keywordprg"
" }}}

" =============================================================================
" Core Options {{{
" =============================================================================

" Source a local config file in the current directory when opening a project.
" NOTE: In NeoVim 0.9+, this reads .nvim.lua, .nvimrc, or .exrc — not .vimrc.
" Create a .nvimrc or .exrc file in your project root for per-project settings.
set exrc

" Force block cursor in all modes (NeoVim defaults to changing cursor shape)
set guicursor=

" Do not highlight all search matches — only highlight while searching (incsearch)
set nohlsearch

" Allow switching away from a modified buffer without saving it first
set hidden

" No error bells
set noerrorbells

" Tab display width = 2 spaces; softtabstop controls backspace behaviour
set tabstop=2 softtabstop=2

" Indent step = 2 spaces
set shiftwidth=2

" Open files with folds at level 2 (deeper folds are closed by default)
set foldlevelstart=2

" Insert spaces when Tab is pressed (not a literal tab character)
set expandtab

" Use smart context-aware indenting
set smartindent

" Do not wrap long lines at the screen edge — scroll horizontally instead
" Use `set wrap` in a specific buffer if you want wrapping there
set nowrap

" No swap file — avoids cluttering your filesystem with .swp files
set noswapfile

" No backup files — you have undofile and git for history
set nobackup

" Persistent undo: save undo history to disk so it survives across sessions.
" IMPORTANT: create this directory first — run: mkdir -p ~/.config/nvim/undodir
set undodir=~/.config/nvim/undodir
set undofile

" Show search matches as you type each character
set incsearch

" Enable 24-bit true colour in the terminal
set termguicolors

" Keep at least 5 lines visible above and below the cursor when scrolling
set scrolloff=5

" Keep at least 10 characters visible to the left/right of the cursor
set sidescrolloff=10

" Do not show -- INSERT -- / -- VISUAL -- in the command line
" (your statusline plugin will handle this)
set noshowmode

" Completion menu behaviour: show menu even for one match, don't auto-insert,
" don't auto-select
set completeopt=menuone,noinsert,noselect

" Always show the sign column (used by linters, git signs, diagnostics)
" Deduplicated — appeared twice in the original vimrc
set signcolumn=yes

" Darker background colour theme hint
set background=dark

" Column 80 marker — helps keep lines readable
" The visual guide sits at column 80; text past it is a warning to break the line
set colorcolumn=80
highlight ColorColumn ctermbg=235 guibg=#151515

" Two lines of space for command/message display — prevents the "Press Enter" prompt
set cmdheight=2

" Reduce the CursorHold delay to 50ms (default is 4000ms).
" Plugins like LSP and git-signs use this event to trigger updates.
set updatetime=50

" Enable filetype detection, filetype plugins, and automatic indenting
filetype plugin indent on

" Enable syntax highlighting
" (NeoVim enables this by default, but explicit is fine)
syntax on

" Typing behaviour
" Allow backspace to delete across indents, line breaks, and insert-start
set backspace=indent,eol,start
" Briefly highlight the matching bracket when you type a closing one
set showmatch
" Tab-complete shows the full match, cycling through options
set wildmode=full
set wildmenu

" FIXED: Original had `set complete-=1` which is a typo.
" The intended option is `complete-=i`, which removes scanning of included
" files (e.g. #include in C) from insert-mode completion — keeps it fast.
set complete-=i

" }}}

" =============================================================================
" Display & Navigation {{{
" =============================================================================

" Hybrid line numbers: show absolute number on current line, relative elsewhere
" https://jeffkreeftmeijer.com/vim-number/
set number relativenumber

" Toggle between hybrid and absolute numbers automatically:
"   - Relative when you're navigating (Normal/Visual)
"   - Absolute when you're typing (Insert) or the window loses focus
augroup NumberToggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
augroup END

" Search for a tags file starting from the current file's directory,
" walking up toward the filesystem root
set tags=./tags;,tags;

" Respect modelines at the top/bottom of files (e.g. the fold settings above)
set modelines=2
set modeline

" Add ** to path so :find searches recursively into subdirectories
set path+=**

" Treat .sh files as Bash syntax (not plain sh)
let g:is_bash = 1

" Case-insensitive search, unless you type an uppercase letter
set ignorecase smartcase

" Use grep with: no binary files, recursive, line numbers, show filename
set grepprg=grep\ -IrsnH

" Show typed command in bottom-right, show ruler, always show status line
set showcmd ruler laststatus=2

" Open vertical splits to the right of the current window
set splitright

" Treat hyphen as part of a word (e.g. my-variable is one word)
set iskeyword+=-

" }}}

" =============================================================================
" Commands {{{
" =============================================================================

" :MakeTags — generate a ctags index for the entire project
" Requires ctags to be installed: sudo apt install universal-ctags
command! MakeTags !ctags -R .

" }}}

" =============================================================================
" Plugin Settings {{{
" =============================================================================

" vim-markdown: enable syntax highlighting inside fenced code blocks
let g:markdown_fenced_languages = ['html', 'python', 'ruby', 'yaml', 'haml', 'bash=sh']

" netrw — built-in file browser (no plugin needed, ships with NeoVim)
let g:netrw_winsize    = 25   " sidebar width (%)
let g:netrw_preview    = 1    " preview opens in a vertical split
let g:netrw_banner     = 0    " hide the top banner
let g:netrw_browse_split = 2  " open files in the previous window
let g:netrw_altv       = 1    " open vertical splits to the right
let g:netrw_liststyle  = 3    " tree view

" Uncomment to hide dotfiles and gitignored files in netrw:
"let g:netrw_list_hide = netrw_gitignore#hide()
"let g:netrw_list_hide .= ',\(^\|\s\s\)\zs\.\S\+'

" NERDTree — must be installed as a plugin (same requirement as in Vim)
" Suggested: add 'preservim/nerdtree' to your plugin manager
let NERDTreeIgnore  = ['\~$', '.o$', 'bower_components', 'node_modules', '__pycache__']
let NERDTreeWinSize = 30

" }}}

" =============================================================================
" Key Mappings {{{
" =============================================================================

" Space as leader key — must be set before any <leader> mappings
let mapleader = " "

" Navigate between splits with <leader> + hjkl (no need for Ctrl-W prefix)
nnoremap <leader>h :wincmd h<CR>
nnoremap <leader>j :wincmd j<CR>
nnoremap <leader>k :wincmd k<CR>
nnoremap <leader>l :wincmd l<CR>

" Open the undo tree sidebar
" Requires the 'undotree' plugin (mbbill/undotree) — same as in Vim
nnoremap <leader>u :UndotreeShow<CR>

" Open netrw as a left-side file explorer, 30 columns wide
nnoremap <leader>pv :wincmd v<bar> :wincmd H<bar> :Ex <bar> :vertical resize 30<CR>

" Resize the current vertical split
nnoremap <silent> <Leader>+ :vertical resize +5<CR>
nnoremap <silent> <Leader>- :vertical resize -5<CR>

" }}}

" =============================================================================
" Autocommands {{{
" =============================================================================

" Strip trailing whitespace from every line on save
fun! TrimWhitespace()
  let l:save = winsaveview()       " remember cursor position
  keeppatterns %s/\s\+$//e         " delete trailing spaces (silent if none)
  call winrestview(l:save)         " restore cursor position
endfun

augroup CleanLines
  autocmd!
  autocmd BufWritePre * :call TrimWhitespace()
augroup END

" Set a file-mark when leaving certain file types.
" This lets you jump back to the last position in that file type
" with e.g. `'Y` (for YAML), `'H` (for HTML), etc.
augroup FileMarks
  autocmd!
  autocmd BufLeave *.yml      normal! mY
  autocmd BufLeave *.yaml     normal! mY
  autocmd BufLeave *.html     normal! mH
  autocmd BufLeave *.go       normal! mG
  autocmd BufLeave *.snippets normal! mS
  autocmd BufLeave *.js       normal! mJ
  autocmd BufLeave *.ts       normal! mT
  autocmd BufLeave *.vim      normal! mV
  autocmd BufLeave *.bzl      normal! mB
augroup END

" }}}
