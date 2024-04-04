################ CSC258H1F Winter 2024 Assembly Final Project ##################
# This file contains our implementation of Tetris.
#
# Student 1: Name, Student Number
# Student 2: Name, Student Number (if applicable)
######################## Bitmap Display Configuration ########################
# - Unit width in pixels:       8
# - Unit height in pixels:      8
# - Display width in pixels:    256
# - Display height in pixels:   256
# - Base Address for Display:   0x10008000 ($gp)
##############################################################################

    .data
##############################################################################
# Immutable Data
##############################################################################
# The address of the bitmap display. Don't forget to connect it!
gravitySpeed: 
    .word 30000  # Initial delay count
ADDR_DSPL:
    .word 0x10008000
# The address of the keyboard. Don't forget to connect it!
ADDR_KBRD:
    .word 0xffff0000
greenColor:  
    .word 0x00FF00
greyColor:
    .word 0x0000FF 
blackColor: 
    .word 0x00000000 


##############################################################################
# Mutable Data
##############################################################################

##############################################################################
# Code
##############################################################################
	.text
	.globl main

	# Run the Tetris game.
main:
    # Initialize the game
    li $s4, 0xff0000
    lw $s0, ADDR_DSPL
    # Drawing left the boundary of the board:
    add $t1, $zero, $zero # initializing y = 0
    addi $t3, $zero, 128 # t3 stores 128
    lw $s1, greenColor
    lw $s2, greyColor
    lw $s3, blackColor

leftbound1:
    beq $t1, 32, leftbound2_vars
    mul $t4, $t1, $t3 # t4 stores the value needed to store as the byte offset 
    add $t5, $s0, $t4  # $t5 now contains the address to store the color
    sw $s2, 0($t5)  # Store the color value from $t2 into the address contained in $t5
    addi $t1, $t1, 1
    j leftbound1

leftbound2_vars:
    add $t1, $zero, $zero # initializing y = 0
    addi $t0, $zero, 1 # initializing x = 1
    add $t2, $zero, $zero
    add $t4, $zero, $zero
    add $t5, $zero, $zero
    addi $t2, $zero, 4 # t2 = 4, t3 is already 128

left_bound2:
    beq $t1, 32, bottomboundvariables
    mul $t4, $t0, $t2 # t4 = x * 4
    mul $t5, $t1, $t3 # t5 = y * 128
    add $t5, $t5, $t4 # t5 = t5 + t4
    add $t5, $s0, $t5
    sw $s2, 0($t5)
    addi $t1, $t1, 1
    j left_bound2
    
    
bottomboundvariables: 
    lw $s0, ADDR_DSPL
    addi $t3, $zero, 4 # t3 stores 4
    add $t1, $zero, $zero # initializing x = 0
    addi $t6, $zero, 31 # intialize y = 31
    add $t7, $zero, $zero
    addi $t7, $zero, 128 # t7 stores 128
    mul $t8, $t6, $t7 

bottombound1:
    beq $t1, 32, bottombound2vars
    mul $t4, $t1, $t3 # x * 4, t4 stores the value needed to store as the byte offset 
    add $t9, $t8, $t4 # x * 4 + y * 128
    add $t5, $s0, $t9  # $t5 now contains the address to store the color
    sw $s2, 0($t5)  # Store the color value from $s1 into the address contained in $t5
    addi $t1, $t1, 1
    j bottombound1
    
bottombound2vars:
    add $t1, $zero, $zero 
    addi $t1, $zero, 30 # initializing y = 30
    addi $t0, $zero, 1 # initializing x = 1
    add $t2, $zero, $zero
    add $t4, $zero, $zero
    add $t5, $zero, $zero
    add $t6, $zero, $zero
    add $t7, $zero, $zero
    addi $t5, $zero, 128
    addi $t2, $zero, 4

bottombound2:
    beq $t0, 31, rightboundvariables
    mul $t3, $t0, $t2 # t3 = x * 4
    mul $t4, $t1, $t5 # t4 = y * 128
    add $t6, $t3, $t4 # t6 = x * 4 + y * 128
    add $t7, $s0, $t6 # byte_offset total
    sw $s2, 0($t7)
    addi $t0, $t0, 1
    j bottombound2


rightboundvariables:
    lw $s0, ADDR_DSPL
    add $t2, $zero, $zero
    add $t4, $zero, $zero
    add $t5, $zero, $zero
    add $t7, $zero, $zero
    add $t3, $zero, $zero
    add $t1, $zero, $zero
    addi $t3, $zero, 4 # t3 stores 4
    add $t1, $zero, 31 # initializing x = 31
    add $t6, $zero, $zero # intialize y = 0
    addi $t7, $zero, 128 # t7 stores 128
    mul $t8, $t3, $t1 # t8 stores x * 4

rightbound:
    beq $t6, 31, rightbound2vars 
    mul $t4, $t6, $t7 # y * 128, t4 stores the value needed to store as the byte offset 
    add $t9, $t8, $t4 # x * 4 + y * 128
    add $t5, $s0, $t9  # $t5 now contains the address to store the color
    sw $s2, 0($t5)  # Store the color value from $s1 into the address contained in $t5
    addi $t6, $t6, 1
    j rightbound

rightbound2vars:
    #reset all temporary registers
    add $t1, $zero, $zero
    add $t2, $zero, $zero
    add $t3, $zero, $zero
    add $t4, $zero, $zero
    add $t5, $zero, $zero
    add $t6, $zero, $zero
    add $t7, $zero, $zero
    add $t8, $zero, $zero
    
    #setting registers:
    addi $t1, $zero, 30 # x = 30
    addi $t3, $zero, 4
    addi $t4, $zero, 128
    # use t2 for y, it is currently 0

rightbound2:
    beq $t2, 30, random_number_for_row
    mul $t5, $t1, $t3 #t5 = x * 4
    mul $t6, $t4, $t2 # t6 = y * 128
    add $t7, $t6, $t5
    add $t7, $t7, $s0
    sw $s2, 0($t7)
    addi $t2, $t2, 1
    j rightbound2
    
random_number_for_row:
li $v0, 42
li $a0, 0 #contains random number
li $a1, 4
syscall

beq $a0, 0, random_rows_0
beq $a0, 1, random_rows_1
beq $a0, 2, random_rows_2
beq $a0, 3, random_rows_3

random_rows_0:
#col 1
add $t1, $s0, 8
sw $s1, 3712($t1)
sw $s1, 3584($t1)
sw $s1, 3456($t1)
sw $s1, 3328($t1)
sw $s1, 3200($t1)
sw $s1, 3072($t1)
sw $s1, 2944($t1)
sw $s1, 2816($t1)
sw $s1, 2688($t1)
sw $s1, 2560($t1)

sw $s1, 3716($t1)
sw $s1, 3588($t1)
sw $s1, 3460($t1)
sw $s1, 3332($t1)
sw $s1, 3204($t1)
sw $s1, 3076($t1)
sw $s1, 2948($t1)
sw $s1, 2820($t1)
sw $s1, 2692($t1)
sw $s1, 2564($t1)

#col 2
sw $s1, 3720($t1)
sw $s1, 3592($t1)
sw $s1, 3464($t1)
sw $s1, 3336($t1)
sw $s1, 3208($t1)
sw $s1, 3080($t1)
sw $s1, 2952($t1)
sw $s1, 2824($t1)
sw $s3, 2696($t1)
sw $s3, 2568($t1)

sw $s1, 3724($t1)
sw $s1, 3596($t1)
sw $s1, 3468($t1)
sw $s1, 3340($t1)
sw $s1, 3212($t1)
sw $s1, 3084($t1)
sw $s1, 2956($t1)
sw $s1, 2828($t1)
sw $s3, 2700($t1)
sw $s3, 2572($t1)

#col 3:

sw $s1, 3728($t1)
sw $s1, 3600($t1)
sw $s1, 3472($t1)
sw $s1, 3344($t1)
sw $s1, 3216($t1)
sw $s1, 3088($t1)
sw $s3, 2960($t1)
sw $s3, 2832($t1)
sw $s3, 2704($t1)
sw $s3, 2576($t1)

sw $s1, 3732($t1)
sw $s1, 3604($t1)
sw $s1, 3476($t1)
sw $s1, 3348($t1)
sw $s1, 3220($t1)
sw $s1, 3092($t1)
sw $s3, 2964($t1)
sw $s3, 2836($t1)
sw $s3, 2708($t1)
sw $s3, 2580($t1)

# col 4
sw $s3, 3736($t1)
sw $s3, 3608($t1)
sw $s3, 3480($t1)
sw $s3, 3352($t1)
sw $s3, 3224($t1)
sw $s3, 3096($t1)
sw $s3, 2968($t1)
sw $s3, 2840($t1)
sw $s3, 2712($t1)
sw $s3, 2584($t1)

sw $s3, 3740($t1)
sw $s3, 3612($t1)
sw $s3, 3484($t1)
sw $s3, 3356($t1)
sw $s3, 3228($t1)
sw $s3, 3100($t1)
sw $s3, 2972($t1)
sw $s3, 2844($t1)
sw $s3, 2716($t1)
sw $s3, 2588($t1)

#col 5
sw $s3, 3744($t1)
sw $s3, 3616($t1)
sw $s3, 3488($t1)
sw $s3, 3360($t1)
sw $s3, 3232($t1)
sw $s3, 3104($t1)
sw $s3, 2976($t1)
sw $s3, 2848($t1)
sw $s3, 2720($t1)
sw $s3, 2592($t1)

sw $s3, 3748($t1)
sw $s3, 3620($t1)
sw $s3, 3492($t1)
sw $s3, 3364($t1)
sw $s3, 3236($t1)
sw $s3, 3108($t1)
sw $s3, 2980($t1)
sw $s3, 2852($t1)
sw $s3, 2724($t1)
sw $s3, 2596($t1)

# col 6
sw $s1, 3752($t1)
sw $s1, 3624($t1)
sw $s1, 3496($t1)
sw $s1, 3368($t1)
sw $s3, 3240($t1)
sw $s3, 3112($t1)
sw $s3, 2984($t1)
sw $s3, 2856($t1)
sw $s3, 2728($t1)
sw $s3, 2600($t1)

sw $s1, 3756($t1)
sw $s1, 3628($t1)
sw $s1, 3500($t1)
sw $s1, 3372($t1)
sw $s3, 3244($t1)
sw $s3, 3116($t1)
sw $s3, 2988($t1)
sw $s3, 2860($t1)
sw $s3, 2732($t1)
sw $s3, 2604($t1)

#col 7
sw $s1, 3760($t1)
sw $s1, 3632($t1)
sw $s1, 3504($t1)
sw $s1, 3376($t1)
sw $s1, 3248($t1)
sw $s1, 3120($t1)
sw $s3, 2992($t1)
sw $s3, 2864($t1)
sw $s3, 2736($t1)
sw $s3, 2608($t1)

sw $s1, 3764($t1)
sw $s1, 3636($t1)
sw $s1, 3508($t1)
sw $s1, 3380($t1)
sw $s1, 3252($t1)
sw $s1, 3124($t1)
sw $s3, 2996($t1)
sw $s3, 2868($t1)
sw $s3, 2740($t1)
sw $s3, 2612($t1)

#col 8
sw $s1, 3768($t1)
sw $s1, 3640($t1)
sw $s1, 3512($t1)
sw $s1, 3384($t1)
sw $s1, 3256($t1)
sw $s1, 3128($t1)
sw $s1, 3000($t1)
sw $s1, 2872($t1)
sw $s3, 2744($t1)
sw $s3, 2616($t1)

sw $s1, 3772($t1)
sw $s1, 3644($t1)
sw $s1, 3516($t1)
sw $s1, 3388($t1)
sw $s1, 3260($t1)
sw $s1, 3132($t1)
sw $s1, 3004($t1)
sw $s1, 2876($t1)
sw $s3, 2748($t1)
sw $s3, 2620($t1)

