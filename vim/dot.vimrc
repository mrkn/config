set nocompatible

if exists('s:default_runtimepath')
  let &runtimepath=s:default_runtimepath
else
  let s:default_runtimepath=&runtimepath
endif

set runtimepath^=~/src/config.git/vim/dot.vim

set encoding=utf-8
set termencoding=utf-8
set fileencodings=ucs-bom,utf-8,iso-2022-jp,sjis,cp932,euc-jp,cp20932
if has('iconv')
  let s:enc_euc = 'euc-jp'
  let s:enc_jis = 'iso-2022-jp'
endif

function! GetPPID()
  return get(matchlist(system('ps -a -o pid,ppid'), '\s*'.getpid().'\s\+\(\d\+\)'), 1)
endfunction

function! GetParentCommand()
  return get(matchlist(system('ps -a -o pid,command'), '\s*'.GetPPID().'\s\+\(\%(\S\|[^\n]\)\+\)'), 1, '')
endfunction

" backup
if match(GetParentCommand(), '\<crontab\|git\|svn\>') >= 0
  set nobackup
  set nowritebackup
else
  set backup
  set backupdir=.
  set writebackup
endif

set expandtab
set incsearch
set backspace=indent,eol,start
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
set autoindent
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
set wildmenu
set wildmode=longest,list,full
set autoread
set shiftwidth=2
set modeline
set modelines=5
set clipboard=unnamed

set list
set listchars=eol:$,tab:>-,trail:-,extends:>,precedes:<
set viminfo=<50,'10,h,r/a,n~/.viminfo

helptags ~/src/config.git/vim/dot.vim/doc

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

" Normal mode keybinds
nnoremap <Space>bd :BDELETE<Enter>
nnoremap <Space>bn :bn<Enter>
nnoremap <Space>bp :bp<Enter>
nnoremap <Space>w :w<Enter>
nnoremap <Space>q :q<Enter>
nnoremap <Space>n :nohl<Enter>

" Command-line editing keybinds
cnoremap <C-A> <Home>
cnoremap <C-F> <Right>
cnoremap <C-B> <Left>
cnoremap <C-N> <Up>
cnoremap <C-P> <Down>

" New group for autocmd defined in this script
augroup MyAutoCmd
  autocmd!
  autocmd BufEnter * echo expand("%")
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
\ | bprevious
\ | execute "bdelete ".s:current_buffer
\ | unlet s:current_buffer

command! BD
\   BDELETE

nnoremap <C-w><C-D> :BDELETE<Enter>

call s:CMapABC_Add('^bd', 'BD')
call s:CMapABC_Add('^bdelete', 'BDELETE')


filetype plugin indent on

" submodules {{{
let s:submodules_dir = expand('<sfile>:h') . '/submodules'
for dir in split(glob(s:submodules_dir . '/*'), "\n")
  if isdirectory(dir)
    let &runtimepath = dir . ',' . &runtimepath
    let docdir = dir . '/doc'
    if isdirectory(docdir)
      helptags `=docdir`
    endif
  endif
endfor

" surround {{{
if isdirectory(expand("~/src/vim-surround.git"))
  set runtimepath^=~/src/vim-surround.git
  if isdirectory(expand("~/src/vim-surround.git/doc"))
    helptags ~/src/vim-surround.git/doc
  endif
endif
" }}}

" changelog
let g:changelog_timeformat='%c'

" blogger.vim
if filereadable(expand('~/.blogger.vimrc'))
  source ~/.blogger.vimrc
endif

" vimshell {{{
" }}}

" quickrun {{{
if !exists("g:quickrun_config")
  let g:quickrun_config = {}
endif
let g:quickrun_no_default_key_mapping = 1
nnoremap <silent> <Leader>r :<C-u>QuickRun -mode n<CR>:redraw!<CR>
let g:quickrun_config["*"] = {'split' : 'rightbelow vertical'}
" for RSpec {{{
let g:quickrun_config['ruby.rspec'] = {'command': 'rspec'}
" }}}
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

" gist-vim {{{
if isdirectory(expand("~/src/gist-vim.git"))
  " http://mattn.kaoriya.net/software/vim/20081106153534.htm
  if has("unix") && match(system("uname"),'Darwin') != -1
    let g:gist_clip_command = 'pbcopy'
  endif

  set runtimepath^=~/src/gist-vim.git
  if isdirectory(expand("~/src/gits-vim.git/doc"))
    helptags ~/src/gits-vim.git/doc
  endif
endif
" }}}

