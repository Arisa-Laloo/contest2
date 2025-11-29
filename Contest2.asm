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



