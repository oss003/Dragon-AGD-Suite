; ------------------------------------------------------------------------------------------------------------------------------------------
; Game engine code 
; Arcade Game Designer.
; (C) 2008 - 2018 Jonathan Cauldwell.
; ZX Spectrum Engine v0.7.
; v0.U1 - converted to 6809 - Pere Serrat - 2018-08-30	-	free 5248 bytes
; ------------------------------------------------------------------------------------------------------------------------------------------
; Global definitions.																				; Global definitions.
; ------------------------------------------------------------------------------------------------------------------------------------------
																											; SIMASK equ 248					; SPRITEINK mask - allows users to set BRIGHT/FLASH/CLUT as well.
PMODE4 		equ 1
PMODE3 		equ 0
																											; SIMASK equ 248             ; SPRITEINK mask - allows users to set BRIGHT/FLASH/CLUT as well.
sprTab	equ	$dbd9							; dbd9 - 204 bytes=12 sprites x 17 bytes	; sprtab	fcb 204 values $ff
sSprit	equ	$dca5							; dca5 - 17 bytes for spare sprite			; ssprit fcb 17 values
eop		equ	$dcb6							; dcb6 - for adventure mode (768 bytes)
SHRAPN	equ	$dfb6							; dfb6 - uses NUMSHR*SHRSIZ=55*6=330		; SHRAPN equ 63926            ; shrapnel table, just below screen address table.
SCADTB	equ	SHRAPN+330					; e100 - uses 256*2=512 bytes					; SCADTB equ 64256            ; screen address table, just below map.
MAP		equ	SCADTB+512					; e300 - uses 768 bytes							; MAP    equ 64768            ; properties map buffer.
													; 			24 rows 32 chars -> 768
ENDXX		equ	MAP+768						; e600 - *must* be $e600									
; ------------------------------------------------------------------------------------------------------------------------------------------
; Variables put into 1st RAM PAGE to allow for direct addressing mode
; ------------------------------------------------------------------------------------------------------------------------------------------
joyVal	equ	$00							; fcb	$00																					; joyval defb 0              ; joystick reading.
frmNo		equ	$01							; fcb	$00																					; frmno  defb 0              ; selected frame.
loopA		equ	$02							; fcb	$00											; variable counterA				; loopa  equ 23681           ; loop counter system variable.
																											; loopb  equ 23728            ; loop counter system variable.
																											; loopc  equ 23729            ; loop counter system variable.
varA		equ	$05							; fcb	$00											; variable							; vara   defb 0              ; general-purpose variable.
																											; varb   defb 0               ; general-purpose variable.
varC		equ	$07							; fcb	$00											; variable							; varc   defb 0              ; general-purpose variable.
varD		equ	$08							; fcb	$00											; variable							; vard   defb 0              ; general-purpose variable.
varE		equ	$09							; fcb	$00											; variable							; vare   defb 0              ; general-purpose variable.
varF		equ	$0a							; fcb	$00											; variable							; varf   defb 0              ; general-purpose variable.
varG		equ	$0b							; fcb	$00											; variable							; varg   defb 0              ; general-purpose variable.
varH		equ	$0c							; fcb	$00											; variable							; varh   defb 0              ; general-purpose variable.
varI		equ	$0d							; fcb	$00											; variable							; vari   defb 0              ; general-purpose variable.
																											; varj   defb 0               ; general-purpose variable.
varK		equ	$0f							; fcb	$00											; number of crystals				; vark   defb 0              ; general-purpose variable.
varL		equ	$10							; fcb	$00											; variable							; varl   defb 0              ; general-purpose variable.
																											; varm   defb 0               ; general-purpose variable.
																											; varn   defb 0               ; general-purpose variable.
varO		equ	$13							; fcb	$00											; variable							; varo   defb 0              ; general-purpose variable.
varP		equ	$14							; fcb	$00											; variable							; varp   defb 0              ; general-purpose variable.
																											; varq   defb 0               ; general-purpose variable.
																											; varr   defb 0               ; general-purpose variable.
																											; vars   defb 0               ; general-purpose variable.
																											; vart   defb 0               ; general-purpose variable.
																											; varu   defb 0               ; general-purpose variable.
																											; varv   defb 0               ; general-purpose variable.
																											; varw   defb 0               ; general-purpose variable.
																											; varz   defb 0               ; general-purpose variable.
contrl	equ	$1d							; fcb	$00											; control, 0=KBd, 1=JoyStck	; contrl defb 0              ; control, 0 = keyboard, 1 = Kempston, 2 = Sinclair, 3 = Mouse.
charX		equ	$1e							; fcb	$00           								; cursor X position.				; charx  defb 0              ; cursor x position.
charY		equ	$1f							; fcb	$00           								; cursor Y position.				; chary  defb 0              ; cursor y position.
clock		equ	$20							; fcb	$00											; last clock value read			; clock  defb 0              ; last clock reading.

nexLev	equ	$22							; fcb	$00             							; next level flag.				; nexlev defb 0              ; next level flag.
restFl	equ	$23							; fcb	$00             							; restart screen flag			; restfl defb 0              ; restart screen flag.
deadF		equ	$24							; fcb	$00            							; dead flag.						; deadf  defb 0              ; dead flag.
gamWon	equ	$25							; fcb	$00											; game won flag.					; gamwon defb 0              ; game won flag.
dispX		equ	$26							; fcb	$00											; screen X position.				; dispx  defb 0              ; cursor x position.
dispY		equ	$27							; fcb	$00											; screen Y position.				; dispy  defb 0              ; cursor y position.
bWid		equ	$28							; fcb	$00																					; bwid   defb 0              ; box/menu width.
bLen		equ	$29							; fcb	$00																					; blen   defb 0              ; box/menu height.
bTop		equ	$2a							; fcb	$00																					; btop   defb 0              ; box coordinates.
bLft		equ	$2b							; fcb	$00																					; blft   defb 0
sndTyp	equ	$2c							; fcb	$00											; type of sound to be produced; sndtyp defb 0
comByt	equ	$2d							; fcb	$00											; byte type compressed			; combyt defb 0              ; byte type compressed.
comCnt	equ	$2e							; fcb	$00											; compression counter			; comcnt defb 0              ; compression counter.
subUnit	equ	$2f							; fcb	$00											; value to be subtracted
cocoFlg	equ	$30							; fcb	$00											; CoCo machine flag
scanOff	equ	$31							; fcb	$00											; offset to add to pointer while scanning keyboard
prtMod	equ	$32							; fcb	$00											; print mode, 0 = std, 1 = double-height.	; prtmod defb 0            ; print mode, 0 = standard, 1 = double-height.
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
grBase	equ	$50							; fdb	#0000											; graphics (posx, posy)			; grbase defw 15360          ; graphics base address.
pbPtr		equ	$52							; fdb	$0000											; Add a new variable putblock pointer		; pbptr    = $96            
tmp		equ	$54							; fdb	$0000											; used in Adventure mode
andeor	equ	$56							; fdb	$ff00											; values to use in AND - EOR
ogPtr		equ	$58							; fdb	$0000											; pointer to sprite table		; ogptr  defw 0              ; original sprite pointer.
fontPtr	equ	$5a							; fdb	$0000											; pointer to font table - (23606) in ZX-Spectrum
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
reg_AF	equ	$a0							; pseudo AF'($a0-a1)
reg_BC	equ	$a2							; pseudo BC ($a2-a3)
reg_B		equ	reg_BC						; 1st byte of BC
reg_C		equ	reg_BC+1						; 2nd byte of BC
reg_DE	equ   $a4     						; pseudo DE ($a4-a5)
reg_D		equ	reg_DE						; 1st byte of DE
reg_E		equ	reg_DE+1						; 2nd byte of DE
reg_HL	equ	$a6							; pseudo HL ($a6-a7)
reg_H		equ	reg_HL						; 1st byte of HL
reg_L		equ	reg_HL+1						; 2nd byte of HL
reg_IX	equ	$a8							; pseudo IX ($a8-a9)
reg_IY	equ	$aa							; pseudo IY ($aa-ab)
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
esp_BC	equ	$b0							; mirror register for reg_BC ($b0-b1)
esp_DE	equ	$b2							; mirror register for reg_DE ($b2-b3)
esp_HL	equ	$b4							; mirror register for reg_HL ($b4-b5)
; ------------------------------------------------------------------------------------------------------------------------------------------
; Block characteristics.																			; Block characteristics.
; ------------------------------------------------------------------------------------------------------------------------------------------
PLATFM equ 1               				; platform.											; PLATFM equ 1               ; platform.
WALL   equ PLATFM + 1      				; solid wall.										; WALL   equ PLATFM + 1      ; solid wall.
LADDER equ WALL + 1        				; ladder.											; LADDER equ WALL + 1        ; ladder.
FODDER equ LADDER + 1      				; fodder block.									; FODDER equ LADDER + 1      ; fodder block.
DEADLY equ FODDER + 1      				; deadly block.									; DEADLY equ FODDER + 1      ; deadly block.
; CUSTOM equ DEADLY + 1      				; custom block.									; CUSTOM equ DEADLY + 1      ; custom block.
; WATER  equ CUSTOM + 1      				; water block.										; WATER  equ CUSTOM + 1      ; water block.
; COLECT equ WATER + 1       				; collectable block.								; COLECT equ WATER + 1       ; collectable block.
; NUMTYP equ COLECT + 1      				; number of types.								; NUMTYP equ COLECT + 1      ; number of types.
; ------------------------------------------------------------------------------------------------------------------------------------------
; Sprites																								; Sprites.
; ------------------------------------------------------------------------------------------------------------------------------------------
NUMSPR	equ	12              			; number of sprites								; NUMSPR equ 12              ; number of sprites.
TABSIZ	equ	17              			; size of each entry								; TABSIZ equ 17              ; size of each entry.
SPRBUF	equ	NUMSPR * TABSIZ 			; size of entire table							; SPRBUF equ NUMSPR * TABSIZ ; size of entire table.
NMESIZ	equ	4               			; bytes stored in nmetab for each sprite	; NMESIZ equ 4               ; bytes stored in nmetab for each sprite.
Xval		equ	8								; new x coordinate of sprite					; X      equ 8               ; new x coordinate of sprite.
Yval		equ	Xval+1						; new y coordinate of sprite					; Y      equ X + 1           ; new y coordinate of sprite.
PAM1ST	equ	5               			; first sprite parameter, old x (ix+5)		; PAM1ST equ 5               ; first sprite parameter, old x (ix+5).
; ------------------------------------------------------------------------------------------------------------------------------------------
; Particle engine																						; Particle engine.
; ------------------------------------------------------------------------------------------------------------------------------------------
NUMSHR	equ	55								; pieces of shrapnel.							; NUMSHR equ 55              ; pieces of shrapnel.
SHRSIZ	equ	6								; bytes per particle.							; SHRSIZ equ 6               ; bytes per particle.
; ------------------------------------------------------------------------------------------------------------------------------------------
													; Game starts here.  No reason why screen data couldn't go between start and contrl to put them in
													; contended RAM, leaving the code and rest of the game in uncontended memory at 32768 and beyond.
; ------------------------------------------------------------------------------------------------------------------------------------------
			org	$0e00							; make it CoCo compatible						; 		 org 32000
Start		orcc	#$50							; disable interrupts								; start  equ $
			jsr	SwMap1						; go MAP1 to access 64K of RAM
			lds	#$03d6						; set stack to end of Buffer for List		; Set up the font.
			ldx	#font-256					; point to font table (-256)					; 		 ld hl,font-256      ; address of font.
			stx	<fontPtr						; save into variable								; 		 ld (23606),hl       ; set up game font.
			jmp	Game							; start the game									; 		 jp game             ; start the game.
; ------------------------------------------------------------------------------------------------------------------------------------------
																											; Don't change the order of these four.  Menu routine relies on winlft following wintop.
; ------------------------------------------------------------------------------------------------------------------------------------------
winTop	fcb	WINDOWTOP					; top of window									; wintop defb WINDOWTOP      ; top of window.
winLft	fcb	WINDOWLFT					; left edge											; winlft defb WINDOWLFT      ; left edge.
winHgt	fcb	WINDOWHGT					; window height									; winhgt defb WINDOWHGT      ; window height.
winWid	fcb	WINDOWWID					; window width										; winwid defb WINDOWWID      ; window width.
; ------------------------------------------------------------------------------------------------------------------------------------------
numOb		fcb	NUMOBJ         			; number of objects in game.					; numob  defb NUMOBJ         ; number of objects in game.
; ------------------------------------------------------------------------------------------------------------------------------------------
																											; Variables start here.
; ------------------------------------------------------------------------------------------------------------------------------------------
																											; Pixel versions of wintop, winlft, winhgt, winwid.
																											; wntopx defb (8 * WINDOWTOP)
																											; wnlftx defb (8 * WINDOWLFT)
																											; wnbotx defb ((WINDOWTOP * 8) + (WINDOWHGT * 8) - 16)
																											; wnrgtx defb ((WINDOWLFT * 8) + (WINDOWWID * 8) - 16)
scNo		fcb	$00							; present screen number							; scno   defb 0              ; present screen number.
varOpt	fcb	$ff							; last option chosen from menu				; varopt defb 255            ; last option chosen from menu.
numLif	fcb	$03							; number of lives									; numlif defb 3              ; number of lives.
																											; varrnd defb 255            ; last random number.
varObj	fcb	254							; last object number								; varobj defb 254            ; last object number.
																											; varblk defb 255            ; block type.
; ------------------------------------------------------------------------------------------------------------------------------------------
																											; Make sure pointers are arranged in the same order as the data itself.
; ------------------------------------------------------------------------------------------------------------------------------------------
frmPtr	fdb	frmLst         			; sprite frames									; frmptr defw frmlst         ; sprite frames.
blkPtr	fdb	chgFx							; block graphics									; blkptr defw chgfx          ; block graphics.
																											; colptr defw bcol           ; address of char colours.
proPtr	fdb	bProp							; address of char properties					; proptr defw bprop          ; address of char properties.
scrPtr	fdb	scDat							; address of screens								; scrptr defw scdat          ; address of screens.
nmePtr	fdb	nmeDat         			; enemy start positions							; nmeptr defw nmedat         ; enemy start positions.
; ------------------------------------------------------------------------------------------------------------------------------------------
																											; Assorted game routines which can go in contended memory.
; ------------------------------------------------------------------------------------------------------------------------------------------
; Modify for inventory																				; Modify for inventory.
; received message number in regA
; ------------------------------------------------------------------------------------------------------------------------------------------
MInve		ldx	#InvDis						; selfmodify										; minve  ld hl,invdis        ; routine address.
			stx	Mod0+1						; some												; 		 ld (mod0+1),hl      ; set up menu routine.
			stx	Mod2+1						; points												; 		 ld (mod2+1),hl      ; set up count routine.
			ldx	#FOpt							; of													; 		 ld hl,fopt          ; find option from available objects.
			stx	Mod1+1						; program											; 		 ld (mod1+1),hl      ; set up routine.
			bra	DBox							; show data											; 		 jr dbox             ; do menu routine.
; ------------------------------------------------------------------------------------------------------------------------------------------
																											; Modify for menu.
; ------------------------------------------------------------------------------------------------------------------------------------------
													; NEVER CALLED										; mmenu  ld hl,always        ; routine address.
																											; 		 ld (mod0+1),hl      ; set up routine.
																											; 		 ld (mod2+1),hl      ; set up count routine.
																											; 		 ld hl,fstd          ; standard option selection.
																											; 		 ld (mod1+1),hl      ; set up routine.
; ------------------------------------------------------------------------------------------------------------------------------------------
; Drop through into box routine																	; Drop through into box routine.
; Work out size of box for message or menu													; Work out size of box for message or menu.
; ------------------------------------------------------------------------------------------------------------------------------------------
																											; ;dbox   ld hl,nummsg        ; total messages.
																											; ;       cp (hl)             ; does this one exist?
																											; ;       ret nc              ; no, nothing to display.
DBox		ldx	#font-256					; ensure
			stx	<fontPtr						; font access
			ldx	#msgDat						; point to messaqes								; dbox   ld hl,msgdat        ; pointer to messages.
			stx	<reg_HL						; put into pseudoreg
			tfr	a,b							; pass message # to regB
			jsr	GetWrd						; point to text for that message				; 		 call getwrd         ; get message number.
			pshs	x								; save pointer to that message				; 		 push hl             ; store pointer to message.
			ldd	#$0100						; height and max width							; 		 ld d,1              ; height.
			std	<reg_DE						; into pseudoreg									; 		 xor a               ; start at object zero.
			stb	<comByt						; first object (zero)							; 		 ld (combyt),a       ; store number of object in combyt.
																											; 		 ld e,a              ; maximum width.
DBox5		clr	<reg_B						; clear width counter							; dbox5  ld b,0              ; this line's width.
Mod2		jsr	Always						; selfmodified code (calls InvDis)			; mod2   call always         ; item in player's possession?
			bne	DBox6							; not in pocket? skip next						; 		 jr nz,dbox6         ; not in inventory, skip this line.
			inc	<reg_D						; add to list										; 		 inc d               ; add to tally.
DBox6		lda	,x+							; get a char, point to next					; dbox6  ld a,(hl)           ; get character.
																											; 		 inc hl              ; next character.
			cmpa	#','							; is it ','?										; 		 cp ','              ; reached end of line?
			beq	DBox3							; yes, skip section								; 		 jr z,dbox3          ; yes.
			cmpa	#13							; is it enter?										; 		 cp 13               ; reached end of line?
			beq	DBox3							; skip two											; 		 jr z,dbox3          ; yes.
			inc	<reg_B						; increment width counter						; 		 inc b               ; add to this line's width.
			tsta									; test read char									; 		 and a               ; end of message?
			bmi	DBox4							; if end of message, skip section			; 		 jp m,dbox4          ; yes, end count.
			bra	DBox6							; loop for next char								; 		 jr dbox6            ; repeat until we find the end.
DBox3		lda	<reg_E						; get max width									; dbox3  ld a,e              ; maximum line width.
			cmpa	<reg_B						; is current width greater?					; 		 cp b                ; have we exceeded longest so far?
			bcc	DBox5							; no, keep on looking							; 		 jr nc,dbox5         ; no, carry on looking.
			ldb	<reg_B						; update
			stb	<reg_E						; max width											; 		 ld e,b              ; make this the widest so far.
			bra	DBox5							; loop for next item								; 		 jr dbox5            ; keep looking.
DBox4		lda	<reg_E						; get max width									; dbox4  ld a,e              ; maximum line width.
			cmpa	<reg_B						; is curent width greater?						; 		 cp b                ; have we exceeded longest so far?
			bcc	DBox8							; no, skip update									; 		 jr nc,dbox8         ; no, carry on looking.
			ldb	<reg_B						; update
			stb	<reg_E						; max width											; 		 ld e,b              ; final line is the longest so far.
DBox8		dec	<reg_D						; decrement number of items found			; dbox8  dec d               ; decrement items found.
			lbeq	DBox15						; if zero exit										; 		 jp z,dbox15         ; total was zero.
			lda	<reg_E						; get max width									; 		 ld a,e              ; longest line.
																											; 		 and a               ; was it zero?
			lbeq	DBox15						; if zero exit										; 		 jp z,dbox15         ; total was zero.
			ldd	<reg_DE						; get height and width							; 		 ld (bwid),de        ; set up size.
			exg	a,b							; invert positions
			std	<bWid							; update bWid and bLen (height) 
; ------------------------------------------------------------------------------------------------------------------------------------------
; That's set up our box size																		; That's set up our box size.
; ------------------------------------------------------------------------------------------------------------------------------------------
			lda	winHgt						; get window height								; 		 ld a,(winhgt)       ; window height in characters.
			suba	<reg_D						; subtract box height							; 		 sub d               ; subtract height of box.
			rora									; divide by 2										; 		 rra                 ; divide by 2.
			ldx	#winTop						; point to window top edge						; 		 ld hl,wintop        ; top edge of window.
			adda	,x								; add displacement								; 		 add a,(hl)          ; add displacement.
			sta	<bTop							; save as box top									; 		 ld (btop),a         ; set up box top.
			lda	winWid						; get window width								; 		 ld a,(winwid)       ; window width in characters.
			suba	<reg_E						; subtract box width								; 		 sub e               ; subtract box width.
			rora									; divide by 2										; 		 rra                 ; divide by 2.
			leax	1,x							; point to window left edge					; 		 inc hl              ; left edge of window.
			adda	,x								; add displacement								; 		 add a,(hl)          ; add displacement.
			sta	<bLft							; save as box left								; 		 ld (blft),a         ; box left.
																											; 		 ld hl,(23606)       ; font.
																											; 		 ld (grbase),hl      ; set up for text display.
			puls	x								; get pointer to text							; 		 pop hl              ; restore message pointer.
			lda	<bTop							; set box top										; 		 ld a,(btop)         ; box top.
			sta	<dispY							; as Y coordinate									; 		 ld (dispx),a        ; set display coordinate.
																											; 		 xor a               ; start at object zero.
			clr	<comByt						; start at object zero							; 		 ld (combyt),a       ; store number of object in combyt.
DBox2		lda	<comByt						; get object number								; dbox2  ld a,(combyt)       ; get object number.
Mod0		jsr	Always						; selfmodified code (calls InvDis)			; mod0   call always         ; check inventory for display.
			lbne	DBox13						; object not in Inv, go for next one		; 		 jp nz,dbox13        ; not in inventory, skip this line.
; ------------------------------------------------------------------------------------------------------------------------------------------
			lda	<bLft							; get box left										; 		 ld a,(blft)         ; box left.
			sta	<dispX							; set as X coordinate							; 		 ld (dispy),a        ; set left display position.
			lda	<bWid							; get box width									; 		 ld a,(bwid)         ; box width.
			sta	<reg_B						; put in reg_B										; 		 ld b,a              ; store width.
DBox0		lda	,x								; get a char										; dbox0  ld a,(hl)           ; get character.
			cmpa	#','							; is it ','?										; 		 cp ','              ; end of line?
			beq	DBox1							; yes, skip it										; 		 jr z,dbox1          ; yes, next one.
			cmpa	#13							; is it Enter?										; 		 cp 13               ; end of option?
			beq	DBox1							; go for next one									; 		 jr z,dbox1          ; yes, on to next.
			dec	<reg_B						; decrement width counter						; 		 dec b               ; one less to display.
			anda	#127							; remove bit7										; 		 and 127             ; remove terminator.
			ldu	<reg_BC						; get pseudoreg									; 		 push bc             ; store characters remaining.
			pshs	x,u							; push onto stack									; 		 push hl             ; store address on stack.
																											; 		 push af             ; store character.
													; no													; 		 call gaadd          ; get attribute address.
													; colours											; 		 ld a,(23693)        ; current colour.
													; by now												; 		 ld (hl),a           ; set attribute.
																											; 		 pop af              ; restore character.
			jsr	PChr0							; show char as Text (from fonts)				; 		 call pchr           ; display on screen.
			puls	x,u							; restore pointers								; 		 pop hl              ; retrieve address of next character.
			stu	<reg_BC						; into pseudoreg									; 		 pop bc              ; chars left for this line.
			lda	,x+							; get a char, point to next					; 		 ld a,(hl)           ; get character.
																											; 		 inc hl              ; next character.
			cmpa	#128							; is end of message?								; 		 cp 128              ; end of message?
			bcc	DBox7							; yes, exit message printing					; 		 jp nc,dbox7         ; yes, job done.
			lda	<reg_B						; get remaining chars number					; 		 ld a,b              ; chars remaining.
																											; 		 and a               ; are any left?
			bne	DBox0							; not yet done? loopback						; 		 jr nz,dbox0         ; yes, continue.
; ------------------------------------------------------------------------------------------------------------------------------------------
; Reached limit of characters per line															; Reached limit of characters per line.
; ------------------------------------------------------------------------------------------------------------------------------------------
DBox9		lda	,x+							; get a char, point to next					; dbox9  ld a,(hl)           ; get character.
																											; 		 inc hl              ; next one.
			cmpa	#','							; is it ','?										; 		 cp ','              ; another line?
			beq	DBox10						; yes, go next line								; 		 jr z,dbox10         ; yes, do next line.
			cmpa	#13							; is it Enter?										; 		 cp 13               ; another line?
			beq	DBox10						; yes, go next line								; 		 jr z,dbox10         ; yes, on to next.
			cmpa	#128							; is end of message?								; 		 cp 128              ; end of message?
			bcc	DBox11						; yes, finish mesage								; 		 jr nc,dbox11        ; yes, finish message.
			bra	DBox9							; loopback for next char						; 		 jr dbox9
; ------------------------------------------------------------------------------------------------------------------------------------------
; Fill box to end of line																			; Fill box to end of line.
; ------------------------------------------------------------------------------------------------------------------------------------------
DBoxf		ldu	<reg_BC						; get pseudoreg BC								; dboxf  push hl             ; store address on stack.
			pshs	x,u							; push onto stack									; 		 push bc             ; store characters remaining.
																											; 		 call gaadd          ; get attribute address.
																											; 		 ld a,(23693)        ; current colour.
																											; 		 ld (hl),a           ; set attribute.
			lda	#32							; get a 'space char'								; 		 ld a,32             ; space character.
			jsr	PChr0							; Show char											; 		 call pchr           ; display character.
			puls	x,u							; restore pointers								; 		 pop bc              ; retrieve character count.
			stu	<reg_BC						; into peuodreg									; 		 pop hl              ; retrieve address of next character.
			dec	<reg_B						; decrement line chars pending counter
			bne	DBoxf							; not yet done? loopback						; 		 djnz dboxf          ; repeat for remaining chars on line.
			rts									; return												; 		 ret
DBox1		leax	1,x							; skip read char									; dbox1  inc hl              ; skip character.
			jsr	DBoxf							; fill box till end of right side			; 		 call dboxf          ; fill box out to right side.
DBox10																									; dbox10 ld a,(dispx)        ; x coordinate.
																											; 		 inc a               ; down a line.
			inc	<dispY							; increment Y coordinate						; 		 ld (dispx),a        ; next position.
			bra	DBox2							; go for next line								; 		 jp dbox2            ; next line.
DBox7		lda	<reg_B						; get remaining chars							; dbox7  ld a,b              ; chars remaining.
																											; 		 and a               ; are any left?
			beq	DBox11						; already done? skip next						; 		 jr z,dbox11         ; no, nothing to draw.
			jsr	DBoxf							; fill line 										; 		 call dboxf          ; fill message to line.
; ------------------------------------------------------------------------------------------------------------------------------------------
; Drawn the box menu, now select option														; Drawn the box menu, now select option.
; ------------------------------------------------------------------------------------------------------------------------------------------
DBox11	lda	<bTop							; get box top										; dbox11 ld a,(btop)         ; box top.
			sta	<dispY							; put as Y coordinate							; 		 ld (dispx),a        ; set bar position.
DBox14	jsr	JoyKey						; read Joy-Kbd										; dbox14 call joykey         ; get controls.
			anda	#95							; anything pressed?								; 		 and 31              ; anything pressed?
			bne	DBox14						; yes, debounce it								; 		 jr nz,dbox14        ; yes, debounce it.
			jsr	DBar							; draw bar											; 		 call dbar           ; draw bar.
DBox12	jsr	JoyKey						; read Joy-Kbd										; dbox12 call joykey         ; get controls.
			bita	#64							; is 'I' pressed?
			lbne	ReDraw						; yes, exit inventory (do nothing)
			anda	#28							; pressed Up-Down-Fire?							; 		 and 28              ; anything pressed?
			beq	DBox12						; no, wait for order								; 		 jr z,dbox12         ; no, nothing.
			anda	#16							; was it fire?										; 		 and 16              ; fire button pressed?
			beq	1f								; no, verify moves U-D
Mod1		jmp	FStd							; selfmodified code	(calls FOpt = exit)	; mod1   jp nz,fstd          ; yes, job done.
1			jsr	DBar							; delete bar										; 		 call dbar           ; delete bar.
			lda	<joyVal						; get selected choice							; 		 ld a,(joyval)       ; joystick reading.
			anda	#8								; was Up?											; 		 and 8               ; going up?
			bne	DBoxu							; yes, go Up										; 		 jr nz,dboxu         ; yes, go up.
			lda	<dispY							; get bar vertical position					; 		 ld a,(dispx)        ; vertical position of bar.
			inca									; look next one									; 		 inc a               ; look down.
			ldx	#bTop							; point to box top								; 		 ld hl,btop          ; top of box.
			suba	,x								; subtract											; 		 sub (hl)            ; find distance from top.
			leax	-1,x							; point to bLen (height)						; 		 dec hl              ; point to height.
			cmpa	,x								; are we at the end?								; 		 cp (hl)             ; are we at end?
			beq	DBox14						; yes, discard command							; 		 jp z,dbox14         ; yes, go no further.
																											; 		 ld hl,dispx         ; coordinate.
			inc	<dispY							; move bar down									; 		 inc (hl)            ; move bar.
			bra	DBox14						; loopback											; 		 jr dbox14           ; continue.
DBoxu		lda	<dispY							; get bar vertical position					; dboxu  ld a,(dispx)        ; vertical position of bar.
																											; 		 ld hl,btop          ; top of box.
			cmpa	<bTop							; are we at top?									; 		 cp (hl)             ; are we at the top?
			beq	DBox14						; yes, discard command							; 		 jp z,dbox14         ; yes, go no further.
																											; 		 ld hl,dispx         ; coordinate.
			dec	<dispY							; move bar up										; 		 dec (hl)            ; move bar.
			bra	DBox14						; loopback											; 		 jr dbox14           ; continue.
FStd		lda	<dispY							; get bar vertical position					; fstd   ld a,(dispx)        ; bar position.
																											; 		 ld hl,btop          ; top of menu.
			suba	<bTop							; find selected option							; 		 sub (hl)            ; find selected option.
			sta	varOpt						; store into variable							; 		 ld (varopt),a       ; store the option.
			lbra	ReDraw						; redraw screen														; 		 jp redraw           ; redraw the screen.
; ------------------------------------------------------------------------------------------------------------------------------------------
; Option not available.  Skip this line														; Option not available.  Skip this line.
; ------------------------------------------------------------------------------------------------------------------------------------------
DBox13	lda	,x+							; get char, point to next						; dbox13 ld a,(hl)           ; get character.
																											; 		 inc hl              ; next one.
			cmpa	#','							; is it ','?										; 		 cp ','              ; another line?
			lbeq	DBox2							; yes, go for next line							; 		 jp z,dbox2          ; yes, do next line.
			cmpa	#13							; is it Enter?										; 		 cp 13               ; another line?
			lbeq	DBox2							; yes, go for next line							; 		 jp z,dbox2          ; yes, on to next line.
			tsta									; end of message?									; 		 and a               ; end of message?
			bmi	DBox11						; yes, end of message							; 		 jp m,dbox11         ; yes, finish message.
			bra	DBox13						; loop for next char								; 		 jr dbox13
DBox15	puls	x,pc							; restore pointer and return					; dbox15 pop hl              ; pop message pointer from the stack.
																											; 		 ret
; ------------------------------------------------------------------------------------------------------------------------------------------
DBar		lda	<bLft							; get box left										; dbar   ld a,(blft)         ; box left.
			sta	<dispX							; put as X coordinate							; 		 ld (dispy),a        ; set display coordinate.
			jsr	GPrad							; get printing address							; 		 call gprad          ; get printing address.
			ldx	<grBase						; get calculated pointer						; 		 ex de,hl            ; flip into hl register pair.
			stx	<reg_HL						; update pseudoreg
			lda	<bWid							; get box width									; 		 ld a,(bwid)         ; box width.
			sta	<reg_C						; store counter in pseudoreg					; 		 ld c,a              ; loop counter in c.
			ldb	<reg_H						; get screen high address byte
			stb	<reg_D						; put in pseuroreg D								; 		 ld d,h              ; store screen address high byte.
DBar1		ldb	#8								; pixels counter									; dbar1  ld b,8              ; pixel height in b.
DBar0		lda	,x								; get a screen byte								; dbar0  ld a,(hl)           ; get screen byte.
			coma									; reverse all bits								; 		 cpl                 ; reverse all bits.
			sta	,x								; update scrfeen									; 		 ld (hl),a           ; write back to screen.
			leax	32,x							; point to next row down						; 		 inc h               ; next line down.
			decb									; decrement counter
			bne	DBar0							; not zero? loopback								; 		 djnz dbar0          ; draw rest of character.
			stx	<reg_HL						; update pseudoreg HL
			ldb	<reg_D						; restore
			stb	<reg_H						; screen address									; 		 ld h,d              ; rsetore screen address.
			inc	<reg_L						; one char right									; 		 inc l               ; one char right.
			ldx	<reg_HL						; get screen pointer
			dec	<reg_C						; decrement counter								; 		 dec c               ; decrement character counter.
			bne	DBar1							; not done? same for whole line				; 		 jr nz,dbar1         ; repeat for whole line.
			rts									; return												; 		 ret
; ------------------------------------------------------------------------------------------------------------------------------------------
; called from DBox5 - Mod2
; ------------------------------------------------------------------------------------------------------------------------------------------
InvDis	ldu	<reg_DE						; get pseudoreg DE (again)						; invdis push hl             ; store message text pointer.
			pshs	x,u							; push pointers									; 		 push de             ; store de pair for line count.
																											; 		 ld hl,combyt        ; object number.
			lda	<comByt						; get object number								; 		 ld a,(hl)           ; get object number.
			inc	<comByt						; increment it (for next time)				; 		 inc (hl)            ; ready for next one.
			jsr	GotOb							; check we have the object (regA)			; 		 call gotob          ; check if we have object.
			tfr	cc,b							; save result (flags)
			puls	x,u							; restore pointers								; 		 pop de              ; retrieve de pair from stack.
			stu	<reg_DE						; put into pseudoreg								; 		 pop hl              ; retrieve text pointer.
			tfr	b,cc							; set result flags
			rts									; return												; 		 ret
																											; ;always xor a               ; set zero flag.
																											; ;       ret
