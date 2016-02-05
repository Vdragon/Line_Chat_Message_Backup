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
adb -d backup -noapk jp.naver.line.android -f db.ab
IF ERRORLEVEL 1 goto ERROR_BACKUP

echo ���b���o��Ʈw��...
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
echo ���b�ǳ��٭�A���I��ù����٭�
adb -d restore new_db.ab

echo ���榨�\�I
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
echo adb���s�Ұʥ���
pause
exit

:ERROR_WAIT_DEVICE
cls
echo adb�L�k���ݸ˸m
pause
exit

:ERROR_VERSION
echo ===================================================
echo �o�Ϳ��~�GAndroid�����ݭn4.0�H�W...�~�i�H�ϥΥ��{��
pause
exit

:ERROR_SHELL
echo ===================================================
echo �o�Ϳ��~�G�s���������
pause
exit

:ERROR_ANDROID_ID
echo ====================================================
echo Android ID���ର�ť�
pause
exit

:ERROR_BACKUP
echo ========================================
echo �ƥ�����...
pause
exit

:ERROR_NOJAVA
echo =========================================
echo �Х��w��Java 7(JRE 7)
echo �w�˺��}�Ghttp://www.java.com/zh_TW/download/
pause
exit

:ERROR_ABE_UNPACK
echo =========================================
echo abe unpack ���~
echo ab�ɮ� unpack tar���~
pause
exit

:ERROR_JAVA_32
echo ==========================================
echo �䤣��Java 7 (JRE 7)���|
echo �M��Java 7 (JRE 7) (x86)���|
goto JAVA_64

:ERROR_JAVA_64
echo ========================================
echo �䤣��Java 7 (JRE 7) (x86)���|
echo �Х��w��Java 7(JRE 7)
echo �w�˺��}�Ghttp://www.java.com/zh_TW/download/
pause
exit

:JAVA_64
"C:\Program Files (x86)\Java\jre7\bin\java" -jar abe.jar unpack db.ab db.tar >> e.log
IF ERRORLEVEL 1 goto ERROR_NOJAVA
goto next1


:abeerror
echo ==============================
echo ���~�I�L�k���o�ƥ��ɮ�
pause
exit

:ERROR_7Z_ERROR
echo ==============================
echo ���������ɤ��s�b
pause
exit

:extracterror
echo ==============================
echo �����Y�X�Ӫ���Ʈw���~
pause
exit

:ERROR_SQLLITE3
echo ==============================
echo ��Ʈw�����ɤ��s�b
pause
exit

:DATA_ERROR
echo ==============================
echo ���oAuthKey����
pause
exit

:ERROR_PACK
echo ==============================
echo abe pack ���~
echo abe pack to ab�ɮ׿��~
pause
exit

:PACK64
"C:\Program Files (x86)\Java\jre7\bin\java" -jar abe.jar pack new_db.tar new_db.ab
IF ERRORLEVEL 1 goto ERROR_NOJAVA
goto next2


