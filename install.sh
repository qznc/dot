#!/bin/bash
set -eu

function info() {
	echo "${*}" >&2
}

if [ ! -f bashrc ]
then
	echo "Something is wrong. Where is bashrc?"
	exit 1
fi

if [[ `hostname` == i44* ]]
then
	EMAIL="zwinkau@kit.edu"
else
	EMAIL="zwinkau@mailbox.org"
fi

# install dot-rc files and directories
for file in bashrc bash_profile vimrc gvimrc vim gdbinit gitignore tmux.conf muttrc devscripts textadept latexmkrc netsurf xsessionrc ansible.cfg gitconfig
do
	info "symlinking ${file}"
	ln -sf `pwd`/${file} ~/.${file} || true
done

# fortune cookies
pushd config/fortune
strfile my_cookies my_cookies.dat >/dev/null || true
popd

# install .config files
for dir in config/*
do
	mkdir -p ~/.$dir
	for file in $dir/*
	do
		ln -sf `pwd`/$file ~/.$dir/
		info "symlinking $file"
	done
done

# create directories
mkdir -p ~/.cache/vim/{backup,swp,undos}

if [[ "$GDMSESSION" == "ubuntu" ]]
then
	# configure Gnome
	gconftool-2 --set /apps/metacity/general/action_double_click_titlebar toggle_maximize_vertically --type string
	gconftool-2 --set /apps/metacity/general/button_layout "close,minimize,maximize:" --type string
	gconftool-2 --set /apps/gnome-terminal/profiles/Default/custom_command "/usr/bin/fish" --type string
	gconftool-2 --set /apps/gnome-terminal/profiles/Default/use_custom_command "0" --type bool

	# configure Gnome3 via gsettings (successor of gconf)
	while read line; do
		gsettings set $line
	done <"simple_gsettings.save"
	# quoted arguments are not simple
	gsettings set org.gnome.gedit.preferences.editor editor-font "PT Sans 12"
	gsettings set org.gnome.gedit.plugins active-plugins "['docinfo', 'filebrowser', 'spell', 'quickopen', 'wordcompletion', 'modelines', 'time', 'smartspaces']"
fi