#col 9
sw $s1, 3776($t1)
sw $s1, 3648($t1)
sw $s1, 3520($t1)
sw $s1, 3392($t1)
sw $s1, 3264($t1)
sw $s1, 3136($t1)
sw $s3, 3008($t1)
sw $s3, 2880($t1)
sw $s3, 2752($t1)
sw $s3, 2624($t1)

sw $s1, 3780($t1)
sw $s1, 3652($t1)
sw $s1, 3524($t1)
sw $s1, 3396($t1)
sw $s1, 3268($t1)
sw $s1, 3140($t1)
sw $s3, 3012($t1)
sw $s3, 2884($t1)
sw $s3, 2756($t1)
sw $s3, 2628($t1)

#col 10
sw $s1, 3784($t1)
sw $s1, 3656($t1)
sw $s1, 3528($t1)
sw $s1, 3400($t1)
sw $s3, 3272($t1)
sw $s3, 3144($t1)
sw $s3, 3016($t1)
sw $s3, 2888($t1)
sw $s3, 2760($t1)
sw $s3, 2632($t1)

sw $s1, 3788($t1)
sw $s1, 3660($t1)
sw $s1, 3532($t1)
sw $s1, 3404($t1)
sw $s3, 3276($t1)
sw $s3, 3148($t1)
sw $s3, 3020($t1)
sw $s3, 2892($t1)
sw $s3, 2764($t1)
sw $s3, 2636($t1)

#col 11
sw $s1, 3792($t1)
sw $s1, 3664($t1)
sw $s3, 3536($t1)
sw $s3, 3408($t1)
sw $s3, 3280($t1)
sw $s3, 3152($t1)
sw $s3, 3024($t1)
sw $s3, 2896($t1)
sw $s3, 2768($t1)
sw $s3, 2640($t1)

sw $s1, 3796($t1)
sw $s1, 3668($t1)
sw $s3, 3540($t1)
sw $s3, 3412($t1)
sw $s3, 3284($t1)
sw $s3, 3156($t1)
sw $s3, 3028($t1)
sw $s3, 2900($t1)
sw $s3, 2772($t1)
sw $s3, 2644($t1)

#col 12
sw $s1, 3800($t1)
sw $s1, 3672($t1)
sw $s1, 3544($t1)
sw $s1, 3416($t1)
sw $s3, 3288($t1)
sw $s3, 3160($t1)
sw $s3, 3032($t1)
sw $s3, 2904($t1)
sw $s3, 2776($t1)
sw $s3, 2648($t1)

sw $s1, 3804($t1)
sw $s1, 3676($t1)
sw $s1, 3548($t1)
sw $s1, 3420($t1)
sw $s3, 3292($t1)
sw $s3, 3164($t1)
sw $s3, 3036($t1)
sw $s3, 2908($t1)
sw $s3, 2780($t1)
sw $s3, 2652($t1)

#col 13
sw $s1, 3808($t1)
sw $s1, 3680($t1)
sw $s1, 3552($t1)
sw $s1, 3424($t1)
sw $s1, 3296($t1)
sw $s1, 3168($t1)
sw $s3, 3040($t1)
sw $s3, 2912($t1)
sw $s3, 2784($t1)
sw $s3, 2656($t1)

sw $s1, 3812($t1)
sw $s1, 3684($t1)
sw $s1, 3556($t1)
sw $s1, 3428($t1)
sw $s1, 3300($t1)
sw $s1, 3172($t1)
sw $s3, 3044($t1)
sw $s3, 2916($t1)
sw $s3, 2788($t1)
sw $s3, 2660($t1)

#col 14
sw $s1, 3816($t1)
sw $s1, 3688($t1)
sw $s1, 3560($t1)
sw $s1, 3432($t1)
sw $s1, 3304($t1)
sw $s1, 3176($t1)
sw $s1, 3048($t1)
sw $s1, 2920($t1)
sw $s3, 2792($t1)
sw $s3, 2664($t1)

sw $s1, 3820($t1)
sw $s1, 3692($t1)
sw $s1, 3564($t1)
sw $s1, 3436($t1)
sw $s1, 3308($t1)
sw $s1, 3180($t1)
sw $s1, 3052($t1)
sw $s1, 2924($t1)
sw $s3, 2796($t1)
sw $s3, 2668($t1)

j set_score


random_rows_1:
#col 1
add $t1, $s0, 8
sw $s1, 3712($t1)
sw $s1, 3584($t1)
sw $s1, 3456($t1)
sw $s1, 3328($t1)
sw $s1, 3200($t1)
sw $s1, 3072($t1)
sw $s1, 2944($t1)
sw $s1, 2816($t1)
sw $s1, 2688($t1)
sw $s1, 2560($t1)

sw $s1, 3716($t1)
sw $s1, 3588($t1)
sw $s1, 3460($t1)
sw $s1, 3332($t1)
sw $s1, 3204($t1)
sw $s1, 3076($t1)
sw $s1, 2948($t1)
sw $s1, 2820($t1)
sw $s1, 2692($t1)
sw $s1, 2564($t1)

#col 2
sw $s1, 3720($t1)
sw $s1, 3592($t1)
sw $s1, 3464($t1)
sw $s1, 3336($t1)
sw $s3, 3208($t1)
sw $s3, 3080($t1)
sw $s3, 2952($t1)
sw $s3, 2824($t1)
sw $s3, 2696($t1)
sw $s3, 2568($t1)

sw $s1, 3724($t1)
sw $s1, 3596($t1)
sw $s1, 3468($t1)
sw $s1, 3340($t1)
sw $s3, 3212($t1)
sw $s3, 3084($t1)
sw $s3, 2956($t1)
sw $s3, 2828($t1)
sw $s3, 2700($t1)
sw $s3, 2572($t1)

#col 3:
sw $s1, 3728($t1)
sw $s1, 3600($t1)
sw $s3, 3472($t1)
sw $s3, 3344($t1)
sw $s3, 3216($t1)
sw $s3, 3088($t1)
sw $s3, 2960($t1)
sw $s3, 2832($t1)
sw $s3, 2704($t1)
sw $s3, 2576($t1)

sw $s1, 3732($t1)
sw $s1, 3604($t1)
sw $s3, 3476($t1)
sw $s3, 3348($t1)
sw $s3, 3220($t1)
sw $s3, 3092($t1)
sw $s3, 2964($t1)
sw $s3, 2836($t1)
sw $s3, 2708($t1)
sw $s3, 2580($t1)

# col 4
sw $s3, 3736($t1)
sw $s3, 3608($t1)
sw $s3, 3480($t1)
sw $s3, 3352($t1)
sw $s3, 3224($t1)
sw $s3, 3096($t1)
sw $s3, 2968($t1)
sw $s3, 2840($t1)
sw $s3, 2712($t1)
sw $s3, 2584($t1)

sw $s3, 3740($t1)
sw $s3, 3612($t1)
sw $s3, 3484($t1)
sw $s3, 3356($t1)
sw $s3, 3228($t1)
sw $s3, 3100($t1)
sw $s3, 2972($t1)
sw $s3, 2844($t1)
sw $s3, 2716($t1)
sw $s3, 2588($t1)

#col 5
sw $s1, 3744($t1)
sw $s1, 3616($t1)
sw $s3, 3488($t1)
sw $s3, 3360($t1)
sw $s3, 3232($t1)
sw $s3, 3104($t1)
sw $s3, 2976($t1)
sw $s3, 2848($t1)
sw $s3, 2720($t1)
sw $s3, 2592($t1)

sw $s1, 3748($t1)
sw $s1, 3620($t1)
sw $s3, 3492($t1)
sw $s3, 3364($t1)
sw $s3, 3236($t1)
sw $s3, 3108($t1)
sw $s3, 2980($t1)
sw $s3, 2852($t1)
sw $s3, 2724($t1)
sw $s3, 2596($t1)

# col 6
sw $s1, 3752($t1)
sw $s1, 3624($t1)
sw $s3, 3496($t1)
sw $s3, 3368($t1)
sw $s3, 3240($t1)
sw $s3, 3112($t1)
sw $s3, 2984($t1)
sw $s3, 2856($t1)
sw $s3, 2728($t1)
sw $s3, 2600($t1)

sw $s1, 3756($t1)
sw $s1, 3628($t1)
sw $s3, 3500($t1)
sw $s3, 3372($t1)
sw $s3, 3244($t1)
sw $s3, 3116($t1)
sw $s3, 2988($t1)
sw $s3, 2860($t1)
sw $s3, 2732($t1)
sw $s3, 2604($t1)

#col 7
sw $s1, 3760($t1)
sw $s1, 3632($t1)
sw $s1, 3504($t1)
sw $s1, 3376($t1)
sw $s3, 3248($t1)
sw $s3, 3120($t1)
sw $s3, 2992($t1)
sw $s3, 2864($t1)
sw $s3, 2736($t1)
sw $s3, 2608($t1)

sw $s1, 3764($t1)
sw $s1, 3636($t1)
sw $s1, 3508($t1)
sw $s1, 3380($t1)
sw $s3, 3252($t1)
sw $s3, 3124($t1)
sw $s3, 2996($t1)
sw $s3, 2868($t1)
sw $s3, 2740($t1)
sw $s3, 2612($t1)

#col 8
sw $s1, 3768($t1)
sw $s1, 3640($t1)
sw $s1, 3512($t1)
sw $s1, 3384($t1)
sw $s3, 3256($t1)
sw $s3, 3128($t1)
sw $s3, 3000($t1)
sw $s3, 2872($t1)
sw $s3, 2744($t1)
sw $s3, 2616($t1)

sw $s1, 3772($t1)
sw $s1, 3644($t1)
sw $s1, 3516($t1)
sw $s1, 3388($t1)
sw $s3, 3260($t1)
sw $s3, 3132($t1)
sw $s3, 3004($t1)
sw $s3, 2876($t1)
sw $s3, 2748($t1)
sw $s3, 2620($t1)

#col 9
sw $s1, 3776($t1)
sw $s1, 3648($t1)
sw $s3, 3520($t1)
sw $s3, 3392($t1)
sw $s3, 3264($t1)
sw $s3, 3136($t1)
sw $s3, 3008($t1)
sw $s3, 2880($t1)
sw $s3, 2752($t1)
sw $s3, 2624($t1)

sw $s1, 3780($t1)
sw $s1, 3652($t1)
sw $s3, 3524($t1)
sw $s3, 3396($t1)
sw $s3, 3268($t1)
sw $s3, 3140($t1)
sw $s3, 3012($t1)
sw $s3, 2884($t1)
sw $s3, 2756($t1)
sw $s3, 2628($t1)

#col 10
sw $s1, 3784($t1)
sw $s1, 3656($t1)
sw $s3, 3528($t1)
sw $s3, 3400($t1)
sw $s3, 3272($t1)
sw $s3, 3144($t1)
sw $s3, 3016($t1)
sw $s3, 2888($t1)
sw $s3, 2760($t1)
sw $s3, 2632($t1)

sw $s1, 3788($t1)
sw $s1, 3660($t1)
sw $s3, 3532($t1)
sw $s3, 3404($t1)
sw $s3, 3276($t1)
sw $s3, 3148($t1)
sw $s3, 3020($t1)
sw $s3, 2892($t1)
sw $s3, 2764($t1)
sw $s3, 2636($t1)

#col 11
sw $s1, 3792($t1)
sw $s1, 3664($t1)
sw $s1, 3536($t1)
sw $s1, 3408($t1)
sw $s1, 3280($t1)
sw $s1, 3152($t1)
sw $s1, 3024($t1)
sw $s1, 2896($t1)
sw $s3, 2768($t1)
sw $s3, 2640($t1)

