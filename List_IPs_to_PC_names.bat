@echo off

REM All IP adresses will be in file named IPList.txt

For /f "UseBackQ Delims=" %%A IN ("IPList.txt") do (ping -a -n 1 "%%A" | FIND "Pinging") >> temp.txt

For /F "tokens=2,2 delims= " %%A in (temp.txt) do @echo %%A %%B >> Parsed.txt
