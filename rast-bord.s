.pc = $801 "BASIC"
:BasicUpstart(49152)

* = $c000 "Raster"
	lda #$00
	sta $3fff	// prevent junk from going in the border

	sei	// Don't interrupt me
	
	ldy #$7f	// y<-%01111111
	sty $dc0d	// Turn off CIA timer int
	sty $dd0d	// Turn off CIA timer int
	lda $dc0d	// cancel CIA in queue
	lda $dd0d	// cancel CIA in queue
	
	lda #$01	// set int req mask
	sta $d01a	// to raster interrupts
	
	// initialise IRQ routine pointer
	lda #<irq
	ldx #>irq
	sta $314
	stx $315
	
	lda #$f9	// first interrupt at line 249
	sta $d012
	lda $d011
	and #$7f	// clear high-bit of $d012 (not a typo)
	sta $d011
	
	cli		// re-enable interrupts
	rts
	
// interrupt routine
irq:
	lda modeflag
	beq mode1
	jmp mode2

mode1:	
	inc modeflag	// flip flag
	
	// open border: set 24-row mode
	lda $d011
	and #$f7
	sta $d011

	// set next interrupt at line 255
	lda #$ff
	sta $d012
	
	dec $d019	// ack interrupt
//	sta $d019
	
	jmp $ea31	// go to standard irq treatment
	
mode2:
	dec modeflag	// flip flag		

	// turn back to 25-row mode
	lda $d011
	ora #$08
	sta $d011

	lda #$f9	// set up for next round (irq at line 249)
	sta $d012

	dec $d019	// ack interrupt
//	sta $d019
	
	// exit from irq
	pla
	tay
	pla
	tax
	pla
	rti

modeflag:	.byte $00
	