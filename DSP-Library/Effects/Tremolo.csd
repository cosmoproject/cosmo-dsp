/********************************************************
	Tremolo.csd
	Author: Bernt Isak Wærstad

	Arguments: Frequency, On/off
    Defaults:  0.8, 1
********************************************************/

opcode Tremolo, aa, aakk
	ainL, ainR, kFreq, kOnOff xin

	kFreq scale kFreq, 5, 0.001
	Sfreq sprintf "Tremolo freq: %fHz", kFreq
		puts Sfreq, kFreq + 1

	aMod oscil 1, kFreq

	aCarL oscil 0.45, 4.21*aMod
	aCarR oscil 0.5, 4.7*aMod*0.98

	aRML = ainL* aCarL
	aRMR = ainR * aCarR

	aoutL, aoutR FadeSwitch ainL, ainR, aRML, aRMR, 0.2, kOnOff

	xout aoutL, aoutR

endop
