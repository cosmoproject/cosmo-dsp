/********************************************************

	MultiDelay.csd
	Author: Bernt Isak Wærstad

	Arguments: Multi tap on/off, Delay time, Feedback, Cutoff, Dry/wet mix
    Defaults:  1, 0.25, 0.45, 0.5, 0.5

	Multi tap on/off: 0 - 1 (1 above 0.5, 0 below 0.5)
	Delay time: 1ms - 1s
	Feedback: 0% - 100%
	Cutoff: 500Hz - 12000Hz
	Dry/wet mix: 0 - 100%

	Description:
	A multi tap delay effect. This effect works best in stereo

********************************************************/

	; Default argument values
	#define MultiTap #1#
	#define DelayTime #0.25#
	#define Feedback #0.45#
	#define Cutoff #0.5#
	#define Mix #0.5#

	; Toggle printing on/off
	#define PRINT #1#

	; Max and minimum values
	#define MAX_DLY_TIME #1000#
	#define MIN_DLY_TIME #1#
	#define MAX_CUTOFF #12000#
	#define MIN_CUTOFF #500#


;*********************************************************************
; MultiDelay - 1 in / 1 out
;*********************************************************************

opcode MultiDelay, a, akkkkk
	ain, kmultitap, kdlytime, kfeed, kcutoff, kDly_Mix xin

	kmultitap = kmultitap > 0.5 ? 1 : 0 
	kfeed scale kfeed, 1, 0
	kdlytime expcurve kdlytime, 10
	kdlytime scale kdlytime, $MAX_DLY_TIME, $MIN_DLY_TIME

	kcutoff scale kcutoff, $MAX_CUTOFF, $MIN_CUTOFF
	kDly_Mix scale kDly_Mix, 1, 0

	if $PRINT == 1 then 
		Stap sprintfk "MultiDly MultTap on/off: %d", kmultitap
			puts Stap, kmultitap+1

		Sfb sprintfk "MultiDly Feedback: %f", kfeed
			puts Sfb, kfeed+1

		Scut sprintfk "MultiDly time: %dms", kdlytime
			puts Scut, kdlytime
		
		Slpf sprintfk "MultiDly Feed LPF Cutoff: %d", kcutoff
			puts Slpf, kcutoff
		
		Srev sprintfk "MultiDly Mix: %f", kDly_Mix
			puts Srev, kDly_Mix+1
	endif 

	kdlytime port kdlytime, 1
	adlytime interp kdlytime / 1000

	; Delay code

	avDly vdelay3 ain, adlytime, $MAX_DLY_TIME ;1200

	abuf	delayr ($MAX_DLY_TIME * 4)/1000 ; Left delay time in seconds
	ad1 	deltap3 adlytime

	if (kmultitap == 1) then
		ad2 	deltap3 adlytime * 1.5
		ad3 	deltap3 adlytime * 4
		aDly = ad1 + (ad2 * 0.6) + (ad3 * 0.4)
	else
		aDly = ad1
	endif
	aDly = aDly + avDly
	aFeed tone aDly, kcutoff
	aFeed = 2 * taninv(aFeed) / 3.1415927 ; limit output

			delayw ain + (aFeed * kfeed)

	;----------------------

	aout = (ain * (1-kDly_Mix)) + (aDly * kDly_Mix)

	aout = 2 * taninv(aout) / 3.1415927 ; limit output

	xout aout
endop
	
;*********************************************************************
; MultiDelay - 1 in / 2 out
;*********************************************************************

opcode MultiDelay, aa, akkkkk
	ain, kmultitap, kdlytime, kfeed, kcutoff, kDly_Mix xin

	aOutL, aOutR MultiDelay ain, ain, kmultitap, kdlytime, kfeed, kcutoff, kDly_Mix

	xout aOutL, aOutR
endop


;*********************************************************************
; MultiDelay - 2 in / 2 out
;*********************************************************************

opcode MultiDelay, aa, aakkkkk
	ainL, ainR, kmultitap, kdlytime, kfeed, kcutoff, kDly_Mix xin

	kmultitap = kmultitap > 0.5 ? 1 : 0 
	kfeed scale kfeed, 1, 0
	kdlytime expcurve kdlytime, 10
	kdlytime scale kdlytime, $MAX_DLY_TIME, $MIN_DLY_TIME

	kcutoff scale kcutoff, $MAX_CUTOFF, $MIN_CUTOFF
	kDly_Mix scale kDly_Mix, 1, 0

	if $PRINT == 1 then 
		Stap sprintfk "MultiDly MultTap on/off: %d", kmultitap
			puts Stap, kmultitap+1

		Sfb sprintfk "MultiDly Feedback: %f", kfeed
			puts Sfb, kfeed+1

		Scut sprintfk "MultiDly time: %dms", kdlytime
			puts Scut, kdlytime
		
		Slpf sprintfk "MultiDly Feed LPF Cutoff: %d", kcutoff
			puts Slpf, kcutoff
		
		Srev sprintfk "MultiDly Mix: %f", kDly_Mix
			puts Srev, kDly_Mix+1
	endif 

	kdlytime port kdlytime, 1
	adlytime interp kdlytime / 1000

	; Delay code

	avDlyL vdelay3 ainL, adlytime, $MAX_DLY_TIME ;1200
	avDlyR vdelay3 ainR, adlytime, $MAX_DLY_TIME ;1200


	abufL	delayr ($MAX_DLY_TIME * 4)/1000 ; Left delay time in seconds
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
	aFeedL = 4 * taninv(aFeedL) / 3.1415927 ; limit feed


	abufR 	delayr ($MAX_DLY_TIME * 3)/1000 ; Right delay time in seconds
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
	aFeedR = 4 * taninv(aFeedR) / 3.1415927 ; limit feed

			delayw ainL + (aFeedL * kfeed)
			delayw ainR + (aFeedR * kfeed)

	;----------------------

	aoutL = (ainL * (1-kDly_Mix)) + (aDlyL * kDly_Mix)
	aoutR = (ainR * (1-kDly_Mix)) + (aDlyR * kDly_Mix)

	aoutL = 2 * taninv(aoutL) / 3.1415927 ; limit output
	aoutR = 2 * taninv(aoutR) / 3.1415927 ; limit output

	xout aoutL, aoutR
endop
