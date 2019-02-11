@echo off
rem Split AGD file
copy %1.agd agdp
if errorlevel 1 goto error
cd AGDP
AGDP %1
del %1.AGD
move GAME*.BIN ..\DragDOS\
cd ..\DragDOS
copy EMPTY.VDK %1.VDK
call pack.bat %1
del GAME*.BIN
move %1.VDK ..\
cd..
