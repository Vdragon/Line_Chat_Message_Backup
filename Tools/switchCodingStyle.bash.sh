#!/bin/bash
if [ $# -ge 2 ]; then
	printf "參數錯誤！"
	exit 1
elif [ $# -eq 1 ]; then
	config_file_path="$1"
else
	read -p "請輸入 Astyle 設定檔路徑：" config_file_path
	find "Source code" -regextype posix-extended -regex '.*\.(c|cpp|cc|h|hpp|hh)$' -print -exec astyle --suffix=none --options="${config_file_path}" {} + 

fi
exit 0