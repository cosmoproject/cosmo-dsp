
/********************************************************

	Bitcrusher.udo
	Author: Iain McCurdy
	COSMO UDO adaptation: Bernt Isak Wærstad

	Arguments: Bits, Fold, Level, DryWet_Mix
    Defaults:  0.5, 0, 1, 1

	Bits: 1 - 16
	Fold: 1 - 1024
	Level: 0 - 1
	Dry/wet mix: 0% - 100%

    Description:
	A bitcrusher effect

********************************************************/

	; Default argument values
	#define Bits #0.5# ; 8 bit
	#define Fold #0# ; 1
	#define Level #1# 
	#define Mix #1# 

	; Toggle printing on/off
	#define PRINT #0#

	; Max and minimum values
	#define MAX_FOLD #1024#
	#define MIN_FOLD #1#	
	#define MAX_BIT #16#
	#define MIN_BIT #1#

;*********************************************************************
; Bitcrusher - 1 in / 1 out
;*********************************************************************

opcode Bitcrusher, a, akkkk

	ain, kBits, kFold, kLevel, kMix xin
	
	kBits 	init $Bits
	kFold	init $Fold
	kLevel	init $Level
	kMix	init $Mix 	 

    ; ******************************
  	; Controller value scalings
  	; ******************************

	kBits scale kBits, $MAX_BIT, $MIN_BIT
	kBits limit kBits, $MIN_BIT, $MAX_BIT

	kFold expcurve kFold, 30 ; CHECK THIS
	kFold scale kFold, $MAX_FOLD, $MIN_FOLD

	if $PRINT == 1 then
		Sfold sprintfk "Foldover: %f", kFold
			puts Sfold, kFold
		Slev sprintfk "BitCrusher level: %f", kLevel
			puts Slev, kLevel
		Smix sprintfk "BitCrusher mix: %f", kMix
			puts Smix, kMix + 1
		Sbit sprintfk "Bits: %d", kBits
			puts Sbit, kBits
	endif

	kLevel port kLevel, 0.01
	kporttime	linseg	0,0.001,0.01
	kFold	portk	kFold,kporttime

	; ??
	kBits *= 0.6

	kvalues		pow		2, kBits					;RAISES 2 TO THE POWER OF kbitdepth. THE OUTPUT VALUE REPRESENTS THE NUMBER OF POSSIBLE VALUES AT THAT PARTICULAR BIT DEPTH
	aBit		=	(int((ain/0dbfs)*kvalues))/kvalues	;BIT DEPTH REDUCE AUDIO SIGNAL
	aBit		fold 	aBit, kFold							;APPLY SAMPLING RATE FOLDOVER

	aBit	=	aBit * kLevel

	aOut ntrpol ain, aBit, kMix	
	
	xout	aOut

endop

;*********************************************************************
; Bitcrusher - 1 in / 2 out
;*********************************************************************

opcode Bitcrusher, aa, akkkk

	ain, kBits, kFold, kLevel, kMix xin

	aOutL Bitcrusher ain, kBits, kFold, kLevel, kMix
	aOutR Bitcrusher ain, kBits, kFold, kLevel, kMix

	xout aOutL, aOutR

endop

;*********************************************************************
; Bitcrusher - 2 in / 2 out
;*********************************************************************

opcode Bitcrusher, aa, aakkkk

	ainL,ainR, kBits, kFold, kLevel, kMix xin

	aOutL Bitcrusher ainL, kBits, kFold, kLevel, kMix
	aOutR Bitcrusher ainR, kBits, kFold, kLevel, kMix

	xout aOutL, aOutR

endop
