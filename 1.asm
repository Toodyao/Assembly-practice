DATAS SEGMENT
    ;此处输入数据段代码  
    INT1 DW 1 DUP(0)
    BUF DB 8                    ;字符串输入缓冲区
        DB 0
        DB 8 DUP(0)
    BIT DW 1 DUP(0)             ;位数    
    CRLF DB 0AH, 0DH, '$'       ;回车换行
    MSG  DB 'Input a number: $' ;输入提示
    YES  DB ' is a prime number$'
    NO   DB ' is not a prime number$'
    TOO_LARGE DB 'Too large, input again: $'  ;重新输入提示
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
    
    MOV DX, OFFSET MSG  ;提示信息
    MOV AH, 9
    INT 21H
    
RE_ENTER:
    MOV DX, OFFSET BUF  ;以字符串读入
    MOV AH, 0AH
    INT 21H
    
    MOV DX, OFFSET CRLF ;回车
    MOV AH, 09
    INT 21H

    CALL CONVERT_NUM      ;转换成数字
    CMP AX, 1000
    JL CONTINUE
    MOV DX, OFFSET TOO_LARGE  ;提示太大
    MOV AH, 9
    INT 21H
    JMP RE_ENTER              ;跳转到重新输入
    
CONTINUE:
    MOV AH, 0           ;打印当前数字
    MOV AL, BUF[1]
    MOV SI, AX
    MOV BUF[2][SI], '$'
    MOV DX, OFFSET BUF[2]
    MOV AH, 9
    INT 21H
    
    JMP JUDGE
    
    
CONVERT_NUM PROC          ;转换数字子程序
    MOV CH, 0
    MOV CL, BUF[1]
    MOV SI, CX
    MOV AX, 0
    MOV DI, 0
    
READ_LOOP:
    MOV BX, 10
    MUL BX                ;乘10
    MOV BL, BUF[2][DI]
    INC DI
    SUB BL, 30H
    ADD AX, BX
    DEC SI
    CMP SI, 0
    JNZ READ_LOOP
	
	MOV INT1, AX
	RET
CONVERT_NUM ENDP

JUDGE:                  ;判断素数
    MOV BX, INT1
    SHR BX, 1           ;判断范围为2 - int1/2
    
    MOV AX, INT1
    CMP AX, 0           ;0和1不是素数
    JZ NOT_PRIME
    CMP AX, 1
    JZ NOT_PRIME
    
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
    MOV DX, OFFSET YES
    MOV AH, 9
    INT 21H
    JMP EXIT
    
NOT_PRIME:
    MOV DX, OFFSET NO
    MOV AH, 9
    INT 21H
    JMP EXIT
    
    
EXIT:
    MOV AH, 4CH   ;结束
    INT 21H
CODES ENDS
    END START



