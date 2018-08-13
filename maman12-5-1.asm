.data
theCode: .word 0X11090006,0xad490004,0x018d5820,0x032dc020,0x032dc021,0x018d5824,0x8d6d0000,0xffffffff
helperArr: .space 144 #initialize to maximum size (4 different commands+(32 registers (not all needed but doesnt add to much space to add them all)))*(2 bytes for descriptor +2 bytes for value) = (4+32)*4=144

#create an array of pointers to command counter addresses
Command_counter_Addresses_Array: .word R_type,l_w,s_w,b_eq
#create an array counters each coresponding to a register Register_counter_Array[0] coresponds to $0 Register_counter_Array[1] coresponds to $1 etc.
Register_counter_Array: .byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 
#command counters
R_type: .word 0
l_w: .byte 0
s_w: .byte 0
b_eq: .byte 0

#other string constants
newline: .asciiz "\n"
comma: .asciiz ","



.text
#variables: $t0: array index

main:
#loop throw theCode Array and count 
	addi $s0,$zero,0 #initialize the array index 
	countingLoop:
	##### the code printing the register numbers is used for test only!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!11
	lw $t0,theCode($s0)
	beq $t0,-1,End # if on last command finish loop (uses the fact that the last theCode array item is 0xffffffff)
	
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


#counts registers in R_type command
#params $a0: command code $a1 is shift
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