; ------------------------------------------------------------------------------------------------------------------------------------------
; Find option selected																				; Find option selected.
; ------------------------------------------------------------------------------------------------------------------------------------------
FOpt		lda	<dispY							; get Y coordinate								; fopt   ld a,(dispx)
																											; 		 ld hl,btop          ; top of menu.
			suba	<bTop							; subtract the one for the top element		; 		 sub (hl)            ; find selected option.
			inca									; increment (0->1)								; 		 inc a               ; object 0 needs one iteration, 1 needs 2 and so on.
			sta	<reg_B						; save in reg_B									; 		 ld b,a              ; option selected in b register.
																											; 		 ld hl,combyt        ; object number.
			clr	<comByt						; point to first object							; 		 ld (hl),0           ; set to first item.
FOpt0		ldd	<reg_BC						; get reg_BC
			pshs	d								; save it to stack								; fopt0  push bc             ; store option counter in b register.
			bsr	FObj							; find next object in inventory				; 		 call fobj           ; find next object in inventory.
			puls	d								; restore counter									; 		 pop bc              ; restore option counter.
			std	<reg_BC						; to pseudoreg
			dec	<reg_B						; decrement counter
			bne	FOpt0							; not zero? loopback								; 		 djnz fopt0          ; repeat for relevant steps down the list.
			lda	<comByt						; get option										; 		 ld a,(combyt)       ; get option.
			deca									; decrement											; 		 dec a               ; one less, due to where we increment combyt.
			sta	varOpt						; store in variable (chosen object)			; 		 ld (varopt),a       ; store the option.
			lbra	ReDraw						; redraw screen									; 		 jp redraw           ; redraw the screen.
																											; 
FObj																										; fobj   ld hl,combyt        ; object number.
			lda	<comByt						; get counter										; 		 ld a,(hl)           ; get object number.
			inc	<comByt						; increment it										; 		 inc (hl)            ; ready for next item.
			beq	FOptEx						; if zero, return									; 		 ret z               ; in case we loop back to zero.
			jsr	GotOb							; verify if we hace this object				; 		 call gotob          ; do we have this item?
																											; 		 ret z               ; yes, it's on the list.
																											; 		 jr fobj             ; repeat until we find next item in pockets.
			bne	FObj							; no, next one. Optimizing jumps				; 		 jr fobj             ; repeat until we find next item in pockets.
FOptEx	rts									; return
; ------------------------------------------------------------------------------------------------------------------------------------------
; Wait for keypress.																					; Wait for keypress.
; ------------------------------------------------------------------------------------------------------------------------------------------
PrsKey	bsr	DebKey						; debounce key										; prskey call debkey         ; debounce key.
PrsKey0	jsr	VSync							; synchronice with FS							; prsky0 call vsync          ; vertical synch.
			jsr	ReadK							; read keyboard									; 		 call 654            ; return keyboard state in e.
																											; 		 inc e               ; is it 255?
			beq	PrsKey0						; if no key, loopback							; 		 jr z,prsky0         ; yes, repeat until key pressed.
													; Debounce keypress.																	; Debounce keypress
DebKey	bsr	VSync							; update scrolling, sounds, etc				; debkey call vsync          ; update scrolling, sounds etc.
			jsr	ReadK							; read keyboard									; 		 call 654            ; d=shift, e=key.
																											; 		 inc e               ; is it 255?
			bne	DebKey						; not yet released? loopback					; 		 jr nz,debkey        ; no - loop until key is released.
			rts									; return												; 		 ret
; ------------------------------------------------------------------------------------------------------------------------------------------
; Delay routine																						; Delay routine.
; ------------------------------------------------------------------------------------------------------------------------------------------
Delay		pshs	b								; save counter										; delay  push bc             ; store loop counter.
			jsr	VSync							; wait for FS interrupt							; 		 call vsync          ; wait for interrupt.
			puls	b								; restore counter									; 		 pop bc              ; restore counter.
			decb									; decrement it			
			bne	Delay							; not zero, loopback								; 		 djnz delay          ; repeat.
			rts									; return												; 		 ret
; ------------------------------------------------------------------------------------------------------------------------------------------
; Clear sprite table.																				; Clear sprite table.
; ------------------------------------------------------------------------------------------------------------------------------------------
XSpr		ldx	#sprTab						; point to sprites table						; xspr   ld hl,sprtab        ; sprite table.
			ldb	#SPRBUF+17					; get table length plus spare sprite		; 		 ld b,SPRBUF         ; length of table.
			lda	#255							; value to clean table							; xspr0  ld (hl),255         ; clear one byte.
XSpr0		sta	,x+							; clean one byte									; 		 inc hl              ; move to next byte.
			decb									; decrement counter
			bne	XSpr0							; not yet done? loopback						; 		 djnz xspr0          ; repeat for rest of table.
			rts									; return												; 		 ret
; ------------------------------------------------------------------------------------------------------------------------------------------
;																											; silenc call silen1         ; silence channel 1.
;																											; 		 call silen2         ; silence channel 2.
;																											; 		 call silen3         ; silence channel 3.
;																											; 		 jp plsnd            ; play all channels to switch them off.
; ------------------------------------------------------------------------------------------------------------------------------------------
; Initialise all objects.																			; Initialise all objects.
; ------------------------------------------------------------------------------------------------------------------------------------------
IniOb		ldx	#objDta+36					; point to Object data table					; iniob  ld ix,objdta        ; objects table.
			ldb	numOb							; number of objects								; 		 ld a,(numob)        ; number of objects in the game.
																											; 		 ld b,a              ; loop counter.
																											; 		 ld de,39            ; distance between objects.
IniOb0	lda	,x								; start screen										; iniob0 ld a,(ix+36)        ; start screen.
			sta	-3,x							; set start screen								; 		 ld (ix+33),a        ; set start screen.
			lda	1,x							; get start X										; 		 ld a,(ix+37)        ; find start x.
			sta	-2,x							; set start X										; 		 ld (ix+34),a        ; set start x.
			lda	2,x							; get initial Y									; 		 ld a,(ix+38)        ; get initial y.
			sta	-1,x							; set it												; 		 ld (ix+35),a        ; set y coord.
			leax	39,x							; point to next object							; 		 add ix,de           ; point to next object
			decb									; decrement counter
			bne	IniOb0						; not yet done? loopback						; 		 djnz iniob0         ; repeat.
			rts									; return												; 		 ret
; ------------------------------------------------------------------------------------------------------------------------------------------
; Screen synchronisation.																			; Screen synchronisation.
;  - read joystick/keyboard																		;  - read joystick/keyboard
;  - handle sound																						;  - handle sound
;  - sync framerate with clock																	;  - sync framerate with clock
;  - handle shrapnel																					;  - handle shrapnel
; ------------------------------------------------------------------------------------------------------------------------------------------
VSync		jsr 	JoyKey						; read joystick/keyboard						; vsync  call joykey         ; read joystick/keyboard.
			lda	<sndTyp						; get sound type									; 		 ld a,(sndtyp)       ; sound to play.
			bmi	VSync6						; if negative go play white noise			; 		 and a               ; any sound?
			beq	VSync1						; if none, exit sound section					; 		 jp z,vsync1         ; no.
			sta	<reg_B						; save as outer loop								; 		 ld b,a              ; outer loop.
																											; 		 ld a,(23624)        ; border colour.
																											; 		 rra                 ; put border bits into d0, d1 and d2.
																											; 		 rra
			clra									; get min value for DAC (1st value)			; 		 rra
																											; 		 ld c,a              ; first value to write to speaker.
																											; 		 ld a,b              ; sound.
																											; 		 and a               ; test it.
																											; 		 jp m,vsync6         ; play white noise.
VSync2																									; vsync2 ld a,c            ; get speaker value.
			sta	$ff20							; send to DAC										; 		 out (254),a         ; write to speaker.
			eora	#%11111100					; invert value										; 		 xor 248             ; toggle all except the border bits.
			ldb	<reg_B						; get loop counter								; 		 ld c,a              ; store value for next time.
			stb	<reg_D						; save in reg_D									; 		 ld d,b              ; store loop counter.
VSync3	ldb	$0113							; get current clock								; vsync3 ld hl,clock       ; previous clock setting.
			cmpb	<clock							; compare to previous clock value			; 		 ld a,(23672)        ; current clock setting.
			bne	VSync4						; if not equal exit loop						; 		 cp (hl)             ; subtract last reading.			
			dec	<reg_B						; decrement inner loop							; 		 jp nz,vsync4        ; yes, no more processing please.
			bne	VSync3						; not zero? loopback								; 		 djnz vsync3         ; loop.
			ldb	<reg_D						; get outer loop counter
			stb	<reg_B						; restore in reg_B								; 		 ld b,d              ; restore loop counter.
 			dec	<reg_B						; decrment outer loop
 			bne	VSync2						; not zero? continue sound						; 		 djnz vsync2         ; continue noise.
VSync4	lda	<reg_D						; get last used outer counter					; vsync4 ld a,d            ; where we got to.
VSynca	sta	<sndTyp						; save for next time								; vsynca ld (sndtyp),a     ; remember for next time.
VSync1	lda	$0113							; get actual timer low value					; vsync1 ld a,(23672)      ; clock low.
			rora									; is it odd?										; 		 rra                 ; rotate bit into carry.
			bcc	VSync0						; no, skip next									
			jsr	VSync5						; yes, go for shrapnel							; 		 call c,vsync5       ; time to play sound and do shrapnel/ticker stuff.
																											; 		 ld hl,clock         ; last clock reading.
VSync0	lda	$0113							; get actual timer								; vsync0 ld a,(23672)      ; current clock reading.
			cmpa	<clock							; compare to last read							; 		 cp (hl)             ; are they the same?
			beq	VSync0						; yes, wait until clock changes				; 		 jr z,vsync0         ; yes, wait until clock changes.
			sta	<clock							; update last read value						; 		 ld (hl),a           ; set new clock reading.
			rts									; return												; 		 ret
																											; ;vsync5 call plsnd       ; play sound.
VSync5	jmp	ProShr						; shrapnel and others							; vsync5 jp proshr         ; shrapnel and stuff.
; ------------------------------------------------------------------------------------------------------------------------------------------
; Play white noise.																					; Play white noise.
; ------------------------------------------------------------------------------------------------------------------------------------------
VSync6	pshs	b								; save parameter									; vsync6 ld a,b            ; 128 - 255.
			subb	#127							; convert to positive							; 		 sub 127
																											; 		 ld b,a
																											; 		 ld hl,clock         ; previous clock setting.
VSync7	lda	$0113							; get timer											; vsync7 ld a,r              ; get random speaker value.
			mul									; multiply (random number)						; 		 and 248             ; only retain the speaker/earphone bits.
			ldx	#$8800						; point into Basic ROM							; 		 or c                ; merge with border colour.
			lda	b,x							; get value from offset
			anda	#%11111100					; clear unused 2 low bits
			sta	$ff20							; send to DAC										; 		 out (254),a         ; write to speaker.
			lda	$0113							; get actual timer								; 		 ld a,(23672)        ; current clock setting.
			cmpa	<clock							; same than last one								; 		 cp (hl)             ; subtract last reading.
			bne	VSync8						; no, exit loop									; 		 jp nz,vsync8        ; yes, no more processing please.
			lda	,s								; get parameter again							; 		 ld a,b
			anda	#127							; reset bit 7 (negative)						; 		 and 127
			inca									; increment it										; 		 inc a
VSync9	deca									; decrement it										; vsync9 dec a
			bne	VSync9						; not yet zero? loopback						; 		 jr nz,vsync9        ; loop.
			dec	,s								; decrement parameter in stack
			bne	VSync7						; not yet zero? loopback						; 		 djnz vsync7         ; continue noise.
VSync8	leas	1,s							; clean stack										; vsync8 xor a
			clra									; get value zero (not sound)					
			bra	VSynca						; exit via VSynca									; 		 jr vsynca
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
																											; ;clock  defb 0              ; last clock reading.
; ------------------------------------------------------------------------------------------------------------------------------------------
; Redraw the screen																					; Redraw the screen.
; Remove old copy of all sprites for redraw													; Remove old copy of all sprites for redraw.
; ------------------------------------------------------------------------------------------------------------------------------------------
ReDraw	ldx	<reg_IX						; get pseudo reg
			pshs	x								; push onto stack									; redraw push ix             ; place sprite pointer on stack.
			jsr	DRoom							; Show screen layout (blocks)					; 		 call droom          ; show screen layout.
			jsr	ShwOb							; draw OBjects										; 		 call shwob          ; draw objects.
NumSp0	ldb	#NUMSPR						; sprites to draw									; numsp0 ld b,NUMSPR         ; sprites to draw.
			ldx	#sprTab						; point to sprites data table					; 		 ld ix,sprtab        ; sprite table.
			stx	<reg_IX						; update pseudoreg
ReDrw0	lda	,x								; get old sprite type							; redrw0 ld a,(ix+0)         ; old sprite type.
			inca									; is enabled?										; 		 inc a               ; is it enabled?
			beq	ReDrw1						; no, go for next one							; 		 jr z,redrw1         ; no, find next one.
			lda	3,x							; get Y coordinate								; 		 ld a,(ix+3)         ; sprite x.
			cmpa	#177							; beyond maximum?									; 		 cp 177              ; beyond maximum?
			bcc	ReDrw1						; yes, do not draw								; 		 jr nc,redrw1        ; yes, nothing to draw.
			pshs	b,x							; put registers onto stack						; 		 push bc             ; store sprite counter.
			jsr	SSpriA						; show sprite										; 		 call sspria         ; show single sprite.
			puls	b,x							; restore registers								; 		 pop bc              ; retrieve sprite counter.
ReDrw1																									; redrw1 ld de,TABSIZ        ; distance to next odd/even entry.
			leax	TABSIZ,x						; point to next sprite							; 		 add ix,de           ; next sprite.
			decb									; decrement counter
			bne	ReDrw0						; jnot yet done? go for next one				; 		 djnz redrw0         ; repeat for remaining sprites.
Rpblc1	jsr	DShrp							; redraw Shrapnel									; rpblc1 call dshrp          ; redraw shrapnel.
	IF AFLAG
			jsr	RBloc							; draw blocks for this screen
	ENDIF	
			puls	x								; restore pointer									; 		 pop ix              ; retrieve sprite pointer.
			stx	<reg_IX						; put into pseudoreg
			rts									; return												; 		 ret
; ------------------------------------------------------------------------------------------------------------------------------------------
; Clear screen routine																				; Clear screen routine
; ------------------------------------------------------------------------------------------------------------------------------------------
Cls																										; cls  ld hl,16384         ; screen address.
			clra									; create a 											; 		 ld (hl),l           ; blank first byte.
			clrb									; 16 bits zero										; 		 ld de,16385         ; second byte.
ClsD		ldx	#SCRBEG						; point to beginning of screen
Cls01		std	,x++							; clean 2 bytes									; 		 ld bc,6144          ; bytes to copy.
			cmpx	#SCREND						; end of screen?									; 		 ldir                ; blank them all.
			bcs	Cls01							; no, loopback										; 		 ld a,(23693)        ; fetch attributes.
																											; 		 ld (hl),a           ; set first attribute cell.
																											; 		 ld bc,767           ; number of attributes.
																											; 		 ldir                ; set all attributes.
																											; 		 ld hl,0             ; set hl to origin (0, 0).
																											; 		 ld (charx),hl       ; reset coordinates.
			rts									; return												; 		 ret
; ------------------------------------------------------------------------------------------------------------------------------------------
;																											; Set palette routine and data.
;																											; Palette.
;																											; 48955 = register select port.
;																											; 65339 = data read/write port.
;																											;
;																											; 48955 = write to register:
;																											; d0-d5 : select register sub-group.
;																											; d6-d7 : select register group.
;																											;         00 = sub-group determines entry in palette table.
;																											;         64 = mode select, write d0 to 65339 to toggle mode on/off.
;																											;
;																											; 65339 = data read/write:
;																											; d0-d1 : blue intensity (last bit duplicated so Bb is Bbb)
;																											; d2-d4 : red intensity
;																											; d5-d7 : green intensity
; ------------------------------------------------------------------------------------------------------------------------------------------
; 													NOT NEEDED - palette is static in MC6847
; ------------------------------------------------------------------------------------------------------------------------------------------
;																											; setpal ld bc,48955         ; register select.
;																											; 		 ld a,64             ; mode select.
;																											; 		 out (c),a           ; set ULAplus mode.
;																											; 		 ld b,255            ; data write.
;																											; 		 ld a,1              ; mode on.
;																											; 		 out (c),a           ; switch on ULAplus.
;																											; 		 ld b,64             ; number of palette table entries to write.
;																											; setpa1 ld hl,palett        ; palette we want.
;																											; 		 ld e,0              ; register number.
;																											; setpa0 push bc             ; store counter.
;																											; 		 ld b,191            ; register select.
;																											; 		 ld a,e              ; register number to write.
;																											; 		 out (c),a           ; write to port.
;																											; 		 ld b,255            ; data select.
;																											; 		 ld a,(hl)           ; get colour data from table.
;																											; 		 out (c),a           ; write to port.
;																											; 		 inc e               ; next clut entry.
;																											; 		 inc hl              ; next table entry.
;																											; 		 pop bc              ; restore counter from stack.
;																											; 		 djnz setpa0         ; set rest of palette.
;																											; 		 ret
;																											; endpal equ $
; ------------------------------------------------------------------------------------------------------------------------------------------
													; FOR SHRAPNEL										; fdchk  ld a,(hl)           ; fetch cell.
																											; 		 cp FODDER           ; is it fodder?
																											; 		 ret nz              ; no.
																											; 		 ld (hl),0           ; rewrite block type.
																											; 		 push hl             ; store pointer to block.
																											; 		 ld de,MAP           ; address of map.
																											; 		 and a               ; clear carry flag for subtraction.
																											; 		 sbc hl,de           ; find simple displacement for block.
																											; 		 ld a,l              ; low byte is y coordinate.
																											; 		 and 31              ; column position 0 - 31.
																											; 		 ld (dispy),a        ; set up y position.
																											; 		 add hl,hl           ; multiply displacement by 8.
																											; 		 add hl,hl
																											; 		 add hl,hl
																											; 		 ld a,h              ; x coordinate now in h.
																											; 		 ld (dispx),a        ; set the display coordinate.
																											; 		 xor a               ; block to write.
																											; 		 call pattr          ; write block.
																											; 		 pop hl              ; restore block pointer.
																											; 		 ret
; ------------------------------------------------------------------------------------------------------------------------------------------
; Colour a sprite																						; Colour a sprite.
; ------------------------------------------------------------------------------------------------------------------------------------------
;												; NO sprite painting!!!								; cspr   ld a,(ix+8)         ; look at the vertical first.
;																											; 		 cp 177              ; is it out-of-range?
;																											; 		 ret nc              ; yes, can't colour it.
;																											; 		 rlca                ; divide by 64.
;																											; 		 rlca                ; quicker than 6 rrca operations.
;																											; 		 ld l,a              ; store in e register for now.
;																											; 		 and 3               ; mask to find segment.
;																											; 		 add a,88            ; attributes start at 88*256=22528.
;																											; 		 ld h,a              ; that's our high byte sorted.
;																											; 		 ld a,l              ; vertical/64 - same as vertical*4.
;																											; 		 and 224             ; want a multiple of 32.
;																											; 		 ld l,a              ; vertical element calculated.
;																											; 		 ld a,(ix+9)         ; get horizontal position.
;																											; 		 rra                 ; divide by 8.
;																											; 		 rra
;																											; 		 rra
;																											; 		 and 31              ; want result in range 0-31.
;																											; 		 add a,l             ; add to existing low byte.
;																											; 		 ld l,a              ; that's the low byte done.
;																											; 		 ld de,30            ; distance to next line down.
;																											; 		 ld a,(ix+8)         ; x coordinate.
;																											; cspr2  ld b,3              ; default rows to write.
;																											; 		 and 7               ; does x straddle cells?
;																											; 		 jr nz,cspr0         ; yes, loop counter is good.
;																											; 		 dec b               ; one less row to write.
;																											; cspr0  ld a,(hl)           ; get attributes.
;																											; cspr3  and SIMASK          ; remove ink.
;																											; 		 or c                ; put in the new ink.
;																											; 		 ld (hl),a           ; write back again.
;																											; 		 inc l               ; next cell.
;																											; 		 ld a,(hl)           ; get attributes.
;																											; cspr4  and SIMASK          ; remove ink.
;																											; 		 or c                ; put in the new ink.
;																											; 		 ld (hl),a           ; write back again.
;																											; 		 inc l               ; next cell.
;																											; 		 ld a,(ix+9)         ; y coordinate.
;																											; 		 and 7               ; straddling cells?
;																											; 		 jr z,cspr1          ; no, only 2 wide.
;																											; 		 ld a,(hl)           ; get attributes.
;																											; cspr5  and SIMASK          ; remove ink.
;																											; 		 or c                ; put in the new ink.
;																											; 		 ld (hl),a           ; write back again.
;																											; cspr1  add hl,de           ; next row.
;																											; 		 djnz cspr0
;																											; 		 ret
; ------------------------------------------------------------------------------------------------------------------------------------------
																											; Scrolly text and puzzle variables.
; ------------------------------------------------------------------------------------------------------------------------------------------
																											; txtbit defb 128            ; bit to write.
																											; txtwid defb 16             ; width of ticker message.
																											; txtpos defw msgdat
																											; txtini defw msgdat
																											; txtscr defw 16406
; ------------------------------------------------------------------------------------------------------------------------------------------
																											; Specialist routines.
; Process shrapnel 		(*** UNDER CONSTRUCTION ***)										; Process shrapnel.
; ------------------------------------------------------------------------------------------------------------------------------------------
ProShr																									; proshr ld ix,SHRAPN      ; table.
																											; 		 ld b,NUMSHR         ; shrapnel pieces to process.
																											; 		 ld de,SHRSIZ        ; distance to next.
																											; prosh0 ld a,(ix+0)       ; on/off marker.
																											; 		 rla                 ; check its status.
																											; proshx call nc,prosh1    ; on, so process it.
																											; 		 add ix,de           ; point there.
																											; 		 djnz prosh0         ; round again.
																											; 		 jp scrly
																											; prosh1 push bc           ; store counter.
																											; 		 call plot           ; delete the pixel.
																											; 		 ld a,(ix+0)         ; restore shrapnel type.
																											; 		 ld hl,shrptr        ; shrapnel routine pointers.
																											; 		 call prosh2         ; run the routine.
																											; 		 call chkxy          ; check x and y are good before we redisplay.
																											; 		 pop bc              ; restore counter.
																											; 		 ld de,SHRSIZ        ; distance to next.
			rts									; return												; 		 ret
																											; prosh2 rlca              ; 2 bytes per address.
																											; 		 ld e,a              ; copy to de.
																											; 		 add hl,de           ; point to address of routine.
																											; 		 ld a,(hl)           ; get address low.
																											; 		 inc hl              ; point to second byte.
																											; 		 ld h,(hl)           ; fetch high byte from table.
																											; 		 ld l,a              ; put low byte in l.
																											; 		 jp (hl)             ; jump to routine.
; ------------------------------------------------------------------------------------------------------------------------------------------
																											; shrptr defw laser        ; laser.
																											; 		 defw trail          ; vapour trail.
																											; 		 defw shrap          ; shrapnel from explosion.
																											; 		 defw dotl           ; horizontal starfield left.
																											; 		 defw dotr           ; horizontal starfield right.
																											; 		 defw dotu           ; vertical starfield up.
																											; 		 defw dotd           ; vertical starfield down.
																											; 		 defw ptcusr         ; user particle.
; ------------------------------------------------------------------------------------------------------------------------------------------
																											; Explosion shrapnel.
; ------------------------------------------------------------------------------------------------------------------------------------------
																											; shrap  ld e,(ix+1)         ; get the angle.
																											; 		 ld d,0              ; no high byte.
																											; 		 ld hl,shrsin        ; shrapnel sine table.
																											; 		 add hl,de           ; point to sine.
																											; 		 ld e,(hl)           ; fetch value from table.
																											; 		 inc hl              ; next byte of table.
																											; 		 ld d,(hl)           ; fetch value from table.
																											; 		 inc hl              ; next byte of table.
																											; 		 ld c,(hl)           ; fetch value from table.
																											; 		 inc hl              ; next byte of table.
																											; 		 ld b,(hl)           ; fetch value from table.
																											; 		 ld l,(ix+2)         ; x coordinate in hl.
																											; 		 ld h,(ix+3)
																											; 		 add hl,de           ; add sine.
																											; 		 ld (ix+2),l         ; store new coordinate.
																											; 		 ld (ix+3),h
																											; 		 ld l,(ix+4)         ; y coordinate in hl.
																											; 		 ld h,(ix+5)
																											; 		 add hl,bc           ; add cosine.
																											; 		 ld (ix+4),l         ; store new coordinate.
																											; 		 ld (ix+5),h
																											; 		 ret
																											; dotl   dec (ix+5)          ; move left.
																											; 		 ret
																											; dotr   inc (ix+5)          ; move left.
																											; 		 ret
																											; dotu   dec (ix+3)          ; move up.
																											; 		 ret
																											; dotd   inc (ix+3)          ; move down.
																											; 		 ret
; ------------------------------------------------------------------------------------------------------------------------------------------
																											; Check coordinates are good before redrawing at new position.
; ------------------------------------------------------------------------------------------------------------------------------------------
																											; chkxy  ld hl,wntopx        ; window top.
																											; 		 ld a,(ix+3)         ; fetch shrapnel coordinate.
																											; 		 cp (hl)             ; compare with top window limit.
																											; 		 jr c,kilshr         ; out of window, kill shrapnel.
																											; 		 inc hl              ; left edge.
																											; 		 ld a,(ix+5)         ; fetch shrapnel coordinate.
																											; 		 cp (hl)             ; compare with left window limit.
																											; 		 jr c,kilshr         ; out of window, kill shrapnel.
																											; 		 inc hl              ; point to bottom.
																											; 		 ld a,(hl)           ; fetch window limit.
																											; 		 add a,15            ; add height of sprite.
																											; 		 cp (ix+3)           ; compare with shrapnel x coordinate.
																											; 		 jr c,kilshr         ; off screen, kill shrapnel.
																											; 		 inc hl              ; point to right edge.
																											; 		 ld a,(hl)           ; fetch shrapnel y coordinate.
																											; 		 add a,15            ; add width of sprite.
																											; 		 cp (ix+5)           ; compare with window limit.
																											; 		 jr c,kilshr         ; off screen, kill shrapnel.
; ------------------------------------------------------------------------------------------------------------------------------------------
																											; Drop through.
																											; Display shrapnel.
; ------------------------------------------------------------------------------------------------------------------------------------------
																											; plot   ld l,(ix+3)         ; x integer.
																											; 		 ld h,(ix+5)         ; y integer.
																											; 		 ld (dispx),hl       ; workspace coordinates.
																											; 		 ld a,(ix+0)         ; type.
																											; 		 and a               ; is it a laser?
																											; 		 jr z,plot1          ; yes, draw laser instead.
																											; plot0  ld a,h              ; which pixel within byte do we
																											; 		 and 7               ; want to set first?
																											; 		 ld d,0              ; no high byte.
																											; 		 ld e,a              ; copy to de.
																											; 		 ld hl,dots          ; table of small pixel positions.
																											; 		 add hl,de           ; hl points to values we want to POKE to screen.
																											; 		 ld e,(hl)           ; get value.
																											; 		 call scadd          ; screen address.
																											; 		 ld a,(hl)           ; see what's already there.
																											; 		 xor e               ; merge with pixels.
																											; 		 ld (hl),a           ; put back on screen.
																											; 		 ret
																											; plot1  call scadd          ; screen address.
																											; 		 ld a,(hl)           ; fetch byte there.
																											; 		 cpl                 ; toggle all bits.
																											; 		 ld (hl),a           ; new byte.
																											; 		 ret
																											; kilshr ld (ix+0),128       ; switch off shrapnel.
																											; 		 ret
; ------------------------------------------------------------------------------------------------------------------------------------------
																											; ;explc  defb 0              ; explosion counter.
																											; shrsin defw 0,1024,391,946,724,724,946,391
																											; 		 defw 1024,0,946,65144,724,64811,391,64589
																											; 		 defw 0,64512,65144,64589,64811,64811,64589,65144
																											; 		 defw 64512,0,64589,391,64811,724,65144,946
; ------------------------------------------------------------------------------------------------------------------------------------------
																											; trail  dec (ix+1)          ; time remaining.
																											; 		 jp z,trailk         ; time to switch it off.
																											; 		 call qrand          ; get a random number.
																											; 		 rra                 ; x or y axis?
																											; 		 jr c,trailv         ; use x.
																											; 		 rra                 ; which direction?
																											; 		 jr c,traill         ; go left.
																											; 		 inc (ix+5)          ; go right.
																											; 		 ret
																											; traill dec (ix+5)          ; go left.
																											; 		 ret
																											; trailv rra                 ; which direction?
																											; 		 jr c,trailu         ; go up.
																											; 		 inc (ix+3)          ; go down.
																											; 		 ret
																											; trailu dec (ix+3)          ; go up.
																											; 		 ret
																											; trailk ld (ix+3),200       ; set off-screen to kill vapour trail.
																											; 		 ret
; ------------------------------------------------------------------------------------------------------------------------------------------
																											; laser  ld a,(ix+1)         ; direction.
																											; 		 rra                 ; left or right?
																											; 		 jr nc,laserl        ; move left.
																											; 		 ld b,8              ; distance to travel.
																											; 		 jr laserm           ; move laser.
																											; laserl ld b,248            ; distance to travel.
																											; laserm ld a,(ix+5)         ; y position.
																											; 		 add a,b             ; add distance.
																											; 		 ld (ix+5),a         ; set new y coordinate.
; ------------------------------------------------------------------------------------------------------------------------------------------
																											; Test new block.
; ------------------------------------------------------------------------------------------------------------------------------------------
																											; 		 ld (dispy),a        ; set y for block collision detection purposes.
																											; 		 ld a,(ix+3)         ; get x.
																											; 		 ld (dispx),a        ; set coordinate for collision test.
																											; 		 call tstbl          ; get block type there.
																											; 		 cp WALL             ; is it solid?
																											; 		 jr z,trailk         ; yes, it cannot pass.
																											; 		 cp FODDER           ; is it fodder?
																											; 		 ret nz              ; no, ignore it.
																											; 		 call fdchk          ; remove fodder block.
																											; 		 jr trailk           ; destroy laser.
; ------------------------------------------------------------------------------------------------------------------------------------------
																											; dots   defb 128,64,32,16,8,4,2,1
																											; Plot, preserving de.
; ------------------------------------------------------------------------------------------------------------------------------------------
																											; plotde push de             ; put de on stack.
																											; 		 call plot           ; plot pixel.
																											; 		 pop de              ; restore de from stack.
																											; 		 ret
; ------------------------------------------------------------------------------------------------------------------------------------------
																											; Shoot a laser.
; ------------------------------------------------------------------------------------------------------------------------------------------
																											; shoot  ld c,a              ; store direction in c register.
																											; 		 ld a,(ix+8)         ; x coordinate.
																											; shoot1 add a,7             ; down 7 pixels.
																											; 		 ld l,a              ; puty x coordinate in l.
																											; 		 ld h,(ix+9)         ; y coordinate in h.
																											; 		 push ix             ; store pointer to sprite.
																											; 		 call fpslot         ; find particle slot.
																											; 		 jr nc,vapou2        ; failed, restore ix.
																											; 		 ld (ix+0),0         ; set up a laser.
																											; 		 ld (ix+1),c         ; set the direction.
																											; 		 ld (ix+3),l         ; set x coordinate.
																											; 		 rr c                ; check direction we want.
																											; 		 jr c,shootr         ; shoot right.
																											; 		 ld a,h              ; y position.
																											; ;       dec a               ; left a pixel.
																											; shoot0 and 248             ; align on character boundary.
																											; 		 ld (ix+5),a         ; set y coordinate.
																											; 		 jr vapou0           ; draw first image.
																											; shootr ld a,h              ; y position.
																											; 		 add a,15            ; look right.
																											; 		 jr shoot0           ; align and continue.
; ------------------------------------------------------------------------------------------------------------------------------------------
																											; Create a bit of vapour trail.
; ------------------------------------------------------------------------------------------------------------------------------------------
																											; vapour push ix             ; store pointer to sprite.
																											; 		 ld l,(ix+8)         ; x coordinate.
																											; 		 ld h,(ix+9)         ; y coordinate.
																											; vapou3 ld de,7*256+7       ; mid-point of sprite.
																											; 		 add hl,de           ; point to centre of sprite.
																											; 		 call fpslot         ; find particle slot.
																											; 		 jr c,vapou1         ; no, we can use it.
																											; vapou2 pop ix              ; restore sprite pointer.
																											; 		 ret                 ; out of slots, can't generate anything.
; ------------------------------------------------------------------------------------------------------------------------------------------
																											; vapou1 ld (ix+3),l         ; set up x.
																											; 		 ld (ix+5),h         ; set up y coordinate.
																											; 		 call qrand          ; get quick random number.
																											; 		 and 15              ; random time.
																											; 		 add a,15            ; minimum time on screen.
																											; 		 ld (ix+1),a         ; set time on screen.
																											; 		 ld (ix+0),1         ; define particle as vapour trail.
																											; vapou0 call chkxy          ; plot first position.
																											; 		 jr vapou2
; ------------------------------------------------------------------------------------------------------------------------------------------
																											; Create a user particle.
