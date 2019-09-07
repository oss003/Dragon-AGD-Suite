for %%a in (*.BIN) do (
   Dragondos DELETE %1.VDK %%a
   Dragondos WRITE %1.VDK %%a
)
Dragondos DIR %1.VDK >listing.txt
