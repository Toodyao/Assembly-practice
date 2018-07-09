DATAS SEGMENT
    ;此处输入数据段代码 
    BUF DB 30                    ;字符串输入缓冲区
        DB 0
        DB 30 DUP(0)
    CHAR_BUF DB 2                    ;字符输入缓冲区
        DB 0
        DB 2 DUP(0)
    CHAR  DB 1 DUP(0)
    RESULT DB 30 DUP(0)         ;保存删除后结果
    CRLF DB 0AH, 0DH, '$'       ;回车换行
    STRING_MSG DB 'Input a string: ', 0AH, 0DH, '$' ;输入提示 
    CHAR_MSG   DB 'Input a char: ', 0AH, 0DH, '$'
    RESULT_MSG DB 'Result: ', 0AH, 0DH, '$'
    TOO_SHORT DB 'Less than 15, input again: ', 0AH, 0DH, '$'  ;重新输入提示
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
    
    MOV DX, OFFSET STRING_MSG
    MOV AH, 9
    INT 21H
    CALL INPUT
    
    MOV DX, OFFSET CHAR_MSG
    MOV AH, 9
    INT 21H
    CALL INPUT_CHAR
    
    MOV DX, OFFSET RESULT_MSG
    MOV AH, 9
    INT 21H
    CALL CONVERT
    MOV DX, OFFSET RESULT
    MOV AH, 9
    INT 21H
    
    JMP EXIT_MAIN
    
;------------CONVERT START----------------
CONVERT PROC
    MOV SI, 0FFFFH
    MOV DI, 0
    
CONTINUE_C:
    INC SI
    MOV AX, 0
    MOV AL, BUF[1]                 ;是否遍历完
    CMP SI, AX
    JZ EXIT_C
    MOV AL, BUF[2][SI]
    CMP AL, CHAR                   ;相同则跳过
    JZ CONTINUE_C
    MOV RESULT[DI], AL             ;不相同移动到result
    INC DI
    JMP CONTINUE_C
    
EXIT_C:
    ;INC DI
    MOV RESULT[DI], '$'
    RET
CONVERT ENDP
;------------CONVERT START----------------    
        
;------------INPUT_CHAR START----------------
INPUT_CHAR PROC
    MOV DX, OFFSET CHAR_BUF  ;以字符串读入，只读一个字符
    MOV AH, 0AH
    INT 21H
    
    MOV AL, CHAR_BUF[2][0]
    MOV CHAR, AL
    CALL PRINT_CRLF
    RET
INPUT_CHAR ENDP
;------------INPUT_CHAR END----------------
        
;------------INPUT START----------------
INPUT PROC
RE_ENTER:
    MOV DX, OFFSET BUF  ;以字符串读入
    MOV AH, 0AH
    INT 21H
    
    CALL PRINT_CRLF

    CMP BUF[1], 15
    JGE CONTINUE_IP
    MOV DX, OFFSET TOO_SHORT  ;小于15太短
    MOV AH, 9
    INT 21H
    JMP RE_ENTER              ;跳转到重新输入
CONTINUE_IP:    
    RET
INPUT ENDP
;------------INPUT END----------------
    
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
PRINT_CRLF PROC               ;
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
    
    
EXIT_MAIN:    
    MOV AH,4CH
    INT 21H
CODES ENDS
    END START







