@echo off
for %%A in (*.sna) do (
   call cv.bat %%~nA %1 
)
