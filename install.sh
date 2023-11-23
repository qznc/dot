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

EMAIL="zwinkau@mailbox.org"

# install dot-rc files and directories
for file in bashrc bash_profile vimrc gvimrc vim gdbinit gitignore tmux.conf muttrc devscripts latexmkrc xsessionrc gitconfig
do
	info "symlinking ${file}"
	ln -sf `pwd`/${file} ~/.${file} || true
done

# fortune cookies
#pushd config/fortune
#strfile my_cookies my_cookies.dat >/dev/null || true
#popd

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
