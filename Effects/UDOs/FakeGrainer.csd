
opcode FakeGrainer, aa, aak

	ainL, ainR, kDryWet xin
	;aMod lfo 20, 3, 1

	kDryWet scale kDryWet, 1, 0
	Srev sprintfk "FakeGrainer Mix: %f", kDryWet
		puts Srev, kDryWet+1 

	aMod lfo 1, 35, 3
	aMod butlp aMod, 300
	;outs gaOutL * (aMod), gaOutR * (aMod)
	aGrainL = ainL * aMod
	aGrainR = ainR * aMod

	aOutL ntrpol ainL, aGrainL, kDryWet
	aOutR ntrpol ainR, aGrainL, kDryWet

	xout aOutL, aOutR
endop