" neocomplcache {{{
" cf. http://vim-users.jp/2009/07/hack-49/
if isdirectory(expand("~/src/neocomplcache.git"))
  let g:acp_enableAtStartup = 0
  let g:neocomplcache_enable_at_startup = 1
  let g:neocomplcache_smart_case = 1
  let g:neocomplcache_enable_camel_case_completion = 1
  let g:neocomplcache_enable_underbar_completion = 1
  let g:neocomplcache_min_syntax_length = 3
  let g:neocomplcache_manual_completion_start_length = 0
  let g:neocomplcache_lock_buffer_name_pattern = '\*ku\*'
  let g:neocomplcache_dictionary_file_type_lists = {
        \ 'default' : '',
        \ 'vimshell' : $HOME.'~/.vimshell_hist',
        \ 'scheme' : $HOME.'~/.gosh_completions',
        \ 'scala' : $DOTVIM.'/dict/scala.dict',
        \ 'ruby' : $DOTVIM.'/dict/ruby.dict'
        \ }
  if !exists('g:neocomplcache_keyword_patterns')
    let g:neocomplcache_keyword_patterns = {}
  endif
  let g:neocomplcache_keyword_patterns['default'] = '\h\w*'
  let g:neocomplcache_snippets_dir = $HOME.'/snippets'
  let g:neocomplcache_caching_percent_in_statusline = 1

  set runtimepath^=~/src/neocomplcache.git
endif
" }}}

" for Ruby {{{
if has('gui_macvim') && has('kaoriya')
  let s:ruby_libdir = system("ruby -rrbconfig -e 'print Config::CONFIG[\"libdir\"]'")
  let s:ruby_libruby = s:ruby_libdir . '/libruby.dylib'
  if filereadable(s:ruby_libruby)
    let $RUBY_DLL = s:ruby_libruby
  endif
endif

augroup Ruby
  autocmd!
  autocmd BufWinEnter,BufNewFile *_spec.rb
  \   set filetype=ruby.rspec
  " cf. http://tenderlovemaking.com/2009/05/18/autotest-and-vim-integration/
  autocmd FileType ruby
  \   nnoremap <Leader>fd :<C-u>compiler rspec<cr> :cf tmp/autotest.log<cr>
  " rake
  autocmd BufRead,BufNewFile *
  \   if filereadable(expand(getcwd() . "/Rakefile"))
  \ |   compiler rspec
  \ |   if filereadable(expand(getcwd() . "/Gemfile"))
  \ |     let &l:makeprg = "bundle exec rake"
  \ |   else
  \ |     let &l:makeprg = "rake"
  \ |   endif
  \ | endif
augroup END

" cf. http://github.com/ujihisa/config/blob/4cd4f32695917f95e9657feb07b73d0cafa6a60c/_vimrc#L310
function! s:CRuby_setup()
  setlocal tabstop=8 softtabstop=4 shiftwidth=4 noexpandtab
  syntax keyword cType VALUE ID RUBY_DATA_FUNC BDIGIT BDIGIT_DBL BDIGIT_DBL_SIGNED ruby_glob_func
  syntax keyword cType rb_global_variable
  syntax keyword cType rb_classext_t rb_data_type_t
  syntax keyword cType rb_gvar_getter_t rb_gvar_setter_t rb_gvar_marker_t
  syntax keyword cType rb_encoding rb_transcoding rb_econv_t rb_econv_elem_t rb_econv_result_t
  syntax keyword cType RBasic RObject RClass RFloat RString RArray RRegexp RHash RFile RRational RComplex RData RTypedData RStruct RBignum
  syntax keyword cType st_table st_data
  syntax match   cType display "\<\(RUBY_\)\?T_\(OBJECT\|CLASS\|MODULE\|FLOAT\|STRING\|REGEXP\|ARRAY\|HASH\|STRUCT\|BIGNUM\|FILE\|DATA\|MATCH\|COMPLEX\|RATIONAL\|NIL\|TRUE\|FALSE\|SYMBOL\|FIXNUM\|UNDEF\|NODE\|ICLASS\|ZOMBIE\)\>"
  syntax keyword cStatement ANYARGS NORETURN PRINTF_ARGS
  syntax keyword cStorageClass RUBY_EXTERN
  syntax keyword cOperator IMMEDIATE_P SPECIAL_CONST_P BUILTIN_TYPE SYMBOL_P FIXNUM_P NIL_P RTEST CLASS_OF
  syntax keyword cOperator INT2FIX UINT2NUM LONG2FIX ULONG2NUM LL2NUM ULL2NUM OFFT2NUM SIZET2NUM SSIZET2NUM
  syntax keyword cOperator NUM2LONG NUM2ULONG FIX2INT NUM2INT NUM2UINT FIX2UINT
  syntax keyword cOperator NUM2LL NUM2ULL NUM2OFFT NUM2SIZET NUM2SSIZET NUM2DBL NUM2CHR CHR2FIX
  syntax keyword cOperator NEWOBJ OBJSETUP CLONESETUP DUPSETUP
  syntax keyword cOperator PIDT2NUM NUM2PIDT
  syntax keyword cOperator UIDT2NUM NUM2UIDT
  syntax keyword cOperator GIDT2NUM NUM2GIDT
  syntax keyword cOperator FIX2LONG FIX2ULONG
  syntax keyword cOperator POSFIXABLE NEGFIXABLE
  syntax keyword cOperator ID2SYM SYM2ID
  syntax keyword cOperator RSHIFT BUILTIN_TYPE TYPE
  syntax keyword cOperator RB_GC_GUARD_PTR RB_GC_GUARD
  syntax keyword cOperator Check_Type
  syntax keyword cOperator StringValue StringValuePtr StringValueCPtr
  syntax keyword cOperator SafeStringValue Check_SafeStr
  syntax keyword cOperator ExportStringValue
  syntax keyword cOperator FilePathValue
  syntax keyword cOperator FilePathStringValue
  syntax keyword cOperator ALLOC ALLOC_N REALLOC_N ALLOCA_N MEMZERO MEMCPY MEMMOVE MEMCMP
  syntax keyword cOperator RARRAY RARRAY_LEN RARRAY_PTR RARRAY_LENINT
  syntax keyword cOperator RBIGNUM RBIGNUM_POSITIVE_P RBIGNUM_NEGATIVE_P RBIGNUM_LEN RBIGNUM_DIGITS
  syntax keyword cOperator Data_Wrap_Struct Data_Make_Struct Data_Get_Struct
  syntax keyword cOperator TypedData_Wrap_Struct TypedData_Make_Struct TypedData_Get_Struct

  syntax keyword cConstant Qtrue Qfalse Qnil Qundef
  syntax keyword cConstant IMMEDIATE_MASK FIXNUM_FLAG SYMBOL_FLAG

  " for bignum.c
  syntax keyword cOperator BDIGITS BIGUP BIGDN BIGLO BIGZEROP
  syntax keyword cConstant BITPERDIG BIGRAD DIGSPERLONG DIGSPERLL BDIGMAX
