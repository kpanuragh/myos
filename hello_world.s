; move 0x07c0 to ax register
mov ax, 0x07c0
; set ax to ds for starting address of data segement register
; ds is special register some reason we can't directly assign value to ds register(some intel stuff)
;only general purpose register is used to assign value to ds register 
;bios load MBR(master boot record) all time in 0x07c0:0x0000 so that is the reason behind setting 0x07c0 to ds 
mov ds,ax
;calling video mode interpter
;to call video mode first we need to set 0x0 to ah register
;then setting 0x3 to al to setup 80 character by 25 character
;then call 0x10 for video service for more information search bios intrepts 
mov ah,0x0
mov al,0x3
int 0x10
;get string from variable to sourse index register set ah to 0xoe for teletype mode intrept 
mov si,msg
mov ah,0x0e
;creating print label to manage string printing functionality
print_string:
	lodsb ; lodsb instruction load a byte to al register from segmented adress ds:si and si register move to next byte
	or al,al ; or condition for checking the string is terminated or not in ascii string terminated by null character which is zero in binary so if the al==0 then zero flag set 1
	jz exit ; jz means jump if zero flag set to 1. if string is terminated then we need to exit from print_string loop
	int 0x10 ; call teletype intrepter to print or display charcter
	jmp print_string ; unconditional jump if the charcter is not null or zero we need to print next character by usring this unconditional jump
;define msg string variable
msg:
	db 'Hello World..',13,10,0 ;db store Hello world to msg and also stroe 13 and 10 13 stands for \r and 10 stands for \n in ascii and also 0 for string termination
exit:
;510-($-$$) means $ is current line and $$ means begining of the program this will get rest of the place and db used to fill 0 to rest of the byte
	jmp $ ; jump current line uncondtionally for infinit loop to run os continuesly $ means current line so current line run infintly  
	times 510-($-$$) db 0;time used to run multiple time  we need to fill rest of the line to 0 upto 510 byte
	
	db 0x55
	db 0xaa ;  we need to set last 2byte of 512byte to 0x55aa for bios to identifying the boot sector 0x55aa is the magic number for boot section

	
