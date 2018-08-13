#writer: yonatan medan date: 13/8/2018
.data 
#the linked list
num1: .word -1,num3
num2: .word 17,0
num3: .word 32,num5
num4: .word -6,num2
num5: .word 1972,num4
#string constants
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
##initialize variables
add $s0,$zero,$zero#$s0 is the sum variable initialize with zero
lw $t0,num1 #$set $t0 to be the current value of the linked list 
lw $t1,num1+4 #set $t1 to be the address of the next node in the list

traverceListSum: #a loop that goes through the list and sums all node value sin register $s0
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

#print new line
la $a0,newLine
li $v0,4
syscall
########End PART 1########################################################
########PART 2############################################################
##initialize variables
add $s0,$zero,$zero # $s0 is the sum variable initialize with zero
lw $t0,num1 # $t0 current value
lw $t1,num1+4 # $t1 next address

traverceListDivedebleBy4: #a loop that goes through the list sums numbers devideble by 4 and positive
	ble $t0,$zero,goToNextNode#if less or equal to zero continue to next node in list
	andi $t2,$t0,3 #check if the two right bits are zero by applying an and mask to the to right bits 
	bne $t2,$zero, goToNextNode #if $t2 is not zero then one of the 2 right most bits of $t0 (the current list value) is 1 this means that the number is deviseble by 4
	#else the right most bit are zero, this means that the number is deviseble by 4
	add $s0,$s0,$t0 #add current value to sum
	goToNextNode:
	beq $t1,0,endLoopPart2  # if ($t1) next address is zero end loop
	#else:
	lw $t0,0($t1) #t0 update current value
	lw $t1,4($t1) #t0 update next addres
	j traverceListDivedebleBy4


endLoopPart2:
#print part2  message
li $v0,4 
la $a0, partTwoMessage #load message to $a0 register
syscall 
	
#print sum
li $v0,1
add $a0,$s0,$zero
syscall 

#print new line
la $a0,newLine 
li $v0,4
syscall

########End PART 2########################################################
########PART 3############################################################
##initialize variables
	lw $t0,num1 # $t0 current value
	lw $t1,num1+4 # $t1 next address
 #print message
	li $v0,4
	la $a0, partThreeMessage
	syscall 
traverceListPrintBase4: #a loop that goes through the list and prints the numbers in base 4 siged
	#print base4 number
	bge $t0,$zero,printNumber #if value>=0 continue printing the number
	#else print minus char ('-')
	li  $v0,4
	la $a0,minus
	syscall
	
	printNumber:
		abs $t0,$t0  #$t0 to be the absolut value of $t0
		#we need to print the first digit from the left first and we dont wont to print zeroes.we can do it by counting the amount to shift right so we get only the two
		#bits of the most segnificant number.
		clz $t3,$t0 #$t3 = number of trailing zeroes to the left
		#the shift amount can be calculated by floor((31-trailing_zeroes)/2)*2
		li $t4,31 #load the number 31 to $t4
		sub $t3,$t4,$t3 # $t3 = 31-$t3
		div $t3,$t3,2 #$t3 = floor($t3/2)
		mulo $t3,$t3,2 #$t3 = $t3*2 $t3 is now the number if shift we need to the right in order to get the first digit in 4 base
		
		li $v0,1 #load syscall 1 (print int) (will not be changed untill the number is fully printed)
		
		printNumberLoop:# loops all the digits of the number and prints them in base 4 by shifting the number 2 bits at a time 
			blt $t3,$zero,endPrintNumberLoop  #if shift amount is less then zero stop printing
			srlv $a0,$t0,$t3 #store in $a0,$t0 shifted by the amount stored in $t3.
			and $a0,$a0,3 #select the right most two bits to be printed
			sub $t3,$t3,2 #decrement the shifting amount (to get the next digit)
			syscall #print int
		j printNumberLoop
	 
	
	endPrintNumberLoop:
	beq $t1,0,endLoopPart3 #if $t1 is 0 then ther is no more nodes we can end the loop
	#else print comma and go to next node
	li $v0,4
	la $a0, comma
	syscall 

	lw $t0,0($t1) #t0 updated to current value
	lw $t1,4($t1)  #t1 updated to next address 
	j traverceListPrintBase4



endLoopPart3:
#print new line
la $a0,newLine 
li $v0,4
syscall

########End PART 3########################################################
########PART 4############################################################
##initialize variables
	lw $t0,num1 # $t0 current value
	lw $t1,num1+4 # $t1 next address
 #print message
	li $v0,4
	la $a0, partFourMessage
	syscall 
traverceListPrintBase4U: #loop the list and print the node values unsigned in 4 base 
	#print base4 number unsigned
	printNumberPart4: 
		#we need to print the first digit from the left first and we dont wont to print zeroes.we can do it by counting the amount to shift right so we get only the two
		#bits of the most segnificant number.
		clz $t3,$t0 #$t3 = number of trailing zeroes
	
		#the shift amount can be calculated by floor((31-trailing_zeroes)/2)*2 
		li $t4,31 #load 31 to register $t4
		sub $t3,$t4,$t3 # $t3 = 31-$t3
		div $t3,$t3,2 #$t3 = floor($t3/2)
		mulo $t3,$t3,2 #$t3 = $t3*2
		li $v0,1
		printNumberLoopPart4:
			blt $t3,$zero,endPrintNumberLoopPart4
			srlv $a0,$t0,$t3 #store in $a0,$t0 shifted by the amount stored in $t3.
			and $a0,$a0,3 #select the right most two bits
			sub $t3,$t3,2 #decrement the shifting amount (to get the next digit)
			syscall
		j printNumberLoopPart4
	 
	
	endPrintNumberLoopPart4:#if $t1 is 0 then there is no more nodes we can end the loop
	#else print comma and go to next node
	beq $t1,0,endPart4Loop 
	li $v0,4
	la $a0, comma
	syscall 
	lw $t0,0($t1) #t0 update current value
	lw $t1,4($t1) #t0 update next address
	j traverceListPrintBase4U



endPart4Loop:
########End PART 4########################################################

#exit
li $v0,10
syscall