sw $s1, 3796($t1)
sw $s1, 3668($t1)
sw $s1, 3540($t1)
sw $s1, 3412($t1)
sw $s1, 3284($t1)
sw $s1, 3156($t1)
sw $s1, 3028($t1)
sw $s1, 2900($t1)
sw $s3, 2772($t1)
sw $s3, 2644($t1)

#col 12
sw $s1, 3800($t1)
sw $s1, 3672($t1)
sw $s3, 3544($t1)
sw $s3, 3416($t1)
sw $s3, 3288($t1)
sw $s3, 3160($t1)
sw $s3, 3032($t1)
sw $s3, 2904($t1)
sw $s3, 2776($t1)
sw $s3, 2648($t1)

sw $s1, 3804($t1)
sw $s1, 3676($t1)
sw $s3, 3548($t1)
sw $s3, 3420($t1)
sw $s3, 3292($t1)
sw $s3, 3164($t1)
sw $s3, 3036($t1)
sw $s3, 2908($t1)
sw $s3, 2780($t1)
sw $s3, 2652($t1)

#col 13
sw $s1, 3808($t1)
sw $s1, 3680($t1)
sw $s1, 3552($t1)
sw $s1, 3424($t1)
sw $s3, 3296($t1)
sw $s3, 3168($t1)
sw $s3, 3040($t1)
sw $s3, 2912($t1)
sw $s3, 2784($t1)
sw $s3, 2656($t1)

sw $s1, 3812($t1)
sw $s1, 3684($t1)
sw $s1, 3556($t1)
sw $s1, 3428($t1)
sw $s3, 3300($t1)
sw $s3, 3172($t1)
sw $s3, 3044($t1)
sw $s3, 2916($t1)
sw $s3, 2788($t1)
sw $s3, 2660($t1)

#col 14
sw $s1, 3816($t1)
sw $s1, 3688($t1)
sw $s1, 3560($t1)
sw $s1, 3432($t1)
sw $s1, 3304($t1)
sw $s1, 3176($t1)
sw $s3, 3048($t1)
sw $s3, 2920($t1)
sw $s3, 2792($t1)
sw $s3, 2664($t1)

sw $s1, 3820($t1)
sw $s1, 3692($t1)
sw $s1, 3564($t1)
sw $s1, 3436($t1)
sw $s1, 3308($t1)
sw $s1, 3180($t1)
sw $s3, 3052($t1)
sw $s3, 2924($t1)
sw $s3, 2796($t1)
sw $s3, 2668($t1)

j set_score


random_rows_2:
#col 1
add $t1, $s0, 8
sw $s1, 3712($t1)
sw $s1, 3584($t1)
sw $s1, 3456($t1)
sw $s1, 3328($t1)
sw $s1, 3200($t1)
sw $s1, 3072($t1)
sw $s1, 2944($t1)
sw $s1, 2816($t1)
sw $s1, 2688($t1)
sw $s1, 2560($t1)

sw $s1, 3716($t1)
sw $s1, 3588($t1)
sw $s1, 3460($t1)
sw $s1, 3332($t1)
sw $s1, 3204($t1)
sw $s1, 3076($t1)
sw $s1, 2948($t1)
sw $s1, 2820($t1)
sw $s1, 2692($t1)
sw $s1, 2564($t1)

#col 2
sw $s3, 3720($t1)
sw $s3, 3592($t1)
sw $s3, 3464($t1)
sw $s3, 3336($t1)
sw $s3, 3208($t1)
sw $s3, 3080($t1)
sw $s3, 2952($t1)
sw $s3, 2824($t1)
sw $s3, 2696($t1)
sw $s3, 2568($t1)

sw $s3, 3724($t1)
sw $s3, 3596($t1)
sw $s3, 3468($t1)
sw $s3, 3340($t1)
sw $s3, 3212($t1)
sw $s3, 3084($t1)
sw $s3, 2956($t1)
sw $s3, 2828($t1)
sw $s3, 2700($t1)
sw $s3, 2572($t1)

#col 3:
sw $s3, 3728($t1)
sw $s3, 3600($t1)
sw $s3, 3472($t1)
sw $s3, 3344($t1)
sw $s3, 3216($t1)
sw $s3, 3088($t1)
sw $s3, 2960($t1)
sw $s3, 2832($t1)
sw $s3, 2704($t1)
sw $s3, 2576($t1)

sw $s3, 3732($t1)
sw $s3, 3604($t1)
sw $s3, 3476($t1)
sw $s3, 3348($t1)
sw $s3, 3220($t1)
sw $s3, 3092($t1)
sw $s3, 2964($t1)
sw $s3, 2836($t1)
sw $s3, 2708($t1)
sw $s3, 2580($t1)

# col 4
sw $s1, 3736($t1)
sw $s1, 3608($t1)
sw $s1, 3480($t1)
sw $s1, 3352($t1)
sw $s3, 3224($t1)
sw $s3, 3096($t1)
sw $s3, 2968($t1)
sw $s3, 2840($t1)
sw $s3, 2712($t1)
sw $s3, 2584($t1)

sw $s1, 3740($t1)
sw $s1, 3612($t1)
sw $s1, 3484($t1)
sw $s1, 3356($t1)
sw $s3, 3228($t1)
sw $s3, 3100($t1)
sw $s3, 2972($t1)
sw $s3, 2844($t1)
sw $s3, 2716($t1)
sw $s3, 2588($t1)

#col 5
sw $s3, 3744($t1)
sw $s3, 3616($t1)
sw $s3, 3488($t1)
sw $s3, 3360($t1)
sw $s3, 3232($t1)
sw $s3, 3104($t1)
sw $s3, 2976($t1)
sw $s3, 2848($t1)
sw $s3, 2720($t1)
sw $s3, 2592($t1)

sw $s3, 3748($t1)
sw $s3, 3620($t1)
sw $s3, 3492($t1)
sw $s3, 3364($t1)
sw $s3, 3236($t1)
sw $s3, 3108($t1)
sw $s3, 2980($t1)
sw $s3, 2852($t1)
sw $s3, 2724($t1)
sw $s3, 2596($t1)

# col 6
sw $s3, 3752($t1)
sw $s3, 3624($t1)
sw $s3, 3496($t1)
sw $s3, 3368($t1)
sw $s3, 3240($t1)
sw $s3, 3112($t1)
sw $s3, 2984($t1)
sw $s3, 2856($t1)
sw $s3, 2728($t1)
sw $s3, 2600($t1)

sw $s3, 3756($t1)
sw $s3, 3628($t1)
sw $s3, 3500($t1)
sw $s3, 3372($t1)
sw $s3, 3244($t1)
sw $s3, 3116($t1)
sw $s3, 2988($t1)
sw $s3, 2860($t1)
sw $s3, 2732($t1)
sw $s3, 2604($t1)

#col 7
sw $s1, 3760($t1)
sw $s1, 3632($t1)
sw $s1, 3504($t1)
sw $s1, 3376($t1)
sw $s1, 3248($t1)
sw $s1, 3120($t1)
sw $s1, 2992($t1)
sw $s1, 2864($t1)
sw $s3, 2736($t1)
sw $s3, 2608($t1)

sw $s1, 3764($t1)
sw $s1, 3636($t1)
sw $s1, 3508($t1)
sw $s1, 3380($t1)
sw $s1, 3252($t1)
sw $s1, 3124($t1)
sw $s1, 2996($t1)
sw $s1, 2868($t1)
sw $s3, 2740($t1)
sw $s3, 2612($t1)

#col 8
sw $s1, 3768($t1)
sw $s1, 3640($t1)
sw $s3, 3512($t1)
sw $s3, 3384($t1)
sw $s3, 3256($t1)
sw $s3, 3128($t1)
sw $s3, 3000($t1)
sw $s3, 2872($t1)
sw $s3, 2744($t1)
sw $s3, 2616($t1)

sw $s1, 3772($t1)
sw $s1, 3644($t1)
sw $s3, 3516($t1)
sw $s3, 3388($t1)
sw $s3, 3260($t1)
sw $s3, 3132($t1)
sw $s3, 3004($t1)
sw $s3, 2876($t1)
sw $s3, 2748($t1)
sw $s3, 2620($t1)

#col 9
sw $s3, 3776($t1)
sw $s3, 3648($t1)
sw $s3, 3520($t1)
sw $s3, 3392($t1)
sw $s3, 3264($t1)
sw $s3, 3136($t1)
sw $s3, 3008($t1)
sw $s3, 2880($t1)
sw $s3, 2752($t1)
sw $s3, 2624($t1)

sw $s3, 3780($t1)
sw $s3, 3652($t1)
sw $s3, 3524($t1)
sw $s3, 3396($t1)
sw $s3, 3268($t1)
sw $s3, 3140($t1)
sw $s3, 3012($t1)
sw $s3, 2884($t1)
sw $s3, 2756($t1)
sw $s3, 2628($t1)

#col 10
sw $s1, 3784($t1)
sw $s1, 3656($t1)
sw $s1, 3528($t1)
sw $s1, 3400($t1)
sw $s1, 3272($t1)
sw $s1, 3144($t1)
sw $s3, 3016($t1)
sw $s3, 2888($t1)
sw $s3, 2760($t1)
sw $s3, 2632($t1)

sw $s1, 3788($t1)
sw $s1, 3660($t1)
sw $s1, 3532($t1)
sw $s1, 3404($t1)
sw $s1, 3276($t1)
sw $s1, 3148($t1)
sw $s3, 3020($t1)
sw $s3, 2892($t1)
sw $s3, 2764($t1)
sw $s3, 2636($t1)

#col 11
sw $s3, 3792($t1)
sw $s3, 3664($t1)
sw $s3, 3536($t1)
sw $s3, 3408($t1)
sw $s3, 3280($t1)
sw $s3, 3152($t1)
sw $s3, 3024($t1)
sw $s3, 2896($t1)
sw $s3, 2768($t1)
sw $s3, 2640($t1)

sw $s3, 3796($t1)
sw $s3, 3668($t1)
sw $s3, 3540($t1)
sw $s3, 3412($t1)
sw $s3, 3284($t1)
sw $s3, 3156($t1)
sw $s3, 3028($t1)
sw $s3, 2900($t1)
sw $s3, 2772($t1)
sw $s3, 2644($t1)

#col 12
sw $s3, 3800($t1)
sw $s3, 3672($t1)
sw $s3, 3544($t1)
sw $s3, 3416($t1)
sw $s3, 3288($t1)
sw $s3, 3160($t1)
sw $s3, 3032($t1)
sw $s3, 2904($t1)
sw $s3, 2776($t1)
sw $s3, 2648($t1)

sw $s3, 3804($t1)
sw $s3, 3676($t1)
sw $s3, 3548($t1)
sw $s3, 3420($t1)
sw $s3, 3292($t1)
sw $s3, 3164($t1)
sw $s3, 3036($t1)
sw $s3, 2908($t1)
sw $s3, 2780($t1)
sw $s3, 2652($t1)

#col 13
sw $s1, 3808($t1)
sw $s1, 3680($t1)
sw $s1, 3552($t1)
sw $s1, 3424($t1)
sw $s3, 3296($t1)
sw $s3, 3168($t1)
sw $s3, 3040($t1)
sw $s3, 2912($t1)
sw $s3, 2784($t1)
sw $s3, 2656($t1)

sw $s1, 3812($t1)
sw $s1, 3684($t1)
sw $s1, 3556($t1)
sw $s1, 3428($t1)
sw $s3, 3300($t1)
sw $s3, 3172($t1)
sw $s3, 3044($t1)
sw $s3, 2916($t1)
sw $s3, 2788($t1)
sw $s3, 2660($t1)

#col 14
sw $s1, 3816($t1)
sw $s1, 3688($t1)
sw $s1, 3560($t1)
sw $s1, 3432($t1)
sw $s1, 3304($t1)
sw $s1, 3176($t1)
sw $s3, 3048($t1)
sw $s3, 2920($t1)
sw $s3, 2792($t1)
sw $s3, 2664($t1)

