
set encoding=utf-8
scriptencoding utf-8

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
  let $VIMHOME=$HOME.'/.vim'
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vim directories
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

if has ('nvim')
  set viminfo+=n$VIMHOME/nviminfo
else
  set viminfo+=n$VIMHOME/viminfo
endif

if !isdirectory($VIMHOME.'/autoload')
  call mkdir($VIMHOME.'/autoload', 'p')
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" general settings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

nnoremap <space> <nop>
let g:mapleader="\<space>"   " use space bar at leader

set hidden                   " allow easier switching between buffers
set confirm                  " confirmation prompt on unsaved buffers
set lazyredraw               " do not redraw while macros are running
set updatetime=250           " wait time to trigger plugin actions
set wildmode=longest,list    " setup bash-like auto-complete

set number                   " display: show absolute line numbers
set colorcolumn=81,101,121   " display: show 80/100/120 char column
set scrolloff=999            " display: cursor always centered
set spell spelllang=en_us    " display: show spell checking
set shortmess+=I             " display: hide startup screen
set noshowmode               " display: hide mode from status bar
set signcolumn=yes           " display: show the sign column
set list                     " display: show white-space characters

set hlsearch                 " search: highlight results
set incsearch                " search: search as typing
set ignorecase               " search: case insensitive search
set smartcase                " search: do not ignore uppercase

set foldmethod=marker
set clipboard^=unnamed,unnamedplus
set belloff=all

" define white-space characters
try
  set listchars=tab:»―,space:·,nbsp:⚬,eol:↵
catch
  set listchars=tab:»―,trail:·,nbsp:⚬,eol:
endtry

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vim-plug
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

if !filereadable($VIMHOME.'/autoload/plug.vim')
  execute 'silent !wget -O "'.$VIMHOME.'/autoload/plug.vim" "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"'
endif

if !isdirectory($VIMHOME.'/plugged')
  augroup InstallPlugins
    autocmd!
    autocmd VimEnter * nested PlugInstall --sync | source $MYVIMRC
  augroup END
endif

call plug#begin()
" airline -------------------(status line) {{{
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'edkolev/tmuxline.vim'
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tmuxline#enabled = 0
let g:airline#extensions#tabline#fnamemod = ':t'
"}}}
" ale -----------------------(automatic linting engine) {{{
Plug 'w0rp/ale'
let g:ale_set_loclist = 0
let g:ale_set_quickfix = 1
let g:ale_set_highlights = 0
let g:ale_sign_error = '✘'
let g:ale_sign_warning = '✘'
let g:ale_linters = {'c':[],'cpp':[]}
"}}}
" better whitespace ---------(highlight trailing whitespace) {{{
Plug 'ntpeters/vim-better-whitespace'
let g:show_spaces_that_precede_tabs = 1
let g:better_whitespace_filetypes_blacklist = ['help', 'nerdtree', 'tagbar', 'qf', 'undotree']

"}}}
" bufexplorer ---------------(improved interface for switching buffers) {{{
Plug 'vim-scripts/bufexplorer.zip'
nmap <silent> <leader>bl :call win_gotoid(g:main_win_id)<CR>:keepjumps BufExplorer<CR>
nmap <silent> <c-u> :keepjumps BufExplorer<CR>
"}}}
" bufkill -------------------(delete buffer without messing up splits) {{{
Plug 'qpkorr/vim-bufkill'
"}}}
" caps lock -----------------(simulate caps lock key) {{{
Plug 'tpope/vim-capslock'
imap <c-c> <Plug>CapsLockToggle
"}}}
" central -------------------(manage backup/swap/undo files) {{{
Plug 'matt1003/central.vim'
"}}}
" cscope {{{
if executable('cscope')
  Plug 'matt1003/cscope.vim'
  set cscopetag        " use ctags and cscope
  set cscopetagorder=0 " search cscope first
  let g:cscope_no_jump = 1
  nnoremap <silent> <leader>fs :call cscope#find('s', expand('<cword>'))<CR>
  nnoremap <silent> <leader>fg :call cscope#find('g', expand('<cword>'))<CR>
  nnoremap <silent> <leader>fd :call cscope#find('d', expand('<cword>'))<CR>
  nnoremap <silent> <leader>fc :call cscope#find('c', expand('<cword>'))<CR>
  nnoremap <silent> <leader>ft :call cscope#find('t', expand('<cword>'))<CR>
  nnoremap <silent> <leader>fe :call cscope#find('e', expand('<cword>'))<CR>
  nnoremap <silent> <leader>ff :call cscope#find('f', expand('<cword>'))<CR>
  nnoremap <silent> <leader>fi :call cscope#find('i', expand('<cword>'))<CR>
