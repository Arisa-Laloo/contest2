; ------------------------------------------------------
; Simple Memory Match Skeleton
; Prints board, gets 2 picks, checks match
; MASM + Irvine32
; ------------------------------------------------------

INCLUDE Irvine32.inc

.data
    ; Cards (face-down values)
    ; Positions: 1 2 3 4
    cards BYTE  'A','A','B','B', 'C', 'C', 'D', 'D'

    board   BYTE "Board Positions: 1 2 3 4 5 6 7 8",0
    promptStart	BYTE "Pick first card position(1-8): ", 0
    promptNextPick BYTE "Enter second card position (1-8): ",0
    matchMsg   BYTE "Match!",0
    noMatchMsg BYTE "Not a match!",0

.code
main PROC

    ;print board
    mov edx, OFFSET board
    call WriteString
    call CrLf
    
    ;prompt for pick 1
    mov edx, OFFSET promptStart
    call WriteString
    call ReadInt
    mov ebx, eax      ; store pick1 (1-4)
    dec ebx           ; convert to array index (0-3)

    ; prompt for pick 1
    mov edx, OFFSET promptNextPick
    call WriteString
    call ReadInt
    mov ecx, eax      ; store pick2
    dec ecx           ; convert to index

    ;get card values
    mov al, cards[ebx]   ; value at pick1
    mov dl, cards[ecx]   ; value at pick2

    ;compare chosen cards
    cmp al, dl
    jne notMatch

match:
    mov edx, OFFSET matchMsg
    call WriteString
    jmp done

notMatch:
    mov edx, OFFSET noMatchMsg
    call WriteString

done:
    call CrLf
    exit

main ENDP
END main
