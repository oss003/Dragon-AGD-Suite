# Dragon-AGD-Suite
AGD suite for converting, compiling and running AGD games on a Dragon/COCO

-------------------------------------------------------------------------------------------------------------

BAT files for the AGD-CoCoDragonSuite

- a <name> params   = compile + assemble + create diskimages [+ create folder] into _OK
- am       params   = same but for all .AGD files in the directory. Carefull same params for all of them!

- b <name> params   = compile + assemble + create diskimages

- z        params   = [cut/reorder 6912 bytes ZX-SCR files | ALL files +] [create folder +] add to Coco/Dragon disk images
- zp       params   = [cut/reorder 6912 bytes ZX-SCR files | ALL files
- w                 = split Coco/Dragon disk images to separate destination folders

btc <name> params = compile + assemble + create diskimages + run Coco emulator
btd <name> params = compile + assemble + create diskimages + run Dragon emulator

cm <name>         = compile C-program + copy to appropriate dir
cv <name> params  = convert snapshot to AGD file. params [b d] (Big, Dither)
cvm       param   = convert all snapshots (applying same parameter). param [b]

see <name> params = shows on a Dragon emulated the selected screen. params [3|4] [x|d]
seeD <name> param = shows on a Dragon emulated the selected screen. param  [3|4]

-------------------------------------------------------------------------------------------------------------

- b   can be used to verify the total binary length to determine if params RFLAG, BFLAG are needed
- btc and btd will be used to verify if the binaries work well on each machine
- zp  is useful to add headers to a lot of files without moving them (for instance for Aeon v1.1)
- seeD forces param 2 to de D (dragon)

Normal Procedure for one game or multiple games:
- copy the sna file(s) to ..\AGD-DragonSuite
- use cv <name> to generate the .AGD file for each game
- modify / correct any known errors in these AGD files
- use   a <name> params to create a folder in _OK with all the files related to <name> (one game)
    or  am       params for the same applied to all agd files
- IF we want a PMODE3 executable, then do
	a <name> params to add to previously generated disks the PMode 3 binaries
- to copy all the 'special' intro screens you'd like for these games in *same* PMODE into folder SCREENS
- use   z [3|4] [x|d] to cut length and/or re-order image from ZX format to 6809 format
	These images will be added to the (pre-existent) disks in _OK as INTRO[3|4].BIN
	If you have screens 6144 length that are *NOT* ZX-like, use param "d", else param "x"

If you want to test all the created disks
- use   w
This will copy all of the VDK / DSK files into (pre-existent) subfolders named "D" and "C" respectively
