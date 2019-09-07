@echo off
copy %1.AGD ..\Viewer
cd ..\Viewer
AGDvx %1.AGD
del %1.AGD
cd ..\AGD-DragonSuite
