INCLUDE Irvine32.inc


COLS EQU 10
ROWS EQU 5
GRIDSIZE EQU COLS*ROWS    ;GRID = 50 CARDS
PAIRS EQU GRIDSIZE/2      ;25 PAIRS 
EMPTY EQU 0FFh		  ;marker for removed card

.data
values BYTE GRIDSIZE DUP(?)		;Displayed values are 0 to 24 or EMPTY
curr_count DWORD GRIDSIZE		; number of non empty card on the grid

colHeader BYTE "  0  1  2  3  4  5  6  7  8  9", 0
promptStart	BYTE "Pick first card(row column): ", 0
promptNextPick BYTE "Pick adjacent matching card", 0
Invalid BYTE "Invalid pick. Try again.",0
notAdj BYTE "Must be adjacent. Try again.",0
noMatch BYTE "Not a matching pair. Try again",0
matched BYTE "Match removed!",0

gameOver BYTE "Game over: no adjacent matches left.",0
win BYTE "You cleared the board! YOU WIN!",0

space BYTE " ", 0 
dot BYTE ". ", 0		; for 

card1 DWORD ?
card2 DWORD ?

.code

FillPairs PROC USES esi ebx
	mov bl, 0		
	mov esi, 0 

FillLoop:
	mov values[esi], bl
	mov values[esi+1], bl

	add esi, 2		
	inc bl

	cmp bl, PAIRS
	jb FillLoop

	ret

FillPairs ENDP

shuffle PROC USES eax ebx ecx edx esi 
	mov ecx, GRIDSIZE -1
	mov esi, ecx 

shuffleLoop:
	mov eax, esi
	inc eax
	call RandomRange		

	mov bl, values[esi]
	mov dl, values[eax]
	mov values[esi], dl
	mov values[eax], bl

	dec esi
	loop shuffleLoop

	ret
shuffle ENDP

formatBoard PROC USES eax ebx ecx edx esi edi
	call Clrscr
	mov edx, OFFSET colHeader
	call WriteString
	call Crlf

	mov esi, 0		; linear index
	mov ebx, 0		; row

RowLoop:
	mov al, '0'
	add al, bl
	call WriteChar
	mov al, ' '  
	call WriteChar

	mov  edi, 0

ColumnLoop:
	mov al, values[esi]
	cmp al, EMPTY
	je DispDot

DispLetter:
	add al, 'A'		;convert the number to a letter
	call WriteChar
	mov al, ' '
	call WriteChar
	mov al, ' '
	call WriteChar
	jmp NextCell

DispDot:
	mov al, '.'
	call WriteChar
	mov al, ' '
	call WriteChar
	mov al, ' '
	call WriteChar

NextCell:
	inc esi
	inc edi
	cmp edi, COLS
	jb ColumnLoop

	call Crlf
	inc ebx
	cmp ebx, ROWS
	jb RowLoop

	ret
formatBoard ENDP

UserSelection PROC USES ebx ecx edx esi
	mov esi, edx

inputLoop:
	call Crlf
	mov edx, esi
	call WriteString	;print prompt

	;READ ROW
	call ReadInt
	mov ebx, eax

	; READ COLUMN
	call ReadInt
	mov ecx, eax

	;Validate Row
	cmp ebx, 0
	jl BadInput
	cmp ebx, COLS
	jge BadInput

	;VUALIDATE  COLMN
	cmp ecx, 0
	jl BadInput
	cmp ecx, COLS
	jge BadInput

	;Convert to index
	mov eax, ebx
	imul eax, COLS
	add eax, ecx

	;Validate card has not been removed
	movzx edx, values[eax]
	cmp edx, EMPTY
	je BadInput

	ret

BadInput:
	call Crlf
	mov edx, OFFSET Invalid
	call WriteString
	call Crlf
	jmp InputLoop

UserSelection ENDP

index_to_rowcol PROC USES edx ecx
	xor edx, edx
	mov ecx, COLS
	div ecx

	mov ebx, eax 
	mov ecx, edx
	ret
index_to_rowcol ENDP

diff PROC
	sub eax, ebx
	jns done		;result not negative then skip negation
	neg eax 
done:
	ret
diff ENDP

adjacent PROC USES ebx ecx esi edi
	
	cmp eax, edx		; eax-index 1, edx-index 2
	je NotAdjacent			;not a valid adjacent match
	
	push edx

	call index_to_rowcol
	mov esi, ebx
	mov edi, ecx

	pop eax 
	call index_to_rowcol
	
	mov eax, esi		;row 1, row 2 in ebx
	call diff
	cmp eax, 1
	jg NotAdjacent

	mov eax, edi
	mov ebx, ecx
	call diff 
	cmp eax, 1
	ja NotAdjacent

	mov eax, 1
	ret					;return 1 if adjacent
	
	NotAdjacent:
		xor eax, eax	;return 0 if not adjacent
		ret
	adjacent ENDP


main PROC
	call Randomize
	call FillPairs
	call shuffle
	call formatBoard
	call WaitMsg

	mov edx, OFFSET promptStart
	call UserSelection
	mov card1, eax

	mov edx, OFFSET promptNextPick
	call UserSelection
	mov card2, eax
	 

;	mov curr_count, GRIDSIZE
;	mov esi, 0

;PrintLoop:
;	movzx eax, values[esi]
;	call WriteDec
;	mov al, ' '
;	call WriteChar

;	inc esi
;	cmp esi, GRIDSIZE
;	jl PrintLoop
;	call Crlf

	exit

main ENDP

END main


