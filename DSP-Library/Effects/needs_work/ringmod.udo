/*
Amplitude Modulator

*/
opcode ringmod,a,akkk

	aIn, kmodFreq, kModIndex, kFeed xin

	kModIndex port kModIndex, 0.01

	aMod    oscil kModIndex, kmodFreq
	;aMod    = aMod + (1-(kModIndex*0.5))

	kPostGain = (kModIndex > 1) ? 1/kModIndex : 1  

	kOnOff = (kModIndex < 0.05) ? 0 : 1
	kOnOff port kOnOff, 0.1

	aFeed		init 0
	aRM 		= aIn * (aMod) * kPostGain

	aOut = (aRM * kOnOff) + (aIn * (1-kOnOff))
;	aOut		= (aIn+aFeed) * (aMod) * kPostGain

;	aFeed		= aOut * kFeed * 0.1
;	aFeed tone aFeed, 400


	
	xout aOut 

endop

