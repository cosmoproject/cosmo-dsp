/********************************************************

	PitchShifter.csd
	Author: Alex Hofmann, 
	COSMO UDO adaptation: Bernt Isak Wærstad

	Arguments: Semitones, Dry/wet mix [, Slide, Formant, Delay, Feedback]
    Defaults:  1, 0, 0 [, 0, 0, 0, 0]

	Semitones (-/+ 1 octaves): -12 - +12 semitones
	Dry/wet mix: 0% - 100%

	[Optional]
	Slide: 0.01s - 1.0s (portamento)
	Formant: 0 - off, 1 - try keep formant 
	Delay: 0 - 1000ms
	Feedback: 0% - 100%

	Description
	Pitch shifter using sliding phase vocoder. 
	Effect is bypassed if dry/wet is close to 0 to save CPU

********************************************************/

	; Default argument values
	#define Semitones #1# ; +12
	#define DryWet_Mix #0.5#
	#define Slide #0.01#

	; Toggle printing on/off
	#define PRINT #0#

	; Max and minimum values
	#define MAX_SEMI #12#
	#define MIN_SEMI #-12#
	#define MAX_SLIDE #0.5#
	#define MIN_SLIDE #0.01#
	#define MAX_DLY #1000#
	#define MIN_DLY #0#
	#define MAX_FEED #1#
	#define FFT_SIZE #2048#
	#define WIN_SIZE #2048#
	#define OVERLAP #512#

;*********************************************************************
; PitchShifter - 1 in / 1 out
;*********************************************************************

opcode PitchShifter, a, akkOOOO

	ain, kSemitones, kDryWet, kSlide, kFormant, kDelay, kFeedback xin

	kDryWet init $DryWet_Mix
	kSemiNotes init $Semitones
	kSlide init $Slide
	kFormant init 0

	aPitchS	init	0	;INITIALIZE aPitchS FOR FIRST PERFORMANCE TIME PASS
  
    ; ******************************
  	; Controller value scalings
  	; ******************************
	kSemitones scale kSemitones, $MAX_SEMI, $MIN_SEMI
	kSemitones = ceil(kSemitones)

	kSlide scale kSlide, $MAX_SLIDE, 0
	kSlide limit kSlide, 0, $MAX_SLIDE

	kFeedback scale kFeedback, $MAX_FEED, 0
	kFeedback limit kFeedback, 0, $MAX_FEED

	kDelay scale kDelay, $MAX_DLY, $MIN_DLY 
	kDelay limit kDelay, $MIN_DLY, $MAX_DLY

	kDryWet scale kDryWet, 1, 0
	kDryWet limit kDryWet, 0, 1

	if ($PRINT == 1) then 
		Semi sprintfk "PitchShifter semitones: %d", kSemitones
			puts Semi, kSemitones + $MAX_SEMI + 1

		Sfeed sprintfk "PitchShifter feedback: %d", (kFeedback * 100)
			puts Sfeed, kFeedback + 1

		Sdelay sprintfk "PitchShifter delay: %dms", kDelay 
			puts Sdelay, kDelay + 1

		Slide sprintfk "PitchShifter slide/portamento: %0.2fs", kSlide 
			puts Slide, kSlide + 1

		Smix sprintfk "PitchShifter Mix: %.2f", kDryWet
			puts Smix, kDryWet+1
	endif

	; To save CPU when bypassed
	if (kDryWet > 0.01) then

		kDelay port kDelay, 0.01
	
		kscal	= 	octave((int(kSemitones)/12))
		kscal portk kscal, kSlide

		fsig1 	pvsanal	ain+(aPitchS*kFeedback), $FFT_SIZE,$OVERLAP,$WIN_SIZE,0		;PHASE VOCODE ANALYSIS
		fsig2 	pvscale	fsig1, kscal, kFormant		;RESCALE PITCH 
		aPitchS	pvsynth	fsig2						;RESYNTHESIZE FROM FSIG 
		aPitchS	vdelay aPitchS, kDelay, $MAX_DLY 	;OPTIONAL DELAY OF PITCHED SIGNAL

		aOut ntrpol ain, aPitchS, kDryWet
	else
		aOut = ain
	endif

	xout aOut

endop


;*********************************************************************
; PitchShifter - 1 in / 2 out
;*********************************************************************

opcode PitchShifter, aa, akkOOOO

	ain, kSemitones, kDryWet, kSlide, kFormant, kDelay, kFeedback xin

	aL PitchShifter ain, kSemitones, kDryWet, kSlide, kFormant, kDelay, kFeedback
	aR PitchShifter ain, kSemitones, kDryWet, kSlide, kFormant, kDelay, kFeedback

	xout aL, aR
endop

;*********************************************************************
; PitchShifter - 2 in / 2 out
;*********************************************************************

opcode PitchShifter, aa, aakkOOOO

	ainL, ainR, kSemitones, kDryWet, kSlide, kFormant, kDelay, kFeedback xin

	aL PitchShifter ainL, kSemitones, kDryWet, kSlide, kFormant, kDelay, kFeedback
	aR PitchShifter ainR, kSemitones, kDryWet, kSlide, kFormant, kDelay, kFeedback

	xout aL, aR
endop
