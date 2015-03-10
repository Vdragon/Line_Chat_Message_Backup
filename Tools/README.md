# 專案會用到的工具/<br>Tools/
存放專案會用到的工具程式的目錄

## 注意事項<br />Note
此目錄底下的程式皆需要**以專案的根目錄當作當前工作目錄(current working directory)**來執行

## 本目錄下的項目說明<br />Description of the items under this directory
### [README.md](README.md)
本說明檔案

### [.gitignore](.gitignore)
Git 版本控制系統版本追蹤忽略規則

### [initializeProject.bash.sh](initializeProject.bash.sh)
初始化專案用的 GNU Bash shell script 程式，此程式會刪除先前的 Git 版本倉庫

### [renameProject.bash.sh](renameProject.bash.sh)
重新命名專案名稱

### [acquireRequiredLibrary.bash.sh](acquireRequiredLibrary.bash.sh)
自動設定專案所需的函式庫的程式

### [installProjectGitHooks.bash.sh](installProjectGitHooks.bash.sh)
安裝專案的 Git hook 程式的程式

### [switchCodingStyle.bash.sh](switchCodingStyle.bash.sh)
轉換程式碼風格的程式

### [checkIllegalUsage.bash.source.sh](checkIllegalUsage.bash.source.sh)
檢查腳本程式的當前工作目錄是否不正確的程式庫

### [convertSourceCodeToUTF-8withBOM.bash.sh](convertSourceCodeToUTF-8withBOM.bash.sh)
將來源程式碼的字元編碼改為 UTF-8 帶 byte ordered mark 的腳本程式

### [convertSourceCodeToUTF-8withoutBOM.bash.sh](convertSourceCodeToUTF-8withoutBOM.bash.sh)
將來源程式碼的字元編碼改為 UTF-8 不帶 byte ordered mark 的腳本程式
