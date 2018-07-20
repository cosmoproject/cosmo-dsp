/********************************************************

	SineDelay.udo
	Author: Alex Hofmann
	COSMO UDO adaptation: Bernt Isak Wærstad

	Arguments: Range, Frequency, ModulationIdx, Feedback, Dry/wet mix
    Defaults:  0.8, 0.3, 0.1, 0.3, 0.5

	Range: 0.001s - 0.5s
	Frequency: 0.1Hz - 10Hz
	ModulationIdx: 0 - 5 
	Feedback: 0% - 100%
	Dry/wet mix: 0% - 100%

	Description:
	A SinMod Delay

********************************************************/

	; Default argument values
	#define Range #0.8# 
	#define Frequency #0.3#
	#define ModulationIdx #0.1#
	#define Feedback #0.3#
	#define DryWet_Mix #0.5#

	; Toggle printing on/off
	#define PRINT #0#

	; Max and minimum values
	#define MAX_RANGE #0.5#
	#define MIN_RANGE #0.001#	

	#define MAX_FREQ #10#
	#define MIN_FREQ #0.1#	

	#define MAX_MOD #5#

;*********************************************************************
; SineDelay - 1 in / 1 out
;*********************************************************************

opcode SineDelay, a, akkkkk

	ain, kRange, kFrequency, kModIdx, kFeedback, kDryWet xin

	kRange init $Range
	kFrequency init $Frequency
	kModIdx init $ModulationIdx
	kFeedback init $Feedback
	kDryWet init $DryWet_Mix
	aWet init 0.5

	kRange scale kRange, $MAX_RANGE, $MIN_RANGE

	kFrequency expcurve kFrequency, 10
	kFrequency scale kFrequency, $MAX_FREQ, $MIN_FREQ

	kModIdx scale kModIdx, $MAX_MOD, 0

	kFeedback scale kFeedback, 1, 0

	kDryWet scale kDryWet, 1, 0

	if $PRINT == 1 then
		Srange sprintfk "SindeDelay range: %f", kRange
			puts Srange, kRange+1
		Sfreq sprintfk "SineDelay Frequency: %fHz", kFrequency
			puts Sfreq, kFrequency + 1
		Smod sprintfk "SineDelay Modulation Index: %d", kModIdx
			puts Smod, kModIdx + 1
		Sfb sprintfk "SineDelay Feedback: %f", kFeedback
			puts Sfb, kFeedback+1
		Smix sprintfk "SineDelay Mix: %f", kDryWet
			puts Smix, kDryWet+1
	endif 

	kRange port kRange, 0.1
	aRange interp kRange

	kFrequency port kFrequency, 0.1

	; Frequency modulation of the sine controlling the delay time
	kMod oscil kModIdx*kFrequency, kFrequency*kModIdx
	aSin poscil aRange, kFrequency+kMod

	aDelay delayr $MAX_RANGE*2			; a delayline, with $MAX_RANGE*2 second maximum delay-time is initialised
	aWet deltapi aSin+0.5				; data at a flexible position is read from the delayline
		 delayw ain+(aWet*kFeedback)	; the audio in is written to the delayline, - to get a feedbackdelay, the delaysignal (aWet) is also added, but scaled by kFeedback

	aOut ntrpol ain, aWet, kDryWet

	xout aOut
endop

;*********************************************************************
; SineDelay - 1 in / 2 out
;*********************************************************************

opcode SineDelay, aa, akkkkk

	ain, kRange, kFrequency, kModIdx, kFeedback, kDryWet xin

	aoutL SineDelay ain, kRange, kFrequency, kModIdx, kFeedback, kDryWet
	aoutR SineDelay ain, kRange, kFrequency, kModIdx, kFeedback, kDryWet

	xout aoutL, aoutR
endop


;*********************************************************************
; SineDelay - 2 in / 2 out
;*********************************************************************

opcode SineDelay, aa, aakkkkk

	ainL, ainR, kRange, kFrequency, kModIdx, kFeedback, kDryWet xin

	aoutL SineDelay ainL, kRange, kFrequency, kModIdx, kFeedback, kDryWet
	aoutR SineDelay ainR, kRange, kFrequency, kModIdx, kFeedback, kDryWet

	xout aoutL, aoutR
endop