; ------------------------------------------------------------------------------------------------------------------------------------------
																											; ptusr  ex af,af'           ; store timer.
																											; 		 ld l,(ix+8)         ; x coordinate.
																											; 		 ld h,(ix+9)         ; y coordinate.
																											; 		 ld de,7*256+7       ; mid-point of sprite.
																											; 		 add hl,de           ; point to centre of sprite.
																											; 		 call fpslot         ; find particle slot.
																											; 		 jr c,ptusr1         ; no, we can use it.
																											; 		 ret                 ; out of slots, can't generate anything.
																											; ptusr1 ld (ix+3),l         ; set up x.
																											; 		 ld (ix+5),h         ; set up y coordinate.
																											; 		 ex af,af'           ; restore timer.
																											; 		 ld (ix+1),a         ; set time on screen.
																											; 		 ld (ix+0),7         ; define particle as user particle.
																											; 		 jp chkxy            ; plot first position.
; ------------------------------------------------------------------------------------------------------------------------------------------
																											; Create a vertical or horizontal star.
; ------------------------------------------------------------------------------------------------------------------------------------------
																											; star   push ix             ; store pointer to sprite.
																											; 		 call fpslot         ; find particle slot.
																											; 		 jp c,star7          ; found one we can use.
																											; star0  pop ix              ; restore sprite pointer.
																											; 		 ret                 ; out of slots, can't generate anything.
																											; star7  ld a,c              ; direction.
																											; 		 and 3               ; is it left?
																											; 		 jr z,star1          ; yes, it's horizontal.
																											; 		 dec a               ; is it right?
																											; 		 jr z,star2          ; yes, it's horizontal.
																											; 		 dec a               ; is it up?
																											; 		 jr z,star3          ; yes, it's vertical.
																											; 		 ld a,(wntopx)       ; get edge of screen.
																											; 		 inc a               ; down one pixel.
																											; star8  ld (ix+3),a         ; set x coord.
																											; 		 call qrand          ; get quick random number.
																											; star9  ld (ix+5),a         ; set y position.
																											; 		 ld a,c              ; direction.
																											; 		 and 3               ; zero to three.
																											; 		 add a,3             ; 3 to 6 for starfield.
																											; 		 ld (ix+0),a         ; define particle as star.
																											; 		 call chkxy          ; plot first position.
																											; 		 jp star0
																											; star1  call qrand          ; get quick random number.
																											; 		 ld (ix+3),a         ; set x coord.
																											; 		 ld a,(wnrgtx)       ; get edge of screen.
																											; 		 add a,15            ; add width of sprite minus 1.
																											; 		 jp star9
																											; star2  call qrand          ; get quick random number.
																											; 		 ld (ix+3),a         ; set x coord.
																											; 		 ld a,(wnlftx)       ; get edge of screen.
																											; 		 jp star9
																											; star3  ld a,(wnbotx)       ; get edge of screen.
																											; 		 add a,15            ; height of sprite minus one pixel.
																											; 		 jp star8
; ------------------------------------------------------------------------------------------------------------------------------------------
																											; Find particle slot for lasers or vapour trail.
																											; Can't use alternate accumulator.
; ------------------------------------------------------------------------------------------------------------------------------------------
																											; fpslot ld ix,SHRAPN        ; shrapnel table.
																											; 		 ld de,SHRSIZ        ; size of each particle.
																											; 		 ld b,NUMSHR         ; number of pieces in table.
																											; fpslt0 ld a,(ix+0)         ; get type.
																											; 		 rla                 ; is this slot in use?
																											; 		 ret c               ; no, we can use it.
																											; 		 add ix,de           ; point to more shrapnel.
																											; 		 djnz fpslt0         ; repeat for all shrapnel.
																											; 		 ret                 ; out of slots, can't generate anything.
; ------------------------------------------------------------------------------------------------------------------------------------------
																											; Create an explosion at sprite position.
; ------------------------------------------------------------------------------------------------------------------------------------------
																											; explod ld c,a              ; particles to create.
																											; 		 push ix             ; store pointer to sprite.
																											; 		 ld l,(ix+8)         ; x coordinate.
																											; 		 ld h,(ix+9)         ; y coordinate.
																											; 		 ld ix,SHRAPN        ; shrapnel table.
																											; 		 ld de,SHRSIZ        ; size of each particle.
																											; 		 ld b,NUMSHR         ; number of pieces in table.
																											; expld0 ld a,(ix+0)         ; get type.
																											; 		 rla                 ; is this slot in use?
																											; 		 jr c,expld1         ; no, we can use it.
																											; expld2 add ix,de           ; point to more shrapnel.
																											; 		 djnz expld0         ; repeat for all shrapnel.
																											; expld3 pop ix              ; restore sprite pointer.
																											; 		 ret                 ; out of slots, can't generate any more.
																											; expld1 ld a,c              ; shrapnel counter.
																											; 		 and 15              ; 0 to 15.
																											; 		 add a,l             ; add to x.
																											; 		 ld (ix+3),a         ; x coord.
																											; 		 ld a,(seed3)        ; crap random number.
																											; 		 and 15              ; 0 to 15.
																											; 		 add a,h             ; add to y.
																											; 		 ld (ix+5),a         ; y coord.
																											; 		 ld (ix+0),2         ; switch it on.
																											; 		 exx                 ; store coordinates.
																											; 		 call chkxy          ; plot first position.
																											; 		 call qrand          ; quick random angle.
																											; 		 and 60              ; keep within range.
																											; 		 ld (ix+1),a         ; angle.
																											; 		 exx                 ; restore coordinates.
																											; 		 dec c               ; one less piece of shrapnel to generate.
																											; 		 jr nz,expld2        ; back to main explosion loop.
																											; 		 jr expld3           ; restore sprite pointer and exit.
																											; qrand  ld a,(seed3)        ; random seed.
																											; 		 ld l,a              ; low byte.
																											; 		 ld h,0              ; no high byte.
																											; 		 ld a,r              ; r register.
																											; 		 xor (hl)            ; combine with seed.
																											; 		 ld (seed3),a        ; new seed.
																											; 		 ret
																											; seed3  defb 0
; ------------------------------------------------------------------------------------------------------------------------------------------
																											; Display all shrapnel.
; ------------------------------------------------------------------------------------------------------------------------------------------
DShrp																										; dshrp  ld hl,plotde        ; display routine.
																											; 		 ld (proshx+1),hl    ; modify routine.
																											; 		 call proshr         ; process shrapnel.
																											; 		 ld hl,prosh1        ; processing routine.
																											; 		 ld (proshx+1),hl    ; modify the call.
			rts																							; 		 ret
; ------------------------------------------------------------------------------------------------------------------------------------------
; Particle engine																						; Particle engine
; ------------------------------------------------------------------------------------------------------------------------------------------
IniShr	ldx	#SHRAPN						; point to shrapnel table						; inishr ld hl,SHRAPN        ; table.
			ldb	#NUMSHR						; get number of pieces							; 		 ld b,NUMSHR         ; shrapnel pieces to process.
			lda	#$ff							; value to be set									; 		 ld de,SHRSIZ        ; distance to next.
IniSh0	sta	,x								; set one element									; inish0 ld (hl),255         ; kill the shrapnel.
			leax	SHRSIZ,x						; point to next element							; 		 add hl,de           ; point there.
			decb									; decrement counter	
			bne	IniSh0						; not yet done, loop								; 		 djnz inish0         ; round again.
			rts									; return												; 		 ret
; ------------------------------------------------------------------------------------------------------------------------------------------
																											; Check for collision between laser and sprite.
; ------------------------------------------------------------------------------------------------------------------------------------------
																											; lcol   ld hl,SHRAPN        ; shrapnel table.
																											; 		 ld de,SHRSIZ        ; size of each particle.
																											; 		 ld b,NUMSHR         ; number of pieces in table.
																											; lcol0  ld a,(hl)           ; get type.
																											; 		 and a               ; is this slot a laser?
																											; 		 jr z,lcol1          ; yes, check collision.
																											; lcol3  add hl,de           ; point to more shrapnel.
																											; 		 djnz lcol0          ; repeat for all shrapnel.
																											; 		 ret                 ; no collision, carry not set.
																											; lcol1  push hl             ; store pointer to laser.
																											; 		 inc hl              ; direction.
																											; 		 inc hl              ; not used.
																											; 		 inc hl              ; x position.
																											; 		 ld a,(hl)           ; get x.
																											; 		 sub (ix+X)          ; subtract sprite x.
																											; lcolh  cp 16               ; within range?
																											; 		 jr nc,lcol2         ; no, missed.
																											; 		 inc hl              ; not used.
																											; 		 inc hl              ; y position.
																											; 		 ld a,(hl)           ; get y.
																											; 		 sub (ix+Y)          ; subtract sprite y.
																											; 		 cp 16               ; within range?
																											; 		 jr c,lcol4          ; yes, collision occurred.
																											; lcol2  pop hl              ; restore laser pointer from stack.
																											; 		 jr lcol3
																											; lcol4  pop hl              ; restore laser pointer.
																											; 		 ret                 ; return with carry set for collision.
; ------------------------------------------------------------------------------------------------------------------------------------------
; Main game engine code starts here																; Main game engine code starts here
; ------------------------------------------------------------------------------------------------------------------------------------------
Game																										; game   equ $
																											; Set up screen address table.
Setsat	ldx	#SCRBEG						; get screen beginning							; setsat ld hl,16384       ; start of screen.
			ldu	#SCADTB						; point to table									; 		 ld de,SCADTB        ; screen address table.
			clr	,-s							; number of entries (256)						; 		 ld b,0              ; vertical lines on screen.
Setsa0	tfr	x,d							; pass address to regD							; setsa0 ex de,hl          ; flip table and screen address.
			sta	,u+							; write high byte entry, inc pointer		; 		 ld (hl),d           ; write high byte.
			stb	255,u							; write low byte entry							; 		 inc h               ; second table.
																											; 		 ld (hl),e           ; write low byte.
																											; 		 dec h               ; back to first table.
			stx	<reg_HL						; save old address								; 		 inc l               ; next position in table.
			jsr	NLine							; 1st byte next screen row						; 		 ex de,hl            ; flip table and screen address back again.
			ldx	<reg_HL						; get new address									; 		 call nline          ; next line down.
			dec	,s								; decrement counter
			bne	Setsa0						; not yet done? loopback						; 		 djnz setsa0         ; repeat for all lines.
			leas	1,s
			jsr	SetPMode						; set desired PMode								; Init graphics mode
													; not needed for 6847							; 		 call setpal         ; set up ULAplus palette.
			jsr	CfgHdw						; config Sound and Interrupts
			jsr	IniShr						; initialise particle engine					; rpblc2 call inishr       ; initialise particle engine.
			jsr	Evnt12						; call intro/menu event							; evintr call evnt12       ; call intro/menu event.
			ldx	#MAP							; point to MAP										; 		 ld hl,MAP           ; block properties.
			lda	#WALL							; get value for WALL								; 		 ld de,MAP+1         ; next byte.
FillMap1	sta	,x+							; put into MAP										; 		 ld bc,767           ; size of property map.
			cmpx	#ENDXX						; filled all MAP?									; 		 ld (hl),WALL        ; write default property.
			blo	FillMap1						; no, loopback										; 		 ldir
			jsr	IniOb							; initialize objects								; 		 call iniob          ; initialise objects.
																											; 		 xor a               ; put zero in accumulator.
			clr	<gamWon						; reset game won flag							; 		 ld (gamwon),a       ; reset game won flag.
			ldx	#score						; point to score									; 		 ld hl,score         ; score.
			jsr	IniSc							; init the score									; 		 call inisc          ; init the score.
MapSt		lda	stMap							; get position on map							; mapst  ld a,(stmap)      ; start position on map.
			sta	roomTb						; put into table									; 		 ld (roomtb),a       ; set up position in table, if there is one.
IniPbl	
	IF AFLAG																								; .if aflag
			ldd	#eop            			; reset blockpointer								; lda #<eop        
			std	<pbPtr   						; put at write pointer							; sta pbptr
						    																				; lda #>eop
							  																				; sta pbptr+1
	ENDIF																									; .endif
			jsr	InitSc						; setup 1st screen number						; inipbl call initsc       ; set up first screen.
			ldx	#sSprit						; point to spare sprite							; 		 ld ix,ssprit        ; default to spare sprite in table.
EvIni		jsr	Evnt13						; Initialisation									; evini  call evnt13       ; initialisation.
; ------------------------------------------------------------------------------------------------------------------------------------------
; Two restarts																							; Two restarts.
; First restart - clear all sprites and initialise everything							; First restart - clear all sprites and initialise everything.
; ------------------------------------------------------------------------------------------------------------------------------------------
RstRt		jsr	RsEvt							; restart events									; rstrt  call rsevt        ; restart events.
			jsr	XSpr							; clear sprite table								; 		 call xspr           ; clear sprite table.
			jsr	SprLst						; fetch pointer to screen sprites			; 		 call sprlst         ; fetch pointer to screen sprites.
			jsr	ISpr							; initialise sprite table						; 		 call ispr           ; initialise sprite table.
			bra	RstRt0						; setup player and sprites						; 		 jr rstrt0
; ------------------------------------------------------------------------------------------------------------------------------------------
																											; Second restart - clear all but player, and don't initialise him.
; ------------------------------------------------------------------------------------------------------------------------------------------
RstRtn	jsr	RsEvt							; restart events									; rstrtn call rsevt        ; restart events.
			jsr	NSpr							; clear all non-player sprites				; 		 call nspr           ; clear all non-player sprites.
			jsr	SprLst						; fetch pointer to screen sprites			; 		 call sprlst         ; fetch pointer to screen sprites.
			jsr	KSpr							; initialise sprite table, no more players; 		 call kspr           ; initialise sprite table, no more players.
; ------------------------------------------------------------------------------------------------------------------------------------------
; Set up the player and/or enemy sprites														; Set up the player and/or enemy sprites.
; ------------------------------------------------------------------------------------------------------------------------------------------
RstRt0	clra									; value zero										; rstrt0 xor a             ; zero in accumulator.
			sta	<nexLev						; reset next level flag							; 		 ld (nexlev),a       ; reset next level flag.
			sta	<restFl						; reset restart flag								; 		 ld (restfl),a       ; reset restart flag.
			sta	<deadF							; reset dead flag									; 		 ld (deadf),a        ; reset dead flag.
			jsr	DRoom							; show screen layout								; 		 call droom          ; show screen layout.
RpBlc0	
	IF PFLAG																								; .if pflag
			jsr	IniShr						; initialise particle engine					; rpblc0 call inishr       ; initialise particle engine.
	ENDIF																									; .endif
	IF AFLAG																								; .if aflag
			jsr	RBloc         				; draw blocks for this screen					; jsr rbloc        
	ENDIF																									; .endif
			jsr	ShwOb							; show Objects										; 		 call shwob          ; draw objects.
																											; 		 ld ix,sprtab        ; address of sprite table, even sprites.
																											; 		 call dspr           ; display sprites.
																											; 		 ld ix,sprtab+TABSIZ ; address of first odd sprite.
																											; 		 call dspr           ; display sprites.
; ------------------------------------------------------------------------------------------------------------------------------------------
MLoop		jsr	VSync							; synchronize with display						; mloop  call vsync        ; synchronise with display.
			ldx	#sprTab						; point to sprites Table						; 		 ld ix,sprtab        ; address of sprite table, even sprites.
			jsr	DSpr							; show sprites (even ones)						; 		 call dspr           ; display even sprites.
																											; ;       call plsnd       ; play sounds.
			jsr	VSync							; synchronize with display						; 		 call vsync          ; synchronise with display.
			ldx	#sprTab+TABSIZ				; point to first odd sprite					; 		 ld ix,sprtab+TABSIZ ; address of first odd sprite.
			jsr	DSpr							; show sprites (odd ones)						; 		 call dspr           ; display odd sprites.
			ldx	#sSprit																				; 		 ld ix,ssprit        ; point to spare sprite for spawning purposes.
			stx	<reg_IX
EvLp1		jsr	Evnt10						; call event10										; evlp1  call evnt10       ; called once per main loop.
			jsr	PSpr							; process sprites									; 		 call pspr           ; process sprites.

; ------------------------------------------------------------------------------------------------------------------------------------------
; Main loop events																					; Main loop events.
; ------------------------------------------------------------------------------------------------------------------------------------------
			ldy	#sSprit						; point to spare sprite data					; 		 ld ix,ssprit        ; point to spare sprite for spawning purposes.
EvLp2		jsr	Evnt11						; process event 11								; evlp2  call evnt11       ; called once per main loop.
BSortx	jsr	BSort							; re-order sprites								; bsortx call bsort        ; sort sprites.
			lda	<nexLev						; next level flag?								; 		 ld a,(nexlev)       ; finished level flag.
																											; 		 and a               ; has it been set?
			bne	NewLev						; yes, go to next	one							; 		 jr nz,newlev        ; yes, go to next level.
			lda	<gamWon						; game finished?									; 		 ld a,(gamwon)       ; finished game flag.
																											; 		 and a               ; has it been set?
			bne	EvWon							; yes, end game									; 		 jr nz,evwon         ; yes, finish the game.
			lda	<restFl						; restart flag?									; 		 ld a,(restfl)       ; finished level flag.
			deca									; was it set (=1)?								; 		 dec a               ; has it been set?
			beq	RstRt							; yes, restart										; 		 jr z,rstrt          ; yes, go to next level.
			deca									; was restart =2?									; 		 dec a               ; has it been set?
			beq	RstRtn						; yes, do this restart							; 		 jr z,rstrtn         ; yes, go to next level.
			lda	<deadF							; dead flag?										; 		 ld a,(deadf)        ; dead flag.
																											; 		 and a               ; is it non-zero?
			bne	PDead							; yes, go player dead							; 		 jr nz,pdead         ; yes, player dead.
																											; 		 ld hl,frmno         ; game frame.
			inc	<frmNo							; increment frame number						; 		 inc (hl)            ; advance the frame.
; ------------------------------------------------------------------------------------------------------------------------------------------
; Back to start of main loop																		; Back to start of main loop.
; ------------------------------------------------------------------------------------------------------------------------------------------
			lda	<joyVal						; get last user command
			bita	#32							; was it 'Z'? (A chance to exit game)
			lbne	ExitGame						; yes, exit game
; ------------------------------------------------------------------------------------------------------------------------------------------
			inc	<clock							; increment clock									; inc clock
			bra	MLoop							; loopback											; qoff   jp mloop          ; switched to a jp nz,mloop during test mode.
																											; 		 ret
; ------------------------------------------------------------------------------------------------------------------------------------------
	IF AFLAG																								; .if aflag
RBloc																										; rbloc:
			ldd	#eop							; reset temp blockpointer    					; lda #<eop        ; reset temp blockpointer
			std	<tmp    						; store in tmp pointer (reset it)			; sta tmp
																											; lda #>eop
																											; sta tmp+1
RBloc2																									; rbloc2:
			ldd	<tmp							; get last block 									; lda tmp            ; check for last block
			cmpd 	<pbPtr							; compare to write pointer						; cmp pbptr
			bne	RBloc1						; not equal? process it							; bne rbloc1
																											; lda tmp+1
																											; cmp pbptr+1
																											; bne rbloc1
			rts									; return												; rts
RBloc1											; READ BLOCK										; rbloc1:
			ldx	<tmp							; get pointer										; ldy #0
			lda	,x								; get block room number			    			; lda (tmp),y        ; check if block for this scno
			cmpa	scNo							; matches current room?							; cmp scno
			bne	RBloc0						; not, skip											; bne rbloc0        ; if not, skip
																											; iny
			lda	1,x							; get y												; lda (tmp),y        ; get y
			sta	<dispY							; put into variable								; sta dispy
				    																						; iny
			lda	2,x							; get x												; lda (tmp),y        ; get x
			sta	<dispX							; put into variable								; sta dispx
																											; iny
			lda	3,x							; get blocknr										; lda (tmp),y        ; get blocknr
			jsr	PAttr2						; draw block (uses regX)						; jsr pattr2        ; draw block
RBloc0																									; rbloc0:
																				    						; clc            ; point to next block
			ldd	<tmp							; get pointer										; lda tmp
			addd	#4								; point to next block entry					; adc #4
																											; sta tmp
																											; bcc rbloc2zzz
			std	<tmp							; update pointer									; inc tmp+1
			bra	RBloc2						; loopback											; jmp rbloc2
	ENDIF																									; .endif
; ------------------------------------------------------------------------------------------------------------------------------------------
NewLev	lda	scNo																					; newlev ld a,(scno)       ; current screen.
																											; 		 ld hl,numsc         ; total number of screens.
			inca																							; 		 inc a               ; next screen.
			cmpa	numSc																					; 		 cp (hl)             ; reached the limit?
			bcc	EvWon																					; 		 jr nc,evwon         ; yes, game finished.
			sta	scNo																					; 		 ld (scno),a         ; set new level number.
			lbra	RstRt																					; 		 jp rstrt            ; restart, clearing all aliens.
EvWon		jsr	Evnt18																				; evwon  call evnt18       ; game completed.
			bra	TidyUp																				; 		 jp tidyup           ; tidy up and return to BASIC/calling routine.
; ------------------------------------------------------------------------------------------------------------------------------------------
																											; Player dead.
; ------------------------------------------------------------------------------------------------------------------------------------------
PDead		ldy	<reg_IX																				; pdead  xor a             ; zeroise accumulator.
			clr	<deadF																					; 		 ld (deadf),a        ; reset dead flag.
EvDie		jsr	Evnt16																				; evdie  call evnt16       ; death subroutine.
			lda	numLif																				; 		 ld a,(numlif)       ; number of lives.
																											; 		 and a               ; reached zero yet?
			lbne	RstRt																					; 		 jp nz,rstrt         ; restart game.
EvFail	jsr	Evnt17																				; evfail call evnt17         ; failure event.
TidyUp	ldx	#hiScor																				; tidyup ld hl,hiscor        ; high score.
			ldu	#score																				; 		 ld de,score         ; player's score.
			ldb	#6																						; 		 ld b,6              ; digits to check.
TidyU2	lda	,u+																					; tidyu2 ld a,(de)           ; get score digit.
			cmpa	,x+																					; 		 cp (hl)             ; are we larger than high score digit?
			bcs	TidyU0																				; 		 jr c,tidyu0         ; high score is bigger.
			bne	TidyU1																				; 		 jr nz,tidyu1        ; score is greater, record new high score.
																											; 		 inc hl              ; next digit of high score.
			decb																							; 		 inc de              ; next digit of score.
			bne	TidyU2																				; 		 djnz tidyu2         ; repeat for all digits.
TidyU0																									; tidyu0 ld hl,10072         ; BASIC likes this in alternate hl.
																											; 		 exx                 ; flip hl into alternate registers.
																											; 		 ld bc,score         ; return pointing to score.
			jmp	ExitGame																				; 		 ret
TidyU1	ldx	#score																				; tidyu1 ld hl,score         ; score.
			ldu	#hiScor																				; 		 ld de,hiscor        ; high score.
			ldb	#6																						; 		 ld bc,6             ; digits to copy.
1			lda	,x+
			sta	,u+
			decb
			bne	1b																						; 		 ldir                ; copy score to high score.
EvNewH	jsr	Evnt19																				; evnewh call evnt19         ; new high score event.
			bra	TidyU0																				; 		 jr tidyu0           ; tidy up.
; ------------------------------------------------------------------------------------------------------------------------------------------
; Restart event																						; Restart event.
; ------------------------------------------------------------------------------------------------------------------------------------------
RsEvt		ldx	#sSprit						; point to spare sprite							; rsevt  ld ix,ssprit        ; default to spare element in table.
Evrs		jmp	Evnt14						; there is an RTS all alone					; evrs   jp evnt14           ; call restart event.
; ------------------------------------------------------------------------------------------------------------------------------------------
; Copy number passed in a to string position bc, right-justified.						; Copy number passed in a to string position bc, right-justified.
; regU contains the pointer to the destination string
; regA contains the number to convert
; ------------------------------------------------------------------------------------------------------------------------------------------
Num2Ch	ldb	#100							; do hundreds										; num2ch ld l,a              ; put accumulator in l.
			stb	<subUnit						; save into variable								; 		 ld h,0              ; blank high byte of hl.
			ldb	#32							; for leading spaces								; 		 ld a,32             ; leading spaces.
																											; numdg3 ld de,100           ; hundreds column.
			bsr	NumDg							; calculate digit for hundreds				; 		 call numdg          ; show digit.
			stb	<reg_B						; save regB
NumDg2	ldb	#10							; do tens											; numdg2 ld de,10            ; tens column.
			stb	<subUnit						; save into variable
			ldb	<reg_B						; restore regB
			bsr	NumDg							; calculate digit for tens						; 		 call numdg          ; show digit.
			orb	#16							; to force last digit to be shown			; 		 or 16               ; last digit is always shown.
			stb	<reg_B						; save regB
			ldb	#1								; do units											; 		 ld de,1             ; units column.
			stb	<subUnit						; save into variable
			ldb	<reg_B						; restore regB
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
NumDg		andb	#48							; clear carry and previous digit				; numdg  and 48              ; clear carry, clear digit.
NumDg1	suba	<subUnit						; subtract unit (100,10,1)						; numdg1 sbc hl,de           ; subtract from column.
			bcs	NumDg0						; if negative, exit loop						; 		 jr c,numdg0         ; nothing to show.
			orb	#16							; convert to ASCII digit						; 		 or 16               ; something to show, make it a digit.
			incb									; increment digit									; 		 inc a               ; increment digit.
			bra	NumDg1						; loopback											; 		 jr numdg1           ; repeat until column is zero.
NumDg0	adda	<subUnit						; covert to positive again						; numdg0 add hl,de           ; restore total.
			cmpb	#32							; was char equal to space?						; 		 cp 32               ; leading space?
			beq	NumDEx						; yes, exit											; 		 ret z               ; yes, don't write that.
			stb	,u+							; no, save digit, advance pointer			; 		 ld (bc),a           ; write digit to buffer.
																											; 		 inc bc              ; next buffer position.
NumDEx	rts									; return												; 		 ret
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
																											; num2dd ld l,a              ; put accumulator in l.
																											; 		 ld h,0              ; blank high byte of hl.
																											; 		 ld a,32             ; leading spaces.
																											; 		 ld de,100           ; hundreds column.
																											; 		 call numdg          ; show digit.
																											; 		 or 16               ; second digit is always shown.
																											; 		 jr numdg2
																											; num2td ld l,a              ; put accumulator in l.
																											; 		 ld h,0              ; blank high byte of hl.
																											; 		 ld a,48             ; leading spaces.
																											; 		 jr numdg3
; ------------------------------------------------------------------------------------------------------------------------------------------
IniSc		ldd	#'0'*256+6					; '0' char and numbytes to write				; inisc  ld b,6              ; digits to initialise.
IniSc0	sta	,x+							; put one											; inisc0 ld (hl),'0'         ; write zero digit.
			decb									; decrement counter								; 		 inc hl              ; next column.
			bne	IniSc0						; if not done, loop								; 		 djnz inisc0         ; repeat for all digits.
			rts									; return												; 		 ret
; ------------------------------------------------------------------------------------------------------------------------------------------
																											; Multiply h by d and return in hl.
; ------------------------------------------------------------------------------------------------------------------------------------------
																											; imul   ld e,d              ; HL = H * D
																											; 		 ld c,h              ; make c first multiplier.
																											; imul0  ld hl,0             ; zeroise total.
																											; 		 ld d,h              ; zeroise high byte.
																											; 		 ld b,8              ; repeat 8 times.
																											; imul1  rr c                ; rotate rightmost bit into carry.
																											; 		 jr nc,imul2         ; wasn't set.
																											; 		 add hl,de           ; bit was set, so add de.
																											; 		 and a               ; reset carry.
																											; imul2  rl e                ; shift de 1 bit left.
																											; 		 rl d
																											; 		 djnz imul1          ; repeat 8 times.
																											; 		 ret
; ------------------------------------------------------------------------------------------------------------------------------------------
																											; Divide d by e and return in d, remainder in a.
; ------------------------------------------------------------------------------------------------------------------------------------------
																											; idiv   xor a
																											; 		 ld b,8              ; bits to shift.
																											; idiv0  sla d               ; multiply d by 2.
																											; 		 rla                 ; shift carry into remainder.
																											; 		 cp e                ; test if e is smaller.
																											; 		 jr c,idiv1          ; e is greater, no division this time.
																											; 		 sub e               ; subtract it.
																											; 		 inc d               ; rotate into d.
																											; idiv1  djnz idiv0
																											; 		 ret
; ------------------------------------------------------------------------------------------------------------------------------------------
																											; Initialise a sound.
; ------------------------------------------------------------------------------------------------------------------------------------------
;																											; isnd   ld de,(ch1ptr)      ; first pointer.
;																											; 		 ld a,(de)           ; get first byte.
;																											; 		 inc a               ; reached the end?
;																											; 		 jr z,isnd1          ; that'll do.
;																											; 		 ld de,(ch2ptr)      ; second pointer.
;																											; 		 ld a,(de)           ; get first byte.
;																											; 		 inc a               ; reached the end?
;																											; 		 jr z,isnd2          ; that'll do.
;																											; 		 ld de,(ch3ptr)      ; final pointer.
;																											; 		 ld a,(de)           ; get first byte.
;																											; 		 inc a               ; reached the end?
;																											; 		 jr z,isnd3          ; that'll do.
;																											; 		 ret
;																											; isnd1  ld (ch1ptr),hl      ; set up the sound.
;																											; 		 ret
;																											; isnd2  ld (ch2ptr),hl      ; set up the sound.
;																											; 		 ret
;																											; isnd3  ld (ch3ptr),hl      ; set up the sound.
;																											; 		 ret
; ------------------------------------------------------------------------------------------------------------------------------------------
;																											; ch1ptr defw spmask
;																											; ch2ptr defw spmask
;																											; ch3ptr defw spmask
; ------------------------------------------------------------------------------------------------------------------------------------------
;																											; plsnd  call plsnd1         ; first channel.
;																											; 		 call plsnd2         ; second one.
;																											; 		 call plsnd3         ; final channel.
; ------------------------------------------------------------------------------------------------------------------------------------------
;																											; Write the contents of our AY buffer to the AY registers.
; ------------------------------------------------------------------------------------------------------------------------------------------
;																											; w8912  ld hl,snddat        ; start of AY-3-8912 register data.
;																											; 		 ld de,14*256        ; start with register 0, 14 to write.
;																											; 		 ld c,253            ; low byte of port to write.
;																											; w8912a ld b,255            ; port 65533=select soundchip register.
;																											; 		 out (c),e           ; tell chip which register we're writing.
;																											; 		 ld a,(hl)           ; value to write.
;																											; 		 ld b,191            ; port 49149=write value to register.
;																											; 		 out (c),a           ; this is what we're putting there.
;																											; 		 inc e               ; next sound chip register.
;																											; 		 inc hl              ; next byte to write.
;																											; 		 dec d               ; decrement loop counter.
;																											; 		 jp nz,w8912a        ; repeat until done.
;																											; 		 ret
; ------------------------------------------------------------------------------------------------------------------------------------------
;																											; snddat defw 0              ; tone registers, channel A.
;																											; 		 defw 0              ; channel B tone registers.
;																											; 		 defw 0              ; as above, channel C.
;																											; sndwnp defb 0              ; white noise period.
;																											; sndmix defb 60             ; tone/noise mixer control.
;																											; sndv1  defb 0              ; channel A amplitude/envelope generator.
;																											; sndv2  defb 0              ; channel B amplitude/envelope.
;																											; sndv3  defb 0              ; channel C amplitude/envelope.
;																											; 		 defw 0              ; duration of each note.
;																											; 		 defb 0
; ------------------------------------------------------------------------------------------------------------------------------------------
;																											; plwn   inc hl              ; next byte of sound.
;																											; 		 and 56              ; check if we're bothering with white noise.
;																											; 		 ret nz              ; we're not.
;																											; 		 ld a,(hl)           ; fetch byte.
;																											; 		 ld (sndwnp),a       ; set white noise period.
;																											; 		 ret
; ------------------------------------------------------------------------------------------------------------------------------------------
;																											; plsnd2 call cksnd2         ; check sound for first channel.
;																											; 		 cp 255              ; reached end?
;																											; 		 jr z,silen2         ; silence this channel.
;																											; 		 and 15              ; sound bits.
;																											; 		 ld (sndv2),a        ; set volume for channel.
;																											; 		 ld a,(sndmix)       ; mixer byte.
;																											; 		 and 237             ; remove bits for this channel.
;																											; 		 ld b,a              ; store in b register.
;																											; 		 call plmix          ; fetch mixer details.
;																											; 		 and 18              ; mixer bits we want.
;																											; 		 or b                ; combine with mixer bits.
;																											; 		 ld (sndmix),a       ; new mixer value.
;																											; 		 call plwn           ; white noise check.
;																											; 		 inc hl              ; tone low.
;																											; 		 ld e,(hl)           ; fetch value.
;																											; 		 inc hl              ; tone high.
;																											; 		 ld d,(hl)           ; fetch value.
;																											; 		 ld (snddat+2),de    ; set tone.
;																											; 		 inc hl              ; next bit of sound.
;																											; 		 ld (ch2ptr),hl      ; set pointer.
;																											; 		 ret
; ------------------------------------------------------------------------------------------------------------------------------------------
;																											; plsnd3 call cksnd3         ; check sound for first channel.
;																											; 		 cp 255              ; reached end?
;																											; 		 jr z,silen3         ; silence last channel.
;																											; 		 and 15              ; sound bits.
;																											; 		 ld (sndv3),a        ; set volume for channel.
;																											; 		 ld a,(sndmix)       ; mixer byte.
;																											; 		 and 219             ; remove bits for this channel.
;																											; 		 ld b,a              ; store in b register.
;																											; 		 call plmix          ; fetch mixer details.
;																											; 		 and 36              ; mixer bits we want.
;																											; 		 or b                ; combine with mixer bits.
;																											; 		 ld (sndmix),a       ; new mixer value.
;																											; 		 call plwn           ; white noise check.
;																											; 		 inc hl              ; tone low.
;																											; 		 ld e,(hl)           ; fetch value.
;																											; 		 inc hl              ; tone high.
;																											; 		 ld d,(hl)           ; fetch value.
;																											; 		 ld (snddat+4),de    ; set tone.
;																											; 		 inc hl              ; next bit of sound.
;																											; 		 ld (ch3ptr),hl      ; set pointer.
;																											; 		 ret
; ------------------------------------------------------------------------------------------------------------------------------------------
;																											; plmix  ld a,(hl)           ; fetch mixer byte.
;																											; 		 and 192             ; mix bits are d6 and d7.
;																											; 		 rlca                ; rotate into d0 and d1.
;																											; 		 rlca
;																											; 		 ld e,a              ; displacement in de.
;																											; 		 ld d,0
;																											; 		 push hl             ; store pointer on stack.
;																											; 		 ld hl,mixtab        ; mixer table.
;																											; 		 add hl,de           ; point to mixer byte.
;																											; 		 ld a,(hl)           ; fetch mixer value.
;																											; 		 pop hl              ; restore pointer.
;																											; 		 ret
;																											; mixtab defb 63,56,7,0      ; mixer byte settings.
; ------------------------------------------------------------------------------------------------------------------------------------------
;																											; silen1 xor a               ; zero.
;																											; 		 ld (sndv1),a        ; sound off.
;																											; 		 ld a,(sndmix)       ; mixer byte.
;																											; 		 or 9                ; mix bits off.
;																											; 		 ld (sndmix),a       ; mixer setting for channel.
;																											; 		 ret
; ------------------------------------------------------------------------------------------------------------------------------------------
;																											; silen2 xor a               ; zero.
;																											; 		 ld (sndv2),a        ; sound off.
;																											; 		 ld a,(sndmix)       ; mixer byte.
;																											; 		 or 18               ; mix bits off.
;																											; 		 ld (sndmix),a       ; mixer setting for channel.
;																											; 		 ret
; ------------------------------------------------------------------------------------------------------------------------------------------
;																											; silen3 xor a               ; zero.
;																											; 		 ld (sndv3),a        ; sound off.
;																											; 		 ld a,(sndmix)       ; mixer byte.
;																											; 		 or 36               ; mix bits off.
;																											; 		 ld (sndmix),a       ; mixer setting for channel.
;																											; 		 ret
; ------------------------------------------------------------------------------------------------------------------------------------------
;																											; cksnd1 ld hl,(ch1ptr)      ; pointer to sound.
;																											; 		 ld a,(hl)           ; fetch mixer/flag.
;																											; 		 ret
;																											; cksnd2 ld hl,(ch2ptr)      ; pointer to sound.
;																											; 		 ld a,(hl)           ; fetch mixer/flag.
;																											; 		 ret
;																											; cksnd3 ld hl,(ch3ptr)      ; pointer to sound.
;																											; 		 ld a,(hl)           ; fetch mixer/flag.
;																											; 		 ret
; ------------------------------------------------------------------------------------------------------------------------------------------
;																											; plsnd1 call cksnd1         ; check sound for first channel.
;																											; 		 cp 255              ; reached end?
;																											; 		 jr z,silen1         ; silence first channel.
;																											; 		 and 15              ; sound bits.
;																											; 		 ld (sndv1),a        ; set volume for channel.
;																											; 		 ld a,(sndmix)       ; mixer byte.
;																											; 		 and 246             ; remove bits for this channel.
;																											; 		 ld b,a              ; store in b register.
;																											; 		 call plmix          ; fetch mixer details.
;																											; 		 and 9               ; mixer bits we want.
;																											; 		 or b                ; combine with mixer bits.
;																											; 		 ld (sndmix),a       ; new mixer value.
;																											; 		 call plwn           ; white noise check.
;																											; 		 inc hl              ; tone low.
;																											; 		 ld e,(hl)           ; fetch value.
;																											; 		 inc hl              ; tone high.
;																											; 		 ld d,(hl)           ; fetch value.
;																											; 		 ld (snddat),de      ; set tone.
;																											; 		 inc hl              ; next bit of sound.
;																											; 		 ld (ch1ptr),hl      ; set pointer.
;																											; 		 ret
; ------------------------------------------------------------------------------------------------------------------------------------------
;																											; Objects handling.
;																											; 32 bytes for image
;																											; 1 for colour
;																											; 3 for room, x and y
;																											; 3 for starting room, x and y.
;																											; 254 = disabled.
;																											; 255 = object in player's pockets.
; ------------------------------------------------------------------------------------------------------------------------------------------
; Show items present																					; Show items present.
; ------------------------------------------------------------------------------------------------------------------------------------------
ShwOb		ldx	#objDta+33					; point to objects table room number		; shwob  ld hl,objdta        ; objects table.
																											; 		 ld de,33            ; distance to room number.
																											; 		 add hl,de           ; point to room data.
			ldb	numOb							; number of objects in the game				; 		 ld a,(numob)        ; number of objects in the game.
																											; 		 ld b,a              ; loop counter.
