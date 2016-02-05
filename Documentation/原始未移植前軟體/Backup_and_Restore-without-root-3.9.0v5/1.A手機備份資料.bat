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
rem ���s�Ұ�adb
echo adb���s�Ұʤ�...
adb -d kill-server
IF ERRORLEVEL 1 goto ERROR_ADBSTARTUP

adb -d start-server
IF ERRORLEVEL 1 goto ERROR_ADBSTARTUP

rem echo ��������s�u...
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


echo �w��������...
echo ��������G %manufacturer% %model%
echo Android �����G%version%
if %version% LSS 4 goto ERROR_VERSION

echo ======================================


echo �Ш����ݿù��I��ƥ��ڪ���ơA�K�X�Ф��n��J
adb -d backup -apk jp.naver.line.android -f backup.ab
IF ERRORLEVEL 1 goto ERROR_BACKUP

exit
:ERROR_BACKUP
echo ========================================
echo �o�Ϳ��~�G�A��adb backup�M����ݵo�Ͱ��D
echo ���ˬd�q���O�_���w�ˤ����USB�����X��
echo �]�нT�w�q���u�s���F�@�����
pause
exit

:ERROR_VERSION
echo ===================================================
echo �o�Ϳ��~�GAndroid�����ݭn4.0�H�W...�~�i�H�ϥΥ��{��
pause
exit

:ERROR_ADBSTARTUP
cls
echo adb���s�Ұʥ���
pause
exit


