for %%a in (*.BIN) do (
   imgtool del coco_jvc_rsdos %1.DSK %%a %%a	
   imgtool put coco_jvc_rsdos %1.DSK %%a %%a
)
for %%a in (*.BAS) do (
   imgtool del coco_jvc_rsdos %1.DSK %%a %%a	
   imgtool put coco_jvc_rsdos %1.DSK %%a %%a --ftype=basic
)
imgtool dir coco_jvc_rsdos %1.DSK >listing.txt
