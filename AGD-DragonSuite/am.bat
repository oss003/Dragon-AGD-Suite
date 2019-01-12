@echo off
for %%A in (*.agd) do (
   call a.bat %%~nA %1 %2 %3 %4 %5 %6
)
