 ; EQUIVALENCIAS USADAS PARA LA ESTRUCTURA DE MATRIZ
 FILSJUEGO     EQU 7
 COLSJUEGO     EQU 5
 TOTALCELDAS   EQU FILSJUEGO*COLSJUEGO 

 ;EQUIVALENCIAS DE COORDENADAS PARA PINTAR EN PANTALLA (FIL, COL)  
 FILMSJMODO    EQU 20  ; posicion msj modo inicial (DEMO o Juego) 
 COLMSJMODO    EQU 5 

 FILMSJPOT     EQU 22   ; posicion msj numero tope con el que jugar
 COLMSJPOT     EQU 5 

 FILENTPOT     EQU FILMSJPOT   ; posicion para pedir el numero tope con el que jugar
 COLENTPOT     EQU COLMSJPOT+60 

 FILPANTALLAJ  EQU 1   ; posicion para imprimir pantTablero
 COLPANTALLAJ  EQU 0

 FILINICIOTAB  EQU 3   ; posicion contenido 1ra celda del tablero
 COLINICIOTAB  EQU 5   
  
 FILMSJGNRAL   EQU 20  ; posicion msjs introduce un comando, ganar, perder y salir 
 COLMSJGNRAL   EQU 43    
 
 FILCOMANDO    EQU FILMSJGNRAL  ; posicion introducir comando
 COLCOMANDO    EQU COLMSJGNRAL+10 
  

data segment        
   comando   db 22 dup ('$')  ;contendra el comando de entrada
   
   ;La estructura que almacena el tablero de juego 
   TableroJuego      dw TOTALCELDAS dup(?) ;contiene los datos del tablero en el momento actual
   TableroJuegoDebug dw 0,0,0,0,0,0,4,2,8,2,0,8,4,2,2,0,2,2,2,2,0,8,2,8,8,0,2,2,8,2,0,8,4,2,16  ;matriz con datos precargados
   
   fil       db ? ; para ColocarCursor
   col       db ? 

   colMatriz db ? ; para VectorAMatriz y MatrizAVector
   filMatriz db ?            
   posMatriz dw ? 
   
   tope      dw ? ; valor maximo hasta el que se jugara 
      
   ;**************************CADENAS ********************************
   cad       db 5 dup(?)  ;para almacenar el numero de una celda tras convertirlo a cadena
   cadVacia  db "     $"  ;para borrar el numero de una celda
   cadTope db 7 dup ('$')    
         
   ;Mensajes de Interfaz                      
   msjModo    db "Entrar al juego en modo Debug - tablero precargado - (S/N)? $"  
   msjIntPot  db "Introduce un valor potencia de 2, entre 16 y 2048 (incls.): $"  

   msgBlancoLargo db 19 dup (' '),'$'   ;para borrar comandos incorrectos
    
   msjPartidaGanada      db "Has ganado la partida!  ;-)  $" 
   msjPartidaPerdida     db "Has perdido! ;-(  $"

   PantallaInicio        db 10, 13, 10  
db " _______   ___        ______    ______   __   ___",10,13 
db "|   _   \ |   |      /      \  /  _   \ |  | /   )",10,13
db "(. |_)  :)||  |     // ____  \(: ( \___)(: |/   /",10,13  
db "|:     \/ |:  |    /  /    ) :)\/ \     |    __/",10,13   
db "(|  _  \\  \  |___(: (____/ // //  \ _  (// _  \",10,13   
db "|: |_)  :)( \_|:  \\        / (:   _) \ |: | \  \",10,13  
db "(_______/  \_______)\ _____/   \_______)(__|  \__)",10,10,13
db "            _______  ____  ____   ________  __      ______    _____  ___",10,13
db "           /       |(   _||_   | /        )|  \    /      \  (\    \|   \",10,13
db "          (: ______)|   (  ) : |(:   \___/ ||  |  // ____  \ |.\\   \    |",10,13
db "           \/    |  (:  |  | . ) \___  \   |:  | /  /    ) :)|: \.   \\  |",10,13
db "           // ___)   \\ \__/ //   __/  \\  |.  |(: (____/ // |.  \    \. |",10,13
db "          (:  (      /\\ __ //\  /  \   :) /\  |\\        /  |    \    \ |",10,13
db "           \__/     (__________)(_______/ (__\_|_)\______/    \___|\____\)",10,13,'$' 

  
   pantTablero db "    |__1__|__2__|__3__|__4__|__5__|     -= COMANDOS =-",10,13
               db "    |     |     |     |     |     |" ,10,13
               db "   A|     |     |     |     |     |" ,10,13         
               db "    |_____|_____|_____|_____|_____|     Introduce 1ro una fila y columna de" ,10,13
               db "    |     |     |     |     |     |     origen, deja un espacio y luego usa" ,10,13
               db "   B|     |     |     |     |     |     las siguientes letras hasta llegar" ,10,13         
               db "    |_____|_____|_____|_____|_____|     al bloque de destino" ,10,13     
               db "    |     |     |     |     |     |" ,10,13
               db "   C|     |     |     |     |     |" ,10,13
               db "    |_____|_____|_____|_____|_____|     Dcha  :D           Pasar       :P",10,13     
               db "    |     |     |     |     |     |" ,10,13
               db "   D|     |     |     |     |     |     Izq   :A",10,13
               db "    |_____|_____|_____|_____|_____|" ,10,13         
               db "    |     |     |     |     |     |     Abjo  :S           Nuevo Juego :N",10,13
               db "   E|     |     |     |     |     |" ,10,13
               db "    |_____|_____|_____|_____|_____|     Arrb  :W           Salir       :E",10,13           
               db "    |     |     |     |     |     |" ,10,13
               db "   F|     |     |     |     |     |" ,10,13
               db "    |_____|_____|_____|_____|_____|" ,10,13          
               db "    |     |     |     |     |     |        Comando>>" ,10,13
               db "   G|     |     |     |     |     |" ,10,13
               db "    |_____|_____|_____|_____|_____|",'$'
