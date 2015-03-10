/*
  程式名稱
  Program name
    GNU gettext library specific configurations
  更新紀錄
  Changelog
    Changelog is now stored on GitHub(http://www.github.com)
  已知問題
  Known issues
    Known issues is now stored on GitHub(http://www.github.com)
  待辦事項
  Todos
    Todo is now stored on GitHub(http://www.github.com)
  著作權宣告
  Copyright declaration
    Copyright 2013 林博仁<pika1021@gmail.com>
  智慧財產授權條款
  Intellectual property license
    "GNU gettext library specific configurations" is part of Vdragons_C_CPP_Libraries_Collection
    Vdragons_C_CPP_Libraries_Collection is free software: you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

    Vdragons_C_CPP_Libraries_Collection is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License along with Vdragons_C_CPP_Libraries_Collection.  If not, see <http://www.gnu.org/licenses/>.
  本程式的框架基於「C/C++ program templates」專案
  This program's frame is based on "C/C++ program templates" project
    https://github.com/Vdragon/C_CPP_program_templates
  建議編輯器設定
  Recommended editor settings
    Indentation by tab character
    Tab character width = 2 space characters
*/
/* include guard：避免同一個 header 檔案被 include 第二次 */
#ifndef GNU_GETTEXT_LIB_H_INCLUDED
#define GNU_GETTEXT_LIB_H_INCLUDED
/* 如果是 C++ 編譯器則停用 C++ 特有的函式名稱 mangling*/
#ifdef __cplusplus
extern "C" {
#endif /* __cplusplus */

/* Forward declarations */

/* 程式所 include 之函式庫的標頭檔
   Included Library Headers */

/* 常數與巨集的定義
* Definition of constants & macros */
#define MESSAGE_DOMAIN "undefined.message.domain"
#define LOCALEDIR NULL
#define MESSAGE_CHARSET "UTF-8"

/* 資料類型、enumeration、資料結構與物件類別的定義
* Definition of data type, enumeration, data structure and class */

/* 函式雛型
   Function prototypes */

/* 全域變數
   Global variables */

/* Inline 子程式的實作
   Inline procedure implementations
     限制
     Limitations
       C89 規範中不可用
     參考資料
     Reference resources
       How do you tell the compiler to make a member function inline?, C++ FAQ
       http://www.parashift.com/c++-faq-lite/inline-member-fns.html */

#ifdef __cplusplus
}
#endif /* __cplusplus */
#endif/* GNU_GETTEXT_LIB_H_INCLUDED */
