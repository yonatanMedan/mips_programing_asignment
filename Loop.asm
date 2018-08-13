.data
	int: .word 24
	int2: .word 25
	finish: .asciiz "finished \n"
.text
	li $s0,100
	lw $s1,int
Loop:	beq $s0,$s1,Exit
	addi $s0,$s0,-1
	li $v0,1
	add $a0,$s0,$zero
	syscall
	j Loop

Exit:
	li $v0,4
	la $a0,finish
	syscall 