endfunction

function! s:CRuby_ext_setup()
  let dirname = expand("%:h")
  let extconf = dirname . "/extconf.rb"
  if filereadable(extconf)
    call s:CRuby_setup()
  endif
endfunction

augroup CRuby
  autocmd!
  autocmd BufWinEnter,BufNewFile ~/src/ruby.git/*.[chy] call s:CRuby_setup()
  autocmd BufWinEnter,BufNewFile ~.ruby/src/ruby.git/*.[chy] call s:CRuby_setup()
  autocmd BufWinEnter,BufNewFile *.{c,cc,cpp,h,hh,hpp} call s:CRuby_ext_setup()
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

" for Rails {{{
if isdirectory(expand("~/src/vim-rails.git"))
  set runtimepath^=~/src/vim-rails.git
endif
" }}}

" for Cucumber {{{
if isdirectory(expand("~/src/vim-cucumber.git"))
  set runtimepath^=~/src/vim-cucumber.git
endif
" }}}

" for rubydoc {{{
function! s:Rubydoc_setup()
  set filetype=BitClust
  syntax match Comment      /^#@#.*$/
  syntax match PreProc      /^#@\(include\|since\|until\)/
  syntax match Todo         /^#@todo.*$/
  syntax match Conditional  /^#@if/
  syntax match Conditional  /^#@else/
  syntax match Conditional  /^#@end/
  syntax match Statement    /@\(param\|return\|raise\|see\)/
  syntax match Constant     /^=\+/
  syntax match Identifier   /^---/
endfunction

augroup Rubydoc
  autocmd!
  autocmd BufWinEnter,BufNewFile *.rd call s:Rubydoc_setup()
augroup END
" }}}

" for unite.vim {{{
" }}}

" for vim-operator-user {{{
" }}}

" for operator-camelize.vim {{{
map <Leader>C <Plug>(operator-camelize)
map <Leader>c <Plug>(operator-decamelize)
" }}}

" for vim-coffee-script {{{
autocmd BufNewFile,BufRead *.coffee set filetype=coffee
autocmd BufNewFile,BufRead *Cakefile set filetype=coffee
" }}}

"
" privacy settings
if filereadable(expand('~/.privacy.vimrc'))
  source ~/.privacy.vimrc
endif

set t_Co=256
set t_AB=[48;5;%dm
set t_AF=[38;5;%dm
if !has('gui_running')
endif
colorscheme mrkn256

set secure

" vim: foldmethod=marker
