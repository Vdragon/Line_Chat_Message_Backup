#!/bin/bash
# 	宣告執行 script 程式用的殼程式(shell)的 shebang
################## Header block ##################
# Script程式名稱
# Script Name
# 	3.B手機免root清除重登
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
check_runtime_dependencies() {
	local required_commands="adb tar java sqlite3"
	for a_command in $required_commands; do
		which $a_command >/dev/null
		if test $? -ne 0; then
			printf "錯誤：本程式需要 $a_command 命令，但是該命令不存在於可執行檔搜尋路徑中！\n"
			printf "請確認是否以正確安裝所有本軟體的執行時期依賴軟體！\n"
			exit 1
		fi
	done
}

# main function, program entry point
# idea from http://www.kfirlavi.com/blog/2012/11/14/defensive-bash-programming/
main() {
	trap print_interrupted_message_and_exit INT
	print_software_title "$PROGRAM_NAME"
	
	check_runtime_dependencies
	restart_adb_daemon
	wait_for_adb_device
	
	detect_and_check_device_information
	
 	printf "請在行動裝置點選「備份我的資料」，但請不要設定任何備份加密密碼！\n"
 	adb -d backup -noapk jp.naver.line.android -f "Android Backups/jp.naver.line.android.noapk.ab"
	
	printf "正在解開從行動裝置收到的 Android Backup……\n"
	cd "LINE data workspace"
	java -jar "../第三方軟體/Android Backup Extractor(dragomerlin's fork)/abe.jar" unpack "../Android Backups/jp.naver.line.android.noapk.ab" jp.naver.line.android.noapk.tar >> "../運行時期紀錄檔/Line Chat Message Backup.log"
	if [ $? -ne 0 ]; then
		printf "Android Backup 解包失敗！(Android Backup Extractor)\n"
		print_interrupted_message_and_exit
	fi
	tar --verbose --extract --file jp.naver.line.android.noapk.tar >> "../運行時期紀錄檔/Line Chat Message Backup.log"
	if [ $? -ne 0 ]; then
		printf "Android Backup 解包失敗！(tar)\n"
		print_interrupted_message_and_exit
	fi
	tar --list --file jp.naver.line.android.noapk.tar > jp.naver.line.android.noapk.tar.list

	printf "正在處理 LINE 應用軟體資料……\n"
	#sqlite3 -separator "" -batch jp.naver.line.android/databases/naver_line "DELETE FROM setting WHERE key like '%%';"
	sqlite3 -batch jp.naver.line.android/databases/naver_line "DELETE FROM setting WHERE key like '%%';" >> "../運行時期紀錄檔/Line Chat Message Backup.log"
	if [ $? -ne 0 ]; then
		printf "錯誤：SQLite 資料庫操作失敗！\n"
		printf "有可能新版本 LINE 已經變更資料儲存格式，請於本專案議題追蹤系統回報問題。\n"
		print_interrupted_message_and_exit
	fi
	rm jp.naver.line.android/shared_prefs/jp.naver.line.android.settings.xml
	
	printf "正在重新打包備份檔案……\n"
	cat jp.naver.line.android.noapk.tar.list | pax -wd -f jp.naver.line.android.noapk.patched.tar
	java -jar "../第三方軟體/Android Backup Extractor(dragomerlin's fork)/abe.jar" pack jp.naver.line.android.noapk.patched.tar "../Android Backups/jp.naver.line.android.noapk.patched.ab" >> "../運行時期紀錄檔/Line Chat Message Backup.log"
	if [ $? -ne 0 ]; then
		printf "錯誤：無法打包備份檔案！\n"
		print_interrupted_message_and_exit
	fi
	
	cd ..
	printf "正在還原修正過的備份檔案……\n"
	adb -d restore "Android Backups/jp.naver.line.android.noapk.patched.ab"
	if [ $? -ne 0 ]; then
		printf "錯誤：還原應用軟體資料到行動裝置上發生錯誤！\n"
		print_interrupted_message_and_exit
	fi
	
	printf "所有操作已完成。"
	exit 0
}
main
######## Program ended ########
