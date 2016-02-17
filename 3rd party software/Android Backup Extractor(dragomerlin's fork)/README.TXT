Android Backup Extractor
https://sourceforge.net/projects/adbextractor/

LAW WARNING
If you are working with password encrypted adb backups, you need to download these two files:
- local_policy.jar
- US_export_policy.jar
from http://www.oracle.com/technetwork/java/javase/downloads/jce-7-download-432124.html
or http://www.oracle.com/technetwork/java/javase/downloads/jce8-download-2133166.html
and put them in the lib/security folder of all your Java SE 7 or 8 installations, for example:
--Windows:
C:\Program Files\Java\jdk1.7.0_60\jre\lib\security\
c:\Program Files\Java\jdk1.8.0_66\jre\lib\security\
C:\Program Files\Java\jre7\lib\security\
c:\Program Files\Java\jre1.8.0_66\lib\security\
C:\Program Files (x86)\Java\jdk1.7.0_60\jre\lib\security\
C:\Program Files (x86)\Java\jre7\lib\security\
c:\Program Files (x86)\Java\jre1.8.0_66\lib\security\
--Linux:
/usr/local/jdk1.7/jre/lib/security/
/usr/lib/jvm/java-7-oracle/jre/lib/security/
/usr/lib/jvm/java-8-oracle/jre/lib/security/
--BSD:
/usr/lib/jvm/java-7-openjdk-*/jre/lib/security/
--OS X:
/Library/Java/JavaVirtualMachines/jdk1.7.0_60.jdk/Contents/Home/jre/lib/security/
/Library/Java/JavaVirtualMachines/jdk1.8.0_66.jdk/Contents/Home/jre/lib/security/
Won't work if you supply them with the application, you must have them installed onto your system.

Application name: Android Backup Extractor
Original author: Nikolay Elenkov
Original source code: https://github.com/nelenkov/android-backup-extractor
Website original documentation: http://nelenkov.blogspot.com/2012/06/unpacking-android-backups.html
Packager and improvements: dragomerlin
Format: runnable jar file with additional software
IDE: Eclipse Mars.1 Release (4.5.1) Build id: 20150924-1200
Compiler: Oracle Java SDK 1.8.0_66
Compiler compliance level: Java 1.7. "Major.Minor Version"=51.0
Bouncy Castle version: bcprov-jdk15on-153

Links:
Full local backup infrastructure: https://android.googlesource.com/platform/frameworks/base/+/4a627c71ff53a4fca1f961f4b1dcc0461df18a06
Tar Binary Splitter: https://sourceforge.net/projects/tar-binary-splitter/
Android Backup Splitter: https://sourceforge.net/projects/adb-split/
Perl scripts to encrypt/decrypt adb backup files: http://forum.xda-developers.com/showthread.php?t=1730309
The Legion of the Bouncy Castle: https://www.bouncycastle.org/java.html

Usage:
	info:	java -jar abe.jar [-debug] [-useenv=yourenv] info <backup.ab> [password]
	unpack:	java -jar abe.jar [-debug] [-useenv=yourenv] unpack <backup.ab> <backup.tar> [password]
	pack:	java -jar abe.jar [-debug] [-useenv=yourenv] pack <backup.tar> <backup.ab> [password]
	pack-kk:	java -jar abe.jar [-debug] [-useenv=yourenv] pack-kk <backup.tar> <backup.ab> [password]

*pack-kk is to create version 2 backups for android kitkat 4.4.3+.
*info gives information about an adb backup without extracting anything.
*yourenv is the environment variable provided to read the password from
*debug shows cryptographic information and password when useenv is used
*If the filename is `-`, then data is read from standard input or written to standard output
If you don't specify a password when packing the backup archive won't be encrypted but only compressed.
Option to create unencrypted and uncompressed backups is possible, but not available on ABE.

Setting environment variables:
--Linux:
To make it persistent between reboots and sessions, add it to your ~/.profile and restart your session:
echo "export FOO=bar" >> ~/.profile
To make is available for all users add it as root to /etc/profile (most linux distros)
sudo echo "export FOO=bar" >> /etc/profile
-- OS X:
To make it persistent for terminal add it to ~/.bash_profile
echo "export FOO=bar" >> ~/.bash_profile
Globally: very tricky, depends on OSX version
-- Windows: very easy

Requirements for compilation:
- Java Development Kit version 7 or 8 (1.7 or 1.8)
- Bouncy Castle java release "JCE with provider and lightweight API" bcprov-jdk15on*
  http://www.bouncycastle.org/latest_releases.html
- Oracle Java Cryptography Extension (JCE) Unlimited Strength Jurisdiction Policy Files (7 or 8) (required when handling encrypted backups)
  * http://www.oracle.com/technetwork/java/javase/downloads/jce-7-download-432124.html
  * http://www.oracle.com/technetwork/java/javase/downloads/jce8-download-2133166.html
- Set the Compiler compliance level to 1.7 to allow more compatible versions (optional but recommended)
- IDE Eclipse (optional but recommended)

Description and scope:
- Android Backup Extractor is an application written in Java that can extract and create android adb backups from or to TAR format.
  It doesn't edit directly.
 - You can choose to view an adb backup properties, extract it to tar or create a new one from tar.
 - When creating a backup, password if optional. When extracting, if backup is encrypted, entering a password is mandatory.
   If it's not provided directly on the command line it will be asked interactively. Will exit if a null or empty string is provided.
- A password can be provided from any environment variable with -useenv=envvar. However, if the password is specified directly on the command line this will be used instead.
- The debug messages can be activated with the -debug flag
 - When working with encryption JCE USJPF is required, so will notify and exit if not present.
- Android Backup Splitter are two bash scripts that allow you to create individual adb backups for each app or shared from the full one,
  so you can restore apps or shared individually. Same encryption is preserved to them, if any. It also informs when any apk is missing for each app.
  * adb-split-extraction.sh extracts the contents of the tar archive(s) to the hard drive and re-tars, but this may lead to problems with not allowed filename characters.
  It only generates adbs for apps.
  * adb-split-no-extraction.sh splits the adb tar in binary mode instead. It requires the program Tar Binary Splitter.
  This is the recommended method. The script generates adb(s) for both apps and shared.
- The adb backups (usually with .ab extension) can be password protected or not. If the device is encrypted this is mandatory and the password must be the same
  as the used to unlock the device.
- The adb backups are extracted to tar format, and are created from the tar format as well.
- The files and folders inside the tar archive must be in some specific order, not necessarily alphabetical like tar does by default.
  Such order is listed in "Full local backup infrastructure". The easiest way to test is to repackage a tar archive from an already existing one;
  for example a part of an archive, and repackage it following the same order as files are listed in the original. If we don't have the original archive,
  we have to guess out the order. Some redundancy checksums may be present on the manifest so restoring a modified backup may not work.

Considerations:
- Read the READMEs of Android Backup Splitter and Tar Binary Splitter for further knowledge.
- The tar archives may be extracted and created on filesystems that respect tar's content's permissions, although seems to work anyway when restoring to the android device.
- Directories inside tar archives must not contain trailing slashes. Since GNU tar doesn't have this option, the use of star or pax is mandatory. For Ubuntu and Cygwin star is included.
- star is recommended instead of pax. Pax only supports path length only up to 100 characters, so will fail in some cases. This usually happens with browsers history.
- Java 7 or higher is required because of SYNC_FLUSH mode for the Deflater.
- If the backup contains apk+data for an app, restore will work. If contains only the data, you must install the app first on the device and then restore. Installing the app later won't work.
- If you want a full backup use a nandroid backup with Clockworkmod or TWRP instead of ADB. Nandroid backup has the disadvantage that is not always 100% compatible between devices. ADB backup intends to be.
- Nandroid Manager (https://play.google.com/store/apps/details?id=com.h3r3t1c.bkrestore) is the best android app to work with nandroid backups.
- Some apps include a policy where the apk is never backed up even if specified. Same may apply for some data, depending on how the app is programmed regarding adb backups.
- Some apps can't be backed up at all. For example if android:allowBackup="false" is set in the manifest or the app is DRM protected (try Titanium Backup instead).
- Some applications or its data couldn't be restored to a different device: require specific device's id, android api level, processor architecture, etc.
- Android debugging bridge is very slow: about 1 MBps if the backup is password encrypted, 1.6 MBps if not, so consider that backing up and restoring may take a long time.
- When adding or removing files for an app you may need to edit _manifest so adb restore accepts the changes.
- ADB backups are not a replacement for a Nandroid backup. The whole /data partition is not backed up, only a part of it. Also, other partitions like /system, /preload, /cache, modem, RIL, efs, boot, kernel or recovery are never backed up because are not user data.
  This is to prevent issues when restoring on a different device. It has also the biggest advantage that doesn't require root to operate, so is totally compatible with stock roms, locked bootloaders and device encryption.
- If you have the device encrypted with a password, you must use that particular one for backup creation and restore. You can't create a backup without password or a different one in that particular case, or if you try to restore will fail.
- star for cygwin for windows is attached (move it to C:\cygwin\bin\star.exe) since there is no package available. It can be compiled from the schily tools (http://sourceforge.net/projects/schilytools).
  star for linux can be installed as package or compiled the same way
  star for OSX can be installed with Homebrew (http://brew.sh/): brew install star
- The best way to test if an adb backup has errors, is to convert it to tar and then check with "tar -tf file.tar && echo $?". 0 is given if ok
- One or more spaces can be used as password. Example: "   "


Example of quick backup editing:
Here is an example on how to make a custom adb backup from a complete one, for the game Grand Theft Auto III from Rockstar Games, installed on the Nexus 7.

1) Unpack the original adb backup:
$ java -jar abe.jar unpack nexus7.ab nexus7.tar [password]

2) Extract the contents of the tar archive. This may be done on a filesystem where the permissions of the files inside the tar are preserved, for example using linux, mac or bsd. Up to two folders may appear, apps and shared.
   Be warned that if there are characters in filenames not supported by the operating system like :;/ etc it will not work even if it appears to do so. OSX is the most flexible in this matter.
$ tar -xvf nexus7.tar

3) Make a list of all the contents of the original archive in the order they are archived:
$ tar -tf nexus7.tar > nexus7.list

4) Create a new list only with the files and folders you want, in proper order. For example for the GTA 3 (you can try savegames instead of all data):
$ cat nexus7.list | grep com.rockstar.gta3 > gta3.list