sw $s1, 3820($t1)
sw $s1, 3692($t1)
sw $s1, 3564($t1)
sw $s1, 3436($t1)
sw $s1, 3308($t1)
sw $s1, 3180($t1)
sw $s3, 3052($t1)
sw $s3, 2924($t1)
sw $s3, 2796($t1)
sw $s3, 2668($t1)

j set_score

random_rows_3:
#col 1
add $t1, $s0, 8
sw $s3, 3712($t1)
sw $s3, 3584($t1)
sw $s3, 3456($t1)
sw $s3, 3328($t1)
sw $s3, 3200($t1)
sw $s3, 3072($t1)
sw $s3, 2944($t1)
sw $s3, 2816($t1)
sw $s3, 2688($t1)
sw $s3, 2560($t1)

sw $s3, 3716($t1)
sw $s3, 3588($t1)
sw $s3, 3460($t1)
sw $s3, 3332($t1)
sw $s3, 3204($t1)
sw $s3, 3076($t1)
sw $s3, 2948($t1)
sw $s3, 2820($t1)
sw $s3, 2692($t1)
sw $s3, 2564($t1)

#col 2
sw $s3, 3720($t1)
sw $s3, 3592($t1)
sw $s3, 3464($t1)
sw $s3, 3336($t1)
sw $s3, 3208($t1)
sw $s3, 3080($t1)
sw $s3, 2952($t1)
sw $s3, 2824($t1)
sw $s3, 2696($t1)
sw $s3, 2568($t1)

sw $s3, 3724($t1)
sw $s3, 3596($t1)
sw $s3, 3468($t1)
sw $s3, 3340($t1)
sw $s3, 3212($t1)
sw $s3, 3084($t1)
sw $s3, 2956($t1)
sw $s3, 2828($t1)
sw $s3, 2700($t1)
sw $s3, 2572($t1)

#col 3:

sw $s1, 3728($t1)
sw $s1, 3600($t1)
sw $s3, 3472($t1)
sw $s3, 3344($t1)
sw $s3, 3216($t1)
sw $s3, 3088($t1)
sw $s3, 2960($t1)
sw $s3, 2832($t1)
sw $s3, 2704($t1)
sw $s3, 2576($t1)

sw $s1, 3732($t1)
sw $s1, 3604($t1)
sw $s3, 3476($t1)
sw $s3, 3348($t1)
sw $s3, 3220($t1)
sw $s3, 3092($t1)
sw $s3, 2964($t1)
sw $s3, 2836($t1)
sw $s3, 2708($t1)
sw $s3, 2580($t1)

# col 4
sw $s1, 3736($t1)
sw $s1, 3608($t1)
sw $s1, 3480($t1)
sw $s1, 3352($t1)
sw $s3, 3224($t1)
sw $s3, 3096($t1)
sw $s3, 2968($t1)
sw $s3, 2840($t1)
sw $s3, 2712($t1)
sw $s3, 2584($t1)

sw $s1, 3740($t1)
sw $s1, 3612($t1)
sw $s1, 3484($t1)
sw $s1, 3356($t1)
sw $s3, 3228($t1)
sw $s3, 3100($t1)
sw $s3, 2972($t1)
sw $s3, 2844($t1)
sw $s3, 2716($t1)
sw $s3, 2588($t1)

#col 5
sw $s3, 3744($t1)
sw $s3, 3616($t1)
sw $s3, 3488($t1)
sw $s3, 3360($t1)
sw $s3, 3232($t1)
sw $s3, 3104($t1)
sw $s3, 2976($t1)
sw $s3, 2848($t1)
sw $s3, 2720($t1)
sw $s3, 2592($t1)

sw $s3, 3748($t1)
sw $s3, 3620($t1)
sw $s3, 3492($t1)
sw $s3, 3364($t1)
sw $s3, 3236($t1)
sw $s3, 3108($t1)
sw $s3, 2980($t1)
sw $s3, 2852($t1)
sw $s3, 2724($t1)
sw $s3, 2596($t1)

# col 6
sw $s1, 3752($t1)
sw $s1, 3624($t1)
sw $s1, 3496($t1)
sw $s1, 3368($t1)
sw $s3, 3240($t1)
sw $s3, 3112($t1)
sw $s3, 2984($t1)
sw $s3, 2856($t1)
sw $s3, 2728($t1)
sw $s3, 2600($t1)

sw $s1, 3756($t1)
sw $s1, 3628($t1)
sw $s1, 3500($t1)
sw $s1, 3372($t1)
sw $s3, 3244($t1)
sw $s3, 3116($t1)
sw $s3, 2988($t1)
sw $s3, 2860($t1)
sw $s3, 2732($t1)
sw $s3, 2604($t1)

#col 7
sw $s1, 3760($t1)
sw $s1, 3632($t1)
sw $s3, 3504($t1)
sw $s3, 3376($t1)
sw $s3, 3248($t1)
sw $s3, 3120($t1)
sw $s3, 2992($t1)
sw $s3, 2864($t1)
sw $s3, 2736($t1)
sw $s3, 2608($t1)

sw $s1, 3764($t1)
sw $s1, 3636($t1)
sw $s3, 3508($t1)
sw $s3, 3380($t1)
sw $s3, 3252($t1)
sw $s3, 3124($t1)
sw $s3, 2996($t1)
sw $s3, 2868($t1)
sw $s3, 2740($t1)
sw $s3, 2612($t1)

#col 8
sw $s1, 3768($t1)
sw $s1, 3640($t1)
sw $s1, 3512($t1)
sw $s1, 3384($t1)
sw $s3, 3256($t1)
sw $s3, 3128($t1)
sw $s3, 3000($t1)
sw $s3, 2872($t1)
sw $s3, 2744($t1)
sw $s3, 2616($t1)

sw $s1, 3772($t1)
sw $s1, 3644($t1)
sw $s1, 3516($t1)
sw $s1, 3388($t1)
sw $s3, 3260($t1)
sw $s3, 3132($t1)
sw $s3, 3004($t1)
sw $s3, 2876($t1)
sw $s3, 2748($t1)
sw $s3, 2620($t1)

#col 9
sw $s3, 3776($t1)
sw $s3, 3648($t1)
sw $s3, 3520($t1)
sw $s3, 3392($t1)
sw $s3, 3264($t1)
sw $s3, 3136($t1)
sw $s3, 3008($t1)
sw $s3, 2880($t1)
sw $s3, 2752($t1)
sw $s3, 2624($t1)

sw $s3, 3780($t1)
sw $s3, 3652($t1)
sw $s3, 3524($t1)
sw $s3, 3396($t1)
sw $s3, 3268($t1)
sw $s3, 3140($t1)
sw $s3, 3012($t1)
sw $s3, 2884($t1)
sw $s3, 2756($t1)
sw $s3, 2628($t1)

#col 10
sw $s1, 3784($t1)
sw $s1, 3656($t1)
sw $s1, 3528($t1)
sw $s1, 3400($t1)
sw $s1, 3272($t1)
sw $s1, 3144($t1)
sw $s3, 3016($t1)
sw $s3, 2888($t1)
sw $s3, 2760($t1)
sw $s3, 2632($t1)

sw $s1, 3788($t1)
sw $s1, 3660($t1)
sw $s1, 3532($t1)
sw $s1, 3404($t1)
sw $s1, 3276($t1)
sw $s1, 3148($t1)
sw $s3, 3020($t1)
sw $s3, 2892($t1)
sw $s3, 2764($t1)
sw $s3, 2636($t1)

#col 11
sw $s1, 3792($t1)
sw $s1, 3664($t1)
sw $s1, 3536($t1)
sw $s1, 3408($t1)
sw $s3, 3280($t1)
sw $s3, 3152($t1)
sw $s3, 3024($t1)
sw $s3, 2896($t1)
sw $s3, 2768($t1)
sw $s3, 2640($t1)

sw $s1, 3796($t1)
sw $s1, 3668($t1)
sw $s1, 3540($t1)
sw $s1, 3412($t1)
sw $s3, 3284($t1)
sw $s3, 3156($t1)
sw $s3, 3028($t1)
sw $s3, 2900($t1)
sw $s3, 2772($t1)
sw $s3, 2644($t1)

#col 12
sw $s1, 3800($t1)
sw $s1, 3672($t1)
sw $s1, 3544($t1)
sw $s1, 3416($t1)
sw $s1, 3288($t1)
sw $s1, 3160($t1)
sw $s1, 3032($t1)
sw $s1, 2904($t1)
sw $s1, 2776($t1)
sw $s1, 2648($t1)

sw $s1, 3804($t1)
sw $s1, 3676($t1)
sw $s1, 3548($t1)
sw $s1, 3420($t1)
sw $s1, 3292($t1)
sw $s1, 3164($t1)
sw $s1, 3036($t1)
sw $s1, 2908($t1)
sw $s1, 2780($t1)
sw $s1, 2652($t1)

#col 13
sw $s1, 3808($t1)
sw $s1, 3680($t1)
sw $s3, 3552($t1)
sw $s3, 3424($t1)
sw $s3, 3296($t1)
sw $s3, 3168($t1)
sw $s3, 3040($t1)
sw $s3, 2912($t1)
sw $s3, 2784($t1)
sw $s3, 2656($t1)

sw $s1, 3812($t1)
sw $s1, 3684($t1)
sw $s3, 3556($t1)
sw $s3, 3428($t1)
sw $s3, 3300($t1)
sw $s3, 3172($t1)
sw $s3, 3044($t1)
sw $s3, 2916($t1)
sw $s3, 2788($t1)
sw $s3, 2660($t1)

#col 14
sw $s1, 3816($t1)
sw $s1, 3688($t1)
sw $s1, 3560($t1)
sw $s1, 3432($t1)
sw $s1, 3304($t1)
sw $s1, 3176($t1)
sw $s1, 3048($t1)
sw $s1, 2920($t1)
sw $s1, 2792($t1)
sw $s1, 2664($t1)

sw $s1, 3820($t1)
sw $s1, 3692($t1)
sw $s1, 3564($t1)
sw $s1, 3436($t1)
sw $s1, 3308($t1)
sw $s1, 3180($t1)
sw $s1, 3052($t1)
sw $s1, 2924($t1)
sw $s1, 2796($t1)
sw $s1, 2668($t1)

# random_rows_4:


set_score:  

add $s7, $zero, $zero # keep track of the score
display_0:
#digit 1:
sw $s2, 88($s0)
sw $s2, 92($s0)
sw $s2, 96($s0)

sw $s2, 216($s0)
sw $s2, 344($s0)
sw $s2, 472($s0)
sw $s2, 600($s0)

sw $s2, 352($s0)
sw $s2, 224($s0)
sw $s2, 480($s0)
sw $s2, 608($s0)

#middle piece:
sw $s2, 604($s0)


# digit 2:
sw $s2, 104($s0)
sw $s2, 108($s0)
sw $s2, 112($s0)

sw $s2, 232($s0)
sw $s2, 360($s0)
sw $s2, 488($s0)
sw $s2, 616($s0)

sw $s2, 368($s0)
sw $s2, 240($s0)
sw $s2, 496($s0)
sw $s2, 624($s0)

#middle piece:
sw $s2, 620($s0)

add $s7, $zero, $zero

#reset gravity speed here
li $t0, 30000        # Reset register $t0 to 0
sw $t0, gravitySpeed  

game_loop:

    addi, $s5, $zero, 1 # s5 represents the state of the tetromino, 1 for vertical, 0 for horizontal states
    addi $s6, $s0, 56 # s6 is the pivot point of the tetromino, set to its smallest (first) byte
    # draw first tetromino
    
check_filled_rows:
add $t9, $zero, $zero
add $t2, $zero, $zero # keep track of rows
add $t1, $s0, 8 # first row
row_loop:
beq $t2, 15, tetromino # outer loop, looping over each row
add $t6, $zero, $zero

