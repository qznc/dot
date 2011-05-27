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

ln -sf `pwd`/bashrc ~/.bashrc
ln -sf `pwd`/vimrc ~/.vimrc
ln -sf `pwd`/vim ~/.vim
ln -sf `pwd`/gdbinit ~/.gdbinit

cp -f `pwd`/gitconfig ~/.gitconfig
git config --global user.email ${EMAIL}
