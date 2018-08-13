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
tableHead:.asciiz       "inst code/reg             appearances"
tableSpaces:.asciiz     "                               "
R_type_str:.asciiz      "R-type                           "
beq_str:.asciiz         "beq                              "
lw_str:.asciiz          "lw                               "
sw_str:.asciiz          "sw                               "
newline: .asciiz "\n"
comma: .asciiz ","
one_space:.asciiz " "
error_message:.asciiz "Insraction is not valid! ending program"


.text
#variables: $t0: array index

main:
#loop throw theCode Array and count 
	addi $s0,$zero,0 #initialize the array index 
	countingLoop:
	
	

	lw $t0,theCode($s0)
	
	
	beq $t0,-1,printTable # if on last command finish loop (uses the fact that the last theCode array item is 0xffffffff)
	##### the code printing the register numbers is used for test only!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!11
	
	#if R type check if rd=0 and count registers of r type and increament r type command counter
	lw $a0, theCode($s0)
	jal is_R_type #$v0 is 1 if R type 0 else 
	beq $v0,0,check_is_beq #if not r type continue
	#else:
		#increament counter
		lw $t1,R_type #load R_type counter to $t1
		addi $t1,$t1,1 #increment R_type counter
		sw $t1,R_type #store incremented counter
		lw $a0,theCode($s0) #load instraction code to param $a0 for procedure call
		jal count_registers_in_R_type_command #count registers in R-type
		j next_instraction
	#if beq check if registers are equal and increament beq counter then jump to i type counter logic
	check_is_beq:
	lw $a0, theCode($s0)
	jal is_beq #$v0 is 1 if insraction is beq else 0 
	beq $v0,0,check_is_lw #if not beq instraction to check other instractions
	#else:is beq
		#increament counter
		lw $t1,b_eq #load beq counter to $t1
		addi $t1,$t1,1 #incrementbeq counter
		sw $t1,b_eq #store incremented counter
		
		#check_same_registers and print message

		j count_i
	#if lw check if rt=0 then increament lw counter then jump to i type counter logic
	check_is_lw:
	lw $a0, theCode($s0)
	jal is_lw #$v0 is 1 if insraction is lw else 0 
	beq $v0,0,check_is_sw #if not lw instraction to check other instractions
		#else:
		#increament counter
		lw $t1,l_w #load lw counter to $t1
		addi $t1,$t1,1 #increment lw counter
		sw $t1,l_w #store incremented counter
		j count_i
	#if sw increament sw counter then jump to i type counter logic
	check_is_sw:
	lw $a0, theCode($s0)
	jal is_sw #$v0 is 1 if insraction is sw else 0 
	beq $v0,0,not_valid_inst #if not sw instraction then instraction is not valid (all valid options had been checked before)
		#else:
		#increament counter
		lw $t1,s_w #load lw counter to $t1
		addi $t1,$t1,1 #increment lw counter
		sw $t1,s_w #store incremented counter
		j count_i
	count_i:
	lw $a0,theCode($s0) #load instraction code to param $a0 for procedure call
	jal count_registers_in_I_type_command
	j next_instraction
	
	not_valid_inst:
	#print error message
	la $a0,error_message
	jal printStr
	j End#end program

	syscall
	next_instraction:
	addi $s0,$s0,4
	j countingLoop


printTable:
	jal printTableHead
	jal print_instraction_count_rows

	
	addi $s0,$zero,0 #inittialize loop counter to zero
	
	printTableRegisterLoop:
		lw $t0, Register_counter_Array($s0)
		beq $t0,-1,end_printTableRegisterLoop #if counter is -1 then its the end of the counter array
		beq $t0,0,next_regsiter #dont print counter set to zero
		sra $s1,$s0,2#divide by 4 to get the register code (devide by shifting to places to the left)
		move $a0,$s1
		jal printInt #print register code
		
		jal printSpaces	#print spaces
		#allign numbers (for register code with two digits)
		bge $s1,10,dont_add_space
			la $a0,one_space
			jal printStr
		
		dont_add_space:
		
		
		#print value of counter
		lw $a0, Register_counter_Array($s0)
		jal printInt
		
		jal printNewLine
		next_regsiter:
		addi $s0,$s0,4
		j printTableRegisterLoop
	end_printTableRegisterLoop:
	
j End


#counts register in rs_field
#params $a0: instraction code
count_rs:
	#pre
	addi $sp,$sp,-4 #mark space on stack
	sw $ra,0($sp) #save return addres
	#body
	jal get_rs #v0 gets to be rs register code
	move $a0,$v0 #saves register code stored in $v0 to $a0
	jal increament_register_counter #inceament regiter counter for the code stored in $a0
	#end
	lw $ra,0($sp) #load return address
	addi $sp,$sp,4 #free stack space
	jr $ra

#counts register in rt_field
#params $a0: instraction code
count_rt:
	#pre
	addi $sp,$sp,-4 #mark space on stack
	sw $ra,0($sp) #save return addres
	#body
	jal get_rt #v0 gets to be rs register code
	move $a0,$v0 #saves register code stored in $v0 to $a0
	jal increament_register_counter #inceament regiter counter for the code stored in $a0
	#end
	lw $ra,0($sp) #load return address
	addi $sp,$sp,4 #free stack space
	jr $ra

#counts register in rd_field
#params $a0: instraction code
count_rd:
	#pre
	addi $sp,$sp,-4 #mark space on stack
	sw $ra,0($sp) #save return addres
	#body
	jal get_rd #v0 gets to be rs register code
	move $a0,$v0 #saves register code stored in $v0 to $a0
	jal increament_register_counter #inceament regiter counter for the code stored in $a0
	#end
	lw $ra,0($sp) #load return address
	addi $sp,$sp,4 #free stack space
	jr $ra

