/* ------------------------------------------------------------	*/
/* Special converter version to deal with AGD v3.0 snapshots   	*/
/* version 1.8  -  Pere Serrat  - 2019-05-10                   	*/
/* ------------------------------------------------------------	*/
/* Rules to be applied (info by Kees van Oss)                  	*/
/*	- AGD3.0 keys = UDLR123, AGD4.7 keys = RLDU123   			*/
/*	- AGD3.0 tokens differ from AGD4.7 tokens   				*/
/*	- AGD3.0 event order is different compared to AGD4.7	   	*/
/*	  		 and has less events     							*/
/*	- AGD3.0 enemy consists of 5 bytes, AGD4.7 has 4 bytes   	*/
/*    		 last byte is to be skipped							*/
/*	- AGD3.0 MAP_LAYOUT is not used								*/
/*	- AGD3.0 NUM_SCREENS address was $3d30						*/
/*	- AGD3.0 START_SCREEN must be forced to ZERO				*/
/*	- AGD3.0 MAP_WID must be 10 instead of 11	  				*/
/* ------------------------------------------------------------	*/
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

/* Definitions.  */
#define LF				0x0a
#define CR				0x0d
#define TARGET_CODE_SIZE		131072						// enough for source code?
#define SNAPSHOT_SIZE			49179
#define FONT				0x3a1b						// 3A1B		same value for v4.7
//#define MAP_LAYOUT_A			( 31959 + 27 - 16384 )		// NOT USED
//#define MAP_LAYOUT_B			( 31959 + 27 - 16384 )		// NOT USED	was 3CF2 for v4.7  *** NOT USED HERE ***
#define WINDOW				0x3d2a						// 3D2A		was 3D23 for v4.7
#define NUM_SCREENS			0x3d30						// 3D30		was 3D2D for v4.7
#define POINTERS			0x3d54						// 3D54		was 3D56 for v4.7
//#define POINTERS_A			( 32057 + 27 - 16384 )		// NOT USED
//#define POINTERS_B			( 32059 + 27 - 16384 )		// NOT USED
//#define START_SCREEN_A		( 33580 + 27 - 16384 )		// NOT USED
//#define START_SCREEN_B		( 33615 + 27 - 16384 )		// force it to be zero. was at 436A for v4.7
//#define KEYS_A			( 35331 + 27 - 16384 )		// NOT USED
#define KEYS				0x53cc						// 47AE		was 4A26 for v4.7
//#define JUMP_TABLE_A			( 36217 + 27 - 16384 )		// NOT USED
#define JUMP_TABLE			0x4b08						// 4B08		was 4DA9 for v4.7
#define STUFF_TO_SKIP			( 16384 - 27 )				// 			this was for v4.7
#define MAP_HGT				8							// 			this was for v4.7
#define MAP_WID				10							// 10		11 was for v4.7
#define NUM_EVENTS			21							// THE NOT USED IN v3.0 ARE ADDED AT THE END OF THE CODE

// Equates for version 4.7
enum
{															// REORDERED FOR v3.0
	INS_IF,													// 00 - was code 000	for v4.7
	INS_MSU,												// 01 - was code 001	for v4.7
	INS_MSD,												// 02 - was code 002	for v4.7
	INS_MSL,												// 03 - was code 003	for v4.7
	INS_MSR,												// 04 - was code 004	for v4.7
	INS_ENDIF,												// 05 - was code 005	for v4.7
	INS_CGU,												// 06 - was code 006	for v4.7
	INS_CGD,												// 07 - was code 007	for v4.7
	INS_CGL,												// 08 - was code 008	for v4.7
	INS_CGR,												// 09 - was code 009	for v4.7
	INS_LDU,												// 10 - was code 010	for v4.7
	INS_LDD,												// 11 - was code 011	for v4.7
	INS_DED,												// 12 - was code 012	for v4.7
	INS_CUS,												// 13 - was code 013	for v4.7
	INS_TO,													// 14 - was code 015	for v4.7
	INS_FROM,												// 15 - was code 016	for v4.7
	INS_TYP,												// 16 - was code 018	for v4.7
	INS_IMAGE,												// 17 - was code 019	for v4.7
	INS_FRAME,												// 18 - was code 020	for v4.7
	INS_X,													// 19 - was code 021	for v4.7
	INS_Y,													// 20 - was code 022	for v4.7
	INS_DIR,												// 21 - was code 023	for v4.7
	INS_PMA,												// 22 - was code 024	for v4.7
	INS_PMB,												// 23 - was code 025	for v4.7
	INS_SCREEN,												// 24 - was code 026	for v4.7
	INS_LIVES,												// 25 - was code 027	for v4.7
	INS_A,													// 26 - was code 028	for v4.7
	INS_B,													// 27 - was code 029	for v4.7
	INS_C,													// 28 - was code 030	for v4.7
	INS_D,													// 29 - was code 031	for v4.7
	INS_E,													// 30 - was code 032	for v4.7
	INS_F,													// 31 - was code 033	for v4.7
	INS_G,													// 32 - was code 034	for v4.7
	INS_H,													// 33 - was code 035	for v4.7
	INS_I,													// 34 - was code 036	for v4.7
	INS_J,													// 35 - was code 037	for v4.7
	INS_K,													// 36 - was code 038	for v4.7
	INS_L,													// 37 - was code 039	for v4.7
	INS_M,													// 38 - was code 040	for v4.7
	INS_N,													// 39 - was code 041	for v4.7
	INS_O,													// 40 - was code 042	for v4.7
	INS_P,													// 41 - was code 043	for v4.7
	INS_Q,													// NU - was code 044	for v4.7
	INS_R,													// NU - was code 045	for v4.7
	INS_LINE,												// 42 - was code 048	for v4.7
	INS_COLUMN,												// 43 - was code 049	for v4.7
	INS_RND,												// 44 - was code 051	for v4.7
	INS_OBJ,												// 45 - was code 052	for v4.7
	INS_OPT,												// 46 - was code 053	for v4.7
	INS_GOT,												// 47 - was code 054	for v4.7
	INS_KEY,												// 48 - was code 055	for v4.7
	INS_COLLISION,											// 49 - was code 056	for v4.7
	INS_NUMBER,												// 50 - was code 014	for v4.7
	INS_EQUAL_TO,											// 51 - was code 057	for v4.7
	INS_GREATER_THAN,										// 52 - was code 058	for v4.7
	INS_NOT_EQUAL_TO,										// 53 - was code 059	for v4.7
	INS_LESS_THAN,											// 54 - was code 060	for v4.7
	INS_LET,												// 55 - was code 061	for v4.7
	INS_ANIMATE,											// 56 - was code 062	for v4.7
	INS_ANIMBACK,											// 57 - was code 063	for v4.7
	INS_DUP,												// 58 - NU - uses DIG direction
	INS_DDWN,												// 59 - NU - uses DIG direction
	INS_DL,													// 60 - NU - uses DIG direction
	INS_DR,													// 61 - NU - uses DIG direction
	INS_FUP,												// 62 - NU - uses fill direction
	INS_FDWN,												// 63 - NU - uses fill direction
	INS_FL,													// 64 - NU - uses fill direction
	INS_FR,													// 65 - NU - uses fill direction
	INS_NEXTLEVEL,											// 66 - was code 065	for v4.7
	INS_RESTART,											// 67 - was code 066	for v4.7
	INS_SPAWN,												// 68 - was code 067	for v4.7
	INS_REM,												// 69 - was code 068	for v4.7
	INS_GRN,												// 70 - was code 069	for v4.7
	INS_ELSE,												// 71 - was code 070	for v4.7
	INS_DSC,												// 72 - was code 071	for v4.7
	INS_SCO,												// 73 - was code 072	for v4.7
	INS_SND,												// 74 - was code 073	for v4.7
	INS_BEEP,												// 75 - was code 074	for v4.7
	INS_CLS,												// 76 - was code 075	for v4.7
	INS_BORDER,												// 77 - was code 076	for v4.7
	INS_CLR,												// 78 - was code 077	for v4.7
	INS_DEL,												// 79 - was code 078	for v4.7
	INS_MESSAGE,											// 80 - was code 079	for v4.7
	INS_MENU,												// 81 - was code 080	for v4.7
	INS_INV,												// 82 - was code 081	for v4.7
	INS_KILL,												// 83 - was code 082	for v4.7
	INS_ADD,												// 84 - was code 083	for v4.7
	INS_SUB,												// 85 - was code 084	for v4.7
	INS_DIS,												// 86 - was code 085	for v4.7
	INS_SUP,												// 87 - was code 086	for v4.7
	INS_SDW,												// 88 - was code 087	for v4.7
	INS_SLF,												// 89 - was code 088	for v4.7
	INS_SRG,												// 90 - was code 089	for v4.7
	INS_PRE,												// 91 - was code 090	for v4.7
	INS_JUMP,												// 92 - was code 091	for v4.7
	INS_FALL,												// 93 - was code 092	for v4.7
	INS_OTHER,												// 94 - was code 093	for v4.7
	INS_SPAWNED,											// 95 - was code 094	for v4.7
	INS_ORIGINAL,											// 96 - was ENDSPRITE code 095	for v4.7
	INS_EGM,												// 97 - was code 096	for v4.7
	INS_GET,												// 98 - was code 097	for v4.7
	INS_PUT,												// 99 - was code 098	for v4.7
	INS_DET,												//100 - was code 099	for v4.7
//	INS_ASM,												// NU - was code 100	for v4.7
//	INS_EXIT,												// NU - was code 101	for v4.7
//	INS_REPEAT,												// NU - was code 102	for v4.7
//	INS_ENDREPEAT,											// NU - was code 103	for v4.7
//	INS_MULTIPLY,											// NU - was code 104	for v4.7
//	INS_DIVDE,												// NU - was code 105	for v4.7
//	INS_SPI,												// NU - was code 106	for v4.7
//	INS_TRAIL,												// NU - was code 107	for v4.7
//	INS_LASER,												// NU - was code 108	for v4.7
//	INS_EXPLODE,											// NU - was code 109	for v4.7
//	INS_FADE,												// NU - was code 110	for v4.7
//	INS_TICKER,												// NU - was code 111	for v4.7
//	INS_BIGMESSAGE,											// NU - was code 112	for v4.7
//	INS_REDRAW,												// NU - was code 113	for v4.7
//	INS_SIL,												// NU - was code 114	for v4.7
//	INS_CON,												// NU - was code 115	for v4.7
//	INS_DIG,												// NU - was code 116	for v4.7
//	INS_STR,												// NU - was code 117	for v4.7
//	INS_BIGSCORE,											// NU - was code 118	for v4.7
//	INS_STOPFALL											// NU - was code 119	for v4.7
//	INS_BY,													// NU - was code 017	for v4.7
//	INS_Q,													// NU - was code 044	for v4.7
//	INS_R,													// NU - was code 045	for v4.7
//	INS_S,													// NU - was code 046	for v4.7
//	INS_T,													// NU - was code 047	for v4.7
//	INS_CLOCK,												// NU - was code 050	for v4.7
//	INS_PUTBLOCK,											// NU - was code 064	for v4.7
};