ShwOb0																									; shwob0 push bc             ; store count.
																											; 		 push hl             ; store item pointer.
			lda	scNo							; get current location							; 		 ld a,(scno)         ; current location.
			cmpa	,x								; same as pointed object?						; 		 cp (hl)             ; same as an item?
			bne	ShwOb1						; no, skip next
			pshs	b,x							; save registers
			jsr	DObjc							; show Object										; 		 call z,dobjc        ; yes, display object in colour.
			puls	b,x							; restore objects									; 		 pop hl              ; restore pointer.
ShwOb1																									; 		 pop bc              ; restore counter.
																											; 		 ld de,39            ; distance to next item.
			leax	39,x							; point to next object							; 		 add hl,de           ; point to it.
			decb									; decrement counter
			bne	ShwOb0						; not yet done? loopback						; 		 djnz shwob0         ; repeat for others.
			rts									; return												; 		 ret
; ------------------------------------------------------------------------------------------------------------------------------------------
; Display object																						; Display object.
; regX points to object's room number															; hl must point to object's room number.
; ------------------------------------------------------------------------------------------------------------------------------------------
DObj																										; dobj   inc hl              ; point to x.
			ldd	1,x							; get coordinates									; dobj0  ld de,dispx         ; coordinates.
			std	<dispX							; put into variables X,Y						; 		 ldi                 ; transfer x coord.
																											; 		 ldi                 ; transfer y too.
																											; 		 ld de,65500         ; minus 36.
			leax	-33,x							; point to object image							; 		 add hl,de           ; point to image.
DObj1		ldd	<dispX
			sta	<dispY
			stb	<dispX
DObjX		jmp	Sprite						; draw object as sprite							; dobj1  jp sprite           ; draw this sprite.
																											; 
DObjc		bsr	DObj							; display object									; dobjc  call dobj           ; display object.
																											; 		 ld c,(hl)           ; put ink in c register.
; ------------------------------------------------------------------------------------------------------------------------------------------
																											; Need to write attribute routine here.
													; NO colours to set in 6809					; set up colour in c register first.
; ------------------------------------------------------------------------------------------------------------------------------------------
CObj																										; cobj   ld a,(hl)           ; get colour byte.
;																											; 		 and a               ; test it.
;																											; 		 ret m               ; colour not set.
;																											; 		 ld h,22             ; quarter of attrubte address.
;																											; 		 ld a,(dispx)        ; x coord.
;																											; 		 and 248             ; only want multiple of 8.
;																											; 		 rla                 ; multiply by 4.
;																											; 		 rl h
;																											; 		 rla
;																											; 		 rl h                ; high byte now set up.
;																											; 		 ld l,a
;																											; 		 ld a,(dispy)        ; take y position.
;																											; 		 rra                 ; divide it by 8.
;																											; 		 rra
;																											; 		 rra
;																											; 		 and 31              ; remove unwanted bits.
;																											; 		 add a,l             ; add to low byte.
;																											; 		 ld l,a              ; low byte of address.
;																											; 		 ld de,30            ; distance to next line down.
;																											; 		 ld a,(dispx)        ; x coordinate.
;																											; 		 ld b,3              ; default rows to write.
;																											; 		 and 7               ; does x straddle cells?
;																											; 		 jr nz,cobj0         ; yes, loop counter is good.
;																											; 		 dec b               ; one less row to write.
;																											; cobj0  ld a,(hl)           ; get attributes.
;																											; 		 and 248             ; remove ink.
;																											; 		 or c                ; put in the new ink.
;																											; 		 ld (hl),a           ; write back again.
;																											; 		 inc l               ; next cell.
;																											; 		 ld a,(hl)           ; get attributes.
;																											; 		 and 248             ; remove ink.
;																											; 		 or c                ; put in the new ink.
;																											; 		 ld (hl),a           ; write back again.
;																											; 		 inc l               ; next cell.
;																											; 		 ld a,(dispy)        ; y coordinate.
;																											; 		 and 7               ; straddling cells?
;																											; 		 jr z,cobj1          ; no, only 2 wide.
;																											; 		 ld a,(hl)           ; get attributes.
;																											; 		 and 248             ; remove ink.
;																											; 		 or c                ; put in the new ink.
;																											; 		 ld (hl),a           ; write back again.
;																											; cobj1  add hl,de           ; next row.
;																											; 		 djnz cobj0
			rts																							; 		 ret
; ------------------------------------------------------------------------------------------------------------------------------------------
																											; Remove an object.
; ------------------------------------------------------------------------------------------------------------------------------------------
																											; remob  ld hl,numob         ; number of objects in game.
																											; 		 cp (hl)             ; are we checking past the end?
																											; 		 ret nc              ; yes, can't get non-existent item.
																											; 		 push af             ; remember object.
																											; 		 call getob          ; pick it up if we haven't already got it.
																											; 		 pop af              ; retrieve object number.
																											; 		 call gotob          ; get its address.
																											; 		 ld (hl),254         ; remove it.
																											; 		 ret
; ------------------------------------------------------------------------------------------------------------------------------------------
; Pick up object number held in the accumulator												; Pick up object number held in the accumulator.
; ------------------------------------------------------------------------------------------------------------------------------------------
GetOb																										; getob  ld hl,numob         ; number of objects in game.
			cmpa	numOb																					; 		 cp (hl)             ; are we checking past the end?
			bcc	GetObEx																				; 		 ret nc              ; yes, can't get non-existent item.
			jsr	GotOb																					; 		 call gotob          ; check if we already have it.
			beq	GetObEx																				; 		 ret z               ; we already do.
																											; 		 ex de,hl            ; object address in de.
			ldx	<reg_HL																				; 		 ld hl,scno          ; current screen.
			cmpa	scNo																					; 		 cp (hl)             ; is it on this screen?
																											; 		 ex de,hl            ; object address back in hl.
			bne	GetOb0																				; 		 jr nz,getob0        ; not on screen, so nothing to delete.
			lda	#255																					; 		 ld (hl),255         ; pick it up.
			sta	,x+																					; 		 inc hl              ; point to x coord.
GetOb1	ldd	,x																						; getob1 ld e,(hl)           ; x coord.
																											; 		 inc hl              ; back to y coord.
																											; 		 ld d,(hl)           ; y coord.
			std	<dispX							; save inverted, DObj1 corrects it			; 		 ld (dispx),de       ; set display coords.
																											; 		 ld de,65501         ; minus graphic size.
			leax	-34,x																					; 		 add hl,de           ; point to graphics.
			
			jsr	DObj1							; delete collected object						; 		 call dobj1          ; delete object sprite.
																											; 		 ld a,(bcol)         ; first block colour.
																											; 		 and 7               ; only want ink attribute.
																											; 		 ld c,a              ; set up colour.
			jmp	CObj																					; 		 jp cobj             ; colour object's old position.
GetOb0	lda	#255
			sta	,x																						; getob0 ld (hl),255         ; pick it up.
GetObEx	rts																							; 		 ret
; ------------------------------------------------------------------------------------------------------------------------------------------
; Got object check																					; Got object check.
; Call with object in accumulator, returns zero set if in pockets						; Call with object in accumulator, returns zero set if in pockets.
; ------------------------------------------------------------------------------------------------------------------------------------------
GotOb																										; gotob  ld hl,numob         ; number of objects in game.
			cmpa	numOb							; are we checking past the end?				; 		 cp (hl)             ; are we checking past the end?
			bcc	GotOb0						; yes, we can't have a non-existent object; 		 jr nc,gotob0        ; yes, we can't have a non-existent object.
			jsr	FindOb						; find object										; 		 call findob         ; find the object.
GotOb1	cmpa	#255							; in pocket's?										; gotob1 cp 255              ; in pockets?
			rts									; return result in flags						; 		 ret
GotOb0	lda	#254							; disabled											; gotob0 ld a,254            ; missing.
			bra	GotOb1						; exit testing										; 		 jr gotob1
; ------------------------------------------------------------------------------------------------------------------------------------------
FindOb	pshs	x								; save working register
			ldx	#objDta						; point to objects table						; findob ld hl,objdta        ; objects.
																											; 		 ld de,39            ; size of each object.
			tsta									; received zero?									; 		 and a               ; is it zero?
			beq	FndOb1						; yes, skip loop									; 		 jr z,fndob1         ; yes, skip loop.
											 																; 		 ld b,a              ; loop counter in b.
FndOb2	leax	39,x							; point to next object							; fndob2 add hl,de           ; point to next one.
			deca									; decrement number of Object
			bne	FndOb2						; not zero, loopback								; 		 djnz fndob2         ; repeat until we find address.
FndOb1																									; fndob1 ld e,33             ; distance to room it's in.
			leax	33,x							; point to room where object is				; 		 add hl,de           ; point to room.
			stx	<reg_HL						; save pointer
			lda	,x								; get status 										; 		 ld a,(hl)           ; fetch status.
			puls	x,pc							; restore register and return					; 		 ret
; ------------------------------------------------------------------------------------------------------------------------------------------
; Drop object number at (dispx, dispy)															; Drop object number at (dispx, dispy).
; ------------------------------------------------------------------------------------------------------------------------------------------
DrpObI	inc	DisObj+1						; set to disable object
DrpOb																										; drpob  ld hl,numob         ; number of objects in game.
			cmpa	numOb							; are we checking past the end?				; 		 cp (hl)             ; are we checking past the end?
			bcc	DrpOEx						; yes, can't drop non-existent item			; 		 ret nc              ; yes, can't drop non-existent item.
			jsr	GotOb							; make sure object is in inventory			; 		 call gotob          ; make sure object is in inventory.
			ldx	<reg_HL						; returns location number in reg_HL
			lda	scNo							; get screen number								; 		 ld a,(scno)         ; screen number.
			cmpa	,x								; already on this screen?						; 		 cp (hl)             ; already on this screen?
			beq	DrpOEx						; yes, exit											; 		 ret z               ; yes, nothing to do.
DisObj	ldb	#$00							; flag for disabling an object
			beq	DrpOb1						; not set) show object
			dec	,x								; convert 255 (in pocket) to disabled
			bra	DrpOEx						; exit
DrpOb1	sta	,x								; update location									; 		 ld (hl),a           ; bring onto screen.
																											; 		 inc hl              ; point to x coord.
			lda	<dispY							; get sprite x coordinate						; 		 ld a,(dispx)        ; sprite x coordinate.
			sta	2,x							; set x coord										; 		 ld (hl),a           ; set x coord.
																											; 		 inc hl              ; point to object y.
			lda	<dispX							; get sprite y coordinate						; 		 ld a,(dispy)        ; sprite y coordinate.
			sta	1,x							; set y coord										; 		 ld (hl),a           ; set the y position.
																											; 		 ld de,65501         ; minus graphic size (35)
			leax	-33,x							; point to object beginning					; 		 add hl,de           ; point to graphics.
			stx	<reg_HL						; update register
			jsr	DObj1							; delete object sprite							; 		 call dobj1          ; delete object sprite.
																											; 		 ld c,(hl)           ; put ink in c register.
DrpOEx	clr	DisObj+1						; reset to enable objects
			jmp	CObj							; no colors - delete old sprite				; 		 jp cobj             ; colour the object.
; ------------------------------------------------------------------------------------------------------------------------------------------
; Seek objects at sprite position																; Seek objects at sprite position.
; ------------------------------------------------------------------------------------------------------------------------------------------
SkObj		ldx	#objDta																				; skobj  ld hl,objdta        ; pointer to objects.
																											; 		 ld de,33            ; distance to room number.
			leax	33,x																					; 		 add hl,de           ; point to room data.
																											; 		 ld de,39            ; size of each object.
			lda	numOb																					; 		 ld a,(numob)        ; number of objects in game.
			sta	<reg_B																				; 		 ld b,a              ; set up the loop counter.
SkObj0	lda	scNo																					; skobj0 ld a,(scno)         ; current room number.
			cmpa	,x																						; 		 cp (hl)             ; is object in here?
			bne	SkObjZ
			jsr	SkObj1																				; 		 call z,skobj1       ; yes, check coordinates.
SkObjZ	leax	39,x																					; 		 add hl,de           ; point to next object in table.
			dec	<reg_B
			bne	SkObj0																				; 		 djnz skobj0         ; repeat for all objects.
			lda	#255																					; 		 ld a,255            ; end of list and nothing found, return 255.
			rts																							; 		 ret
SkObj1	leax	1,x																					; skobj1 inc hl              ; point to x coordinate.
			lda	,x																						; 		 ld a,(hl)           ; get coordinate.
			suba	8,y																					; 		 sub (ix+8)          ; subtract sprite x.
			adda	#15																					; 		 add a,15            ; add sprite height minus one.
			cmpa	#31																					; 		 cp 31               ; within range?
			bcc	SkObj2																				; 		 jp nc,skobj2        ; no, ignore object.
			leax	1,x																					; 		 inc hl              ; point to y coordinate now.
			lda	,x																						; 		 ld a,(hl)           ; get coordinate.
			suba	9,y																					; 		 sub (ix+9)          ; subtract the sprite y.
			adda	#15																					; 		 add a,15            ; add sprite width minus one.
			cmpa	#31																					; 		 cp 31               ; within range?
			bcc	SkObj3																				; 		 jp nc,skobj3        ; no, ignore object.
			leas	2,s																					; 		 pop de              ; remove return address from stack.
			lda	numOb																					; 		 ld a,(numob)        ; objects in game.
			suba	<reg_B																				; 		 sub b               ; subtract loop counter.
			rts																							; 		 ret                 ; accumulator now points to object.
SkObj3	leax	-1,x																					; skobj3 dec hl              ; back to y position.
SkObj2	leax	-1,x																					; skobj2 dec hl              ; back to room.
			rts																							; 		 ret
; ------------------------------------------------------------------------------------------------------------------------------------------
																											; Spawn a new sprite.
; ------------------------------------------------------------------------------------------------------------------------------------------
																											; spawn  ld hl,sprtab        ; sprite table.
																											; numsp1 ld a,NUMSPR         ; number of sprites.
																											; 		 ld de,TABSIZ        ; size of each entry.
																											; spaw0  ex af,af'           ; store loop counter.
																											; 		 ld a,(hl)           ; get sprite type.
																											; 		 inc a               ; is it an unused slot?
																											; 		 jr z,spaw1          ; yes, we can use this one.
																											; 		 add hl,de           ; point to next sprite in table.
																											; 		 ex af,af'           ; restore loop counter.
																											; 		 dec a               ; one less iteration.
																											; 		 jr nz,spaw0         ; keep going until we find a slot.
; ------------------------------------------------------------------------------------------------------------------------------------------
																											; Didn't find one but drop through and set up a dummy sprite instead.
; ------------------------------------------------------------------------------------------------------------------------------------------
																											; spaw1  push ix             ; existing sprite address on stack.
																											; 		 ld (spptr),hl       ; store spawned sprite address.
																											; 		 ld (hl),c           ; set the type.
																											; 		 inc hl              ; point to image.
																											; 		 ld (hl),b           ; set the image.
																											; 		 inc hl              ; next byte.
																											; 		 ld (hl),0           ; frame zero.
																											; 		 inc hl              ; next byte.
																											; 		 ld a,(ix+X)         ; x coordinate.
																											; 		 ld (hl),a           ; set sprite coordinate.
																											; 		 inc hl              ; next byte.
																											; 		 ld a,(ix+Y)         ; y coordinate.
																											; 		 ld (hl),a           ; set sprite coordinate.
																											; 		 inc hl              ; next byte.
																											; 		 ex de,hl            ; swap address into de.
																											; 		 ld hl,(spptr)       ; restore address of details.
																											; 		 ld bc,5             ; number of bytes to duplicate.
																											; 		 ldir                ; copy first version to new version.
																											; 		 ex de,hl            ; swap address into de.
																											; 		 ld a,(ix+10)        ; direction of original.
																											; 		 ld (hl),a           ; set the direction.
																											; 		 inc hl              ; next byte.
																											; 		 ld (hl),b           ; reset parameter.
																											; 		 inc hl              ; next byte.
																											; 		 ld (hl),b           ; reset parameter.
																											; 		 inc hl              ; next byte.
																											; 		 ld (hl),b           ; reset parameter.
																											; 		 inc hl              ; next byte.
																											; 		 ld (hl),b           ; reset parameter.
																											; rtssp  ld ix,(spptr)       ; address of new sprite.
																											; evis1  call evnt09         ; call sprite initialisation event.
																											; 		 ld ix,(spptr)       ; address of new sprite.
																											; 		 call sspria         ; display the new sprite.
																											; 		 pop ix              ; address of original sprite.
																											; 		 ret
; ------------------------------------------------------------------------------------------------------------------------------------------
																											; spptr  defw 0              ; spawned sprite pointer.
																											; seed   defb 0              ; seed for random numbers.
score		fcc	/000000/						; player's score									; score  defb '000000'       ; player's score.
hiScor	fcc 	/000000/						; high score										; hiscor defb '000000'       ; high score.
																											; bonus  defb '000000'       ; bonus.
; ------------------------------------------------------------------------------------------------------------------------------------------
; verify if inside screen window																	; verify if inside screen window
; ------------------------------------------------------------------------------------------------------------------------------------------
CheckX	lda	<dispY							; get Y position									; checkx ld a,e              ; x position.
			cmpa	#24							; out of screen?									; 		 cp 24               ; off screen?
			blo	Check1						; no, skip next									; 		 ret c               ; no, it's okay.
			puls	x								; remove return address from stack			; 		 pop hl              ; remove return address from stack.
Check1	rts									; return												; 		 ret
; ------------------------------------------------------------------------------------------------------------------------------------------
																											; Displays the current score.
; ------------------------------------------------------------------------------------------------------------------------------------------
																											; dscor  call preprt         ; set up font and print position.
																											; 		 call checkx         ; make sure we're in a printable range.
																											; 		 ld a,(prtmod)       ; get print mode.
																											; 		 and a               ; standard size text?
																											; 		 jp nz,bscor0        ; no, show double-height.
																											; dscor0 push bc             ; place counter onto the stack.
																											; 		 push hl
																											; 		 ld a,(hl)           ; fetch character.
																											; 		 call pchar          ; display character.
																											; 		 call gaadd          ; get attribute address.
																											; 		 ld a,(23693)        ; current cell colours.
																											; 		 ld (hl),a           ; write to attribute cell.
																											; 		 ld hl,dispy         ; y coordinate.
																											; 		 inc (hl)            ; move along one.
																											; 		 pop hl
																											; 		 inc hl              ; next score column.
																											; 		 pop bc              ; retrieve character counter.
																											; 		 djnz dscor0         ; repeat for all digits.
																											; 		 ld hl,(blkptr)      ; blocks.
																											; 		 ld (grbase),hl      ; set graphics base.
Dscor2	ldx	<dispX							; get screen position (X,Y)					; dscor2 ld hl,(dispx)       ; general coordinates.
			stx	<charX							; save for next time								; 		 ld (charx),hl       ; set up display coordinates.
			rts									; return												; 		 ret
; ------------------------------------------------------------------------------------------------------------------------------------------
																											; Displays the current score in double-height characters.
; ------------------------------------------------------------------------------------------------------------------------------------------
																											; bscor0 push bc             ; place counter onto the stack.
																											; 		 push hl
																											; 		 ld a,(hl)           ; fetch character.
																											; 		 call bchar          ; display big char.
																											; 		 pop hl
																											; 		 inc hl              ; next score column.
																											; 		 pop bc              ; retrieve character counter.
																											; 		 djnz bscor0         ; repeat for all digits.
																											; 		 jp dscor2           ; tidy up line and column variables.
; ------------------------------------------------------------------------------------------------------------------------------------------
																											; Adds number in the hl pair to the score.
; ------------------------------------------------------------------------------------------------------------------------------------------
																											; addsc  ld de,score+1       ; ten thousands column.
																											; 		 ld bc,10000         ; amount to add each time.
																											; 		 call incsc          ; add to score.
																											; 		 inc de              ; thousands column.
																											; 		 ld bc,1000          ; amount to add each time.
																											; 		 call incsc          ; add to score.
																											; 		 inc de              ; hundreds column.
																											; 		 ld bc,100           ; amount to add each time.
																											; 		 call incsc          ; add to score.
																											; 		 inc de              ; tens column.
																											; 		 ld bc,10            ; amount to add each time.
																											; 		 call incsc          ; add to score.
																											; 		 inc de              ; units column.
																											; 		 ld bc,1             ; units.
																											; incsc  push hl             ; store amount to add.
																											; 		 and a               ; clear the carry flag.
																											; 		 sbc hl,bc           ; subtract from amount to add.
																											; 		 jr c,incsc0         ; too much, restore value.
																											; 		 pop af              ; delete the previous amount from the stack.
																											; 		 push de             ; store column position.
																											; 		 call incsc2         ; do the increment.
																											; 		 pop de              ; restore column.
																											; 		 jp incsc            ; repeat until all added.
																											; incsc0 pop hl              ; restore previous value.
																											; 		 ret
																											; incsc2 ld a,(de)           ; get amount.
																											; 		 inc a               ; add one to column.
																											; 		 ld (de),a           ; write new column total.
																											; 		 cp '9'+1            ; gone beyond range of digits?
																											; 		 ret c               ; no, carry on.
																											; 		 ld a,'0'            ; mae it zero.
																											; 		 ld (de),a           ; write new column total.
																											; 		 dec de              ; back one column.
																											; 		 jr incsc2
; ------------------------------------------------------------------------------------------------------------------------------------------
																											; Add bonus to score.
; ------------------------------------------------------------------------------------------------------------------------------------------
																											; addbo  ld de,score+5       ; last score digit.
																											; 		 ld hl,bonus+5       ; last bonus digit.
																											; 		 and a               ; clear carry.
																											; 		 ld bc,6*256+48      ; 6 digits to add, ASCII '0' in c.
																											; addbo0 ld a,(de)           ; get score.
																											; 		 adc a,(hl)          ; add bonus.
																											; 		 sub c               ; 0 to 18.
																											; 		 ld (hl),c           ; zeroise bonus.
																											; 		 dec hl              ; next bonus.
																											; 		 cp 58               ; carried?
																											; 		 jr c,addbo1         ; no, do next one.
																											; 		 sub 10              ; subtract 10.
																											; addbo1 ld (de),a           ; write new score.
																											; 		 dec de              ; next score digit.
																											; 		 ccf                 ; set carry for next digit.
																											; 		 djnz addbo0         ; repeat for all 6 digits.
																											; 		 ret
; ------------------------------------------------------------------------------------------------------------------------------------------
																											; Swap score and bonus.
; ------------------------------------------------------------------------------------------------------------------------------------------
																											; swpsb  ld de,score         ; first score digit.
																											; 		 ld hl,bonus         ; first bonus digit.
																											; 		 ld b,6              ; digits to add.
																											; swpsb0 ld a,(de)           ; get score and bonus digits.
																											; 		 ld c,(hl)
																											; 		 ex de,hl            ; swap pointers.
																											; 		 ld (hl),c           ; write bonus and score digits.
																											; 		 ld (de),a
																											; 		 inc hl              ; next score and bonus.
																											; 		 inc de
																											; 		 djnz swpsb0         ; repeat for all 6 digits.
																											; 		 ret
; ------------------------------------------------------------------------------------------------------------------------------------------
; Get print address																					; Get print address
; ------------------------------------------------------------------------------------------------------------------------------------------
GPrad		lda	<dispY							; get Y	(row * 256)								; gprad  ld a,(dispx)        ; returns scr. add. in de.
			ldb	<dispX							; get X												; 		 ld e,a              ; place in e for now.
			addd	#SCRBEG						; add screen beginning							; 		 and 24              ; which of 3 segments do we need?
			std	<grBase						; store address									; 		 add a,64            ; add 64 for start address of screen.
																											; 		 ld d,a              ; that's our high byte.
																											; 		 ld a,e              ; restore x coordinate.
																											; 		 rrca                ; multiply by 32.
																											; 		 rrca
																											; 		 rrca
																											; 		 and 224             ; lines within segment.
																											; 		 ld e,a              ; set up low byte for x.
																											; 		 ld a,(dispy)        ; now get y coordinate.
																											; 		 add a,e             ; add to low byte.
																											; 		 ld e,a              ; final low byte.
			rts									; return												; 		 ret
; ------------------------------------------------------------------------------------------------------------------------------------------
; Get property buffer address of char at (dispx, dispy) in hl							; Get property buffer address of char at (dispx, dispy) in hl
; receives in regA byte number. Returns address in regX
; ------------------------------------------------------------------------------------------------------------------------------------------
PrAdd		pshs	a,b							; save registers
			lda	<dispY							; get coordinate Y								; pradd  ld a,(dispx)        ; x coordinate.
			ldb	#32							; multiply											; 		 rrca                ; multiply by 32.
			mul									; by 32												; 		 rrca
																											; 		 rrca
																											; 		 ld l,a              ; store shift in l.
																											; 		 and 3               ; high byte bits.
			ldx	#MAP							; start of properties map						; 		 add a,253           ; 253 * 256 = 64768, start of properties map.
			leax	d,x							; add Y offset										; 		 ld h,a              ; that's our high byte.
								 																			; 		 ld a,l              ; restore shift result.
																											; 		 and 224             ; only want low bits.
																											; 		 ld l,a              ; put into low byte.
			ldb	<dispX							; get coordinate X								; 		 ld a,(dispy)        ; fetch y coordinate.
			andb	#31							; keep into 0-31 range							; 		 and 31              ; should be in range 0 - 31.
			abx									; add X offset										; 		 add a,l             ; add to low byte.
																											; 		 ld l,a              ; new low byte.
			puls	a,b,pc						; restore registers and return				; 		 ret
; ------------------------------------------------------------------------------------------------------------------------------------------
																											; Get attribute address of char at (dispx, dispy) in hl.
; ------------------------------------------------------------------------------------------------------------------------------------------
																											; gaadd  ld a,(dispx)        ; x coordinate.
																											; 		 rrca                ; multiply by 32.
																											; 		 rrca
																											; 		 rrca
																											; 		 ld l,a              ; store shift in l.
																											; 		 and 3               ; high byte bits.
																											; 		 add a,88            ; 88 * 256 = 22528, start of screen attributes.
																											; 		 ld h,a              ; that's our high byte.
																											; 		 ld a,l              ; restore shift result.
																											; 		 and 224             ; only want low bits.
																											; 		 ld l,a              ; put into low byte.
																											; 		 ld a,(dispy)        ; fetch y coordinate.
																											; 		 and 31              ; should be in range 0 - 31.
																											; 		 add a,l             ; add to low byte.
																											; 		 ld l,a              ; new low byte.
																											; 		 ret
; ------------------------------------------------------------------------------------------------------------------------------------------
; Display character in A at dispx,dispy.														; Display character in A at dispx,dispy.
; ------------------------------------------------------------------------------------------------------------------------------------------
PChar		ldb	#8								; to multiply by 8								; pchar  rlca                ; multiply char by 8.		
			mul									; calculate offset 16 bits						; 		 rlca
			ldu	<fontPtr						; get font table beginning						; 		 rlca
			leau	d,u							; add offset										; 		 ld e,a              ; store shift in e.
PChark	jsr	GPrad							; get screen address.							; 		 and 7               ; only want high byte bits.
			ldx	<grBase						; point to screen (destination)				; 		 ld d,a              ; store in d.
			ldb	#8								; lines to write									; 		 ld a,e              ; restore shifted value.
PChar0	lda	,u+							; get char row byte								; 		 and 248             ; only want low byte bits.
	IF !PMODE4
			anda	<andeor
			eora	<andeor+1
	ENDIF
			sta	,x								; put on screen									; 		 ld e,a              ; that's the low byte.
			leax	32,x							; point to next row								; 		 ld hl,(grbase)      ; address of graphics.
			decb									; decrement counter								; 		 add hl,de           ; add displacement.
			bne	PChar0						; not done? loopback								; pchark call gprad          ; get screen address.
																											; ;       ldi                 ; transfer byte.
																											; ;       dec de              ; back again.
																											; ;       inc d               ; next screen row down.
																											; ;       ldi                 ; transfer byte.
																											; ;       dec de              ; back again.
																											; ;       inc d               ; next screen row down.
																											; ;       ldi                 ; transfer byte.
																											; ;       dec de              ; back again.
																											; ;       inc d               ; next screen row down.
																											; ;       ldi                 ; transfer byte.
																											; ;       dec de              ; back again.
																											; ;       inc d               ; next screen row down.
																											; ;       ldi                 ; transfer byte.
																											; 		 ld a,(hl)      																						; ;       dec de              ; back again.
																											; ;       inc d               ; next screen row down.
																											; ;       ldi                 ; transfer byte.
																											; ;       dec de              ; back again.
																											; ;       inc d               ; next screen row down.
																											; ;       ldi                 ; transfer byte.
																											; ;       dec de              ; back again.
																											; ;       inc d               ; next screen row down.
																											; ;       ldi                 ; transfer byte.
																											; 		 ld a,(hl)           ; get image byte.
																											; 		 ld (de),a           ; copy to screen.
																											; 		 inc hl              ; next image byte.
																											; 		 inc d               ; next screen row down.
																											; 		 ld (de),a           ; copy to screen.
																											; 		 inc hl              ; next image byte.
																											; 		 inc d               ; next screen row down.
																											; 		 ld a,(hl)           ; get image byte.
																											; 		 ld (de),a           ; copy to screen.
																											; 		 inc hl              ; next image byte.
																											; 		 inc d               ; next screen row down.
																											; 		 ld a,(hl)           ; get image byte.
																											; 		 ld (de),a           ; copy to screen.
																											; 		 inc hl              ; next image byte.
																											; 		 inc d               ; next screen row down.
																											; 		 ld a,(hl)           ; get image byte.
																											; 		 ld (de),a           ; copy to screen.
																											; 		 inc hl              ; next image byte.
																											; 		 inc d               ; next screen row down.
																											; 		 ld a,(hl)           ; get image byte.
																											; 		 ld (de),a           ; copy to screen.
																											; 		 inc hl              ; next image byte.
																											; 		 inc d               ; next screen row down.
																											; 		 ld a,(hl)           ; get image byte.
																											; 		 ld (de),a           ; copy to screen.
																											; 		 inc hl              ; next image byte.
																											; 		 inc d               ; next screen row down.
																											; 		 ld a,(hl)           ; get image byte.
																											; 		 ld (de),a           ; copy to screen.
			rts									; return												; 		 ret
