include 'emu8086.inc' ; This line includes the emu8086 library, providing additional functionalities and macros specific to the emu8086 emulator environment.

JMP START  ; Jump to the START label to begin program execution.

DATA SEGMENT
    TOTAL        DW 20              ; Declaration of a variable named TOTAL with a word size (DW) of 20.
    IDS1         DW 0000H,0001H,... ; Array declaration for IDS1 containing hexadecimal values.
    IDS2         DW 000AH,000BH,... ; Array declaration for IDS2 containing hexadecimal values.
    PASSWORDS1   DB   00H,  01H,... ; Array declaration for PASSWORDS1 containing hexadecimal values.
    PASSWORDS2   DB   0AH,  0BH,... ; Array declaration for PASSWORDS2 containing hexadecimal values.
    DATA1        DB '******WELCOME*******',0  ; String declaration for DATA1 with termination character.
    DATA2        DB 0DH,0AH,'ENTER YOUR ID: ',0 ; String declaration for DATA2 with termination character.
    DATA3        DB 0DH,0AH,'ENTER YOUR PASSWORD: ',0 ; String declaration for DATA3 with termination character.
    DATA4        DB 0DH,0AH,'DENIED 0  ',0   ; String declaration for DATA4 with termination character.
    DATA5        DB 0DH,0AH,'ALLOWED 1 ',0   ; String declaration for DATA5 with termination character.
    DATA6        DB '******WELCOME BACK*******',0 ; String declaration for DATA6 with termination character.
    IDINPUT      DW 1 DUP (?)      ; Array declaration for IDINPUT with uninitialized values.
    PASSINPUT    DB 1 DUP (?)     ; Array declaration for PASSINPUT with uninitialized values.
DATA ENDS

;*****************

CODE SEGMENT

START:
    MOV  AX,DATA      ; Move the address of DATA segment to AX register.
    MOV  DS,AX        ; Load the value of AX register into DS register.

    DEFINE_SCAN_NUM           ; Macro definition for scanning numeric input.
    DEFINE_PRINT_STRING      ; Macro definition for printing strings.
    DEFINE_PRINT_NUM         ; Macro definition for printing numbers.
    DEFINE_PRINT_NUM_UNS     ; Macro definition for printing unsigned numbers.

AGAIN:
    LEA  SI,DATA1     ; Load effective address of DATA1 into SI register.
    CALL PRINT_STRING ; Call PRINT_STRING subroutine to print the string at SI.
    LEA  SI,DATA2     ; Load effective address of DATA2 into SI register.
    CALL PRINT_STRING ; Call PRINT_STRING subroutine to print the string at SI.
    MOV  SI,-1        ; Set SI register to -1.

    CALL SCAN_NUM     ; Call SCAN_NUM subroutine to scan numeric input.
    MOV  IDINPUT,CX   ; Move the input value to IDINPUT variable.
    MOV  AX,CX        ; Move the input value to AX register.
    MOV  CX,0         ; Initialize CX register to 0.
L1:
    INC  CX           ; Increment CX register.
    CMP  CX,TOTAL     ; Compare CX with TOTAL.
    JE   ERROR        ; If CX equals TOTAL, jump to ERROR.
    INC  SI           ; Increment SI register.
    MOV  DX,SI        ; Move the value of SI to DX register.
    CMP  IDS1[SI],AX ; Compare the value at IDS1[SI] with AX.
    JE   PASS1        ; If equal, jump to PASS1.
    CMP  IDS2[SI],AX ; Compare the value at IDS2[SI] with AX.
    JE   PASS2        ; If equal, jump to PASS2.
    JMP  L1           ; Otherwise, jump to L1.

PASS1:
    LEA  SI,DATA3     ; Load effective address of DATA3 into SI register.
    CALL PRINT_STRING ; Call PRINT_STRING subroutine to print the string at SI.
    CALL SCAN_NUM     ; Call SCAN_NUM subroutine to scan numeric input.
    MOV  PASSINPUT,CL ; Move the input value to PASSINPUT variable.
    MOV  AX,DX        ; Move the value of DX to AX register.
    MOV  DX,0002H     ; Move hexadecimal value 0002 to DX register.
    DIV  DL           ; Divide AX by DL.
    MOV  SI,AX        ; Move the quotient to SI register.
    MOV  AL,CL        ; Move the least significant byte of CL to AL.
    MOV  AH,00H       ; Move 00H to AH register.
    CMP  PASSWORDS1[SI],AL ; Compare the value at PASSWORDS1[SI] with AL.
    JNE  ERROR        ; If not equal, jump to ERROR.
    JMP  DONE         ; Otherwise, jump to DONE.

PASS2:
    LEA  SI,DATA3     ; Load effective address of DATA3 into SI register.
    CALL PRINT_STRING ; Call PRINT_STRING subroutine to print the string at SI.
    CALL SCAN_NUM     ; Call SCAN_NUM subroutine to scan numeric input.
    MOV  PASSINPUT,CL ; Move the input value to PASSINPUT variable.
    MOV  AX,DX        ; Move the value of DX to AX register.
    MOV  DX,0002H     ; Move hexadecimal value 0002 to DX register.
    DIV  DL           ; Divide AX by DL.
    MOV  SI,AX        ; Move the quotient to SI register.
    MOV  AL,CL        ; Move the least significant byte of CL to AL.
    MOV  AH,00H       ; Move 00H to AH register.
    CMP  PASSWORDS2[SI],AL ; Compare the value at PASSWORDS2[SI] with AL.
    JNE  ERROR        ; If not equal, jump to ERROR.
    JMP  DONE         ; Otherwise, jump to DONE.

ERROR:
    LEA  SI,DATA4     ; Load effective address of DATA4 into SI register.
    CALL PRINT_STRING ; Call PRINT_STRING subroutine to print the string at SI.
    PRINT 0AH         ; Print newline character.
    PRINT 0DH         ; Print carriage return character.
    MOV  SI,0         ; Move 0 to SI register.
    JMP  AGAIN        ; Jump to AGAIN to restart the process.

DONE:
    LEA  SI,DATA5     ; Load effective address of DATA5 into SI register.
    CALL PRINT_STRING ; Call PRINT_STRING subroutine to print the string at SI.
    PRINT 0AH         ; Print newline character.
    PRINT 0DH         ; Print carriage return character.
    LEA  SI,DATA6     ; Load effective address of DATA6 into SI register.
    CALL PRINT_STRING ; Call PRINT_STRING subroutine to print the string at SI.
    MOV  SI,0         ; Move 0 to SI register.

CODE ENDS

END START           ; End of the program with the START label as the entry point.

ret                 ; Return from the program.
