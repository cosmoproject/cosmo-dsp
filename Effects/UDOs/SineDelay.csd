
;SinMod Delay

opcode SineDelay, a, akkk

	ain, kRange, kFeedback, kDryWet xin

	kRange scale kRange, 0.5, 0.001
	Srev sprintfk "SindeDelay range: %f", kRange
		puts Srev, kRange+1 

	kFeedback scale kFeedback, 1, 0
	Sfb sprintfk "SineDelay Feedback: %f", kFeedback
		puts Sfb, kFeedback+1  

	kDryWet scale kDryWet, 1, 0
	Srev sprintfk "SineDelay Mix: %f", kDryWet
		puts Srev, kDryWet+1 

	kFeedback init 0.2
	kDryWet init 0.5

	aWet init 0.5

	aSinL poscil kRange, 0.2
	aDelayL delayr 1					;  a delayline, with 1 second maximum delay-time is initialised
	aWetL deltapi aSinL+0.5		; data at a flexible position is read from the delayline 
		 delayw ain+(aWetL*kFeedback)	; the "g.a.Bus" is written to the delayline, - to get a feedbackdelay, the delaysignal (aWet) is also added, but scaled by kFeedback 	
	aOutLtemp = (ain + aWetL); * 0.5	

	xout aOutLtemp
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
