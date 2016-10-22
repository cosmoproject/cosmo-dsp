

opcode RandDelay, aa, aakkk					 ;  Rand_Delay

	ainL, ainR, kRange, kFeedback, kDryWet xin

	kRange scale kRange, 15, 0.001
	Sfb sprintfk "RandDLy Range: %f", kRange
		puts Sfb, kRange+1  


	kFeedback scale kFeedback, 1, 0
	Sfb sprintfk "RandDLy Feedback: %f", kFeedback
		puts Sfb, kFeedback+1  

	kDryWet scale kDryWet, 1, 0
	Srev sprintfk "RandDly Mix: %f", kDryWet
		puts Srev, kDryWet+1 

	kRange init 5
	kFeedback init 0.2
	kDryWet init 0.5
	aWetL init 0
	aWetR init 0

	if kDryWet > 0.1 then 

		aPulse lfo 0.5, 3, 1
		aPulse butlp aPulse, 100

		aInSigL = (ainL*aPulse)
		aInSigR = (ainR*aPulse)

		aRandomTimesL randh 0.4, 0.2 + kRange, 10, 0, 0.401
		aRandomTimesL butlp aRandomTimesL, 2
		aRandomTimesR randh 0.4, 0.25 + kRange, 0.6, 0, 0.401
		aRandomTimesR butlp aRandomTimesR, 2

		aDelayL delayr 1					;  a delayline, with 1 second maximum delay-time is initialised
		aWetL deltapi aRandomTimesL			; data at a flexible position is read from the delayline 
			 delayw aInSigL+(aWetL*kFeedback)	; the "g.a.Bus" is written to the delayline, - to get a feedbackdelay, the delaysignal (aWet) is also added, but scaled by kFeedback 
		aDelayR delayr 1					;  a delayline, with 1 second maximum delay-time is initialised
		aWetR	deltapi aRandomTimesR		; data at a flexible position is read from the delayline 
			  delayw aInSigR+(aWetR*kFeedback)	; the "g.a.Bus" is written to the delayline, - to get a feedbackdelay, the delaysignal (aWet) is also added, but scaled by kFeedback 

	else
		aWetL = 0
		aWetR = 0
	endif 
	
	aOutL ntrpol ainL, aWetL*2, kDryWet
	aOutR ntrpol ainR, aWetR*2, kDryWet


	xout aOutL, aOutR

endop

opcode RandDelay, aa, aakk

	ainL, ainR, kRange, kFeedback xin

	aOutL, aOutR RandDelay ainL, ainR, kRange, kFeedback, 0.5

	xout aOutL, aOutR

endop

opcode RandDelay, aa, aak

	ainL, ainR, kRange xin

	aOutL, aOutR RandDelay ainL, ainR, kRange, 0.2, 0.5

	xout aOutL, aOutR

endop

opcode RandDelay, aa, aa

	ainL, ainR xin

	aOutL, aOutR RandDelay ainL, ainR, 0.5, 0.2, 0.5

	xout aOutL, aOutR

endop