add $t7, $t1, $zero

inner_loop:
lw $t4, 0($t7) # pixel to check if blue
beq $t4, $s2, filled_rows_outer_loop_end
beq $t4, $s3, filled_rows_outer_loop_mid
loop_ctd:
addi $t7, $t7, 4
j inner_loop

filled_rows_outer_loop_mid:
addi, $t6, $zero, 1 #means that a black pixel was encountered in the row
j loop_ctd

filled_rows_outer_loop_end:
beq $t6, 0, shift_rows_down 
j continue_outer_loop

shift_rows_down:
addi, $t9, $zero, 1
addi $s7, $s7, 1

# t1 stores address of first pixel in row
add $t3, $t1, $zero
make_white:
lw $t4, 0($t3)
beq $t4, $s2, pre_1
li $t6, 0xFFFFFF
sw $t6, 0($t3)
sw $t6, 128($t3)
addi $t3, $t3, 4
j make_white

pre_1:
li $v0 , 32
li $a0 , 250
syscall
add $t3, $t1, $zero
make_black:
lw $t4, 0($t3)
beq $t4, $s2, pre_2
li $t6, 0x000000
sw $t6, 0($t3)
sw $t6, 128($t3)
addi $t3, $t3, 4
j make_black

pre_2:
li $v0 , 32
li $a0 , 250
syscall
add $t3, $t1, $zero
make_white_2:
lw $t4, 0($t3)
beq $t4, $s2, continue_shift
li $t6, 0xFFFFFF
sw $t6, 0($t3)
sw $t6, 128($t3)
addi $t3, $t3, 4
j make_white_2

# sw $s4, -4($t1)
# make row blink white for 1 second before removing it
continue_shift:

continue_row:
add $t3, $t1, $zero
make_green:
lw $t4, 0($t3)
beq $t4, $s2, continue_row_2
li $t6, 0x00FF00
sw $t6, 0($t3)
sw $t6, 128($t3)
addi $t3, $t3, 4
j make_green


continue_row_2:
li $t0, 10       # Load immediate value 10 into $t0
div $s7, $t0     # Perform division
mflo $t8       # Move quotient (tens place) to $t8
mfhi $t9        # Move remainder (ones place) to $t9

draw_first_digit:
beq $t8, 1, draw_1_1
beq $t8, 2, draw_2_1
beq $t8, 3, draw_3_1
beq $t8, 4, draw_4_1
beq $t8, 5, draw_5_1
beq $t8, 6, draw_6_1
beq $t8, 7, draw_7_1
beq $t8, 8, draw_8_1
beq $t8, 9, draw_9_1

j draw_second_digit

draw_1_1:
sw $s3, 88($s0)
sw $s3, 92($s0)
sw $s3, 96($s0)

sw $s3, 216($s0)
sw $s3, 344($s0)
sw $s3, 472($s0)
sw $s3, 600($s0)

sw $s3, 352($s0)
sw $s3, 224($s0)
sw $s3, 480($s0)
sw $s3, 608($s0)

#middle piece:
sw $s3, 604($s0)

#draw the 1 as first digit
sw $s2, 92($s0)
sw $s2, 220($s0)
sw $s2, 348($s0)
sw $s2, 476($s0)

#middle piece:
sw $s2, 604($s0)

j draw_second_digit

draw_2_1:
#erase 1 first
sw $s3, 92($s0)
sw $s3, 220($s0)
sw $s3, 348($s0)
sw $s3, 476($s0)

#middle piece:
sw $s3, 604($s0)

#draw 2 as first digit:
sw $s2, 88($s0)
sw $s2, 92($s0)
sw $s2, 96($s0)
sw $s2, 224($s0)
sw $s2, 352($s0)
sw $s2, 348($s0)
sw $s2, 344($s0)
sw $s2, 472($s0)
sw $s2, 600($s0)
sw $s2, 604($s0)
sw $s2, 608($s0)

j draw_second_digit

draw_3_1:
#remove 2 as first digit:
sw $s3, 88($s0)
sw $s3, 92($s0)
sw $s3, 96($s0)
sw $s3, 224($s0)
sw $s3, 352($s0)
sw $s3, 348($s0)
sw $s3, 344($s0)
sw $s3, 472($s0)
sw $s3, 600($s0)
sw $s3, 604($s0)
sw $s3, 608($s0)

#draw 3 as first digit:
sw $s2, 88($s0)
sw $s2, 92($s0)
sw $s2, 96($s0)
sw $s2, 224($s0)
sw $s2, 352($s0)
sw $s2, 348($s0)
sw $s2, 344($s0)
sw $s2, 480($s0)
sw $s2, 600($s0)
sw $s2, 604($s0)
sw $s2, 608($s0)

j draw_second_digit

draw_4_1:
#remove 3:
sw $s3, 88($s0)
sw $s3, 92($s0)
sw $s3, 96($s0)
sw $s3, 224($s0)
sw $s3, 352($s0)
sw $s3, 348($s0)
sw $s3, 344($s0)
sw $s3, 480($s0)
sw $s3, 600($s0)
sw $s3, 604($s0)
sw $s3, 608($s0)

#draw 4:
sw $s2, 88($s0)
sw $s2, 96($s0)
sw $s2, 224($s0)
sw $s2, 352($s0)
sw $s2, 348($s0)
sw $s2, 344($s0)
sw $s2, 216($s0)
sw $s2, 480($s0)
sw $s2, 608($s0)

j draw_second_digit

draw_5_1:
#remove 4:

sw $s3, 88($s0)
sw $s3, 96($s0)
sw $s3, 224($s0)
sw $s3, 352($s0)
sw $s3, 348($s0)
sw $s3, 344($s0)
sw $s3, 216($s0)
sw $s3, 480($s0)
sw $s3, 608($s0)

#draw 5:
sw $s2, 88($s0)
sw $s2, 96($s0)
sw $s2, 92($s0)
sw $s2, 216($s0)
sw $s2, 352($s0)
sw $s2, 348($s0)
sw $s2, 344($s0)
sw $s2, 480($s0)
sw $s2, 608($s0)
sw $s2, 604($s0)
sw $s2, 600($s0)

j draw_second_digit

draw_6_1:
#remove 5:
sw $s3, 88($s0)
sw $s3, 96($s0)
sw $s3, 92($s0)
sw $s3, 216($s0)
sw $s3, 352($s0)
sw $s3, 348($s0)
sw $s3, 344($s0)
sw $s3, 480($s0)
sw $s3, 608($s0)
sw $s3, 604($s0)
sw $s3, 600($s0)

#draw 6:
sw $s2, 88($s0)
sw $s2, 96($s0)
sw $s2, 92($s0)
sw $s2, 216($s0)
sw $s2, 352($s0)
sw $s2, 348($s0)
sw $s2, 344($s0)
sw $s2, 480($s0)
sw $s2, 608($s0)
sw $s2, 604($s0)
sw $s2, 600($s0)
sw $s2, 472($s0)

j draw_second_digit

draw_7_1:
#remove 6:
sw $s3, 88($s0)
sw $s3, 96($s0)
sw $s3, 92($s0)
sw $s3, 216($s0)
sw $s3, 352($s0)
sw $s3, 348($s0)
sw $s3, 344($s0)
sw $s3, 480($s0)
sw $s3, 608($s0)
sw $s3, 604($s0)
sw $s3, 600($s0)
sw $s3, 472($s0)

#draw 7:
sw $s2, 88($s0)
sw $s2, 96($s0)
sw $s2, 92($s0)
sw $s2, 224($s0)
sw $s2, 352($s0)
sw $s2, 480($s0)
sw $s2, 608($s0)

j draw_second_digit 

draw_8_1:
#remove 7:
sw $s3, 88($s0)
sw $s3, 96($s0)
sw $s3, 92($s0)
sw $s3, 224($s0)
sw $s3, 352($s0)
sw $s3, 480($s0)
sw $s3, 608($s0)

#draw 8:
sw $s2, 88($s0)
sw $s2, 96($s0)
sw $s2, 92($s0)
sw $s2, 216($s0)
sw $s2, 352($s0)
sw $s2, 348($s0)
sw $s2, 344($s0)
sw $s2, 480($s0)
sw $s2, 608($s0)
sw $s2, 604($s0)
sw $s2, 600($s0)
sw $s2, 472($s0)
sw $s2, 224($s0)

j draw_second_digit 

draw_9_1:
#remove 8:
sw $s3, 88($s0)
sw $s3, 96($s0)
sw $s3, 92($s0)
sw $s3, 216($s0)
sw $s3, 352($s0)
sw $s3, 348($s0)
sw $s3, 344($s0)
sw $s3, 480($s0)
sw $s3, 608($s0)
sw $s3, 604($s0)
sw $s3, 600($s0)
sw $s3, 472($s0)
sw $s3, 224($s0)

#draw 9:
sw $s2, 88($s0)
sw $s2, 92($s0)
sw $s2, 96($s0)
sw $s2, 224($s0)
sw $s2, 216($s0)
sw $s2, 352($s0)
sw $s2, 348($s0)
sw $s2, 344($s0)
sw $s2, 480($s0)
sw $s2, 600($s0)
sw $s2, 604($s0)
sw $s2, 608($s0)

j draw_second_digit


draw_second_digit:

beq $t9, 1, draw_1_2
beq $t9, 2, draw_2_2
beq $t9, 3, draw_3_2
beq $t9, 4, draw_4_2
beq $t9, 5, draw_5_2
beq $t9, 6, draw_6_2
beq $t9, 7, draw_7_2
beq $t9, 8, draw_8_2
beq $t9, 9, draw_9_2
 
j shift_fr

draw_1_2:
#remove 0 and draw 1:
# remove the second 0 first:
sw $s3, 104($s0)
sw $s3, 108($s0)
sw $s3, 112($s0)

sw $s3, 232($s0)
sw $s3, 360($s0)
sw $s3, 488($s0)
sw $s3, 616($s0)

sw $s3, 368($s0)
sw $s3, 240($s0)
sw $s3, 496($s0)
sw $s3, 624($s0)

#middle piece:
sw $s3, 620($s0)


sw $s2, 104($s0)
sw $s2, 232($s0)
sw $s2, 360($s0)
sw $s2, 488($s0)
sw $s2, 616($s0)

j shift_fr

draw_2_2:
sw $s3, 104($s0)
sw $s3, 232($s0)
sw $s3, 360($s0)
sw $s3, 488($s0)
sw $s3, 616($s0)

sw $s2, 104($s0)
sw $s2, 108($s0)
sw $s2, 112($s0)
sw $s2, 240($s0)
sw $s2, 368($s0)
sw $s2, 364($s0)
sw $s2, 360($s0)
sw $s2, 488($s0)
sw $s2, 616($s0)
sw $s2, 620($s0)
sw $s2, 624($s0)

j shift_fr

draw_3_2:
sw $s3, 104($s0)
sw $s3, 108($s0)
sw $s3, 112($s0)
sw $s3, 240($s0)
sw $s3, 368($s0)
sw $s3, 364($s0)
sw $s3, 360($s0)
sw $s3, 488($s0)
sw $s3, 616($s0)
sw $s3, 620($s0)
sw $s3, 624($s0)

sw $s2, 104($s0)
sw $s2, 108($s0)
sw $s2, 112($s0)
sw $s2, 240($s0)
sw $s2, 368($s0)
sw $s2, 496($s0)
sw $s2, 364($s0)
sw $s2, 360($s0)
sw $s2, 616($s0)
sw $s2, 620($s0)
sw $s2, 624($s0)

j shift_fr

draw_4_2:
sw $s3, 104($s0)
sw $s3, 108($s0)
sw $s3, 112($s0)
sw $s3, 240($s0)
sw $s3, 368($s0)
sw $s3, 496($s0)
sw $s3, 364($s0)
sw $s3, 360($s0)
sw $s3, 616($s0)
sw $s3, 620($s0)
sw $s3, 624($s0)

