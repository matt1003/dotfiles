
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
let mapleader='\<space>'     " use space bar at leader

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
set lazyredraw

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
  silent !wget -O '$VIMHOME/autoload/plug.vim'
    \ 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
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
let g:quickr_preview_sign_enable = 0
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
let g:indexed_search_dont_move = 1
let g:indexed_search_max_lines = 500000
"}}}

" gitv {{{
"Plug 'gregsexton/gitv'
"let g:Gitv_OpenHorizontal=1
"}}}

" always highlight parentheses {{{
Plug 'justinmk/vim-matchparenalways', {'tag':'8fe259720a'}
"}}}

" matchmaker (highlight current word) {{{
Plug 'qstrahl/vim-matchmaker'
let g:matchmaker_enable_startup = 1
let g:matchmaker_matchpriority = -1
augroup MatchMakerColor
  autocmd!
  autocmd ColorScheme * highlight MatchMaker ctermbg=241 guibg=#665c54
augroup END
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

" replace with register (delete and paste) {{{
Plug 'vim-scripts/ReplaceWithRegister'
"}}}

" sleuth (auto detect file indentation) {{{
Plug 'tpope/vim-sleuth'
"}}}

" mucomplete (insert mode auto completion) {{{
Plug 'lifepillar/vim-mucomplete'
let g:mucomplete#enable_auto_at_startup = 1
set completeopt+=menuone
set completeopt-=preview
if version >= 800 || has ('nvim')
  set completeopt+=noinsert
endif
"}}}

" dispatch {{{
Plug 'tpope/vim-dispatch'
"}}}

" surround {{{
Plug 'tpope/vim-surround'
"}}}

" capslock {{{
Plug 'tpope/vim-capslock'
imap <c-c> <Plug>CapsLockToggle
"}}}

" buffexplorer {{{
Plug 'vim-scripts/bufexplorer.zip'
nmap <silent> <leader>bl :call win_gotoid(g:main_win_id)<CR>:BufExplorer<CR>
nmap <silent> <c-u> :BufExplorer<CR>
"}}}

" airline {{{
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'edkolev/tmuxline.vim'
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tmuxline#enabled = 0
let g:airline#extensions#tabline#fnamemod = ':t'
"}}}

" gitgutter {{{
Plug 'airblade/vim-gitgutter'
set signcolumn=yes
let g:gitgutter_sign_added = '▶'
let g:gitgutter_sign_modified = '▶'
let g:gitgutter_sign_modified_removed = '▼'
let g:gitgutter_sign_removed = '▼'
let g:gitgutter_sign_removed_first_line = '▲'
nmap <leader>hn :GitGutterNextHunk<CR>
nmap <leader>hp :GitGutterPrevHunk<CR>
nmap <leader>hu :GitGutterUndoHunk<CR>
nmap <silent> <c-n> :GitGutterNextHunk<CR>
autocmd FileType help,tagbar,nerdtree,qf setlocal signcolumn=no
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
let g:yankring_min_element_length=2
let g:yankring_max_history = 1000
let g:yankring_window_height = 12
let g:yankring_replace_n_pkey=1
let g:yankring_replace_n_nkey=1
nmap <leader>yr :YRShow<CR>
nmap <leader>ys :YRSearch<CR>
nmap <silent> <c-y> :YRShow<CR>
"}}}

" nerdtree {{{
Plug 'scrooloose/nerdtree'
let g:NERDTreeWinSize = 40
let g:NERDTreeMinimalUI = 1
"}}}

" tagbar {{{
Plug 'majutsushi/tagbar'
let g:tagbar_compact = 1
let g:tagbar_indent = 1
let g:tagbar_silent = 1
"}}}

" hardtime {{{
Plug 'takac/vim-hardtime'
let g:hardtime_default_on = 0
let g:hardtime_allow_different_key = 1
let g:hardtime_maxcount = 3
let g:list_of_normal_keys = ['h', 'l', 'x']
let g:list_of_visual_keys = ['h', 'l', 'x']
let g:list_of_insert_keys = []
let g:list_of_disabled_keys = ['<UP>', '<DOWN>', '<LEFT>', '<RIGHT>']
"}}}

" tmux-navigator {{{
Plug 'christoomey/vim-tmux-navigator'
"}}}

" multiple-search {{{
Plug 'vim-scripts/MultipleSearch'
silent! map <F5> :call MultipleSearch#MultipleSearch(bufnr('%'), expand('<cword>'))<CR>
silent! map <F6> :SearchReset<CR>
"}}}

Plug 'qpkorr/vim-bufkill'

call plug#end()

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" gui settings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" set the color scheme
if &term != 'linux'
  try
    set background=dark
    colorscheme gruvbox
  catch
    colorscheme slate
  endtry
endif

if has('gui_running')
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
  autocmd FileType c,cpp,dts,kconfig,javascript,lua,make,python,sh,vim,vhdl,xml setlocal list colorcolumn=81
  " quickfix buffer
  autocmd FileType qf,tagbar,nerdtree,help setlocal nospell norelativenumber
