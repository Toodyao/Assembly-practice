DATAS SEGMENT
    ;�˴��������ݶδ���  
    NUM1 DW 1 DUP(0)
    NUM2 DW 1 DUP(0)
    BUF DB 8                    ;�ַ������뻺����
        DB 0
        DB 8 DUP(0)
    CRLF DB 0AH, 0DH, '$'       ;�س�����
    MSG  DB 'Input a number: $' ;������ʾ
    TOO_LARGE DB 'Too large, input again: $'  ;����������ʾ
    NUM1_INPUT DB 'Input NUM1: ', 0AH, 0DH, '$'  ;NUM1��ʾ
    NUM2_INPUT DB 'Input NUM2: ', 0AH, 0DH, '$'  ;NUM2��ʾ
    NUM1_CONFIRM DB 'NUM1 is: $'  ;NUM1ȷ��
    NUM2_CONFIRM DB 'NUM2 is: $'  ;NUM2ȷ��
    CD_RESULT    DB 'Common Divisor Result: $'     ;��Լ�����
    SQ_RESULT    DB 'Squared Difference Result: $' ;ƽ������
    SQ_NUM1_SUM    DB 'NUM1/SUM = : $' ;NUM1/SUM���
    SQ_NUM2_SUM    DB 'NUM2/SUM = : $' ;NUM2/SUM���    
DATAS ENDS

STACKS SEGMENT
    ;�˴������ջ�δ���
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX
    ;�˴��������δ���
    
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
    
    MOV DX, OFFSET NUM1_CONFIRM  ;ȷ��NUM1
    MOV AH, 9
    INT 21H
    MOV AX, NUM1
    CALL PRINT
    CALL PRINT_CRLF
    
    MOV DX, OFFSET NUM2_CONFIRM  ;ȷ��NUM2
    MOV AH, 9
    INT 21H
    MOV AX, NUM2
    CALL PRINT
    CALL PRINT_CRLF
    CALL PRINT_CRLF
    
    MOV DX, OFFSET CD_RESULT    ;��Լ�����
    MOV AH, 9
    INT 21H
    CALL CAL_CD                 ;���㹫Լ��
    CALL PRINT_CRLF
    
    MOV DX, OFFSET SQ_RESULT    ;ƽ������
    MOV AH, 9
    INT 21H
    CALL CAL_SQUARE              ;����ƽ����
    CALL PRINT_CRLF
    
    MOV DX, OFFSET SQ_NUM1_SUM    ;NUM1/SUM���
    MOV AH, 9
    INT 21H
    MOV AX, NUM1
    MOV BX, NUM2
    ADD BX, AX
    CALL CAL_PART                 ;����NUM1/NUM2
    CALL PRINT_CRLF
    
    MOV DX, OFFSET SQ_NUM2_SUM    ;NUM2/SUM���
    MOV AH, 9
    INT 21H
    MOV AX, NUM2
    MOV BX, NUM1
    ADD BX, AX
    CALL CAL_PART                 ;����NUM2/NUM1
    
    JMP EXIT
    
;------------CAL_PART START----------------
CAL_PART PROC
    MOV DX, 0
    MOV CX, 10000           ;��10000
    MUL CX
    DIV BX                  ;�����ܺͣ�AXΪ���
    
    PUSH AX                 ;��������
    MOV DX, 0               ;AXʮ����ǰ��λΪ��������
    MOV CX, 100             ;��AX����100ȡǰ��λ
    DIV CX                  ;
    MOV AH, 0
    CALL PRINT              
    POP AX
    
    PUSH AX                 ;���С����
    PUSH DX
    MOV DL, '.'
    MOV AH, 2
    INT 21H
    POP DX
    POP AX
    
    MOV AX, DX               ;С������
    CALL PRINT
    CMP DX, 9
    JG PERCENT
    MOV DL, '0'              ;��0
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
    PUSH AX                 ;С��0���������
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
    CMP AX, BX             ;��Сֵ����CH
    JL AX_MIN
    MOV CH, BL
    JMP CONTINUE
AX_MIN:
    MOV CH, AL
CONTINUE: 
    MOV CL, 0
LOOP_C:
    INC CL
    CMP CL, CH             ;������Χ����
    JG EXIT_P
    MOV AX, NUM1
    ;MOV BX, 0
    MOV BL, CL
    DIV BL
    CMP AH, 0              ;NUM1�Ƿ��ܱ�CL����
    JNZ LOOP_C
    MOV AX, NUM2
    DIV BL
    CMP AH, 0              ;NUM2�Ƿ��ܱ�CL����
    JNZ LOOP_C
    MOV AX, 0              ;CL�ǹ�Լ������ӡ
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
    MOV DX, OFFSET BUF  ;���ַ�������
    MOV AH, 0AH
    INT 21H
    
    MOV DX, OFFSET CRLF ;�س�
    MOV AH, 09
    INT 21H

    CALL CONVERT_NUM      ;ת��������
    CMP AX, 100
    JL CONTINUE
    MOV DX, OFFSET TOO_LARGE  ;��ʾ̫��
    MOV AH, 9
    INT 21H
    JMP RE_ENTER              ;��ת����������
CONTINUE:    
    RET
INPUT_NUM ENDP
;------------INPUT_NUM END----------------
    
;------------CONVERT_NUM START----------------
CONVERT_NUM PROC          ;ת�������ӳ���
    MOV CH, 0
    MOV CL, BUF[1]
    MOV SI, CX
    MOV AX, 0
    MOV DI, 0
    
READ_LOOP:
    MOV BX, 10
    MUL BX                ;��10
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
PRINT PROC               ;�ݹ��ӡ��
    PUSH AX
    PUSH BX
    PUSH DX
    
    MOV BX, 10

    MOV DX, 0
    DIV BX

    CMP AX, 0            ;û����
    JZ PRINT_EXIT
    CALL PRINT           ;�ݹ�

PRINT_EXIT:    
    ADD DX,  30H         ;��ӡ
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
PRINT_CRLF PROC               ;��ӡ��
    PUSH AX
    PUSH DX
    
    MOV DX, OFFSET CRLF ;�س�
    MOV AH, 09
    INT 21H
    
    POP DX
    POP AX
    RET
PRINT_CRLF ENDP
;--------PRINT_CRLF END---------------
    
;--------PRINT_SPACE START-------------
PRINT_SPACE PROC               ;��ӡ�ո�
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


