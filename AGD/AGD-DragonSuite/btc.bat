@echo off
 set flagB=0
 if "%2"=="b" @set flagB=1
 if "%3"=="b" @set flagB=1
 if "%4"=="b" @set flagB=1
 if "%5"=="b" @set flagB=1
 if "%6"=="b" @set flagB=1
 if "%7"=="b" @set flagB=1
 if "%8"=="b" @set flagB=1
 if "%9"=="b" @set flagB=1
 if "%10"=="b" @set flagB=1

 set flagR=0
 if "%2"=="r" @set flagR=2
 if "%3"=="r" @set flagR=2
 if "%4"=="r" @set flagR=2
 if "%5"=="r" @set flagR=2
 if "%6"=="r" @set flagR=2
 if "%7"=="r" @set flagR=2
 if "%8"=="r" @set flagR=2
 if "%9"=="r" @set flagR=2
 if "%10"=="r" @set flagR=2

 set flagK=0
 if "%2"=="k" @set flagK=4
 if "%3"=="k" @set flagK=4
 if "%4"=="k" @set flagK=4
 if "%5"=="k" @set flagK=4
 if "%6"=="k" @set flagK=4
 if "%7"=="k" @set flagK=4
 if "%8"=="k" @set flagK=4
 if "%9"=="k" @set flagK=4
 if "%10"=="k" @set flagK=4

@set /a "flags=%flagB%+%flagR%+%flagK%"

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
 call make %1 %2 %3 %4 %5 %6 %7 %8 %9 %10
 goto end
 
:error
 echo %1.agd not found .....
 goto endbad
 
:end
rem Start COCO emulator
cd XRoar
xroar -machine coco -bas bas14.rom -extbas extbas11.rom -machine-cart rsdos -cart-rom disk12.rom -ram 64 -load %1.DSK -type RUN"SETAGD.BAS\n -force-crc-match -disk-write-back -joy-left 0,0:1:0 -kbd-translate  
del %1.DSK.BAK
del %1.DSK
del %1.VDK.BAK
del %1.VDK

echo Going to DELETE virtual files
rem pause
cd ..\
del XRoar\%1.DSK
del XRoar\%1.VDK
del ImgTool\%1.DSK
del DragDOS\%1.VDK

:endbad
