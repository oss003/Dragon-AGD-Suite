@echo off
copy %1.VDK XRoar 
rem Start DRAGON emulator
cd XRoar
xroar -machine dragon64 -machine-cpu 6809 -extbas d64_1.rom -altbas d64_2.rom -machine-cart dragondos -cart-rom ddos.rom -load %1.VDK -type RUN"SETAGD.BAS\n -force-crc-match -disk-write-back -joy-left 0,0:1:0 -kbd-translate
del %1.VDK
del %1.BAK
cd ..\


