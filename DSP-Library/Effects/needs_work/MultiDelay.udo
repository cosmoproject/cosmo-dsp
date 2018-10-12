/********************************************************

	MultiDelay.csd
	Author: Bernt Isak Wærstad

	Arguments: Multi tap on/off, Delay time, Feedback, Cutoff, Dry/wet mix
    Defaults:  1, 0.5, 0.4, 0.9, 0.5

	Multi tap on/off: 0 - 1 (1 above 0.5, 0 below 0.5)
	Delay time: 1ms - 1s
	Feedback: 0% - 100%
	Cutoff: 500Hz - 12000Hz
	Dry/wet mix: 0 - 100%

	Description:
	A multi tap delay effect

********************************************************/

opcode MultiDelay, aa, aakkkkk
	ainL, ainR, kmultitap, kdlytime, kfeed, kcutoff, kDly_Mix xin

	kmultitap = kmultitap > 0.5 ? 1 : 0 
	Stap sprintfk "MultiDly MultTap on/off: %d", kmultitap
		puts Stap, kmultitap+1

	kfeed scale kfeed, 1, 0
	Sfb sprintfk "MultiDly Feedback: %f", kfeed
		puts Sfb, kfeed+1

	kdlytime expcurve kdlytime, 10
	kdlytime scale kdlytime, 1000, 1
	Scut sprintfk "MultiDly time: %dms", kdlytime
		puts Scut, kdlytime

	kdlytime port kdlytime, 1
	adlytime interp kdlytime / 1000

	;kcutoff logcurve kcutoff, 0.05
	kcutoff scale kcutoff, 12000, 500
	Slpf sprintfk "MultiDly Feed LPF Cutoff: %d", kcutoff
		puts Slpf, kcutoff

	kDly_Mix scale kDly_Mix, 1, 0
	Srev sprintfk "MultiDly Mix: %f", kDly_Mix
		puts Srev, kDly_Mix+1

	; Delay code

	avDlyL vdelay3 ainL, adlytime, 1200
	avDlyR vdelay3 ainR, adlytime, 1200


	abufL	delayr 4 ; Left delay time in seconds
	ad1 	deltap3 adlytime

	if (kmultitap == 1) then
		ad2 	deltap3 adlytime * 1.5
		ad3 	deltap3 adlytime * 4
		aDlyL = ad1 + (ad2 * 0.6) + (ad3 * 0.4)
	else
		aDlyL = ad1
	endif
	aDlyL = aDlyL + avDlyL
	aFeedL tone aDlyL, kcutoff


	abufR 	delayr 3 ; Right delay time in seconds
	ad4		deltap3 adlytime
	if (kmultitap == 1) then
		ad5 	deltap3 adlytime * 2
		ad6 	deltap3 adlytime * 3
		aDlyR = ad4 + (ad5 * 0.6) + (ad6 * 0.4)
	else
		aDlyR = ad4
	endif
	aDlyR = aDlyR + avDlyR
	aFeedR tone aDlyR, kcutoff



			delayw ainR + (aFeedL * kfeed)
			delayw ainL + (aFeedR * kfeed)

	;----------------------

	aoutL = (ainL * (1-kDly_Mix)) + (aDlyL * kDly_Mix)
	aoutR = (ainR * (1-kDly_Mix)) + (aDlyR * kDly_Mix)

	xout aoutL, aoutR
endop