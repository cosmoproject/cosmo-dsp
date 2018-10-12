/********************************************************

	Chorus.udo
	Author: Alex Hofmann
	COSMO UDO adaptation: Bernt Isak Wærstad

	Arguments: Feedback, Dry/wet mix
    Defaults:  0.4, 0.5

	Feedback: 0.001% - 100%
	Dry/wet mix: 0% - 100%

	Description:
	A chorus effect

	Mod argument is there to make a stereo chorus.

********************************************************/

	; Default argument values
	#define Feedback #0.4#
	#define DryWet_Mix #0.5#
	#define Left_Mod #0#
	#define Right_Mod #0.02#

	; Toggle printing on/off
	#define PRINT #0#

	; Max and minimum values
	#define MAX_RESO #1.25#
	#define MAX_DIST #1#

;*********************************************************************
; Chorus - 1 in / 1 out
;*********************************************************************

opcode Chorus, a, akkO
	ain, kFeedback, kDryWet, kMod xin

	kFeedback scale kFeedback, 1, 0.0001
	kDryWet scale kDryWet, 1, 0

	if ($PRINT == 1) then
		Srev sprintfk "Chorus feedback: %f", kFeedback
			puts Srev, kFeedback+1

		Srev sprintfk "Chorus Mix: %f", kDryWet
			puts Srev, kDryWet+1
	endif

	kDryWet init 0.5
	kFeedback init 0.5

	aWet init 0.0

	aSin poscil 0.001, 3

	aDelay delayr 5.25					;  a delayline, with 1 second maximum delay-time is initialised
	aWet deltapi aSin+kMod+(0.1/2)		; data at a flexible position is read from the
		 delayw ain+(aWet*kFeedback)	; the "g.a.Bus" is written to the delayline, - to get a feedbackdelay, the delaysignal (aWet) is also added, but scaled by kFeedback

/*
	aDelayR delayr 5.25					;  a delayline, with 1 second maximum delay-time is initialised
	;aWetR	deltapi aSinR+0.22+kgDelTim
	aWetR	deltapi aSinR+0.02+(0.1/2)				; data at a flexible position is read from the delayline
		  delayw ainR+(aWetR*kFeedback)	; the "g.a.Bus" is written to the delayline, - to get a feedbackdelay, the delaysignal (aWet) is also added, but scaled by kFeedback
*/
	aOut ntrpol ain, aWet, kDryWet

xout aOut
endop

;*********************************************************************
; Chorus - 1 in / 2 out
;*********************************************************************


opcode Chorus, aa, akk
	ain, kFeedback, kDryWet xin

	aOutL Chorus ain, kFeedback, kDryWet, $Left_Mod
	aOutR Chorus ain, kFeedback, kDryWet, $Right_Mod

	xout aOutL, aOutR
endop

;*********************************************************************
; Chorus - 2 in / 2 out
;*********************************************************************


opcode Chorus, aa, aakk
	ainL, ainR, kFeedback, kDryWet xin

	aOutL Chorus ainL, kFeedback, kDryWet, $Left_Mod
	aOutR Chorus ainR, kFeedback, kDryWet, $Right_Mod

	xout aOutL, aOutR
endop
