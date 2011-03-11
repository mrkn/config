# -*- mode: sh; coding: utf-8; -*-
# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples
#
# $Id: mrkn-bashrc 28977 2009-01-24 11:36:27Z mrkn $

export RUBYFORGE_USER=mrkn

# Default language and encoding are ja_JP and UTF-8 respectively
export LANG=ja_JP.UTF-8
export LANGUAGE=ja_JP:en_US

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
export HISTCONTROL=ignoredups

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
  debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
xterm*|rxvt*|putty*|screen*)
  PS1='\[\033[0m\]\[\033[1m\]\[\033[38;5;205m\]\h:\w$(if test "`git ls-files 2>/dev/null`"; then echo " ("`git branch 2>/dev/null | grep ^* | cut -b 3-`")"; fi)\[\033[0m\]\n[$(date +%H:%M:%S)#\#]\u\$ '
  ;;
*)
  PS1='\[\033[0m\]\h:\w$(if test "`git ls-files 2>/dev/null`"; then echo " ("`git branch 2>/dev/null | grep ^* | cut -b 3-`")"; fi)\n[$(date +%H:%M:%S)#\#]\u\$ '
  ;;
esac

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

#if [ -f ~/.bash_aliases ]; then
#  . ~/.bash_aliases
#fi

# enable color support of ls and also add handy aliases
if [ "$TERM" != "dumb" ]; then
  if [ `uname -s` = "Darwin" ]; then
    alias ls='ls -G'
    LSCOLORS="gxfxcxdxbxegedabagacad"
    #          : : : : : : : : : : `- 11. directory writable to others, without sticky bit
    #          : : : : : : : : : `- 10. directory writable to others, with sticky bit
    #          : : : : : : : : `- 9. executable with setgid bit set
    #          : : : : : : : `- 8. executable with setuid bit set
    #          : : : : : : `- 7. character special
    #          : : : : : `- 6. block special
    #          : : : : `- 5. executable
    #          : : : `- 4. pipe
    #          : : `- 3. socket
    #          : `- 2. symbolic link
    #          `- 1. directory
    #  a: black
    #  b: red
    #  c: green
    #  d: brown
    #  e: blue
    #  f: magenta
    #  g: cyan
    #  h: light grey
    #  A: bold black, usually shows up as dark grey
    #  B: bold red
    #  C: bold green
    #  D: bold brown, usually shows up as yellow
    #  E: bold blue
    #  F: bold magenta
    #  G: bold cyan
    #  H: bold light grey; looks like bright white
    #  x: default foreground or background
    export LSCOLORS
  else
    eval "`dircolors -b`"
    alias ls='ls --color=auto'
  fi
  #alias dir='ls --color=auto --format=vertical'
  #alias vdir='ls --color=auto --format=long'
fi

if [ `uname -s` = "Darwin" ]; then
  alias ldd='otool -L'
fi

# some more ls aliases
#alias ll='ls -l'
#alias la='ls -A'
#alias l='ls -CF'
alias tree='tree -ACDNp'
if [ -e "/Applications/MacVim.app/Contents/MacOS/Vim" ]; then
  alias vim="/Applications/MacVim.app/Contents/MacOS/Vim"
fi

case `uname -s` in
Darwin*)
  alias gnuplot='env DYLD_LIBRARY_PATH= /opt/local/bin/gnuplot'
  alias emacs='env DYLD_LIBRARY_PATH= /Applications/Emacs.app/Contents/MacOS/Emacs'
  ;;
esac

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ]; then
  . /etc/bash_completion
fi

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"  # This loads RVM into a shell session.
