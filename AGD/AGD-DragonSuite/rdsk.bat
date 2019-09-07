@echo off
copy %~n1.DSK d:\XRoar\_Projectes\48-AGD\AGD\AGD-DragonSuite\XRoar
pushd d:\XRoar\_Projectes\48-AGD\AGD\AGD-DragonSuite\XRoar
xroar -machine coco -bas bas14.rom -extbas extbas11.rom -machine-cart rsdos -cart-rom disk12.rom -ram 64 -load %~n1.DSK -type RUN"SETAGD.BAS\n -force-crc-match -disk-write-back -joy-left 0,0:1:0 -kbd-translate  
del %~n1.DSK
del %~n1.DSK.BAK
popd



