# Dragon-AGD-Suite
AGD suite for converting, compiling and running AGD games on a Dragon/COCO

				BAT files for the AGD-CoCoDragonSuite
============================================================================================================
* a <name> params   = compile + assemble + create diskimages [+ create folder] into _OK
* am       params   = same but for all .AGD files in the directory. Carefull same params for all of them!
* b <name> params   = compile + assemble + create diskimages

* btc <name> params = compile + assemble + create diskimages + run Coco emulator
* btd <name> params = compile + assemble + create diskimages + run Dragon emulator

* cm <name>         = compile C-program + copy to appropriate dir

* cv <name> params  = convert snapshot to AGD file. params [b d] (Big, Dither)
* cvd <name> param  = converts one snapshot (applying param and forcing d (dithering))
* cvdm      param   = same as before for all snapshots in folder
* cvm       param   = convert all snapshots (applying same parameter). param [b]

* p params          = adds Pannels from Screens to already compiled games disks [3|4][x|d]

* see <name> params = shows on a Dragon emulated the selected screen. params [3|4] [x|d]
* seed <name> 	  = shows on a Dragon emulated the selected screen. if not received, forces param [4]

* split <name>      = splits AGD file into pieces and puts them into an VDK same <name>. Carefull will conflict with game disk!!
* spledit <name>    = splits AGD file and starts XRoar to edit the graphic parts

* view <name>       = opens Tony Viewer v1 to se the contents of an AGD file

* z        params   = [cut/reorder 6912 bytes ZX-SCR files | ALL files +] add to Coco/Dragon disk images
* w                 = split Coco/Dragon disk images from _OK folder to separate destination folders in _TEST

-------------------------------------------------------------------------------------------------------------

* b   can be used to verify the total binary length to determine if params RFLAG, BFLAG are needed
* btc and btd will be used to verify if the binaries work well on each machine
* seed forces param 2 to de D (dragon)

Normal Procedure for one game or multiple games:
* copy the sna file(s) to ..\AGD-DragonSuite
* use cv <name> to generate the .AGD file for each game
* modify / correct any known errors in these AGD files
* use   a <name> params to create a folder in _OK with all the files related to <name> (one game)
    or  am       params for the same applied to all agd files
* IF we want a PMODE3 executable, then do
	a <name> params to add to previously generated disks the PMode 3 binaries
* to copy all the 'special' intro screens you'd like for these games in *same* PMODE into folder SCREENS
* use   z [3|4] [x|d] to cut length and/or re-order image from ZX format to 6809 format
	These images will be added to the (pre-existent) disks in _OK as INTRO[3|4].BIN
	If you have screens 6144 length that are *NOT* ZX-like, use param "d", else param "x"

If you want to test all the created disks
* use   w
This will copy all of the VDK / DSK files into (pre-existent) subfolders named "D" and "C" respectively
