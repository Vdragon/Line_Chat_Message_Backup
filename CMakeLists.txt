# 設定最低可拿來解析此文件的 CMake 版本
cmake_minimum_required(VERSION 2.8)

# 設定專案名稱
project("Line Chat Message Backup")

# 設定建構類型
## Specifies the build type on single-configuration generators
### Possible values are empty, Debug, Release, RelWithDebInfo and MinSizeRel.
set (CMAKE_BUILD_TYPE Debug)
## Specifies the available build types on multi-config generators.
### This specifies what build types (configurations) will be available such as Debug, Release, RelWithDebInfo etc.
### set (CMAKE_CONFIGURATION_TYPES Debug)

# 設定專案路徑
## 設定可執行檔的輸出目錄
set (CMAKE_RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/Built software/${CMAKE_LIBRARY_ARCHITECTURE}_${CMAKE_BUILD_TYPE}/")
## 設定靜態連結函式庫的輸出目錄
### set (CMAKE_ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/Built software/Libraries/${CMAKE_LIBRARY_ARCHITECTURE}_${CMAKE_BUILD_TYPE}")
## 設定動態連結函式庫的輸出目錄
### set (CMAKE_LIBRARY_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/Built software/Libraries/${CMAKE_LIBRARY_ARCHITECTURE}_${CMAKE_BUILD_TYPE}")
## PDB?
### set (CMAKE_RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/Built software/PDBs")

if(CMAKE_HOST_WIN32)
	if(CMAKE_GENERATOR MATCHES ".*Makefiles")
		message("### 偵測到目標為 Microsoft Windows GNU toolchain，將套用其專屬設定。 ###")
		set(path_library_header_gnu_intl_gnu "C:\\MinGW\\include")
		set(path_library_gnu_intl_gnu "C:\\MinGW\\lib")
		include_directories(${path_library_header_gnu_intl_gnu})
		link_directories(${path_library_gnu_intl_gnu})
	else()
		message("### 偵測到目標為 Microsoft Windows Visual Studio toolchain，將套用其專屬設定。 ###")
		set(path_library_header_gnu_intl_vc "C:\\Program Files (x86)\\GnuWin32\\include")
		set(path_library_gnu_intl_vc "C:\\Program Files (x86)\\GnuWin32\\lib")
		include_directories(${path_library_header_gnu_intl_vc})
		link_directories(${path_library_gnu_intl_vc})
	endif()
endif()

# 設定額外的函式庫路徑
link_directories(${CMAKE_SOURCE_DIR}/Libraries/)
include_directories("${CMAKE_SOURCE_DIR}/Library headers")

# 設定軟體安裝路徑前綴
## Install directory used by install.
### If "make install" is invoked or INSTALL is built, this directory is prepended onto all install directories. This variable defaults to /usr/local on UNIX and c:/Program Files on Windows.
### set(CMAKE_INSTALL_PREFIX $ENV{HOME}/Software/${CMAKE_PROJECT_NAME})

add_subdirectory("Source code" "Built artifacts")
