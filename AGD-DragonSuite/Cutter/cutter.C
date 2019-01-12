// ********************************************************************
// cutter - cuts and reorganizes the 6144 bytes of a ZX-Spectrum screen
// so that CoCo, Dragon and other machines could use it
// ********************************************************************

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

/* Definitions.  */
#define ZX_IMAGE_SIZE		6912
#define DraCo_IMAGE_SIZE	6144

/* Prototypes. */
void ReadInputFile(void);

/* global variables   */
FILE *fpSource;
FILE *fpObject;
unsigned long int lSize;
unsigned char map[6144];

int main( int argc, const char* argv[] )
{
	char fSourceFilename[ 32 ];
	char fOutputFilename[ 32 ];

	if ( argc != 2 )
	{
	    // invalid number of command line arguments
		puts( "Usage: CUTTER IMAGENAME" );
		exit( 1 );
	}

	/* open source snapshot. */
	sprintf( fSourceFilename, "%s.scr", argv[ 1 ] );
	fpSource = fopen( fSourceFilename, "rb" );
	if ( !fpSource )
	{
       	fprintf( stderr, "Unable to read input file: %s\n", fSourceFilename );
		exit( 1 );
	}

	/* Establish its size. */
	fseek( fpSource, 0, SEEK_END );
	lSize = ftell( fpSource );
	rewind( fpSource );
	if ( lSize != ZX_IMAGE_SIZE  && lSize != DraCo_IMAGE_SIZE )
	{
		puts( "Source is not an accepted Image Screen" );
		exit( 1 );
	}

	/* Open target file. */
	sprintf( fOutputFilename, "%s.BIN", argv[ 1 ] );
	fpObject = fopen( fOutputFilename, "wb" );

	if ( !fpObject )
	{
        fprintf( stderr, "Unable to create output file: %s\n", fOutputFilename );
		exit( 1 );
	}

	ReadInputFile();
	fwrite( &map[0], 1, 6144, fpObject );
	fclose( fpObject );
	fclose( fpSource );
}

void ReadInputFile( void )
{
	unsigned long int i = 0;
	unsigned long int third = 0;
	unsigned long int rowByte = 0;		// vertical bytes that form a char (0 to 7)
	unsigned long int rowChar = 0;		// number of character rows in a screen third (0 to 7)
	unsigned char cByte;

	for	( third=0; third<3; third++ ) {
		for ( rowChar=0; rowChar<8; rowChar++ ) {
			for ( rowByte=0; rowByte<8; rowByte++ ) {
				for ( i=0; i<32; i++) {
					cByte = fgetc(fpSource);
					map[i + 32*rowChar + 256*rowByte + 2048*third] = cByte;
				}
			}
		}
	}
}
