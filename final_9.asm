.data 
	# Store pattern in memory

	line1:  .asciiz "                                          ************* \n"
	line2:  .asciiz "**************                           *3333333333333*\n"
	line3:  .asciiz "*222222222222222*                        *33333******** \n"
	line4:  .asciiz "*22222******222222*                      *33333*        \n"
	line5:  .asciiz "*22222*      *22222*                     *33333******** \n"
	line6:  .asciiz "*22222*        *22222*    *************  *3333333333333*\n"
	line7:  .asciiz "*22222*        *22222*  **11111*****111* *33333******** \n"
	line8:  .asciiz "*22222*        *22222* **1111**      **  *33333*        \n"
	line9:  .asciiz "*22222*       *222222* *1111*            *33333******** \n"
	line10: .asciiz "*22222*******222222*  *11111*            *3333333333333*\n"
	line11: .asciiz "*2222222222222222*    *11111*             ************* \n"
	line12: .asciiz "***************       *11111*                           \n"
	line13: .asciiz "      ---              *1111**                          \n"
	line14: .asciiz "    / o o \\            *1111****   *****                \n"
	line15: .asciiz "    \\   > /             **111111***111*                 \n"
	line16: .asciiz "     -----                 ***********   dce.hust.edu.vn\n" 
	lines: .word line1, line2, line3, line4, line5, line6, line7, line8, line9, line10, line11, line12, line13, line14, line15, line16
	bound1: .word 21
	bound2: .word 42
	
