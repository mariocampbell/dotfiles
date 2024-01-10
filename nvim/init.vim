set rnu " Relative numbers, muestra los numero de arriba y abajo en relacion de la linea acutal
set number " Muestra los numeros ralativos a la izquierda de la terminal
set mouse=a " Permite interaccion del mouse (seleccionar texto, mover el cursor)
set numberwidth=1 " Separacion de los numeros de la izquierda con el margen 
set clipboard=unnamed " Permite interaccion con el portapapeles del sistema. Instalar xclip.
syntax on " Muetra la sintaxis
set showcmd " Habilita mostrar el historial de los ultimos comando ejecutados
set ruler " Muestra en la parte inferior en que liea esta posicionado el cursor
set cursorline " Resalta la linea actual
set nowrap " No dividir la linea si es muy larga
set encoding=utf-8 " codificacion utf-8
set showmatch " Resalta los caracteres cuando se hace una busqueda a medida que se tipea
set sw=2 " Espaciado de la tabulacion
set nocp
filetype plugin on
" set path+=** " Agregar la carpeta actual a find
" set wildignore+=**/node_module/** " ignora node_module al buscar

" Identacion a 2 espacios
set tabstop=2
set shiftwidth=2
set softtabstop=2
set shiftround
set expandtab " Insertar espacios en lugar de tabs
set foldmethod=syntax "indent

set hidden " Permitir cambiar de buffers sin tener que guardarlos

set hlsearch " highlight matches
set incsearch 
set ignorecase " Ignorar mayusculas al hacer una busqueda
set smartcase " No ignorar mayusculas si la palabra a buscar tiene mayusculas

set termguicolors " Activa true colors en la terminal
set background=dark " Fondo del tema: dark o light

set winbar=%f " Muestra el path del archivo en el buffer

" =============================== 
" PLUGINS
call plug#begin('~/.config/nvim/plugged')
  " IDE
  " Navegacion de archivos
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'junegunn/fzf.vim'
  Plug 'scrooloose/nerdtree'
  Plug 'christoomey/vim-tmux-navigator'
if exists('g:vscode')
  Plug 'asvetliakov/vim-easymotion'
else
    " ordinary neovim
  Plug 'easymotion/vim-easymotion'
endif

  " Autocompletado
  Plug 'mattn/emmet-vim'
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
  Plug 'neoclide/coc-git'
  Plug 'sheerun/vim-polyglot'
  Plug 'pangloss/vim-javascript'
  Plug 'iamcco/coc-tailwindcss',  {'do': 'yarn install --frozen-lockfile && yarn run build'}
  Plug 'neovim/nvim-lspconfig'
  Plug 'kabouzeid/nvim-lspinstall'
  Plug 'chun-yang/auto-pairs'
  Plug 'alvan/vim-closetag'
  Plug 'othree/html5.vim'
  Plug 'turbio/bracey.vim', {'do': 'npm install --prefix server'}

  "Themes
  Plug 'norcalli/nvim-colorizer.lua'
  Plug 'navarasu/onedark.nvim'
  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'
  Plug 'frazrepo/vim-rainbow'
  Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install'  }
  Plug 'sakshamgupta05/vim-todo-highlight'
  " Git
  Plug 'mhinz/vim-signify'
  Plug 'tpope/vim-fugitive'
  Plug 'tpope/vim-rhubarb'
  Plug 'junegunn/gv.vim'"
  Plug 'APZelos/blamer.nvim'
  Plug 'Xuyuanp/nerdtree-git-plugin'
  Plug 'kdheepak/lazygit.nvim'

  " Varios
  " Plug 'itchyny/vim-cursorword'
  Plug 'dominikduda/vim_current_word'
  Plug 'karb94/neoscroll.nvim'
  Plug 'Yggdroot/indentLine'
  Plug 'terryma/vim-multiple-cursors'
  Plug 'styled-components/vim-styled-components', { 'branch': 'main' }
  Plug 'wuelnerdotexe/vim-astro'

call plug#end()
" =============================== 

