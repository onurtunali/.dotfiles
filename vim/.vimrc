syntax enable
filetype plugin on
filetype indent on

set nohidden
set nobackup
set nowritebackup
set noswapfile
set number
set encoding=utf-8
set tabstop=4 softtabstop=4
set shiftwidth=4 "indent with 4 spaces
set expandtab " tabs are spaces
set smarttab
set smartindent
set laststatus=2
set incsearch
set scrolloff=8
set colorcolumn=80
set signcolumn=yes
set undodir=~/.vim/undodir
set undofile
set splitright
let mapleader =" "

nnoremap <leader>b :call <SID>compile_and_run()<CR>
map <leader>e :Vexplore<cr>
map <F6> :setlocal spell! spelllang=en_us<CR>
noremap <Leader>t :call TrimWhitespace()<CR>

nnoremap <leader>v "+p
vnoremap <leader>c "+y
nnoremap <leader>c "+yy
"zv opens folds
"
nmap <silent> <leader>k :wincmd l<CR>
nmap <silent> <leader>j :wincmd h<CR>
nmap <silent> <leader>q :wincmd q<CR>

nnoremap Y y$
nnoremap n nzzzv
nnoremap N Nzzzv

autocmd FileType help noremap <buffer> q :q<cr>
autocmd WinEnter * if &previewwindow | noremap <buffer> q :q<cr> | endif


" Trimming trailing white space without moving cursor mapped to <leader>c
fun! TrimWhitespace()
let l:save = winsaveview()
keeppatterns %s/\s\+$//e
call winrestview(l:save)
endfun

" ========== Manage plugins with Vim-Plug ==========

call plug#begin()

" add all your plugins here

Plug 'xuhdev/vim-latex-live-preview'
Plug 'vim-airline/vim-airline'
Plug 'altercation/vim-colors-solarized'
Plug 'vim-latex/vim-latex'
Plug 'gruvbox-community/gruvbox'
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
Plug 'davidhalter/jedi-vim'

call plug#end()


" This must come after gruvbox plug-in
colorscheme gruvbox
set background=dark

hi SpellBad cterm=underline ctermfg=red

"====== LATEX Configurations ==============

autocmd Filetype tex setl updatetime=3000
let g:livepreview_previewer = 'zathura'

" Build inside vim functionality <C-b>
function! s:compile_and_run()
exec 'w'
if &filetype == 'c'
    exec "! gcc % -o %<; time ./%<"
elseif &filetype == 'cpp'
   exec "! g++ -std=c++11 % -o %<; time ./%<"
elseif &filetype == 'java'
   exec "! javac %; time java %<"
elseif &filetype == 'sh'
   exec "! time bash %"
elseif &filetype == 'python'
   exec "! time python %"
elseif &filetype == 'markdown'
   exec ":MarkdownPreview"
elseif &filetype == 'tex'
   exec ":LLPStartPreview"
endif
endfunction


"autocmd BufNewFile *.md 0r ~/.vim/templates/markdown.md  "0r means read from 0th line


let g:mkdp_auto_start = 0
let g:mkdp_auto_close = 0
let g:mkdp_refresh_slow = 0

" " mkit: markdown-it options for render
" " katex: katex options for math
" " uml: markdown-it-plantuml options
" " maid: mermaid options
" " disable_sync_scroll: if disable sync scroll, default 0
" " sync_scroll_type: 'middle', 'top' or 'relative', default value is 'middle'
" "   middle: mean the cursor position alway show at the middle of the preview
" page
" "   top: mean the vim top viewport alway show at the top of the preview page
" "   relative: mean the cursor position alway show at the relative positon of
" the preview page
" " hide_yaml_meta: if hide yaml metadata, default is 1
" " sequence_diagrams: js-sequence-diagrams options
" " content_editable: if enable content editable for preview page, default:
" v:false
let g:mkdp_preview_options = {
\ 'mkit': {},
\ 'katex': 1,
\ 'uml': {},
\ 'maid': {},
\ 'disable_sync_scroll': 0,
\ 'sync_scroll_type': 'middle',
\ 'hide_yaml_meta': 1,
\ 'sequence_diagrams': {},
\ 'flowchart_diagrams': {},
\ 'content_editable': v:false
\ }


"let g:netrw_banner = 0

" Bind F5 to save file if modified and execute python script in a buffer.
nnoremap <silent> <F5> :call SaveAndExecutePython()<CR>:wincmd h<CR>
vnoremap <silent> <F5> :call SaveAndExecutePython()<CR>
autocmd FileType python setlocal completeopt-=preview
function! SaveAndExecutePython()

    " save and reload current file
    silent execute "update | edit"

    " get file path of current file
    let s:current_buffer_file_path = expand("%")

    let s:output_buffer_name = "Python"
    let s:output_buffer_filetype = "output"

    " reuse existing buffer window if it exists otherwise create a new one
    if !exists("s:buf_nr") || !bufexists(s:buf_nr)
        silent execute 'vertical botright new ' . s:output_buffer_name
        let s:buf_nr = bufnr('%')
    elseif bufwinnr(s:buf_nr) == -1
        silent execute 'vertical botright new'
        silent execute s:buf_nr . 'buffer'
    elseif bufwinnr(s:buf_nr) != bufwinnr('%')
        silent execute bufwinnr(s:buf_nr) . 'wincmd w'
    endif

    silent execute "setlocal filetype=" . s:output_buffer_filetype
    setlocal bufhidden=delete
    setlocal buftype=nofile
    setlocal noswapfile
    setlocal nobuflisted
    setlocal winfixheight
    setlocal cursorline " make it easy to distinguish
    setlocal nonumber
    setlocal norelativenumber
    setlocal showbreak=""

    " clear the buffer
    setlocal noreadonly
    setlocal modifiable
    %delete _

    " add the console output
    silent execute ".!python " . shellescape(s:current_buffer_file_path, 1)

    " resize window to content length
    " Note: This is annoying because if you print a lot of lines then your code buffer is forced to a height of one line every time you run this function.
    "       However without this line the buffer starts off as a default size and if you resize the buffer then it keeps that custom size after repeated runs of this function.
    "       But if you close the output buffer then it returns to using the default size when its recreated
    "execute 'resize' . line('$')

    " make the buffer non modifiable
    setlocal readonly
    setlocal nomodifiable
endfunction
