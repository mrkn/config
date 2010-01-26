set nocompatible

if !has('gui_running')
  set t_Co=256
  colorscheme desert256
endif

set encoding=UTF-8
set termencoding=UTF-8
if has('iconv')
  let s:enc_euc = 'euc-jp'
  let s:enc_jis = 'iso-2022-jp'
endif

set expandtab
set incsearch
set list
set listchars=eol:$,tab:>\ ,extends:<
set backspace=indent,eol,start
if exists('$VIM_CRONTAB')
  set nobackup
  set nowritebackup
else
  set backup
  set backupdir=.
  set writebackup
endif
set directory-=.
set noequalalways
set history=100
set hlsearch
set mouse=
set ruler
set showcmd
set showmode
set smartcase
set smartindent
set smarttab
set updatetime=60000
set title
set titlestring=vi:\ %f\ %h%r%m
set number
set numberwidth=6
set shiftwidth=2
set showmatch
set tabstop=2
set whichwrap=b,s,h,l,<,>,[,]
set nowrapscan

set viminfo=<50,'10,h,r/a,n~/.viminfo

helptags ~/.vim/doc

"statusline
set laststatus=2
set statusline=[%{strftime('%m-%d\ %H:%M')}]\ %F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [ASCII=\%03.3b]\ [POS=%04l,%04v,%04c][%p%%]\ [LEN=%L]

" stop automatic turn on/off of input method editor
set iminsert=0
set imsearch=1

" syntax coloring
syntax on
filetype on
filetype indent on
filetype plugin on

" New group for autocmd defined in this script
augroup MyAutoCmd
  autocmd!
augroup end


" CMapABC: support input for Alternate Built-in Commands
let s:CMapABC_Entries = []
function! s:CMapABC_Add(original_pattern, alternate_name)
  call add(s:CMapABC_Entries, [a:original_pattern, a:alternate_name])
endfunction

cnoremap <expr> <Space>  <SID>CMapABC()
function! s:CMapABC()
  let cmdline = getcmdline()
  for [original_pattern, alternate_name] in s:CMapABC_Entries
    if cmdline =~# original_pattern
      return "\<C-u>" . alternate_name . ' '
    endif
  endfor
  return ' '
endfunction


" Alternate :cd command which use 'cdpath' for completion
command! -complete=customlist,<SID>CommandComplete_cdpath -nargs=1 CD
\   TabCD <args>

function! s:CommandComplete_cdpath(arglead, cmdline, cursorpos)
  return split(globpath(&cdpath, a:arglead . '*/'), "\n")
endfunction

call s:CMapABC_Add('^cd', 'CD')


" Per-tab current directory
command! -nargs=1 TabCD
\   execute 'cd' <q-args>
\ | let t:cwd = getcwd()
\ | e .

autocmd MyAutoCmd TabEnter *
\   if !exists('t:cwd')
\ |   let t:cwd = getcwd()
\ | endif
\ | execute 'cd' t:cwd


" Alternate bdelete for keeping window layout
command! BDELETE
\   let s:current_buffer = bufnr("%")
\ | enew
\ | execute "bdelete ".s:current_buffer
\ | unlet s:current_buffer

command! BD
\   BDELETE

call s:CMapABC_Add('^bd', 'BD')
call s:CMapABC_Add('^bdelete', 'BDELETE')

filetype plugin indent on

" blogger.vim
if filereadable(expand('~/.blogger.vimrc'))
  source ~/.blogger.vimrc
endif

" hatena.vim
let g:hatena_user='mrkn'

set secure

