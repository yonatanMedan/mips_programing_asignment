.data 
num1: .word -1,num3
num2: .word 17,0
num3: .word 32,num5
num4: .word -6,num2
num5: .word 1972,num4
partOneMessage: .asciiz "Part One Ansewer: \n"
partTwoMessage: .asciiz "Part Two Ansewer: \n"
partThreeMessage: .asciiz "Part Three Ansewer: \n"
partFourMessage: .asciiz "Part four Ansewer: \n"
newLine: .asciiz "\n"
comma: .asciiz  ","
minus: .ascii  "-"
.text
main:

########PART 1############################################################
#variables: $t0:current value, $t1:next address, $s0:the sum
# go throgh all list nodes thorgh list
	add $s0,$zero,$zero#$s0 is the sum variable initialize with zero
	lw $t0,num1 #$t0 current value
	lw $t1,num1+4 #$t1 next address

traverceListSum: #a loop that goes through the list and does arbitrary things with node
	add $s0,$s0,$t0 #add current value to sum
	beq $t1,0,endLoop  # if ($t1) next address is 0 end loop else: 
	lw $t0,0($t1) #update current value $t0  to the next word in the list
	lw $t1,4($t1) #update next address $t1  to the next address pointer
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

la $a0,newLine
li $v0,4
syscall
########End PART 1########################################################
########PART 2############################################################
# go throgh all list nodes thorgh list
	add $s0,$zero,$zero # $s0 is the sum variable initialize with zero
	lw $t0,num1 # $t0 current value
	lw $t1,num1+4 # $t1 next address

traverceListDivedebleBy4: #a loop that goes through the list and does arbitrary things with node
	ble $t0,$zero,goToNextNode#if less or equal to zero continue to next node in list
	andi $t2,$t0,3 # if the two right bits are zero then $t2 will be equal to 0 meaning that the number $t0 is diviseble by 4
	bne $t2,$zero, goToNextNode
	add $s0,$s0,$t0 #add current value to sum
	goToNextNode:
	beq $t1,0,endLoopPart2  # if ($t1) next address is not 0 
	lw $t0,0($t1) #t0 update current value
	lw $t1,4($t1) #t0 update next addres
	j traverceListDivedebleBy4


endLoopPart2:
#print part2  message
	li $v0,4 
	la $a0, partTwoMessage #load message to $a0 register
	syscall 
	
	
li $v0,1
add $a0,$s0,$zero
syscall 

la $a0,newLine 
li $v0,4
syscall
########End PART 2########################################################
########PART 3############################################################
# go throgh all list nodes thorgh list assumes list is not empty
	lw $t0,num1 # $t0 current value
	lw $t1,num1+4 # $t1 next address
 #print message
	li $v0,4
	la $a0, partThreeMessage
	syscall 
traverceListPrintBase4: #a loop that goes through the list 
	#print base4 number
	bge $t0,$zero,printNumber #if value>=0 continue printing the number
	li  $v0,4
	la $a0,minus
	syscall
	printNumber:
		abs $t0,$t0  #$t0 to be the absulut value of $t0
		clz $t3,$t0 #$t3 = number of trailing zeroes
		#the shift amount can be calculated by floor((31-trailing_zeroes)/2)*2
		li $t4,31
		sub $t3,$t4,$t3 # $t3 = 31-$t3
		div $t3,$t3,2 #$t3 = floor($t3/2)
		mulo $t3,$t3,2 #$t3 = $t3*2
		li $v0,1
		printNumberLoop:
			blt $t3,$zero,endPrintNumberLoop
			srlv $a0,$t0,$t3
			and $a0,$a0,3 #select the right most two bits
			sub $t3,$t3,2 #move shifting counter forward
			syscall
		j printNumberLoop
	 
	
	endPrintNumberLoop:
	beq $t1,0,endLoopPart3
	li $v0,4
	la $a0, comma
	syscall 


	  # if ($t1) next address is not 0 
	lw $t0,0($t1) #t0 update current value
	lw $t1,4($t1)
	j traverceListPrintBase4



endLoopPart3:
la $a0,newLine 
li $v0,4
syscall

########End PART 3########################################################
########PART 4############################################################
	lw $t0,num1 # $t0 current value
	lw $t1,num1+4 # $t1 next address
 #print message
	li $v0,4
	la $a0, partFourMessage
	syscall 
traverceListPrintBase4U: #a loop that goes through the list 
	#print base4 number unsigned
	printNumberPart4:
		clz $t3,$t0 #$t3 = number of trailing zeroes
		#the shift amount can be calculated by floor((31-trailing_zeroes)/2)*2
		li $t4,31
		sub $t3,$t4,$t3 # $t3 = 31-$t3
		div $t3,$t3,2 #$t3 = floor($t3/2)
		mulo $t3,$t3,2 #$t3 = $t3*2
		li $v0,1
		printNumberLoopPart4:
			blt $t3,$zero,endPrintNumberLoopPart4
			srlv $a0,$t0,$t3
			and $a0,$a0,3 #select the right most two bits
			sub $t3,$t3,2 #move shifting counter forward
			syscall
		j printNumberLoopPart4
	 
	
	endPrintNumberLoopPart4:
	beq $t1,0,endPart4Loop 
	li $v0,4
	la $a0, comma
	syscall 


	  # if ($t1) next address is not 0 
	lw $t0,0($t1) #t0 update current value
	lw $t1,4($t1) #t0 update next address
	j traverceListPrintBase4U



endPart4Loop:
########End PART 4########################################################

#exit
li $v0,10
syscall
