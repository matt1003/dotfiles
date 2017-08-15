
set nocompatible
set encoding=utf-8

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" operating system configuration
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

if has('win32') || has ('win64')
  set shell=powershell
  set shellcmdflag=-command
  let $VIMHOME=$HOME.'/vimfiles'
else
  set shell=/bin/bash
  set shellcmdflag=-c
  if has ('nvim')
    let $VIMHOME=$HOME.'/.config/nvim'
  else
    let $VIMHOME=$HOME.'/.vim'
  endif
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vim directories
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set viminfo+=n$VIMHOME/viminfo

if !isdirectory($VIMHOME.'/swap')
  call mkdir($VIMHOME.'/swap', 'p')
endif
set directory=$VIMHOME/swap//
set swapfile

if !isdirectory($VIMHOME.'/backup')
  call mkdir($VIMHOME.'/backup', 'p')
endif
set backupdir=$VIMHOME/backup//
set backup

if !isdirectory($VIMHOME.'/undo')
  call mkdir($VIMHOME.'/undo', 'p')
endif
set undodir=$VIMHOME/undo//
set undofile

if !isdirectory($VIMHOME.'/autoload')
  call mkdir($VIMHOME.'/autoload', 'p')
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" general settings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

syntax on                    " enable syntax highlighting

nnoremap <space> <nop>
let mapleader="\<space>"     " use space bar at leader

set hidden                   " allow easier switching between buffers
set confirm                  " confirmation prompt on unsaved buffers
set updatetime=250           " wait time to trigger plugin actions
set history=1000             " remember the last 1000 commands
set autoread                 " reload file when changed on disk

set laststatus=2

set number                   " display: show absolute line numbers
set relativenumber           " display: show relative line numbers
set cursorline               " display: show current line
set scrolloff=999            " display: cursor always centered
set spell spelllang=en_us    " display: show spell checking
set shortmess+=I             " display: hide startup screen
set noshowmode               " display: hide mode in status bar

set hlsearch                 " search: highlight results
set incsearch                " search: search as typing
set ignorecase               " search: case insensitive search
set smartcase                " search: do not ignore uppercase

set wildmenu                 " visual menu for auto-complete
set wildmode=longest,list    " setup bash-like auto-complete
set formatoptions+=j         " delete comment char when joining commented lines

set foldmethod=marker

" define white-space visible characters
try
  set listchars=tab:»―,space:·,nbsp:⚬,eol:↵
catch
  set listchars=tab:»―,trail:·,nbsp:⚬,eol:↵
endtry

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vim-plug
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

if !filereadable($VIMHOME.'/autoload/plug.vim')
  silent !wget -O "$VIMHOME/autoload/plug.vim"
    \ "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
  autocmd VimEnter * nested PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()

" powerline-fonts {{{
Plug 'powerline/fonts', { 'do' : './install.sh' }
"}}}

" cscope {{{
 if executable('cscope')
  "Plug 'vim-scripts/cscope.vim'
  Plug 'matt1003/cscope.vim'
  let g:cscope_no_jump = 1
endif
"}}}

" quickr-preview {{{
"Plug 'ronakg/quickr-preview.vim'
Plug 'matt1003/quickr-preview.vim'
let g:quickr_preview_on_cursor = 0
"}}}

" gruvbox {{{
"Plug 'morhetz/gruvbox'
Plug 'matt1003/gruvbox'
let g:gruvbox_contrast_dark = 'hard'
let g:gruvbox_number_column = 'bgN'
let g:gruvbox_sign_column = 'bgN'
let g:gruvbox_italic = 1
"}}}

"Plug 'vim-scripts/fontsize' this doesn't work with quickr-preview, as they
"have overlapping key bindings.

" indexed-search {{{
Plug 'henrik/vim-indexed-search'
let g:indexed_search_numbered_only = 1
"}}}

" gitv {{{
"Plug 'gregsexton/gitv'
"let g:Gitv_OpenHorizontal=1
"}}}

"Plug 'justinmk/vim-matchparenalways'   " always highlight parentheses

