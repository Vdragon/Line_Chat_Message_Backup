#!/bin/bash
# 	宣告執行 script 程式用的殼程式(shell)
################## Header block ##################
# Script程式名稱
# Script Name
# 	獲取本專案所需之函式庫的程式
# 著作權宣告
# Copyright Declaration
# 	Ｖ字龍(Vdragon) <Vdragon.Taiwan@gmail.com> (c) 2014
# 授權條款宣告
# License Declaration
# 	請參閱「通用軟體專案範本」的授權條款
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
# main function, program entry point
# idea from http://www.kfirlavi.com/blog/2012/11/14/defensive-bash-programming/
main() {
	set -x
	
	checkIllegalUsage
	
	mkdir --parent "3rd party software"
	cd "3rd party software"

	# 取得 VCCL 函式庫來源程式碼
	git submodule init
	git submodule update

	cd Vdragon_s_C_CPP_Libraries/Buildsystem_CMake
	git pull --force
	# 清掉先前可能有的建構產物，讓 CMake 可以在全空狀態下建構
	git clean -d -X --force
	
	cmake -G "Unix Makefiles" ..
	make
	cp --force --recursive Build/Libraries/* "${project_root_path}/Libraries"
	cp --force --recursive Build/Library_headers/* "${project_root_path}/Library headers"
	cd "${project_root_path}/Libraries"
	ln --symbolic --force */*.a .

	## 正常結束 script 程式
	exit 0
	set +x
}
main