#-------------------------------------------------------------------------------
# lcrand.s
#
# This program prompts the user for a min and max integer value and then for an
# integer number of results to produce.  Finally, it asks for a number to use as
# a random number seed. With those four values properly entered, it loops
# generating a series of random numbers that fit between the min and max values
# previously entered, using the Linear Congruence algorithm.
#
# This is intended to be the first project in Assembly Language written by
# students in CS200 at NAU as an introduction to the language.  It does not
# require the use of subroutines or other advanced techniques.
#
# Author: Travian Lenox
# Date:   11/8
#
# Revision Log 
#-------------------------------------------------------------------------------
# 10/02/2023 - Created Skeleton for student use
#-------------------------------------------------------------------------------

        .data
# constants
Multiplier:	.word	1073807359	# a sufficiently large prime

# You probably have enough registers that you won't need variables.
# However, if you do wish to have named variables, do it here.
# Word Variables First
minMinInput:	.word	0
maxMinInput:	.word	998
maxMaxInput:	.word	1000
maxRandom:	.word	100
minRandom:	.word	5
minSeed:	.word	1073741824
maxSeed:	.word	2147483646


# HalfWord Variables Next

# Byte Variables Last (Strings and characters are Byte data)
outputStart:	.asciiz "Here comes the numbers!"
outputEnd:	.asciiz "Thats all folks!"

# common strings
minPrompt:	.asciiz	"Enter the smallest number acceptable (0<=n<=998): "
maxPrompt:	.asciiz "Enter the biggest number acceptable ( n <= 1000): "
qtyPrompt:	.asciiz "How many randoms do you want (5 - 100)? "
rsdPrompt:	.asciiz "Enter a seed number (1073741824 - 2147483646): "
smErr1:		.asciiz "That number is too small, try again: "
smErr2:		.asciiz "The max cannot be less than the min, try again: "
bgErr:		.asciiz "That number is too large, try again: "	
outStr:		.asciiz "Here is the series of randoms:\n"
newLine:	.asciiz "\n"

	.text
	.globl	main
#-------------------------------------------------------------------------------
# The start: entry point from the MIPS file is encompassed in the kernel code 
# of the QTSPIM simulator.  This version starts with main: which does everything
# in this simple program.
#-------------------------------------------------------------------------------

main:		
	#load $t0 with multiplier
	lw $t0, Multiplier

minFind:		

	#load prompt and print 	
	la 	$a0, minPrompt
	li 	$v0, 4
	syscall	
		
minRetry:
	
	#get input from user 
	li 	$v0, 5
	syscall
			
	#load input and compare to lowest min value variable
	#If greater than min brance to next step
	#else print error and retry 
	la	$a0, ($v0)
	lw 	$s7, minMinInput
	bge   	$a0, $s7, minGreater
	la 	$a0, smErr1
	li 	$v0, 4
	syscall
	j minRetry
			
	
minGreater:
	
	#load highest min value and compare to input
	#if input is less than highest min value, branch to next step
	#else print error and retry 
	lw 	$s7, maxMinInput
	ble 	$a0, $s7, maxFind
	la 	$a0, bgErr
	li	$v0, 4
	syscall
	j minRetry
	

maxFind:
	
	#save previous input
	la	$t1, ($a0)
			
	#load max prompt and print 
	la	$a0, maxPrompt
	li	$v0, 4
	syscall		
		
maxRetry:

	#get user input 
	li	$v0, 5
	syscall
	
	#compare input to min value input
	#if greather than continue,
	#else print error and retry 
	la	$a0, ($v0)
	bge	$a0, $t1, maxGreater
	la	$a0, smErr2
	li	$v0, 4
	syscall
	j maxRetry	
			
maxGreater:

	#Load highest max value and compare it to input
	#if less than highest value continue to next step
	#else print error retry
	lw	$s7, maxMaxInput
	ble	$a0, $s7, NumRandom
	la	$a0, bgErr
	li	$v0, 4
	syscall
	j maxRetry

		
NumRandom:
	
	#save previous input
	la	$t2, ($a0)
			
	#load prompt and print 
	la	$a0, qtyPrompt
	li	$v0, 4
	syscall		
		
randomRetry:

	#get user input 
	li	$v0, 5
	syscall

			
	#load min random number value compare to input
	#if greather than continue to next step
	#else print error and retry 
	la	$a0, ($v0)
	lw	$s7, minRandom
	bge	$a0, $s7, randomGreater
	la	$a0, smErr1
	li	$v0, 4
	syscall
	j	randomRetry
			
randomGreater:

	#load max random number value compare to input
	#if less than continue to next step
	#else print error and retry 
	lw	$s7, maxRandom
	ble	$a0, $s7, seedNumber
	la	$a0, bgErr
	li	$v0, 4
	syscall
	j 	randomRetry
	
seedNumber:
	
	#save previous input
	la	$t3, ($a0)
			
	#load and print prompt
	la	$a0, rsdPrompt
	li	$v0, 4
	syscall

seedRetry:
	
	#get user input
	li	$v0, 5
	syscall
		
	#load min seed possiblity and compare to input
	#if greater than continue to next step
	#else print error and retry 
	lw	$s7, minSeed
	la	$a0, ($v0)
	bge	$a0, $s7, seedGreater
	la	$a0, smErr1
	li	$v0, 4
	syscall
	j seedRetry
			
	
seedGreater:

	#load max seed possibility and compare to input
	#if less than continue to next step
	#else print error and retry
	lw	$s7, maxSeed
	ble 	$a0, $s7, outRange
	la	$a0, bgErr
	li	$v0, 4
	syscall
	j seedRetry

outRange:
	#save previous input
	la	$t4, ($a0)
	
	#subtract min range from max range
	#add 1 and continue to next step
	sub	$t5, $t2, $t1
	addi	$t5, $t5, 1
	j generatorLoop
	

generatorLoop:
	
	
	#print out the starting comment for user
	la	$a0, outputStart
	li	$v0, 4
	syscall
	la	$a0, newLine
	li	$v0, 4
	syscall
	la 	$a0, outStr
	li	$v0, 4
	syscall

loopStart:

	#set loop to end once value equals 0
	#minus one each time it doesnt equal zero
	beqz 	$t3, loopEnd
	addi	$t3, $t3, -1
		# top of random generator loop
		
			# first generate a random
	#multiply the seed by the multiplier
	multu 	$t4, $t0
	#set seed to lo value
	mflo 	$t4
	#set random number start to hi value
	mfhi	$s0
			

	#divide the raw random by the precalculated range
	div  	$s0, $t5
	#set hi value to register
	mfhi	$s1

	#add minimum to the hi value
	add	$a0, $s1, $t1
	#print out the result
	li	$v0, 1
	syscall	
	#print out a newline or " " to separate the next
	#jump to start of loop
	la	$a0, newLine
	li	$v0, 4
	syscall
	j loopStart
	

loopEnd:
	#load end prompt and print
	la	$a0, outputEnd
	li	$v0, 4
	syscall
		# exit program
		li	$v0, 10
		syscall