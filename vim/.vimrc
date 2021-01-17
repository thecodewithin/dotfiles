" VIMRC
" thecodewithin's .vimrc file

" Folds:
" vim: fdm=marker foldenable sw=2 ts =2, sts=2
" "zo" to open folds, "zc" to close, "zn" to disable

" Environment Variables {{{
let $RTP=split(&runtimepath, ',')[0]
let $VIMRC="$HOME/.vim/vimrc"
"let $KP_DIR="$HOME/profile.d/util/vim/keywordprg"
" }}}

" Vim options {{{
" Source a .vimrc file in the current directory when "vim ."
set exrc
" Block cursor
set guicursor=
" No highlight search
set nohlsearch
" Keep buffers arround in the background, just in case
set hidden
"
set noerrorbells
" Number of characters for tabs, tabs are spaces
set tabstop=2 softtabstop=2
" Number of characters for indent
set shiftwidth=2
" Number of folds at opening
set foldlevelstart=2
" Convertts tabs to spaces
set expandtab
" Improved indenting
set smartindent
" Do not wrap the text at the end of the screen
" use `set wrap` in your buffer if needed
set nowrap
" Do not keep a swap file
set noswapfile
" Do not make backups
set nobackup
" Save the undo file in this dir
set undodir=~/.vim/undodir
" Keep an undo file
set undofile
" highlight results as you type
set incsearch
"
set termguicolors
" Keep a few lines on top of (and below) the cursor as you scroll
set scrolloff=5
" Keep a few characters of horizontal buffer as you scroll
set sidescrolloff=10
"
set noshowmode
"
set completeopt=menuone,noinsert,noselect
" Add an extra column for linting
set signcolumn=yes
" Improve contrast on dark backgrounds
set background=dark

" Mark column 80 to help keep your code readable
" text text text text text text text text text text text text text text text text text text text text text
" ColorColumn
set colorcolumn=80
highlight ColorColumn ctermbg=235 guibg=#151515
" highlight ColorColumn ctermbg=red ctermfg=blue
" call matchadd('ColorColumn', '\%81v',100)
" let &colorcolumn=join(range(81,999),",")
" highlight ColorColumn ctermbg=235 guibg=#0B0B0B

" extra column at the left for signals
set signcolumn=yes

" More space for message display
set cmdheight=2

" Default updatetime is too high at 4000ms
set updatetime=50

filetype plugin indent on
syntax on

" Typing behavior
set backspace=indent,eol,start
set showmatch
set wildmode=full
set wildmenu
set complete-=1

" Hybrid line numbers
" https://jeffkreeftmeijer.com/vim-number/
set number relativenumber
" togle hybrid line numbers
:augroup numbertoggle
:  autocmd!
:  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
:  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
:augroup END
"
" Find tags relative to current file and directory
set tags=./tags;,tags;

" Modelines
set modelines=2
set modeline

" Tab-completion for file-related tasks
"set path =.,**
set path+=**

" Bash syntax for sh files
let g:is_bash=1

" Search
set ignorecase smartcase
set grepprg=grep\ -IrsnH

" Window display
set showcmd ruler laststatus=2

" Splits
set splitright

" Word splitting
set iskeyword+=-

" Tag jumping
" Create the `tags` file (may need to install ctags first)
command! MakeTags !ctags -R .

" Autocomplete
" Documented in |ins-completion|

" None yet.

" }}} end vim options

" Plugin settings {{{

" vim-markdown
let g:markdown_fenced_languages = ['html', 'python', 'ruby', 'yaml', 'haml', 'bash=sh']

" netrw config
" (https://github.com/changemewtf/dotfiles/blob/master/vim/.vimrc)
let g:netrw_winsize=25					" new window size
let g:netrw_preview=1					  " vertical splitting default for preview
let g:netrw_banner=0						" disable annoying banner
let g:netrw_browse_split=2			" open in prior window
let g:netrw_altv=1							" open splits to the right
let g:netrw_liststyle=3					" tree view
" hide gitignore files
"let g:netrw_list_hide=netrw_gitignore#hide()
" hide dotfiles by default (this is the string toggled by netrw-gh)
"let g:netrw_list_hide.=',\(^\|\s\s\)\zs\.\S\+'
"let g:netrw_list_hide=',\(^\|\s\s\)\zs\.\S\+'

" nerdtree config
let NERDTreeIgnore=['\~$', '.o$', 'bower_components', 'node_modules', '__pycache__']
let NERDTreeWinSize=30

" }}} end plugin settings

" Mappings {{{
let mapleader = " "

" Easier window navigation
nnoremap <leader>h :wincmd h<CR>
nnoremap <leader>j :wincmd j<CR>
nnoremap <leader>k :wincmd k<CR>
nnoremap <leader>l :wincmd l<CR>

" Open the undo tree
nnoremap <leader>u :UndotreeShow<CR>

" Open the file navigator
nnoremap <leader>pv :wincmd v<bar> :wincmd H<bar> :Ex <bar> :vertical resize 30<CR>

" Resize the current window
nnoremap <silent> <Leader>+ :vertical resize +5<CR>
nnoremap <silent> <Leader>- :vertical resize -5<CR>

" None yet.

" }}} end mappings

" Autocommands {{{

" " Trim white space at the end of lines
" fun! TrimWhitespace()
"   let l:save = winsaveview()
"   keeppatterns %s/\s\+$//e
"   call winrestview(l:save)
" endfun

" augroup CleanLines
"   autocmd!
"   autocmd BufWritePre * :call TrimWhitespace()
" augroup END

" Create file-marks for commonly edited file types
augroup FileMarks
  autocmd!
  autocmd BufLeave *.yml normal! mY
  autocmd BufLeave *.yaml normal! mY
  autocmd BufLeave *.html normal! mH
  autocmd BufLeave *.go   normal! mG
  autocmd BufLeave *.snippets normal! mS
  autocmd BufLeave *.js   normal! mJ
  autocmd BufLeave *.ts   normal! mT
  autocmd BufLeave *.vim  normal! mV
  autocmd BufLeave *.bzl  normal! mB
augroup END

" }}} end autocommands

