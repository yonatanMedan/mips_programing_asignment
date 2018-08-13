.data
theCode: .word 0X11090006,0xad490004,0x018d5820,0x032dc020,0x032dc021,0x018d5824,0x8d6d0000,0xffffffff

#create an array of pointers to command counter addresses
Command_counter_Addresses_Array: .word R_type,l_w,s_w,b_eq
#create an array counters each coresponding to a register Register_counter_Array[0] coresponds to $0 Register_counter_Array[1] coresponds to $1 etc.
Register_counter_Array: .word 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1
#command counters
R_type: .word 0
l_w: .word 0
s_w: .word 0
b_eq: .word 0

#other string constants
newline: .asciiz "\n"
comma: .asciiz ","



.text
#variables: $t0: array index

main:
#loop throw theCode Array and count 
	addi $s0,$zero,0 #initialize the array index 
	countingLoop:
	
	

	lw $t0,theCode($s0)
	
	
	beq $t0,-1,End # if on last command finish loop (uses the fact that the last theCode array item is 0xffffffff)
	##### the code printing the register numbers is used for test only!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!11
	
	#if R type check if rd=0 and count registers of r type
	jal is_R_type
	#if beq check if registers are equal and increament beq counter then jump to i type counter logic
	
	#if lw check if rt=0 then increament lw counter then jump to i type counter logic
	
	#if sw increament sw counter then jump to i type counter logic
	
	lw $a0,theCode($s0)
	jal get_rs

	add $a0,$zero,$v0 
	li $v0,	1
	syscall 

	li $v0, 4     	#print string
	la $a0, comma   # load address of the comma string
	syscall
	
	lw $a0,theCode($s0)
	jal get_rt

	add $a0,$zero,$v0 
	li $v0,1
	syscall 
	
	li $v0, 4     	#print string
	la $a0, comma   # load address of the comma string
	syscall
	
	lw $a0,theCode($s0)
	jal get_rd
	
	
	add $a0,$zero,$v0 
	li $v0,1
	syscall 
	
	li $v0, 4     	#print string
	la $a0, comma   # load address of the comma string
	syscall
	
	lw $a0,theCode($s0)
	jal get_op_code
	
	add $a0,$zero,$v0 
	li $v0,1
	syscall 
	
	
	li $v0, 4     #print string
	la $a0, newline       # load address of the string
	##### the code printing the register numbers is used for test only!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!11
	syscall
	addi $s0,$s0,4
	j countingLoop


#return 1 for R type and 0 for other (in $v0)
#params $a0: instraction code
is_R_type:
	#pre
	addi $sp,$sp,-4 #mark space on stack
	sw $ra,0($sp) #save return addres
	#body
	jal get_op_code# $v0 gets to be the op_code field
	beq $v0,0,R_type_instraction #if R type branch to R_type_instraction
	#else (not R-type)
		addi $v0,$zero,0
		j end_is_R_type
	R_type_instraction:
		addi $v0,$zero,1
	#end
	end_is_R_type
	lw $ra,0($sp) #load return address
	addi $sp,$sp,4 #free stack space
	
	
#counts registers in R_type command
#params $a0: command code 
count_registers_in_R_type_command:
	#pre
	addi $sp,$sp,-4 #mark space on stack
	sw $ra,0($sp) #save return addres
	#body
	#get rs counter address
	#get rt counter address
	#get rd counter address
	#increment Register_counter_Array
	#end
	lw $ra,0($sp) #load returm addres
	addi $sp,$sp,4 #free stack space
	jr $ra #jump to return address

#get rs register code from command
#params $a0: command code
get_rs:
	addi $t0,$zero,0x03e00000 #loads rs location mask to $t0 (000000 11111 00000 00000 00000 000000)
	and $t0,$t0,$a0 #apply mask to command
	srl $v0,$t0,21 #shift right to get the desired rs code on responce
	jr $ra

#get rt register code from command
#params $a0: command code
get_rt:
	addi $t0,$zero,0x001f0000 #loads rt location mask to $t0 (000000 00000 11111 00000 00000 000000) 0x001f0000
	and $t0,$t0,$a0 #apply mask to command
	srl $v0,$t0,16 #shift right to get the desired rs code on responce
	jr $ra
	

#get rd register code from command
#params $a0: command code
get_rd:
	addi $t0,$zero,0x0000f800 #loads rt location mask to $t0 (000000 00000 00000 11111 00000 000000) 0x0000f800
	and $t0,$t0,$a0 #apply mask to command
	srl $v0,$t0,11 #shift right to get the desired rs code on responce
	jr $ra
	
#get opcode code from command
#params $a0: command code
get_op_code:
	addi $t0,$zero,0xfc000000 #loads rt location mask to $t0 (111111 00000 00000 00000 00000 000000) 0xfc000000
	and $t0,$t0,$a0 #apply mask to command
	srl $v0,$t0,26 #shift right to get the desired rs code on responce
	jr $ra
	
#get funct code from command
get_funct:
	addi $t0,$zero,0x00000003f #loads rt location mask to $t0 (111111 00000 00000 00000 00000 000000) 0xfc000000
	and $t0,$t0,$a0 #apply mask to command
	jr $ra
	
#maps regiter codes to counter address
#params $a0: register_num 
#returns $v0: address of counter
get_register_counter_address:
	la $v0,Register_counter_Array($a0)
	jr $ra

End:
li $v0,10
syscall
