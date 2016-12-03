// This program dumps a page in memory continuously
// thanks to an itnerrupt routine synchronised with the rqster.
// Page number is held in $bb (188). Change it by poke 188,n
.var page = $bb

*= $0801 "Basic Upstart"		
	BasicUpstart($c000) // 10 sys$c000
	
* = $c000
	//compiled program will reside on memory start from $c000 
	//can be executed by writing sys 49152

	lda #$93
	jsr $ffd2	// call chrout to print clear screen char
	
	lda #$00	// start with page 0
	sta page
	sta page+1

	// set interrupt vector
	sei
	
	ldy #$7f
	sty $dc0d	// Disable CIA (1)
	sty $dd0d	// Disable CIA (2)
	lda $dc0d	// cancel in-queue interrupts
	lda $dd0d	// ditto
	
	lda #$01
	sta $d01a	// Enable raster interrupts
	
	lda #$00
	sta $d012	// Interrupt on raster line 0
	lda $d011
	and #$7f
	sta $d011	// make sure bit 8 of $d011 is 0 (=bit 9 of $d012)
	
	lda #<irq
	sta $0314
	lda #>irq
	sta $0315
	cli

	rts

count:	.byte $00	// holds our byte counter 

irq:
	dec $d019	// ack irq
	ldy count	// get where we are
	lda (page),y	// get memory content in .a
	sta $0400,y	// and dump it on the screen
	iny
	sty count
//	rts
	jmp $ea31
