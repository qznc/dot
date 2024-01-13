if [ -f ~/.bashrc ]; then
	source ~/.bashrc
fi

if [ -e /home/copacetic/.nix-profile/etc/profile.d/nix.sh ]; then . /home/copacetic/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer
. "$HOME/.cargo/env"