endif
"}}}
" code break {{{
Plug 'johngrib/vim-game-code-break'
"}}}
" dispatch {{{
Plug 'tpope/vim-dispatch'
"}}}
" fugitive {{{
Plug 'tpope/vim-fugitive'
"}}}
" gitgutter {{{
Plug 'airblade/vim-gitgutter'
let g:gitgutter_sign_added = '▶'
let g:gitgutter_sign_modified = '▶'
let g:gitgutter_sign_modified_removed = '▼'
let g:gitgutter_sign_removed = '▼'
let g:gitgutter_sign_removed_first_line = '▲'
nmap <leader>hn :GitGutterNextHunk<CR>
nmap <leader>hp :GitGutterPrevHunk<CR>
nmap <leader>hu :GitGutterUndoHunk<CR>
nmap <silent> <c-n> ]c
"}}}
" gruvbox {{{
Plug 'matt1003/gruvbox'
let g:gruvbox_contrast_dark = 'hard'
let g:gruvbox_number_column = 'bgN'
let g:gruvbox_sign_column = 'bgN'
let g:gruvbox_italic = 1
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
" hexmode {{{
Plug 'fidian/hexmode'
"}}}
" ifdef highlighting --------(highlighting of c #ifdef blocks) {{{
Plug 'vim-scripts/ifdef-highlighting'
"}}}
" indexed search ------------(count current search results) {{{
Plug 'henrik/vim-indexed-search'
let g:indexed_search_numbered_only = 1
let g:indexed_search_dont_move = 1
let g:indexed_search_max_lines = 500000
"}}}
" match maker ---------------(highlight current word) {{{
"
Plug 'qstrahl/vim-matchmaker'
let g:matchmaker_enable_startup = 1
let g:matchmaker_matchpriority = -1
augroup MatchMakerColor
  autocmd!
  autocmd ColorScheme * highlight MatchMaker ctermbg=241 guibg=#665c54
augroup END
"}}}
" match parentheses always --(highlight matching parentheses) {{{
Plug 'justinmk/vim-matchparenalways', {'tag':'8fe259720a'}
"}}}
" mucomplete ----------------(insert mode auto completion) {{{
Plug 'lifepillar/vim-mucomplete'
let g:mucomplete#enable_auto_at_startup = 1
set completeopt+=menuone
set completeopt-=preview
if v:version >= 800 || has ('nvim')
  set completeopt+=noinsert
endif
"}}}
" multiple search -----------(highlight search results in different colors) {{{
Plug 'vim-scripts/MultipleSearch'
silent! map <F5> :call MultipleSearch#MultipleSearch(bufnr('%'), expand('<cword>'))<CR>
silent! map <F6> :SearchReset<CR>
"}}}
" nerdtree {{{
Plug 'scrooloose/nerdtree'
let g:NERDTreeWinSize = 40
let g:NERDTreeMinimalUI = 1
"}}}
" numbers {{{
Plug 'myusuf3/numbers.vim'
let g:numbers_exclude = ['help', 'nerdtree', 'tagbar', 'qf', 'undotree']
"}}}
" powerline fonts {{{
Plug 'powerline/fonts'
"}}}
" quickr-preview {{{
Plug 'matt1003/quickr-preview.vim'
let g:quickr_preview_on_cursor = 0
let g:quickr_preview_sign_enable = 0
let g:quickr_preview_on_cursor = 1
let g:quickr_preview_line_hl = 'IncSearch'
let g:quickr_preview_options = 'number norelativenumber nofoldenable nocursorline colorcolumn=0 numberwidth=6 signcolumn=no'
"}}}
" replace with register -----(delete and paste) {{{
Plug 'vim-scripts/ReplaceWithRegister'
"}}}
" sensible ------------------(sensible vim defaults) {{{
Plug 'tpope/vim-sensible'
"}}}
" sleuth --------------------(auto detect file indentation) {{{
Plug 'tpope/vim-sleuth'
"}}}
" surround {{{
Plug 'tpope/vim-surround'
"}}}
" syntax-extra --------------(improved c syntax highlighting) {{{
Plug 'justinmk/vim-syntax-extra'
"}}}
" tagbar {{{
Plug 'majutsushi/tagbar'
let g:tagbar_compact = 1
let g:tagbar_indent = 1
let g:tagbar_silent = 1
augroup TagBarColor
  autocmd!
  autocmd ColorScheme * highlight link TagbarHighlight IncSearch
