.globl main
.eqv MT	100
.data
	Input:		.string"Input a number:\n"
	Output:		.string"The damage:\n"
.text

main:
	
	li x8, MT
	la a0, Input
	li a7, 4 		#print Input0 string
	ecall
	li a7,5 		#read input
	ecall
	bge a0, x8, End		#x>=100的話就結束
	
	jal f
	
	mv t0, a0		
	la a0, Output
	li a7, 4
	ecall
	mv a0, t0
	li a7, 1
	ecall
End:
	li a7, 10
	ecall
	
f:
	blt a0,x0 R6	#x < 0
	beq a0,x0, R1	#x == 0
	addi t0, a0, -1
	beqz t0,R5	#x == 1
	addi t0, t0, -10
	bltz t0, R21	#1 < x <= 10
	addi t0, t0, -10
	bltz t0, R23	#10 < x <= 20
	beqz zero, RD5	#x > 20
	
R1:
	addi a0, x0, 1
	ret
R5:
	addi a0, x0, 5
	ret
R6:
	addi a0, x0, -1
	ret	
	
R21:
	addi x2, x2, -8	   # 開stack
	sw a0, 0(x2)		# 存a0
	sw x1, 4(x2)		#存x1
	
	addi a0, a0, -1
	jal f		#f(x-1)
	
	lw t1, 0(x2)		#get  x
	sw a0, 0(x2)		#store f(x-1) 
	addi a0, t1, -2
	jal f		  #跳f(x-2)
	
	lw t1, 0(x2)		#get f(x-1)
	add a0, a0, t1		#f(x-2) + f(x-1)
	
	lw x1, 4(x2)		#要X1
	addi x2, x2, 8	   #還原stack
	ret
R23:
	addi x2, x2, -8	   # 開stack
	sw a0, 0(x2)		# 存a0
	sw x1, 4(x2)		#存x1
	
	addi a0, a0, -3
	jal f		#f(x-3)
	
	lw t1, 0(x2)		#get  x
	sw a0, 0(x2)		#store f(x-1) 
	addi a0, t1, -2
	jal f		#f(x-2)
	
	lw t1, 0(x2)		#get f(x-1)
	add a0, a0, t1		#f(x-2) + f(x-1)
	
	lw x1, 4(x2)		#要X1
	addi x2, x2, 8	 #還原stack
	ret
RD5:
	addi x2, x2, -8		# 開stack
	sw a0, 0(x2)		# 存a0
	sw x1, 4(x2)		#存x1
	
	addi t1, x0, 5
	div a0, a0, t1		#f(x/5)
	jal f
	
	lw t0, 0(x2)		#get x
	addi t1, x0, 2
	mul t0, t0, t1		#2x
	
	add a0, a0, t0		#把值給回a0
	
	lw ra, 4(x2)		#要X1
	addi x2, x2,8	   #還原stack
	ret

	