" =============================== 
" CONFIG PLUGINS
  " Airline
  let g:airline_theme='minimalist'
  let g:airline#extensions#tabline#enabled = 1 " Mostrar las tabs de buffers
  let g:airline#extensions#tabline#formatter = 'unique_tail' " default | jsformatter | unique_tail | unique_tail_improved
  
  " Indent blankline
  let g:indent_blankline_char='|'
  " let g:indent_blankline_char_list=['|', '1', '0', '2']
  
  " Nerdtree
  let NERDTreeQuitOnOpen=1
  " enable line numbers
  let NERDTreeShowLineNumbers=1
  " make sure relative line numbers are used
  autocmd FileType nerdtree setlocal relativenumber

  let g:NERDTreeGitStatusIndicatorMapCustom = {
                  \ 'Modified'  :'✹',
                  \ 'Staged'    :'✚',
                  \ 'Untracked' :'✭',
                  \ 'Renamed'   :'➜',
                  \ 'Unmerged'  :'═',
                  \ 'Deleted'   :'✖',
                  \ 'Dirty'     :'-',
                  \ 'Ignored'   :'☒',
                  \ 'Clean'     :'✔︎',
                  \ 'Unknown'   :'?',
                  \ }
  
  " Kite
  let g:kite_supported_languages = ['*'] " Python, JavaScript, Go
  
  " coc
  autocmd FileType javascript let b:coc_suggest_disable=0
  autocmd FileType scss setl iskeyword+=@-@

  let g:coc_global_extensions = ['coc-tsserver', 'coc-eslint', 'coc-json']
  "inoremap <silent><expr> <TAB> coc#pum#visible() ? coc#pum#confirm() : \<C-g>u\<TAB>"
  " Use tab for trigger completion with characters ahead and navigate.
  " NOTE: There's always complete item selected by default, you may want to enable
  " no select by `"suggest.noselect": true` in your configuration file.
  " NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
  " other plugin before putting this into your config.
  inoremap <silent><expr> <TAB>
        \ coc#pum#visible() ? coc#pum#next(1) :
        \ CheckBackspace() ? "\<Tab>" :
        \ coc#refresh()
  inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"
  
  " Make <CR> to accept selected completion item or notify coc.nvim to format
  " <C-g>u breaks current undo, please make your own choice.
  inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                                \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

  "coc-config
  "{
  "eslint.autoFixOnSave': true,
  "javascript.suggest.autoImports": true, 
  "typescript.suggest.autoImports": true
  "}
  
  " rainbow
  let g:rainbow_active = 1

  " Colorizer
  let g:ColorizerAttachToBuffer = 1
  let g:ColorizerToggle = 1

  " theme onedark
let g:onedark_config = {
  \ 'style': 'cool',
  \ 'ending_tildes': v:true,
  \ 'italic': {
    \ 'comment': v:true
    \ },
  \ 'transparent': {
    \ 'background': v:false
    \ },
  \ 'diagnostics': {
    \ 'darker': v:true,
    \ 'background': v:true,
  \ },
\ }
colorscheme onedark

  " let g:onedark_style = 'cool' " darker | cool | deep | warm | warmer
  " let g:onedark_transparent_background = 1 " By default it is 0
  " let g:onedark_italic_comment = 1 " By default it is 1
  " let g:onedark_diagnostics_darker = 1
  
  let g:onedark_hide_endofbuffer=1
  let g:onedark_termcolors=256
  let g:onedark_terminal_italics=1

  " Astro
  let g:astro_typescript = 'enable'
  let g:astro_stylus = 'enable'

  "blamer (gitlens)
  let g:blamer_enabled = 0
  let g:blamer_delay = 500 " default 1000
  
" MAPS
  " Navegacion de archivos
  let mapleader=" "
  
  " nerdtree
  nmap <Leader>nt :NERDTreeFind<CR>

  "lazigit
  nmap <Leader>lg :LazyGit<CR>
  
  " GoTo code navigation.
  nmap <silent> gd <Plug>(coc-definition)
  nmap <silent> gy <Plug>(coc-type-definition)
  nmap <silent> gi <Plug>(coc-implementation)
  nmap <silent> gr <Plug>(coc-references)
  nmap <silent> sd <Plug>(coc-documentation)

  nnoremap <silent>K :call CocActionAsync('doHover')<CR>

  " atajos de vim
  nnoremap <esc><esc> :noh<return><esc>

  " highlight search config
  hi Search guifg=#cce7f4 guibg=#0088CC
  
  " Neovide configs
  if exists("g:neovide")
    let g:neovide_transparency=0.96
    let g:neovide_hide_mouse_when_typing = v:true
    let g:neovide_floating_blur_amount_x=5.0
    let g:neovide_floating_blur_amount_y=5.0
    let g:neovide_floating_opacity=0.8
    " let g:neovide_fullscreen=v:false
    let g:neovide_input_use_logo=v:true  " v:true on macOS
  endif

  " Vim current word
  hi CurrentWord gui=underline
  hi CurrentWordTwins guibg=#444444

  " Twins of word under cursor:
  let g:vim_current_word#highlight_twins = 1
  " The word under cursor:
  let g:vim_current_word#highlight_current_word = 1

  let g:vim_current_word#highlight_only_in_focused_window = 0

  " Lazygit 
  let g:lazygit_floating_window_winblend = 0 " transparency of floating window
  let g:lazygit_floating_window_scaling_factor = 0.9 " scaling factor for floating window
  let g:lazygit_floating_window_corner_chars = ['?', '?', '?', '?'] " customize lazygit popup window corner characters
  let g:lazygit_floating_window_use_plenary = 0 " use plenary.nvim to manage floating window if available
  let g:lazygit_use_neovim_remote = 1 " fallback to 0 if neovim-remote is not installed
 " =============================== 
