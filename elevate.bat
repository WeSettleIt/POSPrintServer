::::::::::::::::::::::::::::::::::::::::::::
:: Automatically check & get admin rights V2
::::::::::::::::::::::::::::::::::::::::::::
@echo off
:init
setlocal DisableDelayedExpansion
set "batchPath=%~0"
for %%k in (%0) do set batchName=%%~nk
set "vbsGetPrivileges=%temp%\OEgetPriv_%batchName%.vbs"
setlocal EnableDelayedExpansion

:checkPrivileges
NET FILE 1>NUL 2>NUL
if '%errorlevel%' == '0' ( goto gotPrivileges ) else ( goto getPrivileges )

:getPrivileges
if '%1'=='ELEV' (echo ELEV & shift /1 & goto gotPrivileges)
ECHO.
ECHO **************************************
ECHO Invoking UAC for Privilege Escalation
ECHO **************************************

ECHO Set UAC = CreateObject^("Shell.Application"^) > "%vbsGetPrivileges%"
ECHO args = "ELEV " >> "%vbsGetPrivileges%"
ECHO For Each strArg in WScript.Arguments >> "%vbsGetPrivileges%"
ECHO args = args ^& strArg ^& " "  >> "%vbsGetPrivileges%"
ECHO Next >> "%vbsGetPrivileges%"
ECHO UAC.ShellExecute "!batchPath!", args, "", "runas", 1 >> "%vbsGetPrivileges%"
"%SystemRoot%\System32\WScript.exe" "%vbsGetPrivileges%" %*
exit /B

:gotPrivileges
setlocal & pushd .
cd /d %~dp0
if '%1'=='ELEV' (del "%vbsGetPrivileges%" 1>nul 2>nul  &  shift /1)

::::::::::::::::::::::::::::
::START
::::::::::::::::::::::::::::
REM Run shell as admin (example) - put here code as you like
set service_name=POSPrintServer
echo Installing service with name '%service_name%'
echo.

REM Set useful variables
SET script_path=%~dp0
set python_exe=
for /f "delims=" %%a in ('where python') do @set python_exe=%%a

for %%a in ("%python_exe%") do (
    set file=%%~fa
    set python_path=%%~dpa
    set filename=%%~nxa
)    

set "psCommand=powershell -Command "$pword = read-host 'Input password for this user account' -AsSecureString ; ^
    $BSTR=[System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($pword); ^
        [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)""
for /f "usebackq delims=" %%p in (`%psCommand%`) do set UserPassword=%%p

nssm install %service_name% C:\Users\%username%\Envs\posprintserver\Scripts\python.exe run.py
nssm set %service_name% Application C:\Users\%username%\Envs\posprintserver\Scripts\python.exe
nssm set %service_name% AppDirectory %script_path%
nssm set %service_name% AppParameters run.py

nssm set %service_name% Description POS Print Server by WeSettleIt
nssm set %service_name% ObjectName .\%username% %UserPassword%

nssm set %service_name% AppStdout %CD:~0,3%WeSettleIt\logs\posprintserver.std.log
nssm set %service_name% AppStderr %CD:~0,3%WeSettleIt\logs\posprintserver.std.log

nssm set %service_name% AppRotateFiles 1
nssm set %service_name% AppRotateBytes 10240000
nssm set %service_name% AppEnvironmentExtra "PATH=%PATH%;C:\Users\%username%\Envs\posprintserver\Scripts\"


echo.
echo Add rules to firewall
netsh advfirewall firewall add rule name="Python POS Print Server" dir=in action=allow program="C:\Users\%username%\Envs\posprintserver\Scripts\python.exe"

echo.
echo Installation done!
echo.
echo Restart computer and make sure service is running.
echo.
set /p StartNow= Start service now (y)? 
echo %StartNow%
if '%StartNow%' == 'y' net stop POSPrintServer & net start POSPrintServer
echo.
pause