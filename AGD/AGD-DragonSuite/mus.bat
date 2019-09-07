@echo off
copy %1.VDK XRoar
pushd
cd XRoar
xroar -ao-format float -machine dragon64 -machine-cpu 6809 -extbas d64_1.rom -altbas d64_2.rom -machine-cart mpi -mpi-load-cart 3=ddos41dir -mpi-load-cart 0=gmc_test -mpi-slot 3 -load %1.VDK -type RUN"MUS.BAS\n -force-crc-match -disk-write-back -joy-left 0,0:1:0 -kbd-translate
del %1*.*
popd

