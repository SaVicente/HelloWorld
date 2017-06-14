list p=P18F45K20
#include <p18f45k20.inc>

config fosc=INTIO67	; Configuramos oscilador
config wdten=off	; Watchdog off
modo equ 0x00
    

    CODE 0X0000
    
    ORG 0X0000
    GOTO MAIN
    
    ORG 0X0010
    MAIN

    MOVLW b'01111100'	;COnfiguramos el oscilador para usar
    MOVWF OSCCON,0	;el PLL y elevar la frecuencia de trabajo
    
    MOVLW b'11011111'   
    MOVWF OSCTUNE,0


    BCF TRISD,0		;Establecemos el PORTD como salidas
    BCF TRISD,1
    MOVLW b'10001101'	;Cargamos el registro del Timer 0
    MOVWF TMR0L
    
    MOVLW b'11100000'	;Configuramos las interrupciones
    MOVWF INTCON
    BCF RCON,7
    
    MOVLW b'11001000'	;COnfiguramos el Timer 0
    MOVWF T0CON
    
    BCF PORTD,1
    BSF PORTD,0
    BCF modo,0
    
    BSF INTCON2,2	;Ponemos la interrupción del TMR0 como prioridad alta
    
    inicio
    
    bra inicio
    
    INTHIGH
     BTFSS modo,0
     BTG PORTD,0	;Cambiamos de valor los puertos para tener la señal
     NOP		;cuadrada		;El NOP es para dejar un tiempo entre cada
     BTG PORTD,1	;orden
     NOP
     BTFSC modo,0
     BTG PORTD,0
     NOP
    
    
    MOVLW b'10001101'	;Cargamos el registro del Timer 0
    MOVWF TMR0L
    
    BCF INTCON, 2
    BTG modo,0
    
    RETFIE
    
    ORG 0X0008
    interrupt
    BRA INTHIGH
 
END




