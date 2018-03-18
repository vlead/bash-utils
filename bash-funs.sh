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

# if <dir> exists and online => git pull origin master
# if <dir> exists and offline => nothing
# if <dir> doesn't exit and online => git clone <repo>
# if <dir> doesn't exit and offline => exit 1

git-install() {
	dir=$1
	repo=$2
	if [ -d $dir ]; then
		echo "$dir already installed"
		if [ online ]; then
			echo "online"
			echo "pulling ..."
			git -C $dir pull origin master
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


# wget-targz
# -----------
# Usage:
# targz-install <dir> <name> <url>

# <dir>  = /tmp
# <name> = foo
# <url> = http://a.com/foo.tar.gz

# if <dir>/<name> exists => already installed
# if <dir> doesn't exit and online => cd wgets; wget <url>; tar -zxvf <name>.tar.gz
# if <dir> doesn't exit and offline => exit 1

targz-install() {
	dir=$1
	name=$2
	url=$3
	if [ -d $dir/$name ]; then
		echo "$name already installed"
	elif [ online ]; then
		cmd="cd $dir; wget $url; tar -zxvf $name.tar.gz"
		echo "cmd=$cmd"
		cd $dir; wget $url; tar -zxvf $name.tar.gz
	else
		echo "You need to be online to install the tar-file." 2>&1
		exit 1
	fi
}
