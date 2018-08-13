.text
nextCh: lb $t0,-3($t2)
	beq $t0,$zero,strEnd
	add $t9,$t9,$t0
	addi $t2,$t2,-12
	j nextCh
strEnd: