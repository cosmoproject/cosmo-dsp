/********************************************************

	Wobble.csd
	Author: Alex Hofmann
	COSMO UDO adaptation: Bernt Isak Wærstad

	Arguments: Frequency, Dry/wet mix
    Defaults:  0.2, 0.5

	Frequency: 0.3Hz - 20Hz

	Description:
	Wobble effect

********************************************************/

opcode Wobble, aa, aakk

	ainL, ainR, kFreq, kDryWet xin

	kFreq expcurve kFreq, 30
	kFreq scale kFreq, 20, 0.3
	Srev sprintfk "Wobble Freq: %fHz", kFreq
		puts Srev, kFreq
	kFreq port kFreq, 0.1

	kDryWet scale kDryWet, 1, 0
	Srev sprintfk "Wobble Mix: %f", kDryWet
		puts Srev, kDryWet+1


	aMod lfo 2000, kFreq, 0

	aFilteredL moogvcf ainL, 2300 + aMod, 0.7
	aFilteredR moogvcf ainR, 2300 + aMod, 0.7

	aFilteredL *= 2.5
	aFilteredR *= 2.5

	aOutL ntrpol ainL, aFilteredL, kDryWet
	aOutR ntrpol ainR, aFilteredR, kDryWet


	xout aOutL, aOutR
endop
