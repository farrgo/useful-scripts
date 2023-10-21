:: Use an centralized folder-emptying script to empty each temporary folder.
call delete-folder-contents.bat %TEMP%
call delete-folder-contents.bat "%WINDIR%\Temp"
::call delete-folder-contents.bat "%WINDIR%\Prefetch"