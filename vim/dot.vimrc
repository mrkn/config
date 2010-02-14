set nocompatible
set runtimepath&

set encoding=UTF-8
set termencoding=UTF-8
if has('iconv')
  let s:enc_euc = 'euc-jp'
  let s:enc_jis = 'iso-2022-jp'
endif

set expandtab
set incsearch
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
set noequalalways " http://vim-users.jp/2009/06/hack31/
set hidden
set history=100
set hlsearch
set mouse=
set ruler
set showcmd
set showmode
set ignorecase
set smartcase
set nosmartindent
set splitright
set splitbelow
set updatetime=60000
set title
set titlestring=vi:\ %f\ %h%r%m
set number
set numberwidth=6
set showmatch
set whichwrap=b,s,h,l,<,>,[,]
set nowrapscan
set cursorline
set switchbuf=useopen
set wildmode=list:longest
set autoread
set shiftwidth=2

set list
set listchars=eol:$,tab:>-,trail:-,extends:>,precedes:<
set viminfo=<50,'10,h,r/a,n~/.viminfo


helptags ~/.vim/doc

"statusline
set laststatus=2
set statusline=[%{strftime('%m-%d\ %H:%M')}]\ %F%m%r%h%w[FMT=%{&ff}][T=%Y][ASC=\%03.3b][%04l,%04v,%04c;%p%%][L=%L]

" stop automatic turn on/off of input method editor
set iminsert=0
set imsearch=1

" syntax coloring
syntax on
filetype indent plugin on

" omni-completion {{{
" cf. http://vim-users.jp/2009/11/hack96/
autocmd FileType *
\   if &l:omnifunc == ''
\ |   setlocal omnifunc=syntaxcomplete#Complete
\ | endif
" }}}

" Command-line editing keybinds
cnoremap <C-A> <Home>
cnoremap <C-F> <Right>
cnoremap <C-B> <Left>

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

" changelog
let g:changelog_timeformat='%c'

" blogger.vim
if filereadable(expand('~/.blogger.vimrc'))
  source ~/.blogger.vimrc
endif

" vimshell
if isdirectory(expand("~/src/vimshell.git")) && isdirectory(expand("~/src/vimproc.git"))
  set runtimepath^=~/src/vimshell.git,~/src/vimproc.git
  if isdirectory(expand("~/src/vimshell.git/doc"))
    helptags ~/src/vimshell.git/doc
  endif
  if isdirectory(expand("~/src/vimproc.git/doc"))
    helptags ~/src/vimproc.git/doc
  endif
endif

" quickrun {{{
if isdirectory(expand("~/src/vim-quickrun.git"))
  if !exists("g:quickrun_config")
    let g:quickrun_config = {}
  endif
  let g:quickrun_config["*"] = {'split' : 'rightbelow vertical'}

  set runtimepath^=~/src/vim-quickrun.git
  if isdirectory(expand("~/src/vim-quickrun.git/doc"))
    helptags ~/src/vim-quickrun.git/doc
  endif
endif
" }}}

" git-vim {{{
if isdirectory(expand("~/src/git-vim.git"))
  " http://vim-users.jp/2009/09/hack67/
  let g:git_no_map_default = 1
  let g:git_command_edit = 'rightbelow vnew'
  nnoremap <Space>gd :<C-u>GitDiff --cached<Enter>
  nnoremap <Space>gD :<C-u>GitDiff<Enter>
  nnoremap <Space>gs :<C-u>GitStatus<Enter>
  nnoremap <Space>gl :<C-u>GitLog<Enter>
  nnoremap <Space>gL :<C-u>GitLog -u \| head -10000<Enter>
  nnoremap <Space>ga :<C-u>GitAdd<Enter>
  nnoremap <Space>gA :<C-u>GitAdd <cfile><Enter>
  nnoremap <Space>gc :<C-u>GitCommit<Enter>
  nnoremap <Space>gC :<C-u>GitCommit --amend<Enter>
  nnoremap <Space>gp :<C-u>Git push

  set runtimepath^=~/src/git-vim.git
  if isdirectory(expand("~/src/git-vim.git/doc"))
    helptags ~/src/git-vim.git/doc
  endif
endif
" }}}

" neocomplcache {{{
" cf. http://vim-users.jp/2009/07/hack-49/
if isdirectory(expand("~/src/neocomplcache.git"))
  let g:NeoComplCache_EnableAtStartup = 1
  let g:NeoComplCache_SmartCase = 1
  let g:NeoComplCache_EnableCamelCaseCompletion = 1
  let g:NeoComplCache_EnableUnderbarCompletion = 1
  let g:NeoComplCache_MinSyntaxLength = 3
  let g:NeoComplCache_ManualCompletionStartLength = 0
  let g:NeoComplCache_CachingPercentInStatusline = 1
  let g:NeoComplCache_DictionaryFileTypeLists = {
        \ 'default' : '',
        \ 'vimshell' : $HOME.'~/.vimshell_hist',
        \ 'scheme' : $HOME.'~/.gosh_completions',
        \ 'scala' : $DOTVIM.'/dict/scala.dict',
        \ 'ruby' : $DOTVIM.'/dict/ruby.dict'
        \ }
  if !exists('g:NeoComplCache_KeywordPatterns')
    let g:NeoComplCache_KeywordPatterns = {}
  endif
  let g:NeoComplCache_KeywordPatterns['default'] = '\v\h\w*'
  let g:NeoComplCache_SnippetsDir = $HOME.'/snippets'

  set runtimepath^=~/src/neocomplcache.git
endif
" }}}

" for Ruby {{{
" cf. http://github.com/ujihisa/config/blob/4cd4f32695917f95e9657feb07b73d0cafa6a60c/_vimrc#L310
augroup Ruby
  autocmd!
  autocmd BufWinEnter,BufNewFile ~/src/ruby-trunk.svn/*.c setlocal tabstop=8 noexpandtab
  autocmd BufWinEnter,BufNewFile ~/src/ruby-trunk.svn/*.y setlocal tabstop=8 noexpandtab
  autocmd BufWinEnter,BufNewFile ~/src/ruby.git/*.c setlocal tabstop=8 noexpandtab
  autocmd BufWinEnter,BufNewFile ~/src/ruby.git/*.y setlocal tabstop=8 noexpandtab
augroup END
" }}}

" for RubySpec {{{
" cf. http://github.com/ujihisa/config/blob/4cd4f32695917f95e9657feb07b73d0cafa6a60c/_vimrc#L317
augroup RubySpec
  autocmd!
  autocmd BufWinEnter,BufNewFile ~/src/mspec.git/*.rb
        \ let b:quickrun_config.ruby = {
        \   'command' : '/usr/bin/env ruby ~/src/mspec.git/bin/mspec -t /opt/ruby/trunk/bin/ruby'
        \ }
augroup END
" }}}

" privacy settings
if filereadable(expand('~/.privacy.vimrc'))
  source ~/.privacy.vimrc
endif

if !has('gui_running')
  set t_Co=256
endif
colorscheme mrkn256

set secure

