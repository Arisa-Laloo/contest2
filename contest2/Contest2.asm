;Memory Matching game
INCLUDE Irvine32.inc

.data
    ; Cards (face-down values)
    ; Positions: 1 2 3 4
    cards BYTE  'A','A','B','B', 'C', 'C', 'D', 'D'

    dispboard   BYTE '1','2','3','4','5','6','7','8'
    promptBoard BYTE "Board: ", 0
    promptStart	BYTE "Pick first card position(1-8): ", 0
    promptNextPick BYTE "Enter second card position (1-8): ",0

    showGuess1 Byte "Value at first pick: ", 0
    showGuess2 Byte "Value at second pick: ", 0

    matchMsg   BYTE "Match!",0
    noMatchMsg BYTE "Not a match!",0
    promptExit BYTE "Exiting game.",0
    newRound BYTE "New Round"
    pairs DWORD 0
    promptWin BYTE "All Pairs Found. You Win!!", 0

.code

Shuffle PROC
    mov ecx, 7          ; start from last index (7)

ShuffleLoop:
    ; j = RandomRange(i+1)
    mov eax, ecx
    inc eax
    call RandomRange    ; 0 to eax-1
    mov ebx, eax        ; EBX = j index

    ; swapping cards[ecx] and cards[ebx] for shuffling
    mov al, cards[ecx]
    mov dl, cards[ebx]

    mov cards[ecx], dl
    mov cards[ebx], al

    loop ShuffleLoop
    ret
Shuffle ENDP


main PROC
call Randomize
call Shuffle
GameLoop:
    ;New round
    mov edx, OFFSET newRound
    call WriteString
    call Crlf

    ;print board
    mov edx, OFFSET promptBoard
    call WriteString
    
    mov esi, OFFSET dispboard
    mov ecx, 8

printBoard:
    mov al, [esi]
    movzx eax, al
    call WriteChar

    mov al, ' '
    call WriteChar

    inc esi
    loop PrintBoard 

    call Crlf
    
    ;prompt 1st pick
    mov edx, OFFSET promptStart
    call WriteString
    call ReadInt

    cmp eax, 0        ; check if user entered 0
    je EndGame        ;exit if 0

    mov ebx, eax      ; store 1st pick(1-8)
    dec ebx           ; 0 - 7
    
    mov edx, OFFSET showGuess1
    call WriteString

    mov al, cards[ebx]
    movzx eax, al
    call WriteChar
    call Crlf

    ; prompt for pick 2
    mov edx, OFFSET promptNextPick
    call WriteString
    call ReadInt
    mov ecx, eax      ; store 2nd pick
    dec ecx           ; convert to index

    mov edx, OFFSET showGuess2
    call WriteString

    mov al, cards[ecx]
    movzx eax, al
    call WriteChar
    call Crlf

    ;save card values
    mov al, cards[ebx]   ; value at pick1
    mov dl, cards[ecx]   ; value at pick2

    ;compare chosen cards
    cmp al, dl
    jne notMatch

match:
    mov edx, OFFSET matchMsg
    call WriteString
    call Crlf
    inc pairs
    jmp ContinueLoop

notMatch:
    mov edx, OFFSET noMatchMsg
    call WriteString

ContinueLoop:
    
    cmp pairs, 4
    je AllFound
    call Crlf
    jmp GameLoop        ;next round

AllFound:
    mov edx, OFFSET promptWin
    call WriteString
    call Crlf
    exit

EndGame:
    mov edx, OFFSET promptExit
    call WriteString
    call Crlf
    exit

main ENDP
END main