#define INS_ARGUMENTS			INS_CGU
typedef struct
{															// I hope this does not change
	short int top;											// this was for v4.7
	short int bottom;										// this was for v4.7
	short int left;											// this was for v4.7
	short int right;										// this was for v4.7
} RECT;

unsigned char cKeyword[][ 13 ] =
{
	/* Some keywords. */									// REORDERED for v3.0
	"IF",				// if.								// 00 - was code 000	for v4.7
	"SPRITEUP",			// move sprite up.					// 01 - was code 001	for v4.7
	"SPRITEDOWN",		// move sprite down.				// 02 - was code 002	for v4.7
	"SPRITELEFT",		// move sprite left.				// 03 - was code 003	for v4.7
	"SPRITERIGHT",		// move sprite right.				// 04 - was code 004	for v4.7
	"ENDIF",			// endif.							// 05 - was code 005	for v4.7
	"CANGOUP",			// sprite can go up test.			// 06 - was code 006	for v4.7
	"CANGODOWN",		// sprite can go down test.			// 07 - was code 007	for v4.7
	"CANGOLEFT",		// sprite can go left test.			// 08 - was code 008	for v4.7
	"CANGORIGHT",		// sprite can go right test.		// 09 - was code 009	for v4.7
	"LADDERABOVE",		// ladder above test.				// 10 - was code 010	for v4.7
	"LADDERBELOW",		// ladder below test.				// 11 - was code 011	for v4.7
	"DEADLY",			// check if touching deadly block.	// 12 - was code 012	for v4.7
	"CUSTOM",    		// check if touching custom block.	// 13 - was code 013	for v4.7
	"TO",           	// variable to increment.			// 14 - was code 015	for v4.7
	"FROM",          	// variable to decrement.			// 15 - was code 016	for v4.7

	/* Sprite variables. */
	"TYPE",				// first parameter.					// 16 - was code 018	for v4.7
	"IMAGE",			// image number.					// 17 - was code 019	for v4.7
	"FRAME",			// frame number.					// 18 - was code 020	for v4.7
	"Y",				// vertical position.				// 19 - was code 021	for v4.7 inverted?
	"X",				// horizontal position.				// 20 - was code 022	for v4.7 inverted?
	"DIRECTION",		// user sprite parameter.			// 21 - was code 023	for v4.7
	"SETTINGA",			// sprite parameter a.				// 22 - was code 024	for v4.7
	"SETTINGB",			// sprite parameter b.				// 23 - was code 025	for v4.7
	"SCREEN",			// screen number.					// 24 - was code 026	for v4.7
	"LIVES",			// lives.							// 25 - was code 027	for v4.7
	"A",				// variable.						// 26 - was code 028	for v4.7
	"B",				// variable.						// 27 - was code 029	for v4.7
	"C",				// variable.						// 28 - was code 030	for v4.7
	"D",				// variable.						// 29 - was code 031	for v4.7
	"E",				// variable.						// 30 - was code 032	for v4.7
	"F",				// variable.						// 31 - was code 033	for v4.7
	"G",				// variable.						// 32 - was code 034	for v4.7
	"H",				// variable.						// 33 - was code 035	for v4.7
	"I",				// variable.						// 34 - was code 036	for v4.7
	"J",				// variable.						// 35 - was code 037	for v4.7
	"K",				// variable.						// 36 - was code 038	for v4.7
	"L",				// variable.						// 37 - was code 039	for v4.7
	"M",				// variable.						// 38 - was code 040	for v4.7
	"N",				// variable.						// 39 - was code 041	for v4.7
	"O",				// variable.						// 40 - was code 042	for v4.7
	"P",				// variable.						// 41 - was code 043	for v4.7
	"Q",				// variable.						// NU - was code 044	for v4.7
	"R",				// variable.						// NU - was code 045	for v4.7
	"LINE",				// x coordinate.					// 42 - was code 048	for v4.7
	"COLUMN",			// y coordinate.					// 43 - was code 049	for v4.7
	"RND",				// last random number variable.		// 44 - was code 051	for v4.7
	"OBJ",				// last object variable.			// 45 - was code 052	for v4.7
	"OPT",				// menu option variable.			// 46 - was code 053	for v4.7
	"GOT",				// function.						// 47 - was code 054	for v4.7
	"KEY",				// function.						// 48 - was code 055	for v4.7

	/* Commands. */
	"COLLISION",		// collision with sprite.			// 49 - was code 056	for v4.7
	".",				// number.							// 50 - was code 014	for v4.7
	"=",				// equals, ignored.					// 51 - was code 057	for v4.7
	">",				// greater than.					// 52 - was code 058	for v4.7
	"<>",				// not equal to.					// 53 - was code 059	for v4.7
	"<=",				// less than or equal to.			// 54 - was code 060	for v4.7
	"LET",				// x = y.							// 55 - was code 061	for v4.7
	"ANIMATE",			// animate sprite.					// 56 - was code 062	for v4.7
	"ANIMBACK",			// animate sprite backwards.		// 57 - was code 063	for v4.7
	"DIG",				// dig up							// 58 - v4.7 uses DIG direction
	"DIG",				// dig down							// 59 - v4.7 uses DIG direction
	"DIG",				// dig to the left					// 60 - v4.7 uses DIG direction
	"DIG",				// dig to the right					// 61 - v4.7 uses DIG direction
	"FILLUP",			// fill up							// 62 - v4.7 uses FILL direction
	"FILLDOWN",			// fill down						// 63 - v4.7 uses FILL direction
	"FILLLEFT",			// fill to the left					// 64 - v4.7 uses FILL direction
	"FILLRIGHT",		// fill to the right				// 65 - v4.7 uses FILL direction
	"NEXTLEVEL",		// next level.						// 66 - was code 065	for v4.7
	"RESTART",			// restart game.					// 67 - was code 066	for v4.7
	"SPAWN",			// spawn new sprite.				// 68 - was code 067	for v4.7
	"REMOVE",			// remove this sprite.				// 69 - was code 068	for v4.7
	"GETRANDOM",		// variable.						// 70 - was code 069	for v4.7
	"ELSE",				// else.							// 71 - was code 070	for v4.7
	"SHOWSCORE",		// show score.						// 72 - was code 071	for v4.7
	"SCORE",			// increase score.					// 73 - was code 072	for v4.7
	"; SOUND",			// play sound.						// 74 - was code 073	for v4.7
	"BEEP",				// play beeper sound.				// 75 - was code 074	for v4.7
	"CLS",				// clear screen.					// 76 - was code 075	for v4.7
	"; BORDER",			// set border.						// 77 - was code 076	for v4.7
	"; COLOUR",			// set all attributes.				// 78 - was code 077	for v4.7
	"DELAY",			// pause for a while.				// 79 - was code 078	for v4.7
	"MESSAGE",			// display a message.				// 80 - was code 079	for v4.7
	"MENU",				// menu in a box.					// 81 - was code 080	for v4.7
	"INV",				// inventory menu.					// 82 - was code 081	for v4.7
	"KILL",				// kill the player.					// 83 - was code 082	for v4.7
	"ADD",				// add to variable.					// 84 - was code 083	for v4.7
	"SUBTRACT",			// subtract from variable.			// 85 - was code 084	for v4.7
	"DISPLAY",			// display number.					// 86 - was code 085	for v4.7
	"SCREENUP",			// up a screen.						// 87 - was code 086	for v4.7
	"SCREENDOWN",		// down a screen.					// 88 - was code 087	for v4.7
	"SCREENLEFT",		// left a screen.					// 89 - was code 088	for v4.7
	"SCREENRIGHT",		// right a screen.					// 90 - was code 089	for v4.7
	"WAITKEY",			// wait for keypress.				// 91 - was code 090	for v4.7
//	"JUMP",				// jump								// 92 - v4.7 uses TABLEJUMP
	"TABLEJUMP",		// jump								// 92 - force v4.7 Command
//	"FALL",				// fall								// 93 - v4.7 uses TABLEFALL
	"TABLEFALL",		// fall								// 93 - force v4.7 Command
	"OTHER",			// select second collision sprite.	// 94 - was code 093	for v4.7
	"SPAWNED",			// select spawned sprite.			// 95 - was code 094	for v4.7
	"ENDSPRITE",		// select original sprite			// 96 - v4.7 uses ENDSPRITE instead
	"ENDGAME",			// end game with victory.			// 97 - was code 096	for v4.7
	"GET",				// get object.						// 98 - was code 097	for v4.7
	"PUT",				// drop object.						// 99 - was code 098	for v4.7
	"DETECTOBJ",		// detect object.					//100 - was code 099	for v4.7
//	"; ASM",			// encode.							// NU - was code 100	for v4.7
//	"EXIT",				// exit.							// NU - was code 101	for v4.7
//	"REPEAT",			// repeat.							// NU - was code 102	for v4.7
//	"ENDREPEAT",		// endrepeat.						// NU - was code 103	for v4.7
//	"MULTIPLY",			// multiply.						// NU - was code 104	for v4.7
//	"DIVIDE",			// divide.							// NU - was code 105	for v4.7
//	"; SPRITEINK",		// set sprite ink.					// NU - was code 106	for v4.7
//	"TRAIL",			// leave a trail.					// NU - was code 107	for v4.7
//	"LASER",			// shoot a laser.					// NU - was code 108	for v4.7
//	"EXPLODE",			// start a shrapnel explosion.		// NU - was code 109	for v4.7
//	"; FADE",			// fade unsupported.				// NU - was code 110	for v4.7
//	"TICKER",			// ticker message.					// NU - was code 111	for v4.7
//	"MESSAGE",			// big message.						// NU - was code 112	for v4.7
//	"REDRAW",			// redraw the play area.			// NU - was code 113	for v4.7
//	"; SILENCE",		// silence AY channels.				// NU - was code 114	for v4.7
//	"CONTROLMENU",		// controlmenu unsupported.			// NU - was code 115	for v4.7
//	"DIG",				// dig.								// NU - was code 116	for v4.7
//	"STAR",				// star.							// NU - was code 117	for v4.7
//	"SHOWSCORE",		// show score double-height.		// NU - was code 118	for v4.7
//	"STOPFALL"			// stop falling.					// NU - was code 119	for v4.7
//	"BY",	          	// multiply or divide by.			// NU - was code 017	for v4.7
//	"Q",				// variable.						// NU - was code 044	for v4.7
//	"R",				// variable.						// NU - was code 045	for v4.7
//	"S",				// variable.						// NU - was code 046	for v4.7
//	"T",				// variable.						// NU - was code 047	for v4.7
//	"CLOCK",			// clock.							// NU - was code 050	for v4.7
//	"PUTBLOCK",			// put block on screen.				// NU - was code 064	for v4.7
//	"TABLEJUMP",		// jump.							// JUMP  - was code 091	for v4.7
//	"TABLEFALL",		// fall.							// FALL  - was code 092	for v4.7
//	"ENDSPRITE",		// select original sprite.			// ORIGINAL  - was code 095	for v4.7
};

