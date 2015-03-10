# 軟體建構解決方案/CMake 軟體建構系統/<br>Build solutions/CMake buildsystem/
存放了用於「CMake 軟體建構系統」軟體建構解決方案檔案的目錄

## 本目錄下的項目說明<br>Description of the items under this directory
### [Build artifacts/](Build artifacts/)
放置軟體建構中間產物的目錄

### [Built software/](Built software/)
放置建構好的軟體的目錄

### [說明文件.md<br>README.md](README.md)
本目錄的說明文件

### [.gitignore](.gitignore)
Git 版本控制系統版本追蹤忽略規則

## 如何使用本軟體建構解決方案建構軟體
### 使用 cmake 命令列介面工具
1. 開啟終端機模擬軟體，切換當前工作目錄(current working directory)到本目錄。
2. 執行 `cmake ../..` 命令產生要使用的軟體建構系統檔案（於 GNU/Linux 作業系統中預設是 GNU Make）。
3. 依照軟體建構系統指定的方式建構軟體（於 GNU Make 軟體建構系統中為執行 `make` 命令）
4. 建構出來的檔案會在當前工作目錄中的 `Built software/` 目錄底下
