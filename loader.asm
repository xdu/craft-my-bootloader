;----------------------------------------------------------------------
; Simple boot loader program
;
;----------------------------------------------------------------------
BITS 16
ORG 0x7c00	; This is where BIOS loads the bootloader
jmp entry
	
; ----------------------------------------------------------------------
; Standard FAT12 Floppy
; ----------------------------------------------------------------------
DB	0x90
DB  'HELLOIPL'  ; Boot sector name (8 bytes)
DW	512			; Sector size, must be 512
DB	1			; Cluster size, must be 1
DW	1			; Reserved boot sectors
DB 	2			; FAT copies, must be 2
DW	224			; Root directory entries
DW	2880		; Floppy sectors, must be 2880
DB	0xf0		; Media descriptor, must be 0xf0
DW	9			; Sectors per FAT, must be 9
DW 	18			; Sectors per track, must be 19
DW	2			; Number of heads
DD	0			; Hidden sectors
DD 	2880		; Floppy sectors
DB	0,0,0x29	; Reserved
DD	0x4b35ff0a	; Volume serial number
DB	"HELLO-OS123"	; Floppy name
DB	"FAT12   "		; File system ID

TIMES 18 	DB 0	; 18 times 0x00

; Boot program begins here
entry:
	MOV AX,0
	MOV SS,AX
	MOV SP,0x7c00
	MOV DS,AX

	MOV SI, msg

writeloop:
	MOV AL,[SI]
	ADD SI,1
	CMP AL,0

	JE fin

	MOV AH,0x0e
	MOV BX,15
	INT 0x10
	jmp writeloop

fin:
	HLT
	JMP .

; Data
msg:
	DB 0x0a, 0x0d
	DB 'Boot Loader ...'
	DB 0x0a, 0x0d, 0x0a, 0x0d
	DB 0	; String must end with 0

times 510-$+$$	DB 0	; Fill the rest with 0x0
DB 0x55,0xAA			; Boot signature

; 0x0200 and 0x1400 must start with 0xF0 0xFF 0xFF