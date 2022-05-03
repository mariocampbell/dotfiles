set rnu " Relative numbers, muestra los numero de arriba y abajo en relacion de la linea acutal
set number " Muestra los numeros ralativos a la izquierda de la terminal
set mouse=a " Permite interaccion del mouse (seleccionar texto, mover el cursor)
set numberwidth=1 " Separacion de los numeros de la izquierda con el margen 
set clipboard=unnamed " Permite interaccion con el portapapeles del sistema
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
set foldmethod=indent

set hidden " Permitir cambiar de buffers sin tener que guardarlos

set hlsearch " highlight matches
set incsearch 
set ignorecase " Ignorar mayusculas al hacer una busqueda
set smartcase " No ignorar mayusculas si la palabra a buscar tiene mayusculas

set termguicolors " Activa true colors en la terminal
set background=dark " Fondo del tema: dark o light

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

  "Themes
  "Plug 'romgrk/doom-one.vim'
  Plug 'norcalli/nvim-colorizer.lua'
  Plug 'navarasu/onedark.nvim'
  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'
  Plug 'frazrepo/vim-rainbow'
  Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install'  }
  " Git
  Plug 'mhinz/vim-signify'
  Plug 'tpope/vim-fugitive'
  Plug 'tpope/vim-rhubarb'
  Plug 'junegunn/gv.vim'"
  Plug 'APZelos/blamer.nvim'

  " Varios
  Plug 'Yggdroot/indentLine'
  Plug 'terryma/vim-multiple-cursors'
  Plug 'styled-components/vim-styled-components', { 'branch': 'main' }

call plug#end()
" =============================== 

" =============================== 
" CONFIG PLUGINS
  " Airline
  let g:airline_theme='minimalist'
  let g:airline#extensions#tabline#enabled = 1 " Mostrar las tabs de buffers
  let g:airline#extensions#tabline#formatter = 'unique_tail'
  
  " Indent blankline
  let g:indent_blankline_char='|'
  " let g:indent_blankline_char_list=['|', '1', '0', '2']
  
  " Nerdtree
  let NERDTreeQuitOnOpen=1
  
  " Kite
  let g:kite_supported_languages = ['*'] " Python, JavaScript, Go
  
  " coc
  autocmd FileType javascript let b:coc_suggest_disable=0
  autocmd FileType scss setl iskeyword+=@-@

  let g:coc_global_extensions = ['coc-tsserver', 'coc-eslint']

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

  colorscheme onedark

  " theme doom_one
  "let g:doom_one_terminal_colors = v:true
  
  " theme onedark
  let g:onedark_style = 'cool' " darker | cool | deep | warm | warmer
  let g:onedark_transparent_background = 1 " By default it is 0
  let g:onedark_italic_comment = 1 " By default it is 1
  
  let g:onedark_hide_endofbuffer=1
  let g:onedark_termcolors=256
  let g:onedark_terminal_italics=1

  "blamer (gitlens)
  let g:blamer_enabled = 1
  let g:blamer_delay = 500 " default 1000
  
" MAPS
  " Navegacion de archivos
  let mapleader=" "
  
  " nerdtree
  nmap <Leader>nt :NERDTreeFind<CR>
  
  " GoTo code navigation.
  nmap <silent> gd <Plug>(coc-definition)
  nmap <silent> gy <Plug>(coc-type-definition)
  nmap <silent> gi <Plug>(coc-implementation)
  nmap <silent> gr <Plug>(coc-references)

  " autoclose pairs
  inoremap ( ()<left>
  inoremap { {}<left>
  inoremap [ []<left>
  inoremap ' ''<left>
  inoremap " ""<left>
 " =============================== 
