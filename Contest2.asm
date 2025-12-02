INCLUDE Irvine32.inc


COLS EQU 10
ROWS EQU 5
SIZE EQU COLS*ROWS    ;GRID = 50 CARDS
PAIRS EQU SIZE/2      ;25 PAIRS 
EMPTY EQU 0FFh		  ;marker for removed card

.data
values BYTE SIZE DUP(?)		;Displayed values are 0 to 24 or EMPTY
curr_count DWORD SIZE		; number of non empty card on the grid

promptStart	BYTE "Pick first card(row column): ", 0
promptNextPick BYTE "Pick adjacent matching card", 0
Invalid BYTE "Invalid pick. Try again.",0
notAdj BYTE "Must be adjacent. Try again.",0
noMatch BYTE "Not a matching pair. Try again",0
matched BYTE "Match removed!",0

gameOver BYTE "Game over: no adjacent matches left.",0
win BYTE "You cleared the board! YOU WIN!",0

card1 DWORD ?
card2 DWORD ?

.code

FillPairs PROC USES esi ebx: 
	mov bl, 0		
	mov exi, 0 

FillLoop:
	mov values[esi], bl
	mov value[esi+1], bl

	add esi, 2		
	inc bl

	cmp bl, PAIRS
	jb FillLoop

	ret

FillPairs ENDP

shuffle PROC USES eax ebx ecx edx esi 
	mov ecx, SIZE -1
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


main PROC
	call Randomize
	call FillPairs
	call shuffle

	mov curr_count, SIZE
	mov esi, 0

PrintLoop:
	movzx eax, values[esi]
	call WriteDex
	mov al, ' '
	call WriteChar

	inc esi
	cmp esi, SIZE
	jl PrintLoop
	call Crlf

	exit

main ENDP

END main


