/********************************************************

	Reverb.csd
	Author: Bernt Isak Wærstad

	Arguments: DecayTime, HighFreq_Cutoff, DryWet_Mix, Mode
    Defaults:  0.85, 0.5, 0.5, 0

	Decay Time: 0.1 - 1
	Dampening/cutoff freq: 200Hz - 12000Hz
	Dry/wet mix: 0% - 100%
	Mode: 

		0: reverbsc
		1: freeverb

	Description:
	This effect has default settings so that it can optionally
	also be used without arugments

********************************************************/

	; Default argument values

	#define DecayTime #0.85#
	#define HighFreq_Cutoff #0.5#
	#define DryWet_Mix #0.5#
	#define Mode #0#

	; Toggle printing on/off
	#define PRINT #0#

	#define MAX_FREQ #12000#
	#define MIN_FREQ #200#	

;*********************************************************************
; Reverb - 2 in / 2 out
;*********************************************************************

opcode Reverb, aa, aaPVVO
	ainL, ainR, kRev_Decay, kRev_Cutoff, kRev_Mix, kMode xin

	kRev_Decay init $DecayTime
	kRev_Cutoff init $HighFreq_Cutoff
	kRev_Mix init $DryWet_Mix
	kMode init $Mode	

	kRev_Mix limit kRev_Mix, 0, 1
	Srev sprintfk "Reverb Mix: %f", kRev_Mix
		puts Srev, kRev_Mix
	kRev_Mix port kRev_Mix, 0.05

	; Skip Reverb processing when mix is close to 0
	 
	if (kRev_Mix > 0.01) then

		if kMode == 0 then

			/********************************************************
			Reverbsc
			
			8 delay line stereo FDN reverb, with feedback matrix
			based upon physical modeling scattering junction of 8
			lossless waveguides of equal characteristic impedance.

			Based on Csound orchestra version by Sean Costello.

			********************************************************/

			kRev_Decay scale kRev_Decay, 1, 0.1
			if $PRINT == 1 then 
				Srev sprintfk "Reverb Decay [reverbsc]: %f", kRev_Decay
					puts Srev, kRev_Decay
			endif
			kRev_Decay port kRev_Decay, 0.1

			kRev_Cutoff scale kRev_Cutoff, $MAX_FREQ, $MIN_FREQ
			if $PRINT == 1 then 
					Srev sprintfk "Reverb Cutoff [reverbsc]: %f", kRev_Cutoff
				puts Srev, kRev_Cutoff
			endif

			; Empty buffer when switching reverb mode
			if (changed(kMode) == 1) then
				arevL = 0
				arevR = 0
			endif

			arevL, arevR reverbsc ainL, ainR, kRev_Decay, kRev_Cutoff

		elseif kMode == 1 then
			
			/********************************************************
			Freeverb

			freeverb is a stereo reverb unit based on Jezar's public 
			domain C++ sources, composed of eight parallel comb 
			filters on both channels, followed by four allpass units 
			in series. The filters on the right channel are slightly
			 detuned compared to the left channel in order to create 
			 a stereo effect.

			********************************************************/
			
			kRoomSize scale kRev_Decay, 1, 0.1
			if $PRINT == 1 then 
				Srev sprintfk "Reverb Room size [freeverb]: %f", kRoomSize
					puts Srev, kRoomSize+1
			endif
			kRoomSize port kRoomSize, 0.1

			kHFMax = kRev_Cutoff / $MAX_FREQ
			kHFMin = $MIN_FREQ / 20000
			kHFDamp scale kRev_Cutoff, kHFMax, kHFMin 
			if $PRINT == 1 then 
					Srev sprintfk "Reverb HF Damp [freeverb]: %f", kHFDamp
				puts Srev, kHFDamp
			endif

			; Empty buffer when switching reverb mode
			if (changed(kMode) == 1) then
				arevL = 0
				arevR = 0
			endif

			arevL, arevR freeverb ainL, ainR, kRoomSize, kHFDamp

		endif

		aoutL ntrpol ainL, arevL, kRev_Mix
		aoutR ntrpol ainR, arevR, kRev_Mix

	else
		aoutL = ainL
		aoutR = ainR
	endif

	xout aoutL, aoutR
endop

;*********************************************************************
; Reverb - 1 in / 2 out
;*********************************************************************

opcode Reverb, aa, aPVVO
	ainMono, kRev_Decay, kRev_Cutoff, kRev_Mix, kMode xin

	aL, aR Reverb ainMono, ainMono, kRev_Decay, kRev_Cutoff, kRev_Mix, kMode

	xout aL, aR
endop

;*********************************************************************
; Reverb - 1 in / 1 out
;*********************************************************************

opcode Reverb, a, aPVVO

	ainMono, kRev_Decay, kRev_Cutoff, kRev_Mix, kMode xin

	aL, aR Reverb ainMono, ainMono, kRev_Decay, kRev_Cutoff, kRev_Mix, kMode

	xout (aL + aR) * 0.5
endop





