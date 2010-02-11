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
  #PS1='${debian_chroot:+($debian_chroot)}\[\e[0;33m\][$(date +%H:%M:%S)#\#]\[\e[1;32m\]\u@\h\[\e[00m\]:\[\e[1;34m\]\w\[\e[0m\]\$ '
  WORKING_DIRECTORY='\[\e[$[COLUMNS-$(echo -n " (\w)" | wc -c)]C\e[1;35m(\w)\e[0m\e[$[COLUMNS]D\]'
  PS1=${WORKING_DIRECTORY}'${debian_chroot:+($debian_chroot)}\[\e[0;33m\][$(date +%H:%M:%S)#\#]\[\e[1;32m\]\u@\h\[\e[00m\]\$ '
  ;;
*)
  PS1='${debian_chroot:+($debian_chroot)}[$(date +%H:%M:%S)(\#)]\u@\h:\w\$ '
  ;;
esac

# Comment in the above and uncomment this below for a color prompt
#PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u#\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

# # If this is an xterm set the title to user@host:dir
# case "$TERM" in
# xterm*|rxvt*|putty*)
#   PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD/$HOME/~}\007"'
#   ;;
# *)
#   ;;
# esac

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
