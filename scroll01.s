// basic scroll experiment
*= $0801 "Basic Upstart"		
	BasicUpstart($c000) // 10 sys$c000

.var screen = $0400	
	
* = $c000
start:	lda #$00
loop:	sta $d016
	ldx #$ff
!delay:	dex
	bne !delay-
	adc #$01
	and #$07
	sta $d020
	bne loop
	jmp start
	
