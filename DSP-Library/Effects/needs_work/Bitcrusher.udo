
/********************************************************

	Bitcrusher.udo
	Author: Iain McCurdy
	COSMO UDO adaptation: Bernt Isak Wærstad

	Arguments: Bits, Fold, Level, DryWet_Mix
    Defaults:  0.6, 0.3, 0.8, 1

	Bits: 1 - 16
	Fold: 1 - 1024
	Level: 0 - 1
	Dry/wet mix: 0% - 100%

    Description:
	A bitcrusher effect

********************************************************/

#define Bits #0.5# ; 8 bit
#define Fold #0# ; 1
#define Level #1# ; 1
#define Mix #1# ; 1

;*********************************************************************
; Bitcrusher - Mono
;*********************************************************************

opcode Bitcrusher, a, akkkk

	ain, kBits, kFold, kLevel, kMix xin
	
	kBits 	init $Bits
	kFold	init $Fold
	kLevel	init $Level
	kMix	init $Mix 	 


	kBits scale kBits, 16, 1
	kBits limit kBits, 1, 16
	Sbit sprintfk "Bits: %d", kBits
		puts Sbit, kBits

	kFold expcurve kFold, 30 ; CHECK THIS
	kFold scale kFold, 1024, 1
	Sfold sprintfk "Foldover: %f", kFold
		puts Sfold, kFold

	kLevel scale kLevel, 0.8, 0
	Slev sprintfk "BitCrusher level: %f", kLevel
		puts Slev, kLevel
	kLevel port kLevel, 0.01

	Smix sprintfk "BitCrusher mix: %f", kMix
		puts Smix, kMix + 1

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
; Bitcrusher - Stereo
;*********************************************************************

opcode Bitcrusher, aa, aakkkk

	ainL,ainR, kBits, kFold, kLevel, kMix xin

	aOutL Bitcrusher ainL, kBits, kFold, kLevel, kMix
	aOutR Bitcrusher ainR, kBits, kFold, kLevel, kMix

	xout aOutL, aOutR

endop
