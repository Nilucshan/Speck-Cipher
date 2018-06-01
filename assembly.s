@Siva Nilucshan (E/13/239)
@Computer Architecture

.text @instruction memory
.global main

main:
	sub sp,sp,#4
	str lr,[sp,#0]  
	
	@prompting for the input
	ldr r0,=enterKey
	bl printf	

	@ stack handling
	sub sp,sp,#8

	@scanf get a hexadecimal first key input
	ldr r0,=formats
	mov r1,sp
	bl scanf

	ldr r4,[sp,#4]      
	ldr r5,[sp,#0]      

	@scanf 	get  a hexadecimal second key	
	ldr r0,=formats
	mov r1,sp
	bl scanf

	ldr r6,[sp,#4]       
	ldr r7,[sp,#0]       

	ldr r0,=plainText
	bl printf

	@scanf and storing the first plain text
	ldr r0,=formats
	mov r1,sp
	bl scanf
	ldr r8,[sp,#4]     
	ldr r9,[sp,#0]     

	
	@scanf and storing the second plain text		
	ldr r0,=formats
	mov r1,sp
	bl scanf

	ldr r10,[sp,#4]        
	ldr r11,[sp,#0]        

	@ stack handling
	add sp,sp,#8

	ldr r0,=cypherText
	bl printf
	
	@RFUNCTION R(x,y,b)

	@ROR call
	mov r0,r8        
	mov r1,r9
	bl ROR

	@updating
	mov r8,r0        
	mov r9,r1

	adds r9,r9,r11   
	adc r8,r8,r10    

	eor r8,r8,r6     
	eor r9,r9,r7     

	@ROL call
	mov r0,r10       
	mov r1,r11
	bl ROL

	@updating
	mov r10,r0       
	mov r11,r1

	eor r10,r10,r8   
	eor r11,r11,r9   

	@setting i as r12
	mov r12,#0 
	b forLoop

forLoop:
	cmp r12,#31
	bge exit

	@ROR call	
	mov r0,r4        
	mov r1,r5
	bl ROR
	@updating
	mov r4,r0        
	mov r5,r1

	adds r5,r5,r7    
	adc r4,r4,r6

	eor r5,r5,r12    

	@ROL call
	mov r0,r6        
	mov r1,r7
	bl ROL
	@update
	mov r6,r0       
	mov r7,r1

	eor r6,r6,r4    
	eor r7,r7,r5

	@ROR call
	mov r0,r8        
	mov r1,r9
	bl ROR
	@update
	mov r8,r0        
	mov r9,r1

	adds r9,r9,r11   
	adc r8,r8,r10

	eor r8,r8,r6     
	eor r9,r9,r7

	@ROL call	
	mov r0,r10       
	mov r1,r11
	bl ROL
	@updating
	mov r10,r0       
	mov r11,r1

	eor r10,r10,r8   
	eor r11,r11,r9

	@incrementing i and calling the loop
	add r12,r12,#1   
	b forLoop           

exit:
	@printing x
	ldr r0,=formatp
	mov r1,r9        
	mov r2,r8       
	bl printf

	@ print y
	ldr r0,=formatfinal
	mov r1,r11       
	mov r2,r10       
	bl printf

	ldr lr,[sp,#0]
	
	@ stack handling
	add sp,sp,#4
	mov pc,lr

RFUNC:	

sub sp,sp,#32
str r0,[sp,#0]
str r1,[sp,#4]
str r2,[sp,#8]
str r3,[sp,#12]
str r4,[sp,#16]
str r5,[sp,#20]
str r6,[sp,#24]
str lr,[sp,#28]

bl ROR
adds r1,r1,r3
adc r0,r0,r2
		
eor r1,r1,r5
eor r0,r0,r4

sub sp,sp,#8
str r0,[sp,#0]
str r1,[sp,#4]


mov r0,r2
mov r1,r3
bl ROL

mov r2,r0
mov r3,r1

ldr r0,[sp,#0]
ldr r1,[sp,#4]
add sp,sp,#8

eor r2,r2,r0
eor r3,r3,r1

ldr r0,[sp,#0]
ldr r1,[sp,#4]
ldr r2,[sp,#8]
ldr r3,[sp,#12]
ldr r4,[sp,#16]
ldr r5,[sp,#20]
ldr r6,[sp,#24]
ldr lr,[sp,#28]

add sp,sp,#32
mov pc,lr



ROR:
	@ allocating stack
	sub sp,sp,#20
	
	str r4,[sp,#0]
	str r5,[sp,#4]
	str r6,[sp,#8]
	str r7,[sp,#12]
	str lr,[sp,#16]

		
	lsr r4,r0,#8	
	lsr r5,r1,#8
	lsl r6,r0,#24		
	lsl r7,r1,#24

	@oring process
	orr r0,r4,r7			
	orr r1,r5,r6		

	@ Stack handling
	ldr r4,[sp,#0]
	ldr r5,[sp,#4]
	ldr r6,[sp,#8]
	ldr r7,[sp,#12]
	ldr lr,[sp,#16]
	
	add sp,sp,#20
	mov pc,lr


ROL:

sub sp,sp,#20
str r4,[sp,#0]
str r5,[sp,#4]
str r6,[sp,#8]
str r7,[sp,#12]
str lr,[sp,#16]

lsl r4,r0,#3
lsr r5,r0,#29
lsl r6,r1,#3
lsr r7,r1,#29

@oring process
orr r0,r4,r7
orr r1,r5,r6

ldr r4,[sp,#0]
ldr r5,[sp,#4]
ldr r6,[sp,#8]
ldr r7,[sp,#12]
ldr lr,[sp,#16]

add sp,sp,#20
mov pc,lr


.data

formats:			.asciz "%llx"
formatp:			.asciz "%llx "
enterKey:			.asciz "Enter the key:\n"
plainText:			.asciz "Enter your plain text:\n"
cypherText:			.asciz "Cypher text is:\n"
formatfinal: 			.asciz "%llx\n"
