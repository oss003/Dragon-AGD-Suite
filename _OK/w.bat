for /r "..\_OK\" %%x in (*.VDK) do copy "%%x" "..\_TEST\D\"
for /r "..\_OK\" %%x in (*.DSK) do copy "%%x" "..\_TEST\C\"
pause