unsigned char cEvent[][ 14 ] =
{															// REORDERED for v3.0
	"PLAYER",			// player.							// now 00 - was 00 for v4.7
	"SPRITETYPE1",		// sprite type 1.					// now 01 - was 01 for v4.7
	"SPRITETYPE2",		// sprite type 2.					// now 02 - was 02 for v4.7
	"SPRITETYPE3",		// sprite type 3.					// now 03 - was 03 for v4.7
	"SPRITETYPE4",		// sprite type 4.					// now 04 - was 04 for v4.7
	"SPRITETYPE5",		// sprite type 5.					// now 05 - was 05 for v4.7
	"SPRITETYPE6",		// sprite type 6.					// now 06 - was 06 for v4.7
	"SPRITETYPE7",		// sprite type 7.					// now 07 - was 07 for v4.7
	"GAMEINIT",			// game initialisation.				// now 08 - was 13 for v4.7
	"RESTARTSCREEN",	// restart a screen.				// now 09 - was 14 for v4.7
	"INITSPRITE",		// initialise sprite.				// now 10 - was 09 for v4.7
	"MAINLOOP1",		// main loop 1.						// now 11 - was 10 for v4.7
	"MAINLOOP2",		// main loop 2.						// now 12 - was 11 for v4.7
	"COMPLETEDGAME",	// won game.						// now 13 - was 18 for v4.7
	"KILLPLAYER",		// kill player.						// now 14 - was 16 for v4.7
	"SPRITETYPE8",		// sprite type 8.					// now NU - was 08 for v4.7
	"INTROMENU",		// main menu.						// now NU - was 12 for v4.7
	"FELLTOOFAR",		// sprite fell too far.				// now NU - was 15 for v4.7
	"LOSTGAME",			// game over.						// now NU - was 17 for v4.7
	"NEWHIGHSCORE",		// new high score.					// now NU - was 19 for v4.7
	"COLLECTBLOCK"		// collected block.					// now NU - was 20 for v4.7
};

