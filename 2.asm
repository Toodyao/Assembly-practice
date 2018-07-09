DATAS SEGMENT
    ;此处输入数据段代码  
    INT1 DW 1 DUP(0)
    CRLF DB 0AH, 0DH, '$'       ;回车换行
DATAS ENDS

STACKS SEGMENT
    ;此处输入堆栈段代码
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX
    ;此处输入代码段代码
    
    MOV AX, 10
LOOP_JUDGE:
    CMP AX, 200
    JG EXIT
    
    MOV DX, 0           ;DL存返回值
    PUSH AX             ;判断AX是否是素数
    CALL JUDGE
    MOV DH, DL          ;DH存放AX是否是素数
    
	ADD AX, 2           ;判断AX+2是否是素数
	CALL JUDGE
	POP AX
	
	CMP DX, 0101H       ;都是素数
	JNZ SKIP
	
	PUSH AX             ;打印这两个数
	CALL PRINT
	CALL PRINT_SPACE
	ADD AX, 2
	CALL PRINT
	CALL PRINT_CRLF
	POP AX
SKIP:
    INC AX
    JMP LOOP_JUDGE
    
    JMP EXIT
    
;------------JUDGE START----------------
JUDGE PROC              ;判断素数
    PUSH AX
    PUSH DX
    MOV INT1, AX
    MOV BX, INT1
    SHR BX, 1           ;判断范围为2 - int1/2
    
    MOV AX, INT1
    MOV CX, 2
PRIME_LOOP:
    CMP CX, BX          ;是否到了int1/2
    JG PRIME            ;循环结束，是质数
    
    MOV AX, INT1
    MOV DX, 0
    DIV CX              ;INT1 % CX == 0 ?
    CMP DX, 0
    JZ NOT_PRIME
    INC CX
    JMP PRIME_LOOP
    
PRIME:
    POP DX
    MOV DL, 1
    JMP EXIT_PROC
    
NOT_PRIME:
    POP DX
    MOV DL, 0
    JMP EXIT_PROC
    
EXIT_PROC:
    POP AX
    RET
JUDGE ENDP
;-----------JUDGE END-----------------
    
PRINT_BUF PROC
    PUSH AX
    PUSH SI
    PUSH DX
    
    MOV AH, 0           ;打印BUF字符串
    MOV AL, BUF[1]
    MOV SI, AX
    MOV BUF[2][SI], '$'
    MOV DX, OFFSET BUF[2]
    MOV AH, 9
    INT 21H
    
    POP DX
    POP SI
    POP AX
    RET
PRINT_BUF ENDP    
    
;----------PRINT START----------------
PRINT PROC               ;递归打印数
    PUSH AX
    PUSH BX
    PUSH DX
    
    MOV BX, 10

    MOV DX, 0
    DIV BX

    CMP AX, 0            ;没数了
    JZ PRINT_EXIT
    CALL PRINT           ;递归

PRINT_EXIT:    
    ADD DX,  30H         ;打印
    PUSH AX
    MOV AH, 2
    INT 21H
    POP AX

    POP DX
    POP BX
    POP AX
    RET
PRINT ENDP
;----------PRINT END------------------
    
;--------PRINT_CRLF START-------------
PRINT_CRLF PROC               ;打印数
    PUSH AX
    PUSH DX
    
    MOV DX, OFFSET CRLF ;回车
    MOV AH, 09
    INT 21H
    
    POP DX
    POP AX
    RET
PRINT_CRLF ENDP
;--------PRINT_CRLF END---------------
    
;--------PRINT_SPACE START-------------
PRINT_SPACE PROC               ;打印空格
    PUSH AX
    PUSH DX
    
    MOV DL, ' '
    MOV AH, 2
    INT 21H
    
    POP DX
    POP AX
    RET
PRINT_SPACE ENDP
;--------PRINT_SPACE END---------------
    
EXIT:    
    MOV AH,4CH
    INT 21H
CODES ENDS
    END START



