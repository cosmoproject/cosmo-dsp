/********************************************************
	Tremolo.udo
	Author: Bernt Isak Wærstad

	Arguments: Frequency, Depth, Dry/wet mix [, StereoMode]
    Defaults:  0.8, 1, 0.5

	Frequency: 0.001Hz - 15Hz
	Depth: 0 - 1
	Dry/wet mix: 0% - 100%

	Optional arguments:
	Stereo Mode: 0 - 1

	Description:
    A tremolo effect
********************************************************/

	; Default argument values
	#define Frequency #0.5#
	#define Depth #1#
	#define DryWet_Mix #0.5#

	; Toggle printing on/off
	#define PRINT #0#

	; Max and minimum values
	#define MAX_FREQ #15#
	#define MIN_FREQ #0.001#

;*********************************************************************
; Tremolo - 1 in / 1 out
;*********************************************************************

opcode Tremolo, a, akkkO
	ain, kFreq, kDepth, kDryWet, kStereoMode xin

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

	aTremolo= ain * aCar
	aOut ntrpol ain, aTremolo, kDryWet

	xout aOut

endop

;*********************************************************************
; Tremolo - 1 in / 2 out
;*********************************************************************

opcode Tremolo, aa, akkkO
	ain, kFreq, kDepth, kDryWet, kStereoMode xin

	aL Tremolo  ain, kFreq, kDepth, kDryWet, 0
	aR Tremolo  ain, kFreq, kDepth, kDryWet, kStereoMode

	xout aL, aR

endop

;*********************************************************************
; Tremolo - 2 in / 2 out
;*********************************************************************

opcode Tremolo, aa, aakkkO
	ainL, ainR, kFreq, kDepth, kDryWet, kStereoMode xin

	aL Tremolo  ainL, kFreq, kDepth, kDryWet, 0
	aR Tremolo  ainR, kFreq, kDepth, kDryWet, kStereoMode

	xout aL, aR

endop
