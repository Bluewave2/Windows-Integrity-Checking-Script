@ECHO OFF
@setlocal DisableDelayedExpansion
%1 %2
ver|find "5.">nul&& goto :Admin
mshta vbscript:createobject("shell.application").shellexecute("%~s0","goto :Admin","","runas",1)(window.close)&goto :eof
:Admin

goto check_Permissions

:check_Permissions
    echo Administrative permissions required. Detecting permissions...

    net session >nul 2>&1
    if %errorLevel% == 0 (
        cls
::        echo Success: Administrative permissions confirmed.
::        timeout 2
        goto P_start
    ) else (
        cls
        echo Failure: Current permissions inadequate. Please relaunch as Administrator
        pause >nul
    )

    ::pause >nul



@REM =======================================================================================
@REM Made by Bluewave2

@REM Github: https://github.com/Bluewave2/Windows-Integrity-Checking-Script
@REM =======================================================================================


:P_start
title Windows Integrity Checking Script
cls
for /f "tokens=6 delims=[]. " %%G in ('ver') do set winbuild=%%G
set command=%command:"=%
ECHO: Work in progress
ECHO =====================================
ECHO Launched as admin: YES
ECHO:
ECHO WICS v0.1
ECHO %DATE%
ECHO %TIME%
ECHO Windows Build: %winbuild%
ECHO =====================================
ECHO:
ECHO -------------------------------------
ECHO 1. Auto Check
ECHO 2. SFC
ECHO 3. DISM
ECHO 4. Diskcheck
ECHO:
ECHO 5. Exit
ECHO 7. Readme
ECHO 9. System info
ECHO -------------------------------------
ECHO:
choice /C:1234579 /N /M ">Select an option with your Keyboard [1,2,3,4,5,9] : "

if errorlevel  7 goto:Systeminfo
if errorlevel  6 goto:Readme
if errorlevel  5 goto:Exit
if errorlevel  4 goto:Diskcheck
if errorlevel  3 goto:DISM
if errorlevel  2 goto:SFC
if errorlevel  1 goto:Auto

::whoami /groups | find "12288" && echo Elevated: YES 

:Exit
echo:
echo Press any key to close
::pause >nul
exit /b

::Null::
:SFC:
cls
ECHO:
ECHO =====================================
ECHO:
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
ping 127.0.0.1
if errorlevel not == 0 goto:Fail
echo errorlevel
goto Success

echo Dism /online /Cleanup-Image /RestoreHealth
pause

:Fail:
color 04
echo: %errorlevel%
echo:
echo:
echo [   ** Failiure **   ]
echo Something went wrong
timeout 7
goto Exit
:Success:
color 0A
echo:
echo:
echo [   == Success ==   ]
echo Operation was completed
timeout 7
goto Exit

:SFCs:
cls
ECHO Input file path (right click):
set /p Input=File path no quotes:
set %Input = %command%
call sfc /verifyfile=%command && color 0A && echo what to do if error level IS 0 ||color 04|| goto:Fail
if errorlevel not == 0 goto:Fail
goto Success
::continue work

:Auto
cls
ECHO: Automatic mode selected
set /p Input=Type y to confirm:
if %Input% == y (
    cls
    ECHO Stage 1 (CheckDisk)
    ECHO Running Diskcheck...
    ECHO Performance variable in use, expect higher CPU and disk usage.
    Chkdsk /f /perf
    if errorlevel not == 0 goto:Fail
    ECHO Stage 1 Completed (1/3)
    ECHO:
    ECHO ----------------------------------------------
    ECHO:
    ECHO Starting Stage 2 (DISM)
    Dism /Online /Cleanup-image /Restorehealth
    if errorlevel not == 0 goto:Fail
    ECHO Stage 2 Competed (2/3)
    ECHO:
    ECHO ----------------------------------------------
    ECHO:
    ECHO Starting Stage 3 (SFC)
    sfc /scannow
    if errorlevel not == 0 goto:Fail
    ECHO Stage 3 Completed (3/3)
    ECHO:
    ECHO:
    ECHO:
    ECHO:
    ECHO Automatic mode complete, restart required to finish.
    set /p Input=Type y to confirm:
    if %Input% == y (
        cls
        ECHO Restart initiated, you have 10 seconds to abort
        shutdown -r -t 10 -c Windows Integrity Checking Script restart procedure
        set /p Input=Type a to abort:
        if %Input% == a (
            shutdown -a
            ECHO Restart aborted.
            ECHO:
            ECHO You can manually restart your PC to finish the integrity fixing process.
            ECHO:
            ECHO:
            ECHO This program will now terminate.
            ECHO Thank you for using this program and have a nice day:)
            pause
        )
    )
)

:Systeminfo
cls
ECHO:
ECHO:
ECHO:
ECHO Architecture: %PROCESSOR_ARCHITECTURE%
ECHO Firmware Type: %FIRMWARE_TYPE%
ECHO System Drive: %SYSTEMDRIVE%
ECHO:
ECHO:
ECHO:5. Exit
ECHO:8. Main Menu
choice /C:58 /N /M ">Select an option with your Keyboard [5,8] : "

if errorlevel  2 goto:P_start
if errorlevel  1 goto:Exit

:Readme
cls
ECHO:
ECHO -------------------------------------------------------------
ECHO:
ECHO:
ECHO:
ECHO * * * * * * * * * *
ECHO:
ECHO Windows Integrity Checking Script
ECHO:
ECHO Made by Bluewave2
ECHO:
ECHO Github: https://github.com/Bluewave2/Windows-Integrity-Checking-Script
ECHO:
ECHO * * * * * * * * * *
ECHO:
ECHO Post any issues/suggestions on the Github page :)
ECHO:
ECHO                -- Licenced GNU GPLv3 --
ECHO -------------------------------------------------------------
ECHO:5. Exit
ECHO:8. Main Menu
choice /C:58 /N /M ">Select an option with your Keyboard [5,8] : "

if errorlevel  2 goto:P_start
if errorlevel  1 goto:Exit