sw $s2, 104($s0)
sw $s2, 112($s0)
sw $s2, 240($s0)
sw $s2, 232($s0)
sw $s2, 368($s0)
sw $s2, 496($s0)
sw $s2, 364($s0)
sw $s2, 360($s0)
sw $s2, 624($s0)

j shift_fr

draw_5_2:
sw $s3, 104($s0)
sw $s3, 112($s0)
sw $s3, 240($s0)
sw $s3, 232($s0)
sw $s3, 368($s0)
sw $s3, 496($s0)
sw $s3, 364($s0)
sw $s3, 360($s0)
sw $s3, 624($s0)

sw $s2, 104($s0)
sw $s2, 108($s0)
sw $s2, 112($s0)
sw $s2, 232($s0)
sw $s2, 368($s0)
sw $s2, 496($s0)
sw $s2, 364($s0)
sw $s2, 360($s0)
sw $s2, 616($s0)
sw $s2, 620($s0)
sw $s2, 624($s0)

j shift_fr

draw_6_2:
sw $s3, 104($s0)
sw $s3, 108($s0)
sw $s3, 112($s0)
sw $s3, 232($s0)
sw $s3, 368($s0)
sw $s3, 496($s0)
sw $s3, 364($s0)
sw $s3, 360($s0)
sw $s3, 616($s0)
sw $s3, 620($s0)
sw $s3, 624($s0)

sw $s2, 104($s0)
sw $s2, 108($s0)
sw $s2, 112($s0)
sw $s2, 232($s0)
sw $s2, 488($s0)
sw $s2, 368($s0)
sw $s2, 496($s0)
sw $s2, 364($s0)
sw $s2, 360($s0)
sw $s2, 616($s0)
sw $s2, 620($s0)
sw $s2, 624($s0)

j shift_fr

draw_7_2:
sw $s3, 104($s0)
sw $s3, 108($s0)
sw $s3, 112($s0)
sw $s3, 232($s0)
sw $s3, 488($s0)
sw $s3, 368($s0)
sw $s3, 496($s0)
sw $s3, 364($s0)
sw $s3, 360($s0)
sw $s3, 616($s0)
sw $s3, 620($s0)
sw $s3, 624($s0)

sw $s2, 104($s0)
sw $s2, 108($s0)
sw $s2, 240($s0)
sw $s2, 112($s0)
sw $s2, 368($s0)
sw $s2, 496($s0)

sw $s2, 624($s0)

j shift_fr 

draw_8_2:
sw $s3, 104($s0)
sw $s3, 108($s0)
sw $s3, 240($s0)
sw $s3, 112($s0)
sw $s3, 368($s0)
sw $s3, 496($s0)

sw $s3, 624($s0)

sw $s2, 104($s0)
sw $s2, 108($s0)
sw $s2, 112($s0)
sw $s2, 232($s0)
sw $s2, 240($s0)
sw $s2, 488($s0)
sw $s2, 368($s0)
sw $s2, 496($s0)
sw $s2, 364($s0)
sw $s2, 360($s0)
sw $s2, 616($s0)
sw $s2, 620($s0)
sw $s2, 624($s0)

j shift_fr

draw_9_2:
sw $s3, 104($s0)
sw $s3, 108($s0)
sw $s3, 112($s0)
sw $s3, 232($s0)
sw $s3, 240($s0)
sw $s3, 488($s0)
sw $s3, 368($s0)
sw $s3, 496($s0)
sw $s3, 364($s0)
sw $s3, 360($s0)
sw $s3, 616($s0)
sw $s3, 620($s0)
sw $s3, 624($s0)

sw $s2, 104($s0)
sw $s2, 108($s0)
sw $s2, 112($s0)
sw $s2, 232($s0)
sw $s2, 240($s0)
sw $s2, 368($s0)
sw $s2, 496($s0)
sw $s2, 364($s0)
sw $s2, 360($s0)
sw $s2, 616($s0)
sw $s2, 620($s0)
sw $s2, 624($s0)

j shift_fr




shift_fr:
addi $t5, $t1, -128 # keep track of each row

shift_inner_loop:
add $t4, $t5, $zero # keep track of each column
addi $t7, $s0, 136
beq $t5, $t7, continue_outer_loop

shift_inner_2:
lw $t6, 0($t4)
beq $t6, $s2, shift_inner_end
beq $t6, $s4, ctnue_shift # to ignore the actual tetromino
lw $t9, 0($t4)
sw $t9, 256($t4)

ctnue_shift:
addi $t4, $t4, 4
j shift_inner_2

shift_inner_end:
# sw $s4, 0($t5)
addi $t5, $t5, -128
j shift_inner_loop

continue_outer_loop:
beq $t9, 1, exit
addi $t2, $t2, 1
addi, $t1, $t1, 256
j row_loop
    
    
# the actual tetromino 
tetromino:
sw $s4, 0($s6)
sw $s4, 4($s6)
sw $s4, 128($s6)
sw $s4, 132($s6)
sw $s4, 256($s6)
sw $s4, 260($s6)
sw $s4, 384($s6)
sw $s4, 388($s6)
sw $s4, 264($s6)
sw $s4, 268($s6)
sw $s4, 392($s6)
sw $s4, 396($s6)
sw $s4, 520($s6)
sw $s4, 648($s6)
sw $s4, 524($s6)
sw $s4, 652($s6)

# check if game over:
check_if_GO:
lw $t3, 780($s6)
beq $t3, $s1, game_over #means game over, so draw message
j check_512

check_512:
lw $t3, 512($s6)
beq $t3, $s1, game_over #means game over, so draw message
j check_key

game_over:
#Redraw the board to black first:
add $t3, $s0, 8 #first pixel to start clearing
add $t8, $zero, $zero #keep track of rows 
redraw_board_outer_loop:
add $t9, $t3, $zero #keep track of columns
beq $t8, 30, draw_GO_message
add $t5, $zero, $zero #keep track of column
per_row_loop:
beq $t5, 28, redraw_board_outer_loop_end 
sw $s3, 0($t9)
addi $t9, $t9, 4
addi $t5, $t5, 1
j per_row_loop

redraw_board_outer_loop_end:
addi $t8, $t8, 1
addi $t3, $t3, 128
j redraw_board_outer_loop

    
draw_GO_message:
sw $s2, 1568($s0)
sw $s2, 1572($s0)
sw $s2, 1576($s0)
sw $s2, 1580($s0)
sw $s2, 1584($s0)

sw $s2, 1696($s0)
sw $s2, 1824($s0)
sw $s2, 1952($s0)
sw $s2, 2080($s0)
sw $s2, 2208($s0)
sw $s2, 2336($s0)
sw $s2, 2464($s0)

sw $s2, 2468($s0)
sw $s2, 2472($s0)
sw $s2, 2476($s0)
sw $s2, 2480($s0)

sw $s2, 2352($s0)
sw $s2, 2224($s0)
sw $s2, 2096($s0)
sw $s2, 2092($s0)
sw $s2, 2088($s0)

sw $s2, 1596($s0)
sw $s2, 1724($s0)
sw $s2, 1852($s0)
sw $s2, 1980($s0)
sw $s2, 2108($s0)
sw $s2, 2236($s0)
sw $s2, 2364($s0)
sw $s2, 2492($s0)

sw $s2, 1600($s0)
sw $s2, 1604($s0)
sw $s2, 1608($s0)
sw $s2, 1612($s0)
sw $s2, 1600($s0)

sw $s2, 1740($s0)
sw $s2, 1868($s0)
sw $s2, 1996($s0)
sw $s2, 2124($s0)
sw $s2, 2252($s0)
sw $s2, 2380($s0)
sw $s2, 2508($s0)

sw $s2, 2504($s0)
sw $s2, 2500($s0)
sw $s2, 2496($s0)
sw $s2, 2492($s0)

#exclamation mark:
sw $s2, 2520($s0)
sw $s2, 2264($s0)
sw $s2, 2136($s0)
sw $s2, 2008($s0)
sw $s2, 1880($s0)
sw $s2, 1752($s0)
sw $s2, 1624($s0)

li $v0 , 32
li $a0 , 250
syscall

check_retry:
li $v0 , 32
li $a0 , 1000
syscall

lw $t0, ADDR_KBRD               # $t0 = base address for keyboard
    lw $t8, 0($t0)                  # Load first word from keyboard
    beq $t8, 1, keyboard_input_2      # If first word 1, key is pressed
    b check_retry # change so it jumps to check for the next key instead
    
    
    
keyboard_input_2:                     # A key is pressed
    lw $a0, 4($t0)                  # Load second word from keyboard
    beq $a0, 0x72, respond_to_r
    b check_retry
    
respond_to_r:
#Redraw the board to black first:
add $t3, $s0, 8 #first pixel to start clearing
add $t8, $zero, $zero #keep track of rows 
redraw_board_outer_loop_r:
add $t9, $t3, $zero #keep track of columns
beq $t8, 30, end
add $t5, $zero, $zero #keep track of column
per_row_loop_r:
beq $t5, 28, redraw_board_outer_loop_end_r 
sw $s3, 0($t9)
addi $t9, $t9, 4
addi $t5, $t5, 1
j per_row_loop_r

redraw_board_outer_loop_end_r:
addi $t8, $t8, 1
addi $t3, $t3, 128
j redraw_board_outer_loop_r

end:
j main





check_key:
delay_for_gravity:
    lw $t0, gravitySpeed  # delay count
gravity_delay_loop:
    nop              
    addi $t0, $t0, -2 # Decrement the delay counter
    bne $t0, 0, gravity_delay_loop # Loop until the counter reaches zero
    


move_tetromino_down:

beq $s5, 1, move_tetromino_down_v 
j move_tetromino_down_h 

move_tetromino_down_v:

addi $t6, $s6, 780
lw $t7, 0($t6)
beq $t7, $s1, v_solidify_piece
beq $t7, $s2, v_solidify_piece

addi $t6, $s6, 776
lw $t7, 0($t6)
beq $t7, $s1, v_solidify_piece
beq $t7, $s2, v_solidify_piece

addi $t6, $s6, 516
lw $t7, 0($t6)
beq $t7, $s1, v_solidify_piece

addi $t6, $s6, 512
lw $t7, 0($t6)
beq $t7, $s1, v_solidify_piece

# no collisions, so continue
sw $s3, 0($s6)
sw $s3, 4($s6)
sw $s3, 128($s6)
sw $s3 132($s6)
sw $s3, 256($s6)
sw $s3, 260($s6)
sw $s3, 384($s6)
sw $s3, 388($s6)
sw $s3, 264($s6)
sw $s3, 268($s6)
sw $s3, 392($s6)
sw $s3, 396($s6)
sw $s3, 524($s6)
sw $s3, 520($s6)
sw $s3, 644($s6)
sw $s3, 648($s6)
sw $s3, 652($s6)

#change the position down and draw the new tetromino from there

addi $s6, $s6, 256
sw $s4, 0($s6)
sw $s4, 4($s6)
sw $s4, 128($s6)
sw $s4, 132($s6)
sw $s4, 256($s6)
sw $s4, 260($s6)
sw $s4, 384($s6)
sw $s4, 388($s6)
sw $s4, 264($s6)
sw $s4, 268($s6)
sw $s4, 392($s6)
sw $s4, 396($s6)
sw $s4, 520($s6)
sw $s4, 648($s6)
sw $s4, 524($s6)
sw $s4, 652($s6)

j continue_keys_1

move_tetromino_down_h:
# paste old code here if needed
addi $t6, $s6, 504
lw $t7, 0($t6)
beq $t7, $s1, h_solidify_piece
beq $t7, $s2, h_solidify_piece

addi $t6, $s6, 508
lw $t7, 0($t6)
beq $t7, $s1, h_solidify_piece
beq $t7, $s2, h_solidify_piece

