.data
Array1: .word 0X11090006,0xad490004,0x018d5820,0x032dc020,0x032dc021,0x018d5824,0x8d6d0000
.text
beq $t0,$t1,label1
sw $t1,4($t2)
add $t3,$t4,$t5
add $t8,$t9,$t5
addu $t8,$t9,$t5
and $t3,$t4,$t5
lw $t5,0($t3)
beq $t1,$t1,label1
add $0,$t0,$t1
lw $0,0($t3)
label1:

 

