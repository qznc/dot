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

function todo -d "txt notebook"
	vim ~/Dropbox/TODO.txt
end

set -xg EDITOR vim
