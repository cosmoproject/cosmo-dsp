

opcode Octaver, aa, aakk 

	ainL, ainR, k2PITCH_SHIFTER, kDryWet xin
	;kscal	=		octave((int(k2PITCH_SHIFTER)/12)+k3PITCH_SHIFTER)			;DERIVE PITCH SCALING RATIO. NOTE THAT THE 'COARSE' PITCH DIAL BECOMES STEPPED IN SEMITONE INTERVALS
;k2PITCH_SHIFTER ctrl7 1, 11, -12, 12

	if (kDryWet > 0.1) then

	k2PITCH_SHIFTER scale k2PITCH_SHIFTER, 24, 0
	k2PITCH_SHIFTER = k2PITCH_SHIFTER - 12
	Srev sprintfk "Octaver Pitch: %f", k2PITCH_SHIFTER
		puts Srev, k2PITCH_SHIFTER + 13
	k2PITCH_SHIFTER port k2PITCH_SHIFTER, 0.01

	kDryWet scale kDryWet, 1, 0
	Srev sprintfk "Octaver Mix: %f", kDryWet
		puts Srev, kDryWet+1 

	kDryWet init 0.5
	k2PITCH_SHIFTER init -12

	kscal	= 		octave((int(k2PITCH_SHIFTER)/12))
	kFeedback =		0.0
	aOctL	init		0									;INITIALIZE aOutL FOR FIRST PERFORMANCE TIME PASS
	aOctR	init		0	
	fsig1L 	pvsanal	ainL+(aOctL*kFeedback), 4096,1024,4096,0					;PHASE VOCODE ANALYSE LEFT CHANNEL
	;fsig1R 	pvsanal	ainR+(aOctR*kFeedback), 2048,512,2048,0					;PHASE VOCODE ANALYSE RIGHT CHANNEL
	fsig2L 	pvscale	fsig1L, kscal							;RESCALE PITCH (LEFT CHANNEL)
	;fsig2R 	pvscale	fsig1R, kscal							;RESCALE PITCH (RIGHT CHANNEL)

	aOctL 	pvsynth	fsig2L								;RESYNTHESIZE FROM FSIG (LEFT CHANNEL)
	;aOctR 	pvsynth	fsig2R								;RESYNTHESIZE FROM FSIG (RIGHT CHANNEL)
	aOctR = aOctR

	aOutL ntrpol ainL, aOctL, kDryWet
	aOutR ntrpol ainR, aOctR, kDryWet
	else
	aOutL = ainL
	aOutR = ainR
	endif

	xout aOutL, aOutR
endop
