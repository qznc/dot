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

for file in bashrc vimrc vim gdbinit;
do
	info "symlinking ${file}"
	ln -sf `pwd`/${file} ~/.${file}
done

cp -f `pwd`/gitconfig ~/.gitconfig
git config --global user.email ${EMAIL}
info "installed gitconfig"
