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
move %1.VDK ..\XRoar
cd..\XRoar
xroar -machine dragon64 -machine-cpu 6809 -extbas d64_1.rom -altbas d64_2.rom -machine-cart dragondos -cart-rom ddos.rom -load %1.VDK -load AGDEDT16.VDK -type RUN"2:EDIT.BAS\n -force-crc-match -disk-write-back -joy-left 0,0:1:0 -kbd-translate
move %1.VDK ..\
echo Going to DELETE virtual files
cd ..\
del XRoar\*.BAK
:error
