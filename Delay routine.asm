; UPE - Escola Politécnica
;
; Disciplina: Microcontroladores e Microprocessadores
;
; Curso de Assembly para Microcontroladores PIC
;
; Autor: André Dias
;
; Data: 10.09.2022
;
; MCU: PIC 18F628A, Clock: 4MHz
;
;
;
; ***************************************************************
; * *
; * Exemplo de Programa básico Assembly *
; * Programa: Cálculo de Delay *
; * *
; * *
; ***************************************************************
; Uso do ciclo de máquina das instruções para cálculo de retardo de tempo (Delay)
;
; O programa temporiza dois leds a cada 500mS (0,5S) de forma alternada
;
;
; Leds acionados com estado "1" (Modo current sourcing)
; --- Arquivo de listagem de saída pós compilação: ---
list p=16F628A ; Diretiva para o arquivo de listagem na compilação
; --- Arquivo de referência da arquitetura do Microcontrolador (End. dos Reg's)
; Path do arquivo: c:\Programa Files (x86)\Microchip\MPASM Suite\
#include <p16f628a.inc> ; Arquivo descritivo da arquitetura do Microcontrolador
; --- Configuração dos Fuse Bits ---
; Oscilador externo (4MHz)
; Watchdog Timer desligado
; Power-up Timer ligado (~70ms retardo)
; Code protection Off

; Brown Out desabilitado
; Sem programação em baixa tensão, sem proteção de código, sem proteção da memória EEPROM

__config _XT_OSC & _WDT_OFF & _PWRTE_ON & _BOREN_OFF & _LVP_OFF & _CP_OFF & _CPD_OFF &
_MCLRE_ON
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
; #define Bank0 bcf status, RP0
; #define Bank1 bsf status, RP0
; --- Notação de representação de valores numéricos ---
; Exemplos:
; Binário: B'01010101'
; Octal: O'55'
; Decimal: 0D55 ou D'55'
; Hexadecimal: 0x55 ou H'55'
; Ascii: A'Texto'

; --- Entradas ---
#define botao_0 PORTB, RB0 ; Botão_0 ligado ao RB0 (Pino 6)
#define botao_2 PORTB, RB2 ; Botão_2 ligado ao RB2 (Pino 8)

; --- Saídas ---
#define led_1 PORTB, RB1 ; Led_1 ligado ao RB1 (Pino 7)
#define led_3 PORTB, RB3 ; Led_3 ligado ao RB3 (Pino 9)

; --- Variáveis usadas no programa ---
#define reg_1 0x21 ; Variável de posição de memória1
#define reg_0 0x20 ; Variável de posição de memória2
; --- Vetor de Reset ---

org 0x0000 ; Diretiva de origem do reset do

Microcontrolador

goto inicio ; Bypass do vetor de interrupção

; --- Vetor de Interrupção ---

org 0x0004 ; Diretiva de origem do vetor de

interrupção

; Todas as fontes de

interrupção apontam para este endereço

; na arquitetura PIC
goto int_tread ; Desvia para identificar e tratar a interrupção

; --- Programa Principal ---
; --- Inicialmente configura as entradas e saídas do MCU (setup) ---
inicio:

Bank1 ; Seleciona Banco do TRISB e

TRISA (Banco 1)

movlw 0xF5
movwf TRISB ; TRISB = 11110101: RB1 e RB3 como

saídas. RB0 e RB2 como entradas

movlw 0xFF
movwf TRISA ; Todos os bits não usados ficam como

entrada

movlw 0xF5 ; inicialmente apaga os leds
movwf PORTB
Bank0 ; Retorno ao banco 0

; --- Execução do código em laço infinito ---
Loop:

call Delay_Led1 ; Acende Led1 por 500mS

call Delay_Led3 ; Acende Led1 por 500mS
goto Loop ; Loop infinito neste trecho

; --- Funções e Subrotinas do Programa ---
Delay_Led1:

bsf PORTB, RB1
call Delay_500
bcf PORTB, RB1
return

Delay_Led3:

bsf PORTB, RB3
call Delay_500
bcf PORTB, RB3
return

;--- Rotina de Delay ---
; Ciclo de Instrução do 16F628A é de 4 Tck
; Operando a 4MHz cada instrução gasta 1uS
; Exceto as instruções Call, Goto e Return que precisam de 2 ciclos de máquina
; Rotina de Delay para 500mS
Delay_500:

movlw D'200'
movwf reg_0 ; reg_0 e reg_1 são posições de

memória

; Previamente

declaradas
Loop1:

movlw D'250'
movwf reg_1
; ********************** Delay 2.500 uS ****************************
Loop2:

nop ; Cada nop gasta 1cy

= 1uS

nop
nop
nop
nop
nop
nop ; 7 cy = 7uS
decfsz reg_1 ; 1 cy = 1us
goto Loop2 ; 2 cy = 2uS , total = Gasta 10uS x 250 =

2.500 uS = 2,5 mS
; ********************** Fim Delay 2.500 uS ****************************
;

;

decfsz reg_0 ; Repete 2.500 uS 200 vezes = 500mS
goto Loop1
return

; --- Tratamento da Interrupção ---
int_tread:

; Instruções aqui...
retfie ; Retorno ao programa principal

; --- Seleção dos Bancos de Registradores ---
; --- Seleciona Bank0 ---
sel_Bank0:

bcf STATUS, RP0
bcf STATUS, RP1
return

; --- Seleciona Bank1 ---
sel_Bank1:

bsf STATUS, RP0
bcf STATUS, RP1
return

; --- Seleciona Bank2 ---
sel_Bank2:

bcf STATUS, RP0
bsf STATUS, RP1
return

; --- Seleciona Bank3 ---
sel_Bank3:

bsf STATUS, RP0
bsf STATUS, RP1
return

end
