.PHONY: git-backup
git-backup:
	git add .
	git commit -m "chore: backup to git"
	git push origin main

