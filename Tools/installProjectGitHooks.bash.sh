#!/bin/bash
if [ $# -ge 2 ]; then
	printf "參數錯誤！"
	exit 1
else
	ln --symbolic Git hooks/Astyle_before_commit.precommit.sh .git/hooks/pre-commit
fi
exit 0