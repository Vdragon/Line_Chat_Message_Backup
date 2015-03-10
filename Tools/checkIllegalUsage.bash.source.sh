################## Header block ##################
# Script程式名稱
# Script Name
# 	檢查違規使用方式程式庫
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

######## Included files ########

######## Included files ended ########

######## File scope variable definitions ########

######## File scope variable definitions ended ########

checkIllegalUsage() {
	if [ "Tools" == "$(basename "$(readlink --canonicalize-missing "$(pwd)")")" ]; then
		printf "此目錄底下的程式皆需要**以專案的根目錄當作當前工作目錄(current working directory)**來執行，請參考本目錄的說明文件。\n"
		exit 1
	fi
	return
}
