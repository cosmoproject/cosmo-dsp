/********************************************************

	Repeater.udo
	Author: Alex Hofmann
	COSMO UDO adaptation: Bernt Isak Wærstad

	Arguments: Range, Repeat time, On_off, MixMode, Mode
    Defaults:  0, 0.8, 0

	Range: 0 - 1 (short or long repeat time)
	Repeat time: 0.1s - 0.5s (short) or 0.1s - 6s
	On/off: 0 - 1 (on above 0.5, off below)
	MixMode: 
		0: Insert, kill input 
		1: Mix, kill input
		2: Insert, input open
		3: Mix, input open
	Mode:
		0: Straight repeater
		1: Glitch stutter
		2: Pitch repeater

	Description:
	Repeater effect with short and long range

********************************************************/

opcode Repeater2, aa, aakkkkk

	ainL, ainR, kRange, kRepeatTime, kOnOff, kMixMode, kMode xin

	kInputVol init 1
	kFeedback = 1
	aFeed = 0

  	; ******************************
  	; Controller value scalings
  	; ******************************

	kOnOff = kOnOff > 0.5 ? 1 : 0 
	Sonoff sprintfk "Repeat on/off: %d", kOnOff
		puts Sonoff, kOnOff + 1

	kRange = kRange > 0.5 ? 1 : 0
	Srange sprintfk "Repeat long range: %d", kRange
		puts Srange, kRange + 1

	if kRange == 0 then 
		kRepeatTime scale kRepeatTime, 0.5, 0.01
		kRepeatTime limit kRepeatTime, 0.01, 0.5		; Make sure range value doesnt exceed delayline length
	else
		kRepeatTime scale kRepeatTime, 6, 0.1
		kRepeatTime limit kRepeatTime, 0.1, 6		; Make sure range value doesnt exceed delayline length
	endif

	Scut sprintfk "Repeat time: %f", kRepeatTime
		puts Scut, kRepeatTime+1

	aRepeatTime interp kRepeatTime
	aRepeatTime butlp aRepeatTime, 10


	aWetL = 0
	aWetR = 0



	kInputVol port kInputVol, 0.01
;	kFeedback port kFeedback, 0.01

	if kMode == 0 then 

		if kMixMode == 0 then 
			if kOnOff == 0 then
				kFeedback = 0
				kInputVol = 1
			else
				kFeedback = 1
				kInputVol = 0
			endif
		endif

		aDelayL delayr 6.5					;  a delayline, with 1 second maximum delay-time is initialised
		aWetL deltapi aRepeatTime		; data at a flexible position is read from the delayline
			 delayw (ainL*kInputVol)+(aWetL*kFeedback)	; the "g.a.Bus" is written to the delayline, - to get a feedbackdelay, the delaysignal (aWet) is also added, but scaled by kFeedback
			; delayw 	aDlInL	; the "g.a.Bus" is written to the delayline, - to get a feedbackdelay, the delaysignal (aWet) is also added, but scaled by kFeedback
		aDelayR delayr 6.5			;  a delayline, with 1 second maximum delay-time is initialised
		aWetR	deltapi aRepeatTime				; data at a flexible position is read from the delayline
			  delayw (ainR*kInputVol)+(aWetR*kFeedback)	; the "g.a.Bus" is written to the delayline, - to get a feedbackdelay, the delaysignal (aWet) is also added, but scaled by kFeedback
		aRepeatL = aWetL
		aRepeatR = aWetR
/*
		if kMixMode == 0 && kOnOff == 1 then
			kInputVol = 0
		elseif kMixMode == 0 && kOnOff == 0 then
			kInputVol = 1
		endif
*/

	elseif kMode == 1 then

		; STUTTER

		if kMixMode == 0 then 
			if kOnOff == 0 then
				kFeedback = 0
				kInputVol = 1
			else
				kFeedback = 1
				kInputVol = 0
			endif
		endif

		kRepeatOn = kOnOff
		kRepeatOff = 0

		kMoveTime = 600
		kHoldTime = 500

		if kRepeatOn == 1 then 
			kRepeatOff delayk kRepeatOff, i(kHoldTime) 

		aDelay deltapi kMoveTime
			delayw aIn + (aDelay * kFeedback)


		kInputVol = 0.97


	elseif kMode == 2 then

	endif



	;aOutL, aOutR FadeSwitch ainL, ainR, aOutLtemp, aOutRtemp, 0.5, kOnOff
	aOutL = ainL + (aRepeatL * kOnOff)
	aOutR = ainR + (aRepeatR * kOnOff)

	xout aOutL, aOutR

endop
