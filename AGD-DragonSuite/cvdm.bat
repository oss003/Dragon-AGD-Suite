@echo off
for %%A in (*.sna) do (
   call cvd.bat %%~nA %1 
)
