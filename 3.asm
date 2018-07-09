DATAS SEGMENT
    ;此处输入数据段代码  
    NUM1 DW 1 DUP(0)
    NUM2 DW 1 DUP(0)
    BUF DB 8                    ;字符串输入缓冲区
        DB 0
        DB 8 DUP(0)
    CRLF DB 0AH, 0DH, '$'       ;回车换行
    MSG  DB 'Input a number: $' ;输入提示
    TOO_LARGE DB 'Too large, input again: $'  ;重新输入提示
    NUM1_INPUT DB 'Input NUM1: ', 0AH, 0DH, '$'  ;NUM1提示
    NUM2_INPUT DB 'Input NUM2: ', 0AH, 0DH, '$'  ;NUM2提示
    NUM1_CONFIRM DB 'NUM1 is: $'  ;NUM1确认
    NUM2_CONFIRM DB 'NUM2 is: $'  ;NUM2确认
    CD_RESULT    DB 'Common Divisor Result: $'     ;公约数结果
    SQ_RESULT    DB 'Squared Difference Result: $' ;平方差结果
    SQ_NUM1_SUM    DB 'NUM1/SUM = : $' ;NUM1/SUM结果
    SQ_NUM2_SUM    DB 'NUM2/SUM = : $' ;NUM2/SUM结果    
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
    
    MOV DX, OFFSET NUM1_INPUT
    MOV AH, 9
    INT 21H
    CALL INPUT_NUM
    MOV NUM1, AX
    
    MOV DX, OFFSET NUM2_INPUT
    MOV AH, 9
    INT 21H
    CALL INPUT_NUM
    MOV NUM2, AX
    
    MOV DX, OFFSET NUM1_CONFIRM  ;确认NUM1
    MOV AH, 9
    INT 21H
    MOV AX, NUM1
    CALL PRINT
    CALL PRINT_CRLF
    
    MOV DX, OFFSET NUM2_CONFIRM  ;确认NUM2
    MOV AH, 9
    INT 21H
    MOV AX, NUM2
    CALL PRINT
    CALL PRINT_CRLF
    CALL PRINT_CRLF
    
    MOV DX, OFFSET CD_RESULT    ;公约数结果
    MOV AH, 9
    INT 21H
    CALL CAL_CD                 ;计算公约数
    CALL PRINT_CRLF
    
    MOV DX, OFFSET SQ_RESULT    ;平方差结果
    MOV AH, 9
    INT 21H
    CALL CAL_SQUARE              ;计算平方差
    CALL PRINT_CRLF
    
    MOV DX, OFFSET SQ_NUM1_SUM    ;NUM1/SUM结果
    MOV AH, 9
    INT 21H
    MOV AX, NUM1
    MOV BX, NUM2
    ADD BX, AX
    CALL CAL_PART                 ;计算NUM1/NUM2
    CALL PRINT_CRLF
    
    MOV DX, OFFSET SQ_NUM2_SUM    ;NUM2/SUM结果
    MOV AH, 9
    INT 21H
    MOV AX, NUM2
    MOV BX, NUM1
    ADD BX, AX
    CALL CAL_PART                 ;计算NUM2/NUM1
    
    JMP EXIT
    
;------------CAL_PART START----------------
CAL_PART PROC
    MOV DX, 0
    MOV CX, 10000           ;乘10000
    MUL CX
    DIV BX                  ;除以总和，AX为结果
    
    PUSH AX                 ;整数部分
    MOV DX, 0               ;AX十进制前两位为整数部分
    MOV CX, 100             ;将AX除以100取前两位
    DIV CX                  ;
    MOV AH, 0
    CALL PRINT              
    POP AX
    
    PUSH AX                 ;输出小数点
    PUSH DX
    MOV DL, '.'
    MOV AH, 2
    INT 21H
    POP DX
    POP AX
    
    MOV AX, DX               ;小数部分
    CALL PRINT
    CMP DX, 9
    JG PERCENT
    MOV DL, '0'              ;补0
    MOV AH, 2
    INT 21H
    
PERCENT:
    MOV DL, '%'
    MOV AH, 2
    INT 21H
    
    RET
CAL_PART ENDP
;------------CAL_PART START---------------- 
  
;------------CAL_SQUARE START----------------
CAL_SQUARE PROC
    MOV AX, NUM2
    MUL AX
    MOV BX, AX
    MOV AX, NUM1
    MUL AX
    CMP AX, BX
    JL LESS
    SUB AX, BX
    CALL PRINT
    JMP EXIT_SQ
    
LESS:
    PUSH AX                 ;小于0，输出负号
    MOV DL, '-'
    MOV AH, 2
    INT 21H
    POP AX
    SUB BX, AX
    MOV AX, BX
    CALL PRINT
EXIT_SQ:
    RET
CAL_SQUARE ENDP
;------------CAL_SQUARE END----------------
    
;------------CAL_CD START----------------
CAL_CD PROC
    MOV AX, NUM1
    MOV BX, NUM2
    CMP AX, BX             ;最小值存在CH
    JL AX_MIN
    MOV CH, BL
    JMP CONTINUE
AX_MIN:
    MOV CH, AL
CONTINUE: 
    MOV CL, 0
LOOP_C:
    INC CL
    CMP CL, CH             ;超出范围跳出
    JG EXIT_P
    MOV AX, NUM1
    ;MOV BX, 0
    MOV BL, CL
    DIV BL
    CMP AH, 0              ;NUM1是否能被CL整除
    JNZ LOOP_C
    MOV AX, NUM2
    DIV BL
    CMP AH, 0              ;NUM2是否能被CL整除
    JNZ LOOP_C
    MOV AX, 0              ;CL是公约数，打印
    MOV AL, CL
    CALL PRINT
    CALL PRINT_SPACE
    JMP LOOP_C
     
EXIT_P:
    RET
CAL_CD ENDP
;------------CAL_CD END----------------
    
;------------INPUT_NUM START----------------
INPUT_NUM PROC
RE_ENTER:
    MOV DX, OFFSET BUF  ;以字符串读入
    MOV AH, 0AH
    INT 21H
    
    MOV DX, OFFSET CRLF ;回车
    MOV AH, 09
    INT 21H

    CALL CONVERT_NUM      ;转换成数字
    CMP AX, 100
    JL CONTINUE
    MOV DX, OFFSET TOO_LARGE  ;提示太大
    MOV AH, 9
    INT 21H
    JMP RE_ENTER              ;跳转到重新输入
CONTINUE:    
    RET
INPUT_NUM ENDP
;------------INPUT_NUM END----------------
    
;------------CONVERT_NUM START----------------
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
	
	;MOV INT1, AX
	RET
CONVERT_NUM ENDP
;------------CONVERT_NUM END----------------
    
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


