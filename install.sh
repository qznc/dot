#!/bin/bash
set -e

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
	EMAIL="beza1e1@web.de"
fi

# install dot-rc files
for file in bashrc vimrc vim gdbinit gitignore tmux.conf
do
	info "symlinking ${file}"
	ln -sf `pwd`/${file} ~/.${file}
done

# install git config
cp -f `pwd`/gitconfig ~/.gitconfig
git config --global user.email ${EMAIL}
info "installed gitconfig"

# install .config files
for dir in fish
do
	mkdir -p ~/.config/$dir
	for file in config/$dir/*
	do
		ln -sf `pwd`/$file ~/.config/$dir/
		info "symlinking $file"
	done
done
