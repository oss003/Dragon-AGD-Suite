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
set filename="PANNEL"
cd SCREENS
for %%A in (*.PAN) do (
   del PANNEL.SCR
   copy %%A PANNEL.SCR
   if %2==x (
      echo using CUTTER1
      ..\Cutter\cutter %filename%
   ) else (
      if %%~zA == 6912 (
         echo using CUTTER6912
         ..\Cutter\cutter %filename%
      ) else (
         echo COPYING FILE
         copy %filename%.SCR %filename%.bin
      )
   )
  del PANNEL.SCR

   rem create binaries for CoCo-Dragon
    copy ..\_Headers\CHeaderP.bin /B + PANNEL.bin /B + ..\_Headers\CFooterP.bin /B PANNELC.BIN /B
    copy ..\_Headers\DHeaderP.bin /B + PANNEL.bin /B  PANNELD.BIN /B
    del PANNEL.bin

   rem copy virtual files to Utils folders
    move ..\..\_OK\%%~nA\%%~nA.DSK ..\ImgTool
    move ..\..\_OK\%%~nA\%%~nA.VDK ..\DragDOS\

   rem copy Basic program for Pannels to ImgTool folders
    copy ..\BAS\SETAGCP.BAS ..\ImgTool\SETAGD.BAS
    copy ..\BAS\SETAGDP.BAS ..\DragDOS\SETAGD.BAS

   rem copy images to DragonDos/ImgTool folders
    if "%1"=="3" (
       move PANNELC.BIN ..\ImgTool\PANNEL3.BIN
       move PANNELD.BIN ..\DragDOS\PANNEL3.BIN
    ) else (
       move PANNELC.BIN ..\ImgTool\PANNEL4.BIN
       move PANNELD.BIN ..\DragDOS\PANNEL4.BIN
    )

   rem create/add to CoCo DSK
    cd ..\ImgTool
    call packP %%~nA
    del PANNEL?.BIN
    del *.BAS
    move %%~nA.DSK ..\..\_OK\%%~nA\

   rem create/add to Dragon VDK
    cd ..\DragDOS
    call packP %%~nA
    del PANNEL?.BIN
    del *.BAS
    move %%~nA.VDK ..\..\_OK\%%~nA\

   rem back to the images directory
    cd ..\SCREENS
    echo ENDED %%~nA
    pause
)
cd..
:end
