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
	print_software_title
	printf "正在重新啟動 Android Debug Bridge(ADB) 服務，請稍候片刻……\n"
	adb -d kill-server
	if [ $? -ne 0 ]; then
		printf "錯誤：執行 adb 命令發生錯誤！\n"
		printf "請確定 Android SDK Platform-tools 是否有正確安裝並位於您的可執行檔搜索路徑中。\n"
		pause_and_exit 5
	fi

	adb -d start-server
	if [ $? -ne 0 ]; then
		printf "錯誤：Android Debug Bridge(ADB) 服務啟動失敗！\n"
		printf "此確定是否無其他程式會用到 Android Debug Bridge 服務預設使用的 5555 連接埠。\n"
		pause_and_exit 6
	fi

	printf "偵測是否正確地連接到行動裝置……"
	adb -d wait-for-device
	if [ $? -ne 0 ]; then
		printf "錯誤：Android Debug Bridge(ADB) 服務無法存取行動裝置！\n"
		printf "請確定：\n"
		printf "\t* 行動裝置是否已連接電腦\n"
		printf "\t* 行動裝置的 Android Debug Bridge 驅動程式是否已安裝\n"
		printf "\t* Android Debug Bridge 服務可以讀寫該 USB 裝置\n"
		printf "\t* 行動裝置的 USB 除錯模式是否已啟動。\n"
		pause_and_exit 6
	else
		printf "偵測到裝置。\n"
	fi
	
	manufacturer="$(adb -d shell getprop ro.product.manufacturer | tr --delete "\r\n")"
	model="$(adb -d shell getprop ro.product.model | tr --delete "\r\n")"
	version="$(adb -d shell getprop ro.build.version.release | tr --delete "\r\n")"

	printf "偵測到的行動裝置細節如下：\n"
	printf "\t手機型號：$manufacturer $model\n"
	printf "\tAndroid® 作業系統版本：$version\n"

	if [ "$version" \< "4" ]; then
		draw_a_line
		printf "錯誤：本軟體只相容 4.0.X 版以上的 Android® 作業系統版本。"
		pause_and_exit 10
	fi
	
	pause "如列出來的資訊與您的行動裝置吻合請鍵入 Enter 繼續操作，如不吻合請鍵入 Ctrl-C 結束本程式並移除其他連接到電腦上的 Android® 行動裝置！"
	draw_a_line
	
	printf "請到手機端螢幕點選「備份我的資料」，但請不要設定任何備份加密密碼！\n"
	adb -d backup -apk jp.naver.line.android -f backup.ab
	draw_a_line
	if [ $? -eq 1 ]; then
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
