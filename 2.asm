DATAS SEGMENT
    ;�˴��������ݶδ���  
    INT1 DW 1 DUP(0)
    CRLF DB 0AH, 0DH, '$'       ;�س�����
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
    
    MOV AX, 10
LOOP_JUDGE:
    CMP AX, 200
    JG EXIT
    
    MOV DX, 0           ;DL�淵��ֵ
    PUSH AX             ;�ж�AX�Ƿ�������
    CALL JUDGE
    MOV DH, DL          ;DH���AX�Ƿ�������
    
	ADD AX, 2           ;�ж�AX+2�Ƿ�������
	CALL JUDGE
	POP AX
	
	CMP DX, 0101H       ;��������
	JNZ SKIP
	
	PUSH AX             ;��ӡ��������
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
JUDGE PROC              ;�ж�����
    PUSH AX
    PUSH DX
    MOV INT1, AX
    MOV BX, INT1
    SHR BX, 1           ;�жϷ�ΧΪ2 - int1/2
    
    MOV AX, INT1
    MOV CX, 2
PRIME_LOOP:
    CMP CX, BX          ;�Ƿ���int1/2
    JG PRIME            ;ѭ��������������
    
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



