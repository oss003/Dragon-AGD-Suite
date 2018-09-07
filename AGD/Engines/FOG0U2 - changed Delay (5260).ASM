; ------------------------------------------------------------------------------------------------------------------------------------------
; Game engine code 
; Arcade Game Designer.
; (C) 2008 - 2018 Jonathan Cauldwell.
; ZX Spectrum Engine v0.7.
; v0.U2 - converted to 6809 - Pere Serrat - 2018-09-04	-	free 5260 bytes
; ------------------------------------------------------------------------------------------------------------------------------------------
; Global definitions.																				; Global definitions.
; ------------------------------------------------------------------------------------------------------------------------------------------
																											; SIMASK equ 248					; SPRITEINK mask - allows users to set BRIGHT/FLASH/CLUT as well.
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
; register B contains de number of loops to be done
; ------------------------------------------------------------------------------------------------------------------------------------------
Delay		ldx	<reg_IX						; get pseudo register
			pshs	x								; save onto stack
Delay1	pshs	b								; save counter										; delay  push bc             ; store loop counter.
			jsr	VSync							; wait for FS interrupt							; 		 call vsync          ; wait for interrupt.
			puls	b								; restore counter									; 		 pop bc              ; restore counter.
			decb									; decrement it			
			bne	Delay1						; not zero, loopback								; 		 djnz delay          ; repeat.
			puls	x								; restore pseudo register
			stx	<reg_IX						; update it
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
ReadK		jsr	[$A000]
;;;			clr	$ff02							; read all columns
;;;			lda	$ff00							; get result
;;;			ora	#$80							; bit 7 not relevant
;;;			coma									; convert a press (value 0) to value 1
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
WINDOWTOP	equ	0																					; WINDOWTOP equ 0
WINDOWLFT	equ	2																					; WINDOWLFT equ 2
WINDOWHGT	equ	20																					; WINDOWHGT equ 20
WINDOWWID	equ	28																					; WINDOWWID equ 28 ;@
MAPWID	equ	10																						; MAPWID equ 10
			fcb	255,255,255,255,255,255,255,255,255,255									; 		 defb 255,255,255,255,255,255,255,255,255,255
mapDat	equ	*																						; mapdat equ $
			fcb	255, 27,255, 20,255, 23,255,255,255,255									; 		 defb 255,27,255,20,255,23,255,255,255,255
			fcb	255,255,255, 19, 21, 22, 24, 25, 26,255									; 		 defb 255,255,255,19,21,22,24,25,26,255
			fcb	255,255, 14, 13, 12, 11, 10, 18, 17,255									; 		 defb 255,255,14,13,12,11,10,18,17,255
			fcb	255,255,255, 15,  3,  0,  4,  6,  8,255									; 		 defb 255,255,255,15,3,0,4,6,8,255
			fcb	255,255,255, 16,  2,  1,  5,  7,  9,255									; 		 defb 255,255,255,16,2,1,5,7,9,255
			fcb	255,255,255,255,255,255,255,255,255,255									; 		 defb 255,255,255,255,255,255,255,255,255,255
stMap		fcb	35																						; stmap  defb 35
; ------------------------------------------------------------------------------------------------------------------------------------------
Evnt00																									; evnt00 equ $
			jsr 	CanGD																					; 		 call cangd
			bne	A00017																				; 		 jp nz,a00017
			jsr	TFall																					; 		 call tfall
A00017	jsr	SkObj																					; a00017 call skobj
			sta	varObj																				; 		 ld (varobj),a
																											; 		 ld a,255
																											; 		 ld hl,varobj
			cmpa	#255																					; 		 cp (hl)
			beq	A00465																				; 		 jp z,a00465
																											; 		 ld a,(varobj)
			jsr	GetOb			 																		; 		 call getob
			lda	#50																					; 		 ld a,50
			sta	<sndTyp																				; 		 ld (sndtyp),a
			lda	#1																						; 		 ld a,1
																											; 		 ld hl,scno
			cmpa	scNo																					; 		 cp (hl)
			bne	A00128																				; 		 jp nz,a00128
													; SCREEN #1
																											; 		 ld a,(vark)
			lbsr	Evnt0R1						; subtitutes next FIVE							; 		 inc a
;S			inc	<varK																					; 		 ld (vark),a
																											; 		 ld a,79
																											; 		 ld (23693),a
;S			ldd	#$1d14						; 29-20 (X - Y for Disply)						; 		 ld a,20
																											; 		 ld (charx),a
																											; 		 ld a,29
;S			std	<charX																					; 		 ld (chary),a
;S			lda	<varK							; number to be shown								; 		 ld a,(vark)
;S			jsr	Disply						; print number										; 		 call disply
A00128	lda	#16																					; a00128 ld a,16
																											; 		 ld hl,scno
			cmpa	scNo																					; 		 cp (hl)
			bne	A00194																				; 		 jp nz,a00194
													; SCREEN #16
																											; 		 ld a,(vark)
			jsr	Evnt0R1						; subtitutes next FIVE							; 		 inc a
;S			inc	<varK																					; 		 ld (vark),a
																											; 		 ld a,79
																											; 		 ld (23693),a
;S			ldd	#$1d14						; 29-20 (X - Y for Disply)						; 		 ld a,20
																											; 		 ld (charx),a
																											; 		 ld a,29
;S			std	<charX																					; 		 ld (chary),a
;S			lda	<varK							; number to be shown								; 		 ld a,(vark)
;S			jsr	Disply						; print number										; 		 call disply
A00194	lda	#7																						; a00194 ld a,7
																											; 		 ld hl,scno
			cmpa	scNo																					; 		 cp (hl)
			bne	A00272																				; 		 jp nz,a00272
													; SCREEN #7
			lda	#3																						; 		 ld a,3
			jsr	GotOb																					; 		 call gotob
			bcs	A00272																				; 		 jp c,a00272
																											; 		 ld a,(vark)
			jsr	Evnt0R1						; subtitutes next FIVE							; 		 inc a
;S			inc	<varK																					; 		 ld (vark),a
																											; 		 ld a,79
																											; 		 ld (23693),a
;S			ldd	#$1d14						; 29-20 (X - Y for Disply)						; 		 ld a,20
																											; 		 ld (charx),a
																											; 		 ld a,29
;S			std	<charX																					; 		 ld (chary),a
;S			lda	<varK							; number to be shown								; 		 ld a,(vark)
;S			jsr	Disply						; print number										; 		 call disply
A00272	lda	#13																					; a00272 ld a,13
																											; 		 ld hl,scno
			cmpa	scNo																					; 		 cp (hl)
			bne	A00314																				; 		 jp nz,a00314
													; SCREEN #13
			lda	#9																						; 		 ld a,9
			jsr	GotOb																					; 		 call gotob
			bcs	A00314																				; 		 jp c,a00314
																											; 		 ld a,(varc)
																											; 		 inc a
			inc	<varC																					; 		 ld (varc),a
A00314	lda	#17																					; a00314 ld a,17
																											; 		 ld hl,scno
			cmpa	scNo																					; 		 cp (hl)
			bne	A00389																				; 		 jp nz,a00389
													; SCREEN #17
																											; 		 ld a,(numlif)
			jsr	Evnt0R2						; subtitutes next SIX							; 		 inc a
;S			inc	numLif																				; 		 ld (numlif),a
																											; 		 ld a,78
																											; 		 ld (23693),a
;S			ldd	#$1d15						; 29-21 (X - Y for Disply)						; 		 ld a,21
																											; 		 ld (charx),a
																											; 		 ld a,29
;S			std	<charX																					; 		 ld (chary),a
;S			lda	numLif						; number of lives									; 		 ld a,(numlif)
;S			jsr	Disply						; show it											; 		 call disply
;S			lda	#1																						; 		 ld a,1
			sta	<varH																					; 		 ld (varh),a
A00389	lda	#19																					; a00389 ld a,19
																											; 		 ld hl,scno
			cmpa	scNo																					; 		 cp (hl)
			bne	A00465																				; 		 jp nz,a00465
													; SCREEN #19
																											; 		 ld a,(numlif)
			jsr	Evnt0R2						; subtitutes next SIX							; 		 inc a
;S			inc	numLif																				; 		 ld (numlif),a
																											; 		 ld a,78
																											; 		 ld (23693),a
;S			ldd	#$1d15						; 29-21 (X - Y for Disply)						; 		 ld a,21
																											; 		 ld (charx),a
																											; 		 ld a,29
;S			std	<charX																					; 		 ld (chary),a
;S			lda	numLif						; number of lives									; 		 ld a,(numlif)
;S			jsr	Disply						; show it											; 		 call disply
;S			lda	#1																						; 		 ld a,1
			sta	<varI																					; 		 ld (vari),a
													; END OF SCREENS
A00465	lda	#223																					; a00465 ld a,223
			cmpa	9,y																					; 		 cp (ix+9)
			bcc	A00510																				; 		 jp nc,a00510
													; GO ROOM RIGHT
			jsr	ScrR																					; 		 call scrr
			lda	#32																					; 		 ld a,32
			sta	9,y																					; 		 ld (ix+9),a
			ldd	8,y																					; 		 ld a,(ix+8)
																											; 		 ld (varo),a
																											; 		 ld a,(ix+9)
			std	<varO																					; 		 ld (varp),a
A00510	lda	#16																					; a00510 ld a,16
			cmpa	9,y																					; 		 cp (ix+9)
			bcs	A00554																				; 		 jp c,a00554
													; GO ROOM LEFT
			jsr	ScrL																					; 		 call scrl
			lda	#208																					; 		 ld a,208
			sta	9,y																					; 		 ld (ix+9),a
			ldd	8,y																					; 		 ld a,(ix+8)
																											; 		 ld (varo),a
																											; 		 ld a,(ix+9)
			std	<varO																					; 		 ld (varp),a
A00554	lda	#2																						; a00554 ld a,2
			cmpa	8,y																					; 		 cp (ix+8)
			bcs	A00599																				; 		 jp c,a00599
													; GO ROOM UP
			jsr	ScrU																					; 		 call scru
			lda	#140																					; 		 ld a,140
			sta	8,y																					; 		 ld (ix+8),a
			ldd	8,y																					; 		 ld a,(ix+8)
																											; 		 ld (varo),a
																											; 		 ld a,(ix+9)
			std	<varO																					; 		 ld (varp),a
A00599	lda	#140																					; a00599 ld a,140
			cmpa	8,y																					; 		 cp (ix+8)
			bcc	A00644																				; 		 jp nc,a00644
													; GO ROOM DOWN
			jsr	ScrD																					; 		 call scrd
			lda	#8																						; 		 ld a,8
			sta	8,y																					; 		 ld (ix+8),a
			ldd	8,y																					; 		 ld a,(ix+8)
																											; 		 ld (varo),a
																											; 		 ld a,(ix+9)
			std	<varO																					; 		 ld (varp),a
													; END OF ROOM CHANGE
A00644	jsr	LaddD																					; a00644 call laddd
			bne	A00683																				; 		 jp nz,a00683
			lda	#2																						; 		 ld a,2
			sta	<varL																					; 		 ld (varl),a
			jsr	LaddU																					; 		 call laddu
			bne	A00679																				; 		 jp nz,a00679
			lda	#1																						; 		 ld a,1
			sta	<varL																					; 		 ld (varl),a
A00679	bra	A00691																				; a00679 jp a00691
A00683																									; a00683 xor a
			clr	<varL																					; 		 ld (varl),a
													; REQUESTED MOVES
A00691	lda	<joyVal																				; a00691 ld a,(joyval)
			anda	#1																						; 		 and 1
			beq	A00931																				; 		 jp z,a00931
													; move RIGHT
			jsr	CanGR																					; 		 call cangr
			bne	A00931																				; 		 jp nz,a00931
			lda	<joyVal																				; 		 ld a,(joyval)
			anda	#4																						; 		 and 4
			beq	A00787																				; 		 jp z,a00787
													; move ladder DOWN
			jsr	LaddD																					; 		 call laddd
;S			bne	A00741																				; 		 jp nz,a00741
;S			bra	A00783																				; 		 jp a00783
			beq	A00783						; substitutes previous TWO						; 		 jp a00783
A00741																									; a00741 xor a
																											; 		 ld hl,vara
			tst	<varA																					; 		 cp (hl)
			bne	A00766																				; 		 jp nz,a00766
;S			clra																							; 		 xor a
;S			jsr	AnimSp																				; 		 call animsp
			jsr	AnimSp0						; substitutes previous TWO						; 		 call animsp
A00766																									; a00766 xor a
			clr	6,y																					; 		 ld (ix+6),a
			inc	9,y																					; 		 inc (ix+9)
			inc	9,y																					; 		 inc (ix+9)
A00783	bra	A00931																				; a00783 jp a00931
A00787	lda	<joyVal																				; a00787 ld a,(joyval)
			anda	#8																						; 		 and 8
			beq	A00860																				; 		 jp z,a00860
													; move ladder UP
			jsr	LaddU																					; 		 call laddu
;S			bne	A00814																				; 		 jp nz,a00814
;S			bra	A00855																				; 		 jp a00855
			beq	A00855						; substitutes previous TWO						; 		 jp a00855
A00814																									; a00814 xor a
			clr	6,y																					; 		 ld (ix+6),a
																											; 		 xor a
																											; 		 ld hl,vara
			tst	<varA																					; 		 cp (hl)
			bne	A00846																				; 		 jp nz,a00846
;S			clra																							; 		 xor a
;S			jsr	AnimSp																				; 		 call animsp
			jsr	AnimSp0						; substitutes previous TWO						; 		 call animsp
A00846	inc	9,y																					; a00846 inc (ix+9)
			inc	9,y																					; 		 inc (ix+9)
A00855	bra	A00931																				; a00855 jp a00931
A00860	lda	#1																						; a00860 ld a,1
			sta	<varD																					; 		 ld (vard),a
																											; 		 xor a
			clr	6,y																					; 		 ld (ix+6),a
																											; 		 xor a
																											; 		 ld hl,vara
			tst	<varA																					; 		 cp (hl)
			bne	A00922																				; 		 jp nz,a00922
;S			clra																							; 		 xor a
;S			jsr	AnimSp																				; 		 call animsp
			jsr	AnimSp0						; substitutes previous TWO						; 		 call animsp
																											; 		 xor a
			tst	7,y																					; 		 cp (ix+7)
			bne	A00922																				; 		 jp nz,a00922
			lda	#20																					; 		 ld a,20
			sta	<sndTyp																				; 		 ld (sndtyp),a
A00922	inc	9,y																					; a00922 inc (ix+9)
			inc	9,y																					; 		 inc (ix+9)
A00931	lda	<joyVal																				; a00931 ld a,(joyval)
			anda	#2																						; 		 and 2
			beq	A01171																				; 		 jp z,a01171
													; move LEFT
			jsr	CanGL																					; 		 call cangl
			bne	A01171																				; 		 jp nz,a01171
			lda	<joyVal																				; 		 ld a,(joyval)
			anda	#4																						; 		 and 4
			beq	A01027																				; 		 jp z,a01027
													; move ladder DOWN
			jsr	LaddD																					; 		 call laddd
;S			bne	A00981																				; 		 jp nz,a00981
;S			bra	A01022																				; 		 jp a01022
			beq	A01022						; substitutes previous TWO						; 		 jp a01022
A00981																									; a00981 xor a
																											; 		 ld hl,vara
			tst	<varA																					; 		 cp (hl)
			bne	A01005																				; 		 jp nz,a01005
;S			clra																							; 		 xor a
;S			jsr	AnimSp																				; 		 call animsp
			jsr	AnimSp0						; substitutes previous TWO						; 		 call animsp
A01005	lda	#1																						; a01005 ld a,1
			sta	6,y																					; 		 ld (ix+6),a
			dec	9,y																					; 		 dec (ix+9)
			dec	9,y																					; 		 dec (ix+9)
A01022	bra	A01171																				; a01022 jp a01171
A01027	lda	<joyVal																				; a01027 ld a,(joyval)
			anda	#8																						; 		 and 8
			beq	A01100																				; 		 jp z,a01100
													; move ladder UP
			jsr	LaddU																					; 		 call laddu
;S			bne	A01054																				; 		 jp nz,a01054
;S			bra	A01095																				; 		 jp a01095
			beq	A01095						; substitutes previous TWO						; 		 jp a01095
A01054	lda	#1																						; a01054 ld a,1
			sta	6,y																					; 		 ld (ix+6),a
																											; 		 xor a
																											; 		 ld hl,vara
			tst	<varA																					; 		 cp (hl)
			bne	A01086																				; 		 jp nz,a01086
;S			clra																							; 		 xor a
;S			jsr	AnimSp																				; 		 call animsp
			jsr	AnimSp0						; substitutes previous TWO						; 		 call animsp
A01086	dec	9,y																					; a01086 dec (ix+9)
			dec	9,y																					; 		 dec (ix+9)
A01095	bra	A01171																				; a01095 jp a01171
A01100	lda	#2																						; a01100 ld a,2
			sta	<varD																					; 		 ld (vard),a
			lda	#1																						; 		 ld a,1
			sta	6,y																					; 		 ld (ix+6),a
																											; 		 xor a
																											; 		 ld hl,vara
			tst	<varA																					; 		 cp (hl)
			bne	A01162																				; 		 jp nz,a01162
;S			clra																							; 		 xor a
;S			jsr	AnimSp																				; 		 call animsp
			jsr	AnimSp0						; substitutes previous TWO						; 		 call animsp
																											; 		 xor a
			tst	7,y																					; 		 cp (ix+7)
			bne	A01162																				; 		 jp nz,a01162
			lda	#20																					; 		 ld a,20
			sta	<sndTyp																				; 		 ld (sndtyp),a
A01162	dec	9,y																					; a01162 dec (ix+9)
			dec	9,y																					; 		 dec (ix+9)
A01171	lda	<joyVal																				; a01171 ld a,(joyval)
			anda	#8																						; 		 and 8
			beq	A01244																				; 		 jp z,a01244
													; move ladder UP
			lda	#3																						; 		 ld a,3
			sta	<varD																					; 		 ld (vard),a
			jsr	LaddU																					; 		 call laddu
			bne	A01244																				; 		 jp nz,a01244
			lda	#2																						; 		 ld a,2
			sta	6,y																					; 		 ld (ix+6),a
																											; 		 xor a
																											; 		 ld hl,vara
			tst	<varA																					; 		 cp (hl)
			bne	A01235																				; 		 jp nz,a01235
;S			clra																							; 		 xor a
;S			jsr	AnimSp																				; 		 call animsp
			jsr	AnimSp0						; substitutes previous TWO						; 		 call animsp
A01235	dec	8,y																					; a01235 dec (ix+8)
			dec	8,y																					; 		 dec (ix+8)
A01244	lda	<joyVal																				; a01244 ld a,(joyval)
			anda	#4																						; 		 and 4
			beq	A01317																				; 		 jp z,a01317
													; move ladder DOWN
			lda	#3																						; 		 ld a,3
			sta	<varD																					; 		 ld (vard),a
			jsr	LaddD																					; 		 call laddd
			bne	A01317																				; 		 jp nz,a01317
			lda	#2																						; 		 ld a,2
			sta	6,y																					; 		 ld (ix+6),a
																											; 		 xor a
																											; 		 ld hl,vara
			tst	<varA																					; 		 cp (hl)
			bne	A01308																				; 		 jp nz,a01308
;S			clra																							; 		 xor a
;S			jsr	AnimSp																				; 		 call animsp
			jsr	AnimSp0						; substitutes previous TWO						; 		 call animsp
A01308	inc	8,y																					; a01308 inc (ix+8)
			inc	8,y																					; 		 inc (ix+8)
A01317	lda	<joyVal																				; a01317 ld a,(joyval)
			anda	#16																					; 		 and 16
			beq	A01378																				; 		 jp z,a01378
													; JUMP
			lda	#1																						; 		 ld a,1
																											; 		 ld hl,varl
			cmpa	<varL							; can have values 0-1-2 upon ladder			; 		 cp (hl)
;S			bne	A01351						; not 1, skip next								; 		 jp nz,a01351
;S			bra	A01378						; equal 1 so no jump, exit section			; 		 jp a01378
			beq	A01378						; substitutes previous TWO						; 		 jp a01378
A01351	jsr	CanGD							; can go down (fall)?							; a01351 call cangd
;S			bne	A01365						; no, skip next									; 		 jp nz,a01365
;S			bra	A01378						; yes, no jump, exit section					; 		 jp a01378
			beq	A01378						; substitutes previous TWO						; 		 jp a01378
A01365	lda	#40							; value												; a01365 ld a,40
			sta	<sndTyp						; to make a beep									; 		 ld (sndtyp),a
			jsr	Hop							; process jump flag								; 		 call hop
			
													; END JUMP
A01378	ldb	#DEADLY																				; a01378 ld b,DEADLY
			stb	<reg_B
			jsr	TDed																					; 		 call tded
			cmpa	<reg_B																				; 		 cp b
			bne	A01423																				; 		 jp nz,a01423
			ldd	<varO																					; 		 ld a,(varo)
																											; 		 ld (ix+8),a
																											; 		 ld a,(varp)
			std	8,y																					; 		 ld (ix+9),a
			lda	#1																						; 		 ld hl,deadf
			sta	<deadF																					; 		 ld (hl),h
A01423	jmp	Grav																					; a01423 jp grav
; ------------------------------------------------------------------------------------------------------------------------------------------
Evnt0R1	inc	<varK	
			bsr	ShowNumC
			rts
; ------------------------------------------------------------------------------------------------------------------------------------------
ShowNumC	ldd	#$1d14						; coordinates to print number
			std	<charX							; into variables
			ldd	#$ffaa						; AND $55 - EOR $aa (YELLOW)
			std	<andeor						; to colour control
			lda	<varK							; get value to be shown
			bra	ShowNumX						; show it
; ------------------------------------------------------------------------------------------------------------------------------------------
Evnt0R2	inc	numLif						; add one life
			bsr	ShowNumL						; show it
			lda	#1								; value to be used on return
			rts									; return
; ------------------------------------------------------------------------------------------------------------------------------------------
ShowNumL	ldd	#$1d15						; coordinates to print number
			std	<charX							; into variables
			ldd	#$ffaa						; AND $55 - EOR $aa (YELLOW)
			std	<andeor						; to colour control
			lda	numLif						; get number of lives
ShowNumX	jsr	Disply						; show it
			ldd	#$ff00						; AND $ff - EOR $00 (NO CHANGE)
			std	<andeor						; set back to std colours
			rts									; return
; ------------------------------------------------------------------------------------------------------------------------------------------
Evnt01																									; evnt01 equ $
																											; 		 xor a
																											; 		 ld hl,vara
			tst	<varA																					; 		 cp (hl)
			bne	B00027																				; 		 jp nz,b00027
;S			clra																							; 		 xor a
;S			jsr	AnimSp																				; 		 call animsp
			jsr	AnimSp0						; substitutes previous TWO						; 		 call animsp
B00027	rts																							; b00027 ret
; ------------------------------------------------------------------------------------------------------------------------------------------
Evnt02																									; evnt02 equ $
																											; 		 xor a
																											; 		 ld hl,vara
			tst	<varA																					; 		 cp (hl)
			bne	C00027																				; 		 jp nz,c00027
;S			clra																							; 		 xor a
;S			jsr	AnimSp																				; 		 call animsp
			jsr	AnimSp0						; substitutes previous TWO						; 		 call animsp
C00027	clr	<reg_B																				; c00027 ld b,0
			jsr	SkTyp																					; 		 call sktyp
			bcc	B00027																				; 		 jp nc,c02813
			lda	<joyVal																				; 		 ld a,(joyval)
			anda	#64							; detect "I" key pressed						; 		 and 64
			beq	B00027						; no, return										; 		 jp z,c02813
			lda	#9																						; 		 ld a,9
			jsr	MInve																					; 		 call minve
													; AY-3 not present								; 		 call silenc
																											; 		 ld a,(ix+8)
																											; 		 ld (vare),a
																											; 		 ld a,(ix+9)
																											; 		 ld (varf),a
																											; 		 xor a
; ------------------------------------------------------------------------------------------------------------------------------------------
			ldd	scNo							; scNo+varOpt										; 		 ld hl,scno
;X			tst	scNo																					; 		 cp (hl)
;X			bne	C00324																				; 		 jp nz,c00324
																											; 		 xor a
;X			ldb	varOpt																				; 		 ld hl,varopt
;X			tst	varOpt						; *** OPEN DOOR WITH KEY BLUE	***			; 		 cp (hl)
			cmpd	#$0000						; 00-00 (screen 0, option 0)
			bne	C00324																				; 		 jp nz,c00324
			ldd	#$1c08						; 28-08 (X - Y for PAttr)						; 		 ld a,8
			jsr	Evnt2R3						; substitutes next FOUR							; 		 ld (charx),a
																											; 		 ld a,28
;S			std	<charX																					; 		 ld (chary),a
;S			ldx	#chgFx																				; 		 ld hl,chgfx
;S			stx	<grBase																				; 		 ld (grbase),hl
;R			ldd	<charX							; redundant											; 		 ld hl,(charx)
;S			std	<dispX																					; 		 ld (dispx),hl
			jsr	Evnt2R10						; substitutes next SIX
;S			clra									; clean block 1c-08								; 		 xor a
;S			jsr	PAttr																					; 		 call pattr
;S			ldx	<dispX																					; 		 ld hl,(dispx)
;S			stx	<charX																					; 		 ld (charx),hl
;S			ldx	#chgFx																				; 		 ld hl,chgfx
;S			stx	<grBase																				; 		 ld (grbase),hl
;R			ldx	<charX							; redundant											; 		 ld hl,(charx)
;R			stx	<dispX							; redundant											; 		 ld (dispx),hl
			jsr	Evnt2R40						; substitutes next FOUR
;S			clra									; clean block 1d-08								; 		 xor a
;S			jsr	PAttr																					; 		 call pattr
;S			ldx	<dispX																					; 		 ld hl,(dispx)
;S			stx	<charX																					; 		 ld (charx),hl
			ldd	#$1c09						; 28-09 (X - Y for PAttr)						; 		 ld a,9
			jsr	Evnt2R3						; substitutes next FOUR							; 		 ld (charx),a
																											; 		 ld a,28
;S			std	<charX																					; 		 ld (chary),a
;S			ldx	#chgFx																				; 		 ld hl,chgfx
;S			stx	<grBase																				; 		 ld (grbase),hl
;R			ldx	<charX							; redundant											; 		 ld hl,(charx)
;S			std	<dispX																					; 		 ld (dispx),hl
			jsr	Evnt2R10						; substitutes next SIX
;S			clra									; clean block 1c-09								; 		 xor a
;S			jsr	PAttr																					; 		 call pattr
;S			ldx	<dispX																					; 		 ld hl,(dispx)
;S			stx	<charX																					; 		 ld (charx),hl
;S			ldx	#chgFx																				; 		 ld hl,chgfx
;S			stx	<grBase																				; 		 ld (grbase),hl
;R			ldx	<charX							; redundant											; 		 ld hl,(charx)
;R			stx	<dispX							; redundant											; 		 ld (dispx),hl
;S			clra									; clean block 1d-09								; 		 xor a
;S			jsr	PAttr																					; 		 call pattr
;S			ldx	<dispX																					; 		 ld hl,(dispx)
;S			stx	<charX																					; 		 ld (charx),hl
;S			ldb	#80																					; 		 ld a,80
			ldd	#$0050						; 00-80
			jsr	Evnt2R2						; substitutes previous FIVE and next THREE
;S			sta	<sndTyp																				; 		 ld (sndtyp),a
;S			lda	#255
;S			sta	5,y																					; 		 ld (ix+5),255
			bra	C00858						; final place must be C02794
; ------------------------------------------------------------------------------------------------------------------------------------------
C00324	
;S			lda	#11																					; c00324 ld a,11
																											; 		 ld hl,scno
;S			cmpa	scNo																					; 		 cp (hl)
;S			bne	C00563																				; 		 jp nz,c00563
;S			lda	#5																						; 		 ld a,5
													; *** OPEN DOOR WITH KEY PINK ***			; 		 ld hl,varopt
;S			cmpa	varOpt						; screen 11, option 5)							; 		 cp (hl)
			cmpd	#$0b05						; 11-05 	- substitutes previous FIVE
			bne	C00563																				; 		 jp nz,c00563
			ldd	#$1402						; 20-02 (X - Y for PAttr)						; 		 ld a,2
																											; 		 ld (charx),a
																											; 		 ld a,20
			jsr	Evnt2R3						; substitutes next FOUR
;S			std	<charX																					; 		 ld (chary),a
;S			ldx	#chgFx																				; 		 ld hl,chgfx
;S			stx	<grBase																				; 		 ld (grbase),hl
;R			ldd	<charX							; redundant											; 		 ld hl,(charx)
;S			std	<dispX																					; 		 ld (dispx),hl
			jsr	Evnt2R10						; substitutes next SIX
;S			clra									; clean block $14-02								; 		 xor a
;S			jsr	PAttr																					; 		 call pattr
;S			ldx	<dispX																					; 		 ld hl,(dispx)
;S			stx	<charX																					; 		 ld (charx),hl
;S			ldx	#chgFx																				; 		 ld hl,chgfx
;S			stx	<grBase																				; 		 ld (grbase),hl
;R			ldx	<charX																					; 		 ld hl,(charx)
;R			stx	<dispX																					; 		 ld (dispx),hl
			jsr	Evnt2R40						; substitutes next FOUR
;S			clra									; clean block $15-02								; 		 xor a
;S			jsr	PAttr																					; 		 call pattr
;S			ldx	<dispX																					; 		 ld hl,(dispx)
;S			stx	<charX																					; 		 ld (charx),hl
			ldd	#$1403						; 20-03 (X - Y for PAttr)						; 		 ld a,3
																											; 		 ld (charx),a
																											; 		 ld a,20
			jsr	Evnt2R3						; substitutes next FOUR
;S			std	<charX																					; 		 ld (chary),a
;S			ldx	#chgFx																				; 		 ld hl,chgfx
;S			stx	<grBase																				; 		 ld (grbase),hl
;R			ldd	<charX							; redundant											; 		 ld hl,(charx)
;S			std	<dispX																					; 		 ld (dispx),hl
			jsr	Evnt2R10						; substitutes next SIX
;S			clra									; clean block $14-03								; 		 xor a
;S			jsr	PAttr																					; 		 call pattr
;S			ldx	<dispX																					; 		 ld hl,(dispx)
;S			stx	<charX																					; 		 ld (charx),hl
;S			ldx	#chgFx																				; 		 ld hl,chgfx
;S			stx	<grBase																				; 		 ld (grbase),hl
;R			ldx	<charX							; redundant											; 		 ld hl,(charx)
;R			stx	<dispX							; redundant											; 		 ld (dispx),hl
;S			clra									; clean block $15-03								; 		 xor a
;S			jsr	PAttr																					; 		 call pattr
;S			ldx	<dispX																					; 		 ld hl,(dispx)
;S			stx	<charX																					; 		 ld (charx),hl
;S			ldb	#60																					; 		 ld a,60
			ldd	#$003c						; 00-60
			jsr	Evnt2R2						; substitutes previous FIVE and next THREE
;S			sta	<sndTyp																				; 		 ld (sndtyp),a
;S			lda	#255
;S			sta	5,y																					; 		 ld (ix+5),255
			bra	C00858						; final place must be C02794
; ------------------------------------------------------------------------------------------------------------------------------------------
C00563	
;S			lda	#4																						; c00563 ld a,4
																											; 		 ld hl,scno
;S			cmpa	scNo																					; 		 cp (hl)
;S			bne	C00859																				; 		 jp nz,c00859
;S			lda	#6																						; 		 ld a,6
													; *** COMPLETE LADDER ***						; 		 ld hl,varopt
;S			cmpa	varOpt						; screen 4, option 6 (using LADDER)			; 		 cp (hl)
			cmpd	#$0406						; 04-06 - substitutes previous FIVE
			bne	C00859																				; 		 jp nz,c00859
																 											; 		 ld a,71
																											; 		 ld (23693),a
			ldd	#$0b02						; 11-02 (X - Y for PAttr)
													; 1st level of ladder							; 		 ld a,2
																											; 		 ld (charx),a
																											; 		 ld a,11
			jsr	Evnt2R3						; substitutes next FOUR
;S			std	<charX																					; 		 ld (chary),a
;S			ldx	#chgFx																				; 		 ld hl,chgfx
;S			stx	<grBase																				; 		 ld (grbase),hl
;R			ldd	<charX																					; 		 ld hl,(charx)
;S			std	<dispX																					; 		 ld (dispx),hl
			lda	#21							; block 21 is left part of ladder			; 		 ld a,21
			jsr	Evnt2R1						; substitutes next FIVE
;S			jsr	PAttr																					; 		 call pattr
;S			ldx	<dispX																					; 		 ld hl,(dispx)
;S			stx	<charX																					; 		 ld (charx),hl
;S			ldx	#chgFx																				; 		 ld hl,chgfx
;S			stx	<grBase																				; 		 ld (grbase),hl
;R			ldx	<charX							; redundant											; 		 ld hl,(charx)
;R			stx	<dispX							; redundant											; 		 ld (dispx),hl
			lda	#22							; block 22 is right part of ladder			; 		 ld a,22
			jsr	Evnt2R4						; substitutes next THREE
;S			jsr	PAttr																					; 		 call pattr
;S			ldx	<dispX																					; 		 ld hl,(dispx)
;S			stx	<charX																					; 		 ld (charx),hl
			ldd	#$0b03						; 11-03 (X - Y for PAttr)
													; 2nd level of ladder							; 		 ld a,3
																											; 		 ld (charx),a
																											; 		 ld a,11
			jsr	Evnt2R3						; substitutes next FOUR
;S			std	<charX																					; 		 ld (chary),a
;S			ldx	#chgFx																				; 		 ld hl,chgfx
;S			stx	<grBase																				; 		 ld (grbase),hl
;R			ldd	<charX							; redundant											; 		 ld hl,(charx)
;S			std	<dispX																					; 		 ld (dispx),hl
			lda	#21							; block 21 is left part of ladder			; 		 ld a,21
			jsr	Evnt2R1						; substitutes next FIVE
;S			jsr	PAttr																					; 		 call pattr
;S			ldx	<dispX																					; 		 ld hl,(dispx)
;S			stx	<charX																					; 		 ld (charx),hl
;S			ldx	#chgFx																				; 		 ld hl,chgfx
;S			stx	<grBase																				; 		 ld (grbase),hl
;R			ldx	<charX							; redundant											; 		 ld hl,(charx)
;R			stx	<dispX							; redundant											; 		 ld (dispx),hl
;S			lda	#22							; block 22 is right part of ladder			; 		 ld a,22
;S			jsr	PAttr																					; 		 call pattr
;S			ldx	<dispX																					; 		 ld hl,(dispx)
;S			stx	<charX																					; 		 ld (charx),hl
;S			ldb	#60																					; 		 ld a,60
			ldd	#$163c						; 22-60
			jsr	Evnt2R2						; substitutes previous FIVE and next THREE
;S			sta	<sndTyp																				; 		 ld (sndtyp),a
;S			lda	#255
;S			sta	5,y																					; 		 ld (ix+5),255
																											; 		 ld a,136
																											; 		 ld (ix+8),a
																											; 		 ld a,24
