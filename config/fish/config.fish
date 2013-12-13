set -xg EDITOR vim
set -xg PATH $PATH $HOME/bin
set -xg PATH $PATH $HOME/dev/x10i/x10.dist/bin
set -xg PATH $PATH $HOME/dev/dot/bin
set -xg PATH $PATH $HOME/dev/k/bin
set -xg PATH $PATH $HOME/dev/git-annex
set -xg PATH $PATH /data1/zwinkau/sparc-linux-4.4.2-toolchains/multilib/bin
set -xg DEBEMAIL "Andreas Zwinkau <qznc@web.de>"

set -xg LANG "en_US.utf8"
set -xg LANGUAGE "$LANG"
set -xg LC_ALL "$LANG"
set -xg LC_MONETARY "de_DE.utf8"
set -xg LC_MEASUREMENT "de_DE.utf8"
set -xg LC_NUMERIC "de_DE.utf8"
set -xg LC_TIME "de_AT.utf8" # austria has better date formatting

if status --is-login
	echo "Login Shell!"
end

function git_prompt -d "short info about git repos if available"
	if git status >/dev/null ^/dev/null
		set -l branch (git name-rev HEAD --name-only --always ^/dev/null)
		echo "$branch "
	end
end

function notify_long_running -d "clone UndistractMe"
	if [ "$CMD_DURATION" = "" ]
		# A short running command. Assume active window is my window.
		set -g MY_WINDOW_ID (xprop -root _NET_ACTIVE_WINDOW)
	else
		set -l ACTIVE_WINDOW (xprop -root _NET_ACTIVE_WINDOW)
		if [ "$ACTIVE_WINDOW" != "$MY_WINDOW_ID" ]
			notify_long_running.py (echo $CMD_DURATION) (echo $history[1])
		end
	end
end

function fish_prompt -d "Write out the prompt"
  set -l RET $status
  [ "$RET" = "0" ]; or echo $RET" "
	notify_long_running
	set_color red
	if nb remind
		echo " "
		nb skip-remind
	end
	#set_color $fish_color_cwd
	#echo -n (git_prompt)
	set_color cyan
	echo -n '➤ '
	set_color normal
end

function g -d "alias for git"
	git $argv
end

function gup -d "alias for g up"
	g up $argv
end

function st -d "alias for g st"
	g st $argv
end

function gap -d "alias for g add -p"
	g add -p $argv
end

function gl -d "alias for g l"
	g l $argv
end

function gb -d "alias for g bv"
	g bv $argv
end

function gp -d "alias for g psh"
	g psh $argv
end

function gd -d "alias for git-diff"
	git diff --word-diff=color $argv
end

function gg -d "alias for gitg"
	gitg $argv
end

function l -d "alias for ls with some tweaks"
	ls --color=auto -B --group-directories-first -h -v $argv
end

function m -d "alias for make"
	make LANG=C --warn-undefined-variables $argv
end

function c -d "alias for cd"
	cd $argv
end

function v -d "alias for vim"
	vim -X $argv
end

function p -d "alias for pwd"
	pwd $argv
end

function go -d "alias for xdg-open"
	xdg-open $argv
end

function vin -d "alias for vixn"
	vixn $argv &
end

function ta -d "alias for textadept"
	textadept $argv &
end

function todo -d "txt notebook"
	vim ~/Dropbox/todo.txt
end

function journal -d "journal inside pvw"
	nb journal
end

function ta -d "alias for textadept"
	textadept -f $argv &
end

function analyse_history -d "analyze fish shell history for often used commands"
	grep -v "^#" $HOME/.config/fish/fish_history | sort | uniq -c | sort -n | tail -n 32
end

function LANGC -d "set LANG=C for a single command"
	begin; set -lx LANG C; eval $argv; end
end

function cl -d "cd and ls"
	cd $argv; and ls -t --color=always -x | head -n3 -q
end

function fish_greeting
	echo -n "Hello World! "
	set_color cyan
	date
	set_color normal
end

function ycomp -d "graph GUI for yFiles"
	/afs/info.uni-karlsruhe.de/public/java/ycomp/ycomp --dolayout --autoreload $argv
end
