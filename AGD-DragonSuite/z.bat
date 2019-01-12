@echo off
if "%1"=="" (
   echo NO 1st PARAMETER. ACCEPTED 3 OR 4
   pause
   goto end
)
if "%2"=="" (
   echo NO 2nd PARAMETER. ACCEPTED x OR d
   pause
   goto end
)

cd SCREENS
for %%A in (*.scr) do (
   if "%2"=="x" (
      ..\Cutter\cutter %%~nA
   ) else (
      if %%~zA == 6912 (
         ..\Cutter\cutter %%~nA
      ) else (
         copy %%A  %%~nA.bin
      )
   )

   rem create binaries for CoCo-Dragon
    copy ..\_Headers\CHeader.bin /B + %%~nA.bin /B + ..\_Headers\CFooter.bin /B %%~nAINTROC.BIN /B
    copy ..\_Headers\DHeader.bin /B + %%~nA.bin /B  %%~nAINTROD.BIN /B
    del %%~nA.bin

   rem copy virtual files to Utils folders
    move ..\..\_OK\%%~nA\%%~nA.DSK ..\ImgTool
    move ..\..\_OK\%%~nA\%%~nA.VDK ..\DragDOS\

   rem copy images to DragonDos/ImgTool folders
    if "%1"=="3" (
       move %%~nAINTROC.BIN ..\ImgTool\INTRO3.BIN
       move %%~nAINTROD.BIN ..\DragDOS\INTRO3.BIN
    ) else (
       move %%~nAINTROC.BIN ..\ImgTool\INTRO4.BIN
       move %%~nAINTROD.BIN ..\DragDOS\INTRO4.BIN
    )

   rem create/add to CoCo DSK
    cd ..\ImgTool
    call pack %%~nA
    del INTRO?.BIN
    move %%~nA.DSK ..\..\_OK\%%~nA\

   rem create/add to Dragon VDK
    cd ..\DragDOS
    call pack %%~nA
    del INTRO?.BIN
    move %%~nA.VDK ..\..\_OK\%%~nA\

   rem back to the images directory
    cd ..\SCREENS
    echo ENDED %%~nA
    pause
)
cd..
:end
