opcode AnalogDelay, aa, aakkk
	ainL, ainR, kdlytime, kfeed, kDly_Mix xin

	kfeed scale kfeed, 1, 0
	Sfb sprintfk "AnalogDly Feedback: %f", kfeed
		puts Sfb, kfeed+1  

	kdlytime expcurve kdlytime, 10
	kdlytime scale kdlytime, 2000, 1
	Scut sprintfk "AnalogDly time: %dms", kdlytime
		puts Scut, kdlytime

	kdlytime port kdlytime, 0.7
	adlytime interp kdlytime  

	kDly_Mix scale kDly_Mix, 1, 0
	Srev sprintfk "AnalogDly Mix: %f", kDly_Mix
		puts Srev, kDly_Mix+1 

	; Delay code
	aFeedL init 0
	aFeedR init 0

	avDlyL vdelay3 ainL + (aFeedL * kfeed * 1.05), adlytime, 3000
	avDlyR vdelay3 ainR + (aFeedR * kfeed), adlytime*1.05, 3000

	aFeedL lpf18 aFeedL, 3500, 0.5, 0.75
	aFeedR lpf18 aFeedR, 3800, 0.55, 0.7

	;----------------------

	aoutL ntrpol ainL, avDlyL, kDly_Mix 
	aoutR ntrpol ainR, avDlyR, kDly_Mix

	xout aoutL, aoutR
endop





