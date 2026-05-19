call plug#begin()

Plug 'tpope/vim-sensible'
Plug 'joshdick/onedark.vim'
Plug 'airblade/vim-gitgutter'

call plug#end()
set relativenumber
set signcolumn=yes
set updatetime=250
set autoread

colorscheme  onedark

hi Normal guibg=NONE ctermbg=NONE
hi SignColumn guibg=NONE ctermbg=NONE
set clipboard=unnamedplus

let g:gitgutter_enabled = 1
let g:gitgutter_map_keys = 0
let g:gitgutter_realtime = 1
let g:gitgutter_eager = 1
let g:gitgutter_highlight_lines = 0
let g:gitgutter_sign_added = '│'
let g:gitgutter_sign_modified = '│'
let g:gitgutter_sign_removed = '▁'
let g:gitgutter_sign_removed_first_line = '▔'
let g:gitgutter_sign_modified_removed = '▎'
hi GitGutterAdd    guifg=#98c379 guibg=NONE ctermfg=114 ctermbg=NONE
hi GitGutterChange guifg=#61afef guibg=NONE ctermfg=75  ctermbg=NONE
hi GitGutterDelete guifg=#e06c75 guibg=NONE ctermfg=168 ctermbg=NONE
hi GitGutterChangeDelete guifg=#e5c07b guibg=NONE ctermfg=180 ctermbg=NONE

augroup codex_autoread
  autocmd!
  autocmd FocusGained,BufEnter,CursorHold,CursorHoldI * silent! checktime
augroup END

nnoremap sv :vsplit<CR><c-w>w
nnoremap ss :split<CR><c-w>w
nnoremap sf :e .<CR>
nnoremap ss :split<CR>
nnoremap te :tabedit<CR>
nnoremap <Tab> :tabnext<CR>
nnoremap <C-n> :GitGutterNextHunk<CR>
nnoremap <C-p> :GitGutterPrevHunk<CR>
nnoremap <space> <c-w>w 
