@echo off
copy %~n1.VDK d:\XRoar\_Projectes\48-AGD\AGD\AGD-DragonSuite\XRoar
pushd d:\XRoar\_Projectes\48-AGD\AGD\AGD-DragonSuite\XRoar
xroar -machine dragon64 -machine-cpu 6809 -extbas d64_1.rom -altbas d64_2.rom -machine-cart dragondos -cart-rom ddos.rom -load %~n1.VDK -type RUN"SETAGD.BAS\n -force-crc-match -disk-write-back -joy-left 0,0:1:0 -kbd-translate
del %~n1.VDK
del %~n1.VDK.BAK
popd



