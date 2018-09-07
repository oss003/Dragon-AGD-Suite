@echo off

rem Set flags

 set if=0
 if "%2"=="i" set if=1
 if "%3"=="i" set if=1
 if "%4"=="i" set if=1
 if "%5"=="i" set if=1

 set af=0
 if "%2"=="a" set af=1
 if "%3"=="a" set af=1
 if "%4"=="a" set af=1
 if "%5"=="i" set af=1

 set hf=0
 if "%2"=="h" set hf=1
 if "%3"=="h" set hf=1
 if "%4"=="h" set hf=1
 if "%5"=="i" set hf=1

 set gf=0
 if "%2"=="g" set gf=1
 if "%3"=="g" set gf=1
 if "%4"=="g" set gf=1
 if "%5"=="i" set gf=1

 echo ; Flags set by user in commandline >>game.cfg
 echo. >>game.cfg
 echo AFLAG equ %af% >>game.cfg
 echo IFLAG equ %if% >>game.cfg
 echo HFLAG equ %hf% >>game.cfg
 echo GFLAG equ %gf% >>game.cfg
 echo. >>game.cfg
 
rem Build asm file
 echo.
 echo Build %1.inc
 copy game.cfg+%1.inc %1.asm
 del %1.inc

rem Conditional assemble game
 echo.
 echo Assemble: %1
 asm6809 -D -l game.txt -o %1.bin %1.asm
 if not "%errorlevel%" == "0" goto failed

rem copy
 echo.
 echo Copying: %1
 copy %1.bin ..\XRoar\agdgame.bin
 echo Finished, created %1.bin
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
 echo.


:end


