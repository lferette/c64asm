*= $0801 "Basic Upstart"		
	BasicUpstart($c000) // 10 sys$c000


* = $c000



	sei	
main:		
raster: 
	lda #150		//Wait for raster line 
	cmp $D012		
	bne raster+2	

	ldy #10		//Loose time to hide the
idle1:
	dey		//flickering at the beginning 
	bne idle1		//of the effect

//------------------------------------------------------------------
// Main Loop to print raster bars
//------------------------------------------------------------------
	ldx #00		
loop:
	lda colorTable,x	//assign background and border
	sta $d020		//colors
	sta $d021

	ldy delayTable,x	//Loose time to hide the
idle2:	
	dey		//flickering at the end
	bne idle2		//of the effect
	inx			//
	cpx #09
	bne loop
//------------------------------------------------------------------
// End of main loop
//------------------------------------------------------------------

	lda #$0e		//Assign default colors
	sta $d020
	lda #$06
	sta $d021
	
	jmp main

colorTable:
.byte 09,08,12,13,01,13,12,08,09

delayTable:
.byte 08,08,09,08,12,08,08,08,09
