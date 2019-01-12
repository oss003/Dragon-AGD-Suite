for %%a in (*.BIN) do (
   imgtool del coco_jvc_rsdos %1.DSK %%a %%a	
   imgtool put coco_jvc_rsdos %1.DSK %%a %%a
)
imgtool dir coco_jvc_rsdos %1.DSK >listing.txt
