/********************************************************

	Hack.csd
	Author: Alex Hofmann
	COSMO UDO adaptation: Bernt Isak Wærstad

	Arguments: Dry/wet mix, Frequency
    Defaults:  0.5, 0.3

	A square wave amplitude modulator

********************************************************/

opcode Hack, aa, aakk

	ainL, ainR, kDryWet, kFreq  xin


	kFreq expcurve kFreq, 30
	kFreq scale kFreq, 45, 0.5
	Srev sprintfk "Hack freq: %fHz", kFreq
		puts Srev, kFreq
	kFreq port kFreq, 0.1

	kDryWet scale kDryWet, 1, 0
	Srev sprintfk "Hack Mix: %f", kDryWet
		puts Srev, kDryWet+1

	aMod lfo 1, kFreq, 3
	aMod butlp aMod, 300

	aHackL = ainL * (aMod)
	aHackR = ainR * (aMod)

	aOutL ntrpol ainL, aHackL, kDryWet
	aOutR ntrpol ainR, aHackR, kDryWet

	xout aOutL, aOutR

endop

opcode Hack, aa, aak

	ainL, ainR, kDryWet  xin

	aOutL, aOutR Hack ainL, ainR, kDryWet, 0.5

	xout aOutL, aOutR

endop

opcode Hack, aa, aa

	ainL, ainR  xin

	aOutL, aOutR Hack ainL, ainR, 1, 0.5

	xout aOutL, aOutR

endop
