
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

ptrn .req r4
ldr ptrn,=pattern
ldr ptrn,[ptrn]
seq .req r5
mov seq,#0			//sets pattern to r5 and current position to r5

loop$: 

/*
* Set GPIO 47 to low, causing the LED to turn on.
*/
pinNum .req r0
mov pinNum,#47

mov r1,#1		
lsl r1,seq  //move it over by seq spaces to get the current instruction
and r1,ptrn    //will store 0 or 1 in r1 to set on/off


bl SetGpio
.unreq pinNum


//delay
ldr r0,=250000
bl Wait

add seq,#1
cmp seq,#32
moveq seq,#0
/*
* Loop over this process forevermore
*/
b loop$

.section .data
.align 2
pattern:								//makes data called pattern that holds S0S in morse code (0 is off 1 is on) 
.int 0b11111111101010100010001000101010
