@echo off

echo POS Print Server
echo.
echo by WeSettleIt
echo.
echo Automagic installer
echo.

echo Checking for Python and pip
where /q python
if ERRORLEVEL 1 (
    echo ERROR: Python not found
    echo.
    echo Install latest Python3 x64 from https://www.python.org/downloads/release/python-351/
    echo Check *Add Python 3.x to PATH* during install.
    echo Restart command window before trying again.
    goto fail
)

where /q pip
if ERRORLEVEL 1 (
    echo ERROR: Pip not found.
    echo.
    echo It should have been automatically installed together with Python.
    goto fail
)

echo All requirements satisfied

SET script_path=%~dp0

echo Creating folders
if not exist %CD:~0,3%WeSettleIt\ mkdir %CD:~0,3%WeSettleIt\
if not exist %CD:~0,3%WeSettleIt\logs\ mkdir %CD:~0,3%WeSettleIt\logs\


set service_name=POSPrintServer

echo Installing VirtualEnv Wrapper
pip install virtualenvwrapper-win

echo Creating environment
cmd /c mkvirtualenv posprintserver

echo Installing requirements
C:\Users\%username%\Envs\posprintserver\Scripts\pip install -r requirements.txt

echo Installing service with name '%service_name%'
echo This must be done as Administrator

elevate install-service.bat

exit /b

:fail
echo .
echo Installation aborted.

pause
exit /b