addi $t6, $s6, 512
lw $t7, 0($t6)
beq $t7, $s1, h_solidify_piece
beq $t7, $s2, h_solidify_piece

addi $t6, $s6, 516
lw $t7, 0($t6)
beq $t7, $s1, h_solidify_piece
beq $t7, $s2, h_solidify_piece

addi $t6, $s6, 264
lw $t7, 0($t6)
beq $t7, $s1, h_solidify_piece

addi $t6, $s6, 268
lw $t7, 0($t6)
beq $t7, $s1, h_solidify_piece


# no collisions, continue
sw $s3, 384($s6)
sw $s3, 256($s6)
sw $s3, 128($s6)
sw $s3, 0($s6)
sw $s3, 388($s6)
sw $s3, 260($s6)
sw $s3, 132($s6)
sw $s3, 4($s6)
sw $s3, 8($s6)
sw $s3, 12($s6)
sw $s3 136($s6)
sw $s3 140($s6)
sw $s3 380($s6)
sw $s3 376($s6)
sw $s3 252($s6)
sw $s3 248($s6)

addi $s6, $s6, 256
sw $s4, 0($s6)
sw $s4, 4($s6)
sw $s4, 12($s6)
sw $s4, 252($s6)
sw $s4, 248($s6)
sw $s4, 380($s6)
sw $s4, 376($s6)
sw $s4, 128($s6)
sw $s4, 132($s6)
sw $s4, 136($s6)
sw $s4, 140($s6)
sw $s4, 260($s6)
sw $s4, 388($s6)
sw $s4, 256($s6)
sw $s4, 384($s6)
sw $s4, 8($s6)

j continue_keys_1


v_solidify_piece:
sw $s1, 0($s6)
sw $s1, 4($s6)
sw $s1, 128($s6)
sw $s1, 132($s6)
sw $s1, 256($s6)
sw $s1, 260($s6)
sw $s1, 384($s6)
sw $s1, 388($s6)
sw $s1, 264($s6)
sw $s1, 268($s6)
sw $s1, 392($s6)
sw $s1, 396($s6)
sw $s1, 520($s6)
sw $s1, 648($s6)
sw $s1, 524($s6)
sw $s1, 652($s6)
add $a3, $zero, $zero

li $v0 , 32
li $a0 , 250
syscall

b game_loop

# check horizontal collisions

h_solidify_piece:
sw $s1, 0($s6)
sw $s1, 4($s6)
sw $s1, 12($s6)
sw $s1, 252($s6)
sw $s1, 248($s6)
sw $s1, 380($s6)
sw $s1, 376($s6)
sw $s1, 128($s6)
sw $s1, 132($s6)
sw $s1, 136($s6)
sw $s1, 140($s6)
sw $s1, 260($s6)
sw $s1, 388($s6)
sw $s1, 256($s6)
sw $s1, 384($s6)
sw $s1, 8($s6)

li $v0 , 32
li $a0 , 250
syscall

b game_loop


continue_keys_1:
    beq $s5, 1, check_vertical_s
j check_horizontal_s

check_horizontal_s:
addi $t3, $s6, 512 # the point of the new tetromino we want to check
lw $t4, 0($t3)  
bne $t4, $s2, continue_check_keys
# add code to add this piece to the bottom of the board, and then spawn new piece at the top
sw $s1, 0($s6)
sw $s1, 4($s6)
sw $s1, 12($s6)
sw $s1, 252($s6)
sw $s1, 248($s6)
sw $s1, 380($s6)
sw $s1, 376($s6)
sw $s1, 128($s6)
sw $s1, 132($s6)
sw $s1, 136($s6)
sw $s1, 140($s6)
sw $s1, 260($s6)
sw $s1, 388($s6)
sw $s1, 256($s6)
sw $s1, 384($s6)
sw $s1, 8($s6)

b game_loop

check_vertical_s:  
addi $t3, $s6, 776 # the point of the new tetromino we want to check
lw $t4, 0($t3)  
bne $t4, $s2, continue_check_keys
sw $s1, 0($s6)
sw $s1, 4($s6)
sw $s1, 128($s6)
sw $s1, 132($s6)
sw $s1, 256($s6)
sw $s1, 260($s6)
sw $s1, 384($s6)
sw $s1, 388($s6)
sw $s1, 264($s6)
sw $s1, 268($s6)
sw $s1, 392($s6)
sw $s1, 396($s6)
sw $s1, 520($s6)
sw $s1, 648($s6)
sw $s1, 524($s6)
sw $s1, 652($s6)
b game_loop



continue_check_keys:
    jal update_gravity_speed
    lw $t0, ADDR_KBRD               # $t0 = base address for keyboard
    lw $t8, 0($t0)                  # Load first word from keyboard
    beq $t8, 1, keyboard_input      # If first word 1, key is pressed
    b check_key # change so it jumps to check for the next key instead
    
    
    
keyboard_input:                     # A key is pressed
    lw $a0, 4($t0)                  # Load second word from keyboard
    beq $a0, 0x77, respond_to_w     # Check if the key w was pressed
    beq $a0 0x61, respond_to_a
    beq $a0 0x73, respond_to_s
    beq $a0, 0x64, respond_to_d
    beq $a0, 0x71, respond_to_q
    beq $a0, 0x70, respond_to_p
    
    b check_key
    
respond_to_p:
pause_game:
# add like a pause sign on the keyboard
add $t3, $s0, 16
li $t4, 0xFFFF00
sw $t4, 0($t3)
sw $t4, 128($t3)
sw $t4, 256($t3)

sw $t4, 8($t3)
sw $t4, 136($t3)
sw $t4, 264($t3)


pause_loop:
    lw $t8, 0($t0)                  # Load the keyboard status again
    beq $t8, 0, pause_loop          # If no key is pressed, stay in the loop

    lw $a0, 4($t0)                  # Load the key pressed
    bne $a0, 0x70, pause_loop       # If 'p' is not pressed, continue waiting

    # Clear the pause message
    sw $s3, 0($t3)
    sw $s3, 128($t3)
    sw $s3, 256($t3)
    
    sw $s3, 8($t3)
    sw $s3, 136($t3)
    sw $s3, 264($t3)
    b check_key
        
    
respond_to_q:
# Is this all I am supposed to do here??
j exit

respond_to_w:
    beq $s5, 1, check_if_next_to_wall # vertical, shouldnt be able to switch to horizontal again here
    j check_if_next_to_bottom # horizontal

check_if_next_to_wall:
addi $t1, $s6, -4
lw $t2, 0($t1)
bne $t2, $s2, check_green
b check_key

check_green:
bne $t2, $s1, check_green_1
b check_key

check_green_1:
addi $t1, $s6, 380
lw $t2, 0($t1)
bne $t2, $s1, respond_to_w_continue
b check_key


check_if_next_to_bottom:
addi $t1, $s6, 512
lw $t2, 0($t1)
bne $t2, $s2, respond_to_w_continue
b check_key

respond_to_w_continue: 
    beq $s5, 0, set_1
    add $s5, $zero, $zero
    j draw_tetromino
set_1:
    addi $s5, $zero, 1
    j draw_tetromino 
    
draw_tetromino:
beq $s5, 1, draw_vertical
j draw_horizontal 

draw_vertical:
    add $a1, $s5, $zero # rotation state
    add $a2, $s6, $zero # pivot point
    jal clear_tetromino

sw $s4, 0($s6)
sw $s4, 4($s6)
sw $s4, 128($s6)
sw $s4, 132($s6)
sw $s4, 256($s6)
sw $s4, 260($s6)
sw $s4, 384($s6)
sw $s4, 388($s6)
sw $s4, 264($s6)
sw $s4, 268($s6)
sw $s4, 392($s6)
sw $s4, 396($s6)
sw $s4, 520($s6)
sw $s4, 648($s6)
sw $s4, 524($s6)
sw $s4, 652($s6)

li $v0 , 32
li $a0 , 250
syscall

b check_key

draw_horizontal:
    add $a1, $s5, $zero # rotation state
    add $a2, $s6, $zero # pivot point
    jal clear_tetromino

sw $s4, 0($s6)
sw $s4, 4($s6)
sw $s4, 12($s6)
sw $s4, 252($s6)
sw $s4, 248($s6)
sw $s4, 380($s6)
sw $s4, 376($s6)
sw $s4, 128($s6)
sw $s4, 132($s6)
sw $s4, 136($s6)
sw $s4, 140($s6)
sw $s4, 260($s6)
sw $s4, 388($s6)
sw $s4, 256($s6)
sw $s4, 384($s6)
sw $s4, 8($s6)

li $v0 , 32
li $a0 , 250
syscall

b check_key

respond_to_a:
#check col was here
add $a3, $zero, $zero
jal check_collisions

beq $v0, 1, check_key

beq $s5, 1, check_vertical
j check_horizontal

check_horizontal:
addi $t1, $s6, 372 # the point of the new tetromino we want to check
lw $t2, 0($t1)  # Load the value from memory at the address in $t1 into $t2
bne $t2, $s2, check_green_2
b check_key

check_green_2:
bne $t2, $s1, check_green_2_h
b check_key

check_green_2_h:
addi $t1, $s6, -4
lw $t2, 0($t1)  # Load the value from memory at the address in $t1 into $t2
bne $t2, $s2, continue
b check_key

check_vertical: 
addi $t1, $s6, -4
lw $t2, 0($t1)  # Load the value from memory at the address in $t1 into $t2
bne $t2, $s2, check_green_3
b check_key

check_green_3:
bne $t2, $s1, check_green_4
b check_key

check_green_4:
addi $t1, $s6, 380
lw $t2, 0($t1)
bne $t2, $s1, check_green_5
b check_key

check_green_5:
addi $t1, $s6, 516
lw $t2, 0($t1)
bne $t2, $s1, continue
b check_key

continue:
beq $s5, 0, horizontal_shift_left
j vertical_shift_left

horizontal_shift_left:
sw $s3, 384($s6)
sw $s3, 256($s6)
sw $s3, 128($s6)
sw $s3, 0($s6)
sw $s3, 388($s6)
sw $s3, 260($s6)
sw $s3, 132($s6)
sw $s3, 4($s6)
sw $s3, 8($s6)
sw $s3, 12($s6)
sw $s3 136($s6)
sw $s3 140($s6)
sw $s3 380($s6)
sw $s3 376($s6)
sw $s3 252($s6)
sw $s3 248($s6)

addi $s6, $s6, -8
sw $s4, 0($s6)
sw $s4, 4($s6)
sw $s4, 12($s6)
sw $s4, 252($s6)
sw $s4, 248($s6)
sw $s4, 380($s6)
sw $s4, 376($s6)
sw $s4, 128($s6)
sw $s4, 132($s6)
sw $s4, 136($s6)
sw $s4, 140($s6)
sw $s4, 260($s6)
sw $s4, 388($s6)
sw $s4, 256($s6)
sw $s4, 384($s6)
sw $s4, 8($s6)

li $v0 , 32
li $a0 , 250
syscall

b check_key

vertical_shift_left:
sw $s3, 0($s6)
sw $s3, 4($s6)
sw $s3, 128($s6)
sw $s3 132($s6)
sw $s3, 256($s6)
sw $s3, 260($s6)
sw $s3, 384($s6)
sw $s3, 388($s6)
sw $s3, 264($s6)
sw $s3, 268($s6)
sw $s3, 392($s6)
sw $s3, 396($s6)
sw $s3, 524($s6)
sw $s3, 520($s6)
sw $s3, 644($s6)
sw $s3, 648($s6)
sw $s3, 652($s6)

