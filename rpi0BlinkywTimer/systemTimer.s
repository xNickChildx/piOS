.global GetSystemTimerBase
GetSystemTimerBase:
ldr r0,=0x20003000
mov pc, lr 

.global GetTimeStamp
GetTimeStamp:
push {lr}
bl GetSystemTimerBase
ldrd r0,r1,[r0,#4]  //loads current 8 bit time into r0 (low) and r1(high)
pop {pc}


.global Wait
Wait: //expects amount of miliseconds to wait to be in r0
waitTime .req r2  		//we know funciton will use r0 and r1 in getTimeStamp
mov waitTime,r0 			//move wait time to r2
push {lr}
bl GetTimeStamp
startLow .req r3
mov startLow,r0

loop$:
	bl GetTimeStamp
	curr .req r1
	sub curr,r0,startLow
	cmp curr, waitTime
	.unreq curr
	bls loop$
.unreq waitTime
.unreq startLow
pop {pc}

	


