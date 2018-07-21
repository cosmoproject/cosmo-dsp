/********************************************************
	Tremolo.udo
	Author: Bernt Isak Wærstad

	Arguments: Frequency, Depth
    Defaults:  0.8, 1

	Frequency: 0.001Hz - 15Hz
	Depth: 0 - 1

	Description:
    A tremolo effect
********************************************************/

	; Default argument values
	#define Frequency #0.5# 
	#define Depth #1#

	; Toggle printing on/off
	#define PRINT #0#

	; Max and minimum values
	#define MAX_FREQ #15#
	#define MIN_FREQ #0.001#	

;*********************************************************************
; Tremolo - 1 in / 1 out
;*********************************************************************

opcode Tremolo, a, akkk
	ain, kFreq, kDepth, kStereoMode xin

	kFreq init $Frequency
	kDepth init $Depth

	kFreq expcurve kFreq, 30
	kFreq scale kFreq, $MAX_FREQ, $MIN_FREQ

	if $PRINT == 1 then
		Sfreq sprintfk "Tremolo freq: %fHz", kFreq
			puts Sfreq, kFreq + 1

		Sdepth sprintfk "Tremolo depth: %f", kDepth
			puts Sdepth, kDepth + 1 
	endif

	kFreq port kFreq, 0.1
	aFreq interp kFreq

	aMod oscil kDepth, aFreq

	if kStereoMode == 0 then
		aCar oscil 0.45, 4.21*aMod
	else
		aCar oscil 0.5, 4.7*aMod*0.98
	endif

	aout = ain * aCar

	xout aout

endop

;*********************************************************************
; Tremolo - 1 in / 2 out
;*********************************************************************

opcode Tremolo, aa, akk
	ain, kFreq, kDepth xin

	aL Tremolo  ain, kFreq, kDepth, 0
	aR Tremolo  ain, kFreq, kDepth, 1

	xout aL, aR

endop

;*********************************************************************
; Tremolo - 2 in / 2 out
;*********************************************************************

opcode Tremolo, aa, aakk
	ainL, ainR, kFreq, kDepth xin

	aL Tremolo  ainL, kFreq, kDepth, 0
	aR Tremolo  ainR, kFreq, kDepth, 1

	xout aL, aR
	
endop
