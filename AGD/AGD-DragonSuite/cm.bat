@echo on
copy %1.C ..\MinGW\sources\%1\%1.C
PATH=d:\XRoar\_Projectes\48-AGD\AGD\MinGW\bin;d:\XRoar\_Projectes\48-AGD\AGD\MinGW\msys\1.0\bin
cd ..\MinGW\sources\%1
make
rem delete old exe, rename actual to old and copy source and exe to destination
if %1==AGDdragon del ..\..\..\AGD-DragonSuite\AGD\AGD-OLD.EXE
if %1==AGDdragon rename ..\..\..\AGD-DragonSuite\AGD\AGD.EXE AGD-OLD.EXE
if %1==AGDdragon copy agd.exe ..\..\..\AGD-DragonSuite\AGD\AGD.EXE
if %1==AGDdragon copy AGDdragon.C ..\..\..\AGD-DragonSuite\AGD\AGDdragon.C

if %1==convert del ..\..\..\AGD-DragonSuite\Convert\convert-OLD.EXE
if %1==convert rename ..\..\..\AGD-DragonSuite\Convert\Convert.EXE convert-OLD.EXE
if %1==convert copy convert.exe ..\..\..\AGD-DragonSuite\Convert\convert.EXE
if %1==convert copy Convert.C ..\..\..\AGD-DragonSuite\Convert\Convert.C

if %1==cutter del  ..\..\..\AGD-DragonSuite\Cutter\cutter-OLD.exe
if %1==cutter rename ..\..\..\AGD-DragonSuite\Cutter\cutter.exe cutter-OLD.exe
if %1==cutter copy cutter.exe ..\..\..\AGD-DragonSuite\Cutter\cutter.exe
if %1==cutter copy cutter.C ..\..\..\AGD-DragonSuite\Cutter\cutter.C

if %1==AGDparser del ..\..\..\AGD-DragonSuite\AGDP\AGDP-OLD.EXE
if %1==AGDparser rename ..\..\..\AGD-DragonSuite\AGDP\AGDP.EXE AGDP-OLD.EXE
if %1==AGDparser copy agdp.exe ..\..\..\AGD-DragonSuite\AGDP\AGDP.EXE
if %1==AGDparser copy AGDparser.C ..\..\..\AGD-DragonSuite\AGDP\AGDparser.C

if %1==Conv30 del ..\..\..\AGD-DragonSuite\Convert\conv30-OLD.EXE
if %1==Conv30 rename ..\..\..\AGD-DragonSuite\Convert\Conv30.EXE conv30-OLD.EXE
if %1==Conv30 copy conv30.exe ..\..\..\AGD-DragonSuite\Convert\conv30.EXE
if %1==Conv30 copy conv30.C ..\..\..\AGD-DragonSuite\Convert\conv30.C

if %1==Conv26 del ..\..\..\AGD-DragonSuite\Convert\conv26-OLD.EXE
if %1==Conv26 rename ..\..\..\AGD-DragonSuite\Convert\Conv26.EXE conv26-OLD.EXE
if %1==Conv26 copy conv26.exe ..\..\..\AGD-DragonSuite\Convert\conv26.EXE
if %1==Conv26 copy conv26.C ..\..\..\AGD-DragonSuite\Convert\conv26.C

cd..\..\..\AGD-DragonSuite
