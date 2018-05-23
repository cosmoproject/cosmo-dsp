/********************************************************

	SineDelay.csd
	Author: Alex Hofmann
	COSMO UDO adaptation: Bernt Isak Wærstad

	Arguments: Range, Frequency, Feedback, Dry/wet mix
    Defaults:  0.8, 0.3, 0.5

	Range: 0.001s - 0.5s
	Frequency: 0.1Hz - 10Hz
	Feedback: 0% - 100%
	Dry/wet mix: 0% - 100%

	Description:
	A SinMod Delay

********************************************************/

opcode SineDelay, aa, aakkkk

	ainL, ainR, kRange, kFrequency, kFeedback, kDryWet xin

	aoutL SineDelay ainL, kRange, kFrequency, kFeedback, kDryWet
	aoutR SineDelay ainR, kRange, kFrequency, kFeedback, kDryWet

	xout aoutL, aoutR
endop


opcode SineDelay, a, akkkk

	ain, kRange, kFrequency, kFeedback, kDryWet xin

	kRange scale kRange, 0.5, 0.001
	Srev sprintfk "SindeDelay range: %f", kRange
		puts Srev, kRange+1
	kRange port kRange, 0.1
	aRange interp kRange

	kFrequency expcurve kFrequency, 10
	kFrequency scale kFrequency, 3, 0.1
	Sfreq sprintfk "SineDelay Frequency: %fHz", kFrequency
		puts Sfreq, kFrequency + 1
	kFrequency port kFrequency, 0.1

	kFeedback scale kFeedback, 1, 0
	Sfb sprintfk "SineDelay Feedback: %f", kFeedback
		puts Sfb, kFeedback+1

	kDryWet scale kDryWet, 1, 0
	Srev sprintfk "SineDelay Mix: %f", kDryWet
		puts Srev, kDryWet+1

	kFeedback init 0.2
	kDryWet init 0.5

	aWet init 0.5

	aSinL poscil aRange, kFrequency
	aDelayL delayr 1					;  a delayline, with 1 second maximum delay-time is initialised
	aWetL deltapi aSinL+0.5		; data at a flexible position is read from the delayline
		 delayw ain+(aWetL*kFeedback)	; the "g.a.Bus" is written to the delayline, - to get a feedbackdelay, the delaysignal (aWet) is also added, but scaled by kFeedback

	aOut ntrpol ain, aWetL, kDryWet

	xout aOut
endop


opcode SineDelay, a, akk
	ain, kRange, kFeedback xin

	aOut SineDelay ain, kRange, kFeedback, 0.5

	xout aOut
endop

opcode SineDelay, a, ak
	ain, kRange xin

	aOut SineDelay ain, kRange, 0.2, 0.5

	xout aOut
endop

opcode SineDelay, a, a
	ain xin

	aOut SineDelay ain, 0.5, 0.2, 0.5

	xout aOut
endop