/* Table used to convert keycodes to ASCII. */
const unsigned char cKeyTab[ 40 ] =
{
	'B', 'H', 'Y', '6', '5', 'T', 'G', 'V',
	'N', 'J', 'U', '7', '4', 'R', 'F', 'C',
	'M', 'K', 'I', '8', '3', 'E', 'D', 'X',
	'.', 'L', 'O', '9', '2', 'W', 'S', 'Z',
	32, 13,	'P', '0', '1', 'Q', 'A', '~'
};

char cYDither[ 8 ][35] =
{
	" 0 0 0 0 0 0 0 0",
	" 17 0 68 0 17 0 68 0",
	" 85 0 85 0 85 0 85 0",
	" 85 170 85 170 85 170 85 170",
	" 85 170 85 170 85 170 85 170",
	" 170 255 170 255 170 255 170 255",
	" 238 255 238 255 238 255 238 255",
	" 255 255 255 255 255 255 255 255"
};

char cNDither[ 8 ][35] =
{
	" 0 0 0 0 0 0 0 0",
	" 0 0 0 0 0 0 0 0",
	" 0 0 0 0 0 0 0 0",
	" 0 0 0 0 0 0 0 0",
	" 0 0 0 0 0 0 0 0",
	" 0 0 0 0 0 0 0 0",
	" 0 0 0 0 0 0 0 0",
	" 0 0 0 0 0 0 0 0"
};

unsigned short int flagB = 0;
unsigned short int flagD = 0;
FILE *fpSource;
FILE *fpObject;
unsigned char *cTgt;
unsigned char *cSrc;
unsigned char *cBuff;
unsigned long int lSize;									/* source file length. */
unsigned short int nFrmlst;
unsigned short int nSprites;
unsigned short int nChgfx;
unsigned short int nBlkcol;
unsigned short int nBprop;
unsigned short int nScdat;
unsigned short int nNmedat;
unsigned short int nSounds;
unsigned short int nText;
unsigned short int nObjects;
unsigned short int nCode;
unsigned short int nControls;
unsigned short int nAddComment = 0;	/* Add comment to outputcode */
short int nTabs;
unsigned char *cTop;
unsigned char *cLeft;
unsigned char *cHeight;
unsigned char *cWidth;
unsigned char cNewLine = 0;
unsigned char cDefaultAttr = 71;			// changed in OutputObjects because OutputBlocks modifies it!
//short int nTop;
//short int nLeft;
//short int nHeight;
//short int nWidth;
short int nRooms;
short int nPrintMode = 0;
short int nVersion;
short int nLastOp = -1;

/* Prototypes. */
void Convert( void );
void OutputWindow( void );
void OutputKeys( void );
void OutputMessages( void );
void OutputFont( void );
void OutputJumpTable( void );
void OutputBlocks( void );
void OutputSprites( void );
void OutputScreens( void );
void OutputObjects( void );
void OutputMap( void );
RECT GetMapEdges( unsigned char *cMap );
void OutputCode( void );
unsigned char ConvertByte( unsigned char cByte );
void CodeLine( char cInstruction, char cNext );
void WriteText( unsigned char *cChar );
void WriteComment( unsigned char *cChar );
void NewLine( void );

int main( int argc, const char* argv[] )
{
	char szSourceFilename[ 128 ];
	char szObjectFilename[ 128 ];
	short int flgParm;

	puts( "AGD extractor tool V0.5" );
	puts( "(C) Jonathan Cauldwell May 2018" );
	puts( "Dragon version by K.v.Oss 2018" );

	if ( argc != 2 && argc !=3 && argc !=4 )
	{
	    // invalid number of command line arguments
		puts( "Usage: CONVERT SNAPSHOT paramB (0 or 1) paramD (0 or 1)" );
		exit( 1 );
	}
	else
	{
		if ( argc == 3  || argc == 4)
		{
 		    flagB = 0;
			flgParm = atoi(argv[2]);
			if ( flgParm == 1 )
			{
			   flagB = 1;
			}
 		    flagD = 0;
			flgParm = atoi(argv[3]);
			if ( flgParm == 1 )
			{
			   flagD = 1;
			}
		}
	}

	/* open source snapshot. */
	sprintf( szSourceFilename, "%s.sna", argv[ 1 ] );
	fpSource = fopen( szSourceFilename, "rb" );
	if ( !fpSource )
	{
       	fprintf( stderr, "Unable to read snapshot file: %s\n", szSourceFilename );
		exit( 1 );
	}

	/* Establish its size. */
	fseek( fpSource, 0, SEEK_END );
	lSize = ftell( fpSource );
	rewind( fpSource );
	if ( lSize != SNAPSHOT_SIZE )
	{
		puts( "Source is not a 48K snapshot" );
		exit( 1 );
	}

	/* Open target file. */
	sprintf( szObjectFilename, "%s.agd", argv[ 1 ] );
	fpObject = fopen( szObjectFilename, "wb" );

	if ( !fpObject )
	{
        fprintf( stderr, "Unable to create target file: %s\n", szObjectFilename );
		exit( 1 );
	}

	/* Allocate buffer for the snapshot. */
	cSrc = ( char* )malloc( SNAPSHOT_SIZE );
	cBuff = cSrc;
	if ( !cSrc )
	{
		fputs( "Out of memory\n", stderr );
		exit( 1 );
	}

	/* Read source file into the buffer. */
	lSize = fread( cBuff, 1, lSize, fpSource );

	Convert();
	free( cSrc );
}