" matchmaker (highlight current word) {{{
"Plug 'qstrahl/vim-matchmaker'
"highlight MatchMaker ctermbg=238 guibg=#585858
"let g:matchmaker_enable_startup = 1
"let g:matchmaker_matchpriority = -1
"}}}

"Plug 'terryma/vim-expand-region'
"Plug 'jiangmiao/auto-pairs'            " insert brackets/quotes in pairs
"Plug 'bronson/vim-visual-star-search'  " search visual mode selection

" better whitespace (highlight trailing whitespace) {{{
"Plug 'ntpeters/vim-better-whitespace'
Plug 'matt1003/vim-better-whitespace'
let g:match_spaces_that_precede_tabs = 1
"}}}

" syntax-extra (improved c syntax highlighting) {{{
Plug 'justinmk/vim-syntax-extra'
"}}}

" ifdef-highlighting (highlighting of c #ifdef blocks) {{{
Plug 'vim-scripts/ifdef-highlighting'
"}}}

" sleuth (auto detect file indentation) {{{
Plug 'tpope/vim-sleuth'
"}}}

" mucomplete (insert mode auto completion) {{{
Plug 'lifepillar/vim-mucomplete'
let g:mucomplete#enable_auto_at_startup = 1
set completeopt+=menuone
if version >= 800 || has ('nvim')
  set completeopt+=noinsert
endif
"}}}

" dispatch {{{
Plug 'tpope/vim-dispatch'
"}}}

" buffexplorer {{{
Plug 'vim-scripts/bufexplorer.zip'
nmap <silent> <leader>bl :BufExplorer<CR>
"}}}

" airline {{{
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'weihanglo/tmuxline.vim'
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tmuxline#enabled = 0
"}}}

" gitgutter {{{
Plug 'airblade/vim-gitgutter'
let g:gitgutter_sign_column_always = 1
let g:gitgutter_sign_added = '▶'
let g:gitgutter_sign_modified = '▶'
let g:gitgutter_sign_modified_removed = '▼'
let g:gitgutter_sign_removed = '▼'
let g:gitgutter_sign_removed_first_line = '▲'
nmap <leader>hn :GitGutterNextHunk<CR>
nmap <leader>hp :GitGutterPrevHunk<CR>
nmap <leader>hu :GitGutterUndoHunk<CR>
"}}}

" fugitive {{{
Plug 'tpope/vim-fugitive'
"}}}

" undotree {{{
Plug 'mbbill/undotree'
"}}}

" yankring {{{
Plug 'vim-scripts/YankRing.vim'
let g:yankring_history_dir = $VIMHOME
let g:yankring_max_history = 1000
let g:yankring_window_height = 12
nmap <leader>yr :YRShow<CR>
nmap <leader>ys :YRSearch<CR>
"}}}

" nerdtree {{{
Plug 'scrooloose/nerdtree'
let g:NERDTreeWinSize = 50
"}}}

" taglist {{{
if executable('ctags')
  Plug 'vim-scripts/taglist.vim'
  let g:Tlist_Use_Right_Window = 1
  let g:Tlist_Enable_Fold_Column = 0
  let g:Tlist_WinWidth = 50
  let g:Tlist_Show_One_File = 1
  let g:Tlist_Compact_Format = 1
endif
"}}}

" hardtime {{{
Plug 'takac/vim-hardtime'
let g:hardtime_default_on = 1
let g:hardtime_allow_different_key = 1
let g:hardtime_maxcount = 3
let g:list_of_normal_keys = ["h", "l", "x"]
let g:list_of_visual_keys = ["h", "l", "x"]
let g:list_of_insert_keys = []
let g:list_of_disabled_keys = ["<UP>", "<DOWN>", "<LEFT>", "<RIGHT>"]
"}}}

" tmux-navigator {{{
Plug 'christoomey/vim-tmux-navigator'
"}}}

Plug 'qpkorr/vim-bufkill'
Plug 'skywind3000/asyncrun.vim'

call plug#end()

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" gui settings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" set the color scheme
try
  set background=dark
  colorscheme gruvbox
catch
  colorscheme slate
endtry

if has("gui_running")
  if has('win32') || has ('win64')
  set guifont=DejaVu_Sans_Mono_for_Powerline:h10:cANSI
  else
    set guifont=DejaVu\ Sans\ Mono\ for\ Powerline\ 10
  endif
  set guioptions-=m    " remove menu bar
  set guioptions-=T    " remove tool bar
  set guioptions-=l    " remove scroll bar (left)
  set guioptions-=L    " remove scroll bar (left)
  set guioptions-=r    " remove scroll bar (right)
  set guioptions-=R    " remove scroll bar (right)
  set guioptions-=b    " remove scroll bar (bottom)
  set mousemodel=popup " right mouse button opens menu
else
  set mouse=a
  if version >= 800 || has ('nvim')
    set termguicolors
  else
    hi Normal ctermbg=None
    hi LineNr ctermbg=None
    hi SignColumn ctermbg=None
  endi
endif

let g:quickfix_window_height = 12

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" file specific settings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

augroup file_specific_settings
  autocmd!
  " git commit message
  autocmd FileType gitcommit setlocal colorcolumn=73
  " source code files
  autocmd FileType c,cpp,dts,kconfig,lua,make,python,sh,vim,vhdl,xml setlocal list colorcolumn=81
  " quickfix buffer
  autocmd FileType qf,taglist setlocal nospell norelativenumber
