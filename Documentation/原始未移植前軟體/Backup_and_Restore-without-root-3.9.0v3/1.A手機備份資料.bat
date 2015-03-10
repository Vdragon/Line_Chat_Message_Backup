@echo off
rem adb -d backup -noapk com.android.providers.settings -f setting.ab
rem "C:\Program Files (x86)\Java\jre7\bin\java" -jar abe.jar unpack  setting.ab  setting.tar >> e.log
rem echo "test"


SETLOCAL ENABLEDELAYEDEXPANSION

rem Find Java
rem set JAVA_HOME=
rem for /f %%a in ('find_java.exe -s') do set JAVA_HOME=%%a
rem if not defined JAVA_HOME goto ERROR_NOJAVA

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
adb -d backup -apk jp.naver.line.android -f backup.ab
IF ERRORLEVEL 1 goto ERROR_BACKUP

exit
:ERROR_BACKUP
echo ========================================
echo 發生錯誤：你的adb backup和手機端發生問題
echo 請檢查電腦是否有安裝手機的USB偵錯驅動
echo 也請確定電腦只連接了一隻手機
pause
exit

:ERROR_VERSION
echo ===================================================
echo 發生錯誤：Android版本需要4.0以上...才可以使用本程式
pause
exit

:ERROR_ADBSTARTUP
cls
echo adb重新啟動失敗
pause
exit


