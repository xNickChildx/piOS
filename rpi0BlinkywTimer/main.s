
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
ldr r0,=5000
bl Wait

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
ldr r0, =50000
bl Wait

/*
* Loop over this process forevermore
*/
b loop$
