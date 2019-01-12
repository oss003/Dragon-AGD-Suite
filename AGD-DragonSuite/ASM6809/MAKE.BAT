@echo off
rem Set flags
 set if=0
 if "%2"=="i" set if=1
 if "%3"=="i" set if=1
 if "%4"=="i" set if=1
 if "%5"=="i" set if=1
 if "%6"=="i" set if=1
 if "%7"=="i" set if=1

 set af=0
 if "%2"=="a" set af=1
 if "%3"=="a" set af=1
 if "%4"=="a" set af=1
 if "%5"=="a" set af=1
 if "%6"=="a" set af=1
 if "%7"=="a" set af=1

 set hf=0
 if "%2"=="h" set hf=1
 if "%3"=="h" set hf=1
 if "%4"=="h" set hf=1
 if "%5"=="h" set hf=1
 if "%6"=="h" set hf=1
 if "%7"=="h" set hf=1

 set gf=0
 if "%2"=="g" set gf=1
 if "%3"=="g" set gf=1
 if "%4"=="g" set gf=1
 if "%5"=="g" set gf=1
 if "%6"=="g" set gf=1
 if "%7"=="g" set gf=1

 set bf=0
 if "%2"=="b" set bf=1
 if "%3"=="b" set bf=1
 if "%4"=="b" set bf=1
 if "%5"=="b" set bf=1
 if "%6"=="b" set bf=1
 if "%7"=="b" set bf=1

 set rf=0
 if "%2"=="r" set rf=1
 if "%3"=="r" set rf=1
 if "%4"=="r" set rf=1
 if "%5"=="r" set rf=1
 if "%6"=="r" set rf=1
 if "%7"=="r" set rf=1

 set mg=4
 if "%2"=="g" set mg=3
 if "%3"=="g" set mg=3
 if "%4"=="g" set mg=3
 if "%5"=="g" set mg=3
 if "%6"=="g" set mg=3
 if "%7"=="g" set mg=3

 echo ; write Flags set by user in commandline to file game.cfg
 echo. >>game.cfg
 echo IFLAG equ %if% >>game.cfg
 echo AFLAG equ %af% >>game.cfg
 echo HFLAG equ %hf% >>game.cfg
 echo GFLAG equ %gf% >>game.cfg
 echo BFLAG equ %bf% >>game.cfg
 echo RFLAG equ %rf% >>game.cfg
 echo. >>game.cfg

rem Build asm file
 echo.
 echo Build %1.inc
 copy game.cfg+%1.inc %1.asm
 del %1.inc
 del game.cfg
 
rem Conditional assemble game
 echo.
 echo Assemble: %1
 asm6809 -9 -D -v --listing=%1%mg%D.LST --o=%1%mg%D.BIN %1.ASM
 if not "%errorlevel%" == "0" goto failed

 asm6809 -9 -C -v --listing=%1%mg%C.LST --o=%1%mg%C.BIN %1.ASM
 if not "%errorlevel%" == "0" goto failed

 del ..\AGD\game.cfg

rem copy to Tools folders
 if %gf%==1 (
    echo PROCESSING PMODE3
    copy %1%mg%D.BIN ..\DragDOS\GAMEPM3.BIN
    copy %1%mg%C.BIN ..\ImgTool\GAMEPM3.BIN
 ) else (
    echo PROCESSING PMODE4
    copy %1%mg%D.BIN ..\DragDOS\GAMEPM4.BIN
    copy %1%mg%C.BIN ..\ImgTool\GAMEPM4.BIN
 )
 move %1*.* ..\
 
rem CoCo DSK create/add
 cd ..\ImgTool
 if exist %1.DSK goto alreadyC
 if exist ..\..\_OK\%1\%1.DSK (
    copy ..\..\_OK\%1\%1.DSK %1.DSK
 ) else (
    copy TEMPLATE.DSK  %1.DSK
 )
 
:alreadyC
 call pack %1
 if %gf%==1 del GAMEPM3.BIN
 if %gf%==0 del GAMEPM4.BIN
 copy %1.DSK ..\
 copy %1.DSK ..\XRoar\%1.DSK
 
rem Dragon VDK create/add
 cd ..\DragDOS
 if exist %1.VDK goto alreadyD
 if exist ..\..\_OK\%1\%1.VDK (
    copy ..\..\_OK\%1\%1.VDK %1.VDK 
 ) else (
 copy TEMPLATE.VDK  %1.VDK
 )

:alreadyD
 call pack %1
 if %gf%==1 del GAMEPM3.BIN
 if %gf%==0 del GAMEPM4.BIN
 copy %1.VDK ..\
 copy %1.VDK ..\XRoar\%1.VDK

 goto end

:failed
 echo.
 echo Error %errorlevel%
 echo.
 echo Usage: build [agd file] [condition0] [condition1] [condition2]
 echo.
 echo Conditional assembly:
 echo i = Invertmode
 echo a = Adventuremode
 echo h = Hidden sprite mode
 echo g = Graphicsmode, default PM4, g=PM3
 echo b = Big sprites (16x24)
 echo r = use preShifted Tables
 echo.
 set errorlevel=1
 
:end
cd ..\


