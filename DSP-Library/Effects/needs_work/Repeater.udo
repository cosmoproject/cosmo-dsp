/********************************************************

	Repeater.udo
	Authors: Alex Hofmann and Bernt Isak Wærstad

	Arguments: Range, Repeat_time, On_off, MixMode
    Defaults:  0, 0.8, 0

	Range: 0 - 1 (short or long repeat time)
	Repeat time: 0.1s - 0.5s (short) or 0.1s - 6s
	On/off: 0 - 1 (on above 0.5, off below)
	MixMode: 
		0: Mix, kill input 
		1: Insert, kill input
		2: Mix, input open
		3: Insert, input open

	Description:
	Repeater effect with short and long range

********************************************************/

	; Default argument values
	#define Range #0# 
	#define Repeat_time #0.8#
	#define On_Off #0#
	#define MixMode #0#
	#define Mode #0#

	; Toggle printing on/off
	#define PRINT #0#

	; Max and minimum values
	#define MAX_S_DLY #0.5#
	#define MIN_S_DLY #0.1#	
	#define MAX_L_DLY #6#
	#define MIN_L_DLY #0.1#

;*********************************************************************
; Repeater - 1 in / 1 out
;*********************************************************************

opcode Repeater, a, akkkk

	ain, kRange, kRepeatTime, kOnOff, kMixMode xin

	kInputVol init 1
	kFeedback = 1
	aFeed = 0

	kDryMix = (kMixMode == 0 || kMixMode == 2) ? 1 : 1-kOnOff

  	; ******************************
  	; Controller value scalings
  	; ******************************

	kOnOff = kOnOff > 0.5 ? 1 : 0 
	kRange = kRange > 0.5 ? 1 : 0

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

	aRepeatTime interp kRepeatTime
	aRepeatTime butlp aRepeatTime, 10

	aWet = 0

	kInputVol port kInputVol, 0.01
	kFeedback port kFeedback, 0.01


	; STRAIGHT REPEAT

	if kMixMode == 0 || kMixMode == 1 then 
		if kOnOff == 0 then
			kFeedback = 0
			kInputVol = 1
		else
			kFeedback = 1
			kInputVol = 0
		endif
	else 
		if kOnOff == 0 then
			kFeedback = 0
			kInputVol = 0
		else
			kFeedback = 1
			kInputVol = 1
		endif
	endif

	aDelay delayr 6.5			
	aWet deltapi aRepeatTime		
			delayw (ain*kInputVol)+(aWet*kFeedback)	
	aRepeat = aWet

	aOut = (ain * kDryMix) + (aRepeat * kOnOff)

	xout aOut

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