; ------------------------------------------------------------------------------------------------------------------------------------------
; Print attributes, properties and pixels														; Print attributes, properties and pixels.
; receives cellnum(block) in regA and repetitions in comCnt
; ------------------------------------------------------------------------------------------------------------------------------------------
PAttr		
	IF AFLAG																								; .if aflag
			pshs	a,x								; save block number								; pha
			jsr	WBloc            	      ; save blockinfo									; jsr wbloc 
			puls	a,x								; restore block number							; pla
	ENDIF																									; .endif
PAttr2																									; pattr2:
			sta	<reg_B						; save value										; pattr  ld b,a              ; store cell in b register for now.
																											; 		 ld e,a              ; displacement in e.
																											; 		 ld d,0              ; no high byte.
			ldx	proPtr						; point to properties table					; 		 ld hl,(proptr)      ; pointer to properties.
																											; 		 add hl,de           ; property cell address.
			ldb	a,x							; fetch byte at offset							; 		 ld c,(hl)           ; fetch byte.
			jsr	PrAdd		 					; get property buffer address					; 		 call pradd          ; get property buffer address.
			stb	,x								; write property									; 		 ld (hl),c           ; write property.
			lda	<reg_B						; restore cell										; 		 ld a,b              ; restore cell.
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
;													; No Attributes in 6809							; Print attributes, no properties.
;																											; panp   ld e,a              ; displacement in e.
;																											; 		 ld d,0              ; no high byte.
;																											; 		 ld hl,(colptr)      ; pointer to colours.
;																											; 		 add hl,de           ; colour cell address.
;																											; 		 ld c,(hl)           ; fetch byte.
;																											; 		 call gaadd          ; get attribute address.
;																											; 		 ld (hl),c           ; write colour.
;																											; 		 ld a,b              ; restore cell.
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
																											; Print character pixels, no more.
PChr		ldx	blkPtr						; get blocks pointer
			stx	<fontPtr						; pass to used variable
PChr0		jsr	PChar							; print char in regA								; pchr   call pchar          ; show character in accumulator.
			ldx	#font-256					; point to fonts table																	
			stx	<fontPtr						; save into pointer								; 		 ld hl,dispy         ; y coordinate.
			inc	<dispX							; move to next char								; 		 inc (hl)            ; move along one.
			rts									; return												; 		 ret

	IF AFLAG																								; .if aflag
WBloc												; Write BLOCK										; wbloc:
			ldx	<pbPtr							; get write pointer								; ldy	#3
			sta	3,x							; store block number								; sta	(pbptr),y        ; store block number
																											; dey
			lda	<dispX							; get Y position									; lda	dispx
			sta	2,x							; write Y block position						; sta	(pbptr),y        ; write x position of block.
																											; dey
			lda	<dispY							; get X position									; lda	dispy
			sta	1,x							; write X block position						; sta	(pbptr),y        ; write y position of block.
																											; dey
			lda	scNo							; get screen number								; lda	scno
			sta	,x								; write screen number							; sta	(pbptr),y        ; write screen.
																											; clc            ; point to next free location
																											; lda	pbptr
			leax	4,x							; point to next bloc								; adc	#4
																											; sta	pbptr
																											; bcc	:
			stx	<pbPtr							; update pointer									; inc	pbptr+1
			rts									; return												;:			rts
	ENDIF																									; .endif
; ------------------------------------------------------------------------------------------------------------------------------------------
; Shifter sprite routine for objects															; Shifter sprite routine for objects.
; ------------------------------------------------------------------------------------------------------------------------------------------
Sprit7	eora	#7								; invert thre low bits							; sprit7 xor 7
			inca									; add one											; 		 inc a
Sprit3	rol	<reg_L						; shift into position							; sprit3 rl l                ; shift into position.
			rol	<reg_C						; the 3												; 		 rl c
			rol	<reg_H						; bytes												; 		 rl h
			deca									; decrement counter								; 		 dec a               ; one less iteration.
			bne	Sprit3						; not zero, shift again							; 		 jp nz,sprit3
			lda	<reg_L						; get reg_L											; 		 ld a,l
			ldb	<reg_C						; pass reg_C
			stb	<reg_L						; to reg_L											; 		 ld l,c
			ldb	<reg_H						; pass reg_H
			stb	<reg_C						; to reg_C											; 		 ld c,h
			sta	<reg_H						; save to reg_H									; 		 ld h,a
			bra	Sprit0						; apply to screen									; 		 jp sprit0           ; now apply to screen.
; ------------------------------------------------------------------------------------------------------------------------------------------
Sprite	pshs	x								; save graphic address							; sprite push hl             ; store sprite graphic address.
			jsr	ScAdd							; get screen address in regX					; 		 call scadd          ; get screen address in hl.
			leau	,x								; pass to regU										; 		 ex de,hl            ; switch to de.
			puls	x								; restore regX										; 		 pop hl              ; restore graphic address.
			lda	<dispY							; get posY											; 		 ld a,(dispy)        ; y position.
			anda	#7								; use only 3 low bits							; 		 and 7               ; position straddling cells.
			sta	<reg_B						; save in reg_B									; 		 ld b,a              ; store in b register.
			lda	#16							; number of rows									; 		 ld a,16             ; pixel height.
Sprit1	sta	<reg_AF						; save to reg_A									; sprit1 ex af,af'
			lda	,x+							; fetch 1st byte									; 		 ld c,(hl)           ; fetch first byte.
			sta	<reg_C						; to reg_C											; 		 inc hl              ; next byte.
			pshs	x								; save regX into stack							; 		 push hl             ; store source address.
			ldb	,x								; get low byte										; 		 ld l,(hl)
			clra									; zero for high byte								; 		 ld h,0
			std	<reg_HL						; pass to reg_HL									; 		 ld a,b              ; position straddling cells.
			lda	<reg_B						; restore reg_B									; 		 and a               ; is it zero?
			beq	Sprit0						; if zero, apply to screen						; 		 jr z,sprit0         ; yes, apply to screen.
			cmpa	#5								; is it lower than 6?							; 		 cp 5
			bcc	Sprit7						; yes, go shift it								; 		 jr nc,sprit7
			andcc	#%11111110					; clear carry										; 		 and a               ; clear carry.
Sprit2	ror	<reg_C						; shift												; sprit2 rr c
			ror	<reg_L						; into												; 		 rr l
			ror	<reg_H						; position											; 		 rr h
			deca									; decrement counter								; 		 dec a
			bne	Sprit2						; not zero, shift again							; 		 jp nz,sprit2
Sprit0	lda	,u								; get byte from screen							; sprit0 ld a,(de)           ; fetch screen image.
			eora	<reg_C						; merge with graphic								; 		 xor c               ; merge with graphic.
			sta	,u+							; write to screen									; 		 ld (de),a           ; write to screen.
																											; 		 inc e               ; next screen byte.
			lda	,u								; fetch next screen byte						; 		 ld a,(de)           ; fetch screen image.
			eora	<reg_L						; merge with graphic								; 		 xor l               ; combine with graphic.
			sta	,u+							; write to screen									; 		 ld (de),a           ; write to screen.
																											; 		 inc de              ; next screen address.
			lda	,u								; fetch next screen byte						; 		 ld a,(de)           ; fetch screen image.
			eora	<reg_H						; merge with graphic								; 		 xor h               ; combine with graphic.
			sta	,u								; write to screen									; 		 ld (de),a           ; write to screen.
																											; 		 dec e               ; back to start byte.
			leau	32-2,u						; point to beginning of next row				; 		 inc d               ; increment line number.
													; no segments in 6809 Screen Map				; 		 ld a,d              ; segment address.
																											; 		 and 7               ; reached end of segment?
																											; 		 jp nz,sprit6        ; no, just do next line within cell.
																											; 		 ld a,e              ; low byte.
																											; 		 add a,32            ; look down.
																											; 		 ld e,a              ; new address.
																											; 		 jp c,sprit6         ; done.
																											; 		 ld a,d              ; high byte.
																											; 		 sub 8               ; start of segment.
																											; 		 ld d,a              ; new high byte.
Sprit6	puls	x								; restore graphic address						; sprit6 pop hl              ; restore source address.
			leax	1,x							; point to next source byte					; 		 inc hl              ; next source byte.
			lda	<reg_AF						; restore row counter							; 		 ex af,af'
			deca									; decrement it										; 		 dec a
			bne	Sprit1						; not zero, loopback								; 		 jp nz,sprit1
			rts									; return												; 		 ret
; ------------------------------------------------------------------------------------------------------------------------------------------
; Get room address																					; Get room address
; ------------------------------------------------------------------------------------------------------------------------------------------
GRoom		lda	scNo							; get screen number								; groom  ld a,(scno)         ; screen number.
			pshs	a								; save in stack
GRoomX	ldu	#$0000						; value zero										; groomx ld de,0             ; start at zero.
			ldx	scrPtr						; point to screens table						; 		 ld hl,(scrptr)      ; pointer to screens.
			tsta									; was the first room?							; 		 and a               ; is it the first one?
GRoom1	beq	GRoom0						; yes, skip no more screens					; groom1 jr z,groom0         ; no more screens to skip.
			ldd	,x++							; get screen size (16 bits)					; 		 ld c,(hl)           ; low byte of screen size.
																											; 		 inc hl              ; point to high byte.
																											; 		 ld b,(hl)           ; high byte of screen size.
																											; 		 inc hl              ; next address.
																											; 		 ex de,hl            ; put total in hl, pointer in de.
			leau	d,u							; add to regU										; 		 add hl,bc           ; skip a screen.
																											; 		 ex de,hl            ; put total in de, pointer in hl.
			dec	,s								; decrement room counter						; 		 dec a               ; one less iteration.
			bra	GRoom1						; loop back											; 		 jr groom1           ; loop until we reach the end.
GRoom0	ldx	scrPtr						; point to screens table						; groom0 ld hl,(scrptr)      ; pointer to screens.
			tfr	u,d							; pass offset to regD
			leax	d,x							; add offset to pointer							; 		 add hl,de           ; add displacement.
			ldb	numSc							; get number of screens							; 		 ld a,(numsc)        ; number of screens.
			clra									; convert to 16 bits value						; 		 ld d,0              ; zeroise high byte.
																											; 		 ld e,a              ; displacement in de.
			leax	d,x							; skip the screens								; 		 add hl,de           ; add double displacement to address.
			leax	d,x							; length at the beginning						; 		 add hl,de
			puls	a,pc							; discard regA and return						; 		 ret
; ------------------------------------------------------------------------------------------------------------------------------------------
; Draw present room																					; Draw present room.
; ------------------------------------------------------------------------------------------------------------------------------------------
DRoom		lda	winTop						; get top of window								; droom  ld a,(wintop)       ; window top.
			sta	<dispY							; put in Y coordinate							; 		 ld (dispx),a        ; set x coordinate.
DRoom2	ldx	blkPtr						; point to blocks table							; droom2 ld hl,(blkptr)      ; blocks.
			stx	<grBase						; copy to variable								; 		 ld (grbase),hl      ; set graphics base.
			jsr	GRoom							; get address of current room					; 		 call groom          ; get address of current room.
			clra									; value zero										; 		 xor a               ; zero in accumulator.
			sta	<comCnt						; int compression counter						; 		 ld (comcnt),a       ; reset compression counter.
			lda	winHgt						; get window height								; 		 ld a,(winhgt)       ; height of window.
DRoom0	pshs	a								; pass row counter into stack					; droom0 push af             ; store row counter.
			lda	winLft						; get window left edge							; 		 ld a,(winlft)       ; window left edge.
			sta	<dispX							; put in X coordinate							; 		 ld (dispy),a        ; set cursor position.
			lda	winWid						; get width of window							; 		 ld a,(winwid)       ; width of window.
DRoom1	pshs	a								; pass column counter into stack				; droom1 push af             ; store column counter.
			
			jsr	FlByt							; decompress next screen byte					; 		 call flbyt          ; decompress next byte on the fly.
			pshs	x								; save pointer										; 		 push hl             ; store address of cell.
			jsr	PAttr2						; show block (no attributes in 6809)		; 		 call pattr          ; show attributes and block.
			puls	x								; restore pointer									; 		 pop hl              ; restore cell address.
			puls	a								; restore column counter						; 		 pop af              ; restore loop counter.
			deca									; decrement it										; 		 dec a               ; one less column.
			bne	DRoom1						; not yet done? loop for next block			; 		 jr nz,droom1        ; repeat for entire line.
			inc	<dispY							; increment Y coordinate						; 		 ld a,(dispx)        ; x coord.
																											; 		 inc a               ; move down one line.
																											; 		 ld (dispx),a        ; set new position.
			puls	a								; restore row counter							; 		 pop af              ; restore row counter.
			deca									; decrement it										; 		 dec a               ; one less row.
			bne	DRoom0						; not yet done? loopback						; 		 jr nz,droom0        ; repeat for all rows.
			rts									; return												; 		 ret
; ------------------------------------------------------------------------------------------------------------------------------------------
; Decompress bytes on-the-fly																		; Decompress bytes on-the-fly
; regX points to blocks  -  returns block in regA and repetitions in comCnt
; ------------------------------------------------------------------------------------------------------------------------------------------
FlByt		lda	<comCnt						; get compression counter						; flbyt  ld a,(comcnt)       ; compression counter.
																											; 		 and a               ; any more to decompress?
			bne	FlByt1						; if not zero, decompress and exit			; 		 jr nz,flbyt1        ; yes.
			lda	,x+							; else get a byte									; 		 ld a,(hl)           ; fetch next byte.
																											; 		 inc hl              ; point to next cell.
			cmpa	#255							; is a control code?								; 		 cp 255              ; is this byte a control code?
			bne	FlByEx						; no, exit, it is uncompressed				; 		 ret nz              ; no, this byte is uncompressed.
			lda	,x+							; get next byte									; 		 ld a,(hl)           ; fetch byte type.
			sta	<comByt						; save in variable								; 		 ld (combyt),a       ; set up the type.
																											; 		 inc hl              ; point to quantity.
			lda	,x+							; get next byte									; 		 ld a,(hl)           ; get quantity.
																											; 		 inc hl              ; point to next byte.
FlByt1	deca									; decrement byte value by one					; flbyt1 dec a               ; one less.
			sta	<comCnt						; save as number of repetitons				; 		 ld (comcnt),a       ; store new quantity.
			lda	<comByt						; get byte to be expanded						; 		 ld a,(combyt)       ; byte to expand.
FlByEx	rts									; return												; 		 ret
; ------------------------------------------------------------------------------------------------------------------------------------------
; Ladder down check																					; Ladder down check.
; ------------------------------------------------------------------------------------------------------------------------------------------
LaddD		ldb	8,y																					; laddd  ld a,(ix+8)         ; x coordinate.
			andb	#254																					; 		 and 254             ; make it even.
			stb	8,y																					; 		 ld (ix+8),a         ; reset it.
			lda	9,y																					; 		 ld h,(ix+9)         ; y coordinate.
NumSp5	addb	#16																					; numsp5 add a,16            ; look down 16 pixels.
			std	<reg_HL																				; 		 ld l,a              ; coords in hl.
			bra	LaddV																					; 		 jr laddv
; ------------------------------------------------------------------------------------------------------------------------------------------
; Ladder up check																						; Ladder up check.
; ------------------------------------------------------------------------------------------------------------------------------------------
LaddU		ldb	8,y																					; laddu  ld a,(ix+8)         ; x coordinate.
			andb	#254																					; 		 and 254             ; make it even.
			stb	8,y																					; 		 ld (ix+8),a         ; reset it.
			lda	9,y																					; 		 ld h,(ix+9)         ; y coordinate.
NumSp6	addb	#14																					; numsp6 add a,14            ; look 2 pixels above feet.
			std	<reg_HL																				; 		 ld l,a              ; coords in hl.
LaddV		exg	a,b
			std	<dispX																					; laddv  ld (dispx),hl       ; set up test coordinates.
			jsr	TstBl																					; 		 call tstbl          ; get map address.
			jsr	LdChk																					; 		 call ldchk          ; standard ladder check.
			bne	LaddUEx																				; 		 ret nz              ; no way through.
			ldx	<reg_HL
			leax	1,x
			stx	<reg_HL																				; 		 inc hl              ; look right one cell.
			jsr	LdChk																					; 		 call ldchk          ; do the check.
			bne	LaddUEx																				; 		 ret nz              ; impassable.
			lda	<dispY																					; 		 ld a,(dispy)        ; y coordinate.
			anda	#7																						; 		 and 7               ; position straddling block cells.
			beq	LaddUEx																				; 		 ret z               ; no more checks needed.
			ldx	<reg_HL
			leax	1,x
			stx	<reg_HL																				; 		 inc hl              ; look to third cell.
			jsr	LdChk																					; 		 call ldchk          ; do the check.
LaddUEx	rts																							; 		 ret                 ; return with zero flag set accordingly.
; ------------------------------------------------------------------------------------------------------------------------------------------
; Can go up check																						; Can go up check.
; ------------------------------------------------------------------------------------------------------------------------------------------
CanGU		ldy	<reg_IX
			ldb	8,y																					; cangu  ld a,(ix+8)         ; x coordinate.
			lda	9,y																					; 		 ld h,(ix+9)         ; y coordinate.
			subb	#2																						; 		 sub 2               ; look up 2 pixels.
			std	<reg_HL																				; 		 ld l,a              ; coords in hl.
			stb	<dispX																					; 		 ld (dispx),hl       ; set up test coordinates.
			sta	<dispY
			jsr	TstBl																					; 		 call tstbl          ; get map address.
			jsr	LRChk																					; 		 call lrchk          ; standard left/right check.
			bne	CanGUex																				; 		 ret nz              ; no way through.
			ldd	<reg_HL
			addd	#1																						; 		 inc hl              ; look right one cell.
			std	<reg_HL
			jsr	LRChk																					; 		 call lrchk          ; do the check.
			bne	CanGUex																				; 		 ret nz              ; impassable.
			lda	<dispY																					; 		 ld a,(dispy)        ; y coordinate.
			anda	#7																						; 		 and 7               ; position straddling block cells.
			beq	CanGUex																				; 		 ret z               ; no more checks needed.
			ldd	<reg_HL
			addd	#1																						; 		 inc hl              ; look to third cell.
			std	<reg_HL
			jsr	LRChk																					; 		 call lrchk          ; do the check.
CanGUex	rts																							; 		 ret                 ; return with zero flag set accordingly.
; ------------------------------------------------------------------------------------------------------------------------------------------
; Can go down check																					; Can go down check.
; here regX contains reg_IX
; ------------------------------------------------------------------------------------------------------------------------------------------
CanGD		ldy	<reg_IX
			ldb	8,y																					; cangd  ld a,(ix+8)         ; x coordinate.
			lda	9,y																					; 		 ld h,(ix+9)         ; y coordinate.
			addb	#16																					; numsp3 add a,16            ; look down 16 pixels.
			std	<reg_HL																				; 		 ld l,a              ; coords in hl.
			stb	<dispX																					; 		 ld (dispx),hl       ; set up test coordinates.
			sta	<dispY
			jsr	TstBl 																				; 		 call tstbl          ; get map address.
			jsr	PlChk																					; 		 call plchk          ; block, platform check.
			bne	CanGDex																				; 		 ret nz              ; no way through.
			ldd	<reg_HL
			addd	#1																						; 		 inc hl              ; look right one cell.
			std	<reg_HL
			jsr	PlChk																					; 		 call plchk          ; block, platform check.
			bne	CanGDex																				; 		 ret nz              ; impassable.
			lda	<dispY																					; 		 ld a,(dispy)        ; y coordinate.
			anda	#7																						; 		 and 7               ; position straddling block cells.
			beq	CanGDex																				; 		 ret z               ; no more checks needed.
			ldd	<reg_HL
			addd	#1																						; 		 inc hl              ; look to third cell.
			std	<reg_HL
			jsr	PlChk																					; 		 call plchk          ; block, platform check.
CanGDex	rts																							; 		 ret                 ; return with zero flag set accordingly.
; ------------------------------------------------------------------------------------------------------------------------------------------
; Can go left check																					; Can go left check.
; ------------------------------------------------------------------------------------------------------------------------------------------
CanGL		ldy	<reg_IX
			ldb	8,y																					; cangl  ld l,(ix+8)         ; x coordinate.
			lda	9,y																					; 		 ld a,(ix+9)         ; y coordinate.
			suba	#2																						; 		 sub 2               ; look left 2 pixels.
			std	<reg_HL																				; 		 ld h,a              ; coords in hl.
			bra	CanGH																					; 		 jr cangh            ; test if we can go there.
; ------------------------------------------------------------------------------------------------------------------------------------------
; Can go right check																					; Can go right check.
; ------------------------------------------------------------------------------------------------------------------------------------------
CanGR		ldy	<reg_IX
			ldb	8,y																					; cangr  ld l,(ix+8)         ; x coordinate.
			lda	9,y																					; 		 ld a,(ix+9)         ; y coordinate.
			adda	#16																					; 		 add a,16            ; look right 16 pixels.
			std	<reg_HL																				; 		 ld h,a              ; coords in hl.
CanGH		stb	<dispX																					; cangh  ld (dispx),hl       ; set up test coordinates.
			sta	<dispY
CanGh2	ldb	#3
			stb	<reg_B																				; cangh2 ld b,3              ; default rows to write.
			lda	<reg_L																				; 		 ld a,l              ; x position.
			anda	#7																						; 		 and 7               ; does x straddle cells?
			bne	CanGh0																				; 		 jr nz,cangh0        ; yes, loop counter is good.
			dec	<reg_B																				; 		 dec b               ; one less row to write.
CanGh0	jsr	TstBl																					; cangh0 call tstbl          ; get map address.
																											; 		 ld de,32            ; distance to next cell.
CanGh1	jsr	LRChk																					; cangh1 call lrchk          ; standard left/right check.
			bne	CanGRex																				; 		 ret nz              ; no way through.
			ldx	<reg_HL
			leax	32,x																					; 		 add hl,de           ; look down.
			stx	<reg_HL
			dec	<reg_B
			bne	CanGh1																				; 		 djnz cangh1
CanGRex	rts																							; 		 ret
; ------------------------------------------------------------------------------------------------------------------------------------------
; Check left/right movement is okay																; Check left/right movement is okay.
; ------------------------------------------------------------------------------------------------------------------------------------------
LRChk		lda	[reg_HL]																				; lrchk  ld a,(hl)           ; fetch map cell.
			cmpa	#WALL																					; 		 cp WALL             ; is it passable?
			beq	LRChkX																				; 		 jr z,lrchkx         ; no.
			cmpa	#FODDER																				; 		 cp FODDER           ; fodder has to be dug.
			beq	LRChkX																				; 		 jr z,lrchkx         ; not passable.
Always	clra																							; always xor a               ; report it as okay.
			rts																							; 		 ret
LRChkX	clra																							; lrchkx xor a               ; reset all bits.
			inca																							; 		 inc a
			rts																							; 		 ret
; ------------------------------------------------------------------------------------------------------------------------------------------
; Check platform or solid item is not in way													; Check platform or solid item is not in way.
; ------------------------------------------------------------------------------------------------------------------------------------------
PlChk		lda	[reg_HL]																				; plchk  ld a,(hl)           ; fetch map cell.
			cmpa	#WALL																					; 		 cp WALL             ; is it passable?
			beq	LRChkX																				; 		 jr z,lrchkx         ; no.
			cmpa	#FODDER																				; 		 cp FODDER           ; fodder has to be dug.
			beq	LRChkX																				; 		 jr z,lrchkx         ; not passable.
			cmpa	#PLATFM																				; 		 cp PLATFM           ; platform is solid.
			beq	PlChkX																				; 		 jr z,plchkx         ; not passable.
			cmpa	#LADDER																				; 		 cp LADDER           ; is it a ladder?
			beq	LRChkX																				; 		 jr z,lrchkx         ; on ladder, deny movement.
PlChk0	clra																							; plchk0 xor a               ; report it as okay.
			rts																							; 		 ret
PlChkX	lda	<dispX																					; plchkx ld a,(dispx)        ; x coordinate.
			anda	#7																						; 		 and 7               ; position straddling blocks.
			beq	LRChkX																				; 		 jr z,lrchkx         ; on platform, deny movement.
			bra	PlChk0																				; 		 jr plchk0
; ------------------------------------------------------------------------------------------------------------------------------------------
; Check ladder is available																		; Check ladder is available.
; ------------------------------------------------------------------------------------------------------------------------------------------
LdChk		lda	[reg_HL]																				; ldchk  ld a,(hl)           ; fetch cell.
			cmpa	#LADDER																				; 		 cp LADDER           ; is it a ladder?
			rts																							; 		 ret                 ; return with zero flag set accordingly.
; ------------------------------------------------------------------------------------------------------------------------------------------
																											; Get collectables.
; ------------------------------------------------------------------------------------------------------------------------------------------
																											; getcol ld b,COLECT         ; collectable blocks.
																											; 		 call tded           ; test for collectable blocks.
																											; 		 cp b                ; did we find one?
																											; 		 ret nz              ; none were found, job done.
																											; 		 call gtblk          ; get block.
																											; 		 call evnt20         ; collected block event.
																											; 		 jr getcol           ; repeat until none left.
; ------------------------------------------------------------------------------------------------------------------------------------------
																											; Get collectable block.
; ------------------------------------------------------------------------------------------------------------------------------------------
																											; gtblk  ld (hl),0           ; make it empty now.
																											; 		 ld de,MAP           ; map address.
																											; 		 and a               ; clear carry.
																											; 		 sbc hl,de           ; find cell number.
																											; 		 ld a,l              ; get low byte of cell number.
																											; 		 and 31              ; 0 - 31 is column.
																											; 		 ld d,a              ; store y in d register.
																											; 		 add hl,hl           ; multiply by 8.
																											; 		 add hl,hl
																											; 		 add hl,hl           ; x is now in h.
																											; 		 ld e,h              ; put x in e.
																											; 		 ld (dispx),de       ; set display coordinates.
																											; 		 ld hl,(blkptr)      ; blocks.
																											; 		 ld (grbase),hl      ; set graphics base.
																											; 		 xor a               ; block zero.
																											; 		 jp pattr            ; display block on screen.
; ------------------------------------------------------------------------------------------------------------------------------------------
; Touched deadly block check																		; Touched deadly block check.
; Returns with DEADLY (must be non-zero) in accumulator if true						; Returns with DEADLY (must be non-zero) in accumulator if true.
; ------------------------------------------------------------------------------------------------------------------------------------------
TDed		ldd	8,y																					; tded   ld l,(ix+8)         ; x coordinate.
			std	<dispX																					; 		 ld h,(ix+9)         ; y coordinate.
			exg	a,b							; dispX receives bytes inverted				; 		 ld (dispx),hl       ; set up test coordinates.
			std	<reg_HL
			jsr	TstBl																					; 		 call tstbl          ; get map address.
			ldu	#31																					; 		 ld de,31            ; default distance to next line down.
			stu	<reg_DE
			cmpa	<reg_B																				; 		 cp b                ; is this the required block?
			beq	TDedEx																				; 		 ret z               ; yes.
			ldx	<reg_HL
			leax	1,x																					; 		 inc hl              ; next cell.
			lda	,x																						; 		 ld a,(hl)           ; fetch type.
			cmpa	<reg_B																				; 		 cp b                ; is this deadly/custom?
			beq	TDedEx																				; 		 ret z               ; yes.
			lda	<dispY																					; 		 ld a,(dispy)        ; horizontal position.
			sta	<reg_C																				; 		 ld c,a              ; store column in c register.
			anda	#7																						; 		 and 7               ; is it straddling cells?
			beq	TDed0																					; 		 jr z,tded0          ; no.
			leax	1,x																					; 		 inc hl              ; last cell.
			lda	,x																						; 		 ld a,(hl)           ; fetch type.
			cmpa	<reg_B																				; 		 cp b                ; is this the block?
			beq	TDedEx																				; 		 ret z               ; yes.
			leau	-1,u																					; 		 dec de              ; one less cell to next row down.
			stu	<reg_DE
TDed0		ldd	<reg_DE
			leax	d,x																					; tded0  add hl,de           ; point to next row.
			lda	,x																						; 		 ld a,(hl)           ; fetch left cell block.
			cmpa	<reg_B																				; 		 cp b                ; is this fatal?
			beq	TDedEx																				; 		 ret z               ; yes.
			leax	1,x																					; 		 inc hl              ; next cell.
			lda	,x																						; 		 ld a,(hl)           ; fetch type.
			cmpa	<reg_B																				; 		 cp b                ; is this fatal?
			beq	TDedEx																				; 		 ret z               ; yes.
			lda	<reg_C																				; 		 ld a,c              ; horizontal position.
			anda	#7																						; 		 and 7               ; is it straddling cells?
			beq	TDed1																					; 		 jr z,tded1          ; no.
			leax	1,x																					; 		 inc hl              ; last cell.
			lda	1,x																					; 		 ld a,(hl)           ; fetch type.
			cmpa	<reg_B																				; 		 cp b                ; is this fatal?
			beq	TDedEx																				; 		 ret z               ; yes.
TDed1		lda	<dispX																					; tded1  ld a,(dispx)        ; vertical position.
			anda	#7																						; 		 and 7               ; is it straddling cells?
			beq	TDedEx																				; 		 ret z               ; no, job done.
			ldd	<reg_DE
			leax	d,x																					; 		 add hl,de           ; point to next row.
			lda	,x																						; 		 ld a,(hl)           ; fetch left cell block.
			cmpa	<reg_B																				; 		 cp b                ; is this fatal?
			beq	TDedEx																				; 		 ret z               ; yes.
			leax	1,x																					; 		 inc hl              ; next cell.
			lda	,x																						; 		 ld a,(hl)           ; fetch type.
			cmpa	<reg_B																				; 		 cp b                ; is this fatal?
			beq	TDedEx																				; 		 ret z               ; yes.
			lda	<reg_C																				; 		 ld a,c              ; horizontal position.
			anda	#7																						; 		 and 7               ; is it straddling cells?
			beq	TDedEx																				; 		 ret z               ; no.
			leax	1,x																					; 		 inc hl              ; last cell.
			lda	,x																						; 		 ld a,(hl)           ; fetch final type.
TDedEx	stx	<reg_HL
			rts																							; 		 ret                 ; return with final type in accumulator.
; ------------------------------------------------------------------------------------------------------------------------------------------
; Fetch block type at (dispx, dispy)															; Fetch block type at (dispx, dispy).
; ------------------------------------------------------------------------------------------------------------------------------------------
TstBl		lda	<dispX																					; tstbl  ld a,(dispx)        ; fetch x coord.
			asla																							; 		 rlca                ; divide by 8,
			bcc	1f
			ora	#1
1			asla																							; 		 rlca                ; and multiply by 32.
			bcc	2f
			ora	#1
2			sta	<reg_D																				; 		 ld d,a              ; store in d.
			anda	#224																					; 		 and 224             ; mask off high bits.
			sta	<reg_E																				; 		 ld e,a              ; low byte.
			lda	<reg_D																				; 		 ld a,d              ; restore shift result.
			anda	#3																						; 		 and 3               ; high bits.
			sta	<reg_D																				; 		 ld d,a              ; got displacement in de.
			lda	<dispY																					; 		 ld a,(dispy)        ; y coord.
			rora																							; 		 rra                 ; divide by 8.
			rora																							; 		 rra
			rora																							; 		 rra
			anda	#31																					; 		 and 31              ; only want 0 - 31.
			adda	<reg_E																				; 		 add a,e             ; add to displacement.
			sta	<reg_E																				; 		 ld e,a              ; displacement in de.
			pshs	x
			ldx	#MAP																					; 		 ld hl,MAP           ; position of dummy screen.
			ldd	<reg_DE																				; 		 add hl,de           ; point to address.
			leax	d,x																					
			stx	<reg_HL
			lda	,x																						; 		 ld a,(hl)           ; fetch byte there.
			puls	x,pc																					; 		 ret
; ------------------------------------------------------------------------------------------------------------------------------------------
																											; Jump - if we can.
																											; Requires initial speed to be set up in accumulator prior to call.
; ------------------------------------------------------------------------------------------------------------------------------------------
																											; jump   neg                 ; switch sign so we jump up.
																											; 		 ld c,a              ; store in c register.
																											; ;       ld a,(ix+8)         ; x coordinate.
																											; ;       ld h,(ix+9)         ; y coordinate.
																											; ;numsp4 add a,16            ; look down 16 pixels.
																											; ;       ld l,a              ; coords in hl.
																											; ;       and 7               ; are we on platform boundary?
																											; ;       ret nz              ; no, cannot jump.
																											; ;       ld (dispx),hl       ; set up test coordinates.
																											; ;       ld b,a              ; copy to b register.
																											; ;       call tstbl          ; get map address.
																											; ;       call plchk          ; block, platform check.
																											; ;       jr nz,jump0         ; it's solid, we can jump.
																											; ;       inc hl              ; look right one cell.
																											; ;       call plchk          ; block, platform check.
																											; ;       jr nz,jump0         ; it's solid, we can jump.
																											; ;       ld a,b              ; y coordinate.
																											; ;       and 7               ; position straddling block cells.
																											; ;       ret z               ; no more checks needed.
																											; ;       inc hl              ; look to third cell.
																											; ;       call plchk          ; block, platform check.
																											; ;       ret z               ; not solid, don't jump.
																											; jump0  ld a,(ix+13)        ; jumping flag.
																											; 		 and a               ; is it set?
																											; 		 ret nz              ; already in the air.
																											; 		 inc (ix+13)         ; set it.
																											; 		 ld (ix+14),c        ; set jump height.
																											; 		 ret
																											; 
