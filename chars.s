*= $0801 "Basic Upstart"		
	BasicUpstart($c000) // 10 sys$c000

*=$c000
main:
	ldx #$00
loop:
	txa
	sta 1024,x
	inx
	cpx #$ff
	bne loop
	rts