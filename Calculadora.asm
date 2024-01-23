====================================================================
; DEFINITIONS
;====================================================================

#include p16f84a.inc                ; Include register definition file
   __CONFIG _XT_OSC & _PWRTE_ON & _CP_OFF & _WDT_OFF

;====================================================================
; VARIABLES
;====================================================================
        RADIX DEC

PUERTOA 				EQU 05H
PUERTOB 				EQU 06H ; Declaración del puerto B en la dirección 06 H
STATUS 					EQU 03H ; Declaración del registro de estado
;====================var de los digitos==============================
Divi				       EQU 0FH ; contador de las unidades
Multi                                EQU 10H 
Copia1		               EQU 12H
Copia2		               EQU 13H
;=====================VARIABLES PARA EL DELAY========================   
Num1				equ 0CH
Num2			        equ 0DH


;====================================================================
; RESET and INTERRUPT VECTORS
;====================================================================

	ORG 	0
      	goto  Start
	ORG 	5
;====================================================================
; CODE SEGMENT
;====================================================================

Start	
    BSF STATUS,5 ; Cambio del banco de memoria. Banco 1 activado.
    CLRF TRISB ; Configuración de la puerta B como puerto de salida.
    MOVLW b'00011110' ; (a0 salida carry lo demas de entrada)
    movwf TRISA             
    BCF STATUS,5 ; Cambio del banco de memoria. Banco 0 activado    

    
Config_inputB
       BSF STATUS,5 ; Cambio del banco de memoria. Banco 1 activado
       MOVLW d'255'
       movwf TRISB ; Configuración de la puerta B como puerto de entrada
       MOVLW b'00011110' ; (a0 salida carry lo demas de entrada)
       movwf TRISA             
       BCF STATUS,5 ; Cambio del banco de memoria. Banco 0 activado  
      return
      
Config_outputB
       BSF STATUS,5 ; Cambio del banco de memoria. Banco 1 activado.
       CLRF TRISB ; Configuración de la puerta B como puerto de salida.
       MOVLW b'00011110' ; (a0 salida carry lo demas de entrada)
       movwf TRISA             
       BCF STATUS,5 ; Cambio del banco de memoria. Banco 0 activado  
      return
      
LeerNum1
       clrf Num1
       movf PORTB, W
       movwf Num1
      return 
LeerNum2
       clrf Num2
       movf PORTB, W
       movwf Num1
       return
       
 Operaciones
     call Suma
     call Resta
     call Multiplicacion
     call Division
     return 
     
 Suma:
    clrw
    movf Num1, w
    addwf Num2 , w
    return

 Resta:
     clrw
     clrf Copia1
     ;---------------
     movf Num2, w
     movwf Copia1
     comf Copia1, f
     incf Copia1, w
     addwf Num1, w
     return 
     
Multipicacion:
    clrw
    clrf Copia1
    clrf Multi
   ;------------------   
   movf  Num1, w
   movwf Copia1
   movf  Num2, w
   goto Loop_multi
Loop_multi:
   addwf Multi, f
   decfsz Copia1, 1
   goto Loop_multi ;si no brinca
   Movf Multi, w
   return
 
Division:
    clrw
    clrf Copia1
    clrf Divi
    ;-------------
   movf  Num1, w
   movwf Copia1
   movf  Num2, w
   movwf Copia2 
   goto Loop_Division   
   
Loop_Division:
      movf  Num2, w
      subwf  Copia1, f
      incf Divi, f
      ;-----------------
      movf Copia2, w
      subwf Copia1, w
      BTFSC STATUS, C
      goto Loop_Division
       Movf Divi, w
      return

   Imprimir
        MOVWF PORTB
   return