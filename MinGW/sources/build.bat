@echo off
PATH=d:\XRoar\_Projectes\48 - AGD\AGD\MinGW\bin;d:\XRoar\_Projectes\48 - AGD\AGD\MinGW\msys\1.0\bin
cd %1
make
if %1==agddragon copy agd.exe "..\..\..\Dragon-AGD-Suite\AGD"
cd..
