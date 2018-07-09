DATAS SEGMENT
    ;此处输入数据段代码  
    BUF DB 20                    ;字符串输入缓冲区
        DB 0
        DB 20 DUP(0)
    CRLF DB 0AH, 0DH, '$'       ;回车换行
    MSG  DB 'Input a string: $' ;输入提示
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
    CALL PRINT_CRLF
    
    MOV DX, OFFSET BUF  ;以字符串读入
    MOV AH, 0AH
    INT 21H
    
    
    CALL CONVERT
    CALL PRINT_CRLF
    CALL PRINT_BUF
    
    
    JMP EXIT
    
    
;------------CONVERT START----------------
CONVERT PROC
    MOV CX, 0
    MOV CL, BUF[1]
    DEC CX
    MOV SI, 0FFFFH
    
CONTINUE:
    INC SI
    CMP SI, CX                  ;SI范围0-len-1
    JG EXIT_P
    
    MOV AX, 0
    MOV AL, BUF[2][SI]
    CMP AX, 'A'
    JL CONTINUE
    CMP AX, 'Z'
    JL UPPER
    CMP AX, 'a'
    JL CONTINUE
    CMP AX, 'z'
    JG CONTINUE
    JMP LOWER
UPPER:
    CALL UPPER_CONVERT
    MOV BUF[2][SI], AL
    JMP CONTINUE
LOWER:
    CALL LOWER_CONVERT
    MOV BUF[2][SI], AL
    JMP CONTINUE
    
EXIT_P:
    RET
CONVERT ENDP
;------------CONVERT END----------------
    
;------------UPPER_CONVERT START----------------
UPPER_CONVERT PROC
    ADD AX, 4
    CMP AX, 'Z'
    JLE EXIT
    SUB AX, 26
EXIT:
    RET
UPPER_CONVERT ENDP
;------------UPPER_CONVERT END----------------

;------------LOWER_CONVERT START----------------
LOWER_CONVERT PROC
    ADD AX, 4
    CMP AX, 'z'
    JLE EXIT
    SUB AX, 26
EXIT:
    RET
LOWER_CONVERT ENDP
;------------LOWER_CONVERT END----------------    

;------------PRINT_BUF START----------------    
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
;------------PRINT_BUF END----------------    

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
    
EXIT:
    MOV AH,4CH
    INT 21H
CODES ENDS
    END START



