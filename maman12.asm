.data 
num1: .word -1,num3
num2: .word 17,0
num3: .word 32,num5
num4: .word -6,num2
num5: .word 1972,num4
partOneMessage: .asciiz "Part One Ansewer: \n"

.text
# go throgh all list nodes thorgh list
	add $s0,$zero,$zero#$s0 is the sum variable initialize with zero
	lw $t0,num1 #t0 current value
	lw $t1,num1+4 #t1 next address

traverceListSum: #a loop that goes through the list and does arbitrary things with node
	add $s0,$s0,$t0 #add current value to sum
	beq $t1,0,endLoop  # if ($t1) next address is not 0 
	lw $t0,0($t1) #t0 update current value
	lw $t1,4($t1)
	j traverceListSum

endLoop:
#print message
li $v0,4
la $a0, partOneMessage
syscall 
#print sum
li $v0,1
add $a0,$s0,$zero
syscall 

#exit
li $v0,10
syscall