augroup END

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" custom keybindings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" insert new line {{{
nmap <leader>o :<C-U>call append(line("."), repeat([''], v:count1))<CR>
nmap <leader>O :<C-U>call append(line(".")-1, repeat([''], v:count1))<CR>
"}}}

nmap <silent> <leader>bd :bd<CR>
nmap <silent> <leader>bn :bn<CR>
nmap <silent> <leader>bp :bp<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Auto Detect Binary Files
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

fun! TestBinFile()
  if &binary || search('\%u0000', 'wn', 0, 200)
    set binary
    silent %!xxd
    set fenc&
    let b:hexdump=1
    echon ", " | echohl WarningMsg | echon "(hex dump of binary file)" | echohl None
  endif
endfun

fun! ToBinFile()
  if exists("b:hexdump")
    silent %!xxd -r
  endif
endfun

fun! ToHexFile()
  if exists("b:hexdump")
    silent %!xxd
  endif
endfun

augroup ConvertBinaryFiles
  autocmd!
  autocmd BufReadPost  * call TestBinFile()
  autocmd BufWritePre  * call ToBinFile()
  autocmd BufWritePost * call ToHexFile()
augroup END

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Cscope / Ctags
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set cscopetag    " use ctags and cscope
set csto=0       " search cscope first

nnoremap <silent> <leader>fa :call cscope#findInteractive(expand('<cword>'))<CR>
nnoremap <silent> <leader>l :call ToggleLocationList()<CR>

nnoremap <silent> <leader>fs :call cscope#find('s', expand('<cword>'))<CR>
nnoremap <silent> <leader>fg :call cscope#find('g', expand('<cword>'))<CR>
nnoremap <silent> <leader>fd :call cscope#find('d', expand('<cword>'))<CR>
nnoremap <silent> <leader>fc :call cscope#find('c', expand('<cword>'))<CR>
nnoremap <silent> <leader>ft :call cscope#find('t', expand('<cword>'))<CR>
nnoremap <silent> <leader>fe :call cscope#find('e', expand('<cword>'))<CR>
nnoremap <silent> <leader>ff :call cscope#find('f', expand('<cword>'))<CR>
nnoremap <silent> <leader>fi :call cscope#find('i', expand('<cword>'))<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" power box
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let s:DefaultPowerBoxAddr = '192.168.0.3'
let s:PowerBoxAddr = s:DefaultPowerBoxAddr

fun! s:UpdatePowerBoxAddr(addr)
  let s:PowerBoxAddr = input("address: ", a:addr, 'dir')
  if s:PowerBoxAddr == "reset"
    let s:PowerBoxAddr = input("address: ", s:DefaultPowerBoxAddr, 'dir')
  endif
endfun

fun! s:ExecutePowerBox(PowerBoxCmd, PowerBoxArgs)
  call <SID>UpdatePowerBoxAddr(s:PowerBoxAddr)
  exe "!".a:PowerBoxCmd." ".s:PowerBoxAddr." ".a:PowerBoxArgs
endfun

command! -nargs=+ PowerBox call <SID>ExecutePowerBox("pdu", <q-args>)
cabbrev pdu PowerBox

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" build system
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let s:BuildSysCmd = "buildwrap --no-output-color --no-output-prefix --fast"
let s:BuildSysDir = "buildsys"
let s:BuildSysPath = 0

" build result color
highlight! link HiBuildSysSuccess GruvboxGreenBold
highlight! link HiBuildSysAborted GruvboxOrangeBold
highlight! link HiBuildSysFailure ErrorMsg
" build errors color
highlight! link HiBuildSysWrn GruvboxOrangeBold
highlight! link HiBuildSysErr GruvboxRedBold

fun! s:SetBuildSysSyntax()
  " build result syntax
  syntax match HiBuildSysSuccess / BUILD SUCCESS /
  syntax match HiBuildSysAborted / BUILD ABORTED /
  syntax match HiBuildSysFailure / BUILD FAILURE /
  " build errors syntax
  syntax match HiBuildSysWrn /\c warning: /
  syntax match HiBuildSysErr /\c error: .*/
  syntax match HiBuildSysErr /recipe for target '.*' failed/
  syntax match HiBuildSysErr /Building: Failed/
endfun

fun! s:IsBuildSysPath(path)
  if filereadable(a:path."/toolchain_version")
    return 1
  endif
  return 0
endfun

fun! s:LocateBuildSysPath()
  " 1) attempt to use the last build system directory
  if <SID>IsBuildSysPath(s:BuildSysPath)
    return s:BuildSysPath
  endif
  " 2) attempt to locate the build system directory
  let path = getcwd()
  while path != "/"
      if <SID>IsBuildSysPath(path."/".s:BuildSysDir)
        return path."/".s:BuildSysDir
    endif
    let path = fnamemodify(path, ':h')
  endwhile
  " 3) give up and use the current working directory
  echohl WarningMsg | echo "Unable to locate buildsys path ..." | echohl None
  return getcwd()
endfunction

fun! s:UpdateBuildSysPath()
  let s:BuildSysPath = input("buildsys path: ", <SID>LocateBuildSysPath(), 'dir')
endfun

fun! s:ExecuteBuildSys(BuildSysArgs)
  if a:BuildSysArgs == "error"
    Copen
    let @/ = 'error:'
  else
    call <SID>UpdateBuildSysPath()
    exe "Dispatch! -compiler=make -dir=".s:BuildSysPath." ".s:BuildSysCmd." ".a:BuildSysArgs
    "botright copen 12
    "call <SID>SetBuildSysSyntax()
    "setlocal nonumber
    "cbottom
    "wincmd p
  endif
endfun

command! -nargs=+ BuildSys call <SID>ExecuteBuildSys(<q-args>)
cabbrev build BuildSys

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" grep
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let s:DefaultGrepPath = getcwd()
let s:DefaultGrepOpts = "--binary-files=without-match --exclude-dir=buildsys"

let s:GrepPath = s:DefaultGrepPath
let s:GrepOpts = s:DefaultGrepOpts

fun! s:UpdateGrepWord(word)
  if a:word != ""
    let s:GrepWord = input("grep pattern: ", "\"".a:word."\"", 'dir')
  else
    let s:GrepWord = input("grep pattern: ", "\"".expand("<cword>")."\"", 'dir')
  endif
endfun

fun! s:UpdateGrepPath(path)
  let s:GrepPath = input("grep path: ", a:path, 'dir')
  if s:GrepPath == "reset"
    let s:GrepPath = input("grep path: ", s:DefaultGrepPath, 'dir')
  endif
endfun

fun! s:UpdateGrepOpts(opts)
  let s:GrepOpts = input("grep flags: ", a:opts, 'dir')
  if s:GrepOpts == "reset"
    let s:GrepOpts = input("grep flags: ", s:DefaultGrepOpts, 'dir')
  endif
endfun

fun! s:ExecuteGrep(GrepCmd, GrepArgs)
  call <SID>UpdateGrepWord(a:GrepArgs)
  call <SID>UpdateGrepPath(s:GrepPath)
  call <SID>UpdateGrepOpts(s:GrepOpts)
  echon "Searching for ".s:GrepWord." ..."
  exe "silent ".a:GrepCmd." ".s:GrepOpts." ".s:GrepWord." ".s:GrepPath
  redraw!
  let total = len(getloclist(0))
  if total == 0
    echohl GruvboxRedBold
    echon "Search for ".s:GrepWord." returned no results."
    echohl Normal
  elseif total == 1
    lwindow 12
    echon "Search for ".s:GrepWord." returned 1 result."
  else
    lwindow 12
    echon "Search for ".s:GrepWord." returned ".total." results."
  endif
endfun

command! -nargs=* Grep call <SID>ExecuteGrep("lgrep! -r", <q-args>)
cabbrev grep Grep

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" random crap
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"▶➕◆✚➕◆♦✖✚✜◆◆⬥•●⚫⬤◈∎⑆■▪►x×X✕☓✖✗✘

function! s:Log(eventName) abort
  let bufnr = bufnr('%')
  let bufname = bufname(bufnr)
  let ispvw = getwinvar(winnr(), "&pvw")
  silent execute '!echo '.a:eventName.' '.bufnr.'-'.ispvw.' '.bufname.' >>'.$VIMHOME.'/vimlog'
endfunction

augroup EventLoggin
  autocmd!
  if 0 " enable/disable autocmd logging
    autocmd BufNewFile  * call s:Log('BufNewFile --')
    autocmd BufReadPre  * call s:Log('BufReadPre --')
    autocmd BufReadPost * call s:Log('BufReadPost -')
    autocmd BufWinEnter * call s:Log('BufWinEnter -')
    autocmd BufCreate   * call s:Log('BufCreate ---')
    autocmd BufDelete   * call s:Log('BufDelete ---')
    autocmd BufEnter    * call s:Log('BufEnter ----')
    autocmd User        * call s:Log('User --------')
    autocmd SwapExists  * call s:Log('SwapExists---')
    "autocmd BufEnter    * call input("enter to continue ", getwinvar(winnr(), "&pvw"), 'dir')
  endif
augroup END

if has("gui_running")
  augroup ide_mode
    autocmd!
    autocmd VimEnter * Tlist
    autocmd VimEnter * NERDTree
    autocmd VimEnter * wincmd p
    "autocmd BufEnter * if &modifiable | NERDTreeFind | wincmd p | endif
  augroup END
endif

" restore last session
"if argc() == 0
"  silent! source session.vim
"endif

" auto load vimrc
augroup reload_vimrc " {
    autocmd!
    autocmd BufWritePost $MYVIMRC nested source $MYVIMRC
augroup END " }

" do not jump when doing '*' search
" todo ... this is being overwritten by vim-indexed-search
nnoremap <silent> * :let @/='\<<C-R>=expand("<cword>")<CR>\>'<CR>:set hls<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" useful method to determine QuickFix vs Location List
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" " returns 1 if the window with the given number is a location window
" "         0 if the window with the given number is not a location window
function! IsLocWindow(nmbr)
  return getbufvar(winbufnr(a:nmbr), "isLoc") == 1
endfunction
"
" " returns 1 if the window with the given number is a quickfix window
" "         0 if the window with the given number is not a quickfix window
function! IsQfWindow(nmbr)
  if getwinvar(a:nmbr, "&filetype") == "qf"
    return IsLocWindow(a:nmbr) ? 0 : 1
  endif
  return 0
endfunction

augroup pvw_swp
  autocmd!
  autocmd SwapExists * if &l:pvw | let v:swapchoice = "o" | endif
augroup END

