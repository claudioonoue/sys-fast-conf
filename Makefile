.PHONY: git-backup
git-backup:
	git add .
	git commit -m "chore: backup to git"
	git push origin main

.PHONY: set-app-conf
set-app-conf:
	stow -v -d app-conf -t ~ -R nvim
	stow -v -d app-conf -t ~ -R zshrc
	stow -v -d app-conf -t ~ -R tmux
