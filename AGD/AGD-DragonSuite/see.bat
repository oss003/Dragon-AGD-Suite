@echo off
if "%2"=="" (
   echo NO PARAMETER. WILL USE 4
)

cd _Files\SCREENS
copy %1.scr %1
if %~z1 == 6912 (
   echo RUNNING CUTTER
   ..\..\Cutter\cutter %1
) else (
    echo USING CURRENT FILE
    copy %1.scr  %1.bin
)

del %1

rem create loadable image
 copy ..\Headers\DHeader.bin /B + %1.bin /B  %1INTRO.BIN /B
 del %1.bin

rem move image to DrgDOS
 move %1INTRO.BIN ..\..\DragDOS\IMG.BIN
 cd ..\..\DragDOS

rem create working disk and put bin inside
 copy ORISEE.VDK  SEE.VDK
 call pack SEE

rem move VDK to XRoar
 move SEE.VDK ..\XRoar\
 del *.BIN

rem Start DRAGON emulator
 cd ..\XRoar
 if "%2"=="4" (
    xroar -machine dragon64 -machine-cpu 6809 -extbas d64_1.rom -altbas d64_2.rom -machine-cart dragondos -cart-rom ddos.rom -load SEE.VDK -type RUN"SEE4.BAS\n -force-crc-match -disk-write-back -joy-left 0,0:1:0 -kbd-translate
 ) else (
    if "%2"=="" (
        xroar -machine dragon64 -machine-cpu 6809 -extbas d64_1.rom -altbas d64_2.rom -machine-cart dragondos -cart-rom ddos.rom -load SEE.VDK -type RUN"SEE4.BAS\n -force-crc-match -disk-write-back -joy-left 0,0:1:0 -kbd-translate
    ) else (
        xroar -machine dragon64 -machine-cpu 6809 -extbas d64_1.rom -altbas d64_2.rom -machine-cart dragondos -cart-rom ddos.rom -load SEE.VDK -type RUN"SEE3.BAS\n -force-crc-match -disk-write-back -joy-left 0,0:1:0 -kbd-translate
    )
 )
 del SEE.VDK
 del SEE.VDK.bak
 cd..

:end
rem exit
