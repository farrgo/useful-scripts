set folder="%~1%"

:: Suppress messages.
echo off

:: Go to the script's directory.
cd %~dp0

:: Only run this script if the folder exists.
if exist %folder% (
    
    :: Only run this script if it isn't emptying the folder that contains it!
    if NOT %folder% == %~dp0 (
        
        :: Go to the folder.
        cd /d %folder%

        :: Delete everything in the folder.
        for /F "delims=" %%i in ('dir /b') do (rmdir "%%i" /s/q 2>NUL || del "%%i" /s/q >NUL )

        :: Go back to the script's directory.
        cd %~dp0

    )

)

:: Enable messages.
echo on

:: Tell user the script is done.
REM Folder emptied.