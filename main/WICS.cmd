@ECHO OFF
@setlocal DisableDelayedExpansion
goto check_Permissions

:check_Permissions
    echo Administrative permissions required. Detecting permissions...

    net session >nul 2>&1
    if %errorLevel% == 0 (
        echo Success: Administrative permissions confirmed.
        timeout 3
        goto P_start
    ) else (
        echo Failure: Current permissions inadequate. Please relaunch as Administrator
    )

    pause >nul



@REM =======================================================================================
@REM Made by Bluewave2

@REM Github: https://github.com/Bluewave2/Windows-Integrity-Checking-Script
@REM =======================================================================================


:P_start
title Windows Integrity Checking Script
cls
for /f "tokens=6 delims=[]. " %%G in ('ver') do set winbuild=%%G
set command=%command:"=%
ECHO :
ECHO =====================================
ECHO Started Script
ECHO WICS v0.1
ECHO %DATE%
ECHO %TIME%
ECHO Windows Build: %winbuild%
ECHO =====================================
ECHO Please execute this script as admin
ECHO -------------------------------------
ECHO 1. Auto Check
ECHO 2. SFC
ECHO 3. DISM
ECHO 4. Diskcheck
ECHO:
ECHO 5. Exit
ECHO -------------------------------------
ECHO:
choice /C:12345 /N /M ">Select an option with your Keyboard [1,2,3,4,5] : "


if errorlevel  5 goto:Exit
if errorlevel  4 goto:Diskcheck
if errorlevel  3 goto:DISM
if errorlevel  2 goto:SFC
if errorlevel  1 goto:Auto



:Exit
echo:
echo Press any key to close
pause >nul
exit /b

::Null::
:SFC:
cls
ECHO:
whoami /groups | find "12288" && echo Elevated
ECHO =====================================
ECHO Started Script
ECHO WICS v0.1
ECHO %DATE%
ECHO %TIME%
ECHO Windows Build: %winbuild%
ECHO =====================================
ECHO Please execute this script as admin
ECHO -------------------------------------
ECHO 1. SFC
ECHO 2. SFC (specific file only)
ECHO:
ECHO:
ECHO:
ECHO 5. Exit
ECHO -------------------------------------
ECHO:
choice /C:125 /N /M ">Select an option with your Keyboard [1,2,5] : "
if errorlevel  5 goto:Exit
if errorlevel  4 goto:none
if errorlevel  3 goto:none
if errorlevel  2 goto:SFCs
if errorlevel  1 goto:SFCr

:SFCr:
cls
echo Starting SFC...
ping 127.0.0.1 && color 0A && echo what to do if error level IS 0 ||color 04|| goto:Fail
if %errorlevel%==-1073741510 goto:Fail
echo %errorlevel%
goto Success

echo Dism /online /Cleanup-Image /RestoreHealth
pause

:Fail:
color 04
echo:
echo:
echo [   ** Failiure **   ]
echo Something went
goto Exit
:Success:
color 0A
echo:
echo:
echo [   == Success ==   ]
echo Operation was completed
goto Exit

:SFCs:
cls
ECHO Input file path (right click):
set /p Input=File path no quotes:
set %Input = %command%
call sfc /verifyfile=%command && color 0A && echo what to do if error level IS 0 ||color 04|| goto:Fail
if %errorlevel% == 0 goto:Fail
goto Success
::continue work