;O			jsr	Evnt2R5						; substitutes next THREE (Optimized)
;N			std	8,y							; not necessary									; 		 ld (ix+9),a
;S			exg	a,b																					; 		 ld a,(ix+9)
																											; 		 ld h,a
																											; 		 ld a,(ix+8)
																											; 		 ld l,a
;S			std	<dispX																					; 		 ld (dispx),hl
			lda	#6								; object Ladder									; 		 ld a,6
			jsr	DrpObI						; drop it invisible								; 		 call drpob
C00858	bra	C01543						; final place must be C02794
; ------------------------------------------------------------------------------------------------------------------------------------------
C00859	
;S			lda	#9																						; c00859 ld a,9
																											; 		 ld hl,scno
;S			cmpa	scNo																					; 		 cp (hl)
;S			bne	C01145																				; 		 jp nz,c01145
;S			lda	#8																						; 		 ld a,8
													; *** USE DIAMOND ***							; 		 ld hl,varopt
;S			cmpa	varOpt						; screen 9, option 8								; 		 cp (hl)
			cmpd	#$0908						; 09-08 - substitutes previous FIVE
			bne	C01145																				; 		 jp nz,c01145
			ldd	#$0204						; 02-04 (X - Y for PAttr)						; 		 ld a,4
																											; 		 ld (charx),a
																											; 		 ld a,2
			jsr	Evnt2R3						; substitutes next FOUR
;S			std	<charX																					; 		 ld (chary),a
;S			ldx	#chgFx																				; 		 ld hl,chgfx
;S			stx	<grBase																				; 		 ld (grbase),hl
;R			ldd	<charX							; redundant											; 		 ld hl,(charx)
;S			std	<dispX																					; 		 ld (dispx),hl
			jsr	Evnt2R10						; substitutes next SIX
;S			clra									; clean block 02-04								; 		 xor a
;S			jsr	PAttr																					; 		 call pattr
;S			ldx	<dispX																					; 		 ld hl,(dispx)
;S			stx	<charX																					; 		 ld (charx),hl
;S			ldx	#chgFx																				; 		 ld hl,chgfx
;S			stx	<grBase																				; 		 ld (grbase),hl
;R			ldx	<charX							; redundant											; 		 ld hl,(charx)
;R			stx	<dispX							; redundant											; 		 ld (dispx),hl
			jsr	Evnt2R40						; substitutes next FOUR
;S			clra									; clean block 03-04								; 		 xor a
;S			jsr	PAttr																					; 		 call pattr
;S			ldx	<dispX																					; 		 ld hl,(dispx)
;S			stx	<charX																					; 		 ld (charx),hl
			ldd	#$0205						; 02-05 (X - Y for PAttr)						; 		 ld a,5
																											; 		 ld (charx),a
																											; 		 ld a,2
			jsr	Evnt2R3						; substitutes next FOUR
;S			std	<charX																					; 		 ld (chary),a
;S			ldx	#chgFx																				; 		 ld hl,chgfx
;S			stx	<grBase																				; 		 ld (grbase),hl
;R			ldd	<charX							; redundant											; 		 ld hl,(charx)
;S			std	<dispX																					; 		 ld (dispx),hl
			jsr	Evnt2R10						; substitutes next SIX
;S			clra									; clean block 02-05								; 		 xor a
;S			jsr	PAttr																					; 		 call pattr
;S			ldx	<dispX																					; 		 ld hl,(dispx)
;S			stx	<charX																					; 		 ld (charx),hl
;S			ldx	#chgFx																				; 		 ld hl,chgfx
;S			stx	<grBase																				; 		 ld (grbase),hl
;R			ldx	<charX							; redundant											; 		 ld hl,(charx)
;R			stx	<dispX							; redundant											; 		 ld (dispx),hl
;S			clra									; clean block 03-05								; 		 xor a
;S			jsr	PAttr																					; 		 call pattr
;S			ldx	<dispX																					; 		 ld hl,(dispx)
;S			stx	<charX																					; 		 ld (charx),hl
;S			ldb	#45																					; 		 ld a,45
			ldd	#$002d						; 00-45
			jsr	Evnt2R2						; substitutes previous FIVE and next THREE
;S			std	<sndTyp																				; 		 ld (sndtyp),a
;S			lda	#255
;S			sta	5,y																					; 		 ld (ix+5),255
																											; 		 ld a,136
																											; 		 ld (ix+8),a
																											; 		 ld a,24
;O			jsr	Evnt2R5						; substitutes next THREE (optimized)
;N			std	8,y							; not necessary									; 		 ld (ix+9),a
;S			exg	a,b																					; 		 ld a,(ix+9)
																											; 		 ld h,a
																											; 		 ld a,(ix+8)
																											; 		 ld l,a
;S			std	<dispX																					; 		 ld (dispx),hl
			lda	#8								; object Diamond									; 		 ld a,8
			jsr	DrpObI						; drop it invisible (?)							; 		 call drpob
			bra	C01543						; final place must be C02794
; ------------------------------------------------------------------------------------------------------------------------------------------
C01145	
;S			lda	#20																					; c01145 ld a,20
																											; 		 ld hl,scno
;S			cmpa	scNo																					; 		 cp (hl)
;S			bne	C01353																				; 		 jp nz,c01353
;S			lda	#15																					; 		 ld a,15
													; *** USE GLOBE GET DIAMOND ***				; 		 ld hl,varopt
;S			cmpa	varOpt						; screen 20, option 15							; 		 cp (hl)
			cmpd	#$140f						; 20-15 - substitutes previous FIVE	
			bne	C01353																				; 		 jp nz,c01353
			ldd	#$0804						; 08-04 (X - Y for PAttr)						; 		 ld a,4
																											; 		 ld (charx),a
																											; 		 ld a,8
			jsr	Evnt2R3						; substitutes next FOUR
;S			std	<charX																					; 		 ld (chary),a
;S			ldx	#chgFx																				; 		 ld hl,chgfx
;S			stx	<grBase																				; 		 ld (grbase),hl
;R			ldd	<charX							; redundant											; 		 ld hl,(charx)
;S			std	<dispX																					; 		 ld (dispx),hl
			lda	#60							; block = upper part of globe					; 		 ld a,60
			jsr	Evnt2R4						; substitutes next THREE
;S			jsr	PAttr																					; 		 call pattr
;S			ldx	<dispX																					; 		 ld hl,(dispx)
;S			stx	<charX																					; 		 ld (charx),hl
			ldd	#$0805						; 08-05 (X - Y for PAttr)						; 		 ld a,5
																											; 		 ld (charx),a
																											; 		 ld a,8
			jsr	Evnt2R3						; substitutes next FOUR
;S			std	<charX																					; 		 ld (chary),a
;S			ldx	#chgFx																				; 		 ld hl,chgfx
;S			stx	<grBase																				; 		 ld (grbase),hl
;R			ldd	<charX							; redundant											; 		 ld hl,(charx)
;S			std	<dispX																					; 		 ld (dispx),hl
;S			lda	#61							; lower part of globe							; 		 ld a,61
;S			jsr	PAttr																					; 		 call pattr
;S			ldx	<dispX																					; 		 ld hl,(dispx)
;S			stx	<charX																					; 		 ld (charx),hl
;S			ldb	#80																					; 		 ld a,80
			ldd	#$3d50						; 61-80
			jsr	Evnt2R2						; substitutes previous FIVE and next THREE
;S			sta	<sndTyp																				; 		 ld (sndtyp),a
;S			lda	#255
;S			sta	5,y																					; 		 ld (ix+5),255
																											; 		 ld a,8
																											; 		 ld (ix+8),a
																											; 		 ld a,216
;O			jsr	Evnt2R5						; substitutes next THREE (optimized)
;N			std	8,y							; not necessary									; 		 ld (ix+9),a
;S			exg	a,b																					; 		 ld a,(ix+9)
																											; 		 ld h,a
																											; 		 ld a,(ix+8)
																											; 		 ld l,a
;S			std	<dispX																					; 		 ld (dispx),hl
			lda	#15							; object GLOBE										; 		 ld a,15
			jsr	DrpObI						; drop it invisible (?)							; 		 call drpob
			bra	C01543						; final place must be C02794
; ------------------------------------------------------------------------------------------------------------------------------------------
C01353	
;S			lda	#13																					; c01353 ld a,13
																											; 		 ld hl,scno
;S			cmpa	scNo																					; 		 cp (hl)
;S			bne	C01544																				; 		 jp nz,c01544
;S			lda	#7																						; 		 ld a,7
													; *** USE BOMB TO GO DOWN ***					; 		 ld hl,varopt
;S			cmpa	varOpt						; screen 13, option 7							; 		 cp (hl)
			cmpd	#$0d07						; 13-07 - substitutes previous FIVE
			bne	C01544																				; 		 jp nz,c01544
			ldd	#$0e11						; 14-17 (X - Y for PAttr)						; 		 ld a,17
																											; 		 ld (charx),a
																											; 		 ld a,14
			jsr	Evnt2R3						; substitutes next FOUR
;S			std	<charX																					; 		 ld (chary),a
;S			ldx	#chgFx																				; 		 ld hl,chgfx
;S			stx	<grBase																				; 		 ld (grbase),hl
;R			ldd	<charX							; redundant											; 		 ld hl,(charx)
;S			std	<dispX																					; 		 ld (dispx),hl
			jsr	Evnt2R10						; substitutes next SIX
;S			clra									; clean block 14-17								; 		 xor a
;S			jsr	PAttr																					; 		 call pattr
;S			ldx	<dispX																					; 		 ld hl,(dispx)
;S			stx	<charX																					; 		 ld (charx),hl
;S			ldx	#chgFx																				; 		 ld hl,chgfx
;S			stx	<grBase																				; 		 ld (grbase),hl
;R			ldx	<charX							; redundant											; 		 ld hl,(charx)
;R			stx	<dispX							; redundant											; 		 ld (dispx),hl
;S			clra									; clean block 15-17								; 		 xor a
;S			jsr	PAttr																					; 		 call pattr
;S			ldx	<dispX																					; 		 ld hl,(dispx)
;S			stx	<charX																					; 		 ld (charx),hl
;S			ldb	#45																					; 		 ld a,45
			ldd	#$002d						; 00-45
			jsr	Evnt2R2						; substitutes previous FIVE and next THREE
;S			sta	<sndTyp																				; 		 ld (sndtyp),a
;S			lda	#255
;S			sta	5,y																					; 		 ld (ix+5),255
																											; 		 ld a,48
																											; 		 ld (ix+8),a
																											; 		 ld a,216
;O			jsr	Evnt2R5						; substitutes next THREE (optimized)
;N			std	8,y							; not necessary									; 		 ld (ix+9),a
;S			exg	a,b																					; 		 ld a,(ix+9)
																											; 		 ld h,a
																											; 		 ld a,(ix+8)
																											; 		 ld l,a
;S			std	<dispX																					; 		 ld (dispx),hl
			lda	#7								; Object BOMB														; 		 ld a,7
			jsr	DrpObI						; drop it invisible (?)							; 		 call drpob
C01543	bra	C01911						; final place must be C02794
; ------------------------------------------------------------------------------------------------------------------------------------------
C01544	
;S			lda	#14																					; c01544 ld a,14
																											; 		 ld hl,scno
;S			cmpa	scNo																					; 		 cp (hl)
;S			bne	C01697																				; 		 jp nz,c01697
;S			lda	#11																					; 		 ld a,11
													; *** USE ROCK GET PIT-PLANT ***				; 		 ld hl,varopt
;S			cmpa	varOpt						; screen 14, option 11							; 		 cp (hl)
			cmpd	#$0e0b						; 14-11 - substitutes previous FIVE
			bne	C01697																				; 		 jp nz,c01697
			ldd	#$070f						; 07-15 (X - Y for PAttr)						; 		 ld a,15
																											; 		 ld (charx),a
																											; 		 ld a,7
			jsr	Evnt2R3						; substitutes next FOUR
;S			std	<charX																					; 		 ld (chary),a
;S			ldx	#chgFx																				; 		 ld hl,chgfx
;S			stx	<grBase																				; 		 ld (grbase),hl
;R			ldd	<charX							; redundant											; 		 ld hl,(charx)
;S			std	<dispX																					; 		 ld (dispx),hl
;S			lda	#56							; block to show ROCK	(obj #11)				; 		 ld a,56
;S			jsr	PAttr																					; 		 call pattr
;S			ldx	<dispX																					; 		 ld hl,(dispx)
;S			stx	<charX																					; 		 ld (charx),hl
;S			ldb	#80																					; 		 ld a,80
			ldd	#$3850						; 56-80
			jsr	Evnt2R2						; substitutes previous FIVE and next THREE
;S			sta	<sndTyp																				; 		 ld (sndtyp),a
;S			lda	#255
;S			sta	5,y																					; 		 ld (ix+5),255
																											; 		 ld a,136
																											; 		 ld (ix+8),a
																											; 		 ld a,24
;O			jsr	Evnt2R5						; substitutes next THREE (optimized)
;N			std	8,y							; not necessary									; 		 ld (ix+9),a
;S			exg	a,b																					; 		 ld a,(ix+9)
																											; 		 ld h,a
																											; 		 ld a,(ix+8)
																											; 		 ld l,a
;S			std	<dispX																					; 		 ld (dispx),hl
			lda	#11							; object ROCK										; 		 ld a,11
			jsr	DrpObI						; drop it after use (invisible)				; 		 call drpob
			bra	C01911						; final place must be C02794
; ------------------------------------------------------------------------------------------------------------------------------------------
C01697	
;S			lda	#5																						; c01697 ld a,5
																											; 		 ld hl,scno
;S			cmpa	scNo																					; 		 cp (hl)
;S			bne	C01912																				; 		 jp nz,c01912
;S			lda	#10																					; 		 ld a,10
													; *** USE PIT-PLANT GET SEED ***				; 		 ld hl,varopt
;S			cmpa	varOpt						; screen 5, option 10							; 		 cp (hl)
			cmpd	#$050a						; 05-10 - substitutes previous FIVE
			bne	C01912																				; 		 jp nz,c01912
;N			ldd	8,y							; not ecessary										; 		 ld a,(ix+8)
																											; 		 ld (vare),a
																											; 		 ld a,(ix+9)
;N			std	<varE							; not necessary									; 		 ld (varf),a
			ldd	#$48b0						; 72-176	(Y - X for DrpOb)
													; coordinates for Pit-Plant					; 		 ld a,72
																											; 		 ld (ix+8),a
;O			jsr	Evnt2R5						; substitutes next THREE (optimized)		; 		 ld a,176
;N			std	8,y							; not necessary									; 		 ld (ix+9),a
;S			exg	a,b																					; 		 ld a,(ix+9)
																											; 		 ld h,a
																											; 		 ld a,(ix+8)
																											; 		 ld l,a
;S			std	<dispX																					; 		 ld (dispx),hl
			std	<dispX							; only one needed									; 		 ld (dispx),hl
			lda	#10							; object PIT-Plant								; 		 ld a,10
			jsr	DrpOb							; drop it visible									; 		 call drpob
			lda	#60																					; 		 ld a,60
			jsr	Evnt2R2A						; substitutes next THREE
;S			sta	<sndTyp																				; 		 ld (sndtyp),a
;S			lda	#255
;S			sta	5,y																					; 		 ld (ix+5),255
;N			ldd	<varE							; not needed										; 		 ld a,(varf)
																											; 		 ld (ix+9),a
																											; 		 ld a,(vare)
;N			std	8,y							; not needed										; 		 ld (ix+8),a
;S			pshs	y																						; 		 push ix
			ldb	#75																					; 		 ld b,75
;;;			jsr	Evnt2R6						; susbtitutes previous ONE and next TWO
			jsr	Delay																					; 		 call delay
;S			puls	y																						; 		 pop ix
																											; 		 ld c,24
;O			lda	9,y							; optimized											; 		 ld a,(ix+9)
;O			adda	#24							; optimized											; 		 add a,c
;O			sta	9,y							; optimized											; 		 ld (ix+9),a
																											; 		 ld a,(ix+9)
																											; 		 ld h,a
;O			ldb	8,y							; optimized											; 		 ld a,(ix+8)

			ldd	#$20a0						; 32-160 (Y - X for DrpOb)
													; coordinates for SEED
																											; 		 ld l,a
			std	<dispX																					; 		 ld (dispx),hl
			lda	#14							; object SEED 										; 		 ld a,14
			jsr	DrpOb							; drop it visible									; 		 call drpob
;N			lda	<varF							; not needed										; 		 ld a,(varf)
;N			sta	9,y							; not needed										; 		 ld (ix+9),a
			lda	#70																					; 		 ld a,70
			sta	<sndTyp																				; 		 ld (sndtyp),a
C01911	bra	C02502						; final place must be C02794
; ------------------------------------------------------------------------------------------------------------------------------------------
C01912	
;S			lda	#14																					; c01912 ld a,14
																											; 		 ld hl,scno
;S			cmpa	scNo																					; 		 cp (hl)
;S			bne	C02144																				; 		 jp nz,c02144
;S			lda	#14																					; 		 ld a,14
													; *** USE SEED ON FLOWER ***					; 		 ld hl,varopt
;S			cmpa	varOpt						; screen 14, option 14							; 		 cp (hl)
			cmpd	#$0e0e						; 14-14 - substitutes previous FIVE
			bne	C02144																				; 		 jp nz,c02144
			ldd	#$0b09						; 11-09 (X - Y for PAttr)						; 		 ld a,9
																											; 		 ld (charx),a
																											; 		 ld a,11
			jsr	Evnt2R3						; substitutes next FOUR
;S			std	<charX																					; 		 ld (chary),a
;S			ldx	#chgFx																				; 		 ld hl,chgfx
;S			stx	<grBase																				; 		 ld (grbase),hl
;R			ldd	<charX							; redundant											; 		 ld hl,(charx)
;S			std	<dispX																					; 		 ld (dispx),hl
			lda	#55							; left part of platform							; 		 ld a,55
			jsr	Evnt2R1						; substitutes next FIVE
;S			jsr	PAttr																					; 		 call pattr
;S			ldx	<dispX																					; 		 ld hl,(dispx)
;S			stx	<charX																					; 		 ld (charx),hl
;S			ldx	#chgFx																				; 		 ld hl,chgfx
;S			stx	<grBase																				; 		 ld (grbase),hl
;R			ldx	<charX							; redundant											; 		 ld hl,(charx)
;R			stx	<dispX							; redundant											; 		 ld (dispx),hl
			lda	#72							; middle part of platform						; 		 ld a,72
			jsr	Evnt2R1						; substitutes next FIVE
;S			jsr	PAttr																					; 		 call pattr
;S			ldx	<dispX																					; 		 ld hl,(dispx)
;S			stx	<charX																					; 		 ld (charx),hl
;S			ldx	#chgFx																				; 		 ld hl,chgfx
;S			stx	<grBase																				; 		 ld (grbase),hl
;R			ldx	<charX							; redundant											; 		 ld hl,(charx)
;R			stx	<dispX							; redundant											; 		 ld (dispx),hl
;S			lda	#73							; right part of platform						; 		 ld a,73
;S			jsr	PAttr																					; 		 call pattr
;S			ldx	<dispX																					; 		 ld hl,(dispx)
;S			stx	<charX																					; 		 ld (charx),hl
;S			ldb	#60																					; 		 ld a,60
			ldd	#$493c
			jsr	Evnt2R2						; substitutes previous FIVE and next THREE
;S			sta	<sndTyp																				; 		 ld (sndtyp),a
;S			lda	#255
;S			sta	5,y																					; 		 ld (ix+5),255
																											; 		 ld a,136
																											; 		 ld (ix+8),a
																											; 		 ld a,24
;O			jsr	Evnt2R5						; substitutes next THREE (optimized)		; 		 ld a,176
;N			std	8,y							; not needed										; 		 ld (ix+9),a
;S			exg	a,b																					; 		 ld a,(ix+9)
																											; 		 ld h,a
																											; 		 ld a,(ix+8)
																											; 		 ld l,a
;S			std	<dispX																					; 		 ld (dispx),hl
			lda	#14							; object SEED										; 		 ld a,14
			jsr	DrpObI						; drop it invisible								; 		 call drpob
C02143	bra	C02502						; final place must be C02794
; ------------------------------------------------------------------------------------------------------------------------------------------
C02144	
;S			lda	#16																					; c02144 ld a,16
																											; 		 ld hl,scno
;S			cmpa	scNo																					; 		 cp (hl)
;S			bne	C02311																				; 		 jp nz,c02311
;S			lda	#9																						; 		 ld a,9
													; *** USE SKULL GET CRYSTAL ***				; 		 ld hl,varopt
;S			cmpa	varOpt						; screen 16, option 9							; 		 cp (hl)
			cmpd	#$1009						; 16-09 - substitutes previous FIVE
			bne	C02311																				; 		 jp nz,c02311
			ldd	#$4878						; 72-120	(Y - X for DrpOb)						; 		 ld a,72
													; coordinates for SKULL							; 		 ld (ix+8),a
																											; 		 ld a,120
;O			jsr	Evnt2R5						; substitutes next THREE (optimized)
;N			std	8,y							; not needed										; 		 ld (ix+9),a
;S			exg	a,b																					; 		 ld a,(ix+9)
																											; 		 ld h,a
																											; 		 ld a,(ix+8)
																											; 		 ld l,a
;S			std	<dispX																					; 		 ld (dispx),hl
			std	<dispX							; only one needed									; 		 ld (dispx),hl
			lda	#9								; object SKULL										; 		 ld a,9
			jsr	DrpOb							; drop it visible									; 		 call drpob
			lda	#60																					; 		 ld a,60
			jsr	Evnt2R2A						; substitutes next THREE						; 		 ld a,176
;S			sta	<sndTyp																				; 		 ld (sndtyp),a
;S			lda	#255
;S			sta	5,y																					; 		 ld (ix+5),255
;S			pshs	y																						; 		 push ix
			ldb	#50																					; 		 ld b,50
;;;			jsr	Evnt2R6						; susbtitutes previous ONE and next TWO
			jsr	Delay																					; 		 call delay
;S			puls	y																						; 		 pop ix
			lda	#80																					; 		 ld a,80
			sta	<sndTyp																				; 		 ld (sndtyp),a
			ldd	#$80a8						; 128-168 (Y - X for DrpOb)					; 		 ld a,128
													; coordinates for CRYSTAL						; 		 ld (ix+8),a
																											; 		 ld a,168
;O			jsr	Evnt2R5						; substitutes next THREE (optimized)
;N			std	8,y							; not needed										; 		 ld (ix+9),a
;S			exg	a,b																					; 		 ld a,(ix+9)
																											; 		 ld h,a
																											; 		 ld a,(ix+8)
																											; 		 ld l,a
;S			std	<dispX																					; 		 ld (dispx),hl
			std	<dispX							; only one needed									; 		 ld (dispx),hl
			lda	#2								; object CRYSTAL									; 		 ld a,2
			jsr	DrpOb							; drop it visible									; 		 call drpob
			bra	C02502						; final place must be C02794
; ------------------------------------------------------------------------------------------------------------------------------------------
C02311	
;S			lda	#15																					; c02311 ld a,15
																											; 		 ld hl,scno
;S			cmpa	scNo																					; 		 cp (hl)
;S			bne	C02503																				; 		 jp nz,c02503
;S			lda	#17																					; 		 ld a,17
													; *** USE BRICKS GET KEY PINK ***			; 		 ld hl,varopt
;S			cmpa	varOpt						; screen 15, option 17							; 		 cp (hl)
			cmpd	#$0f11						; 15-17 - substitutes previous FIVE
			bne	C02503																				; 		 jp nz,c02503
			ldd	#$140f						; 20-15 (X - Y for PAttr)						; 		 ld a,15
																											; 		 ld (charx),a
																											; 		 ld a,20
			jsr	Evnt2R3						; substitutes next FOUR
;S			std	<charX																					; 		 ld (chary),a
;S			ldx	#chgFx																				; 		 ld hl,chgfx
;S			stx	<grBase																				; 		 ld (grbase),hl
;R			ldd	<charX							; redundant											; 		 ld hl,(charx)
;S			std	<dispX																					; 		 ld (dispx),hl
			lda	#52																					; 		 ld a,52
			jsr	Evnt2R1						; substitutes next FIVE
;S			jsr	PAttr																					; 		 call pattr
;S			ldx	<dispX																					; 		 ld hl,(dispx)
;S			stx	<charX																					; 		 ld (charx),hl
;S			ldx	#chgFx																				; 		 ld hl,chgfx
;S			stx	<grBase																				; 		 ld (grbase),hl
;R			ldx	<charX							; redundant											; 		 ld hl,(charx)
;R			stx	<dispX							; redundant											; 		 ld (dispx),hl
;S			lda	#52																					; 		 ld a,52
;S			jsr	PAttr																					; 		 call pattr
;S			ldx	<dispX																					; 		 ld hl,(dispx)
;S			stx	<charX																					; 		 ld (charx),hl
;S			ldb	#60																					; 		 ld a,60
			ldd	#$343c						; 52-60
			jsr	Evnt2R2						; substitutes previous FIVE and next THREE
;S			sta	<sndTyp																				; 		 ld (sndtyp),a
;S			lda	#255
;S			sta	5,y																					; 		 ld (ix+5),255
																											;		 ld a,136
																											; 		 ld (ix+8),a
																											; 		 ld a,24
;O			jsr	Evnt2R5						; substitutes next THREE (optimized)
;N			std	8,y							; not needed										; 		 ld (ix+9),a
;S			exg	a,b																					; 		 ld a,(ix+9)
																											; 		 ld h,a
																											; 		 ld a,(ix+8)
																											; 		 ld l,a
;S			std	<dispX																					; 		 ld (dispx),hl
			lda	#17							; object BRICKS									; 		 ld a,17
			jsr	DrpObI						; drop it invisible								; 		 call drpob
C02502	bra	C02794						; final place must be C02794
; ------------------------------------------------------------------------------------------------------------------------------------------
C02503	
;S			lda	#23																					; c02503 ld a,23
																											; 		 ld hl,scno
;S			cmpa	scNo																					; 		 cp (hl)
;S			bne	C02689																				; 		 jp nz,c02689
;S			lda	#18																					; 		 ld a,18
													; *** USE ICE DRILL ***							; 		 ld hl,varopt
;S			cmpa	varOpt						; screen 23, option 18							; 		 cp (hl)
			cmpd	#$1712						; 23-18 - substitutes previous FIVE
			bne	C02689																				; 		 jp nz,c02689
			ldd	#$1805						; 24-05 (X - Y for PAttr)						; 		 ld a,5
																											; 		 ld (charx),a
																											; 		 ld a,24
			jsr	Evnt2R3						; substitutes next FOUR
;S			std	<charX																					; 		 ld (chary),a
;S			ldx	#chgFx																				; 		 ld hl,chgfx
;S			stx	<grBase																				; 		 ld (grbase),hl
;R			ldd	<charX							; redundant											; 		 ld hl,(charx)
;S			std	<dispX																					; 		 ld (dispx),hl
			jsr	Evnt2R40						; substitutes next FOUR
;S			clra																							; 		 xor a
;S			jsr	PAttr																					; 		 call pattr
;S			ldx	<dispX																					; 		 ld hl,(dispx)
;S			stx	<charX																					; 		 ld (charx),hl
			lda	#45																					; 		 ld a,45
			sta	<sndTyp																				; 		 ld (sndtyp),a
;S			pshs	y																						; 		 push ix
			ldb	#50																					; 		 ld b,50
;;;			jsr	Evnt2R6						; susbtitutes previous ONE and next TWO
			jsr	Delay																					; 		 call delay
;S			puls	y																						; 		 pop ix
			ldd	#$1806						; 24-06 (X - Y for PAttr)						; 		 ld a,6
																											; 		 ld (charx),a
																											; 		 ld a,24
			jsr	Evnt2R3						; substitutes next FOUR
;S			std	<charX																					; 		 ld (chary),a
;S			ldx	#chgFx																				; 		 ld hl,chgfx
;S			stx	<grBase																				; 		 ld (grbase),hl
;R			ldd	<charX							; redundant											; 		 ld hl,(charx)
;S			std	<dispX																					; 		 ld (dispx),hl
;S			clra																							; 		 xor a
;S			jsr	PAttr																					; 		 call pattr
;S			ldx	<dispX																					; 		 ld hl,(dispx)
;S			stx	<charX																					; 		 ld (charx),hl
;S			ldb	#45																					; 		 ld a,45
			ldd	#$002d						; 00-45
			jsr	Evnt2R2						; substitutes previous FIVE and next THREE
;S			sta	<sndTyp																				; 		 ld (sndtyp),a
;S			lda	#255
;S			sta	5,y																					; 		 ld (ix+5),255
			bra	C02794						; final place must be C02794
; ------------------------------------------------------------------------------------------------------------------------------------------
C02689	
;S			lda	#10																					; c02689 ld a,10
																											; 		 ld hl,scno
;S			cmpa	scNo																					; 		 cp (hl)
;S			bne	C02794																				; 		 jp nz,c02794
;S			lda	#16																					; 		 ld a,16
 													; *** USE PICK AXE ***							; 		 ld hl,varopt
;S			cmpa	varOpt						; screen 10, option 16							; 		 cp (hl)
			cmpd	#$0a10						; 10-16 - substitutes previous FIVE
			bne	C02794																				; 		 jp nz,c02794
			ldd	#$1104						; 17-04 (X - Y for PAttr)						; 		 ld a,4
																											; 		 ld (charx),a
																											; 		 ld a,17
			jsr	Evnt2R3						; substitutes next FOUR
;S			std	<charX																					; 		 ld (chary),a
;S			ldx	#chgFx																				; 		 ld hl,chgfx
;S			stx	<grBase																				; 		 ld (grbase),hl
;R			ldd	<charX							; redundant											; 		 ld hl,(charx)
;S			std	<dispX																					; 		 ld (dispx),hl
;S			clra																							; 		 xor a
;S			jsr	PAttr																					; 		 call pattr
;S			ldx	<dispX																					; 		 ld hl,(dispx)
;S			stx	<charX																					; 		 ld (charx),hl
;S			ldb	#45																					; 		 ld a,45
			ldd	#$002d						; 00-45
			jsr	Evnt2R2						; substitutes previous FIVE and next THREE
;S			sta	<sndTyp																				; 		 ld (sndtyp),a
;S			lda	#255
;S			sta	5,y																					; 		 ld (ix+5),255
C02794	
;N			ldd	<varE							; not necessary									; c02794 ld a,(vare)
																											; 		 ld (ix+8),a
																											; 		 ld a,(varf)
;N			std	8,y							; not necessary									; 		 ld (ix+9),a
C02813	rts																							; c02813 ret
; ------------------------------------------------------------------------------------------------------------------------------------------
; receives param regA for PAttr
; ------------------------------------------------------------------------------------------------------------------------------------------
Evnt2R10	clra									; background coloured block
Evnt2R1	jsr	PAttr							; show it (overprintig something)
			ldd	<dispX							; get coordinates
Evnt2R1A	std	<charX							; pass to charXY variables
			ldx	#chgFx						; get blocks address
			stx	<grBase						; pass to pointer
			rts									; return
; ------------------------------------------------------------------------------------------------------------------------------------------
; receives 	param regA for PAttr
;				param regB as sndTyp
; ------------------------------------------------------------------------------------------------------------------------------------------
Evnt2R2	pshs	b								; save register
			jsr	Evnt2R4						; print one bg block
			lda	,s+							; get back register
Evnt2R2A	sta	<sndTyp						; put as sound to be played
			lda	#255							; disable
			sta	5,y							; next type in sprite
			rts									; return
; ------------------------------------------------------------------------------------------------------------------------------------------
; receives param regD for charXY
; ------------------------------------------------------------------------------------------------------------------------------------------
Evnt2R3	std	<dispX							; save coordinates
			bra	Evnt2R1A						; complete assignements
; ------------------------------------------------------------------------------------------------------------------------------------------
; receives param regA for PAttr
; ------------------------------------------------------------------------------------------------------------------------------------------
Evnt2R40	clra									; background coloured block
Evnt2R4	jsr	PAttr							; show it
			ldx	<dispX							; get coordinates
			stx	<charX							; put in charXY variables
			rts									; return
; ------------------------------------------------------------------------------------------------------------------------------------------
; receives param regB for Delay
; code added to engine, so no more needed
; ------------------------------------------------------------------------------------------------------------------------------------------
;;;Evnt2R6	pshs	y								; save sprite pointer
;;;			jsr	Delay							; wait for some time
;;;			puls	y,pc							; restore pointer and return
; ------------------------------------------------------------------------------------------------------------------------------------------
Evnt03																									; evnt03 equ $
																											; 		 xor a
																											; 		 ld hl,varc
			tst	<varC																					; 		 cp (hl)
			bne	D00201																				; 		 jp nz,d00201
																											; 		 xor a
			tst	11,y																					; 		 cp (ix+11)
			bne	D00119																				; 		 jp nz,d00119
			jsr	CanGL																					; 		 call cangl
			bne	D00106																				; 		 jp nz,d00106
			lda	9,y																					; 		 dec (ix+9)
																											; 		 dec (ix+9)
																											; 		 ld c,16
																											; 		 ld a,(ix+9)
			suba	#18							; -1-1-16											; 		 sub c
			sta	9,y																					; 		 ld (ix+9),a
			jsr	CanGD																					; 		 call cangd
			bne	D00085																				; 		 jp nz,d00085
			lda	#1																						; 		 ld a,1
			sta	11,y																					; 		 ld (ix+11),a
D00085	lda	9,y																					; d00085 ld c,16
																											; 		 ld a,(ix+9)
			adda	#16																					; 		 add a,c
			sta	9,y																					; 		 ld (ix+9),a
			bra	D00115																				; 		 jp d00115
D00106	lda	#1																						; d00106 ld a,1
			sta	11,y																					; 		 ld (ix+11),a
D00115	bra	D00201																				; d00115 jp d00201
D00119	jsr	CanGR																					; d00119 call cangr
			bne	D00193																				; 		 jp nz,d00193
			lda	9,y																					; 		 inc (ix+9)
																											; 		 inc (ix+9)
																											; 		 ld c,16
																											; 		 ld a,(ix+9)
			adda	#18							; +1+1+16											; 		 add a,c
			sta	9,y																					; 		 ld (ix+9),a
			jsr	CanGD																					; 		 call cangd
			bne	D00172																				; 		 jp nz,d00172
																											; 		 xor a
			clr	11,y																					; 		 ld (ix+11),a
D00172																									; d00172 ld c,16
			lda	9,y																					; 		 ld a,(ix+9)
			suba	#16																					; 		 sub c
			sta	9,y																					; 		 ld (ix+9),a
			bra	D00201																				; 		 jp d00201
D00193																									; d00193 xor a
			clr	11,y																					; 		 ld (ix+11),a
D00201	
;S			clra																							; d00201 xor a
;S			jsr	AnimSp																				; 		 call animsp
			jsr	AnimSp0						; substitutes previous TWO						; 		 call animsp
			clr	<reg_B																				; 		 ld b,0
			jsr	SkTyp																					; 		 call sktyp
			bcc	D00231																				; 		 jp nc,d00231
			lda	#1																						; 		 ld hl,deadf
			sta	<deadF																					; 		 ld (hl),h
