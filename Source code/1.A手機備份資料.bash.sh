#!/bin/bash
# 	宣告執行 script 程式用的殼程式(shell)的 shebang
################## Header block ##################
# Script程式名稱
# Script Name
# 	1.A手機備份資料
# 著作權宣告
# Copyright Declaration
#	本作品為「[「更新版」LINE 聊天室訊息 免root異機備份 / 還原全攻略(For Android) | 電腦王阿達的3C胡言亂語](http://www.kocpc.com.tw/archives/4209)」的衍伸作品。
# 	Ｖ字龍(Vdragon) <Vdragon.Taiwan@gmail.com> (c) 2016
# 授權條款宣告
# License Declaration
# 	請參考本專案介紹文件
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
readonly PROGRAM_DIRECTORY="$(readlink --canonicalize-missing $(dirname $0))"
readonly PROGRAM_ARGUMENT_ORIGINAL_LIST="$@"
readonly PROGRAM_ARGUMENT_ORIGINAL_NUMBER=$#
######## File scope variable definitions ended ########

######## Included files ########
source "$PROGRAM_DIRECTORY/共用程式碼.source.bash.sh"

######## Included files ended ########

######## Program ########
# main function, program entry point
# idea from http://www.kfirlavi.com/blog/2012/11/14/defensive-bash-programming/
main() {
	trap print_interrupt_message INT
	print_software_title "$PROGRAM_NAME"

	restart_adb_daemon
	wait_for_adb_device
	
	detect_and_check_device_information
	
	printf "請到手機端螢幕點選「備份我的資料」，但請不要設定任何備份加密密碼！\n"
	adb -d backup -apk jp.naver.line.android -f "Android Backups/jp.naver.line.android.apk.ab"
	draw_a_line
	if [ $? -ne 0 ]; then
		printf "發生錯誤：在請求 Android® 作業系統進行 LINE 備份作業時發生問題，\n"
		printf "請確定目前電腦是否只有連接一台 Android® 行動裝置。\n"
		pause_and_exit 20
	else
		printf "備份應已成功完成，請繼續進行下一個步驟。\n"
	fi

	## 正常結束 script 程式
	exit 0
}
main
######## Program ended ########
