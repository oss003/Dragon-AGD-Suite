@echo off
 set bigspr=0
 if "%2"=="b" set bigspr=1
 if "%3"=="b" set bigspr=1

 set dither=0
 if "%2"=="d" set dither=1
 if "%3"=="d" set dither=1

rem Convert ZX snapshot to AGD file
 copy %1.sna convert
 if errorlevel 1 goto error
 cd convert

convert %1 %bigspr% %dither%

:cont
 copy %1.agd ..\
rem  del %1.sna
 del %1.*
 cd ..
 goto end

:error
 echo %1.agd not found .....

:end
