@echo off
call b.bat %1 %2 %3 %4 %5 %6 %7 %8 %9 %10
if errorlevel 1 goto error
goto end

:error
 echo BUILD FAILED ...
 goto endbad
 
:end
rem echo Going to DELETE virtual files
rem  del XRoar\%1.DSK
rem  del XRoar\%1.VDK
rem  del ImgTool\%1.DSK
rem  del DragDOS\%1.VDK

rem create destination folder and move files
 if not exist ..\_OK\%1  md ..\_OK\%1
 move %1*.* ..\_OK\%1\

:endbad
 pause
