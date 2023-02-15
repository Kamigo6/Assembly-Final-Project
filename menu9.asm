.data
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
	menu: .asciiz "\n===MENU===\n1. Display\n2. Display empty\n3. Display ECD\n4. Change color and Display\n5. Exit\n===> Execute order (1-5 only): "
	sub_menu: .asciiz "\nEnter color (0-9 only):"
	color_order1: .asciiz "\n=> Color for D: "
	color_order2: .asciiz "\n=> Color for C: "
	color_order3: .asciiz "\n=> Color for E: "
	error1: .asciiz "\nInvalid input!"
.text
	
display_menu: 
	# Initialize the color
	addi $s1, $0, '2' # color for D
	addi $s2, $0, '1' # color for C
	addi $s3, $0, '3' # color for E
	
	# Initialize the start positions
	addi $s4, $0, 0 # first character (D: start at 0 to 21)
	addi $s5, $0, 22 # second character (C: start at 22 to 40)
	addi $s6, $0, 41 # third character (E: start at 41 to 56)
	
	# Initialize the length corelated to the characters	
	addi $t4, $0, 22 # length for first character (D: 22)
	addi $t5, $0, 19 # length for second character (C: 19)
	addi $t6, $0, 15 # length for third character (E: 16)
	
	#display menu
	li $v0, 4
	la $a0, menu
	syscall
	
	#enter order
	li $v0, 5
	syscall
	
	#process order
	beq $v0, 1, display 	  # execute order 1
	beq $v0, 2, display_empty # execute order 2
	beq $v0, 3, display_ECD   # execute order 3
	beq $v0, 4, change_color  # execute order 4
	beq $v0, 5, exit		 # execute order 5
	j input_error1 
# Function: display()
# Goal: Print the whole picture to the console
#-------------------
# Parameters: color for D, C, and E (s1, s2, and s3)
#	position for 1st, 2nd and 3rd characters (s4, s5 and s6)
display:
	la $s0, lines # address of lines	
	addi $t1, $0, 0 # line iterator
	display_line:
		beq $t1, 16, display_menu
		sll $t3, $t1, 2 # t3 = t1 * 4
		add $t3, $s0, $t3 # address of lines[i] 
		lw $t3, 0($t3)
		# Function: display_1()
		# Goal: Print the first character to the console
		#-------------------
		# Parameters: color (s1), start position (s4) and length (t4) for 1st character 
		display_1:
			add $t7, $t3, $s4 # address of lines[i][s4]
		 	addi $t2, $0, 0 # iterator
			loop1:
				beq $t2, $t4, display_2
				
				
				add $t8, $t7, $t2 #address of character
				lb $a0, 0($t8)
				
				sle $t0, $a0, '9' # a0 <= '9' ?
				sge $t9, $a0, '0' # a0 >= '0' ?
				and $t0, $t0, $t9 # is the character digits?
				beq $t0, 1, set_color1
				continue1:
				
				li $v0, 11
				syscall
				
				addi $t2, $t2, 1 # increase t2 by 1
				j loop1
			set_color1:
				addi $a0, $s1, 0
				j continue1 
				
		# Function: display_3()
		# Goal: Print the second character to the console
		#-------------------
		# Parameters: color (s2), start position (s5) and length (t5) for 1st character 
		
		display_2:
			add $t7, $t3, $s5 # address of lines[i][s5]
		 	addi $t2, $0, 0 # iterator
			loop2:
				beq $t2, $t5, display_3
				
				add $t8, $t7, $t2 #address of character
				li $v0, 11
				lb $a0, 0($t8)
				
				sle $t0, $a0, '9' # a0 <= '9' ?
				sge $t9, $a0, '0' # a0 >= '0' ?
				and $t0, $t0, $t9 # is the character digits?
				beq $t0, 1, set_color2
				continue2:
				
				syscall
				addi $t2, $t2, 1 # increase t2 by 1
				j loop2
			set_color2:
				addi $a0, $s2, 0
				j continue2
		# Function: display_3()
		# Goal: Print the third character to the console
		#-------------------
		# Parameters: color (s3), start position (s6) and length (t6) for 1st character 
		
		display_3:
			add $t7, $t3, $s6 # address of lines[i][s6]
		 	addi $t2, $0, 0 # iterator
			loop3:
				beq $t2, $t6, end_display_line
				
				add $t8, $t7, $t2 #address of character
				li $v0, 11
				lb $a0, 0($t8)

				
				sle $t0, $a0, '9' # a0 <= '9' ?
				sge $t9, $a0, '0' # a0 >= '0' ?
				and $t0, $t0, $t9 # is the character digits?
				beq $t0, 1, set_color3
				continue3:
				
				syscall				
				addi $t2, $t2, 1 # increase t2 by 1
				j loop3
			set_color3:
				addi $a0, $s3, 0
				j continue3
		end_display_line:
			li $v0, 11
			li $a0, '\n'
			syscall
			addi $t1, $t1, 1 # increase line iterator
			j display_line
				 
				
			



