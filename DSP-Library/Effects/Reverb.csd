/********************************************************

	Reverb.csd
	Author: Bernt Isak Wærstad

	Arguments: Decay time, Cutoff frequency, Dry/wet mix, Mode
    Defaults:  0.85, 0.5, 0.5, 0

	Decay time: 0.1 - 1
	Cutoff frequency: 200Hz - 12000Hz
	Dry/wet mix: 0% - 100%
	Mode: 

		0: reverbsc
		1: freeverb

	Description:
	This effect has default settings so that it can optionally
	also be used without arugments

********************************************************/

#define DECAY #0.85#
#define CUTOFF #0.5#
#define MIX #0.5#
#define MODE #0#

opcode Reverb, aa, aakkkk
	ainL, ainR, kRev_Decay, kRev_Cutoff, kRev_Mix, kMode xin

	kRev_Decay init $DECAY
	kRev_Cutoff init $CUTOFF

	kRev_Mix scale kRev_Mix, 1, 0
	Srev sprintfk "Reverb Mix: %f", kRev_Mix
		puts Srev, kRev_Mix+1

	kRev_Mix port kRev_Mix, 0.05
	kRev_Mix init $MIX

	if (kRev_Mix > 0.1) then

		if kMode == 0 then

			/********************************************************
			Reverbsc
			
			8 delay line stereo FDN reverb, with feedback matrix
			based upon physical modeling scattering junction of 8
			lossless waveguides of equal characteristic impedance.

			Based on Csound orchestra version by Sean Costello.

			********************************************************/

			kRev_Decay scale kRev_Decay, 1, 0.1
			Srev sprintfk "Reverb Decay [reverbsc]: %f", kRev_Decay
				puts Srev, kRev_Decay+1
			kRev_Decay port kRev_Decay, 0.1

			kRev_Cutoff scale kRev_Cutoff, 12000, 200
				Srev sprintfk "Reverb Cutoff [reverbsc]: %f", kRev_Cutoff
			puts Srev, kRev_Cutoff

			; Empty buffer when switching reverb mode
			if (changed(kMode) == 1) then
				arevL = 0
				arevR = 0
			endif

			arevL, arevR reverbsc ainL, ainR, kRev_Decay, kRev_Cutoff

		elseif kMode == 1 then
			
			/********************************************************
			Reverbsc

			freeverb is a stereo reverb unit based on Jezar's public 
			domain C++ sources, composed of eight parallel comb 
			filters on both channels, followed by four allpass units 
			in series. The filters on the right channel are slightly
			 detuned compared to the left channel in order to create 
			 a stereo effect.

			********************************************************/
			
			kRoomSize scale kRev_Decay, 1, 0.1
			Srev sprintfk "Reverb Room size [freeverb]: %f", kRoomSize
				puts Srev, kRoomSize+1
			kRoomSize port kRoomSize, 0.1

			kHFDamp = kRev_Cutoff 
				Srev sprintfk "Reverb HF Damp [freeverb]: %f", kHFDamp
			puts Srev, kHFDamp

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

/********************************************************
	With default value for Mode 
********************************************************/
opcode Reverb, aa, aakkk
	ainL, ainR, kRev_Decay, kRev_Cutoff, kMix xin

	aoutL, aoutR Reverb ainL, ainR, kRev_Decay, kRev_Cutoff, kMix, $MODE

	xout aoutL, aoutR
endop

/********************************************************
	With default value for Dry/wet mix and Mode
********************************************************/
opcode Reverb, aa, aakk
	ainL, ainR, kRev_Decay, kRev_Cutoff xin

	aoutL, aoutR Reverb ainL, ainR, kRev_Decay, kRev_Cutoff, $MIX, $MODE

	xout aoutL, aoutR
endop

/********************************************************
	With default value for Cutoff, Dry/wet mix and Mode 
********************************************************/
opcode Reverb, aa, aak
	ainL, ainR, kRev_Decay xin

	aoutL, aoutR Reverb ainL, ainR, kRev_Decay, $CUTOFF, $MIX, $MODE

	xout aoutL, aoutR
endop

/********************************************************
	With default value for Decay, Cutoff Dry/wet mix and Mode
********************************************************/
opcode Reverb, aa, aa
	ainL, ainR xin

	aoutL, aoutR Reverb ainL, ainR, $DECAY, $CUTOFF, $MIX, $MODE

	xout aoutL, aoutR
endop
