VERSION=59

# Author: Matty < matty91 at gmail dot com >
# Last Updated: 02-01-2017
# Version history:
#   Version 56: Added links to shortcuts and a few helpful aliases
#   Version 53: Integrated several awesome suggestions from Stephen Cristol 
#   Version  1: Initial Release
# License: 
#  This program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2 of the License, or
#  (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
#  GNU General Public License for more detai

### Cursor movement short cuts
# ctrl-a - move the cursor to the beginning of the current line
# ctrl-e - move the cursor to the end of the current line
# alt-b - move the cursor backwards one word
# alt-f - move the cursor forward one word
# ctrl-k - delete from cursor to the end of the line
# ctrl-u - delete from cursor to the beginning of the line
# alt-d - delete the word in front of the cursor
# ctrl-w - delete the word behind of the cursor

### Equality operators
# ||  logical or (double brackets only)
# &&  logical and (double brackets only)
# <   string comparison (no escaping necessary within double brackets)
# -lt numerical comparison
# =   string matching with globbing
# ==  string matching with globbing (double brackets only, see below)
# =~  string matching with regular expressions (double brackets only , see below)
# -n  string is non-empty        
# -z  string is empty
# -eq  numerical equality
# -ne  numerical inequality

### Shell command execution short cuts
# !$ - all options to last command
# ^ssss^s - replace sss w/ s in the last command

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# History settings 
export HISTFILESIZE=100000
export HISTSIZE=100000
export HISTCONTROL=ignoreboth
export HISTTIMEFORMAT="%F %T "
shopt -s histappend

# Terminal settings
shopt -s checkwinsize

# Protect ourselves from errors and unset variables
set -o nounset
set -o errexit
# set -o pipefail

# Location to pull bashrc from
bashrc_source="https://raw.githubusercontent.com/Matty9191/bashrc/master/bashrc"

# Take precaution when playing with temp files
temp_file=$(mktemp /tmp/bash_auto_update_XXXXXXXX)

curl -s -o ${temp_file} ${bashrc_source}
RC=$?

if [ ${RC} -eq 0 ]; then
    version=$(head -1 ${temp_file} | awk -F'=' '/VERSION/ {print $2}')

    if [ "${version}" -gt "${VERSION}" ]; then
        # Code to offer options rather than auto-updating
        # echo 'There is a new version of .bashrc; see the changes with:'
        # echo '   cmp .bashrc ${temp_file}'
        # echo 'Install changes with:'
        # echo '   cp ${temp_file} .bashrc
	echo "Upgrading bashrc from version ${VERSION} to ${version}"
	cp ${HOME}/.bashrc ${HOME}/.bashrc.$(/bin/date "+%Y%m%d.%H%M%S")
	mv ${temp_file} ${HOME}/.bashrc
    fi
else
    echo "Unable to retrieve a bashrc from ${bashrc_source}"
    rm ${temp_file}
fi

# Uncompress the file passed as an argument (thanks stackoverflow)
extract () {
   if [ -f $1 ] ; then
       case $1 in
           *.tar.bz2)   tar        xvjf $1   ;;
           *.tar.gz)    tar        xvzf $1   ;;
           *.bz2)       bunzip2         $1   ;;
           *.rar)       unrar      x    $1   ;;
           *.gz)        gunzip          $1   ;;
           *.tar)       tar        xvf  $1   ;;
           *.tbz2)      tar        xvjf $1   ;;
           *.tgz)       tar        xvzf $1   ;;
           *.zip)       unzip           $1   ;;
           *.Z)         uncompress      $1   ;;
           *.7z)        7z         x    $1   ;;
           *)           echo "don't know how to extract '$1'..." ;;
       esac
   else
       echo "'$1' is not a valid file!"
   fi
}

# Run the last command with sudo  (thanks stackoverflow)
ss() { 
    if [[ $# == 0 ]]; then
       sudo $(history -p '!!')
    else
       sudo "$@"
    fi
}

# Remove comments from a file
rc() {
    egrep "^#" ${1}
} 

# Have some fun
if [ -x /bin/cowsay ] && [ -x /bin/fortune ] || 
   [ -x /usr/games/cowsay ] && [ /usr/games/fortune ]; then
	   fortune | cowsay
fi

# Make PS 1 useful
PS1='\n[\u@$(hostname -f)][RC:$?][\w]$ '

# User specific aliases and functions
alias webshare="python -m SimpleHTTPServer 8000"
alias uup="apt update && && atp upgrade && apt dist-upgrade"
alias cup="yum -y update"
alias rd="/usr/bin/rdesktop -g 1024x768 ${1}:3389"
alias record="/usr/bin/cdrecord -v speed=8 dev=/dev/dvd ${1}"
alias ecat="cat -vet ${1}"

# Aliases to be vetted
# alias myip="ip addr | grep -w inet | gawk '{if (NR==2) {$0=$2; gsub(/\//," "); print $1;}}'"
# alias ssh='if [ "$(ssh-add -l)" = "The agent has no identities." ]; then ssh-add; fi; /usr/bin/ssh "$@"'
# set -o ignoreeof
# shopt -s no_empty_cmd_completion

# Add private settings
test -f ${HOME}/.private && source ${HOME}/.private

