# If not running interactively, don't do anything
[ -z "$PS1" ] && return
# another test for interactively
if [[ $- != *i* ]]; then
	return
fi		

alias ls='ls -F --color=auto'
alias grep='grep --color=auto'
alias acroread="acroread -openInNewWindow"
alias go="gnome-open"
alias lsdirs="ls -lUd */" # list directories
alias firm_svn_log="svn log svn+ssh://zwinkau@ssh.info.uni-karlsruhe.de/ben/firm/svn/trunk/"
alias ..="cd .."
alias todo="vim ~/Dropbox/TODO.txt"
#alias goto_pbqp_code="cd $HOME/local/firm/libfirm/ir/be/ia32/ia32_pbqp"
#alias quake="ioquake3-firm +game osp +exec my.cfg +connect i44sun3 && cd ~/dev/arenastats && ./firm.sh"

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

set completion-query-items 100  # display at once, if more than this
set show-all-if-ambiguous       # do not wait for the second tab for auto-completion
set completion-ignore-case on   # auto-completion is case-insensitive

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

export EDITOR=vim

export PATH=${HOME}/bin:${PATH}
export PATH=${PATH}:${HOME}/dev/x10i/x10.dist/bin
export PATH=${HOME}/dev/cparser/build:${PATH}

########## COMMAND HISTORY

shopt -s cmdhist # store multiline cmds as one line
HISTSIZE=15000 # per terminal instance
HISTFILESIZE=200000 # global
HISTCONTROL=ignoredups # no duplicates in history
shopt -s histappend # append to the history file, don't overwrite it
PROMPT_COMMAND='history -a' # write history on every prompt, instead of shell exit
alias history_reload="history -n" # load global history into local shell
alias history_analysis="sort ~/.bash_history | uniq -c | sort -rn | head -10"

g() {
   if [[ $# == '0' ]]; then
      git st
   else
      git "$@"
   fi
}

set_titlebar() {
	echo -ne "\033]0;${1}\007"
}

########## SET PROMPT

# LIGHTRED    \[\033[1;31m\]
# LIGHTGREEN  \[\033[1;32m\]
# YELLOW      \[\033[1;33m\]
# LIGHTBLUE   \[\033[1;34m\]
# LIGHTLILA   \[\033[1;35m\]
# LIGHTGREY   \[\033[0;37m\]
# NOCOLOR     \[\033[m\]
case "$USER" in
   beza1e1) # private use
      PS1="\[\033[1;33m\]\$ \[\033[m\]"
      ;;
   zwinkau) # professional use
      PS1="\[\033[1;35m\]\$ \[\033[m\]"
      ;;
esac

########## MACHINE SPECIFIC

case `hostname` in
	i44pc50*)
		source /usr/public/tools/Modules/init/bash

		export PRINTER=hpneu
		export MAIL=${HOME}/.evolution/mail/local/Inbox
		export PATH=${PATH}:${HOME}/dev/x10i/x10.doc/bin

		export JAVA_HOME=/usr/lib/jvm/java-6-sun
		GRGEN_PATH=~/local/eclipse-workspace/GrGen
		CLASSPATH=$CLASSPATH:$GRGEN_PATH/frontend/jars/jargs.jar
		CLASSPATH=$CLASSPATH:$GRGEN_PATH/frontend/jars/antlr.jar
		CLASSPATH=$CLASSPATH:$GRGEN_PATH/engine-net-2/out/bin/grgen.jar
		export CLASSPATH
		
		module add jam
		alias jam="jam -j2"
		module add icc
		module add ycomp
		# ycomp imports jdk but the one in ubuntu is newer
		module rm jdk-1.5.0-sun
		alias ycomp="ycomp --dolayout"
		;;
   localhost*)
      alias eclipse="~/bin/eclipse/eclipse"
esac

