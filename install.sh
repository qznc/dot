#!/bin/bash
set -e

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

ln -sf bashrc ~/.bashrc
ln -sf vimrc ~/.vimrc
ln -sf vim ~/.vim
ln -sf gdbinit ~/.gdbinit

cp -f gitconfig ~/.gitconfig
git config --global user.email ${EMAIL}
