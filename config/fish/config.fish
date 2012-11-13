if status --is-login
	echo "Login Shell!"
end

function git_prompt -d "short info about git repos if available"
	if git status >/dev/null ^/dev/null
		set -l branch (git name-rev HEAD --name-only --always ^/dev/null)
		echo "$branch "
	end
end

function fish_prompt -d "Write out the prompt"
	set_color $fish_color_cwd
	echo -n (git_prompt)
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

function gst -d "alias for g st"
	g st $argv
end

function gap -d "alias for g add -p"
	g add -p $argv
end

function gg -d "alias for gitg"
	gitg $argv
end

function go -d "alias for gnome-open"
	gnome-open $argv
end

function vin -d "alias for vixn"
	vixn $argv
end

function apt -d "alias for aptitude"
	aptitude $argv
end

function todo -d "txt notebook"
	vim ~/Dropbox/todo.txt
end

function pvw -d "personal vim wiki"
	vim ~/Dropbox/pvw/main
end

function analyse_history -d "analyze fish shell history for often used commands"
	grep -v "^#" $HOME/.config/fish/fish_history | sort | uniq -c | sort -n | tail
end

function LANGC -d "set LANG=C for a single command"
	begin; set -lx LANG C; eval $argv; end
end

function cdl -d "cd and ls"
	cd $argv
	ls -t --color=always -x | head -n3 -q
end

set -xg EDITOR vim
set -xg PATH $PATH $HOME/bin $HOME/dev/x10i/x10.dist/bin $HOME/dev/dot/bin