D00231	rts																							; d00231 ret
; ------------------------------------------------------------------------------------------------------------------------------------------
Evnt04																									; evnt04 equ $
																											; 		 ld a,71
																											; 		 and 7
																											; 		 ld c,a
													; by now no colours								; 		 call cspr
																											; 		 xor a
			tst	11,y																					; 		 cp (ix+11)
			bne	E00099																				; 		 jp nz,e00099
			jsr	CanGD									 												; 		 call cangd
			bne	E00078																				; 		 jp nz,e00078
			inc	8,y																					; 		 inc (ix+8)
			inc	8,y																					; 		 inc (ix+8)
																											; 		 xor a
			tst	<varA																					; 		 ld hl,vara
																											; 		 cp (hl)
			bne	E00073																				; 		 jp nz,e00073
;S			clra																							; 		 xor a
;S			jsr	AnimSp																				; 		 call animsp
			jsr	AnimSp0						; substitutes previous TWO						; 		 call animsp
E00073	bra	E00095																				; e00073 jp e00095
E00078	lda	#1																						; e00078 ld a,1
			sta	11,y																					; 		 ld (ix+11),a
			lda	#35																					; 		 ld a,35
			sta	<sndTyp																				; 		 ld (sndtyp),a
E00095	bra	E00164																				; e00095 jp e00164
E00099	jsr	CanGU																					; e00099 call cangu
			bne	E00147																				; 		 jp nz,e00147
			dec	8,y																					; 		 dec (ix+8)
			dec	8,y																					; 		 dec (ix+8)
																											; 		 xor a
			tst	<varA																					; 		 ld hl,vara
																											; 		 cp (hl)
			bne	E00142																				; 		 jp nz,e00142
;S			clra																							; 		 xor a
;S			jsr	AnimSp																				; 		 call animsp
			jsr	AnimSp0						; substitutes previous TWO						; 		 call animsp
E00142	bra	E00164																				; e00142 jp e00164
E00147																									; e00147 xor a
			clr	11,y																					; 		 ld (ix+11),a
			lda	#35																					; 		 ld a,35
			sta	<sndTyp																				; 		 ld (sndtyp),a
E00164	clr	<reg_B																				; e00164 ld b,0
			jsr	SkTyp																					; 		 call sktyp
			bcc	E00186																				; 		 jp nc,e00186
			lda	#1																						; 		 ld hl,deadf
			sta	<deadF																					; 		 ld (hl),h
E00186																									; e00186 ld a,3
																											; 		 cp (ix+6)
																											; 		 jp nz,e00213
																											; 		 ld a,70
																											; 		 and 7
																											; 		 ld c,a
																											; 		 call cspr
E00213																									; e00213 ld a,6
																											; 		 cp (ix+6)
																											; 		 jp nz,e00241
																											; 		 ld a,77
																											; 		 and 7
																											; 		 ld c,a
																											; 		 call cspr
E00241	rts																							; e00241 ret
; ------------------------------------------------------------------------------------------------------------------------------------------
Evnt05																									; evnt05 equ $
																											; 		 xor a
																											; 		 ld hl,vara
			tst	<varA																					; 		 cp (hl)
			bne	F00027																				; 		 jp nz,f00027
;S			clra																							; 		 xor a
;S			jsr	AnimSp																				; 		 call animsp
			jsr	AnimSp0						; substitutes previous TWO						; 		 call animsp
F00027	clr	<reg_B																				; f00027 ld b,0
			jsr	SkTyp																					; 		 call sktyp
			bcc	E00241						; exit												; 		 jp nc,f00647
			lda	<joyVal																				; 		 ld a,(joyval)
			anda	#64							; is Inventory requested?						; 		 and 64
			beq	E00241						; no, exit											; 		 jp z,f00647
			lda	#9																						; 		 ld a,9
			jsr	MInve																					; 		 call minve
													; AY-3 not present								; 		 call silenc
																											; 		 ld a,(ix+8)
																											; 		 ld (vare),a
																											; 		 ld a,(ix+9)
																											; 		 ld (varf),a
; ------------------------------------------------------------------------------------------------------------------------------------------
			ldd	scNo							; scNo + varOpt									; 		 ld a,25
																											; 		 ld hl,scno
																											; 		 cp (hl)
																											; 		 jp nz,f00325
													; *** OPEN DOOR WITH KEY RED	*** 			; 		 ld a,4
													; screen 25, option 4							; 		 ld hl,varopt
			cmpd	#$1904						; 25-04												; 		 cp (hl)
			bne	F00325																				; 		 jp nz,f00325
			ldd	#$0e09						; 14-09 (X-Y for PAttr)							; 		 ld a,9
																											; 		 ld (charx),a
			jsr	Evnt2R3						; substitutes next FOUR							; 		 ld a,14
;S			std	<charX							; as charXY											; 		 ld (chary),a
;S			ldx	#chgFx																				; 		 ld hl,chgfx
;S			stx	<grBase																				; 		 ld (grbase),hl
;R													; redundant											; 		 ld hl,(charx)
;S			std	<dispX							; and as dispXY									; 		 ld (dispx),hl
			jsr	Evnt2R10						; substitutes next SIX
;S			clra																							; 		 xor a
;S			jsr	PAttr							; open a part of the door						; 		 call pattr
;S			ldd	<dispX																					; 		 ld hl,(dispx)
;S			std	<charX																					; 		 ld (charx),hl
;S			ldx	#chgFx																				; 		 ld hl,chgfx
;S			stx	<grBase																				; 		 ld (grbase),hl
;R													; redudant											; 		 ld hl,(charx)
;R													; redudant											; 		 ld (dispx),hl
			jsr	Evnt2R40						; substitutes next FOUR
;S			clra																							; 		 xor a
;S			jsr	PAttr							; open second part								; 		 call pattr
;S			ldx	<dispX																					; 		 ld hl,(dispx)
;S			stx	<charX																					; 		 ld (charx),hl
			ldd	#$0e0a						; 14-10 (X - Y for PAttr)						; 		 ld a,10
																											; 		 ld (charx),a
			jsr	Evnt2R3						; substitutes next FOUR							; 		 ld a,14
;S			std	<charX																					; 		 ld (chary),a
;S			ldx	#chgFx																				; 		 ld hl,chgfx
;S			stx	<grBase																				; 		 ld (grbase),hl
;R			ldd	<charX							; redundant											; 		 ld hl,(charx)
;S			std	<dispX																					; 		 ld (dispx),hl
			jsr	Evnt2R10						; substitutes next SIX
;S			clra																							; 		 xor a
;S			jsr	PAttr							; open third part									; 		 call pattr
;S			ldx	<dispX																					; 		 ld hl,(dispx)
;S			stx	<charX																					; 		 ld (charx),hl
;S			ldx	#chgFx																				; 		 ld hl,chgfx
;S			stx	<grBase																				; 		 ld (grbase),hl
;R													; redundant											; 		 ld hl,(charx)
;R													; redundant											; 		 ld (dispx),hl
			jsr	Evnt2R40						; substitutes next FOUR
;S			clra																							; 		 xor a
;S			jsr	PAttr							; open fourth part								; 		 call pattr
;S			ldx	<dispX																					; 		 ld hl,(dispx)
;S			stx	<charX																					; 		 ld (charx),hl
			lda	#50																					; 		 ld a,50
			jsr	Evnt2R2A						; substitutes next THREE
;S			sta	<sndTyp																				; 		 ld (sndtyp),a
;S			lda	#255
;S			sta	5,y																					; 		 ld (ix+5),255
			bra	F00564						; skip next section
; ------------------------------------------------------------------------------------------------------------------------------------------
F00325																									; f00325 ld a,1
																											; 		 ld hl,scno
																											; 		 cp (hl)
																											; 		 jp nz,f00564
													; *** OPEN DOOR WITH KEY RED ***				; 		 ld a,4
													; screen 1, option 4								; 		 ld hl,varopt
			cmpd	#$0104						; 01-04												; 		 cp (hl)
			bne	F00564																				; 		 jp nz,f00564
			ldd	#$160f						; 22-15	(X - Y fr PAttr)						; 		 ld a,15
																											; 		 ld (charx),a
			jsr	Evnt2R3						; substitutes next FOUR							; 		 ld a,22
;S			std	<charX																					; 		 ld (chary),a
;S			ldx	#chgFx																				; 		 ld hl,chgfx
;S			stx	<grBase																				; 		 ld (grbase),hl
																											; 		 ld hl,(charx)
;S			std	<dispX																					; 		 ld (dispx),hl
			jsr	Evnt2R10						; substitutes next SIX
;S			clra																							; 		 xor a
;S			jsr	PAttr																					; 		 call pattr
;S			ldd	<dispX																					; 		 ld hl,(dispx)
;S			std	<charX																					; 		 ld (charx),hl
;S			ldx	#chgFx																				; 		 ld hl,chgfx
;S			stx	<grBase																				; 		 ld (grbase),hl
;R													; redundant											; 		 ld hl,(charx)
;R													; redundant											; 		 ld (dispx),hl
			jsr	Evnt2R40						; substitutes next FOUR
;S			clra																							; 		 xor a
;S			jsr	PAttr																					; 		 call pattr
;S			ldd	<dispX																					; 		 ld hl,(dispx)
;S			std	<charX																					; 		 ld (charx),hl
			ldd	#$1610						; 22-16 (X - Y for PAttr)						; 		 ld a,16
																											; 		 ld (charx),a
			jsr	Evnt2R3						; substitutes next FOUR							; 		 ld a,22
;S			std	<charX																					; 		 ld (chary),a
;S			ldx	#chgFx																				; 		 ld hl,chgfx
;S			stx	<grBase																				; 		 ld (grbase),hl
																											; 		 ld hl,(charx)
;S			std	<dispX																					; 		 ld (dispx),hl
			jsr	Evnt2R10						; substitutes next SIX
;S			clra																							; 		 xor a
;S			jsr	PAttr																					; 		 call pattr
;S			ldd	<dispX																					; 		 ld hl,(dispx)
;S			std	<charX																					; 		 ld (charx),hl
;S			ldx	#chgFx																				; 		 ld hl,chgfx
;S			stx	<grBase																				; 		 ld (grbase),hl
;R													; redundant											; 		 ld hl,(charx)
;R													; redundant											; 		 ld (dispx),hl
			jsr	Evnt2R40						; substitutes next FOUR
;S			clra																							; 		 xor a
;S			jsr	PAttr																					; 		 call pattr
;S			ldd	<dispX																					; 		 ld hl,(dispx)
;S			std	<charX																					; 		 ld (charx),hl
			lda	#50																					; 		 ld a,50
			jsr	Evnt2R2A						; substitutes next THREE
;S			sta	<sndTyp																				; 		 ld (sndtyp),a
;S			lda	#255
;S			sta	5,y																					; 		 ld (ix+5),255
; ------------------------------------------------------------------------------------------------------------------------------------------
;OF00564	lda	#5																						; f00564 ld a,5
F00564	lda	scNo							; get screen number								; f00564 ld a,5
			ldb	<varK							; and  number of collected crystals			; 		 ld hl,scno
;O			cmpa	scNo							; screen 5											; 		 cp (hl)
			cmpd	#$0503						; screen 5, 3 crystals							; 		 cp (hl)
			bne	F00647						; doesn't match? exit							; 		 jp nz,f00647
;O			lda	#3																						; 		 ld a,3
																											; 		 ld hl,vark
;O			cmpa	<varK							; numer of crystals								; 		 cp (hl)
;O			bne	F00628																				; 		 jp nz,f00628
			lda	#19							; object MACHINE									; 		 ld a,19
																											; 		 ld hl,varopt
			cmpa	varOpt						; got it?											; 		 cp (hl)
			bne	F00628						; no, exit											; 		 jp nz,f00628
			lda	#27							; last game screen number						; 		 ld a,27
			sta	scNo							; set as next one									; 		 ld (scno),a
			jsr	NwScr							; go start it										; 		 call nwscr
F00628																									; f00628 ld a,(vare)
																											; 		 ld (ix+8),a
																											; 		 ld a,(varf)
																											; 		 ld (ix+9),a
F00647	rts									; return												; f00647 ret
; ------------------------------------------------------------------------------------------------------------------------------------------
Evnt06																									; evnt06 equ $
																											; 		 xor a
			tst	11,y																					; 		 cp (ix+11)
			bne	G00085																				; 		 jp nz,g00085
			jsr	CanGL																					; 		 call cangl
			bne	G00072																				; 		 jp nz,g00072
			dec	9,y																					; 		 dec (ix+9)
			dec	9,y																					; 		 dec (ix+9)
													; wasting											; 		 ld c,16
													; time												; 		 ld a,(ix+9)
													; doing												; 		 sub c
													; and													; 		 ld (ix+9),a
													; undoing											; 		 ld c,16
													; the 												; 		 ld a,(ix+9)
													; same												; 		 add a,c
													; operation											; 		 ld (ix+9),a
			bra	G00080																				; 		 jp g00080
G00072	lda	#1																						; g00072 ld a,1
			sta	11,y																					; 		 ld (ix+11),a
G00080	bra	G00149																				; g00080 jp g00149
G00085	jsr	CanGR																					; g00085 call cangr
			bne	G00141																				; 		 jp nz,g00141
			inc	9,y																					; 		 inc (ix+9)
			inc	9,y																					; 		 inc (ix+9)
													; wasting											; 		 ld c,16
													; time												; 		 ld a,(ix+9)
													; doing												; 		 add a,c
													; and													; 		 ld (ix+9),a
													; undoing											; 		 ld c,16
													; the 												; 		 ld a,(ix+9)
													; same												; 		 sub c
													; operation											; 		 ld (ix+9),a
			bra	G00149																				; 		 jp g00149
G00141																									; g00141 xor a
			clr	11,y																					; 		 ld (ix+11),a
G00149	lda	#1																						; g00149 ld a,1
			cmpa	11,y																					; 		 cp (ix+11)
			bne	G00208																				; 		 jp nz,g00208
																											; 		 xor a
																											; 		 ld hl,vara
			tst	<varA																					; 		 cp (hl)
			bne	G00208																				; 		 jp nz,g00208
;S			clra																							; 		 xor a
;S			jsr	AnimSp																				; 		 call animsp
			jsr	AnimSp0						; substitutes previous TWO						; 		 call animsp
			lda	#3																						; 		 ld a,3
			cmpa	7,y																					; 		 cp (ix+7)
			bne	G00208																				; 		 jp nz,g00208
			lda	#35																					; 		 ld a,35
			sta	<sndTyp																				; 		 ld (sndtyp),a
G00208																									; g00208 xor a
			tst	11,y																					; 		 cp (ix+11)
			bne	G00267																				; 		 jp nz,g00267
																											; 		 xor a
																											; 		 ld hl,vara
			tst	<varA																					; 		 cp (hl)
			bne	G00267																				; 		 jp nz,g00267
			clra																							; 		 xor a
			jsr	AnimBk																				; 		 call animbk
			lda	#3																						; 		 ld a,3
			cmpa	7,y																					; 		 cp (ix+7)
			bne	G00267																				; 		 jp nz,g00267
			lda	#35																					; 		 ld a,35
			sta	<sndTyp																				; 		 ld (sndtyp),a
G00267	clr	<reg_B																				; g00267 ld b,0
			jsr	SkTyp																					; 		 call sktyp
			bcc	G00289																				; 		 jp nc,g00289
			lda	#1																						; 		 ld hl,deadf
			sta	<deadF																					; 		 ld (hl),h
G00289																									; g00289 ld a,8
																											; 		 cp (ix+6)
																											; 		 jp nz,g00317
																											; 		 ld a,6
																											; 		 and 7
																											; 		 ld c,a
																											; 		 call cspr
G00317	rts																							; g00317 ret
; ------------------------------------------------------------------------------------------------------------------------------------------
Evnt07																									; evnt07 equ $
			rts																								; 		 ret
; ------------------------------------------------------------------------------------------------------------------------------------------
Evnt08																									; evnt08 equ $
			rts																								; 		 ret
; ------------------------------------------------------------------------------------------------------------------------------------------
Evnt09																									; evnt09 equ $
			lda	#4								; get value 4										; 		 ld a,4
			cmpa	5,y							; equals value at offset 5?					; 		 cp (ix+5)
			bne	J00024						; no, skip two										; 		 jp nz,j00024
			lda	#1								; put value 1										; 		 ld a,1
			sta	11,y							; at ofset 11										; 		 ld (ix+11),a
J00024																									; j00024 xor a
			tst	5,y							; is offset 5 zero?								; 		 cp (ix+5)
			bne	J00068						; no, exit											; 		 jp nz,j00068
			ldd	<varO							; get variable O+P								; 		 ld a,(varo)
			inca									; increment it										; 		 ld (ix+8),a
			std	8,y							; put at offset 8+9								; 		 ld a,(varp)
																											; 		 ld (ix+9),a
																											; 		 ld a,(ix+8)
																											; 		 inc a
																											; 		 ld (ix+8),a
J00068	rts																							; j00068 ret
; ------------------------------------------------------------------------------------------------------------------------------------------
Evnt10																									; evnt10 equ $
			inc	<varA							; increment varA									; 		 ld a,(vara)
																											; 		 inc a
																											; 		 ld (vara),a
			lda	#2								; get value 2										; 		 ld a,2
																											; 		 ld hl,vara
			cmpa	<varA							; is varA <= 2?									; 		 cp (hl)
			bcc	K00040						; yes, skip next									; 		 jp nc,k00040
																											; 		 xor a
			clr	<varA							; reset varA										; 		 ld (vara),a
K00040	lda	#1								; get value 1										; k00040 ld a,1
																											; 		 ld hl,varh
			cmpa	<varH							; is varH=1?										; 		 cp (hl)
			bne	K00168						; no, skip section								; 		 jp nz,k00168
			lda	#12							; object Medicine BOX							; 		 ld a,12
			jsr	GotOb							; has player this object?						; 		 call gotob
			bcs	K00168						; if not in pocket's, skip section			; 		 jp c,k00168
			ldx	<reg_IX						; get pointer to sprite 
																											; 		 ld a,(ix+8)
																											; 		 ld (vare),a
																											; 		 ld a,(ix+9)
																											; 		 ld (varf),a
																											; 		 ld a,40
																											; 		 ld (ix+8),a
																											; 		 ld a,88
																											; 		 ld (ix+9),a
																											; 		 ld a,(ix+9)
																											; 		 ld h,a
																											; 		 ld a,(ix+8)
																											; 		 ld l,a
																											; 		 ld (dispx),hl
			lda	#12							; object MedKIT									; 		 ld a,12
			jsr	DrpObI						; drop it invisible								; 		 call drpob
																											; 		 ld a,(vare)
																											; 		 ld (ix+8),a
																											; 		 ld a,(varf)
																											; 		 ld (ix+9),a
			inc	<varH							; increment varH									; 		 ld a,(varh)
																											; 		 inc a
																											; 		 ld (varh),a
; ------------------------------------------------------------------------------------------------------------------------------------------
K00168	lda	#1								; get value 1										; k00168 ld a,1
																											; 		 ld hl,vari
			cmpa	<varI							; is varI=1?										; 		 cp (hl)
			bne	K00295						; no, skip section								; 		 jp nz,k00295
			lda	#13							; get value 13										; 		 ld a,13
			jsr	GotOb							; has player this object?						; 		 call gotob
			bcs	K00295						; if not in pocket's, skip section			; 		 jp c,k00295
			ldx	<reg_IX						; get pointer to sprite
																											; 		 ld a,(ix+8)
																											; 		 ld (vare),a
																											; 		 ld a,(ix+9)
																											; 		 ld (varf),a
																											; 		 ld a,8
																											; 		 ld (ix+8),a
																											; 		 ld a,24
																											; 		 ld (ix+9),a
																											; 		 ld a,(ix+9)
																											; 		 ld h,a
																											; 		 ld a,(ix+8)
																											; 		 ld l,a
																											; 		 ld (dispx),hl
			lda	#13							; object MedKIT									; 		 ld a,13
			jsr	DrpObI						; drop it invisible								; 		 call drpob
																											; 		 ld a,(vare)
																											; 		 ld (ix+8),a
																											; 		 ld a,(varf)
																											; 		 ld (ix+9),a
			inc	<varI							; increment varI									; 		 ld a,(vari)
																											; 		 inc a
																											; 		 ld (vari),a
; ------------------------------------------------------------------------------------------------------------------------------------------
K00295	lda	#27							; get value 27										; k00295 ld a,27
																											; 		 ld hl,scno
			cmpa	scNo							; is player in last screen?					; 		 cp (hl)
			bne	K00425						; no, skip section								; 		 jp nz,k00425
																											; 		 xor a
			tst	<varG							; is varG zero?									; 		 ld hl,varg
																											; 		 cp (hl)
			bne	K00425						; no, skip section								; 		 jp nz,k00425
																											; 		 ld a,69
				 																							; 		 ld (23693),a
			ldd	#$0302						; 03-02												; 		 ld a,2
																											; 		 ld (charx),a
																											; 		 ld a,3
			std	<charX							; into variables									; 		 ld (chary),a
			ldb	#11							; select message									; 		 ld a,11
			jsr	Dmsg							; show it											; 		 call dmsg
																											; 		 ld a,70
																											; 		 ld (23693),a
			ldd	#$0c12						; 12-18												; 		 ld a,18
																											; 		 ld (charx),a
																											; 		 ld a,12
			std	<charX							; into variabes									; 		 ld (chary),a
			ldb	#20							; get message										; 		 ld a,20
			jsr	Dmsg							; show it											; 		 call dmsg
			inc	<varG							; increment varG									; 		 ld a,(varg)
																											; 		 inc a
																											; 		 ld (varg),a
;;;			ldx	<reg_IX						; get reg_IX
;;;			pshs	x								; put onto stack									; 		 push ix
			ldb	#25							; get value 25										; 		 ld b,25
			jsr	Delay							; wait for a while								; 		 call delay
;;;			puls	x								; restore value									; 		 pop ix
;;;			stx	<reg_IX						; into register
; ------------------------------------------------------------------------------------------------------------------------------------------
K00425	lda	#27							; get value 27										; k00425 ld a,27
																											; 		 ld hl,scno
			cmpa	scNo							; is player in last screen?					; 		 cp (hl)
			bne	K00456						; no, exit											; 		 jp nz,k00456
			jsr	PrsKey						; wait for keypress								; 		 call prskey
			lda	#1								; put not zero value								; 		 ld hl,gamwon
			sta	<gamWon						; set game is won (<>0)							; 		 ld (hl),h
K00456	rts									; return												; k00456 ret
; ------------------------------------------------------------------------------------------------------------------------------------------
Evnt11																									; evnt11 equ $
			rts									; return												; 		 ret
; ------------------------------------------------------------------------------------------------------------------------------------------
Evnt12																									; evnt12 equ $
																											; 		 ld a,70
	IF PMODE4																							; 		 ld (23693),a
			jsr	Cls							; clear screen: PCLS0							; 		 call cls
	ELSE
			ldd	#$aaaa						; force cls to Blue
			jsr	ClsD							; clear screen: PCLS0							; 		 call cls
	ENDIF
			ldd	#$ffaa						; ANDA $ff - EORA $aa (YELLOW)				; 		 ld a,69
			std	<andeor						; put into variables								; 		 ld (23693),a
			ldd	#$0003						; 00-03 column, row								; 		 ld a,4
			std	<charX							; set actual pos X,Y								; 		 ld (charx),a
																											; 		 xor a
																											; 		 ld (chary),a
																											; 		 ld a,10
			ldb	#12							; 3rd: big rectangle w/chars and graphs	; 		 ld a,12
			jsr	Dmsg							; show it											; 		 call dmsg
																											; 		 ld a,70
																											; 		 ld (23693),a
			ldd	#$1d03						; 29-03 column, row								; 		 ld a,4
			std	<charX							; set actual pos X,Y								; 		 ld (charx),a
																											; 		 ld a,29
																											; 		 ld (chary),a
													; ANDA $ff - EORA $aa (YELLOW)				; 		 ld a,10
			ldb	#16							; 7th: moon right of row4						; 		 ld a,16
			jsr	Dmsg							; show it											; 		 call dmsg
			ldd	#$0015						; 00-21 column, row					
			std	<charX							; set actual pos X,Y			
													; ANDA $ff - EORA $aa (YELLOW)		
			ldb	#22							; 9th: 6809 CODE PERE SERRAT
			jsr	Dmsg							; show it						
	IF !PMODE4
			ldd	#$0016						; 00-22 column, row					
			std	<charX							; set actual pos X,Y			
			ldb	#23							; 10th: PM3 GRAPH. JOSE LUIS TUR
			jsr	Dmsg							; show it						
	ENDIF
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
			ldd	#$0a02						; 10-02 column, row								; 		 ld a,2
			std	<charX							; set actual pos X,Y								; 		 ld (charx),a
			lda	#$aa							; ANDA $aa - EORA $aa (GREEN)					; 		 ld a,10
			sta	<andeor						; put into variables
			clrb									; 1st: FOGGYS QUEST								; 		 ld (chary),a
			stb	<prtMod						; ensure normal size								; 		 xor a
			jsr	Dmsg							; show it											; 		 call dmsg
			ldd	#$0001						; 00-01 column, row								; 		 ld a,1
			std	<charX							; set actual pos X,Y								; 		 ld (charx),a
			ldb	#18							; 2nd: upper part of F							; 		 ld a,18
			jsr	Dmsg							; show it											; 		 call dmsg
																											; 		 ld a,68
																											; 		 ld (23693),a
			ldd	#$0011						; 00-17 column, row								; 		 ld a,18
			std	<charX							; set actual pos X,Y								; 		 ld (charx),a
																											; 		 xor a
																											; 		 ld (chary),a
													; ANDA $aa - EORA $aa (GREEN)					; 		 ld a,10
			ldb	#13							; 4th: publisher and copyright				; 		 ld a,13
			jsr	Dmsg							; show it											; 		 call dmsg
																											; 		 ld a,78
																											; 		 ld (23693),a
			ldd	#$1403						; 20-03												; 		 ld a,4
																											; 		 ld (charx),a
																											; 		 ld a,20
			std	<charX							; AND $aa - EOR $aa (GREEN)					; 		 ld (chary),a
			ldb	#8								; get sign											; 		 ld a,8
			jsr	Dmsg							; show it											; 		 call dmsg
																											; 		 ld a,102
																											; 		 ld (23693),a
			ldd	#$0b0b						; 11-11												; 		 ld a,12
																											; 		 ld (charx),a
																											; 		 ld a,11
			std	<charX							; AND $aa - EOR $aa (GREEN)					; 		 ld (chary),a
			ldb	#8								; get sign											; 		 ld a,8
			jsr	Dmsg							; show it											; 		 call dmsg
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
			lda	#$55							; AND $55 - EOR $aa (RED)						; 		 ld a,71
			sta	<andeor						; put into variables								; 		 ld (23693),a
			ldd	#$0f01						; 15-01 column, row								; 		 ld a,1
			std	<charX							; set actual pos X,Y								; 		 ld (charx),a
																											; 		 ld a,15
																											; 		 ld (chary),a
			ldb	#14							; 5th: eyes over title							; 		 ld a,14
			jsr	Dmsg							; show it											; 		 call dmsg
			ldd	#$0207						; 02-07 column, row								; 		 ld a,8
			std	<charX							; set actual pos X,Y								; 		 ld (charx),a
																											; 		 ld a,2
																											; 		 ld (chary),a
													; ANDA $55 - EORA $aa (RED)					; 		 ld a,10
			ldb	#15							; 6th: spaceship left of choice 1			; 		 ld a,15
			jsr	Dmsg							; show it											; 		 call dmsg
																											; 		 ld a,94
																											; 		 ld (23693),a
			ldd	#$0c0b						; 12-11												; 		 ld a,12
																											; 		 ld (charx),a
																											; 		 ld a,12
			std	<charX							; AND $55 - EOR $aa (RED)						; 		 ld (chary),a
			ldb	#8								; get sign											; 		 ld a,8
			jsr	Dmsg							; show it											; 		 call dmsg
																											; 		 ld a,66
																											; 		 ld (23693),a
			ldd	#$0013						; 00-13 column, row								; 		 ld a,21
			std	<charX							; set actual pos X,Y								; 		 ld (charx),a
													; ANDA $55 - EORA $aa (RED)					; 		 ld a,10
			inc	<prtMod						; set double size
			ldb	#17							; 8th: POWERED BY AGD							; 		 ld a,17
			jsr	Dmsg							; show it											; 		 call dmsg
			dec	<prtMod						; set normal size
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
																											; 		 ld a,5
																											; 		 ld (23693),a
																											; 		 ld a,6
																											; 		 ld (charx),a
																											; 		 ld a,8
																											; 		 ld (chary),a
																											; 		 ld a,10
													; NOTHING (already done)						; 		 call dmsg
																											; 		 ld a,10
																											; 		 ld (charx),a
																											; 		 ld a,8
																											; 		 ld (chary),a
																											; 		 ld a,10
													; NOTHING (already done)						; 		 call dmsg
																											; 		 ld a,8
																											; 		 ld (charx),a
																											; 		 ld a,23
																											; 		 ld (chary),a
																											; 		 ld a,10
													; NOTHING (already done)						; 		 call dmsg
																											; 		 ld a,69
																											; 		 ld (23693),a
																											; 		 ld a,9
																											; 		 ld (charx),a
																											; 		 ld a,23
																											; 		 ld (chary),a
													; added to line									; 		 ld a,10
													; right border choice 2							; 		 call dmsg
																											; 		 ld a,86
																											; 		 ld (23693),a
																											; 		 ld a,12
																											; 		 ld (charx),a
																											; 		 ld a,10
																											; 		 ld (chary),a
																											; 		 ld a,8
													; NOTHING (already done)						; 		 call dmsg
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
			jsr	PrsKey						; process Joystick and Keyboard				; 		 call prskey
			ldd	#$ff00						; ANDA $ff - EORA $00							; 		 ld a,10
			std	<andeor						; no colour changes
												; ADDED to allow user to select Joystick
			ldx	#keys+8						; to verify key '2'
			lda	,x								; get column  value
			jsr	KTest							; check if pressed 
			bcc	NoJstk						; not pressed, exit
			lda	#1								; set to one
			sta	<contrl						; controls
			sta	<varF							; and varF
NoJstk	rts									; return												; 		 ret
; ------------------------------------------------------------------------------------------------------------------------------------------
Evnt13																									; evnt13 equ $
													; value zero										; 		 xor a
													; for border colour								; 		 call 8859
													;														; 		 ld a,77
																											; 		 ld (23693),a
			jsr	Cls							; clear screen										; 		 call cls
																											; 		 call silenc
																											; 		 ld a,75
																											; 		 ld (23693),a
			ldd	#$0214						; 02-20 actual pos X,Y							; 		 ld a,20
																											; 		 ld (charx),a
																											; 		 ld a,2
			std	<charX							; set actual pos X,Y								; 		 ld (chary),a
			ldd	#$ffaa						; AND $ff - EOR $aa (YELLOW)
			std	<andeor
			clrb									; message 0: "FOGGYS QUEST"					; 		 xor a
			jsr	Dmsg							; show it											; 		 call dmsg
																											; 		 ld a,77
																											; 		 ld (23693),a
																											; 		 xor a
													; done below										; 		 ld (varc),a
																											; 		 xor a
													; done below										; 		 ld (varg),a
			ldd	#$8020						; 128-32												; 		 ld a,128
																											; 		 ld (varo),a
																											; 		 ld a,32
			std	<varO							; to varO-P											; 		 ld (varp),a
			lda	#3								; default											; 		 ld a,3
			sta	numLif						; number of lives									; 		 ld (numlif),a
			clra									; get zero											; 		 xor a
			sta	<varK							; to													; 		 ld (vark),a
			sta	<varC							; clear												; 		 xor a
			sta	<varE							; some												; 		 ld (vare),a
			sta	<varG							; more												; 		 xor a
			sta	<varF							; variables											; 		 ld (varf),a
			ldd	#$0100						; 01-00 actual pos X,Y							; 		 xor a
																											; 		 ld (charx),a
																											; 		 ld a,1
			std	<charX							; set actual pos X,Y								; 		 ld (chary),a
			ldd	#$ff00						; AND $ff - EOR $00 (NO CHANGE)
			std	<andeor
			ldb	#3								; message 3	(vertical bar)						; 		 ld a,3
			jsr	Dmsg							; show it											; 		 call dmsg
			lda	#21							; 21+1 times										; 		 ld a,21
			sta	<loopA							; to repeat loopA									; 		 ld (loopa),a
			clr	<charY							; 1st time use row 0
N00169	lda	#$01						   ; always use column 1 							; n00169 ld a,1
			sta	<charX							; put on variable									; 		 ld (chary),a
			ldb	#3								; message 3	(vertical bar)						; 		 ld a,3
			jsr	Dmsg							; show it											; 		 call dmsg
			dec	<loopA							; decrement counterA								; 		 ld hl,loopa
			bpl	N00169						; not done, loop									; 		 dec (hl)
																											; 		 jp nz,n00169
			lda	#$01							; use column 1										; 		 ld a,1
			sta	<charX							; put on variable									; 		 ld (chary),a
			ldb	#4								; message 4											; 		 ld a,4
			jsr	Dmsg							; show it											; 		 call dmsg
			ldd	#$1e00						; 30-00												; 		 xor a
																											; 		 ld (charx),a
																											; 		 ld a,30
			std	<charX							; set actual pos X,Y								; 		 ld (chary),a
			ldb	#3								; message 3	(vertical bar)						; 		 ld a,3
			jsr	Dmsg							; show it											; 		 call dmsg
			lda	#21							; 21+1 times										; 		 ld a,21
			sta	<loopA							; to repeat loopA									; 		 ld (loopa),a
			clr	<charY							; 1st time use row 0								
N00249	lda	#30							; always use col 30								; n00249 ld a,30
			sta	<charX							; put on variable									; 		 ld (chary),a
			ldb	#3								; message 3	(vertical bar)						; 		 ld a,3
			jsr	Dmsg							; show it											; 		 call dmsg
			dec	<loopA							; decrement counterA								; 		 ld hl,loopa
			bpl	N00249						; not done, loop									; 		 dec (hl)
																											; 		 jp nz,n00249
			ldd	#$0216						; actual pos X,Y									; 		 ld a,22
																											; 		 ld (charx),a
																											; 		 ld a,2
			std	<charX							; set actual pos X,Y								; 		 ld (chary),a
			ldb	#5								; message 5 (horizontal bar)					; 		 ld a,5
			jsr	Dmsg							; show it											; 		 call dmsg
			ldd	#$1e16						; actual pos X,Y									; 		 ld a,22
																											; 		 ld (charx),a
																											; 		 ld a,30
			std	<charX							; set actual pos X,Y								; 		 ld (chary),a
			ldb	#6								; message 6											; 		 ld a,6
			jsr	Dmsg							; show it											; 		 call dmsg
																											; 		 ld a,78
																											; 		 ld (23693),a
			ldd	#$0e15						; 14-21 actual pos X,Y							; 		 ld a,21
																											; 		 ld (charx),a
																											; 		 ld a,22
			std	<charX							; set actual pos X,Y								; 		 ld (chary),a
			ldd	#$aaaa						; AND $aa - EOR $aa (GREEN)
			std	<andeor
			ldb	#1								; message 1											; 		 ld a,1
			jsr	Dmsg							; show it											; 		 call dmsg

			jsr	ShowNumL						; SUBSTITUTES NEXT FOUR
