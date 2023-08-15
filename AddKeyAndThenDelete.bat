@echo off

Title AddKeyAndThenDelete

REM Detect if the user has administrator's privileges
REM by trying to query registry branch "HKU\S-1-5-19".
REM If there are no privileges goto :UACPrompt.
REM Else goto :WorkScript
reg.exe query "HKU\S-1-5-19">nul 2>&1
if %errorlevel% equ 1 goto UACPrompt

goto WorkScript

:UACPrompt
REM Run bat-file with administrator privileges
REM %~fs0 - full path to the running bat-file
mshta "vbscript:CreateObject("Shell.Application").ShellExecute("%~fs0","","","runas",1) & Close()"
exit /b

:WorkScript
color 0B
mode con:cols=60 lines=4

REM Add a key "NetJoinLegacyAccountReuse=1" to the registry
REM and wait for user to press any keyboard key
reg add "HKLM\System\CurrentControlSet\Control\LSA" /v NetJoinLegacyAccountReuse /t REG_DWORD /d 1 /f
cls
@Echo Key "NetJoinLegacyAccountReuse" added to registry
@Echo to "HKLM\System\CurrentControlSet\Control\LSA"
@Echo Press any key...

echo @echo off > C:\Windows\temp\WindowSearcher.bat
REM echo mode con:cols=15 lines=1 >> C:\Windows\temp\WindowSearcher.bat
echo :loop >> C:\Windows\temp\WindowSearcher.bat
echo SET FindWindowByTitle=>> C:\Windows\temp\WindowSearcher.bat
echo |set /p="for /f "delims=" %%%%a in ('TASKLIST /v /fo list " >> C:\Windows\temp\WindowSearcher.bat
echo |set /p="^|" >> C:\Windows\temp\WindowSearcher.bat
echo find "AddKeyAndThenDelete"') do set FindWindowByTitle=%%%%a  >> C:\Windows\temp\WindowSearcher.bat
echo echo "Window NOT closed" >> C:\Windows\temp\WindowSearcher.bat
echo IF DEFINED FindWindowByTitle goto loop >> C:\Windows\temp\WindowSearcher.bat
echo echo "Window closed" >> C:\Windows\temp\WindowSearcher.bat
echo reg delete "HKLM\System\CurrentControlSet\Control\LSA" /v NetJoinLegacyAccountReuse /f >> C:\Windows\temp\WindowSearcher.bat
echo del C:\Windows\Temp\WindowSearcher.bat >> C:\Windows\temp\WindowSearcher.bat

start /min cmd /c "C:\Windows\Temp\WindowSearcher.bat"

>nul pause

reg delete "HKLM\System\CurrentControlSet\Control\LSA" /v NetJoinLegacyAccountReuse /f