.text
	# Main part of the program: to call the functions
	.globl main
    	main:
    	   		li $s0, '8'
    			li $s1, '9'
    			li $s2, '5'
			jal print
			j end
	
	
	
	# Function: print()
	# Goal: Print the whole pattern to the console
	#-------------------
	# Input: none
	# Output: the whole pattern
	print:
			# Save the previous registers in stack
			addi $sp, $sp, -36
			sw $t0, 0($sp)
			sw $t1, 4($sp)
			sw $t2, 8($sp)
			sw $t3, 12($sp)
			sw $v0, 16($sp)
			sw $a0, 20($sp)
			sw $ra, 24($sp)
			sw $t4, 28($sp)
			sw $t5, 32($sp)
			
			# Initialization
			la $t0, lines # Address of array that store address of all lines
        			li $t1, 16 # Line limit
	        		li $t2, 0 # Line iterator
	
	# Print loop
	prl_loop:
			# If line iterator reach line limit, go to the end of this function
			beq $t2, $t1, end_print
			# Load address of a line
    			lw $t3, 0($t0)
    			
    			# Print the pattern in standard sequence
    			jal ecd_D
			jal ecd_C
			jal ecd_E
			jal ecd_line_j
    		
			
			# Increase the variables
    			addi $t0, $t0, 4 # Go to next line
    			addi $t2, $t2, 1 # Increase the line iterator
    			j prl_loop
	end_print:
			# Restore the variables from stack and exit the function
			lw $t0, 0($sp)
			lw $t1, 4($sp)
			lw $t2, 8($sp)
			lw $t3, 12($sp)
			lw $v0, 16($sp)
			lw $a0, 20($sp)
			lw $ra, 24($sp)
			lw $t4, 28($sp)
			lw $t5, 32($sp)
			addi $sp, $sp, 36
			jr $ra
	
	
	
	# Function: ecd()
	# Goal: Print the whole pattern to the console in pattern ECD (instead of original's DCE pattern)
	#-------------------
	# Input: none
	# Output: the pattern ECD (reverse pattern of first and last letters' patterns)
	ecd:
			# Save the previous registers in stack
			addi $sp, $sp, -36
			sw $t0, 0($sp)
			sw $t1, 4($sp)
			sw $t2, 8($sp)
			sw $t3, 12($sp)
			sw $v0, 16($sp)
			sw $a0, 20($sp)
			sw $ra, 24($sp)
			sw $t4, 28($sp)
			sw $t5, 32($sp)
			
			# Initialization
			la $t0, lines # Address of array that store address of all lines
        			li $t1, 16 # Line limit
        			li $t2, 0 # Line iterator
	ecd_loop:
			# If line iterator reach line limit, go to the end of this function
			beq $t2, $t1, ecd_end
			# Load address of each line in $t3
    			lw $t3, 0($t0) 
			
			# Print the pattern in sequence
			jal ecd_E
			jal ecd_C
			jal ecd_D
			jal ecd_line_j
			jal ecd_next_loop
		# This is the start of printing the ECD pattern
		# This part is to print "E" pattern first
		ecd_E:
			# The start of "E" pattern, also iterator
			li $t5, 41
			
			# Add the stack
			addi $sp, $sp, -4
			sw $ra, 0($sp)
			
			# A loop to print the part
			ecd_E_line:
				# If reach limit, go to print next pattern
				beq $t5, 56, ecd_E_end
				# The address of the character we want to print
				add $t6, $t3, $t5 
				
				# Load and print the character
				lb $t4, 0($t6)
				li $v0, 11
				add $a0, $zero, $t4
				syscall
				
				# Increase iterator and repeat the loop
				addi $t5, $t5, 1
				j ecd_E_line
			ecd_E_end:
				lw $ra, 0($sp)
				addi $sp, $sp, 4
				jr $ra
    	
		# This part is to print "C" pattern 		
		ecd_C:
			# Print the space character to split the symbol
			li $v0, 11
			li $a0, ' '
			syscall
			
			# The start of "C" pattern, also iterator
			li $t5, 22
			
			# Add the stack
			addi $sp, $sp, -4
			sw $ra, 0($sp)
			
			# A loop to print the part
			ecd_C_line:
				# If reach limit, go to print next pattern
				beq $t5, 40, ecd_C_end 
				# The address of the character we want to print
				add $t6, $t3, $t5 
				
				# Load and print the character
				lb $t4, 0($t6)
				li $v0, 11
				add $a0, $zero, $t4
				syscall
				
				# Increase iterator and repeat the loop
				addi $t5, $t5, 1
				j ecd_C_line
			ecd_C_end:
				# Print the space character to split the symbol
				li $v0, 11
				li $a0, ' '
				syscall
				lw $ra, 0($sp)
				addi $sp, $sp, 4
				jr $ra
			
		# This part is to print "D" pattern	
		ecd_D:
			# The start of "D" pattern, also iterator
			li $t5, 0
			
			# Add the stack
			addi $sp, $sp, -4
			sw $ra, 0($sp)
			
			# A loop to print the part
			ecd_D_line:
				# If reach limit, go to print end pattern of each line
				beq $t5, 22, ecd_D_end 
				# The address of the character we want to print
				add $t6, $t3, $t5 
				
				# Load and print the character
				lb $t4, 0($t6)
				li $v0, 11
				add $a0, $zero, $t4
				syscall
				
				# Increase iterator and repeat the loop
				addi $t5, $t5, 1
				j ecd_D_line
			ecd_D_end:
				lw $ra, 0($sp)
				addi $sp, $sp, 4
				jr $ra
		
		# Print the line breaker, and go to next line
		ecd_line_j:
			li $v0, 11
			li $a0, '\n'
			syscall
			jr $ra
		ecd_next_loop:
    			addi $t0, $t0, 4
    			addi $t2, $t2, 1
    			j ecd_loop
	ecd_end:
			# Restore the variables from stack and exit the function
			lw $t0, 0($sp)
			lw $t1, 4($sp)
			lw $t2, 8($sp)
			lw $t3, 12($sp)
			lw $v0, 16($sp)
			lw $a0, 20($sp)
			lw $ra, 24($sp)
			lw $t4, 28($sp)
			lw $t5, 32($sp)
			addi $sp, $sp, 36
			jr $ra

	
	# Function: rplc($s0, $s1, $s2)
	# Goal: Print the whole pattern to the console in DCE pattern with designated color
	#-------------------
	# Input: $s0: Color of D, $s1: Color of C, $s2: Color of E
	# Output: the standar pattern with new color
	rplc:
			# Save the previous registers in stack
			addi $sp, $sp, -60
			sw $t0, 0($sp)
			sw $t1, 4($sp)
			sw $t2, 8($sp)
			sw $t3, 12($sp)
			sw $v0, 16($sp)
			sw $a0, 20($sp)
			sw $ra, 24($sp)
			sw $t4, 28($sp)
			sw $t5, 32($sp)
			sw $t6, 36($sp)
			sw $s3, 40($sp)
			sw $s4, 44($sp)
			sw $s5, 48($sp)
			sw $s6, 52($sp)
			sw $s7, 56($sp)

			# Initialization
			la $t0, lines # Address of array that store address of all lines
        		li $t1, 16 # Line limit
        		li $t2, 0 # Line iterator
	rplc_loop:
			# If line iterator reach line limit, go to the end of this function
			beq $t2, $t1, rplc_end
			# Load address of each line in $t3
    			lw $t3, 0($t0)
    			 
    			#ACSII bounds of digits
    			li $s6, 48
    			li $s7, 57
			
			# Print the pattern in sequence
			jal rplc_D
			jal rplc_C
			jal rplc_E
			jal rplc_line_j
			jal rplc_next_loop
		# This is the start of printing the ECD pattern
		# This part is to print "E" pattern first
		rplc_E:
			# The start of "E" pattern, also iterator
			li $t5, 41
			
			# Add the stack
			addi $sp, $sp, -4
			sw $ra, 0($sp)
			
			# A loop to print the part
			rplc_E_line:
				# If reach limit, go to print next pattern
				beq $t5, 56, rplc_E_end
				# The address of the character we want to print
				add $t6, $t3, $t5 
				
				# Load the character
				lb $t4, 0($t6)
				sle $s3, $t4, $s7 # $t4 <= 57 ?
				sle $s4, $s6, $t4 # 48 <= $t4 ?
				and $s5, $s3, $s4 # ($t4 <= 57) & (48 <= $t4), in word: is the character digits?
				
				beqz $s5, j_next_E # If it is not a digit, skip the replacement
				jal key_replace_E
				
				j_next_E: 
					li $v0, 11
					add $a0, $zero, $t4
					syscall
				
				# Increase iterator and repeat the loop
				addi $t5, $t5, 1
				j rplc_E_line
			rplc_E_end:
				lw $ra, 0($sp)
				addi $sp, $sp, 4
				jr $ra
    	
		# This part is to print "C" pattern 		
		rplc_C:
			# Print the space character to split the symbol
			li $v0, 11
			li $a0, ' '
			syscall
			
			# The start of "C" pattern, also iterator
			li $t5, 22
			
			# Add the stack
			addi $sp, $sp, -4
			sw $ra, 0($sp)
			
			# A loop to print the part
			rplc_C_line:
				# If reach limit, go to print next pattern
				beq $t5, 40, rplc_C_end 
				# The address of the character we want to print
				add $t6, $t3, $t5 
				
				# Load and print the character
				lb $t4, 0($t6)
				sle $s3, $t4, $s7 # $t4 <= 57 ?
				sle $s4, $s6, $t4 # 48 <= $t4 ?
				and $s5, $s3, $s4 # ($t4 <= 57) & (48 <= $t4), in word: is the character digits?
				
				beqz $s5, j_next_C # If it is not a digit, skip the replacement
				jal key_replace_C
				
				j_next_C: 
					li $v0, 11
					add $a0, $zero, $t4
					syscall
				
				# Increase iterator and repeat the loop
				addi $t5, $t5, 1
				j rplc_C_line
			rplc_C_end:
				# Print the space character to split the symbol
				li $v0, 11
				li $a0, ' '
				syscall
				lw $ra, 0($sp)
				addi $sp, $sp, 4
				jr $ra
			
		# This part is to print "D" pattern	
		rplc_D:
			# The start of "D" pattern, also iterator
			li $t5, 0
			
			# Add the stack
			addi $sp, $sp, -4
			sw $ra, 0($sp)
			
			# A loop to print the part
			rplc_D_line:
				# If reach limit, go to print end pattern of each line
				beq $t5, 22, rplc_D_end 
				# The address of the character we want to print
				add $t6, $t3, $t5 
				
				# Load and print the character
				lb $t4, 0($t6)
				sle $s3, $t4, $s7 # $t4 <= 57 ?
				sle $s4, $s6, $t4 # 48 <= $t4 ?
				and $s5, $s3, $s4 # ($t4 <= 57) & (48 <= $t4), in word: is the character digits?
				
				beqz $s5, j_next_D # If it is not a digit, skip the replacement
				jal key_replace_D
				
				j_next_D: 
					li $v0, 11
					add $a0, $zero, $t4
					syscall
				
				# Increase iterator and repeat the loop
				addi $t5, $t5, 1
				j rplc_D_line
			rplc_D_end:
				lw $ra, 0($sp)
				addi $sp, $sp, 4
				jr $ra
		
		# Print the line breaker, and go to next line
		rplc_line_j:
			li $v0, 11
			li $a0, '\n'
			syscall
			jr $ra
		rplc_next_loop:
    			addi $t0, $t0, 4
    			addi $t2, $t2, 1
    			j rplc_loop
    		key_replace_D:
    			add $t4, $zero, $s0
    			jr $ra
    		key_replace_C:
    			add $t4, $zero, $s1
    			jr $ra
    		key_replace_E:
    			add $t4, $zero, $s2
    			jr $ra
	rplc_end:
			# Restore the variables from stack and exit the function
			lw $t0, 0($sp)
			lw $t1, 4($sp)
			lw $t2, 8($sp)
			lw $t3, 12($sp)
			lw $v0, 16($sp)
			lw $a0, 20($sp)
			lw $ra, 24($sp)
			lw $t4, 28($sp)
			lw $t5, 32($sp)
			lw $t6, 36($sp)
			lw $s3, 40($sp)
			lw $s4, 44($sp)
			lw $s5, 48($sp)
			lw $s6, 52($sp)
			lw $s7, 56($sp)
			addi $sp, $sp, 60
			jr $ra

	end:
	
	
		
		  

			
		
		
		
	 