#increament register at specified register code
#params $a0: register_code
increament_register_counter:
	#pre
	addi $sp,$sp,-4 #mark space on stack
	sw $ra,0($sp) #save return addres
	#body
	sll $t1,$a0,2
	lw $t0,Register_counter_Array($t1) #load register counter at given param
	addi $t0,$t0,1 #increament param
	sw $t0,Register_counter_Array($t1)#save register counter to given param
	#end
	lw $ra,0($sp) #load return address
	addi $sp,$sp,4 #free stack space
	jr $ra

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
	end_is_R_type:
	lw $ra,0($sp) #load return address
	addi $sp,$sp,4 #free stack space
	jr $ra
	
#return 1 for beq type and 0 for other (in $v0)
#params $a0: instraction code
is_beq:
	#pre
	addi $sp,$sp,-4 #mark space on stack
	sw $ra,0($sp) #save return addres
	#body
	jal get_op_code# $v0 gets to be the op_code field
	beq $v0,4,beq_instraction #if beq type branch to beq_instraction
	#else (not beq)
		addi $v0,$zero,0
		j end_is_beq
	beq_instraction:
		addi $v0,$zero,1
	#end
	end_is_beq:
	lw $ra,0($sp) #load return address
	addi $sp,$sp,4 #free stack space
	jr $ra
	
#return 1 for lw type and 0 for other (in $v0)
#params $a0: instraction code
is_lw:
	#pre
	addi $sp,$sp,-4 #mark space on stack
	sw $ra,0($sp) #save return addres
	#body
	jal get_op_code# $v0 gets to be the op_code field
	beq $v0,0x23,lw_instraction #if lw type branch to lw_instraction
	#else (not lw)
		addi $v0,$zero,0
		j end_is_lw
	lw_instraction:
		addi $v0,$zero,1
	#end
	end_is_lw:
	lw $ra,0($sp) #load return address
	addi $sp,$sp,4 #free stack space
	jr $ra
	
#return 1 for sw type and 0 for other (in $v0)
#params $a0: instraction code
is_sw:
	#pre
	addi $sp,$sp,-4 #mark space on stack
	sw $ra,0($sp) #save return addres
	#body
	jal get_op_code# $v0 gets to be the op_code field
	beq $v0,0x2b,sw_instraction #if sw type branch to sw_instraction
	#else (not sw)
		addi $v0,$zero,0
		j end_is_sw
	sw_instraction:
		addi $v0,$zero,1
	#end
	end_is_sw:
	lw $ra,0($sp) #load return address
	addi $sp,$sp,4 #free stack space
	jr $ra
	
#counts registers in R_type command
#params $a0: command code 
count_registers_in_R_type_command:
	#pre
	
	addi $sp,$sp,-8 #mark space on stack
	sw $ra,0($sp) #save return addres
	sw $s0,4($sp) #save $s0
	#body
	move $s0,$a0 #store $a0 for later use
	jal count_rs
	move $a0,$s0
	jal count_rt
	move $a0,$s0
	jal count_rd
	#end
	lw $s0,4($sp) #load $s0
	lw $ra,0($sp) #load returm addres
	addi $sp,$sp,8 #free stack space
	jr $ra #jump to return address
	
	
#counts registers in I_type command
#params $a0: command code 
count_registers_in_I_type_command:
	#pre
	
	addi $sp,$sp,-8 #mark space on stack
	sw $ra,0($sp) #save return addres
	sw $s0,4($sp) #save $s0
	#body
	move $s0,$a0 #store $a0 for later use
	jal count_rs
	move $a0,$s0
	jal count_rt
	#end
	lw $s0,4($sp) #load $s0
	lw $ra,0($sp) #load returm addres
	addi $sp,$sp,8 #free stack space
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
	
#prints the string stored in $a0
printStr:
	addi $v0,$zero,4
	syscall
	jr $ra
	
printInt:
	addi $v0,$zero,1
	syscall
	jr $ra
	
printNewLine:
	#pre
	addi $sp,$sp,-4 #mark space on stack
	sw $ra,0($sp) #save return addres
	#body
	la $a0,newline
	jal printStr
	#end
	lw $ra,0($sp) #load returm addres
	addi $sp,$sp,4 #free stack space
	jr $ra #jump to return address

printTableHead:
	#pre
	addi $sp,$sp,-4 #mark space on stack
	sw $ra,0($sp) #save return addres
	#body
	la $a0,tableHead
	jal printStr
	jal printNewLine
	#end
	lw $ra,0($sp) #load returm addres
	addi $sp,$sp,4 #free stack space
	jr $ra #jump to return address
	
printSpaces:
	#pre
	addi $sp,$sp,-4 #mark space on stack
	sw $ra,0($sp) #save return addres
	#body
	la $a0,tableSpaces
	jal printStr
	#end
	lw $ra,0($sp) #load return address
	addi $sp,$sp,4 #free stack space
	jr $ra #jump to return address
	
print_instraction_count_rows:
	#pre
	addi $sp,$sp,-4 #mark space on stack
	sw $ra,0($sp) #save return addres
	#body
	#print R-type row
	la $a0,R_type_str
	jal printStr
	lw $a0,R_type
	jal printInt
	jal printNewLine
	#print lw row
	la $a0,lw_str
	jal printStr
	lw $a0,l_w
	jal printInt
	jal printNewLine
	#print sw row
	la $a0,sw_str
	jal printStr
	lw $a0,s_w
	jal printInt
	jal printNewLine
	#print b_eq row
	la $a0,beq_str
	jal printStr
	lw $a0,b_eq
	jal printInt
	jal printNewLine
	#end
	lw $ra,0($sp) #load return address
	addi $sp,$sp,4 #free stack space
	jr $ra #jump to return address
End:
li $v0,10
syscall
