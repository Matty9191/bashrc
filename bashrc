VERSION=38

# History settings 
export HISTFILESIZE=100000
export HISTSIZE=100000
export HISTCONTROL=ignoreboth
export HISTTIMEFORMAT="%F %T "
shopt -s histappend

# Terminal settings
shopt -s checkwinsize

# Location to pull bashrc from
bashrc_source="https://raw.githubusercontent.com/Matty9191/bashrc/master/bashrc"

# Take precaution when playing with temp files
temp_file=$(mktemp /tmp/tmp.XXXXXXXX)
curl -s -o ${temp_file} ${bashrc_source}
RC=$?

if [ ${RC} -eq 0 ]; then
    version=$(head -1 ${temp_file} | awk -F'=' '/VERSION/ {print $2}')

    if [ "${version}" -gt "${VERSION}" ]; then
	echo "Upgrading bashrc from version ${VERSION} to ${version}"
	cp ${HOME}/.bashrc ${HOME}/.bashrc.bak.$(/bin/date "+%m%d%Y.%S")
	mv ${temp_file} ${HOME}/.bashrc
    fi
fi

rm ${temp_file}

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
ss() { 
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

# Have some fun
if [ -x /bin/cowsay ] && [ -x /bin/fortune ]; then
	   fortune | cowsay
fi

# Make PS 1 useful
PS1='\n[\u@\h][RC:$?][\w]$ '

# User specific aliases and functions
alias rd="/usr/bin/rdesktop -g 1024x768 ${1}:3389"
alias record="/usr/bin/cdrecord -v speed=8 dev=/dev/dvd ${1}"
alias ecat="cat -vet ${1}"

# Aliases to be vetted
# alias myip="ip addr | grep -w inet | gawk '{if (NR==2) {$0=$2; gsub(/\//," "); print $1;}}'"
# alias ssh='if [ "$(ssh-add -l)" = "The agent has no identities." ]; then ssh-add; fi; /usr/bin/ssh "$@"'

# Add private settings
test -f ${HOME}/.private && . ${HOME}/.private
