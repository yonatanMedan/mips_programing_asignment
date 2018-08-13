.text
addi $t2,$zero,29
addi $t3,$zero,30

slt $at,$t2,$t3
beq $at,$zero,option1
add $t1,$t2,$zero
j continue
option1:add $t1,$t3,$zero
continue:
addi $v0,$zero,1
add $a0,$zero,$t1
syscall

addi $v0,$zero,10
syscall