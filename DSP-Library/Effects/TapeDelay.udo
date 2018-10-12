/********************************************************

	TapeDelay.udo
	Author: Bernt Isak Wærstad

	Arguments: DelayTime, Feedback, Filter, Mix [, StereoMode]
    Defaults:  0.2, 0.4, 0.5, 0.4, 0

	Delay time: 1ms - 2s
	Feedback: 0% - 120%
	Filter: 200Hz - 12000Hz
	Mix: 0% - 100%

	Additional arguements:
	Distortion: 0 - 1
	Modulation:


	Description:
	Analoge style delay

********************************************************/

	; Default argument values

	#define DelayTime #0.2#
	#define Feedback #0.3#
	#define Filter #0.5#
	#define Distortion #0#
	#define Modulation #0.2#
	#define Mix #0.4#
	#define StereoMode #0#

	; Toggle printing on/off
	#define PRINT #0#

;*********************************************************************
; TapeDelay - 2i/2o - Named arguments
;*********************************************************************

opcode TapeDelay, aa, aaS[]k[]
  	ainL, ainR, Snames[], kvalues[] xin

    idlytime init -1
    ifeed init -1
    ifilter init -1
	idist init -1
	imod init -1
	imix init -1
	istereo init -1

	kdlytime init $DelayTime
    kfeed init $Feedback
    ifilter init $Filter
	kdist init $Distortion
	kmod init $Modulation
	kmix init $Mix
	kstereo init $StereoMode

    icnt = 0
    while icnt < lenarray(Snames) do
        if strcmp("delaytime",Snames[icnt]) == 0 then
            idlytime = icnt
        elseif strcmp("feedback",Snames[icnt]) == 0 then
            ifeed = icnt
        elseif strcmp("filter",Snames[icnt]) == 0 then
            ifilter = icnt
        elseif strcmp("distortion",Snames[icnt]) == 0 then
            idist = icnt
        elseif strcmp("modulation",Snames[icnt]) == 0 then
            imod = icnt
        elseif strcmp("mix",Snames[icnt]) == 0 then
            imix = icnt
        elseif strcmp("stereo",Snames[icnt]) == 0 then
            istereo = icnt
        endif
        icnt += 1
    od

    if idlytime >= 0 then
        kdlytime = kvalues[idlytime]
    endif
    if ifeed >= 0 then
        kfeed = kvalues[ifeed]
    endif
    if ifilter >= 0 then
        kfilter = kvalues[ifilter]
    endif
    if idist >= 0 then
        kdist = kvalues[idist]
    endif
	if imod >= 0 then
		kmod = kvalues[imod]
	endif
    if imix >= 0 then
        kmix = kvalues[imix]
    endif
	if istereo >= 0 then
        kstereo = kvalues[istereo]
    endif

	; ******************************
	; Controller value scalings
	; ******************************

	kdlytime expcurve kdlytime, 10
	kdlytime scale kdlytime, 2000, 1
	kfeed scale kfeed, 1.2, 0
	kfilter scale kfilter, 12000, 200

	kdist init $Distortion
	kdist scale kdist, 1, 0

	kmod init $Modulation
	kmod scale kmod, 1, 0

	kmix scale kmix, 1, 0

	if $PRINT == 1 then
		Stime sprintfk "TapeDelay time: %dms", kdlytime
			puts Stime, kdlytime

		Sfb sprintfk "TapeDelay Feedback: %.2f%%", kfeed*100
				puts Sfb, kfeed+1

		Sfilt sprintfk "TapeDelay Filter: %.2fHz", kfilter
			puts Sfilt, kfilter+1

		Sdist sprintfk "TapeDelay Distortion: %.2f", kdist
			puts Sdist, kdist+1

		Smod sprintfk "TapeDelay Modulation: %.2f%%", kmod*100
			puts Smod, kmod+1

		Smix sprintfk "TapeDelay Mix: %.2f%%", kmix*100
			puts Smix, kmix+1
	endif

	kdlytime port kdlytime, 0.5
	adlytime interp kdlytime

	kmod port kmod, 0.5

	; Delay code
	aFeedL init 0
	aFeedR init 0

	ktime_mod = 1.01
	kfeed_mod = 0.99
	kfilter_mod = 1.1

	kWowFreq = 0.7 ; 0.1 - 10Hz
	kWow oscil kmod*0.01, kWowFreq
	kWow += 1
	;kFlutter = 0

	if kdlytime < 1.5 then
		ktime_mod = 1
		kWow = 1
	endif

	adlytime *= kWow

	if kstereo == 1 then

		avDlyL vdelay3 ainL + aFeedL, adlytime * ktime_mod, 3000
		avDlyR vdelay3 ainR + aFeedR, adlytime , 3000

		aFeedL lpf18 avDlyL * kfeed, kfilter, 0, kdist
		aFeedR lpf18 avDlyR * kfeed * kfeed_mod, kfilter * kfilter_mod, 0, kdist

		aoutL ntrpol ainL, avDlyL, kmix
		aoutR ntrpol ainR, avDlyR, kmix
	else
		avDlyL vdelay3 ainL + aFeedL, adlytime , 3000

		aFeedL lpf18 avDlyL * kfeed, kfilter, 0, kdist

		aoutL ntrpol ainL, avDlyL, kmix
		aoutR = aoutL
	endif

	xout aoutL, aoutR

endop

;*********************************************************************
; TapeDelay - 1i/1o - Named arguments
;*********************************************************************

opcode TapeDelay, a, aS[]k[]
  	ain, Snames[], kvalues[] xin

	aout, a0 TapeDelay ain, ain, Snames, kvalues

	xout aout

endop

;*********************************************************************
; TapeDelay - 1i/2o - Named arguments
;*********************************************************************

opcode TapeDelay, aa, aS[]k[]
  	ain, Snames[], kvalues[] xin

	aoutL, aoutR TapeDelay ain, ain, Snames, kvalues

	xout aoutL, aoutR

endop

;*********************************************************************
; TapeDelay - 1i/1o - Fixed arguments
;*********************************************************************

opcode TapeDelay, a, akkkkO
	ain, kdlytime, kfeed, kfilter, kmix, kstereo xin

	Sargs[] fillarray "delaytime", "feedback", "filter", "mix", "stereo"
	;kvalues[] fillarray kdlytime, kfeed, kfilter, kmix
	kvalues[] init 5
	kvalues[0] = kdlytime
	kvalues[1] = kfeed
	kvalues[2] = kfilter
	kvalues[3] = kmix
	kvalues[4] = kstereo

	aout TapeDelay ain, Sargs, kvalues

	xout aout
endop


;*********************************************************************
; TapeDelay - 1i/2o - Fixed arguments
;*********************************************************************

opcode TapeDelay, aa, akkkkO
	ain, kdlytime, kfeed, kfilter, kmix, kstereo xin

	aOutL TapeDelay ain, kdlytime, kfeed, kfilter, kmix, kstereo
	aOutR TapeDelay ain, kdlytime, kfeed, kfilter, kmix, kstereo

	xout aOutL, aOutR
endop

;*********************************************************************
; TapeDelay - 2i/2o - Fixed arguments
;*********************************************************************

opcode TapeDelay, aa, aakkkkO
	ainL, ainR, kdlytime, kfeed, kfilter, kmix, kstereo xin

	aOutL TapeDelay ainL, kdlytime, kfeed, kfilter, kmix, kstereo
	aOutR TapeDelay ainR, kdlytime, kfeed, kfilter, kmix, kstereo

	xout aOutL, aOutR
endop