;S			ldd	#$1d15						; actual pos X,Y									; 		 ld a,21
																											; 		 ld (charx),a
																											; 		 ld a,29
;S			std	<charX							; set actual pos X,Y								; 		 ld (chary),a
;S			lda	numLif						; get player lifes number						; 		 ld a,(numlif)
;S			jsr	Disply						; show it											; 		 call disply

			ldd	#$0215						; actual pos X,Y									; 		 ld a,21
																											; 		 ld (charx),a
																											; 		 ld a,2
			std	<charX							; set actual pos X,Y								; 		 ld (chary),a
			ldd	#$ffaa						; AND $ff - EOR $aa (YELLOW)
			std	<andeor
			ldb	#7								; message 7											; 		 ld a,7
			jsr	Dmsg							; show it											; 		 call dmsg
																											; 		 ld a,79
																											; 		 ld (23693),a
			ldd	#$0e14						; 14-20 actual pos X,Y							; 		 ld a,20
																											; 		 ld (charx),a
																											; 		 ld a,19
			std	<charX							; set actual pos X,Y								; 		 ld (chary),a
			lda	#$aa							; AND $aa - EOR $aa (GREEN)
			sta	<andeor
			ldb	#2								; message 2											; 		 ld a,2
			jsr	Dmsg							; show it											; 		 call dmsg
			ldd	#$ff00						; AND $ff - EOR $00 (NO CHANGE)
			std	<andeor

			jsr	ShowNumC						; SUBSTITUTES NEXT FOUR
;S			ldd	#$1d14						; actual pos X,Y									; 		 ld a,20
																											; 		 ld (charx),a
																											; 		 ld a,29
;S			std	<charX							; set actual pos X,Y								; 		 ld (chary),a
;S			lda	<varK							; get number of crystals						; 		 ld a,(vark)
;S			jsr	Disply						; show it											; 		 call disply
			rts									; return												; 		 ret
; ------------------------------------------------------------------------------------------------------------------------------------------
Evnt14																									; evnt14 equ $
			rts									; return												; 		 ret
; ------------------------------------------------------------------------------------------------------------------------------------------
Evnt15																									; evnt15 equ $
			rts									; return												; 		 ret
; ------------------------------------------------------------------------------------------------------------------------------------------
Evnt16																									; evnt16 equ $
			ldb	#60																					; 		 ld a,60
			stb	<sndTyp																				; 		 ld (sndtyp),a
;;;			lbsr	Evnt2R6						; substitutes next THREE
;S			pshs	y																						; 		 push ix
																											; 		 ld b,a
			jsr	Delay																					; 		 call delay
;S			puls	y																						; 		 pop ix
																											; 		 ld a,(numlif)
																											; 		 dec a
			dec	numLif																				; 		 ld (numlif),a
			ldd	<varO																					; 		 ld a,(varo)
																											; 		 ld (ix+8),a
																											; 		 ld a,(varp)
			std	8,y																					; 		 ld (ix+9),a
																											; 		 ld a,78
																											; 		 ld (23693),a
			jsr	ShowNumL						; SUBSTITUTES NEXT FOUR
;S			ldd	#$1d15						; 29-21												; 		 ld a,21
;S			std	<charX																					; 		 ld (charx),a
																											; 		 ld a,29
																											; 		 ld (chary),a
;S			lda	numLif																				; 		 ld a,(numlif)
;S			jsr	Disply																				; 		 call disply
			rts																							; 		 ret
; ------------------------------------------------------------------------------------------------------------------------------------------
Evnt17																									; evnt17 equ $
;S			pshs	y																						; 		 push ix
			ldb	#50																					; 		 ld b,50
;;;			lbsr	Evnt2R6						; substitutes previous ONE and next TWO
			jsr	Delay																					; 		 call delay
;S			puls	y																						; 		 pop ix
			jsr	Cls																					; 		 call cls
																											; 		 ld a,77
																											; 		 ld (23693),a
			ldd	#$0a0a						; 10-10												; 		 ld a,10
																											; 		 ld (charx),a
																											; 		 ld a,10
			std	<charX																					; 		 ld (chary),a
			clrb																							; 		 xor a
			jsr	Dmsg																					; 		 call dmsg
			lda	#9																						; 		 ld a,9
			sta	<charY																					; 		 ld (charx),a
			ldb	#18																					; 		 ld a,18
			jsr	Dmsg																					; 		 call dmsg
																											; 		 ld a,206
																											; 		 ld (23693),a
			ldd	#$0c0c						; 12-12												; 		 ld a,12
																											; 		 ld (charx),a
																											; 		 ld a,12
			std	<charX																					; 		 ld (chary),a
			ldb	#21																					; 		 ld a,21
			jsr	Dmsg																					; 		 call dmsg
																											; 		 ld a,79
																											; 		 ld (23693),a
			ldd	#$0f0e						; 15-14												; 		 ld a,14
																											; 		 ld (charx),a
																											; 		 ld a,15
			std	<charX																					; 		 ld (chary),a
			ldb	#14																					; 		 ld a,14
			jsr	Dmsg																					; 		 call dmsg
;S			pshs	y																						; 		 push ix
			ldb	#250																					; 		 ld b,200
;;;			jsr	Evnt2R6						; substitutes previous ONE and next TWO
			jsr	Delay																					; 		 call delay
																											; 		 pop ix
;S			puls	y,pc																					; 		 ret
			rts																							; 		 ret
; ------------------------------------------------------------------------------------------------------------------------------------------
Evnt18	ldy	<reg_IX																				; evnt18 equ $
																											; 		 ld a,69
																											; 		 ld (23693),a
			jsr	Cls																					; 		 call cls
;S			pshs	y																						; 		 push ix
			ldb	#50																					; 		 ld b,50
;;;			lbsr	Evnt2R6						; substitutes previous ONE and next TWO
			jsr	Delay																					; 		 call delay
;S			puls	y																						; 		 pop ix
			ldd	#$0001						; 00-01												; 		 ld a,1
																											; 		 ld (charx),a
																											; 		 xor a
			std	<charX																					; 		 ld (chary),a
			ldb	#19																					; 		 ld a,19
			jsr	Dmsg																					; 		 call dmsg
																											; 		 ld a,70
																											; 		 ld (23693),a
			ldd	#$0b15						; 11-21												; 		 ld a,21
																											; 		 ld (charx),a
																											; 		 ld a,11
			std	<charX																					; 		 ld (chary),a
			ldb	#20																					; 		 ld a,20
			jsr	Dmsg																					; 		 call dmsg
			jsr	PrsKey																				; 		 call prskey
			rts																							; 		 ret
; ------------------------------------------------------------------------------------------------------------------------------------------
Evnt19																									; evnt19 equ $
			rts																							; 		 ret
; ------------------------------------------------------------------------------------------------------------------------------------------
																											; evnt20 equ $
																											; 		 ret
; ------------------------------------------------------------------------------------------------------------------------------------------
																											; ptcusr ret
; ------------------------------------------------------------------------------------------------------------------------------------------
msgDat																									; msgdat equ $
			fcc	/FOGGYS;QUEST/,141							; msg #00						; 		 defb 'FOGGYS;QUEST',141
			fcc	/        LIVES: /,141						; msg #01						; 		 defb 'LIVES:',141
			fcc	/     CRYSTALS: /,141						; msg #02						; 		 defb 'CRYSTALS:',141
			fcc	/@/,141											; msg #03						; 		 defb '@',141
			fcc	/`/,141											; msg #04						; 		 defb '`',141
			fcc	/____________________________/,141		; msg #05						; 		 defb '____________________________',141
			fcc	/$/,141											; msg #06						; 		 defb '$',141
			fcc	/BY:;J.BLYTHE/,141							; msg #07						; 		 defb 'BY:;J.BLYTHE',141
			fcc	/x/,141											; msg #08						; 		 defb 'x',141
			fcc	/;KEY;BLUE;;/,13																	; 		 defb ';KEY;BLUE;;',13
			fcc	/CRYSTAL;BLU/,13																	; 		 defb 'CRYSTAL;BLU',13
			fcc	/CRYSTAL;RED/,13																	; 		 defb 'CRYSTAL;RED',13
			fcc	/CRYSTAL;GRN/,13																	; 		 defb 'CRYSTAL;GRN',13
			fcc	/;;KEY;RED;;/,13																	; 		 defb ';;KEY;RED;;',13
			fcc	/;KEY;PINK;;/,13																	; 		 defb ';KEY;PINK;;',13
			fcc	/;;LADDER;;;/,13																	; 		 defb ';;LADDER;;;',13
			fcc	/;;;BOMB;;;;/,13																	; 		 defb ';;;BOMB;;;;',13
			fcc	/;THE;CUBE;;/,13																	; 		 defb ';THE;CUBE;;',13
			fcc	/;THE;SKULL;/,13																	; 		 defb ';THE;SKULL;',13
			fcc	/;PIT;PLANT;/,13																	; 		 defb ';PIT;PLANT;',13
			fcc	/;;;ROCK;;;;/,13																	; 		 defb ';;;ROCK;;;;',13
			fcc	/EXTRA;LIFE;/,13																	; 		 defb 'EXTRA;LIFE;',13
			fcc	/EXTRA;LIFE;/,13																	; 		 defb 'EXTRA;LIFE;',13
			fcc	/;;A;SEED;;;/,13																	; 		 defb ';;A;SEED;;;',13
			fcc	/;;BALLOON;;/,13																	; 		 defb ';;BALLOON;;',13
			fcc	/;PICK;AXE;;/,13																	; 		 defb ';PICK;AXE;;',13
			fcc	/;;BRICKS;;;/,13																	; 		 defb ';;BRICKS;;;',13
			fcc	/;ICE;DRILL;/,13																	; 		 defb ';ICE;DRILL;',13
			fcc	/;;SPLICER;;/,141								; msg #09						; 		 defb ';;SPLICER;;',141
			fcc	/z/,141											; msg #10						; 		 defb 'z',141
			fcc	/WELL;DONE;FOGGY!!/,141						; msg #11						; 		 defb 'WELL;DONE;FOGGY!!',141
 		 	fcc 	/;;;;;;;;w______________y;;;./,13											; 		 defb ';;;;;;;;w___________x__y;;;.',13
			fcc	/;.;;;;;;@;;;;;;;;;;;;;;@/,13													; 		 defb ';.;;;;;;@;;;;;;;;;;;;;;@',13
			fcc	/;;;;;;;;z;;;CONTROLS;;;@;./,13												; 		 defb ';;;;;;;;z;;;CONTROLS;;;@;.',13
			fcc	/;;;;;.;;@;;;;;;;;;;;;;;@;;;;;;./,13										; 		 defb ';;;;;.;;@;;;;;;;;;;;;;;@;;;;;;.',13
			fcc	/;;;;.;;;@;;1;KEYBOARD;;z/,13													; 		 defb ';;;;.;;;@;;1;KEYBOARD;;z',13
			fcc	/;;;;;;;;@;;2;JOYSTICK;;z/,13													; 		 defb ';;;;;;;;@;;2;KEMPSTON;;@',13
			fcc	/;;;;;;;;z;;;;;;;;;;;;;;@;;;;./,13											; 		 defb ';;;;;;;;z;;3;SINCLAIR;;@;;;;.',13
			fcc	/;;;;;;.;@;;;;;;;;;;;;;;@;;;;;./,13											; 		 defb ';;;;;;.;@;;;;;;;;;;;;;;@;;;;;.',13
			fcc 	/;;.;;;;;`_x____________$;;./,13												; 		 defb ';;.;;;;;`_xx___________$;;.',13
			fcc	13																						; 		 defb 13
			fcc	/;;;;;;;;;;KEYS:O,P,Q,A/,13													; 		 defb ';;;;;;;;;;KEYS:O,P,Q,A',13
			fcc	/;;;;;;;;;;;;;;;I-INV./,13														; 		 defb ';;;;;;;;;;;;;;;I-INV.',13
			fcc	/;;;;;;;;;;;;;;;SPC-JUMP/,141				; msg #12						; 		 defb ';;;;;;;;;;;;;;;SPC-JUMP',141
			fcc	/;;;;;;;;;RUCKSACK;GAMES/,13													; 		 defb ';;;;;;;;;RUCKSACK;GAMES',13
			fcc	/;;;;;;;c;2017;JOHN;BLYTHE/,141			; msg #13						; 		 defb ';;;;;;;c;2017;JOHN;BLYTHE',141
			fcc	"/+",141											; msg #14						; 		 defb '/+',141
			fcc	/>/,141											; msg #15						; 		 defb '>',141
			fcc	/?/,141											; msg #16						; 		 defb '?',141
			fcc	/;;;;;;;;;POWERED;BY;AGD/,141				; msg #17						; 		 defb ';;;;;;;;;POWERED;BY;AGD',141
			fcc	/;;;;;;;;;;v/,13																	; 		 defb ';;;;;;;;;;v',13
			fcc	/;;;;;;;;;;u/,141								; msg #18						; 		 defb ';;;;;;;;;;u',141
			fcc	/;;;HOME;AT;LAST.;FOGGY;TAKES;A/,13											; 		 defb ';;;HOME;AT;LAST.;FOGGY;TAKES;A',13
			fcc	/;/,13																				; 		 defb ';',13
			fcc	/;WELL;EARNED;REST;FROM;HOLIDAYS./,13										; 		 defb ';WELL;EARNED;REST;FROM;HOLIDAYS.',13
			fcc	/;/,13																				; 		 defb ';',13
			fcc	/;;;;TIME;FOR;BIT;OF;TREASURE/,13											; 		 defb ';;;;TIME;FOR;BIT;OF;TREASURE',13
			fcc	/;/,13																				; 		 defb ';',13
			fcc	/;;;;;;;;HUNTING;INSTEAD!!!/,13												; 		 defb ';;;;;;;;HUNTING;INSTEAD!!!',13
			fcc	/;/,13																				; 		 defb ';',13
			fcc	/;/,13																				; 		 defb ';',13
			fcc	/;;;;;;;THANKS;FOR;PLAYING!/,13												; 		 defb ';;;;;;;THANKS;FOR;PLAYING!',13
			fcc	/;/,13																				; 		 defb ';',13
			fcc	/;CREDITS../,13																	; 		 defb ';CREDITS..',13
			fcc	/;/,13																				; 		 defb ';',13
			fcc	/;CODING;AND;GFX;-;JOHN;BLYTHE/,13											; 		 defb ';CODING;AND;GFX;-;JOHN;BLYTHE',13
			fcc	/;ADDITIONAL;CODE;-;ANDY;JOHNS/,13											; 		 defb ';ADDITIONAL;CODE;-;ANDY;JOHNS',13
			fcc	/;/,13																				; 		 defb ';',13
			fcc	/;MANY;THANKS;TO../,13															; 		 defb ';MANY;THANKS;TO..',13
			fcc	/;JONATHAN CAULDWELL;FOR;AGD/,141		; msg #19						; 		 defb ';JONATHAN CAULDWELL;FOR;AGD',141
			fcc	/PRESS;A;KEY/,141								; msg #20						; 		 defb 'PRESS;A;KEY',141
			fcc	"IS;OVER..",141								; msg #21						; 		 defb 'IS;OVER..',141
			fcc	/;;;;;6809;CODE;;PERE;SERRAT/,141		; msg #22
			fcc	/;;;;PM3;GRAPH.;JOSE;LUIS;TUR/,141		; msg #23
numMsg	fcb	24																						; nummsg defb 22
; ------------------------------------------------------------------------------------------------------------------------------------------
	IF	PMODE4														; BLOCKS / TILES
chgFx																	; PMODE4 79 x 8 bytes		; chgfx  equ $
			fcb	0,0,0,0,0,0,0,0																	; 		 defb 0,0,0,0,0,0,0,0
			fcb	12,108,97,128,30,222,222,32													; 		 defb 12,108,97,128,30,222,222,32
			fcb	70,6,102,97,0,51,179,48															; 		 defb 70,6,102,97,0,51,179,48
			fcb	0,8,65,0,16,0,130,32																; 		 defb 0,8,65,0,16,0,130,32
			fcb	126,129,141,141,129,161,129,126												; 		 defb 126,129,141,141,129,161,129,126
			fcb	255,126,189,90,165,66,129,0													; 		 defb 255,126,189,90,165,66,129,0
			fcb	255,126,189,90,165,66,129,0													; 		 defb 255,126,189,90,165,66,129,0
			fcb	255,126,189,90,165,66,129,0													; 		 defb 255,126,189,90,165,66,129,0
			fcb	255,126,189,90,165,66,129,0													; 		 defb 255,126,189,90,165,66,129,0
			fcb	239,239,170,69,170,0,239,0														; 		 defb 239,239,170,69,170,0,239,0
			fcb	248,254,174,87,171,23,139,87													; 		 defb 248,254,174,87,171,23,139,87
			fcb	75,87,75,87,0,87,75,87															; 		 defb 75,87,75,87,0,87,75,87
			fcb	75,87,74,69,34,48,15,0															; 		 defb 75,87,74,69,34,48,15,0
			fcb	126,255,170,85,3,187,56,66														; 		 defb 126,255,170,85,3,187,56,66
			fcb	183,183,0,248,240,0,192,128													; 		 defb 183,183,0,248,240,0,192,128
			fcb	215,215,0,29,13,0,3,1															; 		 defb 215,215,0,29,13,0,3,1
			fcb	12,25,30,76,56,28,14,24															; 		 defb 12,25,30,76,56,28,14,24
			fcb	12,88,48,38,72,68,36,24															; 		 defb 12,88,48,38,72,68,36,24
			fcb	239,239,170,69,170,0,239,0														; 		 defb 239,239,170,69,170,0,239,0
			fcb	0,0,0,0,0,0,0,0																	; 		 defb 0,0,0,0,0,0,0,0
			fcb	181,0,96,6,0,85,170,255															; 		 defb 181,0,96,6,0,85,170,255
			fcb	96,96,96,255,170,0,64,96														; 		 defb 96,96,96,255,170,0,64,96
			fcb	6,6,6,255,170,0,4,6																; 		 defb 6,6,6,255,170,0,4,6
			fcb	132,41,16,90,32,148,1,40														; 		 defb 132,41,16,90,32,148,1,40
			fcb	79,159,0,79,0,159,149,79														; 		 defb 79,159,0,79,0,159,149,79
			fcb	250,253,0,250,0,253,85,250														; 		 defb 250,253,0,250,0,253,85,250
			fcb	126,129,141,141,129,161,129,126												; 		 defb 126,129,141,141,129,161,129,126
			fcb	126,129,141,141,129,161,129,126												; 		 defb 126,129,141,141,129,161,129,126
			fcb	168,130,42,162,136,42,162,42													; 		 defb 168,130,42,162,136,42,162,42
			fcb	168,130,42,162,136,42,162,42													; 		 defb 168,130,42,162,136,42,162,42
			fcb	168,130,42,162,136,42,162,42													; 		 defb 168,130,42,162,136,42,162,42
			fcb	0,0,0,0,66,16,36,255																; 		 defb 0,0,0,0,66,16,36,255
			fcb	219,255,85,170,255,0,30,12														; 		 defb 219,255,85,170,255,0,30,12
			fcb	109,255,85,170,255,0,120,48													; 		 defb 109,255,85,170,255,0,120,48
			fcb	63,64,180,160,128,133,255,0													; 		 defb 63,64,180,160,128,133,255,0
			fcb	252,2,1,5,13,161,255,0															; 		 defb 252,2,1,5,13,161,255,0
			fcb	240,252,87,172,240,44,5,14														; 		 defb 240,252,87,172,240,44,5,14
			fcb	13,63,245,58,15,26,160,112														; 		 defb 13,63,245,58,15,26,160,112
			fcb	0,0,0,0,0,0,0,0																	; 		 defb 0,0,0,0,0,0,0,0
			fcb	0,0,0,0,0,0,0,0																	; 		 defb 0,0,0,0,0,0,0,0
			fcb	0,0,0,0,0,0,0,0																	; 		 defb 0,0,0,0,0,0,0,0
			fcb	0,0,0,0,0,0,0,0																	; 		 defb 0,0,0,0,0,0,0,0
			fcb	254,124,184,80,160,64,128,0													; 		 defb 254,124,184,80,160,64,128,0
			fcb	127,62,29,10,5,2,1,0																; 		 defb 127,62,29,10,5,2,1,0
			fcb	0,0,0,0,0,0,0,0																	; 		 defb 0,0,0,0,0,0,0,0
			fcb	0,0,0,0,32,0,0,0																	; 		 defb 0,0,0,0,32,0,0,0
			fcb	0,0,0,8,0,0,0,0																	; 		 defb 0,0,0,8,0,0,0,0
			fcb	0,0,0,0,0,0,0,0
;;;			fcb	0,0,0,0,0,0,0,0							; 48									
			fcb	000,000,000,254,000,000,000,000		; 48									
			fcb	128,64,160,208,232,244,250,253												; 		 defb 128,64,160,208,232,244,250,253
			fcb	8,0,8,255,128,0,128,0															; 		 defb 8,0,8,255,128,0,128,0
			fcb	1,2,5,11,23,47,95,191															; 		 defb 1,2,5,11,23,47,95,191
			fcb	0,106,64,0,64,0,66,0																; 		 defb 0,106,64,0,64,0,66,0
			fcb	24,24,36,36,102,126,231,255													; 		 defb 24,24,36,36,102,126,231,255
			fcb	0,0,0,0,0,0,0,0																	; 		 defb 0,0,0,0,0,0,0,0
			fcb	54,111,221,221,122,50,1,0														; 		 defb 54,111,221,221,122,50,1,0
			fcb	124,214,191,255,235,213,170,124												; 		 defb 124,214,191,255,235,213,170,124
			fcb	56,254,255,221,243,127,157,98													; 		 defb 56,254,255,221,243,127,157,98
			fcb	0,112,236,222,254,251,223,62													; 		 defb 0,112,236,222,254,251,223,62
			fcb	0,15,63,111,254,249,239,112													; 		 defb 0,15,63,111,254,249,239,112
			fcb	60,78,191,255,245,106,52,24													; 		 defb 60,78,191,255,245,106,52,24
			fcb	8,8,4,8,16,32,16,8																; 		 defb 8,8,4,8,16,32,16,8
			fcb	255,255,255,255,255,255,255,255												; 		 defb 255,255,255,255,255,255,255,255
			fcb	85,171,87,175,95,191,127,255													; 		 defb 85,171,87,175,95,191,127,255
			fcb	1,2,5,10,21,42,85,170															; 		 defb 1,2,5,10,21,42,85,170
			fcb	61,104,208,168,208,128,192,128												; 		 defb 61,104,208,168,208,128,192,128
			fcb	188,22,11,21,11,1,3,1															; 		 defb 188,22,11,21,11,1,3,1
			fcb	255,117,170,16,66,0,0,0															; 		 defb 255,117,170,16,66,0,0,0
;;;			fcb	0,0,0,0,0,0,0,0							; 68									; 		 defb 0,0,0,0,0,0,0,0
			fcb	000,000,000,127,000,000,000,000		; 68									; 		 defb 0,0,0,0,0,0,0,0
			fcb	139,197,227,241,185,221,175,151												; 		 defb 139,197,227,241,185,221,175,151
			fcb	255,250,210,82,64,64,0,0														; 		 defb 255,250,210,82,64,64,0,0
			fcb	0,0,0,0,0,0,76,255																; 		 defb 0,0,0,0,0,0,76,255
			fcb	90,165,219,102,189,102,60,90													; 		 defb 90,165,219,102,189,102,60,90
			fcb	76,246,251,187,95,70,128,0														; 		 defb 76,246,251,187,95,70,128,0
			fcb	14,23,45,44,44,88,224,0															; 		 defb 14,23,45,44,44,88,224,0
			fcb	102,91,164,90,219,25,100,154													; 		 defb 102,91,164,90,219,25,100,154
			fcb	1,131,103,90,38,28,0,0															; 		 defb 1,131,103,90,38,28,0,0
			fcb	176,176,176,176,176,176,176,176												; 		 defb 176,176,176,176,176,176,176,176
			fcb	13,21,13,21,13,21,13,21															; 		 defb 13,21,13,21,13,21,13,21
	ELSE
chgFx																	; PMODE3 79 x 8 bytes		; chgfx  equ $
			fcb 	$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA												; 		 defb 0,0,0,0,0,0,0,0
			fcb 	$0C,$C4,$40,$03,$01,$3C,$14,$40												; 		 defb 12,108,97,128,30,222,222,32
			fcb 	$04,$50,$50,$00,$01,$41,$40,$04												; 		 defb 70,6,102,97,0,51,179,48
			fcb 	$00,$04,$40,$01,$00,$04,$40,$10												; 		 defb 0,8,65,0,16,0,130,32
			fcb 	$96,$69,$65,$69,$69,$69,$69,$96												; 		 defb 126,129,141,141,129,161,129,126
			fcb 	$57,$57,$5F,$57,$7F,$5F,$FF,$7F												; 		 defb 255,126,189,90,165,66,129,0
			fcb 	$55,$56,$5A,$56,$6A,$59,$AA,$55												; 		 defb 255,126,189,90,165,66,129,0
			fcb 	$01,$01,$05,$01,$15,$05,$55,$15												; 		 defb 255,126,189,90,165,66,129,0
			fcb 	$56,$57,$5A,$57,$6A,$5F,$AA,$7F												; 		 defb 255,126,189,90,165,66,129,0
			fcb 	$EF,$EF,$EF,$EF,$EF,$EF,$AA,$EF												; 		 defb 239,239,170,69,170,0,239,0
			fcb 	$FE,$EE,$FB,$FF,$FF,$FF,$BF,$EF												; 		 defb 248,254,174,87,171,23,139,87
			fcb 	$BF,$EF,$BF,$EF,$AA,$AA,$BF,$EF												; 		 defb 75,87,75,87,0,87,75,87
			fcb 	$BF,$EF,$BF,$EF,$BF,$EF,$BA,$BF												; 		 defb 75,87,74,69,34,48,15,0
			fcb 	$BF,$FF,$CC,$33,$00,$05,$45,$40												; 		 defb 126,255,170,85,3,187,56,66
			fcb 	$CF,$45,$00,$FE,$5A,$0A,$EA,$6A												; 		 defb 183,183,0,248,240,0,192,128
			fcb 	$CF,$45,$00,$B3,$91,$A0,$AF,$A9												; 		 defb 215,215,0,29,13,0,3,1
			fcb 	$8A,$8A,$A0,$22,$8A,$A2,$A2,$8A												; 		 defb 12,25,30,76,56,28,14,24
			fcb 	$A2,$8A,$8A,$2E,$26,$28,$88,$82												; 		 defb 12,88,48,38,72,68,36,24
			fcb 	$EF,$EF,$EF,$EF,$EF,$EF,$AA,$EF												; 		 defb 239,239,170,69,170,0,239,0
			fcb 	$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA												; 		 defb 0,0,0,0,0,0,0,0
			fcb 	$DD,$FF,$7F,$F7,$FF,$DD,$77,$55												; 		 defb 181,0,96,6,0,85,170,255
			fcb 	$9A,$9A,$9A,$55,$66,$AA,$9A,$9A												; 		 defb 96,96,96,255,170,0,64,96
			fcb 	$A6,$A6,$A6,$55,$66,$AA,$A6,$A6												; 		 defb 6,6,6,255,170,0,4,6
			fcb 	$FF,$AA,$FF,$AA,$FF,$AA,$FF,$AA												; 		 defb 132,41,16,90,32,148,1,40
			fcb 	$99,$65,$AA,$AA,$65,$65,$99,$99												; 		 defb 79,159,0,79,0,159,149,79
			fcb 	$56,$FF,$AA,$AA,$55,$FF,$99,$FE												; 		 defb 250,253,0,250,0,253,85,250
			fcb 	$D7,$7D,$75,$7D,$7D,$7D,$7D,$D7												; 		 defb 126,129,141,141,129,161,129,126
			fcb 	$96,$69,$75,$69,$7D,$69,$7D,$96												; 		 defb 126,129,141,141,129,161,129,126
			fcb 	$22,$22,$AA,$22,$2A,$22,$A2,$22												; 		 defb 168,130,42,162,136,42,162,42
			fcb 	$77,$77,$FF,$77,$7F,$77,$F7,$77												; 		 defb 168,130,42,162,136,42,162,42
			fcb 	$77,$66,$FF,$66,$7F,$66,$F7,$66												; 		 defb 168,130,42,162,136,42,162,42
			fcb 	$AA,$AA,$AA,$AE,$EA,$BA,$EB,$FF												; 		 defb 0,0,0,0,66,16,36,255
			fcb 	$65,$55,$66,$99,$55,$AA,$96,$A6												; 		 defb 219,255,85,170,255,0,30,12
			fcb 	$59,$55,$66,$99,$55,$AA,$96,$9A												; 		 defb 109,255,85,170,255,0,120,48
			fcb 	$BF,$55,$5F,$55,$5F,$55,$57,$80												; 		 defb 63,64,180,160,128,133,255,0
			fcb 	$FE,$7A,$FF,$5E,$FF,$5E,$FF,$02												; 		 defb 252,2,1,5,13,161,255,0
			fcb 	$5A,$FE,$95,$FE,$5A,$AE,$A6,$AB												; 		 defb 240,252,87,172,240,44,5,14
			fcb 	$A5,$95,$55,$96,$A5,$9A,$9A,$6A												; 		 defb 13,63,245,58,15,26,160,112
			fcb 	$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA												; 		 defb 0,0,0,0,0,0,0,0
			fcb 	$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA												; 		 defb 0,0,0,0,0,0,0,0
			fcb 	$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA												; 		 defb 0,0,0,0,0,0,0,0
			fcb 	$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA												; 		 defb 0,0,0,0,0,0,0,0
			fcb 	$55,$95,$66,$9A,$66,$9A,$6A,$AA												; 		 defb 254,124,184,80,160,64,128,0
			fcb 	$55,$56,$99,$A6,$99,$A6,$A9,$AA												; 		 defb 127,62,29,10,5,2,1,0
			fcb 	$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA												; 		 defb 0,0,0,0,0,0,0,0
			fcb 	$AA,$AA,$AA,$AA,$8A,$AA,$AA,$AA												; 		 defb 0,0,0,0,32,0,0,0
			fcb 	$AA,$AA,$AA,$A6,$AA,$AA,$AA,$AA												; 		 defb 0,0,0,8,0,0,0,0
			fcb 	$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF												; 		 defb 0,0,0,0,0,0,0,0
			fcb 	$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF												; 		 defb 0,0,0,0,0,0,0,0
			fcb 	$EA,$AA,$FA,$EA,$FE,$FA,$FF,$FE												; 		 defb 128,64,160,208,232,244,250,253
			fcb 	$F7,$FF,$F7,$55,$7F,$FF,$7F,$FF												; 		 defb 8,0,8,255,128,0,128,0
			fcb 	$AB,$AA,$AF,$AB,$BF,$AF,$FF,$BF												; 		 defb 1,2,5,11,23,47,95,191
			fcb 	$AA,$BF,$BA,$AA,$BA,$AA,$BA,$AA												; 		 defb 0,106,64,0,64,0,66,0
			fcb 	$BE,$FF,$FF,$D7,$D7,$FF,$FF,$BE												; 		 defb 24,24,36,36,102,126,231,255
			fcb 	$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA												; 		 defb 0,0,0,0,0,0,0,0
			fcb 	$82,$08,$20,$20,$82,$22,$A8,$AA												; 		 defb 54,111,221,221,122,50,1,0
			fcb 	$BE,$EF,$FF,$FF,$EF,$FB,$EF,$BE												; 		 defb 124,214,191,255,235,213,170,124
			fcb 	$5A,$55,$55,$95,$65,$5A,$55,$A5												; 		 defb 56,254,255,221,243,127,157,98
			fcb 	$AA,$5A,$56,$65,$95,$55,$65,$96												; 		 defb 0,112,236,222,254,251,223,62
			fcb 	$A9,$A5,$95,$95,$59,$56,$65,$9A												; 		 defb 0,15,63,111,254,249,239,112
			fcb 	$BE,$EF,$BF,$FB,$EE,$FB,$BE,$BE												; 		 defb 60,78,191,255,245,106,52,24
			fcb 	$8A,$8A,$8A,$A2,$A2,$8A,$8A,$A2												; 		 defb 8,8,4,8,16,32,16,8
			fcb 	$55,$55,$55,$55,$55,$55,$55,$55												; 		 defb 255,255,255,255,255,255,255,255
			fcb 	$66,$99,$65,$99,$65,$95,$65,$95												; 		 defb 85,171,87,175,95,191,127,255
			fcb 	$A9,$A6,$A9,$A6,$99,$A6,$99,$66												; 		 defb 1,2,5,10,21,42,85,170
			fcb 	$BF,$BA,$EE,$FA,$EE,$FA,$EA,$EA												; 		 defb 61,104,208,168,208,128,192,128
			fcb 	$FE,$AE,$BB,$AF,$BB,$AF,$AB,$AB												; 		 defb 188,22,11,21,11,1,3,1
			fcb 	$FF,$BB,$EE,$AB,$BA,$AA,$AA,$AA												; 		 defb 255,117,170,16,66,0,0,0
			fcb 	$55,$55,$55,$55,$55,$55,$55,$55												; 		 defb 0,0,0,0,0,0,0,0
			fcb 	$EE,$67,$B9,$9A,$AE,$E6,$7B,$99												; 		 defb 139,197,227,241,185,221,175,151
			fcb 	$55,$65,$66,$66,$6A,$6A,$AA,$AA												; 		 defb 255,250,210,82,64,64,0,0
			fcb 	$AA,$AA,$AA,$AA,$AA,$AA,$66,$55												; 		 defb 0,0,0,0,0,0,76,255
			fcb 	$82,$28,$96,$55,$BE,$BE,$E9,$96												; 		 defb 90,165,219,102,189,102,60,90
			fcb 	$82,$20,$08,$08,$82,$88,$2A,$AA												; 		 defb 76,246,251,187,95,70,128,0
			fcb 	$A2,$84,$92,$82,$92,$82,$2A,$AA												; 		 defb 14,23,45,44,44,88,224,0
			fcb 	$82,$28,$BE,$FF,$96,$96,$EB,$BE												; 		 defb 102,91,164,90,219,25,100,154
			fcb 	$A8,$A1,$00,$16,$82,$AA,$AA,$AA												; 		 defb 1,131,103,90,38,28,0,0
			fcb 	$77,$5F,$77,$5F,$77,$5F,$77,$5F												; 		 defb 176,176,176,176,176,176,176,176
			fcb 	$FB,$FE,$FB,$FE,$FB,$FE,$FB,$FE												; 		 defb 13,21,13,21,13,21,13,21
	ENDIF
; ------------------------------------------------------------------------------------------------------------------------------------------
													; NEVER USED