void Convert( void )
{
	unsigned short int nAddr;
	unsigned short int nSkip = STUFF_TO_SKIP;
	unsigned short int nPointers;

	cTop = cBuff + WINDOW;
	cLeft = cBuff + WINDOW + 1;
	cHeight = cBuff + WINDOW + 2;
	cWidth = cBuff + WINDOW + 3;
	nRooms = *( cBuff + NUM_SCREENS );

	/* look for pointers to determine version. */
//	nAddr = *( cBuff + POINTERS_A ) + ( *( cBuff + POINTERS_A + 1 ) << 8 );
	nAddr = *( cBuff + POINTERS ) + ( *( cBuff + POINTERS + 1 ) << 8 );			// CHANGED for v3.0

	/* is this version 4.6 or 4.7? */		// NOT NEEDED for v3.0
//	if ( nAddr == 36924 )
//	{
//		nVersion = 46;
//		nPointers = POINTERS_A;
//		nControls = KEYS_A;
//	}
//	else
//	{
//		nVersion = 47;
//		nPointers = POINTERS_B;
//		nControls = KEYS_B;
//	}
	nVersion = 30;							// VALUE for v3.0
	nPointers = POINTERS;					// VALUE for v3.0
	nControls = KEYS;						// VALUE for v3.0

	printf( "\nAssuming version %d.%d\n", nVersion / 10, nVersion % 10 );

	/* Addresses. */
	nAddr = *( cBuff + nPointers ) + ( *( cBuff + nPointers + 1 ) << 8 );
	printf( "Sprite frames list %d\n", nAddr );
	nFrmlst = nAddr - nSkip;
	cBuff += 2;

	nAddr = *( cBuff + nPointers ) + ( *( cBuff + nPointers + 1 ) << 8 );
	printf( "Sprite data %d\n", nAddr );
	nSprites = nAddr - nSkip;
	cBuff += 2;

	nAddr = *( cBuff + nPointers ) + ( *( cBuff + nPointers + 1 ) << 8 );
	printf( "Block image data %d\n", nAddr );
	nChgfx = nAddr - nSkip;
	cBuff += 2;

	nAddr = *( cBuff + nPointers ) + ( *( cBuff + nPointers + 1 ) << 8 );
	printf( "Block attribute data %d\n", nAddr );
	nBlkcol = nAddr - nSkip;
	cBuff += 2;

	nAddr = *( cBuff + nPointers ) + ( *( cBuff + nPointers + 1 ) << 8 );
	printf( "Block properties data %d\n", nAddr );
	nBprop = nAddr - nSkip;
	cBuff += 2;

	nAddr = *( cBuff + nPointers ) + ( *( cBuff + nPointers + 1 ) << 8 );
	printf( "Screen layouts %d\n", nAddr );
	nScdat = nAddr - nSkip;
	cBuff += 2;

	nAddr = *( cBuff + nPointers ) + ( *( cBuff + nPointers + 1 ) << 8 );
	printf( "Enemy positions %d\n", nAddr );
	nNmedat = nAddr - nSkip;
	cBuff += 2;

	nAddr = *( cBuff + nPointers ) + ( *( cBuff + nPointers + 1 ) << 8 );
	printf( "AY sound effects %d\n", nAddr );
	nSounds = nAddr - nSkip;
	cBuff += 2;

	nAddr = *( cBuff + nPointers ) + ( *( cBuff + nPointers + 1 ) << 8 );
	printf( "Text %d\n", nAddr );
	nText = nAddr - nSkip;
	cBuff += 2;

	nAddr = *( cBuff + nPointers ) + ( *( cBuff + nPointers + 1 ) << 8 );
	printf( "Objects %d\n", nAddr );
	nObjects = nAddr - nSkip;
	cBuff += 2;

	nAddr = *( cBuff + nPointers ) + ( *( cBuff + nPointers + 1 ) << 8 );
	printf( "Events code %d\n", nAddr );
	nCode = nAddr - nSkip;
	cBuff += 2;

	OutputWindow();
	OutputKeys();
	OutputMessages();
	OutputFont();
	OutputJumpTable();
	OutputBlocks();
	OutputSprites();
	OutputScreens();
	OutputObjects();
	OutputMap();
	OutputCode();
}

void OutputWindow( void )
{
	unsigned char cData[ 16 ];

	NewLine();
	WriteText( "DEFINEWINDOW    " );

	sprintf( cData, "%d %d %d %d", *cTop, *cLeft, *cHeight, *cWidth );
	WriteText( cData );
	NewLine();
}

void OutputKeys( void )
{
	unsigned char cData[ 10 ];
	unsigned char cKeys[ 7 ];
	short int nCount;

	NewLine();
	WriteText( "DEFINECONTROLS " );
	cBuff = cSrc + nControls;

	/* Extract the keyboard controls. */
	cKeys[ 3 ] = *cBuff++;
	cKeys[ 2 ] = *cBuff++;
	cKeys[ 1 ] = *cBuff++;
	cKeys[ 0 ] = *cBuff++;
	for ( nCount = 4; nCount < 7; nCount++ )
	{
		cKeys[ nCount ] = *cBuff++;
	}

	for ( nCount = 0; nCount < 7; nCount++ )
	{
		if ( cKeyTab[ cKeys[ nCount ] ] < 32 )
		{
			sprintf( cData, " %d", cKeyTab[ cKeys[ nCount ] ] );
		}
		else
		{
			sprintf( cData, " '%c'", cKeyTab[ cKeys[ nCount ] ] );
		}
		WriteText( cData );
	}

	NewLine();
}

void OutputMessages( void )
{
	unsigned char cData[ 36 ];
	unsigned char cByte;
	unsigned short int nCount = nObjects - nText;
	unsigned short int nNr = 0;

	NewLine();
	WriteText( "DEFINEMESSAGES" );
	NewLine();
	cBuff = cSrc + nText;

	while ( nCount > 0 )
	{
		sprintf( cData, "; Msg %d", nNr++ );
		WriteComment( cData );
		if (nAddComment > 0) NewLine();
		WriteText( "    \"" );
		while ( *cBuff < 128 )
		{
			cByte = *cBuff++;
			if ( cByte == 34 )				/* quotation marks? */
			{
				fwrite( "'", 1, 1, fpObject );		/* replace double quote with single quote. */
			} else {
				fwrite( &cByte, 1, 1, fpObject );	/* write second set of quotes to file. */
			}
			nCount--;
		}

		cByte = *cBuff++;
		cByte &= 127;
		fwrite( &cByte, 1, 1, fpObject );			/* write output to file. */
		WriteText( "\"" );
		NewLine();
		nCount--;
	}
}

