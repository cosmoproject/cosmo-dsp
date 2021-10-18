/********************************************************

	SSB.udo
	Author: Bernt Isak Wærstad

	Arguments: ModFreq, ModFreqMulti, Balance, Mix 
    Defaults:  

	ModFreq: 0.05Hz - 30Hz 
	ModFreqMulti: 1 - 100 (frequency multiplier)
    Balance: 0 - 1 (mix between lower and upper band)
	Dry/wet mix: 0% - 100%

	Description:
	Single sideband modulator

********************************************************/

	; Default argument values
	#define ModFreq #0.25#
	#define ModFreqMulti #0#
	#define Balance #0.5#
    #define Mix #0.5#

	; Toggle printing on/off
	#define PRINT #0#

	; Max and minimum values
	#define MAX_MOD_FREQ #30#
	#define MIN_MOD_FREQ #0.05#
	#define MAX_MOD_FREQ_MULTI #100#
	#define MIN_MOD_FREQ_MULTI #1#
	

;*********************************************************************
; SSB - 1 in / 1 out
;*********************************************************************

opcode SSB,a,akkkk

	aIn , kmodFreq, kmodFreqMulti, kbalance, kmix  xin

    kmodFreq expcurve kmodFreq, 30
	kmodFreq scale kmodFreq, $MAX_MOD_FREQ, $MIN_MOD_FREQ
	kmodFreqMulti scale kmodFreqMulti, $MAX_MOD_FREQ_MULTI, $MIN_MOD_FREQ_MULTI
	kmodFreq *= kmodFreqMulti

    kbalance limit kbalance, 0, 1
	kmix limit kmix, 0, 1

	if $PRINT = 1 then 
		Smodfreq sprintfk "SSB frequency %f", kmodFreq
			puts Smodfreq, kmodFreq +1
        Sbalance sprintfk "SSB sideband balance %f", kbalance
            puts Sbalance, kbalance+1
		Sssbmix sprintfk "SSB mix %f", kmix
			puts Sssbmix, kmix + 1 
	endif

    kmodFreq port kmodFreq, 0.1

	iSine		ftgen	0, 0, 65536, 10, 1	; sine

	; single sideband modulation
    aSin, aCos	hilbert	aIn	
    aModSin		oscil	1, kmodFreq, iSine, 0.0
    aModCos		oscil	1, kmodFreq, iSine, 0.25
    aMod1		= aSin * aModCos
    aMod2		= aCos * aModSin
    aSum		= aMod1 + aMod2
    aDiff		= aMod1 - aMod2

    aAM = (aSum * sqrt(1-kbalance)) + (aDiff*sqrt(kbalance))

	aOut ntrpol aIn, aAM, kmix
		
	xout aOut 

endop

;*********************************************************************
; SSB - 1 in / 2 out
;*********************************************************************

opcode SSB,aa,akkkk

	aIn, kmodFreq, kmodFreqMulti, kbalance, kmix  xin

	aL SSB aIn, kmodFreq, kmodFreqMulti, kbalance, kmix  
	aR SSB aIn, kmodFreq, kmodFreqMulti, kbalance, kmix  

	xout aL, aR 

endop

;*********************************************************************
; SSB - 1 in / 2 out
;*********************************************************************

opcode SSB,aa,aakkkk

	aInL,aInR, kmodFreq, kmodFreqMulti, kbalance, kmix  xin

	aL SSB aInL, kmodFreq, kmodFreqMulti, kbalance, kmix  
	aR SSB aInR, kmodFreq, kmodFreqMulti, kbalance, kmix  

	xout aL, aR 
endop
