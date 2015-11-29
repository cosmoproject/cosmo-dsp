opcode MultiDelay_Stereo, aa, aakkkkk
	ainL, ainR, kmultitap, kdlytime, kfeed, kcutoff, kDly_Mix xin

	kfeed scale kfeed, 1, 0
	Sfb sprintfk "Feedback: %f", kfeed
		puts Sfb, kfeed+1  

	kdlytime expcurve kdlytime, 10
	kdlytime scale kdlytime, 1000, 1
	Scut sprintfk "Delay time: %dms", kdlytime
		puts Scut, kdlytime

	kdlytime port kdlytime, 0.7
	adlytime interp kdlytime / 1000 

	;kcutoff logcurve kcutoff, 0.05
	kcutoff scale kcutoff, 12000, 500
	Slpf sprintfk "Dly Feed LPF Cutoff: %d", kcutoff
		puts Slpf, kcutoff

	kDly_Mix scale kDly_Mix, 1, 0
	Srev sprintfk "Delay Mix: %f", kDly_Mix
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


	;printk2 gkswitch3

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





