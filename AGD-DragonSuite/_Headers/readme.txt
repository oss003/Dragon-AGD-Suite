ZIP contents
============
AddCo.bat - adds header and postamble to a binary image to enable it for CoCo.
	Sets load and exec addresses equal to $3800 so it is intended to create 
	an INTRO.BIN to be added to an AGD GAME DSK
	
AddDg.bat - adds header to a binary image to enable it for the Dragon.
	Sets load and exec addresses equal to $3800 so it is intended to create 
	an INTRO.BIN to be added to an AGD GAME VDK

AddDgL.bat - adds header to a binary image to enable it for the Dragon.
	Sets load and exec addresses equal to $0c00 so it is intended to create 
	a file.BIN that can be loaded into a Dragon-XRoar-Mess to verify it.

CFooter.bin - is the postamble file that is added to create a CoCo binary
	Sets exec address to $3800 (for AGD disk Games)
	
CHeader.bin - is the header file that is added to create a CoCo binary
	Sets load address to $3800 (for AGD disk Games)
	and the length to $1800 (6144 bytes)

DHeader.bin - is the header file that is added to create a Dragon binary
	Sets load and exec addresses to $3800 (for AGD disk Games)
	and the length to $1800 (6144 bytes)
	
DHeaderL.bin - is the header file that is added to create a 'real' Dragon binary
	Sets load and exec addresses to $0c00 (for Dragon-XRoar-Mess)
	and the length to $1800 (6144 bytes)

There is a folder that contains the 5 binary files you uploaded


