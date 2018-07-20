/********************************************************

	PitchShifter.csd
	Author: Alex Hofmann, 
	COSMO UDO adaptation: Bernt Isak Wærstad

	Arguments: Semitones, Stereo mode, Dry/wet mix 
    Defaults:  1, 0.5, 0

	Semitones (-/+ 1 octaves): -12 - +12 semitones

	Mode:
		0: PVS pitchshifter
		1: Delay-line pitchshifter

	Stereo mode: 0 - 1 (on when 1, otherwise off)
	Dry/wet mix: 0% - 100%

	Description
	Pitch shifter with the range from -1 octave to +1 octave. Can
	be summed to mono to save CPU. Effect is bypassed if dry/wet
	is set to 0 to save CPU

********************************************************/

opcode PitchShifter, a, akkkkk

	ain, kPitch, kFeedback, kDelay, kDryWet, kMode  xin

	; To save CPU when bypassed

	if (kDryWet > 0) then

		if (kMode == 0) then

			setksmps 128

			kSemitones scale kSemitones, 13, -13
			kFeedback scale kFeedback, 0, 1
			kDelay scale kDelay, 0, 2000 

			if ($PRINT == 1) then 
				Semi sprintfk "PitchShifter [PVS] semitones: %d", int(kSemitones)
					puts Semi, kSemitones + 14

				Sfeed sprintfk "PitchShifter [PVS] feedback: %d\%", kFeedback * 100 
					puts Sfeed, kFeedback + 1

				Sdelay sprintfk "PitchShifter [PVS] delay: %d ms", kDelay 
					puts Sdelay, kDelay + 1
			endif

			kSemitones port kSemitones, 0.01
			kDelay port kDelay, 0.01

			kDryWet init 0.5
			kSemiNotes init -12

			kscal	= 		octave((int(kSemitones)/12))
			;kFeedback =		0.0
			aOct	init	0									;INITIALIZE aOut FOR FIRST PERFORMANCE TIME PASS

			ainMono = (ainL + ainR) * 0.5
			fsig1 	pvsanal	ainMono+(aOct*kFeedback), 2048,512,2048,0					;PHASE VOCODE ANALYSE LEFT CHANNEL
			fsig2 	pvscale	fsig1, kscal							;RESCALE PITCH (LEFT CHANNEL)
			aOct 	pvsynth	fsig2								;RESYNTHESIZE FROM FSIG (LEFT CHANNEL)
			aOct 	delay aOct, kDelay * sr ; CHECK THIS ARGUMENT


		endif 

		if (kMode == 1) then 

	        setksmps  1                   ; kr=sr 
			
			;asig,kpitch,kfdb,kdel,iwin  xin 

			kPitch scale kPitch, 0, 12
			kFeedback scale kFeedback, 0, 1
			kDelay scale kDelay, 0, 2000 

			if ($PRINT == 1) then 
				Spitch sprintfk "PitchShifter [Delay] shift ratio: %f", kPitch
					puts Spitch, kPitch+ 1

				Sfeed sprintfk "PitchShifter [Delay] feedback: %d\%", kFeedback * 100 
					puts Sfeed, kFeedback + 1

				Sdelay sprintfk "PitchShifter [Delay] delay: %d ms", kDelay 
					puts Sdelay, kDelay + 1
			endif

			kSemitones port kSemitones, 0.01
			kDelay port kDelay, 0.01

			iwin = 0 ; NEED TO GENERATE A TRIANGLE WINDOW FUNCTION HERE

			kDelRate = (kPitch-1)/kDelay 

			avDel   phasor -kDelRate               ; 1 to 0 
			avDel2  phasor -kDelRate, 0.5          ; 1/2 buffer offset  
			aFade  tablei avDel, iwin, 1, 0, 1     ; crossfade windows 
			aFade2 tablei avDel2,iwin, 1, 0, 1 

			aDump  delayr 1                  
			aTap1  deltapi avDel*kDelay     ; variable delay taps 
			aTap2  deltapi avDel2*kDelay 
			aOct   =   aTap1*aFade + aTap2*aFade2  ; fade in/out the delay taps 
			       delayw  ain+aOct*kFeedback          ; in+feedback signals 
			 
		endif

		kDryWet scale kDryWet, 1, 0

		if ($PRINT == 1) then
			Smix sprintfk "PitchShifter Mix: %f", kDryWet
				puts Smix, kDryWet+1
		endif

		aOut ntrpol ain, aOct, kDryWet

	else
		aOut = ain
	endif

	xout aOut

endop


	Sstereo sprintfk "PitchShifter stereo on/off: %d", kStereoMode
		puts Sstereo, kStereoMode + 1