Hop		tst	13,y																					; hop    ld a,(ix+13)        ; jumping flag.
																											; 		 and a               ; is it set?
			bne	HopEx																					; 		 ret nz              ; already in the air.
			ldd	#$ff00																				; 		 ld (ix+13),255      ; set it.
			std	13,y																					; 		 ld (ix+14),0        ; set jump table displacement.
HopEx		rts																							; 		 ret
; ------------------------------------------------------------------------------------------------------------------------------------------
																											; Random numbers code.
																											; Pseudo-random number generator, 8-bit.
; ------------------------------------------------------------------------------------------------------------------------------------------
																											; random ld hl,seed          ; set up seed pointer.
																											; 		 ld a,(hl)           ; get last random number.
																											; 		 ld b,a              ; copy to b register.
																											; 		 rrca                ; multiply by 32.
																											; 		 rrca
																											; 		 rrca
																											; 		 xor 31
																											; 		 add a,b
																											; 		 sbc a,255
																											; 		 ld (hl),a           ; store new seed.
																											; 		 ld (varrnd),a       ; return number in variable.
																											; 		 ret
; ------------------------------------------------------------------------------------------------------------------------------------------
; Keyboard test routine. 																			; Keyboard test routine.
; ------------------------------------------------------------------------------------------------------------------------------------------
KTest		sta	$ff02							; send to keyboard								; ktest  ld c,a              ; key to test in c.
			lda	$ff00							; read rows											; 		 and 7               ; mask bits d0-d2 for row.
			ldb	scanOff						; get offset to codes							; 		 inc a               ; in range 1-8.
			bita	b,x							; is that bit zero (key pressed)?			; 		 ld b,a              ; place in b.
			bne	ScanK01						; no, clear carry									; 		 srl c               ; divide c by 8
			orcc	#%00000001					; yes, set carry									; 		 srl c               ; to find position within row.
			fcb	$8c							; skip next											; 		 srl c
ScanK01	andcc	#%11111110					; reset carry flag								; 		 ld a,5              ; only 5 keys per row.
																											; 		 sub c               ; subtract position.
																											; 		 ld c,a              ; put in c.
																											; 		 ld a,254            ; high byte of port to read.
																											; ktest0 rrca                ; rotate into position.
																											; 		 djnz ktest0         ; repeat until we've found relevant row.
																											; 		 in a,(254)          ; read port (a=high, 254=low).
																											; ktest1 rra                 ; rotate bit out of result.
																											; 		 dec c               ; loop counter.
																											; 		 jp nz,ktest1        ; repeat until bit for position in carry.
			rts									; return												; 		 ret
; ------------------------------------------------------------------------------------------------------------------------------------------
; Joystick and keyboard reading routines (Joystick if regA=1, else Keyboard) 		; Joystick and keyboard reading routines
; ------------------------------------------------------------------------------------------------------------------------------------------
JoyKey	lda	<contrl						; get kind of control							; joykey ld a,(contrl)       ; control flag.
			deca									; is it 1?											; 		 dec a               ; is it the keyboard?
			beq	JoyJoy						; yes, process Joystick							; 		 jr z,joyjoy         ; no, it's Kempston joystick.
													; only one kind of Joystick					; 		 dec a               ; Sinclair?
																											; 		 jr z,joysin         ; read Sinclair joystick.
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
; Keyboard controls.																					; Keyboard controls.
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
			ldb	#7								; number of keys to be read
			pshs	b								; pshs counter
			ldx	#keys+6+1					; point to last key in table					; 		 ld hl,keys+6        ; address of last key.
JoyNoCC	clr	<reg_E						; reset bits in output register				; 		 ld e,0              ; zero reading.
																											; 		 ld d,7              ; keys to read.
JoyKe0	lda	,-x							; get value from table							; joyke0 ld a,(hl)           ; get key from table.
			bsr	KTest																					; 		 call ktest          ; being pressed?
		 	rol	<reg_E						; shift into output register																											; 		 ccf                 ; complement the carry.
																											; 		 rl e                ; rotate into reading.
			dec	,s								; done all keys?									; 		 dec d               ; one less to do.
			bne	JoyKe0						; no, loopback										; 		 jp nz,joyke0        ; repeat for all keys.
			leas	1,s							; get rid of counter
			lbra	JoyJo1						; go store value									; 		 jr joyjo1           ; store the value.
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
;					 P	  O	A	 Q	 spc  Z	 I	  1	2	 3	  4
keys		fcb	$fe,$7f,$fd,$fd,$7f,$fb,$fd,$fd,$fb,$f7,$ef		; mask to the keyboard columns (only one zero)
keysD		fcb	$10,$08,$04,$10,$20,$20,$08,$01,$01,$01,$01		; expected bit to be zero (Dragon)
keysC		fcb	$04,$02,$01,$04,$08,$08,$02,$10,$10,$10,$10		; expected bit to be zero (CoCo)
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
; Joystick controls	- special for 6809 machines (using 6 bit DAC)
; besides the 2 axis (UD, LR) and button, KEYS 'Z' and 'I' must be checked
; defines three zones: UP or LEFT  	 (00-25) - 40%
;							  NEUTRAL    	 (26-37) - 20%
;							  DOWN or RIGHT (38-63) - 40%
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
												; fills variables $015a-$015b (X - Y axis right joystick)
JoyJoy	lbsr	AudiOff						; turn off audio
			leas	-3,s							; 3 bytes for counters
			ldx	#$015c						; point to end of right joystick table
			ldb	#$01							; axis to read -1 (right joystick)
RdJyAx	lda	#$0a							; max number of tries
			std	1,s							; save counters
			bsr	MuxBits						; set both bits
RdJyDo	ldd	#$4080						; $80 first value to DAC, $40 increment
RdJy00	sta	,s								; save 'step'
			orb	#2								; keep RS232 serial out marking
			stb	$ff20							; send 'start' to DAC
			eorb	#2								; put RS232 back to zero
			tst	$ff00							; read data from joystick
			bmi	RdJy01						; data sent too big?
			subb	,s								; deduct step value
			fcb	$8c							; skip next
RdJy01	addb	,s								; add step
			lsra									; logarithmic search (or binary search?)
			cmpa	#1								; lowest step value?
			bne	RdJy00						; not yet
			lsrb									; value in b2-b7
			lsrb									; to b0-b5
			cmpb	-1,x							; compare to last value
			beq	RdSame						; same value twice
			dec	1,s							; debouncing
			bne	RdJyDo						; redetermine
RdSame	stb	,-x							; save value in table
			ldb	2,s							; number of axis
			decb									; decrement it
			bpl	RdJyAx						; next axis
			clr	$ff20							; avoid sound spikes
			bsr	AudiOn						; set audio on again
			leas	3,s							; clean stack
			clr	<reg_E						; result to zero
												; process special keys 'I','Z'
			ldx	#keys+6						; point to values table
			lda	,x								; get column value for 'I' (64)
			lbsr	KTest							; test for it
		 	rol	<reg_E						; shift into output register
		 	lda	,-x							; get colun value for 'Z' (32)
			lbsr	KTest							; test for it
		 	rol	<reg_E						; shift into output register
		 										; process button 
			andcc	#%11111110					; clear carry
			lda	$ff00							; is button of right Joystick pressed (16)?
			bita	#1								; bit0 is the value (0=YES)
			bne	PutButt						; not pressed
			orcc	#%00000001					; set carry (button is pressed)
PutButt	rol	<reg_E						; shift into output register
												; process 2 axis
JoyAxis	lda	>$015b						; get Y axis value
			cmpa	#26							; is it move Up? (less than 26)
			rol	<reg_E						; puts 1 if it was up (08)
			lda	#37							; is it Down? (greater than 37)
			cmpa	>$015b						; compare to Y axis
			rol	<reg_E						; puts 1 if it was down (04)
			lda	>$015a						; get X axis value
			cmpa	#26							; is it move Left? (less than 26)
			rol	<reg_E						; puts 1 if it was right (02)
			lda	#37							; is it move Right? (greater than 37)
			cmpa	>$015a						; compare to X axis
			rol	<reg_E						; puts 1 if it was right (01)
JoyJo1	lda	<reg_E						; get result							
JoyJo2	sta	<joyVal						; save into variable								
			rts									; return												
; ------------------------------------------------------------------------------
; INPUT: two lower bits in regB -> mutiplex bits									
; ------------------------------------------------------------------------------
MuxBits	ldu	#$ff01						; point to PIA0 CRA
			bsr	MuxB01						; set/reset CA2
MuxB01	lda	,u								; get value from CRA - CRB
			anda	#$f7							; set to zero CA2 - CB2
			rorb									; send bit to carry
			bcc	MuxB02						; not set?
			ora	#8								; set to 1 CA2 - CB2
MuxB02	sta	,u++							; save value, point to CRB
			rts									; return
; ------------------------------------------------------------------------------
AudiOff	clra									; bit 3 of ACCA = 0 disable analog MUX
			fcb	$8c							; skip next
AudiOn	lda	#8								; bit 3 of ACA = 1 enable analog MUX
			sta	,-s							; save on stack
			lda	$ff23							; get ctrl register of PIA1 side-B
			anda	#$f7							; reset bit 3
			ora	,s+							; set desired status
			sta	$ff23							; update PIA
			rts
; ------------------------------------------------------------------------------
;													; NOT USED FOR 6809								; Kempston joystick controls.
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
;																											; joyjoy ld bc,31            ; port for Kempston interface.
;																											; 		 in a,(c)            ; read it.
;																											; joyjo3 ld e,a              ; copy to e register.
;																											; 		 ld a,(keys+5)       ; key six.
;																											; 		 call ktest          ; being pressed?
;																											; 		 jr c,joyjo0         ; not pressed.
;																											; 		 set 5,e             ; set bit d5.
;																											; joyjo0 ld a,(keys+6)       ; key seven.
;																											; 		 call ktest          ; being pressed?
;																											; 		 jr c,joyjo1         ; not pressed.
;																											; 		 set 6,e             ; set bit d6.
;																											; joyjo1 ld a,e              ; copy e register to accumulator.
;																											; joyjo2 ld (joyval),a       ; remember value.
;																											; 		 ret
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
; 													; NOT USED FOR 6809								; Sinclair joystick controls.
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
;																											; joysin ld bc,61438         ; port for Sinclair 2.
;																											; 		 in a,(c)            ; read joystick.
;																											; 		 ld d,a              ; clear values.
;																											; 		 xor a               ; clear accumulator.
;																											; 		 ld e,16             ; Kempston fire bit value.
;																											; 		 bit 0,d             ; fire bit pressed?
;																											; 		 call z,joysi0       ; add bit.
;																											; 		 ld e,1              ; Kempston bit value.
;																											; 		 bit 3,d             ; fire bit pressed?
;																											; 		 call z,joysi0       ; add bit.
;																											; 		 ld e,2              ; Kempston bit value.
;																											; 		 bit 4,d             ; fire bit pressed?
;																											; 		 call z,joysi0       ; add bit.
;																											; 		 ld e,8              ; Kempston bit value.
;																											; 		 bit 1,d             ; fire bit pressed?
;																											; 		 call z,joysi0       ; add bit.
;																											; 		 ld e,4              ; Kempston bit value.
;																											; 		 bit 2,d             ; fire bit pressed?
;																											; 		 call z,joysi0       ; add bit.
;																											; 		 jr joyjo3           ; read last 2 keys a la Kempston.
;																											; joysi0 add a,e           ; add bit value.
;																											; 		 ret
; ------------------------------------------------------------------------------------------------------------------------------------------
; Display message																						; Display message
; Input:  regB = message number
; ------------------------------------------------------------------------------------------------------------------------------------------
Dmsg																										; ;dmsg   ld hl,nummsg     ; total messages.
																											; ;       cp (hl)          ; does this one exist?
																											; ;       ret nc           ; no, nothing to display.
	 		ldx	#msgDat						; point to messages table						; dmsg   ld hl,msgdat      ; pointer to messages.
	 		jsr	GetWrd						; get word											; 		 call getwrd         ; get message number.
Dmsg3		jsr	PrePrt						; pre-printing stuff								; dmsg3  call preprt       ; pre-printing stuff.
			jsr	CheckX						; make sure we're in a printable range		; 		 call checkx         ; make sure we're in a printable range.
			lda	<prtMod						; get print mode									; 		 ld a,(prtmod)       ; print mode.
																											; 		 and a               ; standard size?
			bne	Bmsg1							; if not zero, go double-height text		; 		 jp nz,bmsg1         ; no, double-height text.
Dmsg0		pshs	x								; save string pointer in stack				; dmsg0  push hl             ; store string pointer.
			lda	,x								; fetch byte to display							; 		 ld a,(hl)           ; fetch byte to display.
			anda	#127							; remove any end marker							; 		 and 127             ; remove any end marker.
			cmpa	#13							; is Intro?											; 		 cp 13               ; newline character?
			beq	Dmsg1							; yes, go for next row							; 		 jr z,dmsg1
			jsr	PChar							; display character								; 		 call pchar          ; display character.
																											; 		 call gaadd          ; get attribute address.
																											; 		 ld a,(23693)        ; current cell colours.
																											; 		 ld (hl),a           ; write to attribute cell.
			jsr	NexPos 						; next display position							; 		 call nexpos         ; display position.
			bne	Dmsg2							; if not on a new line skip next				; 		 jr nz,dmsg2         ; not on a new line.
			jsr	NexLin						; next line down									; 		 call nexlin         ; next line down.
Dmsg2		puls	x								; restore pointer									; dmsg2  pop hl
																											; 		 ld a,(hl)           ; fetch last character.
			lda 	,x								; fetch last character.							; 		 rla                 ; was it the end?
			lbmi 	Dscor2						; if it is the end, exit						; 		 jp c,dscor2         ; yes, job done.
			leax	1,x							; next character to display					; 		 inc hl              ; next character to display.
			bra 	Dmsg0							; go process it									;		 jr dmsg0
Dmsg1		inc	<dispY							; increment to next line						; dmsg1  ld hl,dispx         ; x coordinate.
			lda	<dispY							; get line pos										; 		 inc (hl)            ; newline.
			cmpa	#24							; is it last one?									; 		 ld a,(hl)           ; fetch position.
			bcs	Dmsg4							; no, skip next									; 		 cp 24               ; past screen edge?
			clr	<dispY							; yes, set 1st row								; 		 jr dmsg2
																											; 		 ld (hl),0           ; restart at top.
Dmsg4		clr	<dispX							; set first column								; dmsg4  inc hl              ; y coordinate.
																											; 		 ld (hl),0           ; carriage return.
			bra	Dmsg2							; process next char								;      jr dmsg2
; ------------------------------------------------------------------------------------------------------------------------------------------
; Display message in BIG text																		; Display message in BIG text
; Input: regX = string pointer
; ------------------------------------------------------------------------------------------------------------------------------------------
Bmsg1		pshs	x
			lda	,x 							; get character to display						; bmsg1  ld a,(hl)           ; get character to display.
			anda	#127							; remove any end marker							; 		 push hl             ; store pointer to message.
			cmpa	#13							; is Intro?											; 		 and 127             ; only want 7 bits.
			beq	Bmsg2							; yes, go for next row							; 		 cp 13               ; newline character?
			jsr	Bchar 						; display big char								; 		 jr z,bmsg2
																											; 		 call bchar          ; display big char.
Bmsg3		puls	x
			lda	,x+ 							; fetch last character							; bmsg3  pop hl              ; retrieve message pointer.
			bpl	Bmsg1							; if not terminator flag, loopback			; 		 ld a,(hl)           ; look at last character.
																											; 		 inc hl              ; next character in list.
																											; 		 rla                 ; was terminator flag set?
																											; 		 jr nc,bmsg1         ; no, keep going.
			rts									; return												; 		 ret
Bmsg2		clr	<dispX							; column zero										; bmsg2  ld hl,charx         ; x coordinate.
			inc	<dispY							; add two											; 		 inc (hl)            ; newline.
			inc	<dispY							; rows												; 		 inc (hl)            ; newline.
			lda	<dispY							; get value											; 		 ld a,(hl)           ; fetch position.
			cmpa	#23  							; past screen end?								; 		 cp 23               ; past screen edge?
			bcs	Bmsg3							; no, go for next char							; 		 jr c,bmsg3          ; no, it's okay.
			clr	<dispY							; go first row										; 		 ld (hl),0           ; restart at top.
																											; 		 inc hl              ; y coordinate.
																											; 		 ld (hl),0           ; carriage return.
			bra	Bmsg3							; go for next char								; 		 jr bmsg3
; ------------------------------------------------------------------------------------------------------------------------------------------
; Big character display.																			; Big character display.
; Input: regA = character
; ------------------------------------------------------------------------------------------------------------------------------------------
Bchar		pshs	x
			ldb	#8								; to multiply by 8								; 		 rlca
			mul									; calculate offset 16 bits						; 		 rlca
			ldu	<fontPtr						; get font table beginning						; 		 ld e,a              ; store shift in e.
			leau	d,u							; add offset										; 		 and 7               ; only want high byte bits.
			jsr	GPrad							; get screen address.							; 		 ld d,a              ; store in d.
			ldx	<grBase						; point to screen (destination)				; 		 ld a,e              ; restore shifted value.
			ldb	#8								; lines to write									; 		 and 248             ; only want low byte bits.
Bchar0	lda	,u+							; get char row byte								; 		 ld e,a              ; that's the low byte.
			
	IF !PMODE4
			anda	<andeor
			eora	<andeor+1
	ENDIF

			sta	,x								; put on screen									; 		 ld hl,(23606)       ; address of font.
			sta	32,x							; and on next row									; 		 add hl,de           ; add displacement.
			leax	64,x							; point two rows below							; 		 call gprad          ; get screen address.
			decb									; decrement counter								; 		 ex de,hl            ; font in de, screen address in hl.
			bne	Bchar0						; not done? loopback								; 		 ld b,8              ; height of character in font.
																											; bchar0 ld a,(de)           ; get a bit of the font.
																											; 		 inc de              ; next line of font.
																											; 		 ld (hl),a           ; write to screen.	
																											; 		 inc h               ; down a line.	
																											; 		 ld (hl),a           ; write to screen.	
																											; 		 call nline          ; next line down.	
																											; 		 djnz bchar0         ; repeat.	
																											; 		 call gaadd          ; get attribute address.
																											; 		 ld a,(23693)        ; current colour.
																											; 		 ld (hl),a           ; set attribute.
																											; 		 ld c,a              ; copy colour to c.
																											; 		 ld de,32            ; distance to next line.
																											; 		 add hl,de           ; point to second cell.
																											; 		 ld a,h              ; high byte of address.
																											; 		 cp 91               ; past edge of screen?
																											; 		 jr nc,bchar1        ; yes, don't write to printer buffer/sysvars.
																											; 		 ld (hl),c           ; set second cell's attributes.
Bchar1	jsr	NexPos						; display position.								; bchar1 call nexpos         ; display position.
			bne	Bchar2 						; not on a new line.								; 		 jp nz,bchar2        ; not on a new line.
Bchar3	inc	<dispY							; increment Y										; bchar3 inc (hl)            ; newline.
			jsr	NexLin 						; next line check									; 		 call nexlin         ; next line check.
Bchar2	puls	x
			jmp	Dscor2						; exit												; bchar2 jp dscor2           ; tidy up line and column variables.
; ------------------------------------------------------------------------------------------------------------------------------------------
																											; Display a character.
																											; achar  ld b,a            ; copy to b.
																											; 		 call preprt         ; get ready to print.
																											; 		 ld a,(prtmod)       ; print mode.
																											; 		 and a               ; standard size?
																											; 		 ld a,b              ; character in accumulator.
																											; 		 jp nz,bchar         ; no, double-height text.
																											; 		 call pchar          ; display character.
																											; 		 call gaadd          ; get attribute address.
																											; 		 ld a,(23693)        ; current cell colours.
																											; 		 ld (hl),a           ; write to attribute cell.
																											; 		 call nexpos         ; display position.
																											; 		 jp z,bchar3         ; next line down.
																											; 		 jp bchar2           ; tidy up.
; ------------------------------------------------------------------------------------------------------------------------------------------
; Get next print column position.																; Get next print column position.
; ------------------------------------------------------------------------------------------------------------------------------------------
NexPos	inc	<dispX							; move along one position						; nexpos ld hl,dispy         ; display position.
			lda	<dispX 						; get coordinate									; 		 ld a,(hl)           ; get coordinate.
			anda	#31							; keep them between 0-31						; 		 inc a               ; move along one position.
																											; 		 and 31              ; reached edge of screen?
																											; 		 ld (hl),a           ; set new position.
																											; 		 dec hl              ; point to x now.
			rts 									; return with status in zero flag			; 		 ret                 ; return with status in zero flag.
; ------------------------------------------------------------------------------------------------------------------------------------------
; Get next print line position.																	; Get next print line position.
; ------------------------------------------------------------------------------------------------------------------------------------------
NexLin	lda	<dispY 						; get vertical position							; nexlin inc (hl)            ; newline.
			inca									; increment											; 		 ld a,(hl)           ; vertical position.
			cmpa	#24							; past screen edge?								; 		 cp 24               ; past screen edge?
			bcs	NL01							; no, exit updating								; 		 ret c               ; no, still okay.
			clra									; restart at top.									; 		 ld (hl),0           ; restart at top.
NL01		sta	<dispY							; update variable									; 		 ret
			rts									; return
; ------------------------------------------------------------------------------------------------------------------------------------------
; Pre-print preliminaries.																			; Pre-print preliminaries.
; ------------------------------------------------------------------------------------------------------------------------------------------
PrePrt	ldd	<fontPtr						; get font pointer.								; preprt ld de,(23606)       ; font pointer.
			std	<grBase						; put into graphics base.						; 		 ld (grbase),de      ; set up graphics base.
Prescr	ldd	<charX 						; get display coordinates.						; prescr ld de,(charx)       ; display coordinates.
			std	<dispX							; update general coordinates.			 		; 		 ld (dispx),de       ; set up general coordinates.
			rts									; return												; 		 ret
; ------------------------------------------------------------------------------------------------------------------------------------------
; Return message pointer in regX
; Input: regX = pointer to message list beginning 											; On entry: hl points to word list
;  		regB = message number 																	;           a contains word number.
; ------------------------------------------------------------------------------------------------------------------------------------------
GetWrd	tstb									; first message?									; getwrd and a               ; first word in list?
			beq	GetWd1						; yes, exit											; 		 ld b,a
																											; getwd0 ld a,(hl)
GetWd0	tst	,x+							; found end?			 							; 		 inc hl
			bpl 	GetWd0						; no, carry on										; 		 cp 128              ; found end?
			decb									; decrement mesg counter		 				; 		 jr c,getwd0         ; no, carry on.
			bne 	GetWd0						; not done? loop									; 		 djnz getwd0         ; until we have right number.
GetWd1	rts									; return												;      ret
; ------------------------------------------------------------------------------------------------------------------------------------------
; Bubble sort																							; Bubble sort.
; ------------------------------------------------------------------------------------------------------------------------------------------
BSort		ldb	#NUMSPR-1																			; bsort  ld b,NUMSPR - 1     ; sprites to swap.
			ldy	#sprTab																				; 		 ld ix,sprtab        ; sprite table.
BSort0																									; bsort0 push bc             ; store loop counter for now.
			lda	,y																						; 		 ld a,(ix+0)         ; first sprite type.
			inca																							; 		 inc a               ; is it switched off?
			beq	Swemp																					; 		 jr z,swemp          ; yes, may need to switch another in here.
			lda	TABSIZ,y																				; 		 ld a,(ix+TABSIZ)    ; check next slot exists.
			inca																							; 		 inc a               ; is it enabled?
			beq	BSort2																				; 		 jr z,bsort2         ; no, nothing to swap.
			lda	TABSIZ,y																			; 		 ld a,(ix+(3+TABSIZ)); fetch next sprite's coordinate.
			cmpa	,y																					; 		 cp (ix+3)           ; compare with this x coordinate.
			bcs	BSort1																				; 		 jr c,bsort1         ; next sprite is higher - may need to switch.
BSort2																									; bsort2 ld de,TABSIZ        ; distance to next odd/even entry.
			leay	TABSIZ,y																				; 		 add ix,de           ; next sprite.
			decb																							; 		 pop bc              ; retrieve loop counter.
			bne	BSort0																				; 		 djnz bsort0         ; repeat for remaining sprites.
			rts																							; 		 ret
BSort1	lda	TABSIZ,y																				; bsort1 ld a,(ix+TABSIZ)    ; sprite on/off flag.
			inca																							; 		 inc a               ; is it enabled?
			beq	BSort2																				; 		 jr z,bsort2         ; no, nothing to swap.
			bsr	SwSpr																					; 		 call swspr          ; swap positions.
			bra	BSort2																				; 		 jr bsort2
Swemp		lda	TABSIZ,y																				; swemp  ld a,(ix+TABSIZ)    ; next table entry.
			inca																							; 		 inc a               ; is that one on?
			beq	BSort2																				; 		 jr z,bsort2         ; no, nothing to swap.
			bsr	SwSpr																					; 		 call swspr          ; swap positions.
			bra	BSort2																				; 		 jr bsort2
; ------------------------------------------------------------------------------------------------------------------------------------------
; Swap sprites																							; Swap sprites.
; ------------------------------------------------------------------------------------------------------------------------------------------
SwSpr		pshs	b,y							; save working registers						; swspr  push ix             ; table address on stack.
			leax	,y								; X acts as HL										; 		 pop hl              ; pop into hl pair.
			leau	,x								; U acts as DE										; 		 ld d,h              ; copy to de pair.
																											; 		 ld e,l
																											; 		 ld bc,TABSIZ        ; distance to second entry.
			leax	TABSIZ,x						; point to second sprite entry				; 		 add hl,bc           ; point to second sprite entry.
			ldy	#TABSIZ						; bytes to swap									; 		 ld b,TABSIZ         ; bytes to swap.
SwSpr0	ldb	,x								; get a byte from 1nd sprite					; swspr0 ld c,(hl)           ; fetch second byte.
			lda	,u								; get a byte from first sprite				; 		 ld a,(de)           ; fetch first byte.
			sta	,x+							; interchange										; 		 ld (hl),a           ; copy to second.
			stb	,u+							; them												; 		 ld a,c              ; second byte in accumulator.
																											; 		 ld (de),a           ; copy to first sprite entry.
																											; 		 inc de              ; next byte.
			leay	-1,y							; decrement counter								; 		 inc hl              ; next byte.
			bne	SwSpr0						; not yet done, loopback						; 		 djnz swspr0         ; swap all bytes in table entry.
			puls	b,y,pc						; restore registers and return				; 		 ret
; ------------------------------------------------------------------------------------------------------------------------------------------
; Process sprites																						; Process sprites.
; ------------------------------------------------------------------------------------------------------------------------------------------
PSpr		ldb 	#NUMSPR						; number of sprites to precess (12)			; pspr   ld b,NUMSPR         ; sprites to process.
			ldx	#sprTab						; point to sprite table beginning			; 		 ld ix,sprtab        ; sprite table.
			pshs	b								; save counter										; pspr1  push bc             ; store loop counter for now.
PSpr1		lda	,x								; get sprite type									; 		 ld a,(ix+0)         ; fetch sprite type.
			cmpa	#9								; less than 9?										; 		 cp 9                ; within range of sprite types?
			bcc	PSprNo						; no, skip next
			jsr	PSpr2							; process that sprite							; 		 call c,pspr2        ; yes, process this one.
PSprNo																									; 		 ld de,TABSIZ        ; distance to next odd/even entry.
			leax	TABSIZ,x						; point to next sprite entry					; 		 add ix,de           ; next sprite.
			dec	,s								; decrement counter								; 		 pop bc              ; retrieve loop counter.
			bne	PSpr1							; not zero? try this one						; 		 djnz pspr1          ; repeat for remaining sprites.
			leas	1,s							; clean stack
			rts									; return												; 		 ret
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
PSpr2		stx	<ogPtr							; save pointer										; pspr2  ld (ogptr),ix       ; store original sprite pointer.
			stx	<reg_IX
			jsr	PSpr3							; execute the proper routine					; 		 call pspr3          ; do the routine.
RtOrg		ldx	<ogPtr							; restore pointer									; rtorg  ld ix,(ogptr)       ; restore original pointer to sprite.
RtOrg0	rts									; return												; rtorg0 ret
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
PSpr3		ldx	#EvTyp0						; point to sprite's events list				; pspr3  ld hl,evtyp0        ; sprite type events list.
PSpr4		asla									; calculate offset in table					; pspr4  add a,a             ; double accumulator.
																											; 		 ld e,a              ; copy to de.
																											; 		 ld d,0              ; no high byte.
																											; 		 add hl,de           ; point to address of routine.
																											; 		 ld e,(hl)           ; address low.
																											; 		 inc hl              ; next byte of address.
																											; 		 ld d,(hl)           ; address high.
			ldy	<reg_IX																				; 		 ex de,hl            ; swap address into hl.
			jmp	[a,x]							; jump to calculated routine					; 		 jp (hl)             ; go there.
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
																											; Address of each sprite type's routine.
EvTyp0	fdb	Evnt00						; defined by game designer						; evtyp0 defw evnt00
EvTyp1	fdb	Evnt01						; defined by game designer						; evtyp1 defw evnt01
EvTyp2	fdb	Evnt02						; defined by game designer						; evtyp2 defw evnt02
EvTyp3	fdb	Evnt03						; defined by game designer						; evtyp3 defw evnt03
EvTyp4	fdb	Evnt04						; defined by game designer						; evtyp4 defw evnt04
EvTyp5	fdb	Evnt05						; defined by game designer						; evtyp5 defw evnt05
EvTyp6	fdb	Evnt06						; defined by game designer						; evtyp6 defw evnt06
EvTyp7	fdb	Evnt07						; defined by game designer						; evtyp7 defw evnt07
EvTyp8	fdb	Evnt08						; defined by game designer						; evtyp8 defw evnt08
; ------------------------------------------------------------------------------------------------------------------------------------------
; Display sprites																						; Display sprites.
; regX takes the rol of IX
; ------------------------------------------------------------------------------------------------------------------------------------------
DSpr		stx	<reg_IX
			ldb	#NUMSPR/2					; number of sprites to display				; dspr   ld b,NUMSPR/2       ; number of sprites to display.
DSpr0		pshs	b								; save counter										; dspr0  push bc             ; store loop counter for now.
			lda	,x								; get a sprite byte								; 		 ld a,(ix+0)         ; get sprite type.
			inca									; is it enabled?									; 		 inc a               ; is it enabled?
			bne	DSpr1							; yes, needs deleting							; 		 jr nz,dspr1         ; yes, it needs deleting.
DSpr5		lda	5,x							; get new type value								; dspr5  ld a,(ix+5)         ; new type.
			inca									; is it enabled?									; 		 inc a               ; is it enabled?
			bne	DSpr3							; yes, needs drawing								; 		 jr nz,dspr3         ; yes, it needs drawing.
DSpr2		ldx	<reg_IX																				; dspr2  push ix             ; put ix on stack.
																											; 		 pop hl              ; pop into hl.
																											; 		 ld e,l              ; copy to de.
																											; 		 ld d,h
																											; ;dspr2  ld e,ixl            ; copy ix to de.
																											; ;       ld d,ixh
																											; ;       ld l,e              ; copy to hl.
																											; ;       ld h,d
													; copy 5 bytes from new to old				; 		 ld bc,5             ; distance to new type.
			ldd	5,x							; get new type and image						; 		 add hl,bc           ; point to new properties.
			std	,x								; copy to old positions							; 		 ldi                 ; copy to old positions.
			ldd	7,x							; get frame and posX								; 		 ldi
			std	2,x							; to old												; 		 ldi
			lda	9,x							; and posY											; 		 ldi
			sta	4,x							; to old												; 		 ldi
			ldb	#TABSIZ*2					; to skip over two sprites						; 		 ld c,TABSIZ*2       ; distance to next odd/even entry.
			leax	b,x							; point to next odd/even sprite				; 		 add ix,bc           ; next sprite.
			puls	b								; restore counter									; 		 pop bc              ; retrieve loop counter.
			decb									; decrement
			bne	DSpr0							; not zero, loopback								; 		 djnz dspr0          ; repeat for remaining sprites.
			rts									; return												; 		 ret
																											; ;dspr1  ld a,(ix+3)         ; old x coord.
																											; ;       cp 177              ; beyond maximum?
																											; ;       jr nc,dspr5         ; yes, don't delete it.
DSpr1		lda	5,x							; get new type										; dspr1  ld a,(ix+5)         ; type of new sprite.
			inca									; is it enabled?									; 		 inc a               ; is this enabled?
			bne	DSpr4							; yes, display both								; 		 jr nz,dspr4         ; yes, display both.
DSpr6		jsr	SSpriA						; show a single sprite							; dspr6  call sspria         ; show single sprite.
			bra	DSpr2							; loopback											; 		 jp dspr2
