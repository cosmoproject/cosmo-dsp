/********************************************************

	Hack.udo
	Author: Alex Hofmann
	COSMO UDO adaptation: Bernt Isak Wærstad

	Arguments: Frequency, Dry/wet mix
    Defaults:  0.3, 0.5

	Frequency: 0.5Hz - 45Hz
	Dry/wet mix: 0% - 100%

	Description:
	A square wave amplitude modulator

********************************************************/

	; Default argument values
	#define Hack_frequency #0.3#
	#define DryWet_Mix #0.5#
    #define Wave #0.6#

	; Toggle printing on/off
	#define PRINT #0#

	; Max and minimum values
	#define MAX_FREQ #45#
	#define MIN_FREQ #0.5#

;*********************************************************************
; Hack - 1 in / 1 out
;*********************************************************************

opcode Hack, a, akkk

	ain, kFreq, kDryWet, kWave  xin

	kFreq expcurve kFreq, 30
	kFreq scale kFreq, $MAX_FREQ, $MIN_FREQ

	kDryWet scale kDryWet, 1, 0

    kWave scale kWave, 4, 0

	if ($PRINT == 1) then
		Srev sprintfk "Hack freq: %fHz", kFreq
			puts Srev, kFreq

		Srev sprintfk "Hack Mix: %f", kDryWet
			puts Srev, kDryWet+1
	endif

	kFreq port kFreq, 0.05

    if (kWave < 1) then  ; Sine
    	aMod lfo 1, kFreq, 0
    elseif (kWave >= 1 && kWave < 2) then ; Tri
        aMod lfo 1, kFreq, 1
    elseif (kWave >= 2 && kWave < 3) then ; Pulse
        aMod lfo 1, kFreq, 3
    elseif (kWave >= 3 && kWave < 4) then ; Saw
        aMod lfo 1, kFreq, 4
    elseif (kWave >= 4 && kWave < 5) then ; RevSaw
        aMod lfo 1, kFreq, 5
    endif


	aMod butlp aMod, 300

	aHack = ain * (aMod)

	aOut ntrpol ain, aHack, kDryWet

	xout aOut

endop

;*********************************************************************
; Hack - 1 in / 2 out
;*********************************************************************

opcode Hack, aa, akkk

	ain, kFreq, kDryWet, kWave  xin

	aOutL Hack ain, kFreq, kDryWet, kWave
	aOutR Hack ain, kFreq, kDryWet, kWave

	xout aOutL, aOutR

endop

;*********************************************************************
; Hack - 2 in / 2 out
;*********************************************************************

opcode Hack, aa, aakkk

	ainL, ainR, kFreq, kDryWet, kWave  xin

	aOutL Hack ainL, kFreq, kDryWet, kWave
	aOutR Hack ainR, kFreq, kDryWet, kWave

	xout aOutL, aOutR

endop
