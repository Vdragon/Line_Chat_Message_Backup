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
	printf "Line 聊天訊息備份（開發中版本）\n"
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