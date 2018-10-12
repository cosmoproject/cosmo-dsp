/********************************************************

	RandDelay.udo
	Author: Alex Hofmann
	COSMO UDO adaptation: Bernt Isak Wærstad

	Arguments: Range, Speed, Feedback, Dry/wet mix, [Stereo Mode 1i/1o only]
    Defaults:  0.5, 0.1, 0.2, 0.5 [, 0]

	Range: 0.001 - 15
	Speed: 0.001 - 2
	Feedback: 0% - 100%
	Dry/wet mix: 0% - 100%

	Description:
	Delay with random delay times

********************************************************/

	; Default argument values
	#define Range #0.5#
	#define Speed #0.1#
	#define Feedback #0.2#
	#define DryWet_Mix #0.5#

	; Toggle printing on/off
	#define PRINT #0#

	; Max and minimum values
	#define MAX_RANGE #15#
	#define MIN_RANGE #0.001#

	#define MAX_SPEED #2#
	#define MIN_SPEED #0.001#

;*********************************************************************
; RandDelay - 1 in / 1 out
;*********************************************************************

opcode RandDelay, a, akkkkk

	ain, kRange, kSpeed, kFeedback, kDryWet, kStereoMode xin

	kRange init $Range
	kSpeed init $Speed
	;kModIdx init $ModulationIdx
	kFeedback init $Feedback
	kDryWet init $DryWet_Mix
	aWet init 0

	kRange expcurve kRange, $MIN_RANGE
	kRange scale kRange, $MAX_RANGE, $MIN_RANGE
	kSpeed scale kSpeed, $MAX_SPEED, $MIN_SPEED
	kFeedback scale kFeedback, 1, 0
	kDryWet scale kDryWet, 1, 0

	if $PRINT == 1 then
		Sr sprintfk "RandDly Range: %f", kRange
			puts Sr, kRange+1

		Ss sprintfk "RandDly Speed: %f", kSpeed
			puts Ss, kSpeed+1

		Sfb sprintfk "RandDly Feedback: %f", kFeedback
			puts Sfb, kFeedback+1

		Smix sprintfk "RandDly Mix: %f", kDryWet
			puts Smix, kDryWet+1
	endif


	aPulse lfo 0.5, 3, 1
	aPulse butlp aPulse, 100

	aInSig = (ain*aPulse)

	if kStereoMode == 0 then
		kRangeMod = 1
		kSpeedMod = 1
		kSeed = 42
	else
		kRangeMod = 1.05
		kSpeedMod = 0.95
		kSeed = 86400
	endif

	aRandomTimes randh kRange*kRangeMod, kSpeed*kSpeedMod, i(kSeed), 0, 0.401
	aRandomTimes butlp aRandomTimes, 2

	aDelay delayr $MAX_RANGE			;  a delayline, with $MAX_RANGE second maximum delay-time is initialised
	aWet deltap3 aRandomTimes			; data at a flexible position is read from the delayline
		delayw aInSig+(aWet*kFeedback)	; the audio-in is written to the delayline, - to get a feedbackdelay, the delaysignal (aWet) is also added, but scaled by kFeedback

	aOut ntrpol ain, aWet*2, kDryWet

	xout aOut

endop

;*********************************************************************
; RandDelay - 1 in / 2 out
;*********************************************************************

opcode RandDelay, aa, akkkk

	ain, kRange, kSpeed, kFeedback, kDryWet xin

	aL RandDelay ain, kRange, kSpeed, kFeedback, kDryWet, 0
	aR RandDelay ain, kRange, kSpeed, kFeedback, kDryWet, 1

	xout aL, aR

endop

;*********************************************************************
; RandDelay - 1 in / 2 out
;*********************************************************************

opcode RandDelay, aa, aakkkk

	ainL, ainR, kRange, kSpeed, kFeedback, kDryWet xin

	aL RandDelay ainL, kRange, kSpeed, kFeedback, kDryWet, 0
	aR RandDelay ainR, kRange, kSpeed, kFeedback, kDryWet, 1

	xout aL, aR

endop
