.PHONY: git-backup
git-backup:
	git add .
	git commit -m "chore: backup to git"
	git push origin main

.PHONY: set-apps-conf
set-apps-conf:
	stow -v -d app-conf -t ~ nvim
	stow -v -d app-conf -t ~ zshrc
	stow -v -d app-conf -t ~ tmux