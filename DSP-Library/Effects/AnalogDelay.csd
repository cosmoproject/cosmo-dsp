/********************************************************

	EXPERIMENTAL!

	AnalogDelay.csd
	Author: Bernt Isak Wærstad

	Arguments: Delay time, Feedback, Dry/wet mix
    Defaults:  0.2, 0.4, 0.5

	Delay time: 1ms - 2s
	Feedback: 0% - 120%
	Dry/wet mix: 0% - 100%

	Description:
	Analoge style delay

********************************************************/

opcode AnalogDelay, aa, aakkk
	ainL, ainR, kdlytime, kfeed, kDly_Mix xin

	kdlytime expcurve kdlytime, 10
	kdlytime scale kdlytime, 2000, 1
	Scut sprintfk "AnalogDly time: %dms", kdlytime
		puts Scut, kdlytime
	kdlytime port kdlytime, 0.7
	adlytime interp kdlytime

	kfeed scale kfeed, 1.2, 0
	Sfb sprintfk "AnalogDly Feedback: %f", kfeed
		puts Sfb, kfeed+1


	kDly_Mix scale kDly_Mix, 1, 0
	Srev sprintfk "AnalogDly Mix: %f", kDly_Mix
		puts Srev, kDly_Mix+1

	; Delay code
	aFeedL init 0
	aFeedR init 0

	avDlyL vdelay3 ainL + (aFeedL * kfeed), adlytime, 3000
	avDlyR vdelay3 ainR + (aFeedR * kfeed), adlytime*1.02, 3000

	aFeedL lpf18 avDlyL, 4500, 0, 0.15
	aFeedR lpf18 avDlyR, 4800, 0, 0.15

	;----------------------

	aoutL ntrpol ainL, avDlyL, kDly_Mix
	aoutR ntrpol ainR, avDlyR, kDly_Mix

	xout aoutL, aoutR
endop
