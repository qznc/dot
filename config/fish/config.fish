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
	or echo $status" "
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
	v $argv
end

function p -d "alias for pwd"
	pwd $argv
end

function go -d "alias for xdg-open"
	xdg-open $argv
end

function vin -d "alias for vixn"
	vixn $argv
end

function todo -d "txt notebook"
	vim ~/Dropbox/todo.txt
end

function journal -d "journal inside pvw"
	nb journal
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

set -xg EDITOR vim
set -xg PATH $PATH $HOME/bin $HOME/dev/x10i/x10.dist/bin $HOME/dev/dot/bin