; ------------------------------------------------------------------------------------------------------------------------------------------
; Displaying two sprites.  Don't bother redrawing if nothing has changed			; Displaying two sprites.  Don't bother redrawing if nothing has changed.
; ------------------------------------------------------------------------------------------------------------------------------------------
DSpr4		lda	4,x							; get old posY										; dspr4  ld a,(ix+4)         ; old y.
			cmpa	9,x							; same as new?										; 		 cp (ix+9)           ; compare with new value.
			bne	DSpr7							; no, need to redraw								; 		 jr nz,dspr7         ; they differ, need to redraw.
			lda	3,x							; get old posX										; 		 ld a,(ix+3)         ; old x.
			cmpa	8,x							; same as new?										; 		 cp (ix+8)           ; compare against new value.
			bne	DSpr7							; no, need to redraw								; 		 jr nz,dspr7         ; they differ, need to redraw.
			lda	2,x							; get old frame									; 		 ld a,(ix+2)         ; old frame.
			cmpa	7,x							; same as new?										; 		 cp (ix+7)           ; compare against new value.
			bne	DSpr7							; no, need to redraw								; 		 jr nz,dspr7         ; they differ, need to redraw.
			lda	1,x							; get old image									; 		 ld a,(ix+1)         ; old image.
			cmpa	6,x							; same as new?										; 		 cp (ix+6)           ; compare against new value.
			beq	DSpr2							; yes, so NO redrawing							; 		 jp z,dspr2          ; everything is the same, don't redraw.
DSpr7		jsr	SSpriC						; delete old, draw new							; dspr7  call sspric         ; delete old sprite, draw new one simultaneously.
			bra	DSpr2							; loopback											; 		 jp dspr2
DSpr3		stx	<reg_IX
			jsr	SSpriB						; draw a single sprite							; dspr3  call ssprib         ; show single sprite.
			bra	DSpr2							; loopback											; 		 jp dspr2
; ------------------------------------------------------------------------------------------------------------------------------------------
; Get sprite address calculations																; Get sprite address calculations.
; gspran = new sprite, gsprad = old sprite													; gspran = new sprite, gsprad = old sprite.
; regX = IX
; ------------------------------------------------------------------------------------------------------------------------------------------
GSprAN	ldu	<reg_IX						; regU=IX
			ldb	8,u							; get new coordinates							; gspran ld l,(ix+8)         ; new x coordinate.
			lda	9,u							; inverted											; 		 ld h,(ix+9)         ; new y coordinate.
			std	<dispX							; put into variables								; 		 ld (dispx),hl       ; set display coordinates.
			lda	6,u							; get new image									; 		 ld a,(ix+6)         ; new sprite image.
			jsr	GFrm							; fetch start frame in regX					; 		 call gfrm           ; fetch start frame for this sprite.
			lda	,x								; get frame											; 		 ld a,(hl)           ; frame in accumulator.
			adda	7,u							; add new frame									; 		 add a,(ix+7)        ; new add frame number.
			bra	GSprA0						; skip section										; 		 jp gspra0
; ------------------------------------------------------------------------------------------------------------------------------------------
; here regX must arrive as IX (sprite address)
; returns reg_BC=right-left byte mask - reg_DE=spriteframe address
; ------------------------------------------------------------------------------------------------------------------------------------------
GSprAd	leau	,x								; regU takes the rol of reg_IX
			stu	<reg_IX						; save reg_IX for later use
			ldd	3,u							; get old posXY									; gsprad ld l,(ix+3)         ; x coordinate.
			sta	<dispY							; put into											; 		 ld h,(ix+4)         ; y coordinate.
			stb	<dispX							; variables											; 		 ld (dispx),hl       ; set display coordinates.
			lda	1,u							; get old image									; 		 ld a,(ix+1)         ; sprite image.
			jsr	GFrm							; fetch start frame in regX					; 		 call gfrm           ; fetch start frame for this sprite.
			lda	,x								; get frame											; 		 ld a,(hl)           ; frame in accumulator.
			adda	2,u							; add old frame									; 		 add a,(ix+2)        ; add frame number.
GSprA0	lsra									; multiply by 128									; gspra0 rrca                ; multiply by 128.
			bcc	GSp01
			ora	#%10000000
GSp01		sta	<reg_D						; save result in reg_D							; 		 ld d,a              ; store in d.
			lda	#0								; zero low byte									; 		 and 128             ; low byte bit.
			rora									; send carry to it
			sta	<reg_E						; store result in reg_E (Low byte)			; 		 ld e,a              ; got low byte.
			lda	<reg_D						; get saved value									; 		 ld a,d              ; restore result.
			anda	#127							; reset bit 7										; 		 and 127             ; high byte bits.
			sta	<reg_D						; update reg_D (high byte)						; 		 ld d,a              ; displacement high byte.
			ldx	#sprGfx						; point to sprites data beginning			; 		 ld hl,sprgfx        ; address of play sprites.
			ldd	<reg_DE						; get offset
			leax	d,x							; point to right frame							; 		 add hl,de           ; point to frame.
			ldb	<dispX							; get Y coordinate								; 		 ld a,(dispy)        ; y coordinate.
			andb	#%00000110					; position within byte boundary				; 		 and 6               ; position within byte boundary.
			stb	<reg_C						; low byte of table displacement				; 		 ld c,a              ; low byte of table displacement.
			aslb									; four												; 		 rlca                ; multiply by 32.
			aslb									; shifts												; 		 rlca                ; already a multiple
			aslb									; required											; 		 rlca                ; of 2, so just 4
			aslb									; to x32												; 		 rlca                ; shifts needed.
													; low byte calculated							; 		 ld e,a              ; put displacement in low byte of de.
			clra									; high byte to zero								; 		 ld d,0              ; zero the high byte.
			sta	<reg_B						; zero to reg_B									; 		 ld b,d              ; no high byte for mask displacement either.
			leau	d,x							; add to sprite address, change to regU	; 		 add hl,de           ; add to sprite address.
			stu	<reg_DE						; save into reg_DE								; 		 ex de,hl            ; need it in de for now.
			ldx	#spMask						; point to mask table							; 		 ld hl,spmask        ; pointer to mask table.
			ldb	<reg_C						; get saved low byte
			abx									; add to pointer
			ldd	,x								; get masks
			sta	<reg_C						; save left mask									; 		 add hl,bc           ; add displacement to pointer.
			stb	<reg_B						; and right mask									; 		 ld c,(hl)           ; left mask.
																											; 		 inc hl
																											; 		 ld b,(hl)           ; right mask.
; ------------------------------------------------------------------------------------------------------------------------------------------
; Drop into screen address routine.																; Drop into screen address routine.
; This routine returns a screen address for (dispx, dispy) in hl						; This routine returns a screen address for (dispx, dispy) in hl.
; when used for Objects, posY and dispX arrive INVERTED!
; but for Sprites arrive NORAML
; ------------------------------------------------------------------------------------------------------------------------------------------
ScAdd		ldb	<dispY							; get posY											; scadd  ld a,(dispx)        ; coordinate.
			lda	#SCADTB/256					; get high byte of table						; 		 ld l,a              ; low byte of table.
			tfr	d,x							; pass to regX										; 		 ld h,251            ; high byte of 64256 (SCADTB).
			lda	,x+							; fetch high byte of mostleft byte in row	; 		 ld a,(hl)           ; fetch high byte.
			ldb	255,x							; fetch low byte of mostleft byte in row	; 		 inc h               ; point to low byte table.
			std	<reg_HL						; save in reg_HL									; 		 ld l,(hl)           ; fetch low byte.
			lda	<dispX							; get posX											; 		 ld h,a              ; hl points to start of line.
			lsra									; divide												; 		 ld a,(dispy)        ; y pixel coordinate.
			lsra									; by													; 		 rrca                ; divide by 8.
			lsra									; 8													; 		 rrca
			anda	#31							; values 0-31 accepted							; 		 rrca
			adda	<reg_L						; add to low byte									; 		 and 31              ; squares 0 - 31 across screen.
			sta	<reg_L						; update it											; 		 add a,l             ; add to address.
			ldx	<reg_HL						; get pointer to regX							; 		 ld l,a              ; copy to hl = address of screen.
			rts									; return												; 		 ret
; ------------------------------------------------------------------------------------------------------------------------------------------
spMask	fcb	255,0,63,192,15,240,3,252														; spmask defb 255,0,63,192,15,240,3,252
; ------------------------------------------------------------------------------------------------------------------------------------------
; These are the sprite routines.																	; These are the sprite routines.
; SSpriA = single sprite, old (ix).																; spria = single sprite, old (ix).
; SSpriB = single sprite, new (ix+5).															; ssprib = single sprite, new (ix+5).
; SSpriC = both sprites, old (ix) and new (ix+5).											; sspric = both sprites, old (ix) and new (ix+5).
; ------------------------------------------------------------------------------------------------------------------------------------------
SSpriA	jsr	GSprAd						; get old sprite address						; sspria call gsprad         ; get old sprite address.
SSpri2	lda	#16							; number of rows									; sspri2 ld a,16             ; vertical lines.
SSpri0	sta	<reg_AF						; store reg_A										; sspri0 ex af,af'           ; store line counter away in alternate registers.
			jsr	DLine							; draw a line										; 		 call dline          ; draw a line.
			lda	<reg_AF						; restore reg_A									; 		 ex af,af'           ; restore line counter.
			deca									; decrement counter								; 		 dec a               ; one less to go.
			bne	SSpri0						; not zero, loopback								; 		 jp nz,sspri0
			rts									; return												; 		 ret
; ------------------------------------------------------------------------------------------------------------------------------------------
SSpriB	jsr	GSprAN						; get new sprite address						; ssprib call gspran         ; get new sprite address.
			bra	SSpri2						; go draw it										; 		 jp sspri2
; ------------------------------------------------------------------------------------------------------------------------------------------
SSpriC	jsr	GSprAd						; get old sprite address						; sspric call gsprad         ; get old sprite address.
			jsr	do_exx						; store addresses (BC,DE,HL)					; 		 exx                 ; store addresses.
			jsr	GSprAN						; get new sprite address						; 		 call gspran         ; get new sprite addresses.
			lda	#15
			pshs	a
SSLoop	jsr	DLine							; draw a line										; 		 call dline          ; draw a line.
			jsr	do_exx						; restore old addresses							; 		 exx                 ; restore old addresses.
			jsr	DLine							; delete a line									; 		 call dline          ; delete a line.
			jsr	do_exx						; flip to new addresses							; 		 exx                 ; flip to new sprite addresses.
			dec	,s								; decrement counter								; 		 call dline          ; draw a line.
			bne	SSLoop						; not yet done, loopback						; 		 exx                 ; restore old addresses.
			leas	1,s							; discard counter									; 		 call dline          ; delete a line.
																											; 		 exx                 ; flip to new sprite addresses.
			jsr	DLine							; draw a line										; 		 call dline          ; draw a line.
			jsr	do_exx						; restore old addresses							; 		 exx                 ; restore old addresses.
																											; 		 call dline          ; delete a line.
																											; 		 exx                 ; flip to new sprite addresses.
																											; 		 call dline          ; draw a line.
																											; 		 exx                 ; restore old addresses.
																											; 		 call dline          ; delete a line.
																											; 		 exx                 ; flip to new sprite addresses.
																											; 		 call dline          ; draw a line.
																											; 		 exx                 ; restore old addresses.
																											; 		 call dline          ; delete a line.
																											; 		 exx                 ; flip to new sprite addresses.
																											; 		 call dline          ; draw a line.
																											; 		 exx                 ; restore old addresses.
																											; 		 call dline          ; delete a line.
																											; 		 exx                 ; flip to new sprite addresses.
																											; 		 call dline          ; draw a line.
																											; 		 exx                 ; restore old addresses.
																											; 		 call dline          ; delete a line.
																											; 		 exx                 ; flip to new sprite addresses.
																											; 		 call dline          ; draw a line.
																											; 		 exx                 ; restore old addresses.
																											; 		 call dline          ; delete a line.
																											; 		 exx                 ; flip to new sprite addresses.
																											; 		 call dline          ; draw a line.
																											; 		 exx                 ; restore old addresses.
																											; 		 call dline          ; delete a line.
																											; 		 exx                 ; flip to new sprite addresses.
																											; 		 call dline          ; draw a line.
																											; 		 exx                 ; restore old addresses.
																											; 		 call dline          ; delete a line.
																											; 		 exx                 ; flip to new sprite addresses.
																											; 		 call dline          ; draw a line.
																											; 		 exx                 ; restore old addresses.
																											; 		 call dline          ; delete a line.
																											; 		 exx                 ; flip to new sprite addresses.
																											; 		 call dline          ; draw a line.
																											; 		 exx                 ; restore old addresses.
																											; 		 call dline          ; delete a line.
																											; 		 exx                 ; flip to new sprite addresses.
																											; 		 call dline          ; draw a line.
																											; 		 exx                 ; restore old addresses.
																											; 		 call dline          ; delete a line.
																											; 		 exx                 ; flip to new sprite addresses.
																											; 		 call dline          ; draw a line.
																											; 		 exx                 ; restore old addresses.
																											; 		 call dline          ; delete a line.
																											; 		 exx                 ; flip to new sprite addresses.
																											; 		 call dline          ; draw a line.
																											; 		 exx                 ; restore old addresses.
																											; 		 call dline          ; delete a line.
																											; 		 exx                 ; flip to new sprite addresses.
																											; 		 call dline          ; draw a line.
																											; 		 exx                 ; restore old addresses.
; ------------------------------------------------------------------------------------------------------------------------------------------
; Drop through.																						; Drop through.
; Line drawn, now work out next target address												; Line drawn, now work out next target address.
; receives reg_BC=right-left mask
;			  reg_DE=spriteAddress - reg_HL=screenAddress
; ------------------------------------------------------------------------------------------------------------------------------------------
DLine		ldd	<reg_HL						; get screen pointer
			cmpd	#$e600						; is it out of screen?
			bcc	DLin01						; no, skip next
			rts									; yes, do nothing and exit
DLin01	lda	[reg_DE]						; get graphic byte								; dline  ld a,(de)           ; graphic data.
			anda	<reg_C						; mask out what's not needed					; 		 and c               ; mask away what's not needed.
			eora	[reg_HL]						; eor with what's there							; 		 xor (hl)            ; XOR with what's there.
			sta	[reg_HL]						; put to destination								; 		 ld (hl),a           ; bung it in.
			inc	<reg_L						; next screen										; 		 inc l               ; next screen address.
			inc	<reg_L						; address											; 		 inc l               ; next screen address.
			lda	[reg_DE]						; get data											; 		 ld a,(de)           ; fetch data.
			anda	<reg_B						; mask out											; 		 and b               ; mask away unwanted bits.
			eora	[reg_HL]						; eor 												; 		 xor (hl)            ; XOR with what's there.
			sta	[reg_HL]						; put to destination								; 		 ld (hl),a           ; bung it in.
			ldd	<reg_DE						; point
			addd	#1								; to next
			std	<reg_DE						; graphic											; 		 inc de              ; next graphic.
			dec	<reg_L						; one char left to the cell					; 		 dec l               ; one character cell to the left.
			lda	[reg_DE]						; second byte of data							; 		 ld a,(de)           ; second bit of data.
			eora	[reg_HL]						; eor													; 		 xor (hl)            ; XOR with what's there.
			sta	[reg_HL]						; put to destination								; 		 ld (hl),a           ; bung it in.
			ldd	<reg_DE						; point  
			addd	#1								; to next
			std	<reg_DE						; line of data										; 		 inc de              ; point to next line of data.
			dec	<reg_L						; another char left								; 		 dec l               ; another char left.
; ------------------------------------------------------------------------------------------------------------------------------------------
; Line drawn, now work out next target address												; Line drawn, now work out next target address.
; ------------------------------------------------------------------------------------------------------------------------------------------
NLine		pshs	d								; save working register
			ldd	<reg_HL						; get prior row leftmost byte					; nline  inc h             ; increment pixel.
			addd	#32							; to calculate next one							; 		 ld a,h              ; get pixel address.
																											; 		 and 7               ; straddling character position?
																											; 		 ret nz              ; no, we're on next line already.
																											; 		 ld a,h              ; get pixel address.
																											; 		 sub 8               ; subtract 8 for start of segment.
																											; 		 ld h,a              ; new high byte of address.
																											; 		 ld a,l              ; get low byte of address.
																											; 		 add a,32            ; one line down.
																											; 		 ld l,a              ; new low byte.
																											; 		 ret nc              ; not reached next segment yet.
																											; 		 ld a,h              ; address high.
																											; 		 add a,8             ; add 8 to next segment.
			cmpa	#$fe							; end of screen?									; 		 ld h,a              ; new high byte.
			bcs	NLEx01						; no, skip next									; 		 cp 88               ; reached end of screen?
			lda	#$80							; point to ROM (now in RAM)					; 		 ret c               ; not yet.
NLEx01	std	<reg_HL						; save calculated address						; 		 ld h,56             ; back to ROM.
			puls	d,pc							; return												; 		 ret
; ------------------------------------------------------------------------------------------------------------------------------------------
; Animates a sprite																					; Animates a sprite.
; ------------------------------------------------------------------------------------------------------------------------------------------
AnimSp0	clra									; added to reduce bytes in scripts
AnimSp																									; animsp ld hl,frmno         ; game frame.
			anda	<frmNo																					; 		 and (hl)            ; is it time to change the frame?
			bne	AnimSpex																				; 		 ret nz              ; not this frame.
			ldy	<reg_IX
			lda	6,y																					; 		 ld a,(ix+6)         ; sprite image.
			jsr	GFrm							; returns regX as HL								; 		 call gfrm           ; get frame data.
			leax	1,x																					; 		 inc hl              ; point to frames.
			stx	<reg_HL
			lda	7,y																					; 		 ld a,(ix+7)         ; sprite frame.
			inca																							; 		 inc a               ; next one along.
			cmpa	,x																						; 		 cp (hl)             ; reached the last frame?
			bcs	AnimS0																				; 		 jr c,anims0         ; no, not yet.
			clra																							; 		 xor a               ; start at first frame.
AnimS0	sta	7,y																					; anims0 ld (ix+7),a         ; new frame.
AnimSpex	rts																							; 		 ret
; ------------------------------------------------------------------------------------------------------------------------------------------
AnimBk																									; animbk ld hl,frmno         ; game frame.
			anda	<frmNo																					; 		 and (hl)            ; is it time to change the frame?
			bne	AnimSpex																				; 		 ret nz              ; not this frame.
			ldy	<reg_IX
			lda	6,y																					; 		 ld a,(ix+6)         ; sprite image.
			jsr	GFrm																					; 		 call gfrm           ; get frame data.
			leax	1,x																					; 		 inc hl              ; point to frames.
			stx	<reg_HL
			lda	7,y																					; 		 ld a,(ix+7)         ; sprite frame.
																											; 		 and a               ; first one?
			bne	RTanb0																				; 		 jr nz,rtanb0        ; yes, start at end.
			lda	,x																						; 		 ld a,(hl)           ; last sprite.
RTanb0	deca																							; rtanb0 dec a               ; next one along.
			jsr	AnimS0																				; 		 jr anims0           ; set new frame.
; ------------------------------------------------------------------------------------------------------------------------------------------
; Check for collision with other sprite, strict enforcement								; Check for collision with other sprite, strict enforcement.
; ------------------------------------------------------------------------------------------------------------------------------------------
SkTyp		ldx	#sprTab																				; sktyp  ld hl,sprtab        ; sprite table.
			stx	<reg_HL
NumSP2	lda	#NUMSPR																				; numsp2 ld a,NUMSPR         ; number of sprites.
SkTyp0	sta	<reg_AF																				; sktyp0 ex af,af'           ; store loop counter.
			stx	skPtr																					; 		 ld (skptr),hl       ; store pointer to sprite.
			lda	,x																						; 		 ld a,(hl)           ; get sprite type.
			cmpa	<reg_B																				; 		 cp b                ; is it the type we seek?
			beq	ColTyp																				; 		 jr z,coltyp         ; yes, we can use this one.
SkTyp1	ldx	skPtr																					; sktyp1 ld hl,(skptr)       ; retrieve sprite pointer.
			leax	TABSIZ,x																				; 		 ld de,TABSIZ        ; size of each entry.
			stx	<reg_HL																				; 		 add hl,de           ; point to next sprite in table.
			lda	<reg_AF																				; 		 ex af,af'           ; restore loop counter.
			deca																							; 		 dec a               ; one less iteration.
			bne	SkTyp0																				; 		 jp nz,sktyp0        ; keep going until we find a slot.
			ldd	#$0000																				; 		 ld hl,0             ; default to ROM address - no sprite.
			std	skPtr																					; 		 ld (skptr),hl       ; store pointer to sprite.
			andcc	#%11111011																			; 		 or h                ; don't return with zero flag set.
			rts																							; 		 ret                 ; didn't find one.
; ------------------------------------------------------------------------------------------------------------------------------------------
skPtr		fdb	$0000																					; skptr  defw 0              ; search pointer.
; ------------------------------------------------------------------------------------------------------------------------------------------
ColTyp	lda	[reg_IX]																				; coltyp ld a,(ix+0)         ; current sprite type.
			cmpa	<reg_B																				; 		 cp b                ; seeking sprite of same type?
			beq	ColTy1																				; 		 jr z,colty1         ; yes, need to check we're not detecting ourselves.
ColTy0	ldx	<reg_HL																				; colty0 ld de,X             ; distance to x position in table.
			leax	Xval,x																				; 		 add hl,de           ; point to coords.
			ldd	,x+																					; 		 ld e,(hl)           ; fetch x coordinate.
			stb	<reg_D																				; 		 inc hl              ; now point to y.
			sta	<reg_E
			stx	<reg_HL																				; 		 ld d,(hl)           ; that's y coordinate.
; ------------------------------------------------------------------------------------------------------------------------------------------
; Drop into collision detection																	; Drop into collision detection.
; ------------------------------------------------------------------------------------------------------------------------------------------
Colc16	ldy	<reg_IX
			lda	Xval,y																				; colc16 ld a,(ix+X)         ; x coord.
			suba	<reg_E																				; 		 sub e               ; subtract x.
			bcc	Colc1a																				; 		 jr nc,colc1a        ; result is positive.
			nega																							; 		 neg                 ; make negative positive.
Colc1a	cmpa	#16																					; colc1a cp 16               ; within x range?
			bcc	SkTyp1																				; 		 jr nc,sktyp1        ; no - they've missed.
			sta	<reg_C																				; 		 ld c,a              ; store difference.
			lda	Yval,y																				; 		 ld a,(ix+Y)         ; y coord.
			suba	<reg_D																				; 		 sub d               ; subtract y.
			bcc	Colc1b																				; 		 jr nc,colc1b        ; result is positive.
			nega																							; 		 neg                 ; make negative positive.
Colc1b	cmpa	#16																					; colc1b cp 16               ; within y range?
			bcc	SkTyp1																				; 		 jr nc,sktyp1        ; no - they've missed.
			adda	<reg_C																				; 		 add a,c             ; add x difference.
			cmpa	#26																					; 		 cp 26               ; only 5 corner pixels touching?
			bcc	SkTyp1																				; 		 ret c               ; carry set if there's a collision.
			rts																							; 		 jp sktyp1           ; try next sprite in table.
; ------------------------------------------------------------------------------------------------------------------------------------------
ColTy1	ldd	<reg_IX																				; colty1 push ix             ; base sprite address onto stack.
																											; 		 pop de              ; pop it into de.
																											; 		 ex de,hl            ; flip hl into de.
			cmpd	<reg_HL																				; 		 sbc hl,de           ; compare the two.
																											; 		 ex de,hl            ; restore hl.
			beq	SkTyp1																				; 		 jr z,sktyp1         ; addresses are identical.
			bra	ColTy0																				; 		 jp colty0
; ------------------------------------------------------------------------------------------------------------------------------------------
; Display number.	(regA=number to be converted)												; Display number.
; ------------------------------------------------------------------------------------------------------------------------------------------
Disply	ldu	#disp10						; point to string area							; disply ld bc,displ0        ; display workspace.
			jsr	Num2Ch						; convert number to char						; 		 call num2ch         ; convert accumulator to string.
Disp11	lda	-1,u							; get last calculated digit					; displ1 dec bc              ; back one character.
																											; 		 ld a,(bc)           ; fetch digit.
			ora	#128							; raise bit 7 (end of string)					; 		 or 128              ; insert end marker.
			sta	-1,u							; update string									; 		 ld (bc),a           ; new value.
			ldx	#disp10						; point to string									; 		 ld hl,displ0        ; display space.
			jmp	Dmsg3							; show it											; 		 jp dmsg3            ; display the string.
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
disp10	fcb	0,0,0,13+128				; area for converted number					; displ0 defb 0,0,0,13+128
; ------------------------------------------------------------------------------------------------------------------------------------------
; Initialise screen.																					; Initialise screen.
; ------------------------------------------------------------------------------------------------------------------------------------------
InitSc	lda	roomTb						; get room number									; initsc ld a,(roomtb)       ; whereabouts in the map are we?
			jsr	TstSc							; find associated code							; 		 call tstsc          ; find displacement.
			bmi	InitSc1						; if out of map, return zero					; 		 cp 255              ; is it valid?
																											; 		 ret z               ; no, it's rubbish.
			sta	scNo							; store code as present room					; 		 ld (scno),a         ; store new room number.
			rts									; return												; 		 ret
InitSc1	clra									; clear zero flag				
			rts									; return								
; ------------------------------------------------------------------------------------------------------------------------------------------
; Test screen.																							; Test screen.
; ------------------------------------------------------------------------------------------------------------------------------------------
TstSc		ldx	#mapDat-MAPWID				; start of MAP data								; tstsc  ld hl,mapdat-MAPWID ; start of map data, subtract width for negative.
			sta	<reg_B																				; 		 ld b,a              ; store room in b for now.
			adda	#MAPWID						; add MAPWID to skip negatives				; 		 add a,MAPWID        ; add width in case we're negative.
																											; 		 ld e,a              ; screen into e.
			leax	a,x																					; 		 ld d,0              ; zeroise d.
			stx	<reg_HL																				; 		 add hl,de           ; add displacement to map data.
			lda	,x								; get room number									; 		 ld a,(hl)           ; find room number there.
			rts									; return												; 		 ret
; ------------------------------------------------------------------------------------------------------------------------------------------
; Screen left																							; Screen left.
; ------------------------------------------------------------------------------------------------------------------------------------------
ScrL		lda	roomTb																				; scrl   ld a,(roomtb)       ; present room table pointer.
			deca																							; 		 dec a               ; room left.
Scr10		jsr	TstSc																					; scrl0  call tstsc          ; test screen.
			inca																							; 		 inc a               ; is there a screen this way?
			beq	ScrLEx																				; 		 ret z               ; no, return to loop.
			lda	<reg_B																				; 		 ld a,b              ; restore room displacement.
			sta	roomTb																				; 		 ld (roomtb),a       ; new room table position.
Scr11		jsr	InitSc																				; scrl1  call initsc         ; set new screen.
			lda	#2																						; 		 ld hl,restfl        ; restart screen flag.
			sta	<restFl																				; 		 ld (hl),2           ; set it.
ScrLEx	rts																							; 		 ret
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
ScrR		lda	roomTb																				; scrr   ld a,(roomtb)       ; room table pointer.
			inca																							; 		 inc a               ; room right.
			bra	Scr10																					; 		 jr scrl0
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
ScrU		lda	roomTb																				; scru   ld a,(roomtb)       ; room table pointer.
			suba	#MAPWID																				; 		 sub MAPWID          ; room up.
			bra	Scr10																					; 		 jr scrl0
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
ScrD		lda	roomTb																				; scrd   ld a,(roomtb)       ; room table pointer.
			adda	#MAPWID																				; 		 add a,MAPWID        ; room down.
			bra	Scr10																					; 		 jr scrl0
; ------------------------------------------------------------------------------------------------------------------------------------------
; Jump to new screen																					; Jump to new screen.
; ------------------------------------------------------------------------------------------------------------------------------------------
NwScr		ldx	#mapDat																				; nwscr  ld hl,mapdat        ; start of map data.
			ldb	#80																					; 		 ld bc,256*80        ; zero room count, 80 to search.
			clr	,-s
NwScr0	cmpa	,x+																					; nwscr0 cp (hl)             ; have we found a match for screen?
			beq	NwScr1																				; 		 jr z,nwscr1         ; yes, set new point in map.
																											; 		 inc hl              ; next room.
			inc	,s																						; 		 inc c               ; count rooms.
			decb
			bne	NwScr0																				; 		 djnz nwscr0         ; keep looking.
			puls	b,pc							; clean stack and return						; 		 ret
NwScr1	lda	,s+																					; nwscr1 ld a,c              ; room displacement.
			sta	roomTb																				; 		 ld (roomtb),a       ; set the map position.
			bra	Scr11																					; 		 jr scrl1            ; draw new room.
; ------------------------------------------------------------------------------------------------------------------------------------------
; Gravity processing																					; Gravity processing.
; ------------------------------------------------------------------------------------------------------------------------------------------
Grav		lda	13,y 																					; grav   ld a,(ix+13)        ; in-air flag.
																											; 		 and a               ; are we in the air?
			beq	GravEx																				; 		 ret z               ; no we are not.
			inca																							; 		 inc a               ; increment it.
			beq	OGrv																					; 		 jp z,ogrv           ; set to 255, use old gravity.
			sta	13,y																					; 		 ld (ix+13),a        ; write new setting.
			rora																							; 		 rra                 ; every other frame.
			bcc	Grav0																					; 		 jr nc,grav0         ; don't apply gravity this time.
			lda	14,y																					; 		 ld a,(ix+14)        ; pixels to move.
			cmpa	#16																					; 		 cp 16               ; reached maximum?
			beq	Grav0																					; 		 jr z,grav0          ; yes, continue.
			inc	14,y																					; 		 inc (ix+14)         ; slow down ascent/speed up fall.
Grav0		lda	14,y																					; grav0  ld a,(ix+14)        ; get distance to move.
			asra																							; 		 sra a               ; divide by 2.
																											; 		 and a               ; any movement required?
			beq	GravEx																				; 		 ret z               ; no, not this time.
			cmpa	#128																					; 		 cp 128              ; is it up or down?
			bcc	GravU																					; 		 jr nc,gravu         ; it's up.
GravD		sta	<reg_B																				; gravd  ld b,a              ; set pixels to move.
GravD0	jsr	CanGD																					; gravd0 call cangd          ; can we go down?
			bne	GravSt																				; 		 jr nz,gravst        ; can't move down, so stop.
			inc	8,y																					; 		 inc (ix+8)          ; adjust new x coord.
			dec	<reg_B
			bne	GravD0																				; 		 djnz gravd0
			rts																							; 		 ret
GravU		nega																							; gravu  neg                 ; flip the sign so it's positive.
			sta	<reg_B																				; 		 ld b,a              ; set pixels to move.
GravU0	jsr	CanGU																					; gravu0 call cangu          ; can we go up?
			lbne	IFalls																				; 		 jp nz,ifalls        ; can't move up, go down next.
			dec	8,y																					; 		 dec (ix+8)          ; adjust new x coord.
			dec	<reg_B
			bne	GravU0																				; 		 djnz gravu0
			rts																							; 		 ret
GravSt	lda	14,y																					; gravst ld a,(ix+14)        ; jump pointer high.
			clr	13,y																					; 		 ld (ix+13),0        ; reset falling flag.
			clr	14,y																					; 		 ld (ix+14),0        ; store new speed.
			cmpa	#8																						; 		 cp 8                ; was speed the maximum?
EvFtf		lbeq	Evnt15																				; evftf  jp z,evnt15         ; yes, fallen too far.
GravEx	rts																							; 		 ret
; ------------------------------------------------------------------------------------------------------------------------------------------
; Old gravity processing for compatibility with 4.6 and 4.7								; Old gravity processing for compatibility with 4.6 and 4.7.
; ------------------------------------------------------------------------------------------------------------------------------------------
OGrv		ldb	14,y																					; ogrv   ld e,(ix+14)        ; get index to table.
																											; 		 ld d,0              ; no high byte.
			ldx	#jTab																					; 		 ld hl,jtab          ; jump table.
			abx																							; 		 add hl,de           ; hl points to jump value.
			lda	,x																						; 		 ld a,(hl)           ; pixels to move.
			cmpa	#99																					; 		 cp 99               ; reached the end?
			bne	OGrv0																					; 		 jr nz,ogrv0         ; no, continue.
			leax	-1,x																					; 		 dec hl              ; go back to previous value.
			lda	,x																						; 		 ld a,(hl)           ; fetch that from table.
			bra	OGrv1																					; 		 jr ogrv1
OGrv0		inc	14,y																					; ogrv0  inc (ix+14)         ; point to next table entry.
OGrv1		tsta																							; ogrv1  and a               ; any movement required?
			beq	OGrvEx																				; 		 ret z               ; no, not this time.
			cmpa	#128																					; 		 cp 128              ; is it up or down?
			bcc	OGrvU																					; 		 jr nc,ogrvu         ; it's up.
OGrvD		sta	<reg_B																				; ogrvd  ld b,a              ; set pixels to move.
OGrvD0	jsr	CanGD																					; ogrvd0 call cangd          ; can we go down?
			bne	OGrvSt																				; 		 jr nz,ogrvst        ; can't move down, so stop.
			inc	8,y																					; 		 inc (ix+8)          ; adjust new x coord.
			dec	<reg_B
			bne	OGrvD0																				; 		 djnz ogrvd0
			rts																							; 		 ret
OGrvU		nega																							; ogrvu  neg                 ; flip the sign so it's positive.
			sta	<reg_B																				; 		 ld b,a              ; set pixels to move.
OGrvU0	jsr	CanGU																					; ogrvu0 call cangu          ; can we go up?
			bne	OGrv2																					; 		 jr nz,ogrv2         ; can't move up, go down next.
			dec	8,y																					; 		 dec (ix+8)          ; adjust new x coord.
			dec	<reg_B	
			bne	OGrvU0																				; 		 djnz ogrvu0
			rts																							; 		 ret