;bCol												; 79 x 1 byte										; bcol   equ $
;			fcb	71																						; 		 defb 71
;			fcb	77																						; 		 defb 77
;			fcb	78																						; 		 defb 78
;			fcb	77																						; 		 defb 77
;			fcb	78																						; 		 defb 78
;			fcb	86																						; 		 defb 86
;			fcb	79																						; 		 defb 79
;			fcb	116																					; 		 defb 116
;			fcb	94																						; 		 defb 94
;			fcb	65																						; 		 defb 65
;			fcb	65																						; 		 defb 65
;			fcb	65																						; 		 defb 65
;			fcb	65																						; 		 defb 65
;			fcb	78																						; 		 defb 78
;			fcb	69																						; 		 defb 69
;			fcb	69																						; 		 defb 69
;			fcb	68																						; 		 defb 68
;			fcb	4																						; 		 defb 4
;			fcb	1																						; 		 defb 1
;			fcb	69																						; 		 defb 69
;			fcb	86																						; 		 defb 86
;			fcb	71																						; 		 defb 71
;			fcb	71																						; 		 defb 71
;			fcb	65																						; 		 defb 65
;			fcb	71																						; 		 defb 71
;			fcb	7																						; 		 defb 7
;			fcb	86																						; 		 defb 86
;			fcb	94																						; 		 defb 94
;			fcb	205																					; 		 defb 205
;			fcb	214																					; 		 defb 214
;			fcb	222																					; 		 defb 222
;			fcb	66																						; 		 defb 66
;			fcb	71																						; 		 defb 71
;			fcb	7																						; 		 defb 7
;			fcb	69																						; 		 defb 69
;			fcb	65																						; 		 defb 65
;			fcb	7																						; 		 defb 7
;			fcb	71																						; 		 defb 71
;			fcb	66																						; 		 defb 66
;			fcb	67																						; 		 defb 67
;			fcb	68																						; 		 defb 68
;			fcb	65																						; 		 defb 65
;			fcb	70																						; 		 defb 70
;			fcb	70																						; 		 defb 70
;			fcb	65																						; 		 defb 65
;			fcb	69																						; 		 defb 69
;			fcb	70																						; 		 defb 70
;			fcb	87																						; 		 defb 87
;			fcb	87																						; 		 defb 87
;			fcb	66																						; 		 defb 66
;			fcb	80																						; 		 defb 80
;			fcb	66																						; 		 defb 66
;			fcb	66																						; 		 defb 66
;			fcb	70																						; 		 defb 70
;			fcb	64																						; 		 defb 64
;			fcb	68																						; 		 defb 68
;			fcb	66																						; 		 defb 66
;			fcb	71																						; 		 defb 71
;			fcb	71																						; 		 defb 71
;			fcb	71																						; 		 defb 71
;			fcb	66																						; 		 defb 66
;			fcb	68																						; 		 defb 68
;			fcb	70																						; 		 defb 70
;			fcb	70																						; 		 defb 70
;			fcb	70																						; 		 defb 70
;			fcb	66																						; 		 defb 66
;			fcb	66																						; 		 defb 66
;			fcb	66																						; 		 defb 66
;			fcb	119																					; 		 defb 119
;			fcb	69																						; 		 defb 69
;			fcb	71																						; 		 defb 71
;			fcb	71																						; 		 defb 71
;			fcb	67																						; 		 defb 67
;			fcb	68																						; 		 defb 68
;			fcb	4																						; 		 defb 4
;			fcb	66																						; 		 defb 66
;			fcb	4																						; 		 defb 4
;			fcb	87																						; 		 defb 87
;			fcb	80																						; 		 defb 80
; ------------------------------------------------------------------------------------------------------------------------------------------
													; *** Properties Table (WHAT'S THAT???) ***
bProp												; 79 x 1 byte										; bprop  equ $
			fcb 0																							; 		 defb 0
			fcb 2																							; 		 defb 2
			fcb 2																							; 		 defb 2
			fcb 2																							; 		 defb 2
			fcb 2																							; 		 defb 2
			fcb 2																							; 		 defb 2
			fcb 2																							; 		 defb 2
			fcb 2																							; 		 defb 2
			fcb 2																							; 		 defb 2
			fcb 0																							; 		 defb 0
			fcb 0																							; 		 defb 0
			fcb 0																							; 		 defb 0
			fcb 0																							; 		 defb 0
			fcb 2																							; 		 defb 2
			fcb 0																							; 		 defb 0
			fcb 0																							; 		 defb 0
			fcb 0																							; 		 defb 0
			fcb 0																							; 		 defb 0
			fcb 0																							; 		 defb 0
			fcb 0																							; 		 defb 0
			fcb 5																							; 		 defb 5
			fcb 3																							; 		 defb 3
			fcb 3																							; 		 defb 3
			fcb 2																							; 		 defb 2
			fcb 2																							; 		 defb 2
			fcb 2																							; 		 defb 2
			fcb 2																							; 		 defb 2
			fcb 2																							; 		 defb 2
			fcb 2																							; 		 defb 2
			fcb 2																							; 		 defb 2
			fcb 2																							; 		 defb 2
			fcb 0																							; 		 defb 0
			fcb 2																							; 		 defb 2
			fcb 2																							; 		 defb 2
			fcb 2																							; 		 defb 2
			fcb 2																							; 		 defb 2
			fcb 2																							; 		 defb 2
			fcb 2																							; 		 defb 2
			fcb 0																							; 		 defb 0
			fcb 0																							; 		 defb 0
			fcb 0																							; 		 defb 0
			fcb 0																							; 		 defb 0
			fcb 0																							; 		 defb 0
			fcb 0																							; 		 defb 0
			fcb 2																							; 		 defb 2
			fcb 0																							; 		 defb 0
			fcb 0																							; 		 defb 0
			fcb 0																							; 		 defb 0
			fcb 2																							; 		 defb 2
			fcb 0																							; 		 defb 0
			fcb 2																							; 		 defb 2
			fcb 0																							; 		 defb 0
			fcb 3																							; 		 defb 3
			fcb 0																							; 		 defb 0
			fcb 0																							; 		 defb 0
			fcb 1																							; 		 defb 1
			fcb 2																							; 		 defb 2
			fcb 1																							; 		 defb 1
			fcb 1																							; 		 defb 1
			fcb 1																							; 		 defb 1
			fcb 2																							; 		 defb 2
			fcb 0																							; 		 defb 0
			fcb 0																							; 		 defb 0
			fcb 0																							; 		 defb 0
			fcb 0																							; 		 defb 0
			fcb 2																							; 		 defb 2
			fcb 2																							; 		 defb 2
			fcb 2																							; 		 defb 2
			fcb 2																							; 		 defb 2
			fcb 2																							; 		 defb 2
			fcb 0																							; 		 defb 0
			fcb 0																							; 		 defb 0
			fcb 1																							; 		 defb 1
			fcb 1																							; 		 defb 1
			fcb 0																							; 		 defb 0
			fcb 0																							; 		 defb 0
			fcb 0																							; 		 defb 0
			fcb 0																							; 		 defb 0
			fcb 0																							; 		 defb 0
; ------------------------------------------------------------------------------------------------------------------------------------------
													; SPRITES / FRAMES
	IF PMODE4
sprGfx											; 156 rows x 32 bytes (2x16)					; sprgfx equ $
			fcb 0,0,12,0,23,0,7,192,15,224,30,112,61,168,61,36,125,36,126,32,255,252,198,252,187,4,125,250,125,247,60,15
			fcb 0,0,3,0,5,192,1,240,3,248,7,156,15,106,15,73,31,73,31,136,63,255,49,191,46,193,159,126,223,125,207,3
			fcb 0,0,0,192,1,112,0,124,0,254,1,231,131,218,67,210,71,210,7,226,207,255,204,111,75,176,167,223,119,223,243,192
			fcb 0,0,0,48,0,92,0,31,128,63,192,121,160,246,144,244,145,244,129,248,243,255,243,27,18,236,233,247,221,247,60,240
			fcb 0,0,30,0,7,128,7,192,15,224,31,48,62,212,62,144,126,144,127,16,241,252,238,252,95,4,31,120,15,116,0,12
			fcb 0,0,7,128,1,224,1,240,3,248,7,204,15,181,15,164,31,164,31,196,60,127,59,191,23,193,7,222,3,221,0,3
			fcb 0,0,1,224,0,120,0,124,0,254,1,243,67,237,3,233,7,233,7,241,207,31,206,239,69,240,129,247,64,247,192,0
			fcb 0,0,0,120,0,30,0,31,128,63,192,124,80,251,64,250,65,250,65,252,243,199,243,187,17,124,224,125,208,61,48,0
			fcb 16,0,14,0,7,128,7,192,15,224,31,144,63,104,63,72,127,72,127,136,255,252,252,124,123,132,55,216,7,208,27,192
			fcb 4,0,3,128,1,224,1,240,3,248,7,228,15,218,15,210,31,210,31,226,63,255,63,31,30,225,13,246,1,244,6,240
			fcb 1,0,0,224,0,120,0,124,0,254,1,249,131,246,131,244,135,244,135,248,207,255,207,199,71,184,131,125,0,125,1,188
			fcb 0,64,0,56,0,30,0,31,128,63,64,126,160,253,32,253,33,253,33,254,243,255,243,241,17,238,96,223,64,31,0,111
			fcb 0,0,30,0,7,128,7,192,15,224,31,48,62,212,62,144,126,144,127,16,255,252,241,252,110,4,95,120,31,116,15,12
			fcb 0,0,7,128,1,224,1,240,3,248,7,204,15,181,15,164,31,164,31,196,63,255,60,127,27,129,23,222,7,221,3,195
			fcb 0,0,1,224,0,120,0,124,0,254,1,243,67,237,3,233,7,233,7,241,207,255,207,31,70,224,133,247,65,247,192,240
			fcb 0,0,0,120,0,30,0,31,128,63,192,124,80,251,64,250,65,250,65,252,243,255,243,199,17,184,225,125,208,125,48,60
			fcb 0,0,0,48,0,232,3,224,7,240,14,120,21,188,36,188,36,190,4,126,63,255,63,99,32,221,95,190,239,190,240,60
			fcb 0,0,0,12,0,58,0,248,1,252,3,158,5,111,9,47,137,47,129,31,207,255,207,216,72,55,151,239,187,239,60,15
			fcb 0,0,0,3,128,14,0,62,0,127,128,231,193,91,194,75,226,75,224,71,243,255,51,246,210,13,229,251,238,251,207,3
			fcb 0,0,192,0,160,3,128,15,192,31,224,57,240,86,240,146,248,146,248,17,252,255,140,253,116,131,249,126,251,190,243,192
			fcb 0,0,0,120,1,224,3,224,7,240,12,248,43,124,9,124,9,126,8,254,63,143,63,119,32,250,30,248,46,240,48,0
			fcb 0,0,0,30,0,120,0,248,1,252,3,62,10,223,2,95,130,95,130,63,207,227,207,221,136,62,7,190,11,188,12,0
			fcb 0,0,128,7,0,30,0,62,0,127,128,207,194,183,192,151,224,151,224,143,243,248,115,247,162,15,129,239,2,239,3,0
			fcb 0,0,224,1,128,7,128,15,192,31,224,51,240,173,240,37,248,37,248,35,60,254,220,253,232,131,224,123,192,187,0,192
			fcb 0,8,0,112,1,224,3,224,7,240,9,248,22,252,18,252,18,254,17,254,63,255,62,63,33,222,27,236,11,224,3,216
			fcb 0,2,0,28,0,120,0,248,1,252,2,126,5,191,4,191,132,191,132,127,207,255,207,143,136,119,6,251,2,248,0,246
			fcb 128,0,0,7,0,30,0,62,0,127,128,159,193,111,193,47,225,47,225,31,243,255,243,227,226,29,193,190,0,190,128,61
			fcb 32,0,192,1,128,7,128,15,192,31,224,39,240,91,240,75,248,75,248,71,252,255,252,248,120,135,176,111,128,47,96,15
			fcb 0,0,0,120,1,224,3,224,7,240,12,248,43,124,9,124,9,126,8,254,63,255,63,143,32,118,30,250,46,248,48,240
			fcb 0,0,0,30,0,120,0,248,1,252,3,62,10,223,2,95,130,95,130,63,207,255,207,227,136,29,135,190,11,190,12,60
			fcb 0,0,128,7,0,30,0,62,0,127,128,207,194,183,192,151,224,151,224,143,243,255,243,248,98,7,161,239,130,239,3,15
			fcb 0,0,224,1,128,7,128,15,192,31,224,51,240,173,240,37,248,37,248,35,252,255,60,254,216,129,232,123,224,187,192,195
			fcb 3,192,5,160,14,112,14,240,31,248,31,248,63,252,63,252,63,252,127,254,127,235,23,87,106,173,245,91,247,224,240,0
			fcb 0,240,1,104,3,156,3,188,7,254,7,254,15,255,15,255,15,255,159,255,223,250,197,213,90,171,253,86,61,248,60,0
			fcb 0,60,0,90,0,231,0,239,129,255,129,255,195,255,195,255,195,255,231,255,183,254,113,117,214,170,191,85,15,126,15,0
			fcb 0,15,128,22,192,57,192,59,224,127,224,127,240,255,240,255,240,255,249,255,173,255,92,93,181,170,111,213,131,223,3,192
			fcb 3,192,5,160,13,112,12,240,31,248,31,248,63,252,63,252,63,252,127,254,111,238,151,215,234,173,245,91,103,231,0,0
			fcb 0,240,1,104,3,92,3,60,7,254,7,254,15,255,15,255,15,255,159,255,155,251,229,245,122,171,253,86,217,249,0,0
			fcb 0,60,0,90,0,215,0,207,129,255,129,255,195,255,195,255,195,255,231,255,230,254,121,125,222,170,191,85,118,126,0,0
			fcb 0,15,128,22,192,53,192,51,224,127,224,127,240,255,240,255,240,255,249,255,185,191,94,95,183,170,111,213,157,159,0,0
			fcb 3,192,5,160,14,112,14,240,31,248,31,248,63,252,63,252,63,252,127,254,239,254,213,216,170,166,213,79,7,239,0,15
			fcb 0,240,1,104,3,156,3,188,7,254,7,254,15,255,15,255,15,255,159,255,187,255,53,118,170,169,245,83,193,251,192,3
			fcb 0,60,0,90,0,231,0,239,129,255,129,255,195,255,195,255,195,255,231,255,238,255,141,93,106,170,253,84,240,126,240,0
			fcb 0,15,128,22,192,57,192,59,224,127,224,127,240,255,240,255,240,255,249,255,251,191,99,87,154,170,63,85,188,31,60,0
			fcb 3,192,5,160,14,176,15,48,31,248,31,248,63,252,63,252,63,252,127,254,111,238,151,215,234,173,245,91,103,231,0,0
			fcb 0,240,1,104,3,172,3,204,7,254,7,254,15,255,15,255,15,255,159,255,155,251,229,245,122,171,253,86,217,249,0,0
			fcb 0,60,0,90,0,235,0,243,129,255,129,255,195,255,195,255,195,255,231,255,230,254,121,125,222,170,191,85,118,126,0,0
			fcb 0,15,128,22,192,58,192,60,224,127,224,127,240,255,240,255,240,255,249,255,185,191,94,95,183,170,111,213,157,159,0,0
			fcb 102,102,255,255,128,1,179,205,189,189,191,253,183,237,179,205,179,205,179,205,191,253,191,253,166,101,128,1,255,255,102,102
			fcb 153,153,255,255,96,0,108,243,111,111,111,255,109,251,108,243,108,243,108,243,111,255,111,255,105,153,96,0,255,255,153,153
			fcb 102,102,255,255,24,0,219,60,219,219,219,255,219,126,219,60,219,60,219,60,219,255,219,255,90,102,24,0,255,255,102,102
			fcb 153,153,255,255,6,0,54,207,246,246,246,255,182,223,54,207,54,207,54,207,246,255,246,255,150,153,6,0,255,255,153,153
			fcb 102,102,255,255,128,1,191,253,179,205,189,189,191,253,183,237,179,205,179,205,191,253,166,101,160,5,128,1,255,255,102,102
			fcb 153,153,255,255,96,0,111,255,108,243,111,111,111,255,109,251,108,243,108,243,111,255,105,153,104,1,96,0,255,255,153,153
			fcb 102,102,255,255,24,0,219,255,219,60,219,219,219,255,219,126,219,60,219,60,219,255,90,102,90,0,24,0,255,255,102,102
			fcb 153,153,255,255,6,0,246,255,54,207,246,246,246,255,182,223,54,207,54,207,246,255,150,153,22,128,6,0,255,255,153,153
			fcb 102,102,255,255,128,1,191,253,183,237,187,221,189,189,167,229,187,221,191,253,182,109,160,5,160,5,128,1,255,255,102,102
			fcb 153,153,255,255,96,0,111,255,109,251,110,247,111,111,105,249,110,247,111,255,109,155,104,1,104,1,96,0,255,255,153,153
			fcb 102,102,255,255,24,0,219,255,219,126,219,189,219,219,90,126,219,189,219,255,219,102,90,0,90,0,24,0,255,255,102,102
			fcb 153,153,255,255,6,0,246,255,182,223,118,239,246,246,150,159,118,239,246,255,182,217,22,128,22,128,6,0,255,255,153,153
			fcb 48,0,48,0,31,251,56,31,55,236,47,244,47,244,47,52,46,84,46,20,47,52,47,244,240,12,223,248,0,12,0,12
			fcb 12,0,12,0,199,254,206,7,13,251,11,253,11,253,11,205,11,149,11,133,11,205,11,253,60,3,55,254,0,3,0,3
			fcb 3,0,3,0,177,255,243,129,195,126,66,255,66,255,66,243,66,229,66,225,66,243,66,255,207,0,141,255,192,0,192,0
			fcb 0,192,0,192,236,127,124,224,176,223,208,191,208,191,208,188,80,185,80,184,208,188,208,191,51,192,227,127,48,0,48,0
			fcb 3,0,3,0,31,248,56,28,55,236,47,244,47,247,46,119,236,180,236,52,46,116,47,244,48,12,31,248,0,192,0,192
			fcb 0,192,0,192,7,254,14,7,13,251,11,253,203,253,203,157,59,45,59,13,11,157,11,253,12,3,7,254,0,48,0,48
			fcb 0,48,0,48,129,255,195,129,195,126,66,255,114,255,114,231,78,203,78,195,66,231,66,255,195,0,129,255,0,12,0,12
			fcb 0,12,0,12,224,127,112,224,176,223,208,191,220,191,220,185,211,178,211,176,208,185,208,191,48,192,224,127,0,3,0,3
			fcb 0,48,0,48,31,248,56,28,247,236,239,244,47,244,44,244,41,116,40,116,44,247,47,247,48,12,31,248,12,0,12,0
			fcb 0,12,0,12,7,254,14,7,61,251,59,253,11,253,11,61,10,93,10,29,203,61,203,253,12,3,7,254,3,0,3,0
			fcb 0,3,0,3,129,255,195,129,207,126,78,255,66,255,66,207,66,151,66,135,114,207,114,255,195,0,129,255,0,192,0,192
			fcb 192,0,192,0,224,127,112,224,179,223,211,191,208,191,208,179,208,165,208,161,220,179,220,191,48,192,224,127,0,48,0,48
			fcb 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,85,85,255,255
			fcb 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,85,85,255,255
			fcb 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,85,85,255,255
			fcb 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,85,85,255,255
			fcb 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,85,85,0,0,0,0,170,170,255,255
			fcb 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,85,85,0,0,0,0,170,170,255,255
			fcb 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,85,85,0,0,0,0,170,170,255,255
			fcb 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,85,85,0,0,0,0,170,170,255,255
			fcb 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,170,170,0,0,0,0,0,0,0,0,0,0,85,85,255,255
			fcb 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,170,170,0,0,0,0,0,0,0,0,0,0,85,85,255,255
			fcb 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,170,170,0,0,0,0,0,0,0,0,0,0,85,85,255,255
			fcb 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,170,170,0,0,0,0,0,0,0,0,0,0,85,85,255,255
			fcb 0,0,0,0,0,0,0,0,0,0,85,85,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,170,170,255,255
			fcb 0,0,0,0,0,0,0,0,0,0,85,85,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,170,170,255,255
			fcb 0,0,0,0,0,0,0,0,0,0,85,85,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,170,170,255,255
			fcb 0,0,0,0,0,0,0,0,0,0,85,85,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,170,170,255,255
			fcb 0,0,56,28,103,230,92,58,91,218,58,92,58,92,60,60,63,252,56,28,59,220,91,218,92,58,103,230,56,28,0,0
			fcb 0,0,14,7,153,249,151,14,150,246,14,151,14,151,15,15,15,255,14,7,14,247,150,246,151,14,153,249,14,7,0,0
			fcb 0,0,195,129,102,126,165,195,165,189,195,165,195,165,195,195,195,255,195,129,195,189,165,189,165,195,102,126,195,129,0,0
			fcb 0,0,112,224,153,159,233,112,105,111,112,233,112,233,240,240,240,255,112,224,112,239,105,111,233,112,153,159,112,224,0,0
			fcb 6,0,24,0,7,224,28,58,27,218,59,29,59,29,60,60,63,252,191,252,184,28,91,216,92,56,7,224,0,24,0,96
			fcb 1,128,6,0,1,248,135,14,134,246,78,199,78,199,15,15,15,255,47,255,46,7,22,246,23,14,1,248,0,6,0,24
			fcb 0,96,1,128,0,126,161,195,161,189,211,177,211,177,195,195,195,255,203,255,203,129,133,189,133,195,0,126,128,1,0,6
			fcb 0,24,0,96,128,31,232,112,104,111,116,236,116,236,240,240,240,255,242,255,114,224,97,111,225,112,128,31,96,0,128,1
			fcb 1,224,0,0,7,224,28,56,27,216,184,220,184,220,188,61,191,253,63,253,59,221,28,56,31,248,7,224,0,0,7,128
			fcb 0,120,0,0,1,248,7,14,6,246,46,55,46,55,111,15,111,255,79,255,78,247,7,14,7,254,1,248,0,0,1,224
			fcb 0,30,0,0,0,126,129,195,129,189,203,141,203,141,219,195,219,255,211,255,211,189,129,195,129,255,0,126,0,0,0,120
			fcb 128,7,0,0,128,31,224,112,96,111,114,227,114,227,246,240,246,255,244,255,116,239,224,112,224,127,128,31,0,0,0,30
			fcb 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,255,255
			fcb 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,255,255
			fcb 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,255,255
			fcb 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,255,255
			fcb 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,127,222,255,255
			fcb 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,159,247,255,255
			fcb 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,231,253,255,255
			fcb 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,121,255,255,255
			fcb 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,63,128,95,222,255,255
			fcb 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,15,224,151,247,255,255
			fcb 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,248,229,253,255,255
			fcb 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,254,121,127,255,255
			fcb 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,63,128,79,204,127,222,255,255
			fcb 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,15,224,19,243,159,247,255,255
			fcb 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,248,196,252,231,253,255,255
			fcb 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,254,49,63,121,255,255,255
			fcb 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,14,0,63,128,79,204,79,214,63,158,255,255
			fcb 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,128,15,224,19,243,147,245,143,231,255,255
			fcb 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,224,3,248,196,252,100,253,227,249,255,255
			fcb 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,56,0,254,49,63,89,63,120,254,255,255
			fcb 0,0,0,0,0,0,0,0,0,0,0,0,128,0,0,128,17,128,145,32,72,64,72,204,109,214,127,222,63,140,255,255
			fcb 0,0,0,0,0,0,0,0,0,0,0,0,32,0,0,32,4,96,36,72,18,16,18,51,155,117,159,247,15,227,255,255
			fcb 0,0,0,0,0,0,0,0,0,0,0,0,8,0,0,8,1,24,9,18,4,132,196,140,102,221,231,253,195,248,255,255
			fcb 0,0,0,0,0,0,0,0,0,0,0,0,2,0,0,2,0,70,130,68,1,33,49,35,89,183,121,255,48,254,255,255
			fcb 0,0,0,0,128,0,0,0,0,64,0,64,0,0,0,12,0,4,0,33,0,17,0,19,128,90,113,158,63,140,255,255
			fcb 0,0,0,0,32,0,0,0,0,16,0,16,0,0,0,3,0,1,64,8,64,4,192,4,160,22,156,103,15,227,255,255
			fcb 0,0,0,0,8,0,0,0,0,4,0,4,0,0,192,0,64,0,16,2,16,1,48,1,168,5,231,25,195,248,255,255
			fcb 0,0,0,0,2,0,0,0,0,1,0,1,0,0,48,0,16,0,132,0,68,0,76,0,106,1,121,198,48,254,255,255
			fcb 0,0,0,0,0,0,0,0,0,4,0,8,0,0,0,0,0,0,0,0,0,0,0,0,0,32,0,19,127,222,255,255
			fcb 0,0,0,0,0,0,0,0,0,1,0,2,0,0,0,0,0,0,0,0,0,0,0,0,0,8,192,4,159,247,255,255
			fcb 0,0,0,0,0,0,0,0,64,0,128,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,48,1,231,253,255,255
			fcb 0,0,0,0,0,0,0,0,16,0,32,0,0,0,0,0,0,0,0,0,0,0,0,0,128,0,76,0,121,255,255,255
			fcb 127,254,192,3,160,153,176,77,152,37,172,1,150,65,171,33,181,145,186,201,189,101,158,177,175,89,183,173,192,3,127,254
			fcb 159,255,240,0,104,38,108,19,102,9,107,0,101,144,106,200,109,100,110,178,111,89,103,172,107,214,109,235,240,0,159,255
			fcb 231,255,60,0,154,9,219,4,89,130,26,192,25,100,26,178,27,89,155,172,91,214,25,235,154,245,219,122,60,0,231,255
			fcb 249,255,15,0,102,130,54,193,150,96,6,176,6,89,134,172,70,214,38,235,150,245,198,122,102,189,182,222,15,0,249,255
			fcb 0,0,0,0,0,8,0,0,0,8,0,4,0,8,0,4,0,2,0,5,0,2,0,33,0,66,0,36,0,66,0,36
			fcb 0,0,0,0,0,2,0,0,0,2,0,1,0,2,0,1,128,0,64,1,128,0,64,8,128,16,0,9,128,16,0,9
			fcb 0,0,0,0,128,0,0,0,128,0,64,0,128,0,64,0,32,0,80,0,32,0,16,2,32,4,64,2,32,4,64,2
			fcb 0,0,0,0,32,0,0,0,32,0,16,0,32,0,16,0,8,0,20,0,8,0,132,0,8,1,144,0,8,1,144,0
			fcb 0,0,0,0,0,2,0,0,0,2,0,4,0,2,0,4,0,10,0,84,0,8,0,84,0,136,0,68,0,34,0,68
			fcb 0,0,0,0,128,0,0,0,128,0,0,1,128,0,0,1,128,2,0,21,0,2,0,21,0,34,0,17,128,8,0,17
			fcb 0,0,0,0,32,0,0,0,32,0,64,0,32,0,64,0,160,0,64,5,128,0,64,5,128,8,64,4,32,2,64,4
			fcb 0,0,0,0,8,0,0,0,8,0,16,0,8,0,16,0,40,0,80,1,32,0,80,1,32,2,16,1,136,0,16,1
			fcb 3,128,3,128,1,128,3,128,3,128,3,128,3,0,3,0,3,128,3,128,3,128,3,128,1,128,3,128,3,128,3,128
			fcb 0,224,0,224,0,96,0,224,0,224,0,224,0,192,0,192,0,224,0,224,0,224,0,224,0,96,0,224,0,224,0,224
			fcb 0,56,0,56,0,24,0,56,0,56,0,56,0,48,0,48,0,56,0,56,0,56,0,56,0,24,0,56,0,56,0,56
			fcb 0,14,0,14,0,6,0,14,0,14,0,14,0,12,0,12,0,14,0,14,0,14,0,14,0,6,0,14,0,14,0,14
			fcb 7,224,7,224,7,224,3,224,3,224,7,224,7,224,7,224,7,224,7,224,7,224,7,224,7,224,7,192,7,224,7,224
			fcb 1,248,1,248,1,248,0,248,0,248,1,248,1,248,1,248,1,248,1,248,1,248,1,248,1,248,1,240,1,248,1,248
			fcb 0,126,0,126,0,126,0,62,0,62,0,126,0,126,0,126,0,126,0,126,0,126,0,126,0,126,0,124,0,126,0,126
			fcb 128,31,128,31,128,31,128,15,128,15,128,31,128,31,128,31,128,31,128,31,128,31,128,31,128,31,0,31,128,31,128,31
			fcb 31,248,31,240,31,240,31,248,31,248,15,248,31,248,31,248,31,248,31,240,31,248,31,248,15,248,15,248,31,248,31,248
			fcb 7,254,7,252,7,252,7,254,7,254,3,254,7,254,7,254,7,254,7,252,7,254,7,254,3,254,3,254,7,254,7,254
			fcb 129,255,1,255,1,255,129,255,129,255,128,255,129,255,129,255,129,255,1,255,129,255,129,255,128,255,128,255,129,255,129,255
			fcb 224,127,192,127,192,127,224,127,224,127,224,63,224,127,224,127,224,127,192,127,224,127,224,127,224,63,224,63,224,127,224,127
	ELSE
sprGfx	fcb	$00,$00,$0F,$00,$33,$C0,$03,$F0,$0F,$FC,$0C,$CC,$3F,$33,$3F,$33,$3F,$33,$FC,$03,$FF,$FF,$CC,$FF,$23,$0F,$A8,$FC,$A8,$F2,$28,$0A
			fcb	$00,$00,$03,$C0,$0C,$F0,$00,$FC,$03,$FF,$03,$33,$CF,$CC,$CF,$CC,$CF,$CC,$FF,$00,$FF,$FF,$F3,$3F,$C8,$C3,$2A,$3F,$AA,$3C,$8A,$02
			fcb	$00,$00,$00,$F0,$03,$3C,$00,$3F,$C0,$FF,$C0,$CC,$33,$F3,$33,$F3,$33,$F3,$3F,$C0,$FF,$FF,$FC,$CF,$F2,$30,$CA,$8F,$2A,$8F,$A2,$80
			fcb	$00,$00,$00,$3C,$00,$CF,$C0,$0F,$F0,$3F,$30,$33,$CC,$FC,$CC,$FC,$CC,$FC,$0F,$F0,$FF,$FF,$FF,$33,$3C,$8C,$F2,$A3,$CA,$A3,$28,$A0
			fcb	$00,$00,$3C,$00,$03,$00,$03,$C0,$0F,$F0,$0F,$30,$3F,$CC,$3F,$CC,$3F,$CC,$FF,$C0,$F3,$FC,$C8,$FC,$2A,$0C,$2A,$3C,$0A,$30,$00,$08
			fcb	$00,$00,$0F,$00,$00,$C0,$00,$F0,$03,$FC,$03,$CC,$0F,$F3,$0F,$F3,$0F,$F3,$3F,$F0,$3C,$FF,$32,$3F,$0A,$83,$0A,$8F,$02,$8C,$00,$02
			fcb	$00,$00,$03,$C0,$00,$30,$00,$3C,$00,$FF,$00,$F3,$C3,$FC,$C3,$FC,$C3,$FC,$0F,$FC,$CF,$3F,$CC,$8F,$C2,$A0,$C2,$A3,$00,$A3,$80,$00
			fcb	$00,$00,$00,$F0,$00,$0C,$00,$0F,$C0,$3F,$C0,$3C,$30,$FF,$30,$FF,$30,$FF,$03,$FF,$F3,$CF,$F3,$23,$30,$A8,$F0,$A8,$C0,$28,$20,$00
			fcb	$30,$00,$0C,$00,$03,$00,$03,$C0,$0F,$F0,$0F,$30,$3F,$CC,$3F,$CC,$3F,$CC,$3F,$C0,$FF,$FC,$FC,$3C,$32,$8C,$32,$8C,$02,$A0,$08,$A0
			fcb	$0C,$00,$03,$00,$00,$C0,$00,$F0,$03,$FC,$03,$CC,$0F,$F3,$0F,$F3,$0F,$F3,$0F,$F0,$3F,$FF,$3F,$0F,$0C,$A3,$0C,$A3,$00,$A8,$02,$28
			fcb	$03,$00,$00,$C0,$00,$30,$00,$3C,$00,$FF,$00,$F3,$C3,$FC,$C3,$FC,$C3,$FC,$03,$FC,$CF,$FF,$CF,$C3,$C3,$28,$C3,$28,$00,$2A,$00,$8A
			fcb	$00,$C0,$00,$30,$00,$0C,$00,$0F,$C0,$3F,$C0,$3C,$30,$FF,$30,$FF,$30,$FF,$00,$FF,$F3,$FF,$F3,$F0,$30,$CA,$30,$CA,$80,$0A,$80,$22
			fcb	$00,$00,$3C,$00,$03,$C0,$03,$F0,$0F,$FC,$0C,$FC,$3F,$30,$3F,$30,$3F,$30,$3C,$00,$FF,$FC,$F3,$FC,$C8,$0C,$0A,$30,$2A,$08,$2A,$28
			fcb	$00,$00,$0F,$00,$00,$F0,$00,$FC,$03,$FF,$03,$3F,$0F,$CC,$0F,$CC,$0F,$CC,$0F,$00,$3F,$FF,$3C,$FF,$32,$03,$02,$8C,$0A,$82,$0A,$8A
			fcb	$00,$00,$03,$C0,$00,$3C,$00,$3F,$C0,$FF,$C0,$CF,$03,$F3,$03,$F3,$03,$F3,$03,$C0,$CF,$FF,$CF,$3F,$CC,$80,$00,$A3,$82,$A0,$82,$A2
			fcb	$00,$00,$00,$F0,$00,$0F,$C0,$0F,$F0,$3F,$F0,$33,$C0,$FC,$C0,$FC,$C0,$FC,$00,$F0,$F3,$FF,$F3,$CF,$33,$20,$C0,$28,$20,$A8,$A0,$A8
			fcb	$00,$00,$00,$F0,$03,$CC,$0F,$C0,$3F,$F0,$33,$30,$CC,$FC,$CC,$FC,$CC,$FC,$C0,$3F,$FF,$FF,$FF,$33,$F0,$C8,$3F,$2A,$8F,$2A,$A0,$28
			fcb	$00,$00,$00,$3C,$00,$F3,$03,$F0,$0F,$FC,$0C,$CC,$33,$3F,$33,$3F,$33,$3F,$F0,$0F,$FF,$FF,$FF,$CC,$3C,$32,$8F,$CA,$A3,$CA,$28,$0A
			fcb	$00,$00,$00,$0F,$C0,$3C,$00,$FC,$03,$FF,$03,$33,$CC,$CF,$CC,$CF,$CC,$CF,$FC,$03,$FF,$FF,$3F,$F3,$8F,$0C,$A3,$F2,$A8,$F2,$8A,$02
			fcb	$00,$00,$C0,$03,$30,$0F,$00,$3F,$C0,$FF,$C0,$CC,$F3,$33,$F3,$33,$F3,$33,$FF,$00,$FF,$FF,$CF,$FC,$23,$C3,$A8,$FC,$AA,$3C,$A2,$80
			fcb	$00,$00,$00,$3C,$00,$C0,$03,$C0,$0F,$F0,$0C,$F0,$33,$FC,$33,$FC,$33,$FC,$03,$FF,$3F,$CF,$3F,$23,$30,$A8,$3C,$A8,$0C,$A0,$20,$00
			fcb	$00,$00,$00,$0F,$00,$30,$00,$F0,$03,$FC,$03,$3C,$0C,$FF,$0C,$FF,$0C,$FF,$C0,$FF,$CF,$F3,$CF,$C8,$0C,$2A,$0F,$2A,$03,$28,$08,$00
			fcb	$00,$00,$C0,$03,$00,$0C,$00,$3C,$00,$FF,$00,$CF,$C3,$3F,$C3,$3F,$C3,$3F,$F0,$3F,$F3,$FC,$33,$F2,$83,$0A,$83,$CA,$00,$CA,$02,$00
			fcb	$00,$00,$F0,$00,$00,$03,$00,$0F,$C0,$3F,$C0,$33,$F0,$CF,$F0,$CF,$F0,$CF,$FC,$0F,$3C,$FF,$8C,$FC,$A0,$C2,$A0,$F2,$80,$32,$00,$80
			fcb	$00,$0C,$00,$30,$00,$C0,$03,$C0,$0F,$F0,$0C,$F0,$33,$FC,$33,$FC,$33,$FC,$03,$FC,$3F,$FF,$3C,$3F,$32,$8C,$32,$8C,$0A,$80,$0A,$20
			fcb	$00,$03,$00,$0C,$00,$30,$00,$F0,$03,$FC,$03,$3C,$0C,$FF,$0C,$FF,$0C,$FF,$00,$FF,$CF,$FF,$CF,$0F,$0C,$A3,$0C,$A3,$02,$A0,$02,$88
			fcb	$C0,$00,$00,$03,$00,$0C,$00,$3C,$00,$FF,$00,$CF,$C3,$3F,$C3,$3F,$C3,$3F,$C0,$3F,$F3,$FF,$F3,$C3,$C3,$28,$C3,$28,$00,$A8,$00,$A2
			fcb	$30,$00,$C0,$00,$00,$03,$00,$0F,$C0,$3F,$C0,$33,$F0,$CF,$F0,$CF,$F0,$CF,$F0,$0F,$FC,$FF,$FC,$F0,$30,$CA,$30,$CA,$00,$2A,$80,$28
			fcb	$00,$00,$00,$3C,$03,$C0,$0F,$C0,$3F,$F0,$3F,$30,$0C,$FC,$0C,$FC,$0C,$FC,$00,$3C,$3F,$FF,$3F,$CF,$30,$23,$0C,$A0,$20,$A8,$28,$A8
			fcb	$00,$00,$00,$0F,$00,$F0,$03,$F0,$0F,$FC,$0F,$CC,$03,$3F,$03,$3F,$03,$3F,$00,$0F,$CF,$FF,$CF,$F3,$CC,$08,$03,$28,$08,$2A,$0A,$2A
			fcb	$00,$00,$C0,$03,$00,$3C,$00,$FC,$03,$FF,$03,$F3,$C0,$CF,$C0,$CF,$C0,$CF,$C0,$03,$F3,$FF,$F3,$FC,$33,$02,$00,$CA,$82,$0A,$82,$8A
			fcb	$00,$00,$F0,$00,$00,$0F,$00,$3F,$C0,$FF,$C0,$FC,$F0,$33,$F0,$33,$F0,$33,$F0,$00,$FC,$FF,$3C,$FF,$8C,$C0,$80,$32,$A0,$82,$A0,$A2
			fcb	$03,$F0,$03,$00,$0C,$30,$0C,$F0,$0F,$F0,$0F,$F0,$3F,$FC,$3F,$FC,$3F,$FC,$FF,$FF,$FC,$CF,$F3,$3F,$0C,$CC,$A3,$32,$A3,$C0,$A0,$00
			fcb	$00,$FC,$00,$C0,$03,$0C,$03,$3C,$03,$FC,$03,$FC,$0F,$FF,$0F,$FF,$0F,$FF,$FF,$FF,$FF,$33,$FC,$CF,$03,$33,$A8,$CC,$28,$F0,$28,$00
			fcb	$00,$3F,$00,$30,$00,$C3,$00,$CF,$00,$FF,$00,$FF,$C3,$FF,$C3,$FF,$C3,$FF,$FF,$FF,$FF,$CC,$FF,$33,$C0,$CC,$2A,$33,$0A,$3C,$0A,$00
			fcb	$C0,$0F,$00,$0C,$C0,$30,$C0,$33,$C0,$3F,$C0,$3F,$F0,$FF,$F0,$FF,$F0,$FF,$FF,$FF,$3F,$F3,$FF,$CC,$30,$33,$CA,$8C,$02,$8F,$02,$80
			fcb	$03,$C0,$03,$00,$0C,$30,$0C,$F0,$0F,$F0,$0F,$F0,$3F,$FC,$3F,$FC,$3F,$FC,$FF,$FF,$F3,$33,$0C,$CC,$A3,$32,$A0,$CA,$A3,$CA,$00,$00
			fcb	$00,$F0,$00,$C0,$03,$0C,$03,$3C,$03,$FC,$03,$FC,$0F,$FF,$0F,$FF,$0F,$FF,$FF,$FF,$FC,$CC,$03,$33,$A8,$CC,$A8,$32,$A8,$F2,$00,$00
			fcb	$00,$3C,$00,$30,$00,$C3,$00,$CF,$00,$FF,$00,$FF,$C3,$FF,$C3,$FF,$C3,$FF,$FF,$FF,$3F,$33,$C0,$CC,$2A,$33,$AA,$0C,$AA,$3C,$00,$00
			fcb	$00,$0F,$00,$0C,$C0,$30,$C0,$33,$C0,$3F,$C0,$3F,$F0,$FF,$F0,$FF,$F0,$FF,$FF,$FF,$CF,$CC,$30,$33,$CA,$8C,$2A,$83,$2A,$8F,$00,$00
			fcb	$03,$C0,$00,$C0,$0C,$30,$0F,$30,$0F,$F0,$0F,$F0,$3F,$FC,$3F,$FC,$3F,$FC,$FF,$FF,$F3,$3F,$FC,$CF,$33,$30,$8C,$CA,$03,$CA,$00,$0A
			fcb	$00,$F0,$00,$30,$03,$0C,$03,$CC,$03,$FC,$03,$FC,$0F,$FF,$0F,$FF,$0F,$FF,$FF,$FF,$FC,$CF,$FF,$33,$0C,$CC,$A3,$32,$80,$F2,$80,$02
			fcb	$00,$3C,$00,$0C,$00,$C3,$00,$F3,$00,$FF,$00,$FF,$C3,$FF,$C3,$FF,$C3,$FF,$FF,$FF,$FF,$33,$FF,$CC,$03,$33,$A8,$CC,$A0,$3C,$A0,$00
			fcb	$00,$0F,$00,$03,$C0,$30,$C0,$3C,$C0,$3F,$C0,$3F,$F0,$FF,$F0,$FF,$F0,$FF,$FF,$FF,$FF,$CC,$3F,$F3,$C0,$CC,$2A,$33,$28,$0F,$28,$00
			fcb	$0F,$C0,$00,$C0,$0C,$30,$0F,$30,$0F,$F0,$0F,$F0,$3F,$FC,$3F,$FC,$3F,$FC,$FF,$FF,$CC,$CF,$33,$30,$8C,$CA,$A3,$0A,$A3,$CA,$00,$00
			fcb	$03,$F0,$00,$30,$03,$0C,$03,$CC,$03,$FC,$03,$FC,$0F,$FF,$0F,$FF,$0F,$FF,$FF,$FF,$F3,$33,$0C,$CC,$A3,$32,$A8,$C2,$A8,$F2,$00,$00
			fcb	$00,$FC,$00,$0C,$00,$C3,$00,$F3,$00,$FF,$00,$FF,$C3,$FF,$C3,$FF,$C3,$FF,$FF,$FF,$FC,$CC,$03,$33,$A8,$CC,$AA,$30,$AA,$3C,$00,$00
			fcb	$00,$3F,$00,$03,$C0,$30,$C0,$3C,$C0,$3F,$C0,$3F,$F0,$FF,$F0,$FF,$F0,$FF,$FF,$FF,$3F,$33,$C0,$CC,$2A,$33,$2A,$8C,$2A,$8F,$00,$00
			fcb	$44,$11,$55,$55,$40,$01,$6A,$A9,$62,$89,$68,$29,$66,$99,$66,$99,$6E,$B9,$6E,$B9,$6A,$A9,$6A,$A9,$62,$89,$40,$01,$55,$55,$44,$11
			fcb	$51,$04,$55,$55,$50,$00,$5A,$AA,$58,$A2,$5A,$0A,$59,$A6,$59,$A6,$5B,$AE,$5B,$AE,$5A,$AA,$5A,$AA,$58,$A2,$50,$00,$55,$55,$51,$04
			fcb	$14,$41,$55,$55,$14,$00,$96,$AA,$96,$28,$96,$82,$96,$69,$96,$69,$96,$EB,$96,$EB,$96,$AA,$96,$AA,$96,$28,$14,$00,$55,$55,$14,$41
			fcb	$45,$10,$55,$55,$05,$00,$A5,$AA,$25,$8A,$A5,$A0,$65,$9A,$65,$9A,$E5,$BA,$E5,$BA,$A5,$AA,$A5,$AA,$25,$8A,$05,$00,$55,$55,$45,$10
			fcb	$44,$11,$55,$55,$40,$01,$6A,$A9,$6A,$A9,$62,$89,$68,$29,$6A,$A9,$66,$99,$6E,$B9,$6A,$A9,$62,$89,$60,$09,$40,$01,$55,$55,$44,$11
			fcb	$51,$04,$55,$55,$50,$00,$5A,$AA,$5A,$AA,$58,$A2,$5A,$0A,$5A,$AA,$59,$A6,$5B,$AE,$5A,$AA,$58,$A2,$58,$02,$50,$00,$55,$55,$51,$04
			fcb	$14,$41,$55,$55,$14,$00,$96,$AA,$96,$AA,$96,$28,$96,$82,$96,$AA,$96,$69,$96,$EB,$96,$AA,$96,$28,$96,$00,$14,$00,$55,$55,$14,$41
			fcb	$45,$10,$55,$55,$05,$00,$A5,$AA,$A5,$AA,$25,$8A,$A5,$A0,$A5,$AA,$65,$9A,$E5,$BA,$A5,$AA,$25,$8A,$25,$80,$05,$00,$55,$55,$45,$10
			fcb	$44,$11,$55,$55,$40,$01,$6A,$A9,$6A,$A9,$6A,$A9,$62,$89,$68,$29,$62,$89,$6A,$A9,$62,$89,$60,$09,$60,$09,$40,$01,$55,$55,$44,$11
			fcb	$51,$04,$55,$55,$50,$00,$5A,$AA,$5A,$AA,$5A,$AA,$58,$A2,$5A,$0A,$58,$A2,$5A,$AA,$58,$A2,$58,$02,$58,$02,$50,$00,$55,$55,$51,$04
			fcb	$14,$41,$55,$55,$14,$00,$96,$AA,$96,$AA,$96,$AA,$96,$28,$96,$82,$96,$28,$96,$AA,$96,$28,$96,$00,$96,$00,$14,$00,$55,$55,$14,$41
			fcb	$45,$10,$55,$55,$05,$00,$A5,$AA,$A5,$AA,$A5,$AA,$25,$8A,$A5,$A0,$25,$8A,$A5,$AA,$25,$8A,$25,$80,$25,$80,$05,$00,$55,$55,$45,$10
			fcb	$30,$00,$10,$00,$0F,$F3,$16,$95,$3A,$AC,$1A,$A4,$3A,$5C,$1A,$74,$3A,$5C,$1A,$54,$3A,$5C,$12,$84,$FC,$3C,$45,$50,$00,$0C,$00,$04
			fcb	$0C,$00,$04,$00,$C3,$FC,$45,$A5,$0E,$AB,$06,$A9,$0E,$97,$06,$9D,$0E,$97,$06,$95,$0E,$97,$04,$A1,$3F,$0F,$11,$54,$00,$03,$00,$01
			fcb	$03,$00,$01,$00,$30,$FF,$51,$69,$C3,$AA,$41,$AA,$C3,$A5,$41,$A7,$C3,$A5,$41,$A5,$C3,$A5,$41,$28,$CF,$C3,$04,$55,$C0,$00,$40,$00
			fcb	$00,$C0,$00,$40,$CC,$3F,$54,$5A,$B0,$EA,$90,$6A,$70,$E9,$D0,$69,$70,$E9,$50,$69,$70,$E9,$10,$4A,$F3,$F0,$41,$15,$30,$00,$10,$00
			fcb	$03,$00,$01,$00,$0F,$F0,$16,$94,$3A,$AC,$1A,$A4,$39,$6F,$1B,$E5,$F9,$6C,$59,$64,$39,$6C,$12,$84,$3C,$3C,$05,$50,$00,$C0,$00,$40
			fcb	$00,$C0,$00,$40,$03,$FC,$05,$A5,$0E,$AB,$06,$A9,$CE,$5B,$46,$F9,$3E,$5B,$16,$59,$0E,$5B,$04,$A1,$0F,$0F,$01,$54,$00,$30,$00,$10
			fcb	$00,$30,$00,$10,$00,$FF,$41,$69,$C3,$AA,$41,$AA,$F3,$96,$51,$BE,$CF,$96,$45,$96,$C3,$96,$41,$28,$C3,$C3,$00,$55,$00,$0C,$00,$04
			fcb	$00,$0C,$00,$04,$C0,$3F,$50,$5A,$B0,$EA,$90,$6A,$BC,$E5,$94,$6F,$B3,$E5,$91,$65,$B0,$E5,$10,$4A,$F0,$F0,$40,$15,$00,$03,$00,$01
			fcb	$00,$30,$00,$10,$0F,$F0,$16,$94,$FA,$AC,$5A,$A4,$35,$AC,$1D,$A4,$35,$AC,$15,$A4,$35,$AF,$12,$85,$3C,$3C,$05,$50,$0C,$00,$04,$00
			fcb	$00,$0C,$00,$04,$03,$FC,$05,$A5,$3E,$AB,$16,$A9,$0D,$6B,$07,$69,$0D,$6B,$05,$69,$CD,$6B,$44,$A1,$0F,$0F,$01,$54,$03,$00,$01,$00
			fcb	$00,$03,$00,$01,$00,$FF,$41,$69,$CF,$AA,$45,$AA,$C3,$5A,$41,$DA,$C3,$5A,$41,$5A,$F3,$5A,$51,$28,$C3,$C3,$00,$55,$00,$C0,$00,$40
			fcb	$C0,$00,$40,$00,$C0,$3F,$50,$5A,$B3,$EA,$91,$6A,$B0,$D6,$90,$76,$B0,$D6,$90,$56,$BC,$D6,$14,$4A,$F0,$F0,$40,$15,$00,$30,$00,$10
			fcb	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$33,$33,$FF,$FF
			fcb	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$CC,$CC,$FF,$FF
			fcb	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$33,$33,$FF,$FF
			fcb	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$CC,$CC,$FF,$FF
			fcb	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$33,$33,$00,$00,$00,$00,$CC,$CC,$FF,$FF
			fcb	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$CC,$CC,$00,$00,$00,$00,$33,$33,$FF,$FF
			fcb	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$33,$33,$00,$00,$00,$00,$CC,$CC,$FF,$FF
			fcb	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$CC,$CC,$00,$00,$00,$00,$33,$33,$FF,$FF
			fcb	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$CC,$CC,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$33,$33,$FF,$FF
			fcb	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$33,$33,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$CC,$CC,$FF,$FF
			fcb	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$CC,$CC,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$33,$33,$FF,$FF
			fcb	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$33,$33,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$CC,$CC,$FF,$FF
			fcb	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$33,$33,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$CC,$CC,$FF,$FF
			fcb	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$CC,$CC,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$33,$33,$FF,$FF
			fcb	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$33,$33,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$CC,$CC,$FF,$FF
			fcb	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$CC,$CC,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$33,$33,$FF,$FF
			fcb	$20,$08,$20,$08,$A1,$4A,$87,$D2,$8F,$F2,$1F,$34,$1F,$34,$10,$04,$15,$54,$1F,$F4,$13,$C4,$87,$D2,$84,$12,$A1,$4A,$20,$08,$20,$08
			fcb	$08,$02,$08,$02,$A8,$52,$A1,$F4,$A3,$FC,$07,$CD,$07,$CD,$04,$01,$05,$55,$07,$FD,$04,$F1,$A1,$F4,$A1,$04,$A8,$52,$08,$02,$08,$02
			fcb	$82,$00,$82,$00,$AA,$14,$28,$7D,$28,$FF,$41,$F3,$41,$F3,$41,$00,$41,$55,$41,$FF,$41,$3C,$28,$7D,$28,$41,$AA,$14,$82,$00,$82,$00
			fcb	$20,$80,$20,$80,$2A,$85,$4A,$1F,$CA,$3F,$D0,$7C,$D0,$7C,$10,$40,$50,$55,$D0,$7F,$10,$4F,$4A,$1F,$4A,$10,$2A,$85,$20,$80,$20,$80
			fcb	$0A,$00,$28,$00,$21,$40,$07,$D2,$0F,$F2,$1C,$F6,$1C,$F6,$10,$06,$95,$54,$9F,$F4,$93,$C4,$84,$10,$84,$10,$01,$48,$00,$28,$00,$A0
			fcb	$02,$80,$0A,$00,$08,$50,$81,$F4,$83,$FC,$87,$3D,$87,$3D,$84,$01,$25,$55,$27,$FD,$24,$F1,$21,$04,$21,$04,$00,$52,$00,$0A,$00,$28
			fcb	$00,$A0,$02,$80,$02,$14,$20,$7D,$20,$FF,$61,$CF,$61,$CF,$61,$00,$49,$55,$49,$FF,$49,$3C,$08,$41,$08,$41,$80,$14,$80,$02,$00,$0A
			fcb	$00,$28,$00,$A0,$00,$85,$48,$1F,$C8,$3F,$D8,$73,$D8,$73,$18,$40,$52,$55,$D2,$7F,$12,$4F,$42,$10,$42,$10,$20,$05,$A0,$00,$80,$02
			fcb	$00,$A0,$00,$A8,$01,$40,$07,$D0,$8F,$F0,$9F,$34,$9F,$34,$90,$06,$95,$56,$1F,$F6,$10,$06,$04,$12,$04,$10,$01,$40,$2A,$00,$0A,$00
			fcb	$00,$28,$00,$2A,$00,$50,$01,$F4,$23,$FC,$27,$CD,$27,$CD,$A4,$01,$A5,$55,$87,$FD,$84,$01,$81,$04,$01,$04,$00,$50,$0A,$80,$02,$80
			fcb	$00,$0A,$80,$0A,$00,$14,$00,$7D,$08,$FF,$49,$F3,$49,$F3,$69,$00,$69,$55,$61,$FF,$61,$00,$20,$41,$00,$41,$00,$14,$02,$A0,$00,$A0
			fcb	$80,$02,$A0,$02,$00,$05,$40,$1F,$C2,$3F,$D2,$7C,$D2,$7C,$1A,$40,$5A,$55,$D8,$7F,$18,$40,$48,$10,$40,$10,$00,$05,$00,$A8,$00,$28
			fcb	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$55,$55
			fcb	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$55,$55
			fcb	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$55,$55
			fcb	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$55,$55
			fcb	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$15,$44,$55,$55
			fcb	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$05,$51,$55,$55
			fcb	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$41,$54,$55,$55
			fcb	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$10,$55,$55,$55
			fcb	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$05,$00,$1D,$44,$55,$55
			fcb	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$40,$07,$51,$55,$55
			fcb	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$50,$41,$D4,$55,$55
			fcb	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$14,$10,$75,$55,$55
			fcb	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$05,$00,$1D,$44,$15,$44,$55,$55
			fcb	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$40,$07,$51,$05,$51,$55,$55
			fcb	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$50,$41,$D4,$41,$54,$55,$55
			fcb	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$14,$10,$75,$10,$55,$55,$55
			fcb	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$05,$00,$1D,$40,$1D,$44,$15,$5D,$15,$55,$55,$55
			fcb	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$40,$07,$50,$07,$51,$45,$57,$45,$55,$55,$55
			fcb	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$50,$01,$D4,$41,$D4,$D1,$55,$51,$55,$55,$55
			fcb	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$14,$00,$75,$10,$75,$74,$55,$54,$55,$55,$55
			fcb	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$40,$00,$00,$40,$11,$00,$11,$10,$44,$40,$04,$44,$04,$51,$15,$15,$15,$04,$55,$55
			fcb	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$10,$00,$00,$10,$04,$40,$04,$44,$11,$10,$01,$11,$41,$14,$45,$45,$05,$41,$55,$55
			fcb	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$04,$00,$00,$04,$01,$10,$01,$11,$04,$44,$40,$44,$10,$45,$51,$51,$41,$50,$55,$55
			fcb	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$00,$00,$01,$00,$44,$40,$44,$01,$11,$10,$11,$44,$11,$54,$54,$10,$54,$55,$55
			fcb	$00,$00,$00,$00,$40,$00,$00,$00,$00,$40,$00,$40,$00,$00,$00,$04,$00,$04,$00,$41,$00,$11,$00,$11,$40,$14,$11,$14,$15,$04,$55,$55
			fcb	$00,$00,$00,$00,$10,$00,$00,$00,$00,$10,$00,$10,$00,$00,$00,$01,$00,$01,$40,$10,$40,$04,$40,$04,$10,$05,$04,$45,$05,$41,$55,$55
			fcb	$00,$00,$00,$00,$04,$00,$00,$00,$00,$04,$00,$04,$00,$00,$40,$00,$40,$00,$10,$04,$10,$01,$10,$01,$44,$01,$41,$11,$41,$50,$55,$55
			fcb	$00,$00,$00,$00,$01,$00,$00,$00,$00,$01,$00,$01,$00,$00,$10,$00,$10,$00,$04,$01,$44,$00,$44,$00,$51,$00,$50,$44,$10,$54,$55,$55
			fcb	$00,$00,$00,$00,$00,$00,$00,$01,$00,$00,$00,$10,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$40,$00,$00,$00,$11,$15,$44,$55,$55
			fcb	$00,$00,$00,$00,$00,$00,$40,$00,$00,$00,$00,$04,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$10,$00,$00,$40,$04,$05,$51,$55,$55
			fcb	$00,$00,$00,$00,$00,$00,$10,$00,$00,$00,$00,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$04,$00,$00,$10,$01,$41,$54,$55,$55
			fcb	$00,$00,$00,$00,$00,$00,$04,$00,$00,$00,$40,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$00,$00,$44,$00,$10,$55,$55,$55
			fcb	$3F,$FC,$C0,$03,$F3,$03,$C0,$C3,$F0,$33,$FC,$CF,$CC,$33,$FF,$0F,$CF,$C3,$F3,$F3,$CC,$FF,$F3,$3F,$CC,$CF,$F3,$33,$C0,$03,$3F,$FC
			fcb	$0F,$FF,$F0,$00,$FC,$C0,$F0,$30,$FC,$0C,$FF,$33,$F3,$0C,$FF,$C3,$F3,$F0,$FC,$FC,$F3,$3F,$FC,$CF,$F3,$33,$FC,$CC,$F0,$00,$0F,$FF
			fcb	$C3,$FF,$3C,$00,$3F,$30,$3C,$0C,$3F,$03,$FF,$CC,$3C,$C3,$FF,$F0,$3C,$FC,$3F,$3F,$FC,$CF,$FF,$33,$FC,$CC,$3F,$33,$3C,$00,$C3,$FF
			fcb	$F0,$FF,$0F,$00,$0F,$CC,$0F,$03,$CF,$C0,$3F,$F3,$CF,$30,$3F,$FC,$0F,$3F,$CF,$CF,$FF,$33,$FF,$CC,$3F,$33,$CF,$CC,$0F,$00,$F0,$FF
			fcb	$00,$00,$00,$00,$00,$30,$00,$0C,$00,$0C,$00,$30,$00,$30,$00,$0C,$00,$03,$00,$03,$00,$03,$00,$CC,$03,$0C,$00,$CC,$03,$03,$03,$0C
			fcb	$00,$00,$00,$00,$00,$0C,$00,$03,$00,$03,$00,$0C,$00,$0C,$00,$03,$C0,$00,$C0,$00,$C0,$00,$00,$33,$00,$C3,$00,$33,$C0,$C0,$00,$C3
			fcb	$00,$00,$00,$00,$00,$03,$C0,$00,$C0,$00,$00,$03,$00,$03,$C0,$00,$30,$00,$30,$00,$30,$00,$C0,$0C,$C0,$30,$C0,$0C,$30,$30,$C0,$30
			fcb	$00,$00,$00,$00,$C0,$00,$30,$00,$30,$00,$C0,$00,$C0,$00,$30,$00,$0C,$00,$0C,$00,$0C,$00,$30,$03,$30,$0C,$30,$03,$0C,$0C,$30,$0C
			fcb	$00,$0C,$00,$00,$00,$0C,$00,$03,$00,$03,$00,$0C,$00,$0C,$03,$30,$00,$30,$03,$0C,$00,$CC,$03,$0C,$03,$03,$00,$C3,$00,$C3,$03,$0C
			fcb	$00,$03,$00,$00,$00,$03,$C0,$00,$C0,$00,$00,$03,$00,$03,$00,$CC,$00,$0C,$00,$C3,$00,$33,$00,$C3,$C0,$C0,$C0,$30,$C0,$30,$00,$C3
			fcb	$C0,$00,$00,$00,$C0,$00,$30,$00,$30,$00,$C0,$00,$C0,$00,$00,$33,$00,$03,$C0,$30,$C0,$0C,$C0,$30,$30,$30,$30,$0C,$30,$0C,$C0,$30
			fcb	$30,$00,$00,$00,$30,$00,$0C,$00,$0C,$00,$30,$00,$30,$00,$C0,$0C,$C0,$00,$30,$0C,$30,$03,$30,$0C,$0C,$0C,$0C,$03,$0C,$03,$30,$0C
			fcb	$01,$40,$01,$40,$00,$40,$01,$40,$01,$40,$01,$40,$01,$00,$01,$00,$01,$40,$01,$40,$01,$40,$01,$40,$00,$40,$01,$40,$01,$40,$01,$40
			fcb	$00,$50,$00,$50,$00,$10,$00,$50,$00,$50,$00,$50,$00,$40,$00,$40,$00,$50,$00,$50,$00,$50,$00,$50,$00,$10,$00,$50,$00,$50,$00,$50
			fcb	$00,$14,$00,$14,$00,$04,$00,$14,$00,$14,$00,$14,$00,$10,$00,$10,$00,$14,$00,$14,$00,$14,$00,$14,$00,$04,$00,$14,$00,$14,$00,$14
			fcb	$00,$05,$00,$05,$00,$01,$00,$05,$00,$05,$00,$05,$00,$04,$00,$04,$00,$05,$00,$05,$00,$05,$00,$05,$00,$01,$00,$05,$00,$05,$00,$05
			fcb	$05,$50,$05,$50,$05,$50,$01,$50,$01,$50,$05,$50,$05,$50,$05,$50,$05,$50,$05,$50,$05,$50,$05,$50,$05,$50,$05,$40,$05,$50,$05,$50
			fcb	$01,$54,$01,$54,$01,$54,$00,$54,$00,$54,$01,$54,$01,$54,$01,$54,$01,$54,$01,$54,$01,$54,$01,$54,$01,$54,$01,$50,$01,$54,$01,$54
			fcb	$00,$55,$00,$55,$00,$55,$00,$15,$00,$15,$00,$55,$00,$55,$00,$55,$00,$55,$00,$55,$00,$55,$00,$55,$00,$55,$00,$54,$00,$55,$00,$55
			fcb	$40,$15,$40,$15,$40,$15,$40,$05,$40,$05,$40,$15,$40,$15,$40,$15,$40,$15,$40,$15,$40,$15,$40,$15,$40,$15,$00,$15,$40,$15,$40,$15
			fcb	$15,$54,$15,$50,$15,$50,$15,$54,$15,$54,$05,$54,$15,$54,$15,$54,$15,$54,$15,$50,$15,$54,$15,$54,$05,$54,$05,$54,$15,$54,$15,$54
			fcb	$05,$55,$05,$54,$05,$54,$05,$55,$05,$55,$01,$55,$05,$55,$05,$55,$05,$55,$05,$54,$05,$55,$05,$55,$01,$55,$01,$55,$05,$55,$05,$55
			fcb	$41,$55,$01,$55,$01,$55,$41,$55,$41,$55,$40,$55,$41,$55,$41,$55,$41,$55,$01,$55,$41,$55,$41,$55,$40,$55,$40,$55,$41,$55,$41,$55
			fcb	$50,$55,$40,$55,$40,$55,$50,$55,$50,$55,$50,$15,$50,$55,$50,$55,$50,$55,$40,$55,$50,$55,$50,$55,$50,$15,$50,$15,$50,$55,$50,$55
	ENDIF
; ------------------------------------------------------------------------------------------------------------------------------------------
frmLst											; FRAME list										; frmlst equ $
			fcb	0,4																					; 		 defb 0,4
			fcb	4,4																					; 		 defb 4,4
			fcb	8,4																					; 		 defb 8,4
			fcb	12,3																					; 		 defb 12,3
			fcb	15,3																					; 		 defb 15,3
			fcb	18,4																					; 		 defb 18,4
			fcb	22,3																					; 		 defb 22,3
			fcb	25,8																					; 		 defb 25,8
			fcb	33,1																					; 		 defb 33,1
			fcb	34,2																					; 		 defb 34,2
			fcb	36,3,39,0																			; 		 defb 36,3,39,0
; ------------------------------------------------------------------------------------------------------------------------------------------
													; 28 words and then 28 compressed SCREENS	; scdat  equ $
													; SCREEN #01
scDat		fdb	425,471,436,372,323,381,312,298,276,343,255,305,230,299,292,268,350,320,349,203,222,352,366,303,202,225
			fdb	236,382
			fcb	2,2,1,1,1,3,1,3,3,2,255,1,4,2,2,1,1,6,2,1,1,1,2,1,3,3,2,1,14,16,16,15,1
			fcb	255,3,4,1,14,16,16,0,16,0,16,255,0,5,15,1,2,8,3,2,0,17,16,0,15,2,3,1,14,16,0,17,16
			fcb	74,16,0,75,255,0,6,16,15,1,3,0,0,0,17,0,0,15,1,14,0,75,0,0,16,0,17,255,0,7,74,16,76
			fcb	2,2,255,0,7,16,255,0,5,17,255,0,10,17,0,1,3,255,13,4,0,0,0,16,76,255,0,17,1,1,1,14,255,0,4
			fcb	74,16,255,0,18,2,1,1,255,0,6,17,255,0,8,13,13,255,0,7,4,24,25,1,255,0,8,13,13,13,21,22,0,0
			fcb	2,1,16,255,0,7,28,28,1,255,0,8,17,0,0,21,22,0,0,1,3,2,0,0,0,19,19,0,0,28,28,1,13,13,13
			fcb	255,0,8,21,22,0,0,1,3,1,0,0,0,13,13,13,4,24,25,3,8,1,1,13,13,255,0,6,21,22,0,0,2
			fcb	3,1,255,0,5,16,15,7,3,2,14,17,16,255,0,8,21,22,0,13,1,3,1,255,0,5,17,0,15,1,1,0,0
			fcb	17,255,0,5,255,13,6,2,1,3,2,255,0,8,1,1,255,0,8,15,1,2,5,1,2,1,3,1,14,255,0,8,1
			fcb	2,255,0,10,6,1,24,25,18,6,18,9,10,255,0,7,2,1,255,0,5,13,13,13,6,0,15,2,77,78,1,14,0,0
			fcb	11,255,0,4,19,19,0,1,1,255,0,4,13,7,2,1,13,54,54,2,77,78,2,18,10,0,11,255,0,4,19,19,13
			fcb	1,1,0,13,13,13,1,2,3,3,2,54,54,2,24,25,1,0,11,0,11,255,0,4,13,13,5,3,1,13,1,2,1
			fcb	3,3,3,2,2,0,0,1,77,78,1,0,11,0,11,0,0,13,13,1,3,3,1
													; SCREEN #02
			fcb	255,3,5,1,3,1,1,17,0,0,1,77,78,2,0,11,0,11,0,0,6,1,1,8,255,3,4,1,23,23,3,3,3
			fcb	2,16,76,17,2,24,25,1,0,12,18,11,0,0,0,2,1,3,23,23,1,3,3,3,23,23,23,3,1,16,75,1,3
			fcb	12,10,1,0,0,0,11,0,0,0,2,3,23,23,0,1,2,1,1,23,0,23,1,3,1,16,2,3,3,11,14,0,0,0
			fcb	11,0,0,0,1,3,23,255,0,4,15,1,2,23,23,23,3,1,2,2,3,1,11,255,0,4,11,13,13,13,2,3,23,23
			fcb	255,0,4,17,1,3,3,23,2,3,3,1,3,1,12,9,9,9,18,13,2,1,1,3,23,23,255,0,6,15,1,255,3,6
			fcb	7,2,255,0,5,1,1,3,3,23,0,0,23,255,0,6,19,19,3,3,3,1,1,1,14,255,0,5,2,3,3,23,0
			fcb	54,54,255,0,9,1,1,1,14,17,16,76,255,0,5,1,3,23,0,23,54,54,23,0,255,13,5,8,1,1,0,16,0,0
			fcb	16,255,0,6,2,3,23,0,0,23,23,3,23,1,2,2,2,1,1,2,0,0,16,0,0,17,255,0,5,17,1,1,23,23,23
			fcb	3,3,1,3,3,2,1,1,14,16,16,76,0,17,255,0,6,13,13,13,1,3,3,23,3,1,255,3,4,1,1,14,74
			fcb	16,75,255,0,9,15,1,2,1,3,1,3,1,1,2,1,2,3,6,1,0,0,17,255,0,4,13,13,13,255,0,4,11
			fcb	7,1,2,1,1,0,17,11,0,0,1,2,14,255,0,7,2,1,1,255,0,4,12,9,26,24,25,26,9,18,11,18,9
			fcb	255,0,8,13,13,1,5,2,13,17,255,0,5,29,29,0,0,0,11,255,0,9,17,2,1,2,3,3,1,13,13,19,19
			fcb	0,0,29,29,0,0,0,11,255,0,8,13,13,1,255,3,5,2,1,13,13,13,26,24,25,26,255,13,11,2,1,1,255,3,6
			fcb	7,255,1,4,2,2,255,1,5,2,1,2,2,1,2,1,1,3,3,6,255,3,6,2,255,3,4,1,3,3,3,2,1
			fcb	3
													; SCREEN #03
			fcb	255,0,5,23,3,3,2,1,1,21,22,1,1,2,1,1,21,22,1,1,1,2,3,23,5,23,255,0,4,23,23,3,1
			fcb	14,0,0,21,22,15,14,16,15,1,21,22,17,16,15,1,1,3,23,3,255,0,4,23,3,3,1,0,0,0,21,22,0
			fcb	74,16,0,2,21,22,0,16,76,15,2,1,3,1,255,0,5,23,3,2,0,0,0,21,22,0,0,17,0,1,21,22,74
			fcb	16,0,0,16,15,1,2,255,0,4,23,23,1,14,0,0,0,21,22,255,0,4,8,21,22,0,17,0,0,17,0,16,255,0,5
			fcb	23,3,1,75,0,0,0,21,22,255,0,4,2,21,22,255,0,6,75,255,0,4,23,3,3,2,1,0,0,0,21,22,255,0,4
			fcb	1,21,22,255,0,12,23,3,1,14,0,0,0,21,22,255,0,4,1,13,13,17,255,0,11,23,3,1,17,0,0,0,21
			fcb	22,255,0,5,2,1,13,13,255,0,9,23,23,3,8,1,13,21,22,13,13,255,0,5,16,1,1,2,255,13,6,0,0,0
			fcb	23,3,3,3,2,1,21,22,16,76,255,0,5,16,15,1,7,1,2,1,1,2,1,255,0,4,23,3,1,1,14,21,22
			fcb	17,255,0,6,17,0,0,1,3,3,1,3,3,3,255,0,4,23,3,1,14,0,21,22,255,0,10,15,1,1,23,23,23
			fcb	3,0,0,0,23,3,3,2,0,0,21,22,255,0,12,15,5,3,1,3,255,0,4,23,3,1,17,0,21,22,255,0,13
			fcb	15,1,1,1,255,0,4,23,3,1,16,0,21,22,255,0,21,23,3,1,2,0,21,22,0,38,38,255,0,4,38,38,255,0,11
			fcb	23,23,3,7,1,17,21,22,31,38,38,31,0,0,0,38,38,31,31,255,0,9,23,3,23,3,1,13,13,13,255,20,4
			fcb	13,13,13,255,20,4,255,13,6,255,0,4,23,23,3,3,1,2,255,1,5,2,1,1,8,255,1,4,2,7,1,2,1
													; SCREEN #04
			fcb	23,3,1,1,3,1,3,3,1,2,2,1,1,2,1,1,7,1,1,255,3,4,1,2,1,1,3,23,1,1,16,1,3,3
			fcb	1,1,14,0,16,0,0,16,76,0,0,0,1,2,1,8,1,14,15,2,1,3,2,14,16,15,2,1,14,0,0,74,16
			fcb	0,0,17,255,0,4,16,15,1,17,16,76,0,15,1,1,1,0,16,76,16,255,0,5,75,255,0,7,17,0,1,0,17
			fcb	255,0,4,1,14,74,16,0,17,255,0,15,1,255,0,6,1,0,0,17,255,0,17,2,1,21,22,13,13,13,1,255,0,13
			fcb	13,13,13,255,0,6,21,22,15,2,3,2,255,0,13,7,1,1,255,0,6,21,22,0,1,7,1,255,0,6,13,13,13
			fcb	255,0,4,1,3,1,255,0,6,21,22,0,15,1,1,255,0,13,1,3,8,255,0,6,21,22,0,0,1,1,13,13,255,0,11
			fcb	2,3,1,255,0,6,21,22,0,0,1,1,14,255,0,12,1,3,1,255,0,8,13,13,1,2,255,0,13,1,1,1,255,0,9
			fcb	15,2,7,255,13,6,255,0,7,1,2,1,13,13,255,0,8,1,1,17,6,0,0,6,255,0,8,1,3,2,14,255,0,9
			fcb	1,1,13,255,0,9,13,13,13,1,3,1,255,0,7,13,13,13,2,3,8,13,255,0,10,15,8,1,1,255,0,9,15
			fcb	1,23,3,1,13,17,255,0,9,1,3,2,17,255,0,8,17,1,0,23,3,1,255,13,4,255,0,5,17,1,3,1,16
			fcb	0,0,0,17,255,13,5,1,0,23,23,3,1,5,1,2,13,13,13,21,22,13,1,23,3,13,21,22,13,13,255,1,4
			fcb	2,1
													; SCREEN #05
			fcb	255,0,7,3,1,21,22,1,3,23,255,0,21,3,1,21,22,1,3,23,255,0,20,23,3,1,21,0,2,3,3,23,255,0,18
			fcb	23,3,1,14,0,0,15,1,2,1,3,23,23,255,0,14,23,3,1,1,255,0,4,74,16,15,2,1,7,3,3,23,255,0,8
			fcb	23,23,3,2,1,2,14,255,0,5,16,76,0,15,1,2,1,1,3,23,23,0,23,0,0,3,1,1,2,14,16,0,0,0
			fcb	19,19,0,0,17,255,0,4,16,15,1,2,1,1,3,3,23,23,1,14,0,17,0,17,0,0,0,13,13,255,0,7,17
			fcb	0,0,0,15,1,1,2,2,1,255,0,42,13,13,255,0,12,255,13,8,17,255,0,19,3,5,1,1,2,1,1,2,13,13
			fcb	255,0,18,23,255,3,7,5,2,13,13,13,0,0,0,21,22,255,13,10,255,0,4,23,0,0,23,23,3,3,3,2,0,0,0
			fcb	21,22,255,1,5,2,1,1,2,1,255,0,9,23,23,3,1,0,0,0,21,22,2,3,3,3,23,3,3,23,23,3,255,0,10
			fcb	23,3,1,0,0,0,21,22,1,3,23,23,0,0,23,0,0,23,255,0,11,3,2,13,13,0,21,22,1,8,23,255,0,8
			fcb	54,54,255,0,7,23,3,1,14,0,0,21,22,1,3,255,0,9,54,54,255,0,8,3,1,0,0,0,21,22,2,3,23
			fcb	255,0,18,3,1,21,22,13,13,13,1,3,255,0,8
													; SCREEN #06
			fcb	255,0,10,23,3,1,21,22,1,1,1,3,3,23,23,0,0,3,3,23,3,255,0,11,3,1,21,22,0,15,255,1,5
			fcb	8,255,1,5,18,9,9,10,255,0,7,23,1,21,22,0,0,0,16,17,255,0,4,16,76,255,0,5,11,255,0,7,23
			fcb	1,21,22,0,0,0,17,255,0,5,17,255,0,6,11,255,0,8,1,21,22,255,0,16,11,255,0,7,23,1,13,13,19,19
			fcb	17,255,0,7,17,255,0,5,11,255,0,7,23,3,1,1,255,13,6,0,255,13,6,0,0,0,11,255,0,9,23,3,1,1
			fcb	7,1,1,16,0,15,1,1,3,3,1,0,0,0,12,255,9,5,10,255,0,6,23,23,3,1,17,0,75,1,3,255,23,4
			fcb	255,0,8,11,0,0,23,255,0,5,1,17,40,39,16,17,1,23,0,0,23,23,0,23,0,0,23,23,3,11,24,25,1
			fcb	3,0,23,0,23,1,16,40,40,16,16,1,0,0,0,255,3,4,2,1,1,3,1,12,77,78,15,1,3,0,0,0,3
			fcb	1,13,13,1,1,3,0,0,0,1,2,1,1,14,16,16,1,14,17,24,25,0,16,1,255,0,4,23,3,3,23,23,255,0,5
			fcb	16,0,0,74,16,17,0,0,0,38,38,0,17,1,23,255,0,12,18,17,18,10,0,17,255,0,4,38,38,0,0,2,23
			fcb	255,0,15,11,255,0,6,34,35,0,0,1,23,255,0,15,11,0,0,0,19,19,37,32,33,36,0,7,255,0,13,255,13,14
			fcb	23,23,255,0,9,54,54,0,2,1,1,3,3,1,5,2,1,3,1,1,3,0,23,255,0,10,54,54,0,23,23,3,3
			fcb	23,0,23,23,3,23,23,0,23,255,0,15
													; SCREEN #07
			fcb	0,0,0,23,3,1,0,0,45,255,0,7,8,255,5,5,8,255,0,8,3,1,14,255,0,12,43,6,42,255,0,6,45
			fcb	0,0,0,3,1,75,255,0,4,46,255,0,8,5,0,46,255,0,10,8,1,255,0,25,23,3,1,19,19,255,0,11,5
			fcb	255,0,8,23,23,0,23,3,1,255,5,4,8,0,46,255,0,15,3,3,23,3,1,14,0,0,0,43,5,255,0,8,7
			fcb	255,0,8,255,1,4,14,0,0,0,45,0,5,255,0,18,16,15,14,0,0,0,46,0,0,5,255,0,18,17,255,0,8
			fcb	5,5,7,255,0,13,46,255,0,11,5,42,255,0,26,5,45,255,0,7,7,5,5,5,255,0,5,255,13,4,5,5,7
			fcb	0,0,0,7,255,0,5,7,5,5,42,0,43,7,255,0,5,1,2,1,255,0,17,41,19,8,8,255,0,4,3,7,1
			fcb	255,0,17,41,41,7,42,255,0,4,23,3,3,13,0,0,7,5,0,5,0,5,0,5,0,5,0,5,0,5,0,5,5
			fcb	0,0,0,17,0,0,23,3,1,0,0,38,38,255,0,12,38,38,0,0,17,1,1,2,0,0,3,2,31,31,38,38,255,31,12
			fcb	38,38,31,31,2,2,7,3,0,3,3,1,255,20,20,1,3,23,23,0,23,3,1,1,1,2,1,2,1,1,2,255,1,4
			fcb	2,1,1,5,1,1,1,2,1,3,23,0
													; SCREEN #08
			fcb	3,23,3,23,23,3,3,23,23,3,23,255,0,8,23,3,3,23,23,3,8,3,23,1,1,2,2,1,8,1,1,1,2
			fcb	1,3,23,255,0,4,23,3,255,1,4,2,1,1,2,1,0,16,0,17,0,0,0,16,76,0,15,1,3,255,0,4,3
			fcb	2,14,16,0,0,74,16,17,15,1,0,17,255,0,5,17,0,0,0,15,1,23,0,0,0,1,14,0,75,0,0,0,17
			fcb	0,0,1,255,0,11,17,1,3,23,0,23,1,0,40,40,255,0,7,17,255,0,8,38,0,13,1,23,0,0,0,1,17
			fcb	255,0,7,17,0,255,13,5,0,0,255,13,4,1,3,255,0,4,23,1,13,13,0,0,255,13,5,1,1,2,1,1,0,0
			fcb	2,1,3,1,3,23,255,0,5,3,7,2,0,0,1,1,2,3,1,3,23,3,3,2,0,0,1,3,23,23,255,0,8
			fcb	23,1,0,0,2,3,3,23,3,0,0,23,3,1,0,0,1,3,255,0,11,1,0,0,1,3,23,255,0,5,1,2,0,0
			fcb	1,23,255,0,11,2,0,0,1,23,255,0,6,23,1,0,0,1,3,255,0,10,23,3,1,1,3,23,255,0,6,5,1
			fcb	0,0,1,23,255,0,11,23,3,0,23,255,0,6,23,3,1,1,2,3,0,23,255,0,21,23,3,3,23,255,0,161
													; SCREEN #09
			fcb	0,0,0,45,255,0,10,44,255,0,8,7,5,21,22,5,255,0,25,21,22,255,0,12,46,255,0,10,45,0,0,21,22
			fcb	8,255,0,25,21,22,255,0,28,5,255,0,16,46,255,0,38,7,255,0,5,46,255,0,13,7,5,5,7,255,0,14,8
			fcb	5,5,8,255,0,6,12,10,255,0,6,5,255,0,10,11,255,0,9,11,255,0,4,46,255,0,12,11,255,0,9,11,255,0,6
			fcb	255,5,5,7,255,0,5,11,255,0,9,11,0,0,53,255,0,7,12,255,9,5,18,12,10,255,0,5,45,0,0,11,255,0,6
			fcb	8,255,0,9,45,0,11,255,0,6,46,0,11,255,0,10,17,255,0,7,11,255,0,8,11,0,0,53,0,0,0,7,0,0,0
			fcb	16,255,0,7,11,255,0,8,11,255,0,7,255,13,5,17,0,0,7,255,5,5,7,255,0,5,11,255,0,6,5,1,1
			fcb	2,1,1,13,21,22,5,42,0,11,0,43,5,255,0,5,11,0,0,53,255,0,4,3,23,23,3,1,2,21,22,5,0,0
			fcb	12,9,9,5,18,9,9,10,0,11,255,0,6,6,0,0,0,23,3,1,21,22,8,255,0,5,8,21,22,7,5,5,5
			fcb	7,255,0,5,5
													; SCREEN #10
			fcb	23,23,3,23,3,1,21,22,8,5,0,5,0,5,7,21,22,7,255,0,9,8,3,2,1,1,2,14,21,22,255,0,5
			fcb	43,5,21,22,255,0,11,2,1,14,16,0,0,21,22,255,0,6,5,21,22,255,0,5,45,255,0,4,5,1,2,0,17
			fcb	0,43,7,5,0,5,0,5,5,5,8,21,22,255,0,7,46,0,0,0,7,6,255,0,10,46,43,5,21,22,255,0,10
			fcb	5,8,5,0,0,0,19,19,255,0,7,5,21,22,0,45,255,0,9,255,13,7,255,0,8,21,22,255,0,9,45,5,255,1,5
			fcb	2,5,5,5,7,255,0,4,5,0,22,255,0,11,3,23,3,23,3,1,14,255,0,20,5,0,0,0,23,3,1,0,0
			fcb	45,255,0,5,5,255,0,5,7,5,0,0,0,21,22,255,0,5,3,2,0,46,255,0,5,5,7,255,0,10,21,22,5
			fcb	0,0,0,23,1,14,255,0,6,5,42,255,0,7,46,0,0,0,21,22,255,0,4,3,1,255,0,20,21,22,5,0,0
			fcb	23,1,14,255,0,10,45,255,0,9,21,0,0,0,23,3,2,17,255,0,4,8,255,0,17,5,0,0,3,1,16,76,255,0,24
			fcb	23,1,13,0,0,0,38,38,0,0,7,0,5,0,5,0,5,0,5,7,38,38,0,0,0,5,0,54,54,1,1,31,31,31
			fcb	38,38,255,31,12,38,38,31,31,31,5,0,54,54,3,2,255,20,22,13,0,0,0,23,3,2,255,1,7,2,255,1,6
			fcb	2,2,1,1,1,2,1,1
													; SCREEN #11
			fcb	255,44,28,255,0,33,46,255,0,26,45,255,0,7,19,19,255,0,10,46,0,0,0,8,7,5,5,0,8,0,5,8,0
			fcb	5,0,7,5,0,6,0,8,5,0,5,0,7,5,0,5,0,8,43,54,54,42,255,0,11,39,38,255,0,10,44,0,54,54
			fcb	255,0,11,45,40,40,255,0,10,17,255,0,24,45,0,0,13,255,0,13,11,255,0,13,1,255,0,8,46,255,0,4,11
			fcb	0,0,0,45,255,0,5,46,0,0,0,1,255,0,13,11,255,0,13,1,255,0,13,11,255,0,13,1,255,0,12,11,11
			fcb	255,0,13,8,255,0,12,11,11,255,0,13,1,255,0,12,11,12,10,255,0,11,75,2,0,0,0,17,255,0,8,12,18
			fcb	11,10,255,0,9,74,16,1,0,0,0,16,76,255,0,9,11,11,0,0,0,17,255,0,5,17,1,3,255,13,9,21,22
			fcb	13,13,13,24,25,255,13,10,1,3,1,2,1,1,1,5,1,1,1,21,22,2,1,1,77,78,1,2,1,1,7,1,1
			fcb	2,2,1,3,3,255,0,4,23,0,23,3,2,21,22,2,3,23,32,33,255,0,12
													; SCREEN #12
			fcb	14,255,0,9,6,21,22,5,44,44,44,24,77,78,25,255,44,7,255,0,5,46,0,54,54,54,5,21,22,255,0,4,27
			fcb	24,25,27,0,0,0,45,255,0,5,45,255,0,4,54,54,54,5,21,22,255,0,5,30,30,255,0,15,54,54,54,7,21
			fcb	22,255,0,5,30,30,0,0,19,19,255,0,14,43,5,5,7,0,0,7,27,24,25,27,7,5,5,7,5,8,5,255,0,7
			fcb	45,0,0,0,43,0,42,0,0,43,0,77,78,0,42,43,0,42,43,0,42,255,0,6,46,255,0,11,77,78,255,0,26
			fcb	24,25,0,0,45,255,0,18,46,0,0,0,37,32,33,36,255,0,4,46,255,0,17,44,0,0,38,38,255,0,16,75,255,0,9
			fcb	38,38,255,0,16,16,76,255,0,8,38,38,255,0,15,74,16,255,0,9,38,38,255,0,15,17,16,255,0,9,38,38,255,0,15
			fcb	16,16,76,255,0,8,38,38,0,0,17,255,0,12,16,16,0,17,255,0,7,38,38,0,0,16,76,255,0,10,17,13,13
			fcb	17,16,255,0,7,38,38,0,17,16,255,0,5,255,13,7,1,1,255,13,8,66,67,67,65,255,13,7,1,1,1,3,1
			fcb	7,1,14,15,1,3,1,1,1,2,1,2,1,66,65,255,1,7,2,0,0,23,255,0,6,23,23,255,0,6,23,0,23
			fcb	255,0,8
													; SCREEN #13
			fcb	255,44,4,15,255,1,4,2,1,14,0,44,0,15,2,1,3,23,0,0,0,23,23,3,3,1,255,0,6,15,14,0,16
			fcb	17,255,0,6,16,1,3,3,23,3,3,1,1,2,14,255,0,9,75,0,46,255,0,5,17,15,1,2,1,1,2,14,16,16
			fcb	255,0,4,46,255,0,16,17,16,45,0,0,17,16,76,255,0,5,46,255,0,15,17,255,0,4,75,255,0,25,46,255,0,12
			fcb	45,255,0,12,45,255,0,26,45,255,0,23,46,255,0,11,45,255,0,89,75,255,0,27,17,255,0,26,74,16,17,255,0,4
			fcb	13,255,0,21,16,16,76,0,38,38,5,38,38,255,0,16,17,0,0,13,13,31,31,38,38,5,38,38,31,31,13,13,255,0,4
			fcb	17,0,0,0,255,13,7,1,1,255,20,4,5,255,20,4,1,2,255,13,8,1,1,1,3,1,7,1,14,15,1,3,1,1
			fcb	6,2,1,2,1,3,8,255,1,7,2,0,0,23,255,0,6,23,23,255,0,8,23,255,0,8
													; SCREEN #14
			fcb	44,44,21,22,0,255,44,4,255,0,4,44,255,0,13,44,0,0,21,22,255,0,26,21,22,255,0,7,46,255,0,18,21
			fcb	22,255,0,18,45,0,40,19,255,0,4,21,22,0,46,255,0,18,40,19,255,0,4,21,22,255,0,19,59,57,57,57,58
			fcb	59,57,58,59,58,255,0,4,45,255,0,12,45,0,54,54,54,0,0,59,57,58,255,0,17,45,0,0,54,54,54,255,0,12
			fcb	51,24,25,49,0,0,46,255,0,11,45,255,0,8,51,48,48,48,50,49,255,0,21,51,50,50,255,48,4,49,255,0,19
			fcb	51,48,48,50,255,48,5,49,255,0,17,51,255,47,9,48,49,255,0,15,51,48,255,47,9,50,48,49,255,0,7,17,255,0,5
			fcb	51,48,48,47,47,47,48,48,48,50,255,47,5,49,255,0,5,74,16,0,17,0,0,51,50,50,48,48,47,47,47,42,43
			fcb	48,255,47,6,49,255,0,5,16,0,16,0,51,48,48,50,48,48,47,47,47,0,0,50,48,48,48,50,48,48,48,49,0
			fcb	17,0,0,16,255,13,10,50,50,5,5,50,50,255,13,12,1,1,1,3,1,7,1,2,1,1,3,50,52,52,50,1,2
			fcb	1,3,2,1,7,1,1,8,1,1,2,0,0,23,255,0,6,23,1,50,52,52,50,2,23,0,0,23,23,255,0,7
													; SCREEN #15
			fcb	13,255,44,27,1,17,255,0,7,59,57,57,58,255,0,15,1,16,75,255,0,25,1,16,16,76,255,0,18,45,255,0,5
			fcb	2,13,13,17,255,0,24,1,2,1,13,61,255,0,19,46,0,0,0,3,23,3,1,13,255,0,4,45,255,0,10,59,57
			fcb	58,0,0,59,57,58,23,0,23,3,1,255,0,11,59,58,0,0,0,45,255,0,8,3,1,255,0,6,40,39,0,0,59
			fcb	57,58,46,255,0,12,23,1,255,0,6,40,40,255,0,19,2,255,0,6,17,255,0,20,1,17,255,0,4,74,16,255,0,20
			fcb	3,13,255,0,5,16,76,255,0,5,75,255,0,13,3,1,255,0,4,17,16,0,0,17,0,0,74,16,255,0,5,17,255,0,7
			fcb	23,2,0,0,0,74,16,16,76,0,16,76,0,0,16,76,17,0,0,0,16,0,75,255,0,5,23,1,0,0,17,0,16,16
			fcb	0,17,16,0,0,17,16,0,16,0,0,74,16,17,16,255,0,5,3,2,13,61,16,0,16,16,0,16,16,19,61,16,16
			fcb	0,16,0,0,61,16,16,16,76,0,0,54,54,23,3,1,255,13,22,0,54,54,0,23,7,255,1,4,3,1,1,1,2
			fcb	1,2,1,3,1,1,1,8,255,1,4,2,255,0,9,23,23,255,0,8,23,255,0,8
													; SCREEN #16
			fcb	255,0,11,50,52,52,50,255,0,24,50,52,52,50,23,255,0,22,23,50,52,52,48,23,23,255,0,19,50,50,50,48,52,52
			fcb	255,50,4,255,0,17,23,50,255,0,8,50,255,0,18,50,255,0,8,50,23,255,0,17,48,50,50,50,52,52,50,50,50
			fcb	48,255,0,19,23,23,50,52,52,50,23,255,0,6,23,255,0,16,48,52,52,50,255,0,4,23,0,23,23,23,255,0,14
			fcb	23,50,52,52,48,0,0,255,50,4,48,255,50,4,255,0,13,50,52,52,50,23,0,50,255,0,4,39,39,17,50,255,0,13
			fcb	50,52,52,50,0,0,50,255,0,4,39,39,0,48,23,255,0,9,255,50,4,52,52,50,23,23,48,0,0,255,50,4,48,48
			fcb	255,0,9,23,50,0,0,0,52,52,50,48,50,50,0,0,50,23,23,255,0,12,23,48,0,0,0,52,52,255,0,6,50
			fcb	23,255,0,14,50,19,19,0,52,52,255,0,6,48,255,0,15,255,50,4,52,52,0,0,17,255,50,4,255,0,8,54,54
			fcb	255,0,8,48,52,52,255,50,4,255,0,11,54,54,255,0,7,23,50,52,52,50,255,0,23,50,50,52,52,50,48,255,0,12
													; SCREEN #17
			fcb	255,0,11,50,52,52,50,23,255,0,21,23,48,50,52,52,50,48,255,0,20,23,48,50,0,52,52,0,50,48,23,255,0,14
			fcb	23,0,23,23,48,50,0,0,52,52,0,0,50,48,23,0,0,0,23,255,0,8,255,50,4,48,50,0,0,0,52,52,0,0,0
			fcb	255,50,4,48,50,50,50,255,0,6,50,255,0,20,50,255,0,6,48,255,0,20,50,255,0,5,23,50,52,52,50,48,255,50,7
			fcb	48,50,48,255,50,4,52,52,48,23,255,0,5,50,52,52,50,50,50,48,50,42,255,0,4,43,50,50,48,48,50,52,52
			fcb	50,255,0,6,50,255,0,8,44,39,38,44,255,0,8,48,255,0,6,50,255,0,8,51,39,38,49,255,0,8,50,23,255,0,5
			fcb	50,52,52,50,48,50,50,42,0,255,50,4,0,43,48,50,50,50,52,52,50,23,255,0,5,50,52,52,50,42,255,0,12
			fcb	43,50,52,52,50,255,0,5,23,48,52,52,255,0,16,52,52,50,255,0,6,50,52,52,255,0,5,51,0,38,38,0,49
			fcb	255,0,5,52,52,50,255,0,5,23,50,52,52,255,0,5,50,31,38,38,31,50,255,0,5,52,52,48,255,0,6,50,52,52
			fcb	255,0,5,50,255,20,4,50,17,0,38,38,0,52,52,50,255,0,4,54,54,48,52,52,0,0,19,19,0,50,255,68,4
			fcb	50,16,76,0,0,0,52,52,50,23,0,0,0,54,54,255,50,4,48,255,50,7,48,50,50,50,48,48,255,50,4,255,0,13
			fcb	23,0,23,255,0,6,23,23,255,0,7
													; SCREEN #18
			fcb	255,44,28,0,0,0,45,255,0,5,46,255,0,15,45,0,46,255,0,27,44,255,0,18,7,5,5,5,57,58,0,0,46
			fcb	44,7,5,5,7,0,6,0,0,8,5,5,7,0,0,5,7,255,0,5,8,255,0,5,44,5,0,0,45,255,0,5,54,54
			fcb	255,0,6,45,255,0,7,59,57,57,5,38,38,0,0,5,0,0,5,54,54,5,0,0,5,255,0,12,44,5,38,38,0
			fcb	59,58,255,0,14,59,7,255,0,5,44,8,57,58,0,0,5,0,0,5,45,0,5,0,0,5,255,0,6,5,57,58,0,0
			fcb	46,44,5,255,0,4,8,5,5,8,0,0,8,5,5,7,255,0,6,5,45,255,0,4,44,7,59,58,255,0,8,45,0,0,0
			fcb	59,57,58,0,0,0,7,0,0,0,59,57,57,255,0,27,44,255,0,27,44,7,57,58,255,0,4,59,57,57,58,0,0,0
			fcb	59,57,57,58,59,57,57,7,57,58,0,0,0,44,5,0,45,255,0,7,46,255,0,11,46,255,0,4,44,5,255,0,5
			fcb	59,57,58,255,0,8,59,58,0,0,5,0,0,59,57,57,58,6,255,0,14,46,255,0,11,44,5,17,0,59,58,255,0,16
			fcb	8,255,0,5,44,5,16,17,255,0,13,19,19,255,0,4,17,0,0,21,22,44,5,5,8,0,8,0,5,0,5,0,8
			fcb	0,8,0,8,0,5,0,7,0,7,5,5,5,7,21,22,8
													; SCREEN #19
			fcb	255,44,11,24,25,24,25,24,25,255,44,11,0,0,45,255,0,4,46,0,0,0,255,47,6,0,0,45,46,0,0,0,45
			fcb	255,0,14,255,47,6,255,0,22,255,47,6,255,0,11,8,5,5,7,255,0,4,45,38,38,24,25,24,25,24,25,38,38
			fcb	255,0,5,7,5,8,5,7,42,0,43,5,7,0,0,31,38,38,43,42,43,42,43,42,38,38,31,0,0,7,5,42,0
			fcb	46,5,75,0,0,45,0,43,8,5,255,20,12,5,5,42,0,0,45,0,5,13,0,0,0,46,0,43,255,5,14,42,255,0,5
			fcb	8,1,13,255,0,25,5,3,2,255,0,25,5,23,1,17,5,5,21,22,5,7,0,0,0,8,5,5,7,0,0,0,7
			fcb	5,5,7,21,22,7,5,8,23,1,16,76,0,21,22,43,5,0,0,0,5,42,43,5,0,0,0,5,42,43,5,21,22
			fcb	0,0,0,3,1,13,0,0,21,22,0,43,5,0,5,42,0,0,43,5,0,5,42,0,0,5,21,22,0,0,0,1,14
			fcb	0,0,0,21,22,255,0,15,255,5,5,7,1,17,0,0,0,21,22,255,0,20,5,1,255,13,4,5,0,6,0,5,255,0,17
			fcb	7,3,1,1,1,2,17,0,0,0,43,5,0,5,0,7,0,5,0,5,0,7,0,5,0,8,21,22,5,0,23,3,3
			fcb	1,13,255,0,19,21,22,5,0,0,0,23,3,2,255,0,19,21,22,6,0,0,23,23,3,1,0,5,0,53,0,7,0
			fcb	5,0,8,0,7,0,5,0,5,0,8,0,5,0,5
													; SCREEN #20
			fcb	255,44,16,0,0,0,255,44,10,54,54,255,0,9,46,255,0,14,44,44,54,54,45,255,0,20,46,0,0,44,44,255,0,15
			fcb	59,57,58,255,0,6,45,0,44,44,255,0,18,46,255,0,7,44,44,255,0,20,59,58,255,0,4,44,44,255,0,6,59
			fcb	57,57,58,255,0,16,44,44,38,38,255,0,24,44,44,38,38,255,0,21,59,57,58,44,44,255,0,6,45,255,0,6,59
			fcb	58,255,0,11,44,44,255,0,26,44,44,255,0,17,45,255,0,5,59,58,0,44,44,255,0,8,59,57,58,255,0,15,44,44
			fcb	46,255,0,25,44,44,255,0,21,59,58,0,0,0,44,44,255,0,12,59,57,57,58,255,0,10,44,44,255,0,5,59,57
			fcb	58,0,46,255,0,14,45,0,44,44,255,0,26,44,59,58,21,22,255,0,8,53,255,0,14,44,44,59,21,22,57,58,255,0,21
			fcb	44
													; SCREEN #21
			fcb	255,44,15,255,0,12,44,44,255,0,6,46,255,0,16,54,54,54,44,44,0,0,40,39,255,0,11,45,255,0,7,54,54,54
			fcb	44,44,0,0,38,41,255,0,22,44,44,59,57,57,57,58,255,0,21,44,44,255,0,24,46,0,44,44,255,0,6,45,0,0,0
			fcb	59,58,255,0,7,45,255,0,6,44,44,255,0,26,44,44,255,0,20,19,19,255,0,4,44,44,0,0,45,255,0,10,59
			fcb	58,255,0,4,59,57,57,58,0,0,0,44,44,255,0,26,44,44,255,0,26,44,44,255,0,5,46,255,0,4,59,58,255,0,10
			fcb	45,0,0,0,44,44,255,0,26,44,44,0,0,0,59,57,57,58,255,0,19,44,44,255,0,26,44,44,0,0,46,255,0,9
			fcb	59,57,57,58,255,0,4,45,255,0,5,44,44,255,0,26,44,44,255,0,8,53,0,0,53,255,0,9,53,0,0,53,0
			fcb	44,59,57,57,58,59,57,58,255,0,9,59,57,58,255,0,8,44
													; SCREEN #22
			fcb	255,44,11,23,3,2,68,62,2,3,23,255,44,10,54,54,41,41,44,255,41,6,64,63,62,42,255,41,9,54,54,44,44
			fcb	54,54,255,41,8,64,63,62,42,255,41,10,54,54,44,44,44,255,41,8,64,63,1,3,23,255,44,6,41,41,41,255,44,5
			fcb	255,41,8,64,3,1,44,0,0,44,255,41,8,44,0,0,44,44,255,41,4,44,44,44,23,23,44,255,0,4,44,255,41,8
			fcb	44,0,0,44,44,255,41,4,44,255,0,9,44,41,41,41,255,44,6,0,0,44,44,41,41,41,44,44,255,0,9,44,41,41,41
			fcb	44,255,0,7,44,44,255,41,4,44,0,255,44,9,41,41,41,44,23,44,23,23,3,1,1,2,44,255,41,4,44,0,66
			fcb	41,38,38,255,41,12,64,63,62,62,62,44,44,41,41,41,44,0,66,38,38,38,31,38,255,41,9,64,63,255,62,4,44
			fcb	255,41,4,44,0,44,66,47,47,47,65,41,41,41,255,44,4,23,44,23,23,3,1,1,2,44,255,41,4,44,0,0,44
			fcb	67,67,67,44,44,41,41,44,255,0,11,44,41,41,41,44,44,0,255,44,6,41,41,41,255,44,10,0,0,44,255,41,4
			fcb	44,0,44,255,41,15,54,54,44,0,0,44,255,41,4,44,0,44,255,41,15,54,54,44,0,0,44,66,38,38,38,44,44,44
			fcb	38,38,38,65,255,44,6,255,41,5,44,44,44,0,0,66,31,31,38,38,255,31,5,38,65,255,0,5,255,44,7,255,0,4
			fcb	66,255,47,9,65,44,255,0,16,44,255,67,9,255,0,18
													; SCREEN #23
			fcb	3,1,13,0,71,0,255,71,4,6,21,22,6,71,71,255,0,12,23,3,1,13,255,9,6,18,21,22,18,9,10,255,0,13
			fcb	23,3,1,0,6,0,0,6,0,7,21,22,5,0,11,71,71,46,71,71,71,255,0,8,3,2,255,0,4,70,0,0,21
			fcb	22,0,0,12,255,9,6,10,255,0,7,1,1,0,0,0,45,0,0,0,21,22,7,255,0,5,44,44,0,11,255,0,6
			fcb	23,1,14,255,0,7,21,22,255,0,9,11,255,0,5,23,3,2,0,45,255,0,6,21,22,5,0,8,0,8,0,0,0
			fcb	5,11,8,0,5,0,26,3,3,1,255,0,8,21,22,0,45,255,0,7,11,255,0,4,53,2,1,14,255,0,8,21,22
			fcb	255,0,8,46,11,255,0,27,11,255,0,10,17,255,0,16,11,255,0,4,53,255,13,4,5,16,8,0,5,0,7,21,22
			fcb	7,0,8,0,7,0,8,0,8,11,7,0,5,0,26,1,2,1,1,13,16,255,0,4,5,21,22,255,0,9,12,255,9,5
			fcb	3,3,3,2,1,16,76,0,0,0,7,21,22,5,255,0,14,23,0,23,3,1,13,255,0,5,21,22,255,0,6,46,0,0,0
			fcb	45,255,0,7,23,3,1,255,0,4,7,21,22,8,255,0,15,23,3,2,1,14,255,0,4,5,21,22,255,0,4,45,255,0,10
			fcb	23,3,1,14,0,0,0,46,0,0,0,21,22,5,255,0,4,45,34,35,255,0,7,3,2,14,0,0,0,45,0,0,0
			fcb	8,21,22,255,0,5,24,77,78,25,255,0,6,1,14,255,0,8,5,21,22,5,255,0,5,77,78,255,0,7
													; SCREEN #24
			fcb	255,0,4,45,255,0,37,46,255,0,7,255,6,5,255,0,21,46,0,6,70,70,19,6,255,0,7,46,0,0,0,71,0,0,0
			fcb	71,0,0,0,71,0,71,71,6,19,19,0,6,255,0,11,6,0,6,0,6,0,6,0,6,0,6,24,25,19,19,19,6
			fcb	255,0,11,70,255,0,11,69,38,38,19,6,255,0,11,6,0,0,71,71,0,71,0,19,19,71,0,69,38,38,71,6,0,0,0
			fcb	46,255,0,8,21,22,6,6,0,6,0,6,6,6,24,25,255,6,4,255,0,11,6,21,22,6,0,0,70,0,0,0,70
			fcb	11,11,0,0,70,255,0,9,45,0,0,0,21,22,255,0,7,45,12,11,18,9,10,255,0,8,71,0,71,0,6,21,22
			fcb	6,0,71,255,0,6,12,255,9,5,255,0,6,255,6,5,21,22,6,6,6,255,0,6,46,0,0,12,9,9,255,0,6
			fcb	6,0,0,70,255,0,4,70,6,255,0,13,45,255,0,4,6,255,71,4,0,0,71,71,6,255,0,18,255,6,5,21,22
			fcb	6,6,6,255,0,19,70,0,0,6,21,22,6,0,70,255,0,10,45,255,0,5,46,255,0,6,21,22,70,0,0,46,255,0,12
			fcb	54,54,255,0,7,6,21,22,6,255,0,6,46,255,0,8,54,54,255,0,8,21,22,255,0,25,6,21,22,6,255,0,14
													; SCREEN #25
			fcb	255,0,23,11,255,0,9,46,255,0,17,11,255,0,21,45,255,0,5,11,255,0,9,44,0,44,0,44,0,44,0,44,0
			fcb	44,0,44,0,44,0,0,0,11,255,0,27,11,255,0,27,11,255,0,4,5,0,7,0,5,255,0,15,7,0,5,11,5
			fcb	0,5,255,0,24,12,10,255,0,27,11,255,0,27,11,255,0,27,12,10,0,0,5,0,59,57,58,0,5,0,5,0,5
			fcb	0,8,0,6,0,7,0,5,0,5,0,0,0,7,11,5,0,18,255,9,12,10,255,0,11,12,9,9,7,0,59,58,255,0,9
			fcb	12,255,9,9,18,5,18,9,9,255,0,4,45,255,0,18,6,45,0,0,0,5,0,59,58,255,0,20,5,255,0,13,45
			fcb	255,0,17,8,0,5,0,7,0,5,0,5,0,8,0,5,0,7,0,5,0,7,0,5,0,8,0,7,255,0,17,46,255,0,41
													; SCREEN #26
			fcb	255,0,25,11,255,0,4,45,255,0,19,46,0,0,11,255,0,27,11,255,0,27,11,255,0,8,44,255,0,8,45,255,0,4
			fcb	44,255,0,4,11,255,0,14,34,35,255,0,11,11,0,0,5,0,7,0,5,0,0,0,5,0,5,8,24,25,5,0,5
			fcb	0,5,0,0,0,5,0,5,11,5,255,0,5,53,0,0,0,53,0,0,5,24,25,8,0,0,0,53,0,0,0,53,0,0
			fcb	11,255,0,13,26,24,25,26,255,0,10,11,255,0,14,29,29,255,0,11,11,255,0,10,19,19,0,0,29,29,255,0,11
			fcb	11,0,0,5,0,5,0,7,0,5,0,5,7,5,26,24,25,26,0,7,0,5,0,5,0,8,0,7,11,5,0,255,9,12
			fcb	18,11,255,0,11,12,9,9,9,10,255,0,11,12,255,9,14,0,11,255,0,13,45,255,0,13,11,0,0,45,255,0,24
			fcb	11,255,0,11,46,255,0,15,11,255,0,22,45,255,0,4,11,255,0,27,11,255,0,26
													; SCREEN #27
			fcb	255,0,21,24,25,255,0,14,45,255,0,11,77,78,255,0,15,46,0,0,0,44,255,0,6,24,25,255,0,7,45,255,0,18
			fcb	39,38,0,0,0,45,255,0,22,39,38,255,0,24,7,7,24,25,7,7,0,0,0,48,0,48,0,48,0,68,0,48,0
			fcb	68,0,68,0,0,8,255,7,4,42,77,78,0,7,255,0,24,43,42,0,26,255,0,24,38,0,0,4,255,0,27,27,255,0,24
			fcb	34,35,0,7,0,0,0,48,0,48,0,48,0,68,0,48,0,68,0,68,0,0,8,255,7,5,24,25,7,42,0,0,0
			fcb	255,9,12,10,0,0,0,12,9,9,9,18,11,11,255,0,5,9,9,10,255,0,9,11,255,0,8,11,11,0,0,0,45
			fcb	0,0,0,11,255,0,14,46,0,0,0,12,11,10,0,45,255,0,4,11,255,0,11,44,255,0,7,11,11,255,0,6,11
			fcb	255,0,19,11,11,255,0,20,45,255,0,5,11,11,255,0,10,46,255,0,15,11,12,9,9,10,255,0,23,11,0,0,0
			fcb	11,0
													; SCREEN #28
			fcb	255,0,5,46,255,0,6,45,0,45,255,0,5,39,255,0,27,39,0,0,46,255,0,24,11,255,0,6,45,57,58,255,0,15
			fcb	46,0,0,11,0,71,71,71,34,35,71,0,0,0,59,57,57,58,0,45,0,0,55,75,73,255,0,6,11,71,1,1,1
			fcb	24,25,1,255,0,12,17,0,0,0,46,0,0,0,11,1,14,0,0,77,78,255,0,4,46,255,0,7,55,16,0,0,59
			fcb	58,0,0,71,1,14,23,23,0,77,78,0,72,73,255,0,5,45,55,72,73,0,16,255,0,5,71,1,12,9,9,10,0
			fcb	24,25,23,17,255,0,8,17,0,74,16,73,255,0,4,1,14,0,23,0,11,0,15,14,0,16,73,255,0,6,74,16,0,0
			fcb	16,0,45,75,0,64,1,0,23,0,0,11,255,0,4,16,255,0,6,61,0,16,73,0,16,76,0,61,0,15,1,255,0,4
			fcb	11,255,0,4,16,61,0,34,35,0,0,61,13,16,0,0,16,0,0,17,0,0,69,255,0,4,11,255,0,4,16,61,37
			fcb	32,33,36,13,13,1,13,17,61,16,0,0,16,61,0,69,255,0,4,11,0,0,21,22,13,13,24,25,24,25,1,1,3
			fcb	1,255,13,16,21,22,1,1,1,2,1,1,3,3,23,3,1,1,2,1,1,1,2,2,255,1,6,2,1,21,22,3,3
			fcb	1,1,3,255,54,4,255,3,14,11,3,1,21,22,23,23,3,3,44,255,54,4,44,23,23,23,0,0,23,0,23,23,0
			fcb	23,0,23,11,3,2,21,22,0,0,23,23,255,44,6,255,0,4,23,255,0,8,11,3,2,21,22,255,0,6,23,255,0,14
			fcb	23,0,11,3,2,21,22,255,0,23,11,3,1,21,22

numSc		fcb	28																						; numsc  defb 28
; ------------------------------------------------------------------------------------------------------------------------------------------
													; 28 chunks ended in $ff						; nmedat (in original)
													; Default sprites in each location
													; each sprite uses four bytes
nmeDat	fcb	0,90,112,72,4,3,72,176,6,4,40,208,2,5,64,192,255
			fcb	6,4,72,152,0,0,16,176,5,5,120,144,255
			fcb	6,4,32,136,4,6,120,144,0,0,56,80,1,7,128,112,1,7,128,160,255
			fcb	0,0,136,88,4,3,72,152,4,6,96,112,255
			fcb	0,0,64,24,6,4,80,152,2,5,40,88,255
			fcb	0,0,32,168,2,5,32,136,5,5,120,72,1,10,104,96,255
			fcb	0,0,80,32,6,6,104,168,4,3,8,192,4,6,72,144,1,7,128,64,1,7,128,176,255
			fcb	0,0,32,32,4,3,88,56,4,3,24,184,255
			fcb	0,0,72,32,6,4,32,104,4,6,16,128,255
			fcb	0,0,8,80,2,5,32,56,1,7,128,80,1,7,128,192,6,4,56,136,255
			fcb	0,0,120,64,2,5,16,112,1,9,80,104,1,9,48,112,255
			fcb	0,0,120,216,4,3,24,128,2,5,16,192,1,10,72,160,1,10,88,160,1,10,104,160,1,10,120,160,255
			fcb	0,0,120,216,1,7,120,104,1,7,120,128,4,6,16,120,255
			fcb	0,0,120,216,4,3,48,112,2,5,120,96,255
			fcb	0,0,120,176,2,5,120,128,255
			fcb	0,0,8,112,3,3,32,88,3,3,32,136,2,5,112,88,255
			fcb	0,0,16,112,6,3,40,48,1,7,112,120,2,5,128,80,6,8,72,80,6,8,72,160,255
			fcb	0,0,128,216,2,5,136,144,6,4,88,112,4,3,8,64,4,6,40,112,255
			fcb	0,0,16,216,1,7,32,88,1,7,32,152,6,6,8,80,6,8,64,120,6,4,104,168,255
			fcb	0,0,80,96,6,4,56,184,6,6,104,160,255
			fcb	0,0,136,144,2,5,56,184,6,3,80,128,255
			fcb	0,0,72,208,1,7,72,88,1,7,128,40,255
			fcb	0,0,72,112,4,3,72,160,255
			fcb	0,0,40,104,6,3,96,104,2,5,40,160,255
			fcb	0,0,72,32,4,8,40,56,4,8,56,72,4,8,72,88,4,8,40,128,4,8,56,144,4,8,72,160,255
			fcb	0,0,72,32,5,5,72,80,4,8,40,56,4,8,40,168,255
			fcb	0,0,72,32,4,8,24,120,4,8,104,120,1,10,24,184,255
			fcb	0,0,120,64,1,9,0,168,1,1,88,176,255
; ------------------------------------------------------------------------------------------------------------------------------------------
; Just a reminder of OBJECT structure to TEST program
			; 0-31	32 bytes for image
			; 32		for colour
			; 33-35	for room, x and y
			; 36-38	for starting room, x and y
			; Special Values:
			;		254 = disabled
			; 		255 = object in player's pockets
; ------------------------------------------------------------------------------------------------------------------------------------------
NUMOBJ 	equ 	20
	IF PMODE4
objDta	equ *									; 20 objects x 39 bytes = 780 bytes			; objdta (in original)
;			Obj0  = KEY		 Obj1  = CRYSTAL		Obj2  = CRYSTAL		Obj3  = CRYSTAL		Obj4  = KEY		Obj5  = KEY		Obj6  = LADDER		Obj7  = BOMB
;			Obj8  = DIAMOND Obj9  = SKULL			Obj10 = PIT-PLANT		Obj11 = ROCK			Obj12 = MEDKIT	Obj13 = MEDKIT	Obj14 = SEED		Obj15 = GLOBE
;			Obj16 = PICK	 Obj17 = BRICKS		Obj18 = ICE DRILL		Obj19 = MACHINE	
; - - - - - -    0   1   2   3   4   5   6   7   8   9  10  11  12  13  14  15  16  17  18  19  20  21  22  23  24  25  26  27  28  29  30  31  32  33  34  35  36  37  38
			fcb	 63,192, 64, 32, 95,208, 95,232, 95,244, 81,244, 84, 20, 81,148, 95,244, 95,244, 64,  4,127,252, 42,168,127,252,127,252,  0,  0, 71,  0,128,208,  0,128,208 ; 00
			fcb	  1,128,  2,192,  7, 96, 14,208, 31,248, 30,200, 31, 72, 30,200, 39,252, 79,254, 79,234, 37, 84,  0,  0, 79,254,155,109,159,255, 71,  1, 56, 56,  1, 56, 56 ; 01
			fcb	  1,128,  2,192,  7, 96, 14,208, 31,248, 30,200, 31, 72, 30,200, 39,252, 79,254, 79,234, 37, 84,  0,  0, 79,254,155,109,159,255, 71,254,  0, 16,254,  0, 16 ; 02
			fcb	  1,128,  2,192,  7, 96, 14,208, 31,248, 30,200, 31, 72, 30,200, 39,252, 79,254, 79,234, 37, 84,  0,  0, 79,254,155,109,159,255, 71,  7, 32,168,  7, 32,168 ; 03
			fcb	 63,192, 64, 32, 95,208, 95,232, 95,244, 81,244, 84, 20, 81,148, 95,244, 95,244, 64,  4,127,252, 42,168,127,252,127,252,  0,  0, 71, 23, 40,200, 23, 40,200 ; 04
			fcb	 63,192, 64, 32, 95,208, 95,232, 95,244, 81,244, 84, 20, 81,148, 95,244, 95,244, 64,  4,127,252, 42,168,127,252,127,252,  0,  0, 71, 15, 80,192, 15, 80,192 ; 05
			fcb	  0,  4,  0, 12,  0,  0,  1,254,  0,170,  0,  0, 64, 12, 96, 12, 96, 12, 96, 12,  0,  0,255,254,170,170,  0,  0, 96, 12, 96, 12, 71,  9,  8,104,  9,  8,104 ; 06
			fcb	 15,  0, 17,128,  0,  0,  2,192,  2,192,  7,224, 27,248, 39,252, 88,126,121, 62,120,122,121, 54,121, 42, 56, 84, 30,184,  7,224, 71,  6,104,176,  6,104,176 ; 07
			fcb	  1,  0,  3,128,  7, 64, 11,160, 23, 80, 47,168,127, 84,255,250, 85, 84, 43,168, 21, 80, 11,160,  5, 64,  2,128,  1,  0,  0,  0, 71, 20, 16, 40, 20, 16, 40 ; 08
			fcb	  7,192, 27,176, 61,120,102,204, 99,140, 97, 12, 83,148, 46,232, 20, 80, 77,100,111,236, 53, 88,112, 28,  5, 64,123,188,252,126, 71, 13, 24,208, 13, 24,208 ; 09
			fcb	  7,  0, 52,  0,119,  4,244,  8,174, 12,232, 26,238,112,245,192,214,133,187, 85,221,223,174,112, 87,142, 74,250, 53, 84, 15,248, 71, 14, 64, 96, 14, 64, 96 ; 10
			fcb	  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0, 28,  0, 46,  0,126,  0, 93,  0,235,  0,209,  0,170,  0,124,  0, 71,  7, 32, 88,  7, 32, 88 ; 11
			fcb	  0,  0,  0,  0,  3,192,  7,224,  1,128, 63,252, 76, 50, 93,186,113,142,119,238,119,238,113,142, 93,186, 76, 50, 63,252,  0,  0, 71, 17, 48, 24, 17, 48, 24 ; 12
			fcb	  0,  0,  0,  0,  3,192,  7,224,  1,128, 63,252, 76, 50, 93,186,113,142,119,238,119,238,113,142, 93,186, 76, 50, 63,252,  0,  0, 71, 19, 56, 24, 19, 56, 24 ; 13
			fcb	  0,  0,  1,128,  7,224,  9,112, 19,248, 19,152, 63,188, 57,244,121,190, 79,254, 94,226,127,194, 95,194, 43,196,149, 91, 98,166, 71,254,  0, 16,254,  0, 16 ; 14
			fcb	  7,192,  9,224, 25,240, 23,240, 31,240, 31,176, 15, 32,  7,192,  1,  0,  1,  0,  0,128,  0,128,  0, 64,  2, 32,  5, 32,  0,192, 71, 10, 40,136, 10, 40,136 ; 15
			fcb	  0,  0,120,  0, 30,  0,  7,  0,  3,160,  1, 80,  0,224,  1, 80,  3,184,  7, 28, 14, 12, 20,  6, 40,  6, 80,  2,160,  2, 64,  0, 71, 21,  8,216, 21,  8,216 ; 16
			fcb	  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,254,254,234,234,212,212,170,170,212,212,170,170,212,212, 71, 14, 16, 24, 14, 16, 24 ; 17
			fcb	  0,  0,  0,  0,  0,  0,  0,  8, 55,228, 85,122, 79,245, 86,122, 53,164,  3,200,  4, 32, 13,176, 16,  8, 53,172, 49,140, 31,248, 71,  6, 24, 64,  6, 24, 64 ; 18
			fcb	120,  0,132,  0,165, 80,133, 88,132,  0,120, 26,128,  2,192,127,199,201,207,201,204,127,205, 89,204,111,237,217,109,239, 12,127, 71, 26, 64,184, 26, 64,184 ; 19
; ------------------------------------------------------------------------------------------------------------------------------------------
	ELSE
objDta	fcb	$AA,$80,$80,$20,$80,$08,$80,$02,$80,$02,$8F,$02,$8F,$F2,$8F,$32,$80,$02,$80,$02,$80,$02,$80,$02,$AA,$AA,$11,$10,$55,$55,$FF,$FF, 71,  0,128,208,  0,128,208
			fcb	$03,$C0,$03,$C0,$0C,$30,$0C,$00,$3C,$0C,$33,$00,$3C,$00,$30,$0C,$3C,$00,$45,$55,$CF,$CD,$31,$54,$00,$00,$33,$54,$CF,$FD,$CF,$D5, 71,  1, 56, 56,  1, 56, 56
			fcb	$01,$40,$01,$40,$05,$50,$05,$50,$11,$54,$14,$44,$11,$44,$15,$44,$11,$54,$45,$55,$CF,$CD,$31,$54,$00,$00,$33,$54,$CF,$FD,$CF,$D5, 71,254,  0, 16,254,  0, 16
			fcb	$02,$80,$02,$80,$0A,$A0,$0A,$A0,$22,$A8,$28,$88,$22,$88,$2A,$88,$22,$A8,$45,$55,$CF,$CD,$31,$54,$00,$00,$33,$54,$CF,$FD,$CF,$D5, 71,  7, 32,168,  7, 32,168
			fcb	$AA,$80,$95,$60,$95,$58,$95,$56,$95,$56,$9F,$56,$9F,$F6,$9F,$76,$95,$56,$95,$56,$95,$56,$95,$56,$AA,$AA,$11,$10,$55,$55,$FF,$FF, 71, 23, 40,200, 23, 40,200
			fcb	$AA,$80,$95,$60,$80,$08,$95,$56,$80,$02,$9F,$56,$8F,$F2,$9F,$76,$80,$02,$95,$56,$80,$02,$95,$56,$AA,$AA,$11,$10,$55,$55,$FF,$FF, 71, 15, 80,192, 15, 80,192
			fcb	$00,$0C,$00,$0C,$00,$00,$03,$FF,$03,$33,$00,$00,$30,$0C,$30,$0C,$30,$0C,$30,$0C,$00,$00,$FF,$FF,$CC,$CC,$00,$00,$30,$0C,$30,$0C, 71,  9,  8,104,  9,  8,104
			fcb	$0F,$00,$30,$C0,$00,$00,$03,$40,$03,$40,$05,$50,$1D,$54,$35,$54,$74,$15,$54,$45,$54,$15,$54,$45,$54,$45,$14,$14,$15,$54,$05,$50, 71,  6,104,176,  6,104,176
			fcb	$00,$80,$01,$80,$00,$20,$05,$88,$00,$20,$15,$88,$00,$22,$55,$AA,$FF,$45,$CC,$51,$33,$44,$0C,$50,$33,$44,$0C,$50,$03,$40,$00,$40, 71, 20, 16, 40, 20, 16, 40
			fcb	$0A,$F0,$22,$CC,$28,$3C,$96,$D7,$96,$D7,$96,$D7,$A6,$DF,$AA,$FC,$28,$3C,$08,$30,$8A,$F3,$22,$CC,$A0,$0F,$02,$C0,$A2,$CF,$A8,$3F, 71, 13, 24,208, 13, 24,208
			fcb	$25,$00,$24,$00,$A5,$01,$84,$04,$85,$04,$A4,$05,$A4,$10,$A4,$40,$29,$01,$89,$11,$2A,$55,$8A,$A0,$22,$AA,$88,$AA,$22,$28,$08,$A0, 71, 14, 64, 96, 14, 64, 96
			fcb	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$05,$00,$05,$00,$11,$40,$15,$40,$55,$40,$54,$40,$51,$00,$44,$40,$11,$00, 71,  7, 32, 88,  7, 32, 88
			fcb	$00,$00,$01,$40,$05,$50,$01,$40,$00,$00,$15,$54,$50,$05,$51,$45,$51,$45,$45,$51,$45,$51,$51,$45,$51,$45,$50,$05,$15,$54,$00,$00, 71, 17, 48, 24, 17, 48, 24
			fcb	$00,$00,$01,$40,$05,$50,$01,$40,$00,$00,$15,$54,$50,$05,$51,$45,$51,$45,$45,$51,$45,$51,$51,$45,$51,$45,$50,$05,$15,$54,$00,$00, 71, 19, 56, 24, 19, 56, 24
			fcb	$03,$C0,$0F,$F0,$0C,$F0,$33,$FC,$33,$FC,$3F,$FC,$FF,$DF,$3D,$FF,$CF,$F7,$3F,$D7,$CD,$D7,$33,$D7,$CC,$DF,$33,$3C,$AC,$CA,$2A,$A8, 71,254,  0, 16,254,  0, 16
			fcb	$05,$40,$07,$40,$1D,$50,$1D,$50,$15,$50,$15,$50,$15,$50,$05,$40,$05,$40,$02,$00,$02,$00,$00,$80,$00,$20,$00,$20,$02,$20,$00,$80, 71, 10, 40,136, 10, 40,136
			fcb	$00,$00,$F0,$00,$CF,$00,$33,$00,$0F,$50,$03,$40,$03,$D0,$00,$F0,$01,$0C,$03,$3C,$04,$00,$0C,$0F,$10,$03,$30,$03,$40,$03,$C0,$00, 71, 21,  8,216, 21,  8,216
			fcb	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$55,$55,$44,$44,$50,$50,$44,$44,$50,$50,$44,$44,$50,$50, 71, 14, 16, 24, 14, 16, 24
			fcb	$00,$00,$00,$00,$00,$00,$00,$10,$0F,$D0,$40,$14,$4F,$D5,$4F,$D4,$0C,$10,$02,$80,$08,$20,$0A,$A0,$20,$08,$CA,$A3,$73,$CD,$15,$54, 71,  6, 24, 64,  6, 24, 64
			fcb	$30,$00,$CC,$00,$CC,$00,$CC,$A0,$CC,$00,$30,$28,$40,$08,$40,$55,$41,$55,$45,$DD,$44,$1D,$44,$55,$44,$1D,$54,$75,$14,$5D,$04,$75, 71, 26, 64,184, 26, 64,184
	ENDIF
; ------------------------------------------------------------------------------------------------------------------------------------------
																											; palett equ $
																											; 		 defb 0,2,20,19,128,227,200,146,0,2,20,19,128,227,200,146
																											; 		 defb 0,35,60,63,224,227,252,255,0,35,60,63,224,227,252,255
																											; 		 defb 0,33,39,162,243,64,128,244,0,33,39,162,243,64,128,244
																											; 		 defb 0,44,80,120,108,109,146,219,0,44,80,120,108,109,146,219
; ------------------------------------------------------------------------------------------------------------------------------------------
	IF PMODE4
font		fcb	0,0,0,0,0,0,0,0						; 96 chars x 8 = 768 bytes			; font (in orginal)
			fcb	0,48,120,120,48,48,0,48
			fcb	0,24,6,6,9,17,32,64
			fcb	24,52,60,94,126,114,114,60
			fcb	0,94,126,126,42,82,4,120
			fcb	2,2,14,66,126,66,126,66
			fcb	126,189,153,90,36,60,0,24
			fcb	124,185,246,232,213,239,189,126
			fcb	0,12,24,24,24,24,12,0
			fcb	0,96,48,48,48,48,96,0
			fcb	24,52,114,255,149,90,52,24
			fcb	28,62,127,127,87,71,71,62
			fcb	0,0,0,0,0,24,24,48
			fcb	0,0,0,0,126,0,0,0
			fcb	0,0,0,0,0,0,16,0
			fcb	56,124,254,254,234,226,226,124
			fcb	124,254,206,214,230,254,124,0
			fcb	24,120,120,24,24,126,126,0
			fcb	252,254,6,124,192,254,254,0
			fcb	252,254,6,62,6,254,252,0
			fcb	216,216,216,216,254,254,24,0
			fcb	254,254,192,252,6,254,252,0
			fcb	124,252,192,252,198,254,124,0
			fcb	254,254,6,14,28,24,24,0
			fcb	124,254,198,124,198,254,124,0
			fcb	124,254,198,254,126,6,6,0
			fcb	0,0,0,48,0,0,48,0
			fcb	0,0,0,0,0,0,0,0
			fcb	120,124,126,126,126,66,66,126
			fcb	0,0,0,0,0,0,0,0
			fcb	0,24,52,36,126,171,126,36
			fcb	60,14,7,7,7,7,14,60
			fcb	0,78,86,78,86,78,86,74
			fcb	60,126,6,126,126,102,102,0
			fcb	120,126,6,124,102,126,124,0
			fcb	62,126,0,96,96,126,62,0
			fcb	124,126,6,102,102,126,124,0
			fcb	62,126,0,124,96,126,62,0
			fcb	62,126,0,124,96,96,96,0
			fcb	62,126,0,110,102,126,62,0
			fcb	102,102,6,126,102,102,102,0
			fcb	126,126,0,24,24,126,126,0
			fcb	6,6,0,6,6,126,124,0
			fcb	102,110,28,120,124,110,102,0
			fcb	96,96,0,96,96,126,62,0
			fcb	99,119,31,107,99,99,99,0
			fcb	124,126,6,102,102,102,102,0
			fcb	60,126,6,102,102,126,60,0
			fcb	124,126,6,126,124,96,96,0
			fcb	60,126,6,102,102,112,54,6
			fcb	124,126,6,126,124,110,102,0
			fcb	62,126,0,60,14,126,124,0
			fcb	126,126,0,24,24,24,24,0
			fcb	102,102,6,102,102,126,62,0
			fcb	102,102,6,102,126,60,24,0
			fcb	99,99,3,107,127,119,99,0
			fcb	99,119,46,28,62,119,99,0
			fcb	102,102,6,126,6,62,60,0
			fcb	126,126,0,12,24,62,126,0
			fcb	30,12,12,12,12,12,12,30
			fcb	0,0,192,96,48,24,12,0
			fcb	0,240,48,48,48,48,240,0
			fcb	60,78,94,126,122,60,8,24
			fcb	0,0,127,127,42,85,0,127
			fcb	0,86,75,85,74,69,32,31
			fcb	0,0,60,6,62,102,62,0
			fcb	0,96,96,124,102,102,124,0
			fcb	60,66,153,161,161,153,66,60
			fcb	0,6,6,62,102,102,62,0
			fcb	0,0,60,102,124,96,60,0
			fcb	0,28,48,56,48,48,48,0
			fcb	0,0,56,108,108,60,12,120
			fcb	0,96,96,124,102,102,102,0
			fcb	0,24,0,56,24,24,60,0
			fcb	0,6,0,6,6,6,102,60
			fcb	0,96,108,120,120,108,102,0
			fcb	0,48,48,48,48,48,28,0
			fcb	0,0,54,127,127,107,99,0
			fcb	0,0,124,102,102,102,102,0
			fcb	0,0,60,102,102,102,60,0
			fcb	0,0,124,102,102,124,96,96
			fcb	0,0,62,102,102,62,6,7
			fcb	0,0,30,51,48,48,48,0
			fcb	0,0,62,96,60,6,124,0
			fcb	0,48,124,48,48,48,28,0
			fcb	212,224,224,224,224,224,224,192
			fcb	127,254,213,224,224,224,252,248
			fcb	0,0,31,39,74,85,72,87
			fcb	126,129,177,177,129,133,129,126
			fcb	0,0,120,124,46,86,14,86
			fcb	0,40,40,92,92,92,0,40
			fcb	0,30,24,112,24,24,30,0
			fcb	0,24,24,24,24,24,24,0
			fcb	0,240,48,28,48,48,240,0
			fcb	0,60,120,0,0,0,0,0
			fcb	60,66,153,161,161,153,66,60
	ELSE
font		fcb	$00,$00,$00,$00,$00,$00,$00,$00
			fcb	$00,$30,$30,$30,$30,$30,$00,$30
			fcb	$00,$30,$0C,$0C,$33,$30,$C0,$C0
			fcb	$0C,$3C,$3F,$F3,$FF,$F3,$F3,$3C
			fcb	$00,$CC,$FC,$FC,$3C,$CC,$0C,$F0
			fcb	$03,$03,$0F,$C3,$FF,$C3,$FF,$C3
			fcb	$3C,$FF,$3C,$3C,$FF,$3C,$00,$3C
			fcb	$3C,$CF,$FF,$FC,$F3,$CC,$F3,$3C
			fcb	$00,$0C,$30,$30,$30,$30,$0C,$00
			fcb	$00,$30,$0C,$0C,$0C,$0C,$30,$00
			fcb	$3C,$3C,$FF,$F3,$FC,$F3,$3C,$3C
			fcb	$30,$3C,$FC,$FF,$C3,$F3,$C3,$FC
			fcb	$00,$00,$00,$00,$00,$0C,$0C,$30
			fcb	$00,$00,$00,$00,$3C,$00,$00,$00
			fcb	$00,$00,$00,$00,$00,$00,$30,$00
			fcb	$0C,$3C,$3F,$FF,$C3,$CF,$C3,$3F
			fcb	$30,$FC,$CC,$CC,$CC,$FC,$30,$00
			fcb	$30,$F0,$F0,$30,$30,$FC,$FC,$00
			fcb	$F0,$FC,$0C,$30,$C0,$FC,$FC,$00
			fcb	$F0,$FC,$0C,$30,$0C,$FC,$F0,$00
			fcb	$CC,$CC,$CC,$FC,$0C,$0C,$0C,$00
			fcb	$3C,$FC,$C0,$F0,$0C,$FC,$F0,$00
			fcb	$3C,$FC,$C0,$FC,$CC,$FC,$30,$00
			fcb	$F0,$FC,$0C,$0C,$30,$C0,$C0,$00
			fcb	$30,$FC,$CC,$30,$CC,$FC,$30,$00
			fcb	$3C,$FC,$CC,$FC,$3C,$0C,$0C,$00
			fcb	$00,$00,$00,$30,$00,$00,$30,$00
			fcb	$00,$00,$00,$00,$00,$00,$00,$00
			fcb	$F0,$FC,$FF,$FF,$FF,$C3,$C3,$FF
			fcb	$00,$00,$00,$00,$00,$00,$00,$00
			fcb	$00,$3C,$00,$3C,$3C,$FF,$C3,$3C
			fcb	$3C,$0F,$0F,$0F,$0F,$0F,$0F,$3C
			fcb	$00,$3F,$CF,$3F,$CF,$3F,$CF,$3F
			fcb	$30,$FC,$0C,$FC,$FC,$CC,$CC,$00
			fcb	$F0,$FC,$0C,$F0,$CC,$FC,$F0,$00
			fcb	$3C,$FC,$00,$C0,$C0,$FC,$3C,$00
			fcb	$F0,$FC,$0C,$CC,$CC,$FC,$F0,$00
			fcb	$3C,$FC,$00,$F0,$C0,$FC,$3C,$00
			fcb	$3C,$FC,$00,$F0,$C0,$C0,$C0,$00
			fcb	$3C,$FC,$00,$CC,$CC,$FC,$3C,$00
			fcb	$CC,$CC,$0C,$FC,$CC,$CC,$CC,$00
			fcb	$FC,$FC,$00,$30,$30,$FC,$FC,$00
			fcb	$0C,$0C,$00,$0C,$0C,$FC,$F0,$00
			fcb	$CC,$CC,$30,$F0,$F0,$CC,$CC,$00
			fcb	$C0,$C0,$00,$C0,$C0,$FC,$3C,$00
			fcb	$CC,$FC,$0C,$CC,$CC,$CC,$CC,$00
			fcb	$F0,$FC,$0C,$CC,$CC,$CC,$CC,$00
			fcb	$30,$FC,$0C,$CC,$CC,$FC,$30,$00
			fcb	$F0,$FC,$0C,$FC,$F0,$C0,$C0,$00
			fcb	$30,$FC,$0C,$CC,$CC,$C0,$3C,$0C
			fcb	$F0,$FC,$0C,$FC,$F0,$CC,$CC,$00
			fcb	$3C,$FC,$00,$F0,$3C,$FC,$F0,$00
			fcb	$FC,$FC,$00,$30,$30,$30,$30,$00
			fcb	$CC,$CC,$0C,$CC,$CC,$FC,$3C,$00
			fcb	$CC,$CC,$0C,$CC,$CC,$30,$30,$00
			fcb	$CC,$CC,$0C,$CC,$CC,$FC,$CC,$00
			fcb	$CC,$CC,$30,$30,$30,$CC,$CC,$00
			fcb	$CC,$CC,$0C,$FC,$0C,$FC,$F0,$00
			fcb	$FC,$FC,$00,$0C,$30,$FC,$FC,$00
			fcb	$FC,$30,$30,$30,$30,$30,$30,$FC
			fcb	$00,$C0,$C0,$30,$30,$0C,$0C,$00
			fcb	$00,$F0,$30,$30,$30,$30,$F0,$00
			fcb	$30,$FC,$FC,$FC,$FC,$30,$0C,$30
			fcb	$00,$3F,$3F,$3F,$0C,$33,$00,$3F
			fcb	$00,$FF,$CF,$33,$CC,$F3,$3C,$0F
			fcb	$00,$00,$F0,$0C,$FC,$CC,$FC,$00
			fcb	$00,$C0,$C0,$F0,$CC,$CC,$FC,$00
			fcb	$FC,$03,$F3,$C3,$C3,$F3,$03,$FC
			fcb	$00,$0C,$0C,$3C,$CC,$CC,$FC,$00
			fcb	$00,$00,$3C,$CC,$FC,$C0,$FC,$00
			fcb	$00,$30,$C0,$F0,$C0,$C0,$C0,$00
			fcb	$00,$00,$3C,$CC,$CC,$FC,$0C,$F0
			fcb	$00,$C0,$C0,$F0,$CC,$CC,$CC,$00
			fcb	$00,$30,$00,$F0,$30,$30,$F0,$00
			fcb	$00,$0C,$00,$0C,$0C,$0C,$CC,$30
			fcb	$00,$C0,$CC,$F0,$F0,$CC,$CC,$00
			fcb	$00,$C0,$C0,$C0,$C0,$C0,$30,$00
			fcb	$00,$00,$30,$FC,$FC,$CC,$CC,$00
			fcb	$00,$00,$F0,$CC,$CC,$CC,$CC,$00
			fcb	$00,$00,$30,$CC,$CC,$CC,$30,$00
			fcb	$00,$00,$F0,$CC,$CC,$F0,$C0,$C0
			fcb	$00,$00,$3C,$CC,$CC,$3C,$0C,$0C
			fcb	$00,$00,$30,$CC,$C0,$C0,$C0,$00
			fcb	$00,$00,$3C,$C0,$30,$0C,$F0,$00
			fcb	$00,$30,$FC,$30,$30,$30,$0C,$00
			fcb	$CC,$F0,$F0,$F0,$F0,$F0,$F0,$C0
			fcb	$3F,$FF,$CC,$C0,$C0,$F0,$FC,$C0
			fcb	$00,$0F,$3F,$F3,$CF,$F3,$CF,$F3
			fcb	$3C,$C3,$F3,$F3,$C3,$C3,$C3,$3C
			fcb	$00,$30,$3C,$3F,$0F,$3F,$0F,$3F
			fcb	$0C,$3C,$0C,$FF,$3F,$FF,$0C,$3C
			fcb	$00,$3C,$30,$F0,$30,$30,$3C,$00
			fcb	$00,$30,$30,$30,$30,$30,$30,$00
			fcb	$00,$F0,$30,$3C,$30,$30,$F0,$00
			fcb	$00,$3C,$F0,$00,$00,$00,$00,$00
			fcb	$FC,$03,$F3,$C3,$C3,$F3,$03,$FC
	ENDIF
; ------------------------------------------------------------------------------------------------------------------------------------------
jTab																										; jtab   equ $
			fcb	249,250,251,254,254,255,255,255,0,0,0,1,1,1,2,2,6,7,6,15,16,99		; 		 	defb 249,250,251,254,254,255,255,255,0,0,0,1,1,1,2,2,6,7,6,15,16,99
																											; keys   defb 34,26,38,37,32,31,18,36,28,20,12
; ------------------------------------------------------------------------------------------------------------------------------------------
EndPgm	equ	*
GamDLen	equ	EndPgm-GameData
FreeRam	equ	$8000-EndPgm