void OutputFont( void )
{
	unsigned char cData[ 40 ];
	short int nCount;
	short int nByte;

	cBuff = cSrc + FONT;

	NewLine();
	nCount = 0;

	while ( nCount < 96 )
	{
		if ( nCount == 0 )
		{
			WriteText( "DEFINEFONT     " );
		}
		else
		{
			WriteText( "               " );
		}

		for ( nByte = 0; nByte < 8; nByte++ )
		{
			sprintf( cData, " %d", *cBuff++ );
			WriteText( cData );
		}

		NewLine();
		nCount++;
	}
}

void OutputJumpTable( void )
{
	unsigned char cData[ 10 ];
	unsigned short int nStart;

//	if ( nVersion < 47 )				// NOT NEEDED for v3.0
//	{
//		nStart = JUMP_TABLE_A;
//	}
//	else
//	{
//		nStart = JUMP_TABLE_B;
//	}

	nStart = JUMP_TABLE;				// VALUE for v3.0
	cBuff = cSrc + nStart;

	NewLine();
	WriteText( "DEFINEJUMP     " );

	while ( *cBuff != 99 )
	{
		sprintf( cData, " %d", *cBuff++ );
		WriteText( cData );
	}

	sprintf( cData, " %d", *cBuff );
	WriteText( cData );
	NewLine();
}

void OutputBlocks( void )
{
	unsigned char *cImg;
	unsigned char *cProp;
	unsigned char *cAttr;
	unsigned char *cText;
	unsigned char cByte;
	unsigned char cData[ 36 ];
	short int nCount = nBprop - nBlkcol;
	short int nNr = 0;
	short int nByte;
	short int nChecksum;
	short int nColour;
	unsigned char cBitmap[ 8 ];
	unsigned char cBlock[][ 14 ] =
	{
		"EMPTYBLOCK",		// empty space.
		"PLATFORMBLOCK",	// platform.
		"WALLBLOCK",		// wall.
		"LADDERBLOCK",		// ladder.
		"FODDERBLOCK",		// fodder.
		"DEADLYBLOCK",		// deadly.
		"CUSTOMBLOCK",		// custom.
		"WATERBLOCK",		// water block.
		"COLLECTABLE"		// collectable.
	};

	cImg = cSrc + nChgfx;
	cProp = cSrc + nBprop;
	cAttr = cSrc + nBlkcol;
	cDefaultAttr = *cAttr;

	NewLine();

	while ( nCount > 0 )
	{
		WriteText( "DEFINEBLOCK     " );
		cByte = *cProp;
//		cText = cBlock[ cByte ];

		if (cByte > 8 )
		{
			cText = cBlock[ 0 ];
		}
		else
		{
			cText = cBlock[ cByte ];
		}

		WriteText( cText );
		NewLine();
		nChecksum =0;
		for ( nByte = 0; nByte < 8; nByte++ )
		{
			cBitmap[ nByte ] = *cImg++;
			nChecksum=nChecksum+cBitmap[ nByte ];
		}

		WriteText( "               " );

		nColour = ( *cAttr >> 3) & 7;
//		printf("\nBlockChecksum: %d, Colour: %d, ", nChecksum, nColour);

		if (nChecksum == 0)
		{
			if ( flagD == 1) {
				WriteText( cYDither[nColour]);
			}  else {
				WriteText( cNDither[nColour]);
			}
		} else {
			for ( nByte = 0; nByte < 8; nByte++ )
			{
				sprintf( cData, " %d", cBitmap[ nByte ] );
				WriteText( cData );
			}

		}
		NewLine();
		sprintf( cData, "                %d", *cAttr );
		WriteText( cData );

		NewLine();
		NewLine();
		nCount--;
		cProp++;
		cAttr++;
	}
}

void OutputSprites( void )
{
	short int nByteMax;
	unsigned char *cImg;
	unsigned char *cFrm;
	unsigned char cByte;
	unsigned char cData[ 50 ];
	unsigned char cBitmap[ 48 ];
	short int nCount = nChgfx - nSprites;
	short int nNr = 0;
	short int nByte;
	short int nFrames;
	short int nGroups;

	cFrm = cSrc + nFrmlst + 1;							/* number of frames. */
	cImg = cSrc + nSprites;								/* sprite image data. */
	NewLine();
	nGroups = ( nSprites - nFrmlst ) / 2;				/* total sprite groups. */
	if ( flagB == 1 )
	{
		nByteMax = 48;
	}
	else
	{
		nByteMax = 32;
	}

	while ( nGroups-- > 0 )
	{
		nFrames = *cFrm;
		sprintf( cData, "; Spritenr %d", nNr++ );
		WriteComment( cData );
//		NewLine();
		sprintf( cData, "DEFINESPRITE    %d", nFrames );
		WriteText( cData );
		NewLine();

		while ( nFrames-- > 0 )
		{
			for ( nByte = 0; nByte < nByteMax; nByte++ )
			{
				cBitmap[ nByte ] = *cImg++;
			}

			WriteText( "               " );

			for ( nByte = 0; nByte < 16; nByte++ )
			{
				sprintf( cData, " %d", cBitmap[ nByte ] );
				WriteText( cData );
			}

			NewLine();
			WriteText( "               " );

			while ( nByte < 32 )
			{
				sprintf( cData, " %d", cBitmap[ nByte++ ] );
				WriteText( cData );
			}

			NewLine();

			if ( flagB == 1 )
			{
				WriteText( "               " );

				while ( nByte < 48 )
				{
					sprintf( cData, " %d", cBitmap[ nByte++ ] );
					WriteText( cData );
				}

				NewLine();
				NewLine();
				nCount -= 192;
				cImg += 144;									/* skip shifted versions. */
			}
			else
			{
				NewLine();
				nCount -= 128;
				cImg += 96;									/* skip shifted versions. */
			}
		}

		cFrm += 2;
	}
}

void OutputScreens( void )
{
	short int nExpand = 0;
	short int nByteToExpand;
	unsigned char *cScrn;
	unsigned char *cNme;
	unsigned char cByte;
	unsigned char cData[ 36 ];
	short int nThisRoom = 0;
	short int nRow;
	short int nCol;
	short int nNr = 0;

	cScrn = cSrc + nScdat + nRooms + nRooms;			/* skip to room data. */
	cNme = cSrc + nNmedat;

	while ( nThisRoom < nRooms )
	{
		nRow = 0;
		nCol = 0;

		while ( nRow < *cHeight )
		{
			nCol = 0;
			NewLine();

			if ( nRow == 0 )
			{
				sprintf( cData, "; Screen nr %d", nNr++ );
				WriteComment( cData );
//				NewLine();
				WriteText( "DEFINESCREEN   " );
			}
			else
			{
				WriteText( "               " );
			}

			while ( nCol++ < *cWidth )
			{
				if ( nExpand > 0 )
				{
					cByte = nByteToExpand;
					nExpand--;
				}
				else
				{
					cByte = *cScrn++;

					if ( cByte == 255 )					/* start of compressed data block. */
					{
						cByte = nByteToExpand = *cScrn++;
						nExpand = *cScrn++;
						if ( nExpand == 0 )				/* 0 indicates 256 bytes to follow. */
						{
							nExpand = 256;
						}
						nExpand--;
					}
				}

				sprintf( cData, " %3d", cByte );
				WriteText( cData );
			}

			nRow++;
		}

		nThisRoom++;
		NewLine();

		cByte = *cNme++;
		while ( cByte != 255 )
		{
			WriteText( "SPRITEPOSITION  " );
			sprintf( cData, "%d", cByte );
			WriteText( cData );
			cByte = *cNme++;
			sprintf( cData, " %d", cByte );
			WriteText( cData );
			cByte = *cNme++;
			sprintf( cData, " %d", cByte );
			WriteText( cData );
			cByte = *cNme++;
			sprintf( cData, " %d", cByte );
			WriteText( cData );
			cByte = *cNme++;
			cByte = *cNme++;						// FIFTH BYTE MUST BE SKIPPED in v3.0
			NewLine();
		}
	}
}

