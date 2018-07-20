
opcode Stutter, aa, aakkkk

	aL, aR, kStutterBang, kChangeFreq, kStutterSpeed, kInsertMix xin

	; Todo: scale kStutterPoint by kStutterSpeed

	;kStutterBang
	kStutterToggle = kStutterBang

	kFeedback init 0
	kTmp = 0

	printk2 kStutterBang

	if (kStutterBang == 1) then
		kFeedback = 0.97
 		;kFeedback delayk kTmp, 2 ; set to 0 after 0.5s
 	else
 		kFeedback = 0
 	endif

	kStutterPoint init 0.5

	kTrig metro 1

	if kTrig == 1 then
		kStutterPoint random 0.1, 0.5
	endif 

	aDelayL delayr 20
	aWetL	deltapi kStutterPoint
	aStuttL	= (aL + (aWetL * kFeedback))
			delayw aStuttL

	aDelayR delayr 20
	aWetR	deltapi kStutterPoint
	aStuttR	= (aR + (aWetR * kFeedback))
			delayw aStuttR


	aOutL = (aL * (1-kStutterBang)) + (aWetL)
	aOutR = (aR * (1-kStutterBang)) + (aWetR)

	if (kStutterBang == 0) && (kStutterToggle == 0) then
		aOutL = aL
		aOutR = aR
	endif

	xout aOutL, aOutR

endop

/*


opcode Stutter, aa, aakkkk

	aL, aR, kOnOff, kChangeFreq, kStutterSpeed, kInsertMix xin



	; Todo: scale kStutterPoint by kStutterSpeed



	kStutterPoint init 0.3

	kTrig metro kChangeFreq
	if kTrig == 1 then
		kStutterPoint random 0.1, 2
	endif 

	if (kOnOff == 0) then
		kFeedback = 0
	else
		kFeedback = 1
	endif

	kOnOffInverse = kOnOff == 1 ? 0 : 1

	aDelayL delayr 6
	aWetL	deltapi kStutterPoint
			delayw ((aL*kOnOffInverse) + (aWetL * kFeedback))

	aDelayR delayr 6
	aWetR	deltapi kStutterPoint
			delayw ((aR*kOnOffInverse) + (aWetR *kFeedback))	

	if (kOnOff == 0) then
		aDelayL = 0
		aDelayR = 0
		aWetL = 0
		aWetR = 0
	endif

	aOutL = (aL * kInsertMix) + (aWetL * kOnOff)
	aOutR = (aR * kInsertMix) + (aWetR * kOnOff)

	if kOnOff == 0 then
		aOutL = aL
		aOutR = aR
	endif

	xout aOutL, aOutR

endop

*/