@echo on
 set flagB=0
 if "%2"=="b" @set flagB=1
 if "%3"=="b" @set flagB=1
 if "%4"=="b" @set flagB=1
 if "%5"=="b" @set flagB=1
 if "%6"=="b" @set flagB=1
 if "%7"=="b" @set flagB=1

 set flagR=0
 if "%2"=="r" @set flagR=2
 if "%3"=="r" @set flagR=2
 if "%4"=="r" @set flagR=2
 if "%5"=="r" @set flagR=2
 if "%6"=="r" @set flagR=2
 if "%7"=="r" @set flagR=2

@set /a "flags=%flagB%+%flagR%"

rem Compile AGD file
 copy %1.agd agd
 if errorlevel 1 goto error
 cd AGD
 AGD %1 %flags%

rem prepare compile phase
 copy %1.inc ..\ASM6809\
 copy game.cfg ..\ASM6809\
 del %1.*

rem Assemble file
 cd ..\ASM6809
 call make %1 %2 %3 %4 %5 %6 %7
 goto end

:error
 echo %1.agd not found .....
 goto endbad
 
:end
rem Start DRAGON emulator
cd XRoar
xroar -machine dragon64 -machine-cpu 6809 -extbas d64_1.rom -altbas d64_2.rom -machine-cart dragondos -cart-rom ddos.rom -load %1.VDK -type RUN"SETAGD.BAS\n -force-crc-match -disk-write-back -joy-left 0,0:1:0 -kbd-translate
del %1.VDK.BAK
del %1.VDK
del %1.DSK.BAK
del %1.DSK

echo Going to DELETE virtual files
rem pause
cd ..\
del XRoar\%1.DSK
del XRoar\%1.VDK
del ImgTool\%1.DSK
del DragDOS\%1.VDK

:endbad

