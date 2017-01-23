/********************************************************

	Repeater.csd
	Author: Alex Hofmann
	COSMO UDO adaptation: Bernt Isak Wærstad

	Arguments: Range, Repeat time, On/off
    Defaults:  0, 0.8, 0

	Range: 0 - 1 (short or long repeat time)
	Repeat time: 0.1s - 0.5s (short) or  
	On/off: 0 - 1 (on above 0.5, off below)

	Description:
	Repeater effect with short and long range

********************************************************/

opcode Repeater, aa, aakkk

	ainL, ainR, kRepeatTime, kRange, kOnOff xin

	kOnOff = kOnOff > 0.5 ? 1 : 0 
	Sonoff sprintfk "Repeat on/off: %d", kOnOff
		puts Sonoff, kOnOff + 1

	kRange = kRange > 0.5 ? 1 : 0
	Srange sprintfk "Repeat long range: %d", kRange
		puts Srange, kRange + 1

	if kRange == 0 then 
		kRepeatTime scale kRepeatTime, 0.5, 0.01
		kRepeatTime limit kRepeatTime, 0.01, 0.5		; Make sure range value doesnt exceed delayline length
		Scut sprintfk "Repeat time: %f", kRepeatTime
			puts Scut, kRepeatTime+1
	else
		kRepeatTime scale kRepeatTime, 6, 0.1
		kRepeatTime limit kRepeatTime, 0.1, 6		; Make sure range value doesnt exceed delayline length
		Scut sprintfk "Repeat time: %f", kRepeatTime
			puts Scut, kRepeatTime+1
	endif


	aRepeatTime interp kRepeatTime
	aRepeatTime butlp aRepeatTime, 10

	kFeedback = 1
	aWetL = 0.0
	aWetR = 0.0

	kInputVol init 1
	if kOnOff < 1 then
		kFeedback = 0
		kInputVol = 0
	else
		kInputVol = 1
		kFeedback = 1
	endif

	kInputVol port kInputVol, 0.01
	kFeedback port kFeedback, 0.01

	aDelayL delayr 6.5					;  a delayline, with 1 second maximum delay-time is initialised
	aWetL deltapi aRepeatTime		; data at a flexible position is read from the delayline
		 delayw (ainL*kInputVol)+(aWetL*kFeedback)	; the "g.a.Bus" is written to the delayline, - to get a feedbackdelay, the delaysignal (aWet) is also added, but scaled by kFeedback
		; delayw 	aDlInL	; the "g.a.Bus" is written to the delayline, - to get a feedbackdelay, the delaysignal (aWet) is also added, but scaled by kFeedback
	aDelayR delayr 6.5			;  a delayline, with 1 second maximum delay-time is initialised
	aWetR	deltapi aRepeatTime				; data at a flexible position is read from the delayline
		  delayw (ainR*kInputVol)+(aWetR*kFeedback)	; the "g.a.Bus" is written to the delayline, - to get a feedbackdelay, the delaysignal (aWet) is also added, but scaled by kFeedback
	aOutLtemp = aWetL
	aOutRtemp = aWetR

	;aOutL, aOutR FadeSwitch ainL, ainR, aOutLtemp, aOutRtemp, 0.5, kOnOff
	aOutL = ainL + aOutLtemp
	aOutR = ainR + aOutRtemp

	xout aOutL, aOutR

endop
