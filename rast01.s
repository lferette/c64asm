*= $0801 "Basic Upstart"		
	BasicUpstart($c000) // 10 sys$c000


* = $c000

.var counter = $02
.var scanline = $03

	lda #50
	sta scanline

	jsr clear_screen
	jsr set_irq

	jmp *

//----------------------------------------------------------
// CLEAR SCREEN
//----------------------------------------------------------
clear_screen:	
	lda #$20
	ldx #00
l:	sta $0400,x
	sta $0500,x
	inx
	bne l
	rts 

//--------------------------------------------------------
// SET IRQ
//--------------------------------------------------------
set_irq: sei

	lda #$7f	//Disable CIA I and CIA II interrupts
	sta $dc0d

	lda $d01a	//Enable raster interrupts
	ora #$01
	sta $d01a

	lda #$00
	sta $dc0e
	
	lda #48		//set raster line
	sta $d012
	lda $d011
	and #$7f	//%01111111
	sta $d011
		
	lda #<irq	//set interrupt handler
	sta $0314
	lda #>irq
	sta $0315
 
	cli
	
	rts

//---------------------------------------------------------
// IRQ 
//---------------------------------------------------------
//.namespace irq1 {
irq:
	ldx #03		//wait for new line
m:	dex
	bne m

	ldx #00		//reset counter
!next:	lda colors,x	
	sta $d020
	sta $d021

	ldy delay,x		//grab delay value and
!wait:	dey			//wait for end of line
	bne !wait-

	inx			//compare x with
	cpx #200	//number of bars and
	bne !next-	//loop for next bar

	ldx #03		//wait for new line
n:	dex
	bne n

	lda #00		//reset colors
	sta $d020
	sta $d021

	jsr calc	//calculate the effect	

!end:	asl $d019	//acknowledge interrupt register
	jmp $ea81

//}
//----------------------------------------------------------
// CALCULATE
//----------------------------------------------------------
calc:
	lda counter		//if counter = 100	
	cmp #30		//reset counter
	bne o

	lda #00
	sta counter

o:	adc #100	//x = counter+100
	tax

	lda #11
	sta colors,x

	inc counter

!end:	rts

//----------------------------------------------------------
// Data
//----------------------------------------------------------

delay:	.byte 8,8,2,6,8,8,9,8
		.byte 8,8,2,6,8,8,9,8
		.byte 8,8,2,6,8,8,9,8
		.byte 8,8,2,6,8,8,9,8
		.byte 8,8,2,6,8,8,9,8
		.byte 8,8,2,6,8,8,9,8
		.byte 8,8,2,6,8,8,9,8
		.byte 8,8,2,6,8,8,9,8
		.byte 8,8,2,6,8,8,9,8
		.byte 8,8,2,6,8,8,9,8
		.byte 8,8,2,6,8,8,9,8
		.byte 8,8,2,6,8,8,9,8
		.byte 8,8,2,6,8,8,9,8
		.byte 8,8,2,6,8,8,9,8
		.byte 8,8,2,6,8,8,9,8
colors:	.fill 200, 00