augroup END

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" custom keybindings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" insert new line {{{
nmap <leader>o :<C-U>call append(line('.'), repeat([''], v:count1))<CR>
nmap <leader>O :<C-U>call append(line('.')-1, repeat([''], v:count1))<CR>
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
    echon ', ' | echohl WarningMsg | echon '(hex dump of binary file)' | echohl None
  endif
endfun

fun! ToBinFile()
  if exists('b:hexdump')
    silent %!xxd -r
  endif
endfun

fun! ToHexFile()
  if exists('b:hexdump')
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
  let s:PowerBoxAddr = input('address: ', a:addr, 'dir')
  if s:PowerBoxAddr == 'reset'
    let s:PowerBoxAddr = input('address: ', s:DefaultPowerBoxAddr, 'dir')
  endif
endfun

fun! s:ExecutePowerBox(PowerBoxCmd, PowerBoxArgs)
  call <SID>UpdatePowerBoxAddr(s:PowerBoxAddr)
  exe '!'.a:PowerBoxCmd.' '.s:PowerBoxAddr.' '.a:PowerBoxArgs
endfun

command! -nargs=+ PowerBox call <SID>ExecutePowerBox('pdu', <q-args>)
cabbrev pdu PowerBox

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" build system
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let s:BuildSysCmd = 'buildwrap'
let s:BuildSysDir = 'docker'
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

fun! s:CheckForModifiedBuffers()
  let buflist = filter(range(1, bufnr('$')), 'buflisted(v:val)')
  let unsavbuflist = []
  for bufnr in buflist
    if getbufvar(bufnr, '&modified')
      call add(unsavbuflist, bufnr)
    endif
  endfor
  if empty(unsavbuflist)
    return
  endif
  for bufnr in unsavbuflist
    echo bufname(bufnr)
  endfor
  while 1
    echohl Question
    let anwser = input('Modified files detected! Save all? [Y/N]: ')
    echohl None
    if anwser == 'Y'
      write all
      return
    elseif anwser == 'N'
      return
    endif
  endwhile
endfun

fun! s:IsBuildSysPath(path)
  if filereadable(a:path.'/build.sh')
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
  while path != '/'
      if <SID>IsBuildSysPath(path.'/'.s:BuildSysDir)
        return path.'/'.s:BuildSysDir
    endif
    let path = fnamemodify(path, ':h')
  endwhile
  " 3) give up and use the current working directory
  echohl WarningMsg | echo 'Unable to locate buildsys path ...' | echohl None
  return getcwd()
endfunction

fun! s:UpdateBuildSysPath()
  let s:BuildSysPath = input('buildsys path: ', <SID>LocateBuildSysPath(), 'dir')
endfun

fun! s:ExecuteBuildSys(BuildSysArgs)
  if a:BuildSysArgs == 'error'
    Copen
    let @/ = 'error:'
  else
    call <SID>CheckForModifiedBuffers()
    call <SID>UpdateBuildSysPath()
    exe 'Dispatch! -compiler=make -dir='.s:BuildSysPath.' '.s:BuildSysCmd.' '.a:BuildSysArgs
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

if executable('ag')
  " use the silver searcher
  set grepprg=ag\ --vimgrep
  set grepformat=%f:%l:%c:%m
  let s:DefaultGrepPath = getcwd()
  let s:DefaultGrepOpts = '-w'
else
  " use standard old grep
  let s:DefaultGrepPath = getcwd()
  let s:DefaultGrepOpts = '-I -w'
endif

let s:GrepPath = s:DefaultGrepPath
let s:GrepOpts = s:DefaultGrepOpts
let s:GrepShow = 'loc' " qf/loc

fun! s:UpdateGrepWord(word)
  if a:word != ''
    let s:GrepWord = input('search pattern: ', '"'.a:word.'"', 'dir')
  else
    let s:GrepWord = input('search pattern: ', '"'.expand('<cword>').'"', 'dir')
  endif
endfun

fun! s:UpdateGrepPath(path)
  let s:GrepPath = input('search path: ', a:path, 'dir')
  if s:GrepPath == 'reset'
    let s:GrepPath = input('search path: ', s:DefaultGrepPath, 'dir')
  endif
endfun

fun! s:UpdateGrepOpts(opts)
  let s:GrepOpts = input('search flags: ', a:opts, 'dir')
  if s:GrepOpts == 'reset'
    let s:GrepOpts = input('search flags: ', s:DefaultGrepOpts, 'dir')
  endif
endfun

fun! s:ExecuteGrep(GrepCmd, GrepArgs)
  call <SID>UpdateGrepWord(a:GrepArgs)
  call <SID>UpdateGrepPath(s:GrepPath)
  call <SID>UpdateGrepOpts(s:GrepOpts)
  call CloseAllQfLocWins()
  echon 'Searching for '.s:GrepWord.' ...'
  exe 'silent '.a:GrepCmd.' '.s:GrepOpts.' '.s:GrepWord.' '.s:GrepPath
  redraw!
  if s:GrepShow == 'qf'
    let total = len(getqflist())
  else
    let total = len(getloclist(0))
  endif
  if total == 0
    echohl WarningMsg
    echon 'Search for '.s:GrepWord.' returned no results.'
    echohl Normal
    return
  elseif total == 1
    echon 'Search for '.s:GrepWord.' returned 1 result.'
  else
    echon 'Search for '.s:GrepWord.' returned '.total.' results.'
  endif
  if s:GrepShow == 'qf'
    botright copen 12
  else
    botright lwindow 12
  endif
endfun

if s:GrepShow == 'qf'
  command! -nargs=* MySearch call <SID>ExecuteGrep('grep! -r', <q-args>)
else
  command! -nargs=* MySearch call <SID>ExecuteGrep('lgrep! -r', <q-args>)
endif

cabbrev grep MySearch
cabbrev ag MySearch

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" random crap
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function! s:Log(eventName) abort
  let bufnr = bufnr('%')
  let bufname = bufname(bufnr)
  let ispvw = getwinvar(winnr(), '&pvw')
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
    "autocmd BufEnter    * call input('enter to continue ', getwinvar(winnr(), '&pvw'), 'dir')
  endif
augroup END

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" useful stuff
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" auto load vimrc
augroup reload_vimrc " {
    autocmd!
    autocmd BufWritePost $MYVIMRC nested source $MYVIMRC
augroup END " }

" select read only when opening a swap file in the preview window
augroup pvw_swp
  autocmd!
  autocmd SwapExists * if &l:pvw | let v:swapchoice = 'o' | endif
augroup END

" enable the cursor line and relative numbering in the active window only
augroup CursorLineOnlyInActiveWindow
  autocmd!
  autocmd VimEnter,WinEnter,BufWinEnter * setlocal cursorline | if (&ft!='help' && &ft!='nerdtree' && &ft!='tagbar' && &ft!='qf') | setlocal relativenumber | endif
  autocmd WinLeave * setlocal nocursorline norelativenumber
augroup END

" override airline status line to print straight lines when inactive
set fillchars+=vert:│,stlnc:─
function! Render_Only_File(...)
  return 1   " modify the statusline with the current contents of the builder
endfunction
call airline#add_inactive_statusline_func('Render_Only_File')

" close all quickfix/location windows
func! CloseAllQfLocWins()
  windo if &ft == 'qf' | bd | endif
  call win_gotoid(g:main_win_id)
endfunc
silent! map <F2> :call CloseAllQfLocWins()<CR>

" write file with sudo rights
func! SudoWrite()
  write !sudo tee % > /dev/null
  edit!
endfunc
command! Write call SudoWrite()

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" tracking the main window
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:main_win_tm = -1
let g:main_win_id = -1

func! MainWinHandler(...)
  if &modifiable
    let g:main_win_id = win_getid()
  endif
  "echo ' main='.g:main_win_id.' (win='.win_getid().',mod='.&modifiable.',ft='.&ft.')'
endfunc

func! MainWinTimer()
  call timer_stop(g:main_win_tm)
  let g:main_win_tm = timer_start(250, 'MainWinHandler')
endfunc

augroup main_win_au()
  autocmd!
  autocmd VimEnter,WinEnter * call MainWinTimer()
augroup END

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" nerd tree auto trace current buffer
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

func! s:NERDTreeIsOpen()
  return exists('t:NERDTreeBufName') && (bufwinnr(t:NERDTreeBufName) != -1)
endfunc

func! s:NERDTreeSync()
  " check if nerdtree is open
  if !s:NERDTreeIsOpen()
    return
  endif
  " ignore the preview window
  if getwinvar(winnr(), '&pvw')
    return
  endif
  " ignore non-modifiable buffers
  if !&modifiable
    return
  endif
  " ignore non-existing buffers
  if strlen(expand('%')) == 0
    return
  endif
  " highlight the current file
  let l:win_id = win_getid()
  NERDTreeFind
  execute 'sign unplace 27'
  execute 'sign place 27 name=NERDTreeCurrentFile line='.line('.').' buffer='.bufnr('%')
  call win_gotoid(l:win_id)
endfunc

augroup nerdtree_au()
  autocmd!
  autocmd BufEnter * call s:NERDTreeSync()
augroup END

sign define NERDTreeCurrentFile linehl=Search

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ide view
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let s:ide_view = 0

func! IdeViewToggle(...)
  if s:ide_view
    TagbarClose
    NERDTreeClose
    let s:ide_view = 0
  else
    let l:win_id = win_getid()
    NERDTree
    Tagbar
    call win_gotoid(l:win_id)
    let s:ide_view = 1
  endif
endfunc

augroup ide_view_au
  autocmd!
  autocmd VimEnter * if winwidth(0) > 160 | call timer_start(200, 'IdeViewToggle') | endif
augroup END

silent! map <F3> :call IdeViewToggle()<CR>

