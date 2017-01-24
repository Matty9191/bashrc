VERSION=4

# HIstory settings 
export HISTFILESIZE=20000
export HISTSIZE=10000
shopt -s histappend
HISTCONTROL=ignoredups

# Location to fetch a bashrc from
bashrc_source="https://raw.githubusercontent.com/Matty9191/bashrc/master/bashrc"
temp_name=$(/usr/bin/mktemp  tmp.XXXXXXXX)
temp_file="/tmp/${temp_name}"

curl -s -o ${temp_file} ${bashrc_source}
version=$(head -1 ${temp_file} | awk -F'=' '/VERSION/ {print $2}')

if [ "${version}" -gt "${VERSION}" ]; then
	cp ${HOME}/.bashrc ${HOME}/.bashrc.bak.$(/bin/date "+%m%d%Y.%S")
	mv ${temp_file} ${HOME}/.bashrc
fi

# Uncompress the file passed as an argument (thanks stackoverflow)
extract () {
   if [ -f $1 ] ; then
       case $1 in
           *.tar.bz2)   tar xvjf $1    ;;
           *.tar.gz)    tar xvzf $1    ;;
           *.bz2)       bunzip2 $1     ;;
           *.rar)       unrar x $1       ;;
           *.gz)        gunzip $1      ;;
           *.tar)       tar xvf $1     ;;
           *.tbz2)      tar xvjf $1    ;;
           *.tgz)       tar xvzf $1    ;;
           *.zip)       unzip $1       ;;
           *.Z)         uncompress $1  ;;
           *.7z)        7z x $1        ;;
           *)           echo "don't know how to extract '$1'..." ;;
       esac
   else
       echo "'$1' is not a valid file!"
   fi
}

# Run the last command with sudo  (thanks stackoverflow)
s() { 
    if [[ $# == 0 ]]; then
       sudo $(history -p '!!')
    else
       sudo "$@"
    fi
}

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

if [ -x /bin/cowsay ] && [ -x /bin/fortune ]; then
	   fortune | cowsay
fi

# User specific aliases and functions
alias rd="/usr/bin/rdesktop -g 1024x768 ${1}:3389"
alias record="/usr/bin/cdrecord -v speed=8 dev=/dev/dvd ${1}"

# Add private settings
. ${HOME}/.private
