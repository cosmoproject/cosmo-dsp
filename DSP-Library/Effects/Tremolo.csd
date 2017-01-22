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

	kFreq scale kFreq, 5, 0.001
	Sfreq sprintfk "Tremolo freq: %fHz", kFreq
		puts Sfreq, kFreq + 1

	Sdepth sprintfk "Tremolo depth: %f", kDepth
		puts Sdepth, kDepth + 1 

	aMod oscil 1, kFreq

	aCarL oscil 0.45, 4.21*aMod
	aCarR oscil 0.5, 4.7*aMod*0.98

	aRML = ainL* aCarL
	aRMR = ainR * aCarR

	aoutL, aoutR FadeSwitch ainL, ainR, aRML, aRMR, 0.2, kDepth

	xout aoutL, aoutR

endop