data ends


code segment
  include "PROCS_std.inc"  
  include "PROCS_clase.inc"

;*************************************************************************************                                                                                                                        
;*************************     procedimientos de IU    *******************************
;************************************************************************************* 

 

  ;F: Pinta en la pantalla TableroJuego   
  ;E: FILINICIOTAB, COLINICIOTAB (EQU) posicíon donde imprimir el contenido de la 1ra celda del tablero   
  ;E: tableroJuego (vector DB) y sus dimensiones como matriz FILJUEGO y COLJUEGO (EQU)
  ;E: fil y col para usar ColocarCursor
  ;E: cad y cadVacia (cadenas DB) para usar con ImprimirCadena
  ;S: pantalla
  PintarTableroJuego  PROC
    push ax
    push bx
    push cx
    push dx
    push si

    lea si, tableroJuego
      
    mov fil, FILINICIOTAB ;primera fila de la pantalla de juego
    xor bx, bx  
    mov cx, FILSJUEGO
     
   sigueFil:
    push cx
    mov col, COLINICIOTAB ; primera columna de la pantalla de juego 
    mov cx, COLSJUEGO 
 
   sigueCol:
    call ColocarCursor
    lea dx, cadVacia
    call ImprimirCadena
    call ColocarCursor 

    mov ax, [si+bx] 
    cmp ax, 0
    je siguecelda 
       
    lea dx, cad
    call NumeroACadena
    call imprimirCadena
      
   siguecelda:
    add bx, 2  
    add col, 6    ; se mueve por la misma fila
    loop sigueCol

    pop cx
    mov col, COLINICIOTAB 
    add fil, 3    ; cambia a la fila siguiente
  
    loop sigueFil
    
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret 
  PintarTableroJuego ENDP 
  
  ;F: pide una numero al usuario hasta que es un valor potencia de 2, entre 16 y 2048     
  ;S: tope (variable) contiene el valor introducido
  ControlEntrada16_2048 PROC   
   push ax
   push dx 
   push bx
   
   mov fil, FILMSJPOT
   mov col, COLMSJPOT
   call ColocarCursor 
   
   lea dx, msjIntPot
   call ImprimirCadena 

   NumEscrito:
   mov fil, FILENTPOT
   mov col, COLENTPOT
   call ColocarCursor 
   
   lea dx, cadVacia
   call ImprimirCadena
   call ColocarCursor
     
   lea dx, cadTope
   mov cadTope[0], 5 
   call LeerCadena
   
   lea dx, cadTope[2]
   call CadenaANumero     
   
   mov tope, ax                                                  
   cmp AX, 16
   jl NumEscrito
     
   cmp AX, 2048  
   jg NumEscrito   
   
   Potencia2: 
   mov bx, AX
   sub bx, 1
   and bx, AX
   cmp bx, 0
   je fin
   jmp NumEscrito
   
   fin:
   pop bx 
   pop dx
   pop ax
   ret
  ControlEntrada16_2048 ENDP     

  ;F:Dibuja la pantalla de inicio y pide Debug o Juego Normal y pide un numero tope para jugar entre 16 y 2048
  ; Si es modo Debug utiliza un tablero con valores iniciales
  ; Si es modo juego el usuario juega partiendo de cero contablero vacio
  ;S:TableroJuego actualizado segun Modo 
  InicioEntornoBloques PROC
    push dx
    push ax 
    push cx
      
    lea dx, PantallaInicio
    call ImprimirCadena 

    mov fil, FILMSJMODO
    mov col, COLMSJMODO
    call ColocarCursor 
    
    lea dx, msjModo
    call ImprimirCadena  
    
    LeerTecla:
    call LeerTeclaSinEco
    cmp AL, 'S'
    je  ModoDebug
    
    cmp AL, 'N'
    je  Borrar
    
    jmp LeerTecla
    
    ModoDebug:
    mov cx, TOTALCELDAS
    lea si, TableroJuegoDebug
    lea di, TableroJuego 
    call CopiarVector
    jmp sigPaso
    
    Borrar:  
    mov cx, COLSJUEGO     
    lea si, TableroJuego [(TOTALCELDAS-COLSJUEGO)* 2]
    call GenerarVectorAleatorios   
    jmp sigPaso                   
                       
    sigPaso: 
    
    call ControlEntrada16_2048     
    
    call BorrarPantalla
    
    mov fil, FILPANTALLAJ
	mov col, COLPANTALLAJ
	call ColocarCursor

	lea dx, PantTablero
	call imprimircadena
    
    call PintarTableroJuego
      
    jmp final
    
    final:  
    pop cx 
    pop ax
    pop dx
    ret 
  InicioEntornoBloques ENDP  

  
  ;F: Lee un comandos hasta que correponda con un formato de salida permitido y devuelve la acción que habrá que realizar:
  ;    formato A (cadenas que solo pueden contener un carácter):             
  ;    "P$" -> paso (seguir jugando sin mover bloque)     ; S: AH=0 
  ;    "N$" -> nuevo juego                                ; S: AH=1 
  ;    "E$" -> salir del juego                            ; S: AH=2

  ;    formato B: una cadena de longitud variable, de hasta 19 caracteres sin incluir el ENTER
  ;    FILCOL XXXXX donde FILCOL representan la posicion de un bloque a mover, siendo FIL un valor de fila entre 'A' y 'G', y COL la columna entre '1' y '5'
  ;    tras el espacio en blanco, XXXXX representa una combinación de caracteres que indican
  ;    'D' desplazar a la derecha
  ;    'A' desplazar a la izquierda         
  ;    'S' desplazar hacia abajo
  ;    'W' desplazar arriba                                
  ;    la salida del formato B es                         ; S: AH=3
  ComandoEntrada proc 
    push dx
    push cx
    push bx 
    push si
     
    PedirCom:
     
    mov fil, FILCOMANDO 
    mov col, COLCOMANDO
    call ColocarCursor  
    
    lea dx, msgBlancoLargo
    call ImprimirCadena
    call ColocarCursor
     
    lea dx, comando
    mov comando[0], 20
    call LeerCadena    
    
    cmp comando[1], 1
    je formatoA
     
    cmp comando[2], 'A'
    jl PedirCom
    cmp comando[2], 'G'
    jg PedirCom      
   
    cmp comando[3], '1'
    jl PedirCom
    cmp comando[3], '5'
    jg PedirCom
    
    cmp comando[4], ' '
    jne PedirCom   
    
    xor ah, ah
    mov al, comando[1]
    sub ax, 2
    mov cx, ax 
    xor ax, ax 
    
    mov si, 4
    aumentarCom: 
    inc si 
    mov bl, comando[si]
    sub cx, 1            
       
    Comprobar:
    cmp cx, 0  
    je finalComp:       
    cmp bl, 'A'
    je aumentarCom  
    cmp bl, 'S'
    je aumentarCom
    cmp bl, 'D'
    je aumentarCom
    cmp bl, 'W'
    je aumentarCom
    jne PedirCom
   
    loop Comprobar
     
    finalComp:
    
    mov ah, 3     
    jmp finalCom
    
    formatoA:
    cmp comando [2], 'P'
    je comandoP                 
                        
    cmp comando [2], 'N'
    je comandoN 
    
    cmp comando [2], 'E'
    je comandoE
    
    jmp PedirCom   
    
    comandoP:
    mov ah, 0
    jmp finalCom   
    
    comandoN:
    mov ah, 1 
    jmp finalCom  
    
    comandoE:
    mov ah, 2


    finalCom:
    pop si 
    pop bx
    pop cx
    pop dx
    ret
  ComandoEntrada endp
  
  ;F: Comprueba si se dan las condiciones de fin de juego
  ;    Si hay una celda con valor tope (DW) se ha ganado
  ;E: tablero de juego
  ;    numero de celdas del tablero   
  ;    tope, variable DW
  ;S: BX =0 si no es fin de juego y el juego debe continuar
  ;    BX =1 si es fin de juego y el juego debe terminar (se puede crear algún estado más si se considera oportuno)
  ;    mensajes de partida ganada en la posición FILMSJGNRAL, COLMSJGNRAL de pantalla, si es el caso
  ComprobarFinJuegoTope proc  
    push cx ;loop
    push di 
    push ax
     
    xor bx, bx 
    lea di,TableroJuego 
    mov cx, TOTALCELDAS 
   CompTope:   
    mov ax, [di] 
	cmp ax, tope
	je msjGanar
	add di,2
    loop CompTope  
    
    jmp ContinuaJu  
    
    msjGanar: 
    mov bx, 1
    mov fil, FILMSJGNRAL
    mov col, COLMSJGNRAL  
    call ColocarCursor
    
    lea dx, msjPartidaGanada
    call imprimircadena
    
    ContinuaJu:
    pop ax
    pop di
    pop cx 
    ret
    
    
  ComprobarFinJuegoTope endp 
  
  ;F: Comprueba si se dan las condiciones de fin de juego por haber elementos en la fila superior
  ;   Si el tablero tiene algún bloque en la primera fila, se ha perdido
  ;E: TableroJuego
  ;    COLSJUEGO  
  ;S: BX =0 si no es fin de juego y el juego debe continuar
  ;   BX =1 si el juego debe terminar
  ;   imprime mensaje de partida perdida en la posición FILMSJGNRAL, COLMSJGNRAL de pantalla, si es el caso
  ComprobarFinJuegoFila proc
    push cx ;loop
    push di 
    push ax   
     
    xor bx, bx   
    lea di,TableroJuego
    mov cx, COLSJUEGO
   CompFila:   
    mov ax, [di] 
	cmp ax, 0
	jne msjPerder
	add di,2
    loop CompFila  
     
    jmp NoPerdido
     
    msjPerder:
    mov bx, 1 
    mov fil, FILMSJGNRAL
    mov col, COLMSJGNRAL  
    call ColocarCursor
    
    lea dx, msjPartidaPerdida
    call imprimircadena
    
    NoPerdido: 

    pop ax
    pop di
    pop cx 
    ret
    
    
  ComprobarFinJuegoFila endp   
   
  ;F: si hay una fila vacia este procedimiento subira los valores
  ;   de todas las celdas una fila, generando una nueva con valores
  ;   aleatorios (entre 2^1 y 2^4) en la ultima posicion de las filas
  ;S: si bx=0, continua el juego 
  ;   si bx=1, finaliza el juego
  Pasar proc   
  push cx 
  push si  
  
  call ComprobarFinJuegoFila
  cmp bx, 0 
  je moverFil 
  jmp nada
  
  moverFil:  
  lea si, TableroJuego[COLSJUEGO*2]
  lea di, TableroJuego
  mov cx, TOTALCELDAS-COLSJUEGO

  call CopiarVector  
   
  mov cx, COLSJUEGO     
  lea si, TableroJuego [(TOTALCELDAS-COLSJUEGO)* 2]
  call GenerarVectorAleatorios 
  
  call PintarTableroJuego
    
  nada: 
  pop si
  pop cx
  ret 
  Pasar endp
  
  ;F: tras saber la posición en la que estamos vemos el movimiento del comando
  ;   y verificamos que son movimientos validos es decir:
  ;   que el movimiento se haga por casillas de valor 0 (menos la ultima)
  ;   que la casilla final no sea la misma que la inicial
  ;   que el valor de la cailla final sea el mismo que el valor de la inicial 
  mov2 proc 
  push bx
  push cx
  push ax 
  
  mov ch, 0
  mov cl, comando[1]
  sub cl, 3                 ; necesario para saber cual es la ultima letra de comando 
                           
  mov di, 4                   
  sigMov: 
  inc di 
  mov bl, comando[di]
  sub cx, 1                 ; resto 4 a CX en vez de 3 para saber cual es la ultima
  
  movCasillas:
  
  cmp bl, 'A'
  je movA 
  cmp bl, 'S'
  je movS
  cmp bl, 'D'
  je movD
  cmp bl, 'W'
  je movW  
  jmp finalmov2
  
  movA:
  sub colMatriz, 1  
  jmp comp0 
  
  movS:
  add filMatriz, 1  
  jmp comp0
 
  movD:
  add colMatriz, 1
  jmp comp0
    
  movW:
  sub filMatriz, 1   
  
  comp0: 
  cmp  colMatriz, 0
  jl finalmov2
  cmp  colMatriz, COLSJUEGO-1
  jg finalmov2   
  
  cmp  filMatriz, 0
  jl finalmov2
  cmp  filMatriz, FILSJUEGO-1
  jg finalmov2 
  
  lea si, tableroJuego
  call MatrizAVector   
  add si, posMatriz
  add si, posMatriz
    
  
  cmp cx, 0                    ;comprueba cual es la ultima letra del comando
  je ultNum
  
  cmp [si], 0
  je sigMov
  jne finalmov2          
  
  loop movCasillas            ;loop con duda
  jmp finalmov2 
  
  ultNum:     
  cmp si, dx                  ;comprueba que no sea la misma casilla del inicio
  je  finalmov2 
                             
  mov ax, [bp]
  cmp [si], ax                ;comprueba q tienen el mismo valor
  jne finalmov2
  
  shl [si], 1                ;se suman los valores 
                    
  xor cx, cx
  mov cl, dl
  bajar:                      ;se caen las casillas de encima
  mov ax,[bp-COLSJUEGO*2]
  mov [bp], ax 
  sub bp, COLSJUEGO*2  
  loop bajar 
  mov [bp], word ptr 0        ;pone a 0 la ultima celda
  
  call PintarTableroJuego                                         
  
  finalmov2:
  pop ax  
  pop cx
  pop bx 
  ret  
  mov2 endp
  