void OutputObjects( void )
{
	unsigned char *cObj;
	short int nCount = nCode - nObjects - 1;			/* ignore marker at end of objects. */
	unsigned char cBitmap[ 32 ];
	unsigned char cData[ 36 ];
	short int nRow;
	short int nByte;
	short int nNr = 0;

	cObj = cSrc + nObjects;								/* point to first object. */
	NewLine();

	while ( nCount > 0 )
	{
		for ( nByte = 0; nByte < 32; nByte++ )
		{
			cBitmap[ nByte ] = *cObj++;
		}

		cObj += 3;
		sprintf( cData, "; Object nr %d", nNr++ );
		WriteComment( cData );
//		NewLine();
		cDefaultAttr = 99;								// DEFAULT VALUE for v3.0
		WriteText( "DEFINEOBJECT    " );
		sprintf( cData, "%d", cDefaultAttr );			/* use default attribute as wasn't supported before. */
		WriteText( cData );
		sprintf( cData, " %d", *cObj++ );				/* room. */
		WriteText( cData );
		sprintf( cData, " %d", *cObj++ );				/* x. */
		WriteText( cData );
		sprintf( cData, " %d", *cObj++ );				/* y. */
		WriteText( cData );
		nCount -= 38;
		NewLine();

		for ( nRow = 0; nRow < 2; nRow++ )
		{
			WriteText( "               " );

			for ( nByte = 0; nByte < 16; nByte++ )
			{
				sprintf( cData, " %d", cBitmap[ nRow * 16 + nByte ] );
				WriteText( cData );
			}

			NewLine();
		}

		NewLine();
	}
}

void OutputMap( void )
{
	unsigned char *cMap;
	unsigned short int nMap = nFrmlst - 101;
	unsigned short int nStart;
	short int nRow, nCol;
	unsigned char cData[ 5 ];
	unsigned char cLoc[ 11 ];
	unsigned short int nRoom;
	short int nFound = 0;
	RECT stMap;

	NewLine();

//	if ( nVersion < 47 )				// NOT NEEDED for v3.0
//	{
//		nStart = START_SCREEN_A;
//	}
//	else
//	{
//		nStart = START_SCREEN_B;
//		nMap=20487;
//	}
		nStart = 0;						// FORCED VALUE for v3.0

	cMap = cSrc + nStart;
	nRoom = *cMap;
	cMap = cSrc + nMap;
	stMap = GetMapEdges( cMap );
	WriteText( "MAP             WIDTH " );
	cMap = cSrc + nMap + nRoom;
	sprintf( cData, "%d", 1 + stMap.right - stMap.left );
	WriteText( cData );
	NewLine();
	WriteText( "                STARTSCREEN " );
//	sprintf( cData, "%d", *cMap );
	sprintf( cData, "%d", 0 );			// START SCREEN for v3.0
	WriteText( cData );
	NewLine();

	cMap = cSrc + nMap;

	for ( nRow = 0; nRow < stMap.top; nRow++ )
	{
		cMap += MAP_WID;
	}

	while ( nRow <= stMap.bottom )
	{
//        WriteText( "                255" );
        WriteText( "                " );
		cMap += stMap.left;

		for ( nCol = stMap.left; nCol <= stMap.right; nCol++ )
		{
			sprintf( cData, " %3d", *cMap++ );
			WriteText( cData );
		}

		cMap += MAP_WID - stMap.right - 1;
//		WriteText( " 255" );
		NewLine();
		nRow++;
	}

	WriteText( "ENDMAP" );
//	NewLine();
}

RECT GetMapEdges( unsigned char *cMap )
{
	RECT edge;
	short int nRow, nCol;

	edge.top = MAP_HGT;
	edge.bottom = 0;
	edge.left = MAP_WID;
	edge.right = 0;

	for ( nRow = 0; nRow < MAP_HGT; nRow++ )
	{
		for ( nCol = 0; nCol < MAP_WID; nCol++ )
		{
			if ( *cMap++ < 255 )
			{
				if ( nRow < edge.top )
				{
					edge.top = nRow;
				}
				if ( nRow > edge.bottom )
				{
					edge.bottom = nRow;
				}
				if ( nCol < edge.left )
				{
					edge.left = nCol;
				}
				if ( nCol > edge.right )
				{
					edge.right = nCol;
				}
			}
		}
	}

	return ( edge );
}

