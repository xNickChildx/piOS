.globl GetGpioAddress
GetGpioAddress:
ldr r0,=0x20200000
mov pc,lr  //copies link register (return address) back into program counter, returning from function

.globl SetGpioFunction
SetGpioFunction:
	cmp r0,#53
	cmpls r1,#7
	movhi pc,lr  		//returns back to function if pin is >53 or if function select is >7
	push {lr}
	mov r2,r0			//else pushes return address and r0 because they will be overwriten
	bl GetGpioAddress	//r0 now holds gpioaddress

	functionLoop$:

		cmp r2,#9
		subhi r2,#10				//finds what register for function select
		addhi r0,#4					//increases location of memory for every register
		bhi functionLoop$
		add r2, r2,lsl #1			//3 bits per pin so multipies pin number by 3 to get bit# to write to
		lsl r1,r2					//r1 holds function and r2 holds bit so moves the functions select to the proper bit
		str r1,[r0]					//stores final select in address pointed to by r0 (gpioSet)
		pop {pc}					//sets pc back to return address that was pushed


.globl SetGpio
SetGpio:
	pinNum .req r0		//pinNum points to r0
	pinVal .req r1		//u get it
	cmp pinNum,#53		
	movhi pc,lr		//return if icorrect pin number is given
	push {lr}	
	mov r2,pinNum		//pinNum stored in r2
	.unreq pinNum		//remove alias
	pinNum .req r2		//pinNum points to r2
	bl GetGpioAddress
	gpioAddr .req r0	//gpioaddr points to r0
	pinBank .req r3
	lsr pinBank,pinNum,#5		//divides pin by 32 and stores it in pinBank, determines if in first bank or second
	lsl pinBank,#2				//multiplies by 4
	add gpioAddr,pinBank		//will hold gpioaddr+0 or gpioaddr+4
	.unreq pinBank
	and pinNum,#31				//gets remainder to find bit in bank to set, 31 is 11111 in binary so answer is only 0-31
	setBit .req r3
	mov setBit,#1
	lsl setBit,pinNum			//sets 1 in the bit we want to write to
	.unreq pinNum
	teq pinVal,#0				//tests if pinVal is eq to 0
	.unreq pinVal				
	streq setBit,[gpioAddr,#40]	//if 0 then set to off
	strne setBit,[gpioAddr,#28]	//if 1 set on
	.unreq setBit
	.unreq gpioAddr
	pop {pc}			//finally for the love of god return