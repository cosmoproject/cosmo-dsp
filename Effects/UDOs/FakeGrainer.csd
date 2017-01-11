/********************************************************

	FakeGrainer.csd
	Author: Alex Hofmann
	COSMO UDO adaptation: Bernt Isak Wærstad

	Arguments: Dry/wet mix
    Defaults:  1

	An effect that sounds like granular synthesis

********************************************************/

opcode FakeGrainer, aa, aak

	ainL, ainR, kDryWet xin

	kDryWet scale kDryWet, 1, 0
	Srev sprintfk "FakeGrainer Mix: %f", kDryWet
		puts Srev, kDryWet+1

	aMod lfo 1, 35, 3
	aMod butlp aMod, 300

	aGrainL = ainL * aMod
	aGrainR = ainR * aMod

	aOutL ntrpol ainL, aGrainL, kDryWet
	aOutR ntrpol ainR, aGrainL, kDryWet

	xout aOutL, aOutR
endop
