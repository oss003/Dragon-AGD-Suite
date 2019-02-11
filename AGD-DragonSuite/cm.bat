@echo on
copy %1.C ..\MinGW\sources\%1\%1.C
PATH=d:\XRoar\_Projectes\48-AGD\AGD\MinGW\bin;d:\XRoar\_Projectes\48-AGD\AGD\MinGW\msys\1.0\bin
cd ..\MinGW\sources\%1
make

if %1==AGDdragon del ..\..\..\AGD-DragonSuite\AGD\AGD-OLD.EXE
if %1==AGDdragon rename ..\..\..\AGD-DragonSuite\AGD\AGD.EXE AGD-OLD.EXE
if %1==AGDdragon copy agd.exe ..\..\..\AGD-DragonSuite\AGD\AGD.EXE

if %1==convert del ..\..\..\AGD-DragonSuite\Convert\convert-OLD.EXE
if %1==convert rename ..\..\..\AGD-DragonSuite\Convert\Convert.EXE convert-OLD.EXE
if %1==convert copy convert.exe ..\..\..\AGD-DragonSuite\Convert\convert.EXE

if %1==cutter del  ..\..\..\AGD-DragonSuite\Cutter\cutter-OLD.exe
if %1==cutter rename ..\..\..\AGD-DragonSuite\Cutter\cutter.exe cutter-OLD.exe
if %1==cutter copy cutter.exe ..\..\..\AGD-DragonSuite\Cutter\cutter.exe

if %1==AGDparser del ..\..\..\AGD-DragonSuite\AGDP\AGDP-OLD.EXE
if %1==AGDparser rename ..\..\..\AGD-DragonSuite\AGDP\AGDP.EXE AGDP-OLD.EXE
if %1==AGDparser copy agdp.exe ..\..\..\AGD-DragonSuite\AGDP\AGDP.EXE

cd..\..\..\AGD-DragonSuite
