.data 
num1: .word -1,num3
num2: .word 17,0
num3: .word 32,num5
num4: .word -6,num2
num5: .word 1972,num4
partThreeMessage: .asciiz "Part Three Ansewer: \n"
comma: .asciiz  ","
minus: .ascii  "-"

.text 
main:
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
	beq $t1,0,endLoop 
	li $v0,4
	la $a0, comma
	syscall 


	  # if ($t1) next address is not 0 
	lw $t0,0($t1) #t0 update current value
	lw $t1,4($t1)
	j traverceListPrintBase4



endLoop:


li $v0,10
syscall
