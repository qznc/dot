if status --is-login
	echo "Login Shell!"
end

function fish_prompt -d "Write out the prompt"
	printf '%s%s%s➤%s ' (set_color $fish_color_cwd) (prompt_pwd) (set_color cyan) (set_color normal)
end

function g -d "alias for git"
	git $argv
end

function go -d "alias for gnome-open"
	gnome-open $argv
end

function vin -d "alias for vixn"
	vixn $argv
end

function todo -d "txt notebook"
	vim ~/Dropbox/TODO.txt
end

function LANGC -d "set LANG=C for a single command"
	begin; set -lx LANG C; $argv; end
end

set -xg EDITOR vim
set -xg PATH $PATH $HOME/bin $HOME/dev/x10i/x10.dist/bin
