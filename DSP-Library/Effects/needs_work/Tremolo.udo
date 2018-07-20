/********************************************************
	Tremolo.csd
	Author: Bernt Isak Wærstad

	Arguments: Frequency, Depth
    Defaults:  0.8, 1

	Frequency: 0.001Hz - 5Hz
	Depth: 0 - 1

	Description:
    A tremolo effect
********************************************************/

opcode Tremolo, aa, aakk
	ainL, ainR, kFreq, kDepth xin

	kFreq expcurve kFreq, 30
	kFreq scale kFreq, 15, 0.001
	Sfreq sprintfk "Tremolo freq: %fHz", kFreq
		puts Sfreq, kFreq + 1
	kFreq port kFreq, 0.1
	aFreq interp kFreq

	Sdepth sprintfk "Tremolo depth: %f", kDepth
		puts Sdepth, kDepth + 1 

	aMod oscil kDepth, aFreq

	aCarL oscil 0.45, 4.21*aMod
	aCarR oscil 0.5, 4.7*aMod*0.98

	aoutL = ainL* aCarL
	aoutR = ainR * aCarR

	;aoutL ntrpol ainL, aRML, kDepth
	;aoutR ntrpol ainR, aRMR, kDepth

	xout aoutL, aoutR

endop
