# -*- mode: sh; coding: utf-8; -*-
# ~/.bash_profile: executed by bash(1) for login shells.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.
#
# $Id: mrkn-bash_profile 3544 2007-12-24 15:54:24Z mrkn $

if [ -f /etc/profile ]; then
  . /etc/profile
fi

# the default umask is set in /etc/login.defs
#umask 022

# include .bashrc if it exists
if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi

# set PATH so it includes user's private bin if it exists
if [ -d ~/bin ] ; then
    PATH=~/bin:"${PATH}"
fi
