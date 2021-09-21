/********************************************************

	Wobble.udo
	Author: Alex Hofmann
	COSMO UDO adaptation: Bernt Isak Wærstad

	Arguments: Frequency, Dry/wet mix
    Defaults:  0.2, 0.5

	Frequency: 0.3Hz - 20Hz

	Description:
	Wobble effect

********************************************************/

	; Default argument values
	#define Wobble_frequency #0.2# 
	#define DryWet_Mix #0.5#

	; Toggle printing on/off
	#define PRINT #0#

	; Max and minimum values
	#define MAX_FREQ #20#
	#define MIN_FREQ #0.3#	

;*********************************************************************
; Wobble - 1 in / 1 out
;*********************************************************************

opcode Wobble, a, akk

	ain, kFreq, kDryWet xin

	kFreq expcurve kFreq, 30
	kFreq scale kFreq, $MAX_FREQ, $MIN_FREQ
	kDryWet scale kDryWet, 1, 0
	
	if ($PRINT == 1) then
		Srev sprintfk "Wobble Freq: %fHz", kFreq
			puts Srev, kFreq
		
		Srev sprintfk "Wobble Mix: %f", kDryWet
			puts Srev, kDryWet+1
	endif

	kFreq port kFreq, 0.1

	aMod lfo 2000, kFreq, 0

	aFiltered moogvcf ain, 2300 + aMod, 0.7

	aFiltered *= 2.5

	aOut ntrpol ain, aFiltered, kDryWet

	xout aOut

endop

;*********************************************************************
; Wobble - 1 in / 2 out
;*********************************************************************

opcode Wobble, aa, akk

	ain, kFreq, kDryWet xin

	aOutL Wobble ain, kFreq, kDryWet
	aOutR Wobble ain, kFreq, kDryWet

	xout aOutL, aOutR

endop

;*********************************************************************
; Wobble - 2 in / 2 out
;*********************************************************************

opcode Wobble, aa, aakk

	ainL, ainR, kFreq, kDryWet xin

	aOutL Wobble ainL, kFreq, kDryWet
	aOutR Wobble ainR, kFreq, kDryWet

	xout aOutL, aOutR


endop
