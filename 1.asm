DATAS SEGMENT
    ;�˴��������ݶδ���  
    INT1 DW 1 DUP(0)
    BUF DB 8                    ;�ַ������뻺����
        DB 0
        DB 8 DUP(0)
    BIT DW 1 DUP(0)             ;λ��    
    CRLF DB 0AH, 0DH, '$'       ;�س�����
    MSG  DB 'Input a number: $' ;������ʾ
    YES  DB ' is a prime number$'
    NO   DB ' is not a prime number$'
    TOO_LARGE DB 'Too large, input again: $'  ;����������ʾ
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
    
RE_ENTER:
    MOV DX, OFFSET BUF  ;���ַ�������
    MOV AH, 0AH
    INT 21H
    
    MOV DX, OFFSET CRLF ;�س�
    MOV AH, 09
    INT 21H

    CALL CONVERT_NUM      ;ת��������
    CMP AX, 1000
    JL CONTINUE
    MOV DX, OFFSET TOO_LARGE  ;��ʾ̫��
    MOV AH, 9
    INT 21H
    JMP RE_ENTER              ;��ת����������
    
CONTINUE:
    MOV AH, 0           ;��ӡ��ǰ����
    MOV AL, BUF[1]
    MOV SI, AX
    MOV BUF[2][SI], '$'
    MOV DX, OFFSET BUF[2]
    MOV AH, 9
    INT 21H
    
    JMP JUDGE
    
    
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
	
	MOV INT1, AX
	RET
CONVERT_NUM ENDP

JUDGE:                  ;�ж�����
    MOV BX, INT1
    SHR BX, 1           ;�жϷ�ΧΪ2 - int1/2
    
    MOV AX, INT1
    CMP AX, 0           ;0��1��������
    JZ NOT_PRIME
    CMP AX, 1
    JZ NOT_PRIME
    
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
    MOV AH, 4CH   ;����
    INT 21H
CODES ENDS
    END START



