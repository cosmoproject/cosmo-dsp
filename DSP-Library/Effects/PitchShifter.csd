/********************************************************

	PitchShifter.csd
	Author: Alex Hofmann
	COSMO UDO adaptation: Bernt Isak Wærstad

	Arguments: Semitones, Stereo mode, Dry/wet mix 
    Defaults:  1, 0.5, 0

	Semitones (-/+ 1 octaves): -12 - +12 semitones
	Stereo mode: 0 - 1 (on when 1, otherwise off)
	Dry/wet mix: 0% - 100%

	Description
	Pitch shifter with the range from -1 octave to +1 octave. Can
	be summed to mono to save CPU. Effect is bypassed if dry/wet
	is below 10% to save CPU

********************************************************/

opcode PitchShifter, aa, aakkk

	ainL, ainR, kSemitones, kStereoMode, kDryWet  xin

	kSemitones scale kSemitones, 13, -13
	Srev sprintfk "PitchShifter semitones: %d", int(kSemitones)
		puts Srev, kSemitones + 14
	kSemitones port kSemitones, 0.01

	kDryWet scale kDryWet, 1, 0
	Srev sprintfk "PitchShifter Mix: %f", kDryWet
		puts Srev, kDryWet+1

	Sstereo sprintfk "PitchShifter stereo on/off: %d", kStereoMode
		puts Sstereo, kStereoMode + 1

	if (kDryWet > 0.1) then

		kDryWet init 0.5
		kSemiNotes init -12

		kscal	= 		octave((int(kSemitones)/12))
		kFeedback =		0.0
		aOctL	init	0									;INITIALIZE aOutL FOR FIRST PERFORMANCE TIME PASS
		aOctR	init	0
		aOct 	init 	0

		if kStereoMode == 1 then
			fsig1L 	pvsanal	ainL+(aOctL*kFeedback), 2048,512,2048,0					;PHASE VOCODE ANALYSE LEFT CHANNEL
			fsig1R 	pvsanal	ainR+(aOctR*kFeedback), 2048,512,2048,0					;PHASE VOCODE ANALYSE RIGHT CHANNEL
			fsig2L 	pvscale	fsig1L, kscal							;RESCALE PITCH (LEFT CHANNEL)
			fsig2R 	pvscale	fsig1R, kscal							;RESCALE PITCH (RIGHT CHANNEL)

			aOctL 	pvsynth	fsig2L								;RESYNTHESIZE FROM FSIG (LEFT CHANNEL)
			aOctR 	pvsynth	fsig2R								;RESYNTHESIZE FROM FSIG (RIGHT CHANNEL)
		else
			ainMono = (ainL + ainR) * 0.5
			fsig1 	pvsanal	ainMono+(aOct*kFeedback), 2048,512,2048,0					;PHASE VOCODE ANALYSE LEFT CHANNEL
			fsig2 	pvscale	fsig1, kscal							;RESCALE PITCH (LEFT CHANNEL)
			aOct 	pvsynth	fsig2								;RESYNTHESIZE FROM FSIG (LEFT CHANNEL)

			aOctL = aOct
			aOctR = aOct

		endif 

		aOutL ntrpol ainL, aOctL, kDryWet
		aOutR ntrpol ainR, aOctR, kDryWet
	else
		aOutL = ainL
		aOutR = ainR
	endif

	xout aOutL, aOutR
endop
