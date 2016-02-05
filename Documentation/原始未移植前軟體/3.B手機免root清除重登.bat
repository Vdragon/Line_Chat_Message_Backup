@echo off
rem adb -d backup -noapk com.android.providers.settings -f setting.ab
rem "C:\Program Files (x86)\Java\jre7\bin\java" -jar abe.jar unpack  setting.ab  setting.tar >> e.log
rem echo "test"


SETLOCAL ENABLEDELAYEDEXPANSION

rem Find Java
set JAVA_HOME=
for /f %%a in ('find_java.exe -s') do set JAVA_HOME=%%a
if not defined JAVA_HOME goto ERROR_NOJAVA

cls
rem 重新啟動adb
echo adb重新啟動中...
adb -d kill-server
IF ERRORLEVEL 1 goto ERROR_ADBSTARTUP

adb -d start-server
IF ERRORLEVEL 1 goto ERROR_ADBSTARTUP

rem echo 偵測手機連線...
rem adb -d wait-for-device
rem IF ERRORLEVEL 1 goto ERROR_WAIT_DEVICE

FOR /F "tokens=1" %%i IN ('adb -d shell getprop ro.product.manufacturer') DO (
	set manufacturer=%%i
)
FOR /F "delims=/" %%a IN ('adb -d shell getprop ro.product.model') DO (
	set model=%%a
)
FOR /F "tokens=1" %%x IN ('adb -d shell getprop ro.build.version.release') DO (
	set version=%%x		
)


echo 已偵測到手機...
echo 手機型號： %manufacturer% %model%
echo Android 版本：%version%
if %version% LSS 4 goto ERROR_VERSION

echo ======================================


echo 請到手機端螢幕點選備份我的資料，密碼請不要輸入
adb -d backup -noapk jp.naver.line.android -f db.ab
IF ERRORLEVEL 1 goto ERROR_BACKUP

echo 正在取得資料庫的...
%JAVA_HOME% -jar abe.jar unpack db.ab db.tar >> e.log
IF ERRORLEVEL 1 goto ERROR_ABE_UNPACK

:next1
tar -xvf db.tar >> e.log
tar -tf db.tar > db.list
IF ERRORLEVEL 1 goto ERROR_7Z_ERROR

sqlite3.exe -separator "" -batch apps\jp.naver.line.android\db\naver_line "DELETE FROM setting WHERE key like '%%';"
IF ERRORLEVEL 1 goto ERROR_SQLLITE3

del apps\jp.naver.line.android\sp\jp.naver.line.android.settings.xml

cat db.list | pax -wd > new_db.tar

%JAVA_HOME% -jar abe.jar pack new_db.tar new_db.ab
IF ERRORLEVEL 1 goto ERROR_PACK

:next2
echo 正在準備還原，請點選螢幕的還原
adb -d restore new_db.ab

echo 執行成功！
del db.ab
del db.list
del db.tar
del e.log
del new_db.ab
del new_db.tar
rmdir /s/q apps
pause


exit
:ERROR_ADBSTARTUP
cls
echo adb重新啟動失敗
pause
exit

:ERROR_WAIT_DEVICE
cls
echo adb無法等待裝置
pause
exit

:ERROR_VERSION
echo ===================================================
echo 發生錯誤：Android版本需要4.0以上...才可以使用本程式
pause
exit

:ERROR_SHELL
echo ===================================================
echo 發生錯誤：連接手機失敗
pause
exit

:ERROR_ANDROID_ID
echo ====================================================
echo Android ID不能為空白
pause
exit

:ERROR_BACKUP
echo ========================================
echo 備份失敗...
pause
exit

:ERROR_NOJAVA
echo =========================================
echo 請先安裝Java 7(JRE 7)
echo 安裝網址：http://www.java.com/zh_TW/download/
pause
exit

:ERROR_ABE_UNPACK
echo =========================================
echo abe unpack 錯誤
echo ab檔案 unpack tar錯誤
pause
exit

:ERROR_JAVA_32
echo ==========================================
echo 找不到Java 7 (JRE 7)路徑
echo 尋找Java 7 (JRE 7) (x86)路徑
goto JAVA_64

:ERROR_JAVA_64
echo ========================================
echo 找不到Java 7 (JRE 7) (x86)路徑
echo 請先安裝Java 7(JRE 7)
echo 安裝網址：http://www.java.com/zh_TW/download/
pause
exit

:JAVA_64
"C:\Program Files (x86)\Java\jre7\bin\java" -jar abe.jar unpack db.ab db.tar >> e.log
IF ERRORLEVEL 1 goto ERROR_NOJAVA
goto next1


:abeerror
echo ==============================
echo 錯誤！無法取得備份檔案
pause
exit

:ERROR_7Z_ERROR
echo ==============================
echo 解壓執行檔不存在
pause
exit

:extracterror
echo ==============================
echo 解壓縮出來的資料庫錯誤
pause
exit

:ERROR_SQLLITE3
echo ==============================
echo 資料庫執行檔不存在
pause
exit

:DATA_ERROR
echo ==============================
echo 取得AuthKey失敗
pause
exit

:ERROR_PACK
echo ==============================
echo abe pack 錯誤
echo abe pack to ab檔案錯誤
pause
exit

:PACK64
"C:\Program Files (x86)\Java\jre7\bin\java" -jar abe.jar pack new_db.tar new_db.ab
IF ERRORLEVEL 1 goto ERROR_NOJAVA
goto next2


