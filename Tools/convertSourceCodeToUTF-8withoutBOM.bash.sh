#!/bin/bash
# 	宣告執行 script 程式用的殼程式(shell)的 shebang
################## Header block ##################
# Script程式名稱
# Script Name
# 	將所有原始程式碼轉換為帶有 BOM 的 UTF-8 編碼的格式
# 著作權宣告
# Copyright Declaration
# 	Ｖ字龍(Vdragon) <pika1021@gmail.com> (c) 2012
# 授權條款宣告
# License Declaration
# 	GNU Lesser General Public License version 3.0 or later
# 	http://www.gnu.org/licenses/lgpl.html
# 傳回值定義
# Return Value Definition
# 	0
# 		正常結束
# 已知問題
# Known Issues
# 	Known issues is now tracked on GitHub
# 	
# 修訂紀錄
# Changelog
# 	Changelog is now tracked using Git repostiory commit log
# 	
############## Header block ended ##############

######## File scope variable definitions ########
# idea from http://www.kfirlavi.com/blog/2012/11/14/defensive-bash-programming/
readonly PROGRAM_NAME="$(basename $0)"
readonly PROGRAM_DIRECTORY="$(readlink -m $(dirname $0))"
readonly PROGRAM_ARGUMENT_ORIGINAL_LIST="$@"
readonly PROGRAM_ARGUMENT_ORIGINAL_NUMBER=$#
readonly project_root_path="${PROGRAM_DIRECTORY}/.."

######## File scope variable definitions ended ########

######## Included files ########
source "${project_root_path}/Tools/checkIllegalUsage.bash.source.sh"

######## Included files ended ########

######## Program ########
prepare3rdPartySoftware() {
	mkdir --parent 3rd_party_software
	cd 3rd_party_software
	if [ ! -d "addUTF-8bomb" ]; then
		git clone 'https://github.com/Vdragon/addUTF-8bomb'
	else
		cd addUTF-8bomb
		git pull --force
	fi
	cd "${project_root_path}"
	return
}

# main function, program entry point
# idea from http://www.kfirlavi.com/blog/2012/11/14/defensive-bash-programming/
main() {
	set -x
	checkIllegalUsage
	prepare3rdPartySoftware
	
	find "Source code" -path 'Source code/CMakeFiles' -prune -o  -regextype posix-extended -regex '.*\.(c|cpp|cc|h|hpp|hh)$' -exec bash 3rd_party_software/addUTF-8bomb/Executables/removeUTF-8bomb {} \;
	## 正常結束 script 程式
	exit 0
	set +x
}
main
######## Program ended ########