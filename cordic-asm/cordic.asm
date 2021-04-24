		.data
INPUT:		.asciiz "Input angle from -pi/2 do pi/2, multiplied by 2^30\n"
INPUT_ERR:	.asciiz "You provided wrong angle\n"
SIN_OUT:	.asciiz "\nsin = "
COS_OUT:	.asciiz "\ncos = "
SCALE_INFO:	.asciiz "\nAnswers are multiplied by 2^30. Divide them to get actual value.\n"

SCALE:		.word 0x40000000
K_CONST:	.word 0x26DD3B6A
ATAN_ANGLES:	.word 0x3243f6a8, 0x1dac6705, 0x0fadbafc, 0x07f56ea6, 0x03feab76, 0x01ffd55b, 0x00fffaaa, 0x007fff55, 0x003fffea, 0x001ffffd, 0x000fffff, 0x0007ffff, 0x0003ffff, 0x0001ffff, 0x0000ffff, 0x00007fff, 0x00003fff, 0x00001fff, 0x00000fff, 0x000007ff, 0x000003ff, 0x000001ff, 0x000000ff, 0x0000007f, 0x0000003f, 0x0000001f, 0x0000000f, 0x00000008, 0x00000004, 0x00000002, 0x00000001, 0x00000000

		.text
		.globl main
main:
		li $v0, 4
		la $a0, INPUT
		syscall
		
		li $v0, 5
		syscall
		
		bgt $v0, 1686629713, exiterr
		blt $v0, -1686629713, exiterr
		
cordic:		
		lw $t0, K_CONST		# x = K_CONST;
		li $t1, 0		# y = 0;
		move $t2, $v0		# z = angle;
		li $t3, 0		# i = 0;
		la $t4, ATAN_ANGLES	# pointer to atan table
loop:		
		srav $s0, $t1, $t3	# dx = y >> i;
		srav $s1, $t0, $t3	# dy = x >> i;
		lw $s2, ($t4)		# dz = ATAN_ANGLES[i];
		bltz $t2, else
		
		sub $t0, $t0, $s0	# x -= dx;
		add $t1, $t1, $s1 	# y += dy
		sub $t2, $t2, $s2	# z -= dz
		b loop_end
		
else:
		add $t0, $t0, $s0	# x += dx;
		sub $t1, $t1, $s1 	# y -= dy
		add $t2, $t2, $s2	# z += dz
loop_end:
		addi $t3, $t3, 1
		addi $t4, $t4, 4
		bne $t3, 32, loop

output:
		li $v0, 4
		la $a0, SIN_OUT
		syscall
		
		li $v0, 1
		move $a0, $t1
		syscall
		
		li $v0, 4
		la $a0, COS_OUT
		syscall
		
		li $v0, 1
		move $a0, $t0
		syscall
		
		li $v0, 4
		la $a0, SCALE_INFO
		syscall
		
		li $v0, 10
		syscall
		
exiterr:
		li $v0, 4
		la $a0, INPUT_ERR
		syscall
		
		li $v0, 10
		syscall