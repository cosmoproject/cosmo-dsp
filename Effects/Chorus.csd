/********************************************************

	Chorus.csd
	Author: Alex Hofmann
	COSMO UDO adaptation: Bernt Isak Wærstad

	Arguments: Feedback, Dry/wet mix
    Defaults:  0.4, 0.5
	A chorus effect

********************************************************/

opcode Chorus, aa, aakk
	ainL, ainR, kFeedback, kDryWet xin

	kFeedback scale kFeedback, 1, 0.0001
	Srev sprintfk "Chorus feedback: %f", kFeedback
		puts Srev, kFeedback+1


	kDryWet scale kDryWet, 1, 0
	Srev sprintfk "Chorus Mix: %f", kDryWet
		puts Srev, kDryWet+1

	kDryWet init 0.5
	kFeedback init 0.5

	aWetL init 0.0
	aWetR init 0.0

	aSinL poscil 0.001, 3
	aSinR poscil 0.001, 1

	aDelayL delayr 5.25					;  a delayline, with 1 second maximum delay-time is initialised
	aWetL deltapi aSinL+(0.1/2)		; data at a flexible position is read from the
		 delayw ainL+(aWetL*kFeedback)	; the "g.a.Bus" is written to the delayline, - to get a feedbackdelay, the delaysignal (aWet) is also added, but scaled by kFeedback

	aDelayR delayr 5.25					;  a delayline, with 1 second maximum delay-time is initialised
	;aWetR	deltapi aSinR+0.22+kgDelTim
	aWetR	deltapi aSinR+0.02+(0.1/2)				; data at a flexible position is read from the delayline
		  delayw ainR+(aWetR*kFeedback)	; the "g.a.Bus" is written to the delayline, - to get a feedbackdelay, the delaysignal (aWet) is also added, but scaled by kFeedback

	aOutL ntrpol ainL, aWetL, kDryWet
	aOutR ntrpol ainR, aWetR, kDryWet

xout aOutL, aOutR
endop

opcode Chorus, aa, aak
	ainL, ainR, kFeedback xin

	aOutL, aOutR Chorus ainL, ainR, kFeedback, 0.5

	xout aOutL, aOutR
endop

opcode Chorus, aa, aa
	ainL, ainR xin

	aOutL, aOutR Chorus ainL, ainR, 0.5, 0.5

	xout aOutL, aOutR
endop