addi $s6, $s6, -8
sw $s4, 0($s6)
sw $s4, 4($s6)
sw $s4, 128($s6)
sw $s4, 132($s6)
sw $s4, 256($s6)
sw $s4, 260($s6)
sw $s4, 384($s6)
sw $s4, 388($s6)
sw $s4, 264($s6)
sw $s4, 268($s6)
sw $s4, 392($s6)
sw $s4, 396($s6)
sw $s4, 520($s6)
sw $s4, 648($s6)
sw $s4, 524($s6)
sw $s4, 652($s6)

li $v0 , 32
li $a0 , 250
syscall

b check_key

respond_to_s:
add $a3, $zero, $zero
jal check_collisions

beq $v0, 1, check_key
#check col was here
beq $s5, 0, horizontal_move_down
j vertical_move_down

horizontal_move_down:
sw $s3, 384($s6)
sw $s3, 256($s6)
sw $s3, 128($s6)
sw $s3, 0($s6)
sw $s3, 388($s6)
sw $s3, 260($s6)
sw $s3, 132($s6)
sw $s3, 4($s6)
sw $s3, 8($s6)
sw $s3, 12($s6)
sw $s3 136($s6)
sw $s3 140($s6)
sw $s3 380($s6)
sw $s3 376($s6)
sw $s3 252($s6)
sw $s3 248($s6)

addi $s6, $s6, 256
sw $s4, 0($s6)
sw $s4, 4($s6)
sw $s4, 12($s6)
sw $s4, 252($s6)
sw $s4, 248($s6)
sw $s4, 380($s6)
sw $s4, 376($s6)
sw $s4, 128($s6)
sw $s4, 132($s6)
sw $s4, 136($s6)
sw $s4, 140($s6)
sw $s4, 260($s6)
sw $s4, 388($s6)
sw $s4, 256($s6)
sw $s4, 384($s6)
sw $s4, 8($s6)

li $v0 , 32
li $a0 , 250
syscall

b check_key


vertical_move_down:
# remove previous tetromino
sw $s3, 0($s6)
sw $s3, 4($s6)
sw $s3, 128($s6)
sw $s3 132($s6)
sw $s3, 256($s6)
sw $s3, 260($s6)
sw $s3, 384($s6)
sw $s3, 388($s6)
sw $s3, 264($s6)
sw $s3, 268($s6)
sw $s3, 392($s6)
sw $s3, 396($s6)
sw $s3, 524($s6)
sw $s3, 520($s6)
sw $s3, 644($s6)
sw $s3, 648($s6)
sw $s3, 652($s6)

#change the position down and draw the new tetromino from there

addi $s6, $s6, 256
sw $s4, 0($s6)
sw $s4, 4($s6)
sw $s4, 128($s6)
sw $s4, 132($s6)
sw $s4, 256($s6)
sw $s4, 260($s6)
sw $s4, 384($s6)
sw $s4, 388($s6)
sw $s4, 264($s6)
sw $s4, 268($s6)
sw $s4, 392($s6)
sw $s4, 396($s6)
sw $s4, 520($s6)
sw $s4, 648($s6)
sw $s4, 524($s6)
sw $s4, 652($s6)

li $v0, 32
li $a0, 250
syscall

b check_key

respond_to_d:
add $a3, $zero, $zero
jal check_collisions

beq $v0, 1, check_key
#check col was here
beq $s5, 1, check_vertical_d
j check_horizontal_d

check_horizontal_d:
addi $t1, $s6, 16 # the point of the new tetromino we want to check
lw $t2, 0($t1)  # Load the value from memory at the address in $t1 into $t2
bne $t2, $s2, check_collisions_with_green
b check_key

check_collisions_with_green:
bne $t2, $s1, continue_d
b check_key

check_vertical_d: 
addi $t1, $s6, 272
lw $t2, 0($t1)  # Load the value from memory at the address in $t1 into $t2
bne $t2, $s2, check_collision_1
b check_key

check_collision_1:
bne $t2, $s1, check_collision_2
b check_key

check_collision_2:
addi $t1, $s6, 656
lw $t2, 0($t1)  # Load the value from memory at the address in $t1 into $t2
bne $t2, $s2, check_collision_3_1
b check_key

check_collision_3_1:
bne $t2, $s1, check_collision_3
b check_key

check_collision_3:
addi $t1, $s6, 8
lw $t2, 0($t1)  # Load the value from memory at the address in $t1 into $t2
bne $t2, $s2, continue_d_before
b check_key

continue_d_before:
bne $t2, $s1, continue_d
b check_key

continue_d:
beq $s5, 0, horizontal_move_right
j vertical_move_right 

horizontal_move_right:
sw $s3, 384($s6)
sw $s3, 256($s6)
sw $s3, 128($s6)
sw $s3, 0($s6)
sw $s3, 388($s6)
sw $s3, 260($s6)
sw $s3, 132($s6)
sw $s3, 4($s6)
sw $s3, 8($s6)
sw $s3, 12($s6)
sw $s3 136($s6)
sw $s3 140($s6)
sw $s3 380($s6)
sw $s3 376($s6)
sw $s3 252($s6)
sw $s3 248($s6)

addi $s6, $s6, 8
sw $s4, 0($s6)
sw $s4, 4($s6)
sw $s4, 12($s6)
sw $s4, 252($s6)
sw $s4, 248($s6)
sw $s4, 380($s6)
sw $s4, 376($s6)
sw $s4, 128($s6)
sw $s4, 132($s6)
sw $s4, 136($s6)
sw $s4, 140($s6)
sw $s4, 260($s6)
sw $s4, 388($s6)
sw $s4, 256($s6)
sw $s4, 384($s6)
sw $s4, 8($s6)

li $v0 , 32
li $a0 , 250
syscall

b check_key

vertical_move_right:
# remove previous tetromino
sw $s3, 0($s6)
sw $s3, 4($s6)
sw $s3, 128($s6)
sw $s3 132($s6)
sw $s3, 256($s6)
sw $s3, 260($s6)
sw $s3, 384($s6)
sw $s3, 388($s6)
sw $s3, 264($s6)
sw $s3, 268($s6)
sw $s3, 392($s6)
sw $s3, 396($s6)
sw $s3, 524($s6)
sw $s3, 520($s6)
sw $s3, 644($s6)
sw $s3, 648($s6)
sw $s3, 652($s6)

#change the position down and draw the new tetromino from there

addi $s6, $s6, 8
sw $s4, 0($s6)
sw $s4, 4($s6)
sw $s4, 128($s6)
sw $s4, 132($s6)
sw $s4, 256($s6)
sw $s4, 260($s6)
sw $s4, 384($s6)
sw $s4, 388($s6)
sw $s4, 264($s6)
sw $s4, 268($s6)
sw $s4, 392($s6)
sw $s4, 396($s6)
sw $s4, 520($s6)
sw $s4, 648($s6)
sw $s4, 524($s6)
sw $s4, 652($s6)

li $v0 , 32
li $a0 , 250
syscall

b check_key

update_gravity_speed:
    lw $t1, gravitySpeed      # Load the current gravity speed
    lw $t3, gravitySpeed
    li $t2, 200              # Define the decrement value
    sub $t1, $t1, $t2         # Decrease the gravity speed
    bne $t1, 0, jump_here
    add $t1, $t3, 0
    jr $ra
    jump_here:
    sw $t1, gravitySpeed      # Store the updated speed
    jr $ra                    # Return from the subroutine


clear_tetromino: # given the pivot point of the tetromino, and rotation state:
beq $a1 0, remove_vertical
j remove_horizontal

remove_vertical: 
sw $s3, 0($a2)
sw $s3, 4($a2)
sw $s3, 128($a2)
sw $s3, 132($a2)
sw $s3, 256($a2)
sw $s3, 260($a2)
sw $s3, 384($a2)
sw $s3, 388($a2)
sw $s3, 264($a2)
sw $s3, 268($a2)
sw $s3, 392($a2)
sw $s3, 396($a2)
sw $s3, 520($a2)
sw $s3, 648($a2)
sw $s3, 524($a2)
sw $s3, 652($a2)
j clear_end

remove_horizontal:
sw $s3, 0($a2)
sw $s3, 4($a2)
sw $s3, 8($a2)
sw $s3, 12($a2)
sw $s3, 252($a2)
sw $s3, 248($a2)
sw $s3, 380($a2)
sw $s3, 376($a2)
sw $s3, 128($a2)
sw $s3, 132($a2)
sw $s3, 136($a2)
sw $s3, 140($a2)
sw $s3, 260($a2)
sw $s4, 388($a2)
sw $s4, 256($a2)
sw $s4, 384($a2)
j clear_end

clear_end:
jr $ra    

check_collisions:
beq $s5, 1, check_collisions_v 
j check_collisions_h 

check_collisions_v:
addi $t6, $s6, 780
lw $t7, 0($t6)
beq $t7, $s1, v_solidify_piece_ch
beq $t7, $s2, v_solidify_piece_ch

addi $t6, $s6, 776
lw $t7, 0($t6)
beq $t7, $s1, v_solidify_piece_ch
beq $t7, $s2, v_solidify_piece_ch

addi $t6, $s6, 516
lw $t7, 0($t6)
beq $t7, $s1, v_solidify_piece_ch

addi $t6, $s6, 512
lw $t7, 0($t6)
beq $t7, $s1, v_solidify_piece_ch

# no collisions, so continue

add $v0, $a3, $zero

jr $ra

check_collisions_h:

addi $t6, $s6, 504
lw $t7, 0($t6)
beq $t7, $s1, h_solidify_piece_ch
beq $t7, $s2, h_solidify_piece_ch

addi $t6, $s6, 508
lw $t7, 0($t6)
beq $t7, $s1, h_solidify_piece_ch
beq $t7, $s2, h_solidify_piece_ch

addi $t6, $s6, 512
lw $t7, 0($t6)
beq $t7, $s1, h_solidify_piece_ch
beq $t7, $s2, h_solidify_piece_ch

addi $t6, $s6, 516
lw $t7, 0($t6)
beq $t7, $s1, h_solidify_piece_ch
beq $t7, $s2, h_solidify_piece_ch

addi $t6, $s6, 264
lw $t7, 0($t6)
beq $t7, $s1, h_solidify_piece_ch

addi $t6, $s6, 268
lw $t7, 0($t6)
beq $t7, $s1, h_solidify_piece_ch

# no collisions, continue
add $v0, $a3, $zero

jr $ra


v_solidify_piece_ch:
sw $s1, 0($s6)
sw $s1, 4($s6)
sw $s1, 128($s6)
sw $s1, 132($s6)
sw $s1, 256($s6)
sw $s1, 260($s6)
sw $s1, 384($s6)
sw $s1, 388($s6)
sw $s1, 264($s6)
sw $s1, 268($s6)
sw $s1, 392($s6)
sw $s1, 396($s6)
sw $s1, 520($s6)
sw $s1, 648($s6)
sw $s1, 524($s6)
sw $s1, 652($s6)

li $v0 , 32
li $a0 , 250
syscall

addi $v0 $a3, 1

jr $ra

# check horizontal collisions

h_solidify_piece_ch:
sw $s1, 0($s6)
sw $s1, 4($s6)
sw $s1, 12($s6)
sw $s1, 252($s6)
sw $s1, 248($s6)
sw $s1, 380($s6)
sw $s1, 376($s6)
sw $s1, 128($s6)
sw $s1, 132($s6)
sw $s1, 136($s6)
sw $s1, 140($s6)
sw $s1, 260($s6)
sw $s1, 388($s6)
sw $s1, 256($s6)
sw $s1, 384($s6)
sw $s1, 8($s6)

li $v0 , 32
li $a0 , 250
syscall

addi $v0, $a3, 1

jr $ra




























	# 1a. Check if key has been pressed
    # 1b. Check which key has been pressed
    # 2a. Check for collisions
	# 2b. Update locations (paddle, ball)d
	# 3. Draw the screen
	# 4. Sleep

    #5. Go back to 1
    b game_loop

exit:
    li $v0, 10              # terminate the program gracefully
    syscall
