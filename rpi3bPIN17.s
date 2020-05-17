/*
*Assembly code to set PIN 17 on Rpi3B to output and turn ON
*
*/
.section .init
.globl _start
_start:

/* 
* This command loads the physical address of the GPIO region into r0.
*/
ldr r0,=0x3F200000

/*
* Our register use is as follows:
* r0=0x20200000	the address of the GPIO region on Rpi1.
* 0x3F200000 on rpi 2 and 3
*/
mov r1,#1		//1 is used as output
lsl r1,#21		//shift 21 bits to set pin 17 as output

/*
* Set the GPIO function select.
*/
str r1,[r0,#4]		//puts the function select at 0x3F200004

/* 
* Set the 17th bit of r1 to turn on
*/
mov r1,#1
lsl r1,#17

/* 
* Set GPIO 17 to low, causing the LED to turn on.
*/
str r1,[r0,#28]		//puts function set at 0x3F20001C (PIN Output Set 1)

/*
* Loop over this forevermore
*/
loop$: 
b loop$
