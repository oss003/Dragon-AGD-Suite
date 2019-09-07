@echo on
rem Set requested version
set vers=0
if "%1"=="47" set vers=3
if "%1"=="30" set vers=2
if "%1"=="26" set vers=1
if vers==0 goto eruse 

rem Test received parameters
 set bigspr=0
 if "%3"=="b" set bigspr=1
 if "%4"=="b" set bigspr=1

 set dither=0
 if "%3"=="d" set dither=1
 if "%4"=="d" set dither=1

rem Convert ZX snapshot to AGD file
 copy %2.sna Convert
 if errorlevel 1 goto error
 cd Convert
 if %vers%==1 conv26  %2 %bigspr% %dither%
 if %vers%==2 conv30  %2 %bigspr% %dither%
 if %vers%==3 convert %2 %bigspr% %dither%

rem move result and clean working files
 copy %2.agd ..\
 del %2.*
 cd ..
 goto end

rem show user the new mandatory syntax
:reuse
echo"USAGE cv [26|30|47] Gamename [b][d]
goto end

:error
 echo %2.agd not found .....

:end
