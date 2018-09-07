@echo off

rem Compile AGD file
 copy %1.agd agd
 if errorlevel 1 goto error
 cd AGD
 AGD %1
 copy %1.inc ..\ASM6809\
 copy game.cfg ..\ASM6809\
 del %1.*

rem Assemble file
 cd ..\ASM6809
 call make %1 %2 %3 %4 
 copy %1.bin ..\XRoar\agdgame.bin
rem del %1.*

rem Start emulator
 cd ..\XRoar
 xroar -run agdgame.bin
 del agdgame.bin
 cd ..
 goto end

:error
 echo %1.agd not found .....

:end
