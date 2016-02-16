pause() {
	read -p "$1" keyholder
}

pause_and_exit() {
	pause "請鍵入 Enter 以結束本程式。"
	exit $1
}

draw_a_line() {
	printf "－－－－－－－－－－－－－－－－－－－\n"
}

draw_a_line_with_newline() {
	printf "\n"
	draw_a_line
}

print_software_title() {
	printf "Line 聊天訊息備份（開發中版本） - $0\n"
	printf "本作品為「[「更新版」LINE 聊天室訊息 免root異機備份 / 還原全攻略(For Android) | 電腦王阿達的3C胡言亂語](http://www.kocpc.com.tw/archives/4209)」的衍伸作品。\n"
	printf "Ｖ字龍(Vdragon) <Vdragon.Taiwan@gmail.com> (c) 2016\n"
	printf "https://github.com/Vdragon/Line_Chat_Message_Backup\n"
	draw_a_line
}

print_interrupt_message() {
	draw_a_line_with_newline
	printf "程式提前被終止！\n"
	printf "有任何問題請至本軟體的議題追蹤系統回報：\n"
	printf "https://github.com/Vdragon/Line_Chat_Message_Backup/issues\n"
	exit 0
}

restart_adb_daemon() {
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

}

wait_for_adb_device() {
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
}

detect_and_check_device_information() {
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
	
}
