#!/bin/bash


# online() ==  0 implies system is online
#          ==  1 implies system is not online
online() {
	nc -z 8.8.8.8 53  >/dev/null 2>&1; echo $?
}

# git-install
# -----------
# Usage:
# git-install <dir> <repo>

# if <dir> exists and online => git pull
# if <dir> exists and offline => nothing
# if <dir> doesn't exit and online => git clone
# if <dir> doesn't exit and offline => exit 1

git-install() {
	dir=$1
	repo=$2
	if [ -d $dir ]; then
		echo "$dir already installed"
		cd $dir
		if [ online ]; then
			echo "online"
			echo "pulling ..."
			git pull
		else
			echo "offline"
		fi
	elif [ online ]; then
		echo "cloning ..."
		git clone $repo
	else
		echo "You need to be online to clone the repository." 2>&1
		exit 1
	fi
}
