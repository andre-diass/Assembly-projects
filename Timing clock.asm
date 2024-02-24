;Curso de Assembly para Microcontroladores PIC - Lista 01
;
; MCU: PIC 16F628A, Clock: 4MHz
;
; Autor: André Dias Santos Filho
;
; Código de temporização de 10ms com timer0
;
; UPE-Poli
;
; Data: 30.08.2022
;
;
; ********************************************************* 
; *							  			                                             
; *		Exemplo de Programa básico Assembly	  		               
; *			FREQUENCIA 10KHz	          			                        
; *							  			                                             
; * 										                                              
; *										                                               
; ********************************************************* 

; --- ARQUIVO DE LINGUAGEM DE SAÍDA PÓS COMPILAÇÃO ---

list p=16F628A ; DIRETIVA PARA O ARQUIVO DELISTAGEM NA COMPILAÇÃO

; --- ARQUIVO DE ARQUITETURA DO MICROCONTROLADOR ---

; PATH DOS ARQUIVOS

#include &lt;p16f628a. inc&gt; ; arquivo descritivo da arquitetura do microcontrolador

; --- CONFIGURÇÃO DOS FUSE BITS ---

; Oscilador externo (4MHz)
; Watch dog timer desligado
; Power-up timer ligado
; Brown out reset desligado
; sem programação em baixa tensão
; sem proteção de código
; sem proteção de memória EEPROM
; Reset externo no pino RA5

__config _XT_OSC &amp; _WDT_OFF &amp; _PWRTE_ON &amp; _BOREN_OFF &amp; _LVP_OFF &amp; _CP_OFF &amp;
_CPD_OFF &amp; _MCLRE_ON ;
; seleção dos bancos de memória do microcontrolador 16F628A

; o microcontrolador apresenta 4 bancos de registradores BANK0, BANK1, BANK2, BANK3
#define Bank 0 call sel_Bank0
#define Bank 1 call sel_Bank1
#define Bank 2 call sel_Bank2
#define Bank 3 call sel_Bank3
; definição de variáveis de memória 
cblock  0x20              ;  diretiva para definição sequencial para endereços de memória
contador                    ; registrador de contagem de repetições
endc




; ENTRADAS
#define     BOTAO_0  PORTB, RB0                ; botao 0 ligado a RB0
#define     BOTAO_2  PORTB, RB2                ; botao 2 ligado a RB2
#define     BOTAO_4  PORTB, RB0                ; botao 4 ligado a RB4
; SAÍDAS
#define     Led_1  PORTB, RB1                ;  Led 1 ligado a RB1
#define     Led_3PORTB, RB3                ;  Led 3 ligado a RB3
#define     Led_5  PORTB, RB5                ; Led 54 ligado a RB5

;  Área de Equates
timer0_req   equ T0IF
INT_req         equ INTF
RB_req      equ RBIF

; ---VETOR DE RESET ---

org 0x0000 ; diretiva de origem de reset do microcontrolador
goto inicio ; Bypass do vetor de interrupção

; ---VETOR DE INTERUPÇÃO---

org 0x0004 ; diretiva de origem do vetor interrupção
; todas as fontes de interrupção apontam para este endereço

goto int_tread ; identifica e trata e interrupção

; PROGRAMA PRINCIPAL
inicio:
; Configuração dos Ports


Bank0
movlw 0x07
movwf  CMCON

Bank 1
movlw   B’11111101’ 
movwf   TRISB   

Bank 2
movlw   B’11111111’ 
movwf   TRISA 
 
; HABILITAR INTERRUPÇÕES
movlw  B’00111000’
movwf INTCON

movlw  0x00
movwf  PIE1

; CONFIGURAÇÃO DO TIMER 0
movlw  B’10000101’
movwf  OPTION_REG

; LOOP INFINITO DO PROGRAMA PRINCIPAL
call   contador_2
bsf  Led_1
  
loop:
timer0_5ms
espera:
btfsc   INTCON, T0IF
goto  dec_contador
goto  espera 

dec_contador :
decfsz  contador
goto loop

inverte_led_1:
bcf   INTCON, T0IF
btfsc  Led_1
goto   apaga_led
bsf    Led_1
call  contador_02
goto  loop

apaga_led:
bcf    Led_1
call   contador_02
goto  loop
; TRATAMENTO DAS INTERRUPÇÕES
nop ;
nop ; não faz nada
retfile ; retorna para o programa principal

; CARGA DO TIMER
timer0_5ms:
movlw  D’178’
movwf TMR0
return


; CARGA PARA O LAÇO DE 10ms
movlw  D’2
movwf  contador
return

; SELEÇÃO DOS BANCOS DE REGISTRADORES
sel_Bank0:
bcf STATUS, RP0
bcf STATUS, RP1
return
sel_Bank1:
bsf STATUS, RP0
bcf STATUS, RP1
return
sel_Bank2:
bcf STATUS, RP0
bsf STATUS, RP1
return
sel_Bank3:
bsf STATUS, RP0
bsf STATUS, RP1
return

end