# Function: change_color()
# Goal: Change the color and print the whole picture to the console
#-------------------
# Parameters: color for D, C, and E (s1, s2, and s3)
#	position for 1st, 2nd and 3rd characters (s4, s5 and s6)
change_color:
	#enter color
	li $v0, 4
	la $a0, sub_menu
	syscall
	#enter color for 1st character
	li $v0, 4
	la $a0, color_order1
	syscall
	
	li $v0, 5
	syscall
	# check if 0 <= v0 <=9
	blt $v0, 0, input_error2
	bgt $v0, 9, input_error2
	
	addi $s1, $v0, '0' 

	#enter color for 2nd character
	li $v0, 4
	la $a0, color_order2
	syscall
	
	li $v0, 5
	syscall
	# check if 0 <= v0 <=9
	blt $v0, 0, input_error2
	bgt $v0, 9, input_error2
	
	addi $s2, $v0, '0'
	
	#enter color for 3rd character
	li $v0, 4
	la $a0, color_order3
	syscall
	
	li $v0, 5
	syscall
	# check if 0 <= v0 <=9
	blt $v0, 0, input_error2
	bgt $v0, 9, input_error2
	
	addi $s3, $v0, '0'
	
	j display

# Function: display_empty()
# Goal: Change the color to space and print the whole picture to the console
#-------------------
# Parameters: color for D, C, and E (s1, s2, and s3)
#	position for 1st, 2nd and 3rd characters (s4, s5 and s6)
display_empty:
	addi $s1, $0, ' ' # color for D
	addi $s2, $0, ' ' # color for C
	addi $s3, $0, ' ' # color for E
	j display
# Function: display_ECD()
# Goal: Change the position  and print the whole picture to the console
#-------------------
# Parameters: color for D, C, and E (s3, s2, and s1)
#	position for 1st, 2nd and 3rd characters (s6, s5 and s4)
display_ECD:
	# reset the color
	addi $s1, $0, '3' # color for E
	addi $s2, $0, '1' # color for C
	addi $s3, $0, '2' # color for D
	
	# reset the start positions
	addi $s4, $0, 41 # first character (E: start at 41 to 56)
	addi $s5, $0, 22 # second character (C: start at 22 to 40)
	addi $s6, $0, 0 # third character (D: start at 0 to 21)
	
	# reset the length corelated to the characters	
	addi $t4, $0, 15 # length for first character  (E: 16)
	addi $t5, $0, 19 # length for second character (C: 19)
	addi $t6, $0, 22 # length for third character (D: 22)
	
	j display
	
# display error for wrong input while changing color
input_error2:
	li $v0, 4
	la $a0, error1
	syscall
	j change_color
# display error for wrong input while taking order
input_error1:
	li $v0, 4
	la $a0, error1
	syscall
	j display_menu
#END PROGRAM
exit:
	li $v0, 10
	syscall
