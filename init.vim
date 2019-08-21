call plug#begin('~/.config/nvim/plugged')
Plug 'skielbasa/vim-material-monokai'
Plug 'scrooloose/nerdtree'
Plug 'xuyuanp/nerdtree-git-plugin'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'sheerun/vim-polyglot'
Plug 'terryma/vim-multiple-cursors'
Plug 'junegunn/fzf.vim'
Plug 'matze/vim-move'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'carlitux/deoplete-ternjs'
Plug 'ternjs/tern_for_vim', { 'do': 'npm install && npm install -g tern' }
Plug 'jistr/vim-nerdtree-tabs'
Plug 'scrooloose/nerdcommenter'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'w0rp/ale'
Plug 'RRethy/vim-illuminate'
Plug 'tpope/vim-surround'
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'
Plug 'posva/vim-vue'
Plug 'shime/vim-livedown'
call plug#end()

" Use deoplete.
let g:deoplete#enable_at_startup = 1
let g:python3_host_prog = '/usr/local/bin/python3'

" TernJS
let g:tern#arguments = ["--no-port-file"]

colorscheme material-monokai

syntax on
filetype plugin on
filetype indent on

hi Normal guibg=NONE ctermbg=NONE

set title
set t_Co=256
set hidden
set number
set relativenumber
set confirm
set nocompatible
set mouse=a
set inccommand=split
set nowrap
set cursorline
set encoding=utf-8
set fileencoding=utf-8
set rtp+=/usr/local/opt/fzf
set tabstop=2 shiftwidth=2 expandtab
set guioptions=
set incsearch
set ignorecase
set smartcase
set noswapfile
set list listchars=tab:»·,trail:·
set smartindent
set autoindent
set updatetime=100
set splitbelow
set splitright

let mapleader=","
nmap <leader>m :NERDTreeToggle<cr>
nmap <leader>f :Ag<cr>
nmap <leader>n :noh<cr>
nmap <leader>o :only<cr>
map <C-a> <esc>ggVG<cr>
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l
vnoremap <C-C> "+yy
vnoremap <C-V> p
map <leader>z :bp<CR>
map <leader>x :bn<CR>

" Airline
let g:airline_theme='deus'
let g:airline#extensions#tabline#enabled=1
let g:airline#extensions#ale#enabled=1
let g:ale_sign_column_always=0
let g:airline_powerline_fonts=0
if !exists('g:aiirline_symbols')
  let g:airline_symbols = {}
endif

" unicode symbols
let g:airline_left_sep = '»'
let g:airline_left_sep = '▶'
let g:airline_right_sep = '«'
let g:airline_right_sep = '◀'
let g:airline_symbols.crypt = '🔒'
let g:airline_symbols.linenr = '☰'
let g:airline_symbols.linenr = '␊'
let g:airline_symbols.linenr = '␤'
let g:airline_symbols.linenr = '¶'
let g:airline_symbols.maxlinenr = ''
let g:airline_symbols.maxlinenr = '㏑'
let g:airline_symbols.branch = '⎇'
let g:airline_symbols.paste = 'ρ'
let g:airline_symbols.paste = 'Þ'
let g:airline_symbols.paste = '∥'
let g:airline_symbols.spell = 'Ꞩ'
let g:airline_symbols.notexists = 'Ɇ'
let g:airline_symbols.whitespace = 'Ξ'

" powerline symbols
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = '☰'
let g:airline_symbols.maxlinenr = ''

" Move
let g:move_key_modifier='S'

" CTRL-P
let g:ctrlp_custom_ignore='node_modules\|DS_Store\|git|bower_components\|.git|vscode'

" Illuminate
let g:Illuminate_delay = 250
hi illuminatedWord cterm=underline gui=underline

" Vim Vue
autocmd FileType vue syntax sync fromstart


"/=== FUNCTIONS ===/
"delete the buffer; keep windows; create a scratch buffer if no buffers left
function s:Kwbd(kwbdStage)
  if(a:kwbdStage == 1)
    if(!buflisted(winbufnr(0)))
      bd!
      return
    endif
    let s:kwbdBufNum = bufnr("%")
    let s:kwbdWinNum = winnr()
    windo call s:Kwbd(2)
    execute s:kwbdWinNum . 'wincmd w'
    let s:buflistedLeft = 0
    let s:bufFinalJump = 0
    let l:nBufs = bufnr("$")
    let l:i = 1
    while(l:i <= l:nBufs)
      if(l:i != s:kwbdBufNum)
        if(buflisted(l:i))
          let s:buflistedLeft = s:buflistedLeft + 1
        else
          if(bufexists(l:i) && !strlen(bufname(l:i)) && !s:bufFinalJump)
            let s:bufFinalJump = l:i
          endif
        endif
      endif
      let l:i = l:i + 1
    endwhile
    if(!s:buflistedLeft)
      if(s:bufFinalJump)
        windo if(buflisted(winbufnr(0))) | execute "b! " . s:bufFinalJump | endif
      else
        enew
        let l:newBuf = bufnr("%")
        windo if(buflisted(winbufnr(0))) | execute "b! " . l:newBuf | endif
      endif
      execute s:kwbdWinNum . 'wincmd w'
    endif
    if(buflisted(s:kwbdBufNum) || s:kwbdBufNum == bufnr("%"))
      execute "bd! " . s:kwbdBufNum
    endif
    if(!s:buflistedLeft)
      set buflisted
      set bufhidden=delete
      set buftype=
      setlocal noswapfile
    endif
  else
    if(bufnr("%") == s:kwbdBufNum)
      let prevbufvar = bufnr("#")
      if(prevbufvar > 0 && buflisted(prevbufvar) && prevbufvar != s:kwbdBufNum)
        b #
      else
        bn
      endif
    endif
  endif
endfunction

command! Kwbd call s:Kwbd(1)
nnoremap <silent> <Plug>Kwbd :<C-u>Kwbd<CR>