5) Create the new tar archive. The directories stored on tar mustn't contain trailing slashes, so I use star instead of tar. Pax works also if paths are up to 100 of length:
$ star -c -v -f gta3.tar -no-dirslash list=gta3.list
OR
$ cat gta3.list | pax -wd > gta3.tar

6) Create the adb backup from the tar archive. Password is optional except if the device is encrypted:
$ java -jar abe.jar pack gta3.tar gta3.ab [password]

Note:
If the backup is not encrypted zlib can be used instead for both unpack and pack the ab archive.
If openssl is not compiled with zlib support due to security issues (RHSA-2013-0587;CVE-2012-4929), you can try python instead.

- Quick unpacking:
	tail -c +25 nexus7.ab | openssl zlib -d > nexus7.tar
	tail -c +25 nexus7.ab | python -c "import zlib,sys;sys.stdout.write(zlib.decompress(sys.stdin.read()))" > nexus7.tar
- Quick packing:
	dd if=nexus7.ab bs=24 count=1 of=gta3.ab ; openssl zlib -in gta3.tar >> gta3.ab
	dd if=nexus7.ab bs=24 count=1 of=gta3.ab ; cat gta3.tar | python -c "import zlib,sys;sys.stdout.write(zlib.compress(sys.stdin.read()))" >> gta3.ab
	dd if=nexus7.ab bs=24 count=1 of=gta3.ab ; python -c "import zlib,sys;open('gta3.ab', 'ab').write(zlib.compress(open('layton.tar', 'rb').read()))"
- Instead of "tail -c +25 nexus7.ab" you can use "dd if=nexus7.ab bs=1 skip=24" but is less efficient.


Example of adb splitting to create an individual adb backup for shared and each app (non extraction method, RECOMMENDED):
Use ADB Backup Splitter (is a shell script). Works on Linux, Cygwin and OSX:
bash adb-split-no-extraction.sh backup.ab [password]
Resulting files go in split-ab folder.
Missing apk(s) are listed in apk-missing.html

Example of adb splitting to create an individual adb backup for each app (extraction method):
Use ADB Backup Splitter (is a shell script). Works on Linux, Cygwin and OSX:
bash adb-split-extraction.sh backup.ab [password]
Resulting files go in app-ab folder.
Missing apk(s) are listed in apk-missing.html


Changelog:
(Initial)
(6 June 2014)
- Changed "enabled" to "allowed" and "not enabled" to "not allowed" relating to strong AES encryption because some user complained
- JDK updated to 1.7.0_60, mixed mode
- Added support for android 4.4 encrypted backups
- Removed bcprov-jdk15on documentation
- Updated Bouncy Castle source (JCE with provider and lightweight API) from 1.48 to 1.50
- Updated adb-split.sh to add "${SCRIPT_DIR}/" before abe.jar
- Eclipse updated from 20130225-0426 to 20140224-0627
(15 June 2014)
- Updated program to create version 2 backups for android 4.4.3+.
(30 June 2014)
- Added backup version 3 for android L. No real code changes.
(19 October 2015)
- Updated Bouncy Castle source (JCE with provider and lightweight API) from 1.50 to 1.53
- Replace "%s." with "%s" in AndroidBackup.java for better reading
- Added VERSION to usage()
- Added star-1.5.3-i686-pc-cygwin/star.exe compiled from schily-dist-pre2.tar.xz (2015-10-16)
- JDK updated to 1.8.0_60-b27
- Updated README.TXT
- Updated Main.java to add JCE 8 to usage()
- Created VERSION.TXT
- Created folder Doc
	Move there "Full local backup infrastructure.txt"
	Copy there README.TXT from Tar Binary Splitter
	Copy there README.TXT from Android Backup Splitter
- Added Tar Binary Splitter v4.0 (tar-bin-split.jar) to split adb backups without issues.
- Updated Android Backup Splitter
	Extraction version
	Non Extraction version
(20 October 2015)
- Exit 0 if no arguments are given
- Detect when password is provided but strong AES encryption is not allowed, so warn user and exit 1
- Compiler compliance level set to Java 1.7. Changes "Major.Minor Version" from 52.0 to 51.0. Previous version was 1.8
- Updated Tar Binary Splitter to v4.1 with its Readme
(22 October 2015)
- Added method requirePassword() to demand password from user when no one is present but backup is encrypted
(23 October 2015)
- Improved routines for detecting when a password is required
- Improbed routines for detecting when JCE USJPF is required
(24 October 2015)
- Added ability to read password from any specified environment variable
(25 October 2015)
- Send non usage messages to stderr instead of stdout. This allows pipelining to stdout only real data
- Now debug is user selectable with the -debug flag
- Flag "USEENV=" replaced with "-useenv="
(26 October 2015)
- Support "-" for stdin/stdout (pipes)
(2 November 2015)
- Improved README.TXT
- JRE and JDK updated to 1.8.0_66
- star.exe 1.5.3 compiled from schily-dist-pre4.tar.xz (27-10-2015)
