
.section .init
.globl _start
_start:

b main

.section .text
main:
mov sp,#0x8000			//sets location of stack to a good spot

pinNum .req r0		
pinFunc .req r1
mov pinNum,#47			//pin 47
mov pinFunc,#1			//output
bl SetGpioFunction
.unreq pinNum
.unreq pinFunc
loop$: 

/*
* Set GPIO 47 to low, causing the LED to turn on.
*/
pinNum .req r0
pinVal .req r1
mov pinNum,#47
mov pinVal,#0
bl SetGpio
.unreq pinNum
.unreq pinVal

/* NEW
* Now, to create a delay, we busy the processor on a pointless quest to 
* decrement the number 0x3F0000 to 0!
*/
mov r2,#0x3F0000
wait1$:
	sub r2,#1
	cmp r2,#0
	bne wait1$

/* NEW
* Set GPIO 16 to high, causing the LED to turn off.
*/
pinNum .req r0
pinVal .req r1
mov pinNum,#47
mov pinVal,#1
bl SetGpio
.unreq pinNum
.unreq pinVal

/* NEW
* Wait once more.
*/
mov r2,#0x3F0000
wait2$:
	sub r2,#1
	cmp r2,#0
	bne wait2$

/*
* Loop over this process forevermore
*/
b loop$