augroup END
"}}}
" terminus {{{
Plug 'wincent/terminus'
"}}}
" tmux-navigator {{{
Plug 'christoomey/vim-tmux-navigator'
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
call plug#end()

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" gui settings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" set the color scheme
if &term !=? 'linux'
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
  if v:version >= 800 || has ('nvim')
    set termguicolors
  else
    hi Normal ctermbg=None
    hi LineNr ctermbg=None
    hi SignColumn ctermbg=None
  endi
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" file specific settings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

augroup FileSpecificSettings
  autocmd!
  " git commit message
  autocmd FileType gitcommit setlocal colorcolumn=73
  " non-editable buffers
  autocmd FileType help,nerdtree,tagbar,qf,undotree setlocal nolist nospell signcolumn=no colorcolumn=0
augroup END

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" custom keybindings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

nmap <leader>o :<C-U>call append(line('.'), repeat([''], v:count1))<CR>
nmap <leader>O :<C-U>call append(line('.')-1, repeat([''], v:count1))<CR>

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
  let l:buflist = filter(range(1, bufnr('$')), 'buflisted(v:val)')
  let l:unsavbuflist = []
  for l:bufnr in l:buflist
    if getbufvar(l:bufnr, '&modified')
      call add(l:unsavbuflist, l:bufnr)
    endif
  endfor
  if empty(l:unsavbuflist)
    return
  endif
  for l:bufnr in l:unsavbuflist
    echo bufname(l:bufnr)
  endfor
  while 1
    echohl Question
    let l:anwser = input('Modified files detected! Save all? [Y/N]: ')
    echohl None
    if l:anwser ==? 'Y'
      write all
      return
    elseif l:anwser ==? 'N'
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
  let l:path = getcwd()
  while l:path !=? '/'
      if <SID>IsBuildSysPath(l:path.'/'.s:BuildSysDir)
        return l:path.'/'.s:BuildSysDir
    endif
    let l:path = fnamemodify(l:path, ':h')
  endwhile
  " 3) give up and use the current working directory
  echohl WarningMsg | echo 'Unable to locate buildsys path ...' | echohl None
  return getcwd()
endfun

fun! s:UpdateBuildSysPath()
  let s:BuildSysPath = input('buildsys path: ', <SID>LocateBuildSysPath(), 'dir')
endfun

fun! s:ExecuteBuildSys(BuildSysArgs)
  if a:BuildSysArgs ==? 'error'
    Copen
    let @/ = 'error:'
  else
    call <SID>CheckForModifiedBuffers()
    call <SID>UpdateBuildSysPath()
    exe 'Dispatch! -compiler=make -dir='.s:BuildSysPath.' '.s:BuildSysCmd.' '.a:BuildSysArgs
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
  if a:word !=? ''
    let l:escaped = shellescape(a:word)
  else
    let l:escaped = shellescape(expand('<cword>'))
  endif
  let s:GrepWord = input('search pattern: ', l:escaped)
endfun

fun! s:UpdateGrepPath(path)
  let s:GrepPath = input('search path: ', a:path, 'dir')
  if s:GrepPath ==? 'reset'
    let s:GrepPath = input('search path: ', s:DefaultGrepPath, 'dir')
  endif
endfun

fun! s:UpdateGrepOpts(opts)
  let s:GrepOpts = input('search flags: ', a:opts)
  if s:GrepOpts ==? 'reset'
    let s:GrepOpts = input('search flags: ', s:DefaultGrepOpts)
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
  if s:GrepShow ==? 'qf'
    let l:total = len(getqflist())
  else
    let l:total = len(getloclist(0))
  endif
  if l:total == 0
    echohl WarningMsg
    echon 'Search for '.s:GrepWord.' returned no results.'
    echohl Normal
    return
  elseif l:total == 1
    echon 'Search for '.s:GrepWord.' returned 1 result.'
  else
    echon 'Search for '.s:GrepWord.' returned '.l:total.' results.'
  endif
  if s:GrepShow ==? 'qf'
    botright copen 12
  else
    botright lwindow 12
  endif
endfun

if s:GrepShow ==? 'qf'
  command! -nargs=* MySearch call <SID>ExecuteGrep('grep! -r', <q-args>)
else
  command! -nargs=* MySearch call <SID>ExecuteGrep('lgrep! -r', <q-args>)
endif

cabbrev grep MySearch
cabbrev ag MySearch

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" useful stuff
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" auto load vimrc
augroup ReloadVimrc
  autocmd!
  autocmd BufWritePost $MYVIMRC nested source $MYVIMRC
augroup END

" enable the cursor line in the active window only
augroup CursorLineOnlyInActiveWindow
  if !&diff
    autocmd!
    autocmd VimEnter,WinEnter,BufWinEnter * setlocal cursorline
    autocmd WinLeave * setlocal nocursorline
  endif
augroup END

" override airline status line to print straight lines when inactive
set fillchars+=vert:│,stlnc:─
fun! RenderNoStatusLine(...)
  return 1
endfun
if isdirectory($VIMHOME.'/plugged/vim-airline')
  call airline#add_inactive_statusline_func('RenderNoStatusLine')
endif

" close all quickfix/location windows
fun! CloseAllQfLocWins()
  windo if &ft == 'qf' | echom 'close qf/loc win (F2)' | lcl | ccl | endif
  call win_gotoid(g:main_win_id)
endfun
silent! map <F2> :call CloseAllQfLocWins()<CR>

" auto update vim diff on write
augroup UpdateDiff
  if &diff
    autocmd!
    autocmd TextChanged * diffupdate
    autocmd BufRead * setlocal cursorline noreadonly
  endif
augroup END

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" write file with sudo rights
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

if !exists('*SudoWrite')
fun! SudoWrite(path, dir)
  silent doautocmd BufWritePre

  if !isdirectory(a:dir)
    if confirm('The directory "'.a:dir.'" does not exits.'."\n".
              \'Do you wish to create it?', "&Yes\n&No", 2) == 1
      " TODO what if we need sudo to create the dir
      call mkdir(a:dir, 'p')
    endif
  endif

  if filereadable(a:path)
    silent execute '![ -w '.a:path.' ]'
    echom '![ -w '.a:path.' ]'
  else
    silent execute '![ -w '.a:dir.'/ ]'
    echom '![ -w '.a:dir.'/ ]'
  endif
  if v:shell_error
    if confirm('You do not have permission to write to "'.a:path.'".'."\n".
              \'Do you wish to write with sudo?', "&Yes\n&No", 2) == 1
      silent write !sudo tee % > /dev/null
      " TODO don't call edit if the write fails
      silent edit!
      redraw
      echo 'sudo write "'.a:path.'"'
    endif
  else
    write
  endif

  doautocmd BufWritePost
endfun

if has ('unix')
  augroup SudoWrite
    autocmd!
    autocmd BufWriteCmd * call SudoWrite(expand("<amatch>:p"), expand("<amatch>:p:h"))
  augroup END
endif
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" download latest vimrc
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

if ! exists(':UpdateVim')

  fun! s:DownloadLatestVimrc()
      if getftype($MYVIMRC) ==# 'link'
        echo 'error: "'.$MYVIMRC.'" is a symlink'
      else
        if confirm('Updating vim config. This will overwrite "'.$MYVIMRC.'".'."\n".
                  \'Do you wish to continue?', "&Yes\n&No", 2) == 1
          execute 'silent !wget -O "'.$MYVIMRC.'" "https://raw.githubusercontent.com/matt1003/dotfiles/master/vimrc"'
        endif
      endif
  endfun

  fun! s:DownloadLatestPlugins()
    if confirm('Updating vim plugins. This may overwrite local changes.'."\n".
              \'Do you wish to continue?', "&Yes\n&No", 2) == 1
      PlugUpgrade
      PlugUpdate
    endif
  endfun

  command! UpdateVim call <SID>DownloadLatestVimrc() | call <SID>DownloadLatestPlugins()

endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" tracking the main window
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:main_win_tm = -1
let g:main_win_id = -1

fun! MainWinHandler(...)
  if &modifiable
    let g:main_win_id = win_getid()
  endif
  "echo ' main='.g:main_win_id.' (win='.win_getid().',mod='.&modifiable.',ft='.&ft.')'
endfun

fun! MainWinTimer()
  call timer_stop(g:main_win_tm)
  let g:main_win_tm = timer_start(250, 'MainWinHandler')
endfun

augroup MainWindowTracking
  autocmd!
  autocmd VimEnter,WinEnter * call MainWinTimer()
augroup END

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" nerd tree auto trace current buffer
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

fun! s:NERDTreeIsOpen()
  return exists('t:NERDTreeBufName') && (bufwinnr(t:NERDTreeBufName) != -1)
endfun

fun! s:NERDTreeSync()
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
  set eventignore+=all
  keepjumps NERDTreeFind
  execute 'match IncSearch /\%'.line('.').'l^\s*\zs.\{-}\ze\s*\(->\|$\)/'
  call win_gotoid(l:win_id)
  set eventignore-=all
endfun

augroup NERDTreeTracking
  autocmd!
  autocmd BufEnter * call s:NERDTreeSync()
augroup END

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ide view
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let s:ide_view = 0

fun! IdeViewToggle(...)
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
endfun

augroup IdeView
  autocmd!
  autocmd VimEnter * if winwidth(0) > 160 | call timer_start(200, 'IdeViewToggle') | endif
augroup END

silent! map <F3> :call IdeViewToggle()<CR>

