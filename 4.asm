DATAS SEGMENT
    ;�˴��������ݶδ���  
    BUF DB 20                    ;�ַ������뻺����
        DB 0
        DB 20 DUP(0)
    CRLF DB 0AH, 0DH, '$'       ;�س�����
    MSG  DB 'Input a string: $' ;������ʾ
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
    
    MOV DX, OFFSET MSG  ;��ʾ��Ϣ
    MOV AH, 9
    INT 21H
    CALL PRINT_CRLF
    
    MOV DX, OFFSET BUF  ;���ַ�������
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
    CMP SI, CX                  ;SI��Χ0-len-1
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
    
    MOV AH, 0           ;��ӡBUF�ַ���
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
    
EXIT:
    MOV AH,4CH
    INT 21H
CODES ENDS
    END START