OGrvSt	ldb	14,y																					; ogrvst ld e,(ix+14)        ; get index to table.
																											; 		 ld d,0              ; no high byte.
			ldx	#jTab																					; 		 ld hl,jtab          ; jump table.
			abx																							; 		 add hl,de           ; hl points to jump value.
			lda	,x																						; 		 ld a,(hl)           ; fetch byte from table.
			cmpa	#99																					; 		 cp 99               ; is it the end marker?
			clr	13,y																					; 		 ld (ix+13),0        ; reset jump flag.
			clr	14,y																					; 		 ld (ix+14),0        ; reset pointer.
			bra	EvFtf																					; 		 jp evftf
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
OGrv2		ldx	#jTab																					; ogrv2  ld hl,jtab          ; jump table.
			clrb																							; 		 ld b,0              ; offset into table.
OGrv4		lda	,x																						; ogrv4  ld a,(hl)           ; fetch table byte.
			cmpa	#100																					; 		 cp 100              ; hit end or downward move?
			bcs	OGrv3																					; 		 jr c,ogrv3          ; yes.
			leax	1,x																					; 		 inc hl              ; next byte of table.
			incb																							; 		 inc b               ; next offset.
			bra	OGrv4																					; 		 jr ogrv4            ; keep going until we find crest/end of table.
OGrv3		stb	14,y																					; ogrv3  ld (ix+14),b        ; set next table offset.
OGrvEx	rts																							; 		 ret
; ------------------------------------------------------------------------------------------------------------------------------------------
; Initiate fall check																				; Initiate fall check.
; ------------------------------------------------------------------------------------------------------------------------------------------
IFall		lda	13,y																					; ifall  ld a,(ix+13)        ; jump pointer flag.
																											; 		 and a               ; are we in the air?
			bne	IFallEx																				; 		 ret nz              ; if set, we're already in the air.
			ldd	8,y							; inverted HL for dispX							; 		 ld h,(ix+9)         ; y coordinate.
			adda	#16																					; 		 ld a,16             ; look down 16 pixels.
			std	<dispX							; into dispXY										; 		 add a,(ix+8)        ; add x coordinate.
			exg	a,b							; invert bytes										; 		 ld l,a              ; coords in hl.
			tfr	d,x							; to regX											; 		 ld (dispx),hl       ; set up test coordinates.
			stx	<reg_HL						; and to pseudo register
			jsr	TstBl																					; 		 call tstbl          ; get map address.
			jsr	PlChk																					; 		 call plchk          ; block, platform check.
			bne	IFallEx																				; 		 ret nz              ; it's solid, don't fall.
			leax	1,x																					; 		 inc hl              ; look right one cell.
			stx	<reg_HL
			jsr	PlChk																					; 		 call plchk          ; block, platform check.
			bne	IFallEx																				; 		 ret nz              ; it's solid, don't fall.
			lda	<dispY																					; 		 ld a,(dispy)        ; y coordinate.
			anda	#7																						; 		 and 7               ; position straddling block cells.
			beq	IFalls																				; 		 jr z,ifalls         ; no more checks needed.
			leax	1,x																					; 		 inc hl              ; look to third cell.
			stx	<reg_HL
			jsr	PlChk																					; 		 call plchk          ; block, platform check.
			bne	IFallEx																				; 		 ret nz              ; it's solid, don't fall.
IFalls	inc	13,y																					; ifalls inc (ix+13)         ; set in air flag.
			clr	14,y																					; 		 ld (ix+14),0        ; initial speed = 0.
IFallEx	rts																							; 		 ret
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
TFall		lda	13,y																					; tfall  ld a,(ix+13)        ; jump pointer flag.
																											; 		 and a               ; are we in the air?
			bne	IFallEx																				; 		 ret nz              ; if set, we're already in the air.
			jsr	IFall																					; 		 call ifall          ; do fall test.
			lda	13,y																					; 		 ld a,(ix+13)        ; get falling flag.
																											; 		 and a               ; is it set?
			beq	IFallEx																				; 		 ret z               ; no.
			lda	#255
			sta	13,y																					; 		 ld (ix+13),255      ; we're using the table.
			jmp	OGrv2																					; 		 jr ogrv2            ; find position in table.
; ------------------------------------------------------------------------------------------------------------------------------------------
; Get frame data for a particular sprite														; Get frame data for a particular sprite.
; receives in regA frameNumber
; returns regX (HL)
; ------------------------------------------------------------------------------------------------------------------------------------------
GFrm		asla									; multiple of 2									; gfrm   rlca                ; multiple of 2.
			adca	#0								; pass bit7 to bit0
			tfr	a,b							; pass to low byte								; 		 ld e,a              ; copy to de.
			clra									; zero to high byte								; 		 ld d,0              ; no high byte as max sprite is 128.
			ldx	frmPtr						; get frame pointer								; 		 ld hl,(frmptr)      ; frames used by game.
			leax	d,x							; apply offset										; 		 add hl,de           ; point to frame start.
			rts									; return												; 		 ret
; ------------------------------------------------------------------------------------------------------------------------------------------
; Find sprite list for current room																; Find sprite list for current room.
; ------------------------------------------------------------------------------------------------------------------------------------------
SprLst	ldx	nmePtr						; point to enemies array						; sprlst ld a,(scno)         ; screen number.
			ldb	scNo							; get screen number								; sprls2 ld hl,(nmeptr)      ; pointer to enemies.
			beq	SprLsEx						; if zero, exit. Ptr OK							; 		 ld b,a              ; loop counter in b register.
																											; 		 and a               ; is it the first screen?
																											; 		 ret z               ; yes, don't need to search data.
																											; 		 ld de,NMESIZ        ; bytes to skip.
SprLs1	lda	,x								; get byte from array							; sprls1 ld a,(hl)           ; fetch type of sprite.
			inca									; was it 255?										; 		 inc a               ; is it an end marker?
			beq	SprLs0						; yes, go for next screen						; 		 jr z,sprls0         ; yes, end of this room.
			leax	NMESIZ,x						; no, point to next sprite in list			; 		 add hl,de           ; point to next sprite in list.
			bra	SprLs1						; loopback											; 		 jr sprls1           ; continue until end of room.
SprLs0	leax	1,x							; point to next screen 1st sprite			; sprls0 inc hl              ; point to start of next screen.
			decb									; decrement counter
			bne	SprLs1						; not yet done? loopback						; 		 djnz sprls1         ; continue until room found.
SprLsEx	rts									; return												; 		 ret
; ------------------------------------------------------------------------------------------------------------------------------------------
; Clear all but a single player sprite															; Clear all but a single player sprite.
; ------------------------------------------------------------------------------------------------------------------------------------------
NSpr		ldb	#NUMSPR																				; nspr   ld b,NUMSPR         ; sprite slots in table.
			ldy	#sprTab																				; 		 ld ix,sprtab        ; sprite table.
																											; 		 ld de,TABSIZ        ; distance to next odd/even entry.
NSpr0		lda	,y																						; nspr0  ld a,(ix+0)         ; fetch sprite type.
																											; 		 and a               ; is it a player?
			beq	NSpr1																					; 		 jr z,nspr1          ; yes, keep this one.
			lda	#255
			sta	,y																						; 		 ld (ix+0),255       ; delete sprite.
			sta	5,y																					; 		 ld (ix+5),255       ; remove next type.
			leay	TABSIZ,y																				; 		 add ix,de           ; next sprite.
			decb
			bne	NSpr0																					; 		 djnz nspr0          ; one less space in the table.
			rts																							; 		 ret
NSpr1		lda	#255
			sta	,y																						; nspr1  ld (ix+0),255       ; delete sprite.
			leay	TABSIZ,y																				; 		 add ix,de           ; point to next sprite.
			decb
			bne	NSpr2																					; 		 djnz nspr2          ; one less to do.
			rts																							; 		 ret
NSpr2		lda	#255	
			sta	,y																						; nspr2  ld (ix+0),255       ; delete sprite.
			sta	5,y																					; 		 ld (ix+5),255       ; remove next type.
			leay	TABSIZ,y																				; 		 add ix,de           ; next sprite.
			decb
			bne	NSpr2																					; 		 djnz nspr2          ; one less space in the table.
			rts																							; 		 ret
; ------------------------------------------------------------------------------------------------------------------------------------------
																											; Two initialisation routines.
; Initialise sprites - copy everything from list to table.								; Initialise sprites - copy everything from list to table.
; regX (HL) gets here pointing to the beginning of 1st sprite for that screen
; ------------------------------------------------------------------------------------------------------------------------------------------
ISpr		ldb	#NUMSPR						; number of sprites in table					; ispr   ld b,NUMSPR         ; sprite slots in table.
			ldy	#sprTab						; point to destination table					; 		 ld ix,sprtab        ; sprite table.
ISpr2		lda	,x								; get a byte from source						; ispr2  ld a,(hl)           ; fetch byte.
			cmpa	#255							; is it end marker?								; 		 cp 255              ; is it an end marker?
			beq	ISprEx						; yes, exit											; 		 ret z               ; yes, no more to do.
ISpr1		lda	,y								; get a byte from destination					; ispr1  ld a,(ix+0)         ; fetch sprite type.
			cmpa	#255							; is it enabled?									; 		 cp 255              ; is it enabled yet?
			bne	ISpr4							; yes, already in use, skip it				; 		 jr nz,ispr4         ; yes, try another slot.
			lda	5,y							; get 1st byte next sprite						; 		 ld a,(ix+5)         ; next type.
			cmpa	#255							; is it enabled?									; 		 cp 255              ; is it enabled yet?
			beq	ISpr3							; no, copy it										; 		 jr z,ispr3          ; no, process this one.
ISpr4		leay	TABSIZ,y						; point to next destination sprite			; ispr4  ld de,TABSIZ        ; distance to next odd/even entry.
			decb									; decrement counter								; 		 add ix,de           ; next sprite.
			bne	ISpr1							; not yet done? loopback						; 		 djnz ispr1          ; repeat for remaining sprites.
ISprEx	rts									; return												; 		 ret                 ; no more room in table.
ISpr3		jsr	CpSp							; Do copy sprite to destination				; ispr3  call cpsp           ; initialise a sprite.
			decb									; decrement counter
			bne	ISpr2							; not yet done? loopback						; 		 djnz ispr2          ; one less space in the table.
			rts									; return												; 		 ret
; ------------------------------------------------------------------------------------------------------------------------------------------
																											; Initialise sprites - but not player, we're keeping the old one.
; ------------------------------------------------------------------------------------------------------------------------------------------
KSpr		ldb	#NUMSPR																				; kspr   ld b,NUMSPR         ; sprite slots in table.
			ldy	#sprTab																				; 		 ld ix,sprtab        ; sprite table.
KSpr2		lda	,x																						; kspr2  ld a,(hl)           ; fetch byte.
			cmpa	#255																					; 		 cp 255              ; is it an end marker?
			beq	KSprEx																				; 		 ret z               ; yes, no more to do.
			tsta																							; 		 and a               ; is it a player sprite?
			bne	KSpr1																					; 		 jr nz,kspr1         ; no, add to table as normal.
																											; 		 ld de,NMESIZ        ; distance to next item in list.
			leax	NMESIZ,x																				; 		 add hl,de           ; point to next one.
			bra	KSpr2																					; 		 jr kspr2
KSpr1		lda	,y																						; kspr1  ld a,(ix+0)         ; fetch sprite type.
			cmpa	#255																					; 		 cp 255              ; is it enabled yet?
			bne	KSpr4																					; 		 jr nz,kspr4         ; yes, try another slot.
			lda	5,y																					; 		 ld a,(ix+5)         ; next type.
			cmpa	#255																					; 		 cp 255              ; is it enabled yet?
			beq	KSpr3																					; 		 jr z,kspr3          ; no, process this one.
KSpr4																										; kspr4  ld de,TABSIZ        ; distance to next odd/even entry.
			leay	TABSIZ,y																				; 		 add ix,de           ; next sprite.
			decb
			bne	KSpr1																					; 		 djnz kspr1          ; repeat for remaining sprites.
			rts																							; 		 ret                 ; no more room in table.
KSpr3		jsr	CpSp																					; kspr3  call cpsp           ; copy sprite to table.
			decb
			bne	KSpr2																					; 		 djnz kspr2          ; one less space in the table.
KSprEx	rts																							; 		 ret
; ------------------------------------------------------------------------------------------------------------------------------------------
; Copy sprite from list to table																	; Copy sprite from list to table
; regB arrives with number of sprites to deal with (saved register)
; regX points to source of data. regY points to destination
; ------------------------------------------------------------------------------------------------------------------------------------------
CpSp		pshs	b								; save working register
			lda	,x+							; get a byte from source						; cpsp   ld a,(hl)           ; fetch byte from table.
			sta	,y								; save to destination							; 		 ld (ix+0),a         ; set up type.
			sta	PAM1ST,y						; set up type										; 		 ld (ix+PAM1ST),a    ; set up type.
																											; 		 inc hl              ; move to next byte.
			lda	,x+							; get 2nd byte										; 		 ld a,(hl)           ; fetch byte from table.
			sta	6,y							; set up image										; 		 ld (ix+6),a         ; set up image.
																											; 		 inc hl              ; move to next byte.
			ldd	,x++							; get 3rd and 4th byte							; 		 ld a,(hl)           ; fetch byte from table.
																											; 		 ld (ix+3),200       ; set initial coordinate off screen.
			std	8,y							; set up coordinates								; 		 ld (ix+8),a         ; set up coordinate.
			ldb	#200							; use this value to								; 		 inc hl              ; move to next byte.
			stb	3,y							; set initial coordinate						; 		 ld a,(hl)           ; fetch byte from table.
																											; 		 ld (ix+9),a         ; set up coordinate.
																											; 		 inc hl              ; move to next byte.
			clra									; value zero										; 		 xor a               ; zeroes in accumulator.
			sta	7,y							; reset frame number								; 		 ld (ix+7),a         ; reset frame number.
			sta	10,y							; reset direction									; 		 ld (ix+10),a        ; reset direction.
																											; ;       ld (ix+12),a        ; reset parameter B.
			sta	13,y							; reset jump pointer low						; 		 ld (ix+13),a        ; reset jump pointer low.
			sta	14,y							; reset jump pointer high.						; 		 ld (ix+14),a        ; reset jump pointer high.
			deca
			sta	16,y							; reset data pointer to auto-restore		; 		 ld (ix+16),255      ; reset data pointer to auto-restore.
			pshs	x,y							; save pointers									; 		 push ix             ; store ix pair.
																											; 		 push hl             ; store hl pair.
																											; 		 push bc
Evis0		jsr	Evnt09						; perform event									; evis0  call evnt09         ; perform event.
			puls	x,y							; restore pointers								; 		 pop bc
																											; 		 pop hl              ; restore hl.
																											; 		 pop ix              ; restore ix.
																											; 		 ld de,TABSIZ        ; distance to next odd/even entry.
			leay	TABSIZ,y						; poit to next sprite							; 		 add ix,de           ; next sprite.
			puls	b,pc							; restore counter and return					; 		 ret
; ------------------------------------------------------------------------------------------------------------------------------------------
																											; Clear the play area window.
; ------------------------------------------------------------------------------------------------------------------------------------------
																											; clw    ld hl,(wintop)      ; get coordinates of window.
																											; 		 ld (dispx),hl       ; put into dispx for calculation.
																											; 		 ld a,(winhgt)       ; height of window.
																											; 		 ld b,a              ; copy to b register.
																											; clw3   push bc             ; store lines on stack.
																											; 		 ld a,(winwid)       ; width of window.
																											; clw2   ex af,af'           ; store column counter.
																											; 		 call gprad          ; get print address.
																											; 		 xor a               ; zero byute to write.
																											; 		 ld b,8              ; pixel height of each cell.
																											; clw1   ld (de),a           ; copy to screen.
																											; 		 inc d               ; next screen row down.
																											; 		 djnz clw1
																											; 		 call gaadd          ; get attribute address.
																											; 		 ld a,(23693)        ; get colour.
																											; 		 ld (hl),a           ; write colour.
																											; 		 ld hl,dispy         ; column position.
																											; 		 inc (hl)            ; next column.
																											; 		 ex af,af'           ; restore column counter.
																											; 		 dec a               ; one less to do.
																											; 		 jr nz,clw2          ; repeat for remaining columns.
																											; 		 ld a,(winlft)       ; get left edge.
																											; 		 ld (dispy),a        ; reset y.
																											; 		 ld hl,dispx         ; line.
																											; 		 inc (hl)            ; next line down.
																											; 		 pop bc              ; restore line counter.
																											; 		 djnz clw3           ; repeat down the screen.
																											; 		 ld hl,(wintop)      ; get coordinates of window.
																											; 		 ld (charx),hl       ; put into display position.
																											; 		 ret
; ------------------------------------------------------------------------------------------------------------------------------------------
																											; Effects code.
																											; Ticker routine is called 25 times per second.
; ------------------------------------------------------------------------------------------------------------------------------------------
																											; scrly  ret
																											; 		 defw txtscr         ; get screen address.
																											; 		 ld b,8              ; 8 pixel rows.
																											; 		 push hl             ; store screen address.
																											; scrly1 push bc             ; store rows on stack.
																											; 		 push hl
																											; 		 ld a,(txtwid)       ; characters wide.
																											; 		 ld b,a              ; put into the loop counter.
																											; 		 and a               ; reset carry flag.
																											; scrly0 rl (hl)             ; rotate left.
																											; 		 dec l               ; char left.
																											; 		 djnz scrly0         ; repeat for width of ticker message.
																											; 		 pop hl
																											; 		 inc h               ; next row down.
																											; 		 pop bc              ; retrieve row counter from stack.
																											; 		 djnz scrly1         ; repeat for all rows.
																											; 		 ld hl,(txtpos)      ; get text pointer.
																											; 		 ld a,(hl)           ; find character we're displaying.
																											; 		 and 127             ; remove end marker bit if applicable.
																											; 		 cp 13               ; is it newline?
																											; 		 jr nz,scrly5        ; no, it's okay.
																											; 		 ld a,32             ; convert to a space instead.
																											; scrly5 rlca
																											; 		 rlca
																											; 		 rlca                ; multiply by 8 to find char.
																											; 		 ld b,a              ; store shift in b.
																											; 		 and 3               ; keep within 768-byte range of font.
																											; 		 ld d,a              ; that's our high byte.
																											; 		 ld a,b              ; restore the shift.
																											; 		 and 248
																											; 		 ld e,a
																											; 		 ld hl,(23606)       ; font address.
																											; 		 add hl,de           ; point to image of character.
																											; 		 ex de,hl            ; need the address in de.
																											; 		 pop hl
																											; 		 ld a,(txtbit)
																											; 		 ld c,a
																											; 		 ld b,8
																											; scrly3 ld a,(de)           ; get image of char line.
																											; 		 and c               ; test relevant bit of char.
																											; 		 jr z,scrly2         ; not set - skip.
																											; 		 inc (hl)            ; set bit.
																											; scrly2 inc h               ; next line of window.
																											; 		 inc de              ; next line of char.
																											; 		 djnz scrly3
																											; 		 ld hl,txtbit        ; bit of text to display.
																											; 		 rrc (hl)            ; next bit of char to use.
																											; 		 ret nc              ; not reached end of character yet.
																											; 		 ld hl,(txtpos)      ; text pointer.
																											; 		 ld a,(hl)           ; what was the character?
																											; 		 inc hl              ; next character in message.
																											; 		 rla                 ; end of message?
																											; ;       ret nc              ; not yet, exit here.
																											; ;       ld a,201            ; code for ret.
																											; ;       ld (scrly),a        ; disable scrolling routine.
																											; 		 jr nc,scrly6        ; not yet - continue.
																											; scrly4 ld hl,(txtini)      ; start of scrolling message.
																											; scrly6 ld (txtpos),hl      ; new text pointer position.
																											; 		 ret
; ------------------------------------------------------------------------------------------------------------------------------------------
																											; iscrly call prescr         ; set up display position.
																											; 		 ld hl,msgdat        ; text messages.
																											; 		 ld a,b              ; width.
																											; 		 dec a               ; subtract one.
																											; 		 cp 32               ; is it between 1 and 32?
																											; 		 jr nc,iscrl0        ; no, disable messages.
																											; 		 ld a,c              ; message number.
																											; 		 ld d,b              ; copy width to d.
																											; 		 call getwrd         ; find message start.
																											; 		 ld b,d              ; restore width to b register.
																											; 		 ld (txtini),hl      ; set initial text position.
																											; 		 ld a,42             ; code for ld hl,(nn).
																											; iscrl0 ld (scrly),a        ; enable/disable scrolling routine.
																											; 		 call prescr         ; set up display position.
																											; 		 call gprad          ; get print address.
																											; 		 ld l,b              ; width in b so copy to hl.
																											; 		 ld h,0              ; no high byte.
																											; 		 dec hl              ; width minus one.
																											; 		 add hl,de           ; add width.
																											; 		 ld (txtscr),hl      ; set text screen address.
																											; 		 ld a,b              ; width.
																											; 		 ld (txtwid),a       ; set width in working storage.
																											; 		 ld hl,txtbit        ; bit of text to display.
																											; 		 ld (hl),128         ; start with leftmost bit.
																											; 		 jr scrly4
; ------------------------------------------------------------------------------------------------------------------------------------------
																											; Sprite table.
																											; ix+0  = type.
																											; ix+1  = sprite image number.
																											; ix+2  = frame.
																											; ix+3  = x coord.
																											; ix+4  = y coord.

																											; ix+5  = new type.
																											; ix+6  = new image number.
																											; ix+7  = new frame.
																											; ix+8  = new x coord.
																											; ix+9  = new y coord.

																											; ix+10 = direction.
																											; ix+11 = parameter 1.
																											; ix+12 = parameter 2.
																											; ix+13 = jump pointer low.
																											; ix+14 = jump pointer high.
																											; ix+15 = data pointer low.
																											; ix+16 = data pointer high.
; ------------------------------------------------------------------------------------------------------------------------------------------
roomTb	fcb	34								; room number										; roomtb defb 34                     ; room number.
; ------------------------------------------------------------------------------------------------------------------------------------------
;  												END OF STD ENGINE ###1
; ------------------------------------------------------------------------------------------------------------------------------------------

; ------------------------------------------------------------------------------------------------------------------------------------------
; 													6809 Added constants, variables and subroutines ###2
; ------------------------------------------------------------------------------------------------------------------------------------------
SCRBEG	equ	$e600							; to make it CoCo-Compatible (with discs)
SCREND	equ	SCRBEG+$1800				; $e600+6144=$fe00
	IF PMODE4
scrMode	equ	$f8							; $f8 PMODE4 artifacted colors
													; $f0 PMODE4 green monochrome
	ELSE
scrMode	equ	$e0							; $e0	PMODE3 green palete
													; $e8 PMODE3 buff palete
	ENDIF
setPIA 	equ	$ff22							; Screen selection address
SCRROWS	equ	192							; number of screen rows
; ------------------------------------------------------------------------------------------------------------------------------------------
; switch to MAP1 copying only the Basic Interpreter, NO DOS
; ------------------------------------------------------------------------------------------------------------------------------------------
SwMap1	ldx	#$015e						; point to hooks beginning
			lda	#$39							; opcode for RTS
SwML01	sta	,x+							; disable hoop
			cmpx	#$1a9							; got to the end?
			blo	SwML01						; no, loopback
			ldx	#$8000						; point to std BASIC ROM
SwML02	sta	$ffde							; switch to MAP0 (RAM-ROM)
			ldd	,x								; get a word
			sta	$ffdf							; switch to MAP1 (all 64k RAM)
			std	,x++							; put at destination
			cmpx	#$c000 						; copied full ROMs?
			blo	SwML02						; no, loopback
			rts									; return
; ------------------------------------------------------------------------------------------------------------------------------------------
; exit the program and return to the Interpreter 
; ------------------------------------------------------------------------------------------------------------------------------------------
ExitGame	clr	$71							; set cold restart
			sta	$ffde							; back to MAP0
			andcc	#$af							; enable interrupts
			jmp	[$fffe]						; restart computer
; ------------------------------------------------------------------------------------------------------------------------------------------
; reads keyboard returns keypress in A (zero or a column number)
;  changed to avoid last ROM call. Now 1st RAM page is free for variables!!
; ------------------------------------------------------------------------------------------------------------------------------------------
ReadK		clr	$ff02							; read all columns
			lda	$ff00							; get result
			ora	#$80							; bit 7 not relevant
			coma									; convert a press (value 0) to value 1
			rts									; return
; ------------------------------------------------------------------------------------------------------------------------------------------
; Sets the graphic Mode and points to the graph page beginning
; ------------------------------------------------------------------------------------------------------------------------------------------
SetPMode	sta	$ffc0							; set SAM
			sta	$ffc3							;   for 
			sta	$ffc5							;   PMODE4
			lda	#scrMode						; set PIA
			sta	setPIA						;   to PM4 green palete
												; set page = $e600/$200 = $73 = 115 = %1110011
			sta	$ffd3							; bit6 = 1
			sta	$ffd1							; bit5 = 1
			sta	$ffcf							; bit4 = 1
			sta	$ffcc							; bit3 = 0
			sta	$ffca							; bit2 = 0
			sta	$ffc9							; bit1 = 1
			sta	$ffc7							; bit0 = 1
			rts									; return
; ------------------------------------------------------------------------------------------------------------------------------------------
; config DAC sound and VSync detection at the end of frame
; ------------------------------------------------------------------------------------------------------------------------------------------
CfgHdw	clrb									; flag for Dragon machine
			lda	$fffe							; read high byte for Reset address
			cmpa	#$b3							; is it a Dragon? ($b3b4)
			beq	CfgHdw1						; yes, skip next
			incb									; set flag for CoCo machine
CfgHdw1	stb	<cocoFlg						; write to variable
			ldb	#keysD-keys					; get offset to Dragon codes
			tst	<cocoFlg						; is this a CoCo?
			beq	CfgNoCC						; no, skip next
			ldb	#keysC-keys					; get offset to CoCo codes
CfgNoCC	stb	scanOff						; offset for scanning keys / joysticks
			lda	$ff01							; get config PIA0-SideA
			anda	#%11110100					; reset LSB of MUX. Disable HS IRQ to CPU
			sta	$ff01							; update config PIA0-SideA
			lda	$ff03							; get config PIA0-SideB
			anda	#%11110100					; reset MSB of MUX -> %00 select DAC sound. Flag set on falling edge
			ora	#%00000001					; Enable FS IRQ to CPU
			sta	$ff03							; update config PIA0-SideB
			clr	$ff20							; set zero sound volume
			lda	$ff23							; get config PIA1-SideB
			ora	#%00001000					; enable DAC sound
			sta	$ff23							; update config PIA1-SideB
			ldx	#IRQHndlr					; get new IRQ dispatcher address
			stx	$010d							; set in system hook
			andcc	#$ef							; allow IRQ			
			rts									; return
; ------------------------------------------------------------------------------------------------------------------------------------------
; new IRQ Handler (for Vertical Blanking interrupt)
; ------------------------------------------------------------------------------------------------------------------------------------------
IRQHndlr	lda	$ff03							; is an FS IRQ?
			bmi	IRQRcvd						; yes, skip next
			rti									; return from interrupt
IRQRcvd	lda	$ff02							; clear flag
			inc	$0113							; increment counter
			rti									; return from interrupt
; ------------------------------------------------------------------------------------------------------------------------------------------
													; interchanges contents of registers BC, DE and HL with their mirrors (Z80 exx opcode)
													; here they are: reg_BC, reg_DE, reg_HL with esp_BC, esp_DE, esp_HL
do_exx	pshs	x,u							; save registers
			ldx	<reg_BC						; get register BC
			ldu	<esp_BC						; get mirror BC
			stx	<esp_BC						; put register into mirror
			stu	<reg_BC						; put mirror into register
			ldx	<reg_DE						; get register DE
			ldu	<esp_DE						; get mirror DE
			stx	<esp_DE						; put register into mirror
			stu	<reg_DE						; put mirror into register
			ldx	<reg_HL						; get register HL
			ldu	<esp_HL						; get mirror HL
			stx	<esp_HL						; put register into mirror
			stu	<reg_HL						; put mirror into register
			puls	x,u,pc						; restore registers and return
; --------------------------------------------------------------------------------------------------------------------------------------------------------------------
EndMotor	equ	*
MotorLen	equ	EndMotor-Start
; ------------------------------------------------------------------------------------------------------------------------------------------




; ------------------------------------------------------------------------------------------------------------------------------------------
;													DATA AND CODE PARTICULAR TO THE GAME *** FOGGY ***
; ------------------------------------------------------------------------------------------------------------------------------------------
GameData	equ	*																						; Everything below here will be generated by the editors.
;																											; Sounds.
;																											; fx1    defb 128+15         ; volume and mixer.
;																											; 		 defb 31             ; white noise.
;																											; 		 defw 1000           ; tone register.
;																											; 		 defb 128+15         ; volume and mixer.
;																											; 		 defb 25             ; white noise.
;																											; 		 defw 1000           ; tone register.
;																											; 		 defb 128+14         ; volume and mixer.
;																											; 		 defb 19             ; white noise.
;																											; 		 defw 1000           ; tone register.
;																											; 		 defb 128+13         ; volume and mixer.
;																											; 		 defb 13             ; white noise.
;																											; 		 defw 1000           ; tone register.
;																											; 		 defb 128+12         ; volume and mixer.
;																											; 		 defb 7              ; white noise.
;																											; 		 defw 1000           ; tone register.
;																											; 		 defb 128+11         ; volume and mixer.
;																											; 		 defb 0              ; white noise.
;																											; 		 defw 1000           ; tone register.
;																											; 		 defb 128+10         ; volume and mixer.
;																											; 		 defb 6              ; white noise.
;																											; 		 defw 1000           ; tone register.
;																											; 		 defb 128+8          ; volume and mixer.
;																											; 		 defb 12             ; white noise.
;																											; 		 defw 1000           ; tone register.
;																											; 		 defb 128+6          ; volume and mixer.
;																											; 		 defb 18             ; white noise.
;																											; 		 defw 1000           ; tone register.
;																											; 		 defb 128+3          ; volume and mixer.
;																											; 		 defb 24             ; white noise.
;																											; 		 defw 1000           ; tone register.
;																											; 		 defb 255
; ------------------------------------------------------------------------------------------------------------------------------------------
;																											; fx2    defb 064+15         ; volume and mixer.
;																											; 		 defb 27             ; white noise.
;																											; 		 defw 1000           ; tone register.
;																											; 		 defb 064+14         ; volume and mixer.
;																											; 		 defb 31             ; white noise.
;																											; 		 defw 2000           ; tone register.
;																											; 		 defb 064+13         ; volume and mixer.
;																											; 		 defb 28             ; white noise.
;																											; 		 defw 3000           ; tone register.
;																											; 		 defb 064+12         ; volume and mixer.
;																											; 		 defb 31             ; white noise.
;																											; 		 defw 2000           ; tone register.
;																											; 		 defb 064+11         ; volume and mixer.
;																											; 		 defb 29             ; white noise.
;																											; 		 defw 1000           ; tone register.
;																											; 		 defb 064+10         ; volume and mixer.
;																											; 		 defb 31             ; white noise.
;																											; 		 defw 2000           ; tone register.
;																											; 		 defb 064+9          ; volume and mixer.
;																											; 		 defb 30             ; white noise.
;																											; 		 defw 3000           ; tone register.
;																											; 		 defb 064+8          ; volume and mixer.
;																											; 		 defb 31             ; white noise.
;																											; 		 defw 2000           ; tone register.
;																											; 		 defb 064+7          ; volume and mixer.
;																											; 		 defb 31             ; white noise.
;																											; 		 defw 1000           ; tone register.
;																											; 		 defb 064+6          ; volume and mixer.
;																											; 		 defb 31             ; white noise.
;																											; 		 defw 2000           ; tone register.
;																											; 		 defb 255
; ------------------------------------------------------------------------------------------------------------------------------------------
;																											; fx3    defb 064+15         ; volume and mixer.
;																											; 		 defb 0              ; white noise.
;																											; 		 defw 4000           ; tone register.
;																											; 		 defb 064+15         ; volume and mixer.
;																											; 		 defb 0              ; white noise.
;																											; 		 defw 4100           ; tone register.
;																											; 		 defb 064+14         ; volume and mixer.
;																											; 		 defb 0              ; white noise.
;																											; 		 defw 4200           ; tone register.
;																											; 		 defb 064+14         ; volume and mixer.
;																											; 		 defb 0              ; white noise.
;																											; 		 defw 4300           ; tone register.
;																											; 		 defb 064+13         ; volume and mixer.
;																											; 		 defb 0              ; white noise.
;																											; 		 defw 4400           ; tone register.
;																											; 		 defb 064+13         ; volume and mixer.
;																											; 		 defb 0              ; white noise.
;																											; 		 defw 4500           ; tone register.
;																											; 		 defb 064+12         ; volume and mixer.
;																											; 		 defb 0              ; white noise.
;																											; 		 defw 4600           ; tone register.
;																											; 		 defb 064+12         ; volume and mixer.
;																											; 		 defb 0              ; white noise.
;																											; 		 defw 4700           ; tone register.
;																											; 		 defb 064+11         ; volume and mixer.
;																											; 		 defb 0              ; white noise.
;																											; 		 defw 4800           ; tone register.
;																											; 		 defb 064+10         ; volume and mixer.
;																											; 		 defb 0              ; white noise.
;																											; 		 defw 4900           ; tone register.
;																											; 		 defb 255
; ------------------------------------------------------------------------------------------------------------------------------------------
																											; 		 defb 99             ; temporary marker.
; ------------------------------------------------------------------------------------------------------------------------------------------
																											; User routine.  Put your own code in here to be called with USER instruction.
																											; if USER has an argument it will be passed in the accumulator.
; ------------------------------------------------------------------------------------------------------------------------------------------
																											; user   ret
; ------------------------------------------------------------------------------------------------------------------------------------------
; Game-specific data and events code generated by the compiler							; Game-specific data and events code generated by the compiler
; ------------------------------------------------------------------------------------------------------------------------------------------
