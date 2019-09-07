# Dragon-AGD-Suite
AGD suite for converting, compiling and running AGD games on a Dragon/COCO

			    BAT files for the AGD-CoCoDragonSuite
==============================================================================
* a [name] params   = compile + assemble + create diskimages [+ create folder] into _OK
* b [name] params   = compile + assemble + create diskimages (is called by a.bat file)

* btc [name] params = compile + assemble + create diskimages + run Coco emulator
* btd [name] params = compile + assemble + create diskimages + run Dragon emulator

* cm [name]         = compile C-program + copy to appropriate dir, same name as source file 
 		      The destination folder must exist in ..\MinGW\sources\)
 		      and it should contain a file makefile. with the compile command

* cv [version] [name] params  
		    = convert snapshot to AGD file. 
		      <version> should be one of  26, 30, 47 
		      params [b | d] (Big, Dither)

* mus [VdkFileName] = calls dragon emulator with MPI and GMC module. Starts MUS.BAS
		      that calls the compiled binary musical demo

* p params          = adds Pannels from Screens to game disks already created in OK folder
		      params [3|4][x|d] for PMode3/4 ZX/Dgn

* r [name]	    = will start XRoar with a VDK file and start the AGD game. 
		      the VDK file must exist in main folder AGD-DragonSuite

* rdsk		   = is a bat file associated to .DSK files. Clicking on a DSK starts it
* rvdk		   = is a bat file associated to .VDK files. Clicking on a VDK starts it

* see [name] param  = shows on a Dragon emulated screen the selected image 
		      param [3|4] If not received, forces value 4

* spledit [name]    = splits AGD file and starts XRoar to edit the graphic parts
		      The created disk is named GAMEGFX.VDK and you should better
		      copy it to another folder, renaming it at your will

* view [name]       = opens Tony's Viewer v1 to see the contents of an AGD file

* w                 = copies Coco/Dragon disk images from _OK folder to separate destination
		      in folder _TEST using subfolders \C and \D that *must* exist there

* z        params   = cuts/reorders 6912 bytes ZX-SCR files (names must equal gamename)
	 	      and adds to Coco/Dragon disk images as INTRO screen


				     PROCEDURE FOR ONE GAME
================================================================================
1) copy the .sna file to main folder AGD-DragonSuite
2) use cv <version> <name> [params] to generate the .AGD file
3) modify / correct the AGD file at your will
4) to test the game issue command
  btd or btc <name> <params> so that you can play the game
5) when you are done, issue the command
  a <name> params to create a folder in _OK with all the files related to <name>

If we want to add a PMODE3 executable, then use param [G] in previous steps 2-4-5<br>
	in case you are creating both B/W and Colour, create first the B/W and then the colour one but using the same GameNAME for both versions. You will get only one disk with all the versions <br>
	Carefull when archiving with command a because it will overwrite files B/W when processing colour<br>
	To avoid this you *MUST* rename B/W files appending a suffix to diferentiate them.<br> 
	For instance gamenameBW and then gamename will be used for the colour files<br>
To copy an intro screen you'd like to add to a game in *same* PMODE<br>
  first copy the gamename.scr into folder SCREENS. Name must equal the gamename. Then do<br>
  z [3|4] [x|d] to cut length and/or re-order image from ZX format to 6809 format<br>
	These images will be added to the (pre-existent) disks in _OK as INTRO[3|4].BIN<br>
	If you have screens 6144 length that are *NOT* ZX-like, use param "d", else param "x"<br>
In case the game needs a Pannel to complete the screen<br>
  first copy the gamename.pan into folder SCREENS. Name must equal the gamename. Then do<br>
  p [3|4] [x|d] that will add the pannel into the pre-existent VDK/DSK files for that game<br>
If you want to test the created disks, send them to _TEST issuing the command <br>
  w	This will copy all of the VDK/DSK files into (pre-existent) subfolders named "D" and "C"<br>
