StkSeg  SEGMENT PARA STACK 'STACK'
    DB 200h DUP (?)
StkSeg  ENDS
;
DataS SEGMENT word 'DATA'
    HelloMessage    DB   'Hello, world !'  ;
                    DB   13                ; /r 
                    DB   10                ; /n
                    DB   '$'               ;ограничитель
    ExitMessage     DB   'Press '  ;
                    DB   '$'               ;ограничитель
DataS   ENDS
;
Code    SEGMENT para 'CODE'
    ASSUME  CS:Code, DS:DataS ; 
;Являетсяинструкциейкомпилятору,указывающей,какойсегментныйрегистрс
;какимсегментомбудетсвязанвовремяработыпрограммы.
;Используетсядляконтроляправильностиобращениякпеременными
;автоматическогоопределениясегментногопрефикса в машинных командах работы с память
;
DispMsg:
    mov   AX,DataS                  ;AX - text
    mov   DS,AX                     ;установка DS

    mov   DX, OFFSET HelloMessage   ;DS:DX -адрес строки
    mov   AH, 9                     ;АН=09h выдать на дисплей строку

    mov   CX, 0                     ; start loop
Hello:
    int   21h                       ;вызов  функции DOS

    INC   CX                        ; or ADD CX, 1
    CMP   CX, 3                     ; may be loop in cx 
    JNE  Hello


    mov   DX, OFFSET ExitMessage   ;DS:DX -адрес строки
    mov   AH, 9                    ;АН=09h выдать на дисплей строку
    int   21h                      ;вызов  функции DOS

    mov   AH,7                     ;АН=07h ввести символ без эха
    INT   21h                      ;вызов  функции DOS
    mov   AH,4Ch                   ;АН=4Ch завершить процесс
    int   21h                      ;вызов  функции DOS
Code    ENDS

END   DispMsg   ;masm only in mdn 
