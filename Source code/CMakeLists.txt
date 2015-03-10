# 設定最低可拿來解析此文件的 CMake 版本
cmake_minimum_required(VERSION 2.8)
add_executable(${CMAKE_PROJECT_NAME} main.cpp)
if(CMAKE_HOST_WIN32)
	target_link_libraries(${CMAKE_PROJECT_NAME} VCCL_showSoftwareInfo intl VCCL_pauseProgram VCCL_printSomething VCCL_Error_C)
else()
	target_link_libraries(${CMAKE_PROJECT_NAME} VCCL_showSoftwareInfo VCCL_pauseProgram VCCL_printSomething VCCL_Error_C)
endif()