void OutputCode( void )
{
//	short int nEvents = 20;
	short int nEvents = 15;								// VALUE FOR v3.0
	short int nThisEvent = 0;
	unsigned char *cNme;
	unsigned char cByte;
	short int nIndents;
	unsigned char cData[ 5 ];
	unsigned char cDataX[ 100 ];

	NewLine();
	cNme = cSrc + nCode + 1;							/* first byte is always end marker. */

	while ( nEvents-- > 0 )
	{
		cNewLine = 1;
		nIndents = nTabs = 0;
		NewLine();
		NewLine();
		WriteText( "EVENT " );
		WriteText( cEvent[ nThisEvent ] );
		nThisEvent++;
		cByte = *cNme++;
		cByte = ConvertByte( cByte );
		nPrintMode = 0;

		while ( cByte < 255 )
		{
			if ( cNewLine > 0 && cByte != INS_NUMBER )
			{
				nIndents = nTabs;
				cNewLine = 0;
				NewLine();
				nLastOp = -1;

				while ( nIndents-- > 0 )
				{
					WriteText( "    " );
				}

				if ( nPrintMode > 0 )
				{
					nPrintMode = 0;
					WriteText( "PRINTMODE 0" );
					NewLine();
					for ( nIndents = 0; nIndents < nTabs; nIndents++ )
					{
						WriteText( "    " );
					}
				}
			}
			else
			{
				WriteText( " " );
			}

			if ( cByte == INS_NUMBER )
			{
				cByte = *cNme++;
				sprintf( cData, "%d", cByte );
				WriteText( cData );
			}
			else
			{
				CodeLine( cByte, *cNme );
			}

//			if ( cByte == INS_TICKER )					// NOT USED in v3.0
//			{
//				cByte = *cNme++;
//				if ( cByte == INS_NUMBER )
//				{
//					WriteText( " " );
//					cByte = *cNme++;
//					if ( cByte == 99 )					/* TICKER 99 x turned off the ticker. */
//					{
//						WriteText( "0" );				/* it's now TICKER 0. */
//						cByte = *cNme++;				/* there might be a second parameter. */
//						if ( cByte == INS_NUMBER )
//						{
//							cNme++;						/* skip it, it's no longer required. */
//						}
//						else
//						{
//							cNme--;
//						}
//					}
//					else
//					{
//						sprintf( cData, "%d", cByte );
//						WriteText( cData );
//					}
//				}
//				else
//				{
//					cNme--;
//				}
//			}

			if ( cByte == INS_KEY )
			{
				cByte = *cNme++;
				if ( cByte == INS_NUMBER )
				{
					WriteText( " " );
					cByte = *cNme++;
					switch( cByte )						// CHANGED to deal with v3.0
					{
						case 0:
							WriteText( "UP" );			// 00 - CHANGED - was 03 for v4.7
							break;
						case 1:
							WriteText( "DOWN" );		// 01 - CHANGED - was 02 for v4.7
							break;
						case 2:
							WriteText( "LEFT" );		// 02 - CHANGED - was 01 for v4.7
							break;
						case 3:
							WriteText( "RIGHT" );		// 03 - CHANGED - was 00 for v4.7
							break;
						case 4:
							WriteText( "FIRE" );
							break;
						case 5:
							WriteText( "FIRE2" );
							break;
						case 6:
							WriteText( "FIRE3" );
							break;
						default:
							sprintf( cDataX, "%d        ; warning - unrecognised key", cByte );
							WriteText( cDataX );
							break;
					}
				}
				else
				{
					cNme--;
				}
			}

//			if ( cByte == INS_DIG )							// SUBSTITUTED BY THE FOUR DIRECTION CHOICES for v3.0
			if ( cByte == INS_DUP || cByte == INS_DDWN || cByte == INS_DL || cByte == INS_DR )
			{
//				cByte = *cNme++;							// CODE TO DEAL WITH FOUR COMMANDS
//				if ( cByte == INS_NUMBER )					// NOT USED in v3.0
//				{
				if ( ( ConvertByte(*(cNme-2)) != INS_NUMBER )  ||		// if previous byte was NOT an INS_NUMBER flag  then show direction
					 ( ( ConvertByte(*(cNme-2)) == INS_NUMBER )	&&  	// if previous byte was an INS_NUMBER flag (but in fact was a number)
					   ( ConvertByte(*(cNme-3)) == INS_NUMBER )	) )  	// if byte before previous byte was the actual INS_NUMBER flag, show direction
				{
					WriteText( " " );
//					cByte = *cNme++;						// NOT NEEDED in v3.0
					switch( cByte )
					{
						case INS_DUP:
							WriteText( "UP" );
							break;
						case INS_DDWN:
							WriteText( "DOWN" );
							break;
						case INS_DL:
							WriteText( "LEFT" );
							break;
						case INS_DR:
							WriteText( "RIGHT" );
							break;
						default:
							sprintf( cDataX, "%d        ; warning - unrecognised direction", cByte );
							WriteText( cDataX );
							break;
					}
				}
//				}
//				else									// NOT NEEDED in v3.0
//				{
//					cNme--;
//				}
			}

//			if ( cByte == INS_STR )						// STAR NOT USED in v3.0
//			{
//				cByte = *cNme++;
//				if ( cByte == INS_NUMBER )
//				{
//					WriteText( " " );
//					cByte = *cNme++;
//					switch( cByte )						// I asume this part doe not change!
//					{
//						case 0:
//							WriteText( "LEFT" );
//							break;
//						case 1:
//							WriteText( "RIGHT" );
//							break;
//						case 2:
//							WriteText( "UP" );
//							break;
//						case 3:
//							WriteText( "DOWN" );
//							break;
//						default:
//							sprintf( cDataX, "%d        ; warning - unrecognised direction", cByte );
//							WriteText( cDataX );
//							break;
//					}
//				}
//				else
//				{
//					cNme--;
//				}
//			}
			cByte = *cNme++;
			cByte = ConvertByte( cByte );

			switch( cByte )
			{
				case INS_ELSE:
				case INS_ENDIF:
//				case INS_ENDREPEAT:						// NOT USED in v3.0
					nTabs--;
					if ( nTabs < 0 )
					{
						nTabs = 0;
						NewLine();
						WriteText( "; warning - ENDIF without IF?" );
					}
					break;
			}

			if ( ( cByte < INS_ARGUMENTS ) ||
				 ( cByte >= INS_LET ) )
//				 ( cByte >= INS_LET && cByte != INS_BY ) )	// INS_BY NOT USED in v3.0
			{
				cNewLine++;
			}
		}
		NewLine();

		while ( nTabs > 0 )
		{
			nIndents = --nTabs;
			while ( nIndents-- > 0 )
			{
				WriteText( "    " );
			}
			WriteText( "ENDIF        ; warning - missing ENDIF?" );
			NewLine();
		}
	}

	/* write empty routines for new events not present in previous versions. */
	while ( nThisEvent < NUM_EVENTS )
	{
		NewLine();
		NewLine();
		WriteText( "EVENT " );
		WriteText( cEvent[ nThisEvent++ ] );
	}

	NewLine();
}

unsigned char ConvertByte( unsigned char cByte )
{
	/* There were no S and T variables vefore version 4.7 */
	if ( nVersion < 47 )
	{
//		if ( cByte > INS_R && cByte != 255 )		// *** TRICK TO BE REVIEWED ***
		if ( cByte > INS_P && cByte != 255 )
		{
			cByte += 2;
		}
	}

	return ( cByte );
}

void CodeLine( char cInstruction, char cNext )
{
	short int nIndents;

	switch( cInstruction )
	{
		case INS_IF:
			nLastOp = cInstruction;
		case INS_ELSE:
//		case INS_REPEAT:						// NOT USED in v3.0
			nTabs++;
			break;
//		case INS_BIGMESSAGE:					// NOT USED in v3.0
//		case INS_BIGSCORE:						// NOT USED in v3.0
//			nPrintMode++;
//			WriteText( "PRINTMODE 1" );
//			NewLine();
//			for ( nIndents = 0; nIndents < nTabs; nIndents++ )
//			{
//				WriteText( "    " );
//			}
//			break;
		case INS_TO:
			if ( nLastOp == INS_SUB && cInstruction == INS_TO )
			{
				cInstruction = INS_FROM;
			}
			break;
		case INS_LET:
		case INS_SUB:
			nLastOp = cInstruction;
			break;
	}

	WriteText( cKeyword[ cInstruction ] );

	switch( cInstruction )
	{
		case INS_PUT:									/* put now takes two arguments for x and y. */
			WriteText( " X Y" );
			break;
	}
}

void WriteText( unsigned char *cChar )
{
	char cByte;

	while ( *cChar )
	{
		cByte = *cChar++;
		fwrite( &cByte, 1, 1, fpObject );			/* write output to file. */
	}
}

void WriteComment( unsigned char *cChar )
{
	char cByte;

	if (nAddComment > 0)
	{
		while ( *cChar )
		{
			cByte = *cChar++;
			fwrite( &cByte, 1, 1, fpObject );			/* write output to file. */
		}
	}
}

void NewLine( void )
{
	unsigned char cLine[ 2 ] = { CR, LF };

	fwrite( &cLine[ 0 ], 1, 2, fpObject );			/* write output to file. */
}
