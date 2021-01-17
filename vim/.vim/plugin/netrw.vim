" netrw config
" (https://github.com/changemewtf/dotfiles/blob/master/vim/.vimrc)
let g:netrw_banner=0						" disable annoying banner
let g:netwr_browse_split=4			" open in prior window
let g:netwr_altv=1							" open splits to the right
let g:netrw_liststyle=3					" tree view
let g:netrw_winsize=25					" window size
" hide gitignore files
"let g:netrw_list_hide=netrw_gitignore#hide()
" hide dotfiles by default (this is the string toggled by netrw-gh)
"let g:netrw_list_hide.=',\(^\|\s\s\)\zs\.\S\+'
"let g:netrw_list_hide=',\(^\|\s\s\)\zs\.\S\+'
