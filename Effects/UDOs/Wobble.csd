
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

	aOutL ntrpol ainL, aFilteredL, kDryWet
	aOutR ntrpol ainR, aFilteredR, kDryWet


	xout aOutL, aOutR
endop

