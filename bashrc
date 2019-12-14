VERSION=89
# Author: Matty < matty91 at gmail dot com >
# Last Updated: 11-29-2018
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

# History settings 
export PATH=/bin:/usr/bin:/usr/local/bin:/sbin:/usr/sbin:/usr/games:/opt/VSCode-linux-x64:/home/matty/bin
export HISTFILESIZE=100000
export HISTSIZE=100000
export HISTCONTROL=ignoreboth
export HISTTIMEFORMAT="%F %T "

# Make PS 1 useful
prompt() {
    export PS1="${CUSTOM_PS1:-\n[\u@$(hostname -f)][RC:$?][\w]$ }"
}
PROMPT_COMMAND=prompt


# Append to the history file
shopt -s histappend

# Terminal settings
shopt -s checkwinsize

# Default location to place virtual environments
export WORKON_HOME=/home/matty/virtualenv
export PROJECT_HOME=/home/matty/virtualenv

# GO workspace path
GOPATH=$HOME/go

# View markdown files from the command line
vmd() {
    pandoc "${1}" | lynx --stdin
}

# Create a new GO workspace if it doesn't exist
gows() {
    if [ ! -d "${GOPATH}" ]; then
        echo "Setting up a go workspace in ${GOPATH}"
        mkdir -p ${GOPATH} ${GOPATH}/src ${GOPATH}/bin ${GOPATH}/pkg
        mkdir -p ${GOPATH}/src/github.com/Matty9191
    fi
}

# Update bashrc to a newer version
update() {
    bashrc_source="https://raw.githubusercontent.com/Matty9191/bashrc/master/bashrc"
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
            mv -f ${temp_file} ${HOME}/.bashrc
        fi
    else
        echo "Unable to retrieve a bashrc from ${bashrc_source}"
        rm ${temp_file}
    fi
}

dict() {
        if [ "${1}" != "" ]
        then     
                lynx -cfg=/dev/null -dump "http://www.dictionary.com/cgi-bin/dict.pl?term=$1" | more
        else
                echo "USAGE: dict word"
        fi
}

nrange() {
        lo=$1
        hi=$2
        while [ $lo -le $hi ]
        do 
                echo -n $lo " "
                lo=`expr $lo + 1`
        done
}

dnsfinger() {
   domain=${1}

   grep -F ${domain} /var/named/chroot/logs/named.queries | awk -F'[()]+' '{print $2}' | sort | uniq
}

malloc() {
    bytes=$((${1} * 1024*1024))
    echo "Allocating ${bytes}-bytes of memory"
    yes | tr \\n x | head -c ${bytes} | grep n
}

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

# User specific aliases and functions
alias webshare="python -m SimpleHTTPServer 8000"
alias smtptestserver="python -m smtpd -c DebuggingServer -n localhost:8025"
alias uup="apt update && apt upgrade && apt dist-upgrade"
alias cup="yum -y update"
alias rd="/usr/bin/rdesktop -g 1024x768 ${1}:3389"
alias record="/usr/bin/cdrecord -v speed=8 dev=/dev/dvd ${1}"
alias ecat="cat -vet ${1}"
alias syncsystime="hwclock --set --date="`date "+%Y-%m-%d %H:%M:%S"`" --utc"
alias k="kubectl"
alias shot="gnome-screenshot -i"
alias dracut_updatekernel="dracut -f –v"
alias iptables-all="iptables -vL -t filter && iptables -vL -t nat && iptables -vL mange && iptables -vL -t raw && iptables -vL -t security"
alias iptables-clean="iptables -F && iptables -t nat -F && iptables -t mangle -F && iptables -X"
alias ipconfig="ip -c a"
alias dockerc='docker rm $(docker ps -a -q)'
alias dockeric='docker rmi $(docker images | grep "^<none>" | awk "{print $3}")'


# Aliases to be vetted
# alias myip="ip addr | grep -w inet | gawk '{if (NR==2) {$0=$2; gsub(/\//," "); print $1;}}'"
# alias ssh='if [ "$(ssh-add -l)" = "The agent has no identities." ]; then ssh-add; fi; /usr/bin/ssh "$@"'
# set -o ignoreeof

if [ ! -S ~/.ssh/ssh_auth_sock ]; then
    eval `ssh-agent`
    ln -sf "$SSH_AUTH_SOCK" ~/.ssh/ssh_auth_sock
fi
export SSH_AUTH_SOCK=~/.ssh/ssh_auth_sock
ssh-add -l > /dev/null || ssh-add

# Source the kubectl auto completion functions
if [[ -x $(command -v kubectl) ]]; then
    source <(kubectl completion bash)
fi

# Use direnv to add variables to the environment
if [[ -x "$(command -v direnv)" ]]; then
    eval "$(direnv hook bash)"
fi

# Add private settings
test -f ${HOME}/.private && source ${HOME}/.private
