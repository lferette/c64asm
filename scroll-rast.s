// This program wobbles the screen continuously
// thanks to an itnerrupt routine synchronised with the raster.
.var page = $bb
.var valcount = $0d

*= $0801 "Basic Upstart"		
	BasicUpstart($c000) // 10 sys$c000
	
* = $c000
	//compiled program will reside on memory start from $c000 
	//can be executed by writing sys 49152

//	lda #$93
//	jsr $ffd2	// call chrout to print clear screen char
	
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

irq:
	dec $d019	// ack irq
	ldx count
	lda vals,x
	sta $d016
	dex
	bne end
	ldx #valcount
end:	stx count
	jmp $ea31

count:	.byte valcount	// holds our byte counter 
vals:	.byte $00,$01,$02,$03,$04,$05,$06
	.byte $07,$06,$05,$04,$03,$02,$01