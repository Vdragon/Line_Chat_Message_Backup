#!/bin/bash
######## File scope variable definitions ########
# idea from http://www.kfirlavi.com/blog/2012/11/14/defensive-bash-programming/
readonly PROGRAM_NAME="$(basename $0)"
readonly PROGRAM_DIRECTORY="$(readlink -m $(dirname $0))"
readonly PROGRAM_ARGUMENT_ORIGINAL_LIST="$@"
readonly PROGRAM_ARGUMENT_ORIGINAL_NUMBER=$#
readonly project_root_path="${PROGRAM_DIRECTORY}/.."

######## File scope variable definitions ended ########

######## Included files ########
source "${project_root_path}/Tools/checkIllegalUsage.bash.source.sh"
######## Included files ended ########

checkIllegalUsage

# 清空無追蹤版本的檔案
git clean -d --force
git clean -X --force

# 重新建立新的版本倉庫
rm -rf .git/
./Tools/renameProject.bash.sh
git init
## Git 子模組在移除舊版本倉庫後不會保留（即使 .gitmodules 設定檔仍存在），重新註冊它
rm -rf "3rd party software/Vdragon_s_C_CPP_Libraries"
git submodule add "$(git config -f .gitmodules --get "submodule.3rd party software/Vdragon_s_C_CPP_Libraries.url")" "$(git config -f .gitmodules --get "submodule.3rd party software/Vdragon_s_C_CPP_Libraries.path")"
git add .
git commit -m "Import template files from \"Generic Software Project Template\" project."

exit 0