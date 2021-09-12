/********************************************************

	Repeater.udo
	Authors: Alex Hofmann and Bernt Isak Wærstad

	Arguments: Range, Repeat_time, On_off [, MixMode]
    Defaults:  0, 0.3, 0, 0

	Range: 0 - 1 (short or long repeat time)
	Repeat time: 0.01s - 0.2s (short) or 0.5s - 6s
	On/off: 0 - 1 (on above 0.5, off below)
	MixMode: 
		0: Insert
		1: Mix

	Description:
	Repeater effect with short and long range

********************************************************/

	; Default argument values
	#define Range #0# 
	#define Repeat_time #0.3#
	#define On_Off #0#
	#define MixMode #0#

	; Toggle printing on/off
	#define PRINT #0#

	; Max and minimum values
	#define MAX_S_DLY #0.2#
	#define MIN_S_DLY #0.05#	
	#define MAX_L_DLY #6#
	#define MIN_L_DLY #0.2#

;*********************************************************************
; Repeater - 1 in / 1 out
;*********************************************************************

opcode Repeater, a, akkkO

	ain, kRange, kRepeatTime, kOnOff, kMixMode xin

	kfeed init 1
    kRepeat init 0
    aRepeat init 0
    aout init 0

    ; ******************************
  	; Controller value scalings
  	; ******************************

    if kRange == 0 then 
		kRepeatTime scale kRepeatTime, $MAX_S_DLY, $MIN_S_DLY
		kRepeatTime limit kRepeatTime, $MIN_S_DLY, $MAX_S_DLY		; Make sure range value doesnt exceed delayline length
	else
		kRepeatTime scale kRepeatTime, $MAX_L_DLY, $MIN_L_DLY
		kRepeatTime limit kRepeatTime, $MIN_L_DLY, $MAX_L_DLY		; Make sure range value doesnt exceed delayline length
	endif

	if $PRINT == 1 then
		Sonoff sprintfk "Repeat on/off: %d", kOnOff
			puts Sonoff, kOnOff + 1
		Srange sprintfk "Repeat long range: %d", kRange
			puts Srange, kRange + 1
		Scut sprintfk "Repeat time: %f", kRepeatTime
			puts Scut, kRepeatTime+1
	endif

    if changed(kOnOff) == 1 && (kOnOff == 1) then 
        kRepeat = 1
    endif
    kRepeatOff vdel_k kRepeat, kRepeatTime, $MAX_L_DLY
    if changed(kRepeatOff) == 1 then 
        kRepeat = 0
    endif

    aRepeatTime interp kRepeatTime
	aRepeatTime butlp aRepeatTime, 10
    kOnOff port kOnOff, 0.0001

    aInput = (ain * (1-kOnOff)) + (aRepeat * kOnOff)
    aRepeat vdelayx aInput, aRepeatTime, $MAX_L_DLY, 1024

    if kMixMode == 0 then 
        aout = (ain * (1-kOnOff)) + (aRepeat * kOnOff)
    else 
        aout = ain + (aRepeat * kOnOff)
    endif

    xout aout

endop

;*********************************************************************
; Repeater - 1 in / 2 out
;*********************************************************************

opcode Repeater, aa, akkkk
	ain, kRange, kRepeatTime, kOnOff, kMixMode xin

	aoutL Repeater ain, kRange, kRepeatTime, kOnOff, kMixMode
	aoutR Repeater ain, kRange, kRepeatTime, kOnOff, kMixMode

	xout aoutL, aoutR
endop


;*********************************************************************
; Repeater - 2 in / 2 out
;*********************************************************************

opcode Repeater, aa, aakkkk
	ainL, ainR, kRange, kRepeatTime, kOnOff, kMixMode xin

	aoutL Repeater ainL, kRange, kRepeatTime, kOnOff, kMixMode
	aoutR Repeater ainR, kRange, kRepeatTime, kOnOff, kMixMode

	xout aoutL, aoutR
endop

