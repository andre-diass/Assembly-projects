;
; Curso de Assembly para Microcontroladores PIC
;
; MCU: PIC 16F628A, Clock: 4MHz
;
; Autor: André Dias 
;
; UPE-Poli
;
; Data: 30.08.2022
;
;
; *********************************************************
; *							  *
; *		Exemplo de Programa básico Assembly	  *
; *		 FREQUENCIA CONDICIONAL A RB0	          *
; *							  *
; *********************************************************
;
;
; --- Funcionamento do Programa ---
;
;O programa que implementa uma frequencia condicional no pino RB3 de acordo com condição de RB0, isso poderá ser observado através do led
;ligado ao pino RB3, este led deve permanecer 50 microsegundos aceso quando RB0 = 0 e RB0 = 1 permanecer 10 microsegundos aceso.

; --- Arquivo de listagem de saída pós compilação: ---

 	list p=16F628A			; Diretiva para o arquivo de listagem na compilação
 	
 	

; --- Arquivo de referência da arquitetura do Microcontrolador (End. dos Reg's)

; Path do arquivo: c:\Programa Files (x86)\Microchip\MPASM Suite\

	#include <p16f628a.inc>	; Arquivo descritivo da arquitetura do Microcontrolador 
	

; --- Configuração dos Fuse Bits ---

; Oscilador externo (4MHz)
; Watchdog Timer desligado
; Power-up Timer ligado (~70ms retardo)
; Code protection Off
; Brown Out desabilitado
; Sem programação em baixa tensão, sem proteção de código, sem proteção da memória EEPROM



__config _XT_OSC & _WDT_OFF & _PWRTE_ON & _BOREN_OFF & _LVP_OFF & _CP_OFF & _CPD_OFF & _MCLRE_ON


; Operandos do Set de Instruções - Microcntroladores PIC

; W: work (registrador de trabalho ou acumulador)
; F: file (registradores especiais e/ou de uso geral | posição de memória)
; L: literal (constante, número qualquer) Utilizado como L nas instruções e
; k nos argumentos
; D: destination (local onde o resultado de uma operação será armazenado).
; B: bit (bits dentro dos registradores, dentro de um byte, flags)
; T: test (utilizado para teste de bits)
; S: skip (pulo, salto, desvio condicional)
; S: set (setar, tornar nível alto)
; C: clear (limpar, tornar nível baixo)
; Z: zero (testar se é equivalente a zero)


; --- Paginação de memória: Seleção dos bancos de memória do Microcontrolador ---
;
; O PIC16F628A apresenta 4 bancos de registradores: Bank0, Bank1, Bank2 e Bank3

; Criando mnemônicos para seleção dos bancos de reg's:

	#define Bank0 call sel_Bank0
	#define Bank1 call sel_Bank1
	#define Bank2 call sel_Bank2
	#define Bank3 call sel_Bank3
	
; Obs.: Para o PIC16F84A so existem 2 bancos. Usa-se as diretivas a seguir:

;	#define Bank0 bcf status, RP0
;	#define Bank1 bsf status, RP0

; --- Definição de variáveis de memória ou Reg's de Uso Geral ---

	cblock	0x20	    	        ; Diretiva do MPASM para definição sequencial de endereços de registradores
	
	W_TEMP				; Reg. Temporário para armazenar W  
	STATUS_TEMP			; Reg. Temporário para armazenar STATUS
		
	endc 

;W_TEMP equ 0x20

; --- Notação de representação de valores numéricos ---

; Exemplos:

; Binário: 		0B01010101 ou B'01010101'
; Octal:		O'55'
; Decimal:		0D55 ou D'55'
; Hexadecimal:	        0x55 ou H'55'
; Ascii:		A'Texto'


; ENTRADAS

; ENTRADAS

	#define botao_0 PORTB, RB0 ; botão 0 ligado a RB0

; SAÍDAS

	#define led_3 PORTB, RB3 ; led ligado a RB3


; VARIÁVEIS USADAS NO PROGRAMA

#define reg_1 0x21 ; variável da posição de memória 1

; --- Vetor de Reset ---	


				org	0x0000			; Diretiva de origem do reset do Microcontrolador
				goto	inicio			; Bypass do vetor de interrupção
				
				
; --- Vetor de Interrupção ---			

				org	0x0004			; Diretiva de origem do vetor de interrupção
								; Todas as fontes de interrupção apontam para este endereço
								; na arquitetura PIC
										
				goto	int_tread		; Desvia para identificar e tratar a interrupção
				
				
; --- Programa Principal ---

inicio:	
				
; --- desabilitar interrupções ---

				movlw	0x00
				movwf	INTCON			; desabilitar interrupções EEPROM, RB, T0, INT(RB0) 
								; Detalhe: INTCON está presente em todos os bancos
				
				Bank0				; Retorno ao banco 0


;  SAÍDA 

                                Bank1                           ; seleciona o banco 1 do TRISB
                                movlw B’11110111’               ; coloca RB3 como saída
                                movwf TRISB 
                                movlw B’11111111’               ; apagar LED
                                movwf PORTB                     ; LED APAGADO
                                Bank0 ; retorna ao banco 0 

;LOOP

           loop:
                               call botao_0                    ; chama o botao 0
                               goto loop                       ; retorna ao loop

           Botao_0:
                               btfsc botao_0                   ; testa botão 0
                               goto Acende_50                  ; BRO = 1, acende o led 10 mircrosegundos
                               goto Acende_10                  ; BRO = 0, acender o led 50 mircrosegundos

           Acende_10:                                          ;função para acender o led 

                               bsf PORTB, RB3                   ; LED = 1, liga led
                               call Delay_temp1                 ; chama função que conta 50 microssegundos
                               bcf PORTB, RB3                   ; LED = 0, desliga led
                               return
;LOOP PARA CONTAR TEMPO

           Delay_temp1:
                               movlw D’100‘                     ; move literal 100 para o w
                               movwf reg_0                      ; move w para o registrador reg_0
           
           CONTAGEM:
                               nop
                               nop
                               nop
                               nop                             ; cada NOP gasta 1microsseg.
                               nop
                               nop
                               nop
                               decfsc reg_0                    ; decrementa registrador 0, gasta 2microseg.
                               goto CONTAGEM                   ; retornar para CONTAGEM, gasta 1microseg.
                               return

 	   Acende_50:                                          ;função para acender o led 

                               bsf PORTB, RB3                   ; LED = 1, liga led
                               call Delay_temp2                 ; chama função que conta 10 microssegundos
                               bcf PORTB, RB3                   ; LED = 0, desliga led
                               return
;LOOP PARA CONTAR TEMPO

           Delay_temp2:
                               movlw D’250‘                     ; move literal 250 para o w
                               movwf reg_0                      ; move w para o registrador reg_0

           CONTAGEM:
                               nop
                               nop
                               nop
                               nop                             ; cada NOP gasta 1microsseg.
                               nop
                               nop
                               nop
                               decfsc reg_1                    ; decrementa registrador 0, gasta 2microseg.
                               goto CONTAGEM                   ; retornar para CONTAGEM, gasta 1microseg.
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
