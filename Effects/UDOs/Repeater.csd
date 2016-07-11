
opcode Repeater, aa, aakk

	ainL, ainR, kRange, kOnOff xin

	kRange scale kRange, 0.5, 0.1
	Scut sprintfk "Repeat range: %f", kRange	
		puts Scut, kRange+1

	;kRange portk kRange, 0.02
	aRange interp kRange
	aRange butlp aRange, 10

	kFeedback = 1
	aWetL = 0.0
	aWetR = 0.0

	aDelayL delayr 0.55					;  a delayline, with 1 second maximum delay-time is initialised
	aWetL deltapi aRange		; data at a flexible position is read from the delayline 
		delayw gaOutL+(aWetL*kFeedback)
		; delayw 	aDlInL	; the "g.a.Bus" is written to the delayline, - to get a feedbackdelay, the delaysignal (aWet) is also added, but scaled by kFeedback 
	aDelayR delayr 0.55			;  a delayline, with 1 second maximum delay-time is initialised
	aWetR	deltapi aRange				; data at a flexible position is read from the delayline 
		  delayw gaOutR+(aWetR*kFeedback)	; the "g.a.Bus" is written to the delayline, - to get a feedbackdelay, the delaysignal (aWet) is also added, but scaled by kFeedback 
	aOutLtemp = aWetL
	aOutRtemp = aWetR

	aOutL, aOutR FadeSwitch ainL, ainR, aOutLtemp, aOutRtemp, 0.2, kOnOff

	xout aOutL, aOutR

endop



opcode RepeaterLong, aa, aakk				 ; Repeat Long

	ainL, ainR, kRange, kOnOff xin

	kRange scale kRange, 6, 0.001
	Scut sprintfk "Repeat range: %f", kRange	
		puts Scut, kRange+1

	;kRange portk kRange, 0.02
	aRange interp kRange
	aRange butlp aRange, 200

	kFeedback = 1

	aDelayL delayr 6					;  a delayline, with 1 second maximum delay-time is initialised
	aWetL deltapi aRange		; data at a flexible position is read from the delayline 
		 delayw gaOutL+(aWetL*kFeedback)	; the "g.a.Bus" is written to the delayline, - to get a feedbackdelay, the delaysignal (aWet) is also added, but scaled by kFeedback 
	aDelayR delayr 6				;  a delayline, with 1 second maximum delay-time is initialised
	aWetR	deltapi aRange				; data at a flexible position is read from the delayline 
		  delayw gaOutR+(aWetR*kFeedback)	; the "g.a.Bus" is written to the delayline, - to get a feedbackdelay, the delaysignal (aWet) is also added, but scaled by kFeedback 
	aEmpty = 0.0

	aWetL, aWetR FadeSwitch aEmpty, aEmpty, aWetL, aWetR, 0.2, kOnOff

	xout ainL + aWetL, ainR + aWetR 

endop 
