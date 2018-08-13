.data

.text
.globl main
main:
	subu $sp,$sp,4
	sw $ra,4($sp)
	addi $a0,$zero,3
	addi $a1,$zero,3
	jal sum
	addi $s0,$v0,3
	li $v0,1
	add $a0,$s0,$zero
	syscall
	j Exit


sum: 
	add $v0,$a1,$a0
	jr $ra

Exit:
li $v0 10
syscall