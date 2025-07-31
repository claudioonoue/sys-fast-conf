.PHONY: git-backup
git-backup:
	git add .
	git commit -m "chore: backup to git"
	git push origin 

.PHONY: clone-git-req
clone-git-req:
	# TMUX Requirements
	git clone https://github.com/tmux-plugins/tpm ./app-conf/tmux/.config/tmux/plugins/tpm

.PHONY: set-app-conf
set-app-conf:
	stow -v -d app-conf -t ~ -R nvim
	stow -v -d app-conf -t ~ -R zshrc
	stow -v -d app-conf -t ~ -R tmux
	stow -v -d app-conf -t ~ -R kitty

.PHONY: nvim
nvim:
	nvim app-conf/nvim/.config/nvim

.PHONY:	tmux 
tmux:
	nvim app-conf/tmux/.config/tmux

.PHONY:	kitty 
kitty:
	nvim app-conf/kitty/.config/kitty