;*************************************************************************************                                                                                                                        
;**********************    procedimientos de funcionlidad    *************************
;************************************************************************************* 

;  Pese a que los procedimientos anteriores son una mezcla entre procedimientos
;  de funcionalidad e IU, los (por así llamarlos) hibridos los he colocado directamente 
;  en la parte de procedimientos IU, siendo los de procedimientos de funcionalidad
;  colocados en esta parte por no ser hibridos     

  ;F: Genera un vector de CX valores aleatorios potencia de 2 entre 2^1 y 2^4  
  ;E: si, dirección del vector donde almacenar cada dato
  ;   cx, número de valores aleatorios a generar y almacenar
  ;S: El vector contiene los valores aleatorios
  GenerarVectorAleatorios proc  
   push ax 
   push dx
   push bx
 
   exponente:
   mov bl, 4
   call NumAleatorio
   inc AH
    
   push cx 
   mov dx, 1  
   mov CL, AH
   shl dx, CL 
   pop cx
   
    
   mov [si], dx
   add si,2 
   loop exponente
   
   pop bx
   pop dx
   pop ax
   ret
  GenerarVectorAleatorios endp  
   
   
  ;F: Obtenemos la posicion de la celda introducida en el comando
  ;   y comprobamos que sea una celda valida (distinto de 0)
  ;S: bp, almacena la posicion de la celda inicial
  ;   si, almacena la posicion de la celda destino (ira cambiando segun el codigo)             
  mov1 proc
  push ax 
         
  lea si, tableroJuego
         
  mov al, comando[2]
  sub al, 'A'
  mov filMatriz, al 
  xor dx, dx
  mov dl, filMatriz           ; guarda en dl filMatriz(requerido para el bajar)
  
  mov al, comando[3]   
  sub al, '1'  
  mov colMatriz, al     
                     
  call MatrizAVector  
  add si, posMatriz
  add si, posMatriz  
    
  mov bp, si                  ; en bp se almacena la posicion de la celda inicial 
  cmp [si], 0                 ; verifica que la casilla a la que intentamos acceder no es 0
  je  finalMov1    
  
  call mov2              
  
  finalMov1: 

  pop ax  
  ret
  mov1 endp
  

;************************ PROGRAMA PRINCIPAL ***************
principal:
    mov ax, data
    mov ds, ax         
    
    inicio: 
    
    call BorrarPantalla 
    
    mov fil, 0
    mov col, 0
    call ColocarCursor  
    
    call InicioEntornoBloques  
    
    comandos:
    call ComandoEntrada 
    
    cmp ah, 3 
    je movim
    
    cmp ah, 2
    je salir
    
    cmp ah, 1
    je inicio
    
    cmp ah, 0
    je pasa
    jmp salir 
    
    movim:
    call mov1
    call ComprobarFinJuegoTope
    cmp bx, 1
    je salir 
    jmp comandos
    
    pasa:
    call Pasar 
    cmp bx, 0
    jne salir
    jmp comandos
    
    salir:  
    mov ah, 4ch
    int 21h        
 ends 
end principal         