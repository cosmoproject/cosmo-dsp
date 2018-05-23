/********************************************************
	TriggerDelay.csd
	Author: Iain McCurdy
	COSMO UDO adaption: Bernt Isak Wærstad

	Arguments: 	Threshold, DelayTime Min, DelayTime Max, Feedback Min, Feedback Max, Width, Level, Portamento time, Cutoff frequency, Bandwidth, Dry/wet mix
    Defaults:	0.1, 0.1, 0.2, 0.5, 0.9, 1, 1, 0.1, 0.5, 0.1, 0.5

	Treshold: 0.0001 - 1
	DelayTime Min: 0.0001s - 2s
	DelayTime Max: 0.0001s - 2s
	Feedback Min: 0% - 120%
	Feedback Max: 0% - 120%
	Width: 0 - 1
	Level: 0 - 1 
	Portamento time: 0 - 5
	Cutoff frequency: 50Hz - 10000Hz
	Bandwidth: 600Hz - 22050Hz
	Dry/wet mix: 0% - 100%

	Description:
	This example works best with sharp percussive sounds

	A trigger impulse is generated each time the rms of the input signal
	crosses the defined 'Threshold' value. Each time a new trigger is generated
	a new random delay time (between user definable limits) - and a new random
	feedback value (again between user definable limits) are generated.

	It is possible to generate feedback values of 1 and greater (which can lead
	to a continuous build-up of sound) this is included intentionally and the
	increasing sound will be clipped and can be filtered by reducing the
	'Damping' control to produce increasing distortion of the sound within
	the delay buffer as it repeats

	Increasing the 'Portamento' control damps the otherwise abrupt changes
	in delay time.

	'Width' allows the user to vary the delay from a simple monophonic
	delay to a ping-pong style delay


********************************************************/

	; Default argument values
/*
	#define DelayTime #0.2# 
	#define Feedback #0.3#
	#define Filter #0.5#
	#define Distortion #0#	
	#define Modulation #0#
	#define Mix #0.4#
*/
	; Toggle printing on/off
	#define PRINT #0#

;*********************************************************************
; Triggerelay
;*********************************************************************

opcode TriggerDelay, aa, aakkkkkkkkkkk

	ainL, ainR, kthreshold, kdly1, kdly2, kfback1, kfback2, kwidth, klevel, kporttime, kcf, kbw, kmix xin

	; ******************************
	; Controller value scalings
	; ******************************

	kthreshold expcurve kthreshold, 10
	kthreshold scale kthreshold, 1, 0.0001
	kthreshold init 0.1

	kdly1 expcurve kdly1, 10
	kdly1 scale kdly1, 2, 0.0001
	kdly1 init 0.0001

	kdly2 expcurve kdly2, 10
	kdly2 scale kdly2, 2, 0.0001
	kdly2 init 0.1

	kfback1 scale kfback1, 1.2, 0
	kfback1 init 0.5

	kfback2 scale kfback2, 1.2, 0
	kfback2 init 0.9

	kwidth scale kwidth, 1, 0
	kwidth init 1

	klevel scale klevel, 1, 0
	klevel init 1

	kporttime expcurve kporttime, 10
	kporttime scale kporttime, 5, 0
	kporttime init 0.01

	kcf logcurve kcf, 0.05
	kcf scale kcf, 10000, 50
	kcf init 5000

	kbw expcurve kbw, 30
	kbw scale kbw, 22050, 600
	kbw init 4000

	kmix scale kmix, 1, 0
	kmix init 0.5

	if $PRINT == 1 then 
		
		Scut sprintfk "Threshold: %f", kthreshold
			puts Scut, kthreshold

		Scut sprintfk "Delay time 1: %fs", kdly1
			puts Scut, kdly1

		Scut sprintfk "Delay time 2: %fs", kdly2
			puts Scut, kdly2

		Sfb sprintfk "Feedback 1: %f", kfback1
			puts Sfb, kfback1+1

		Sfb sprintfk "Feedback 2: %f", kfback2
			puts Sfb, kfback2+1

		Smix sprintfk "Stereo Width: %f", kwidth
			puts Smix, kwidth+1

		Smix sprintfk "Level: %f", klevel
			puts Smix, klevel+1

		Smix sprintfk "Port time: %f", kporttime
			puts Smix, kporttime+1

		Slpf sprintfk "Dly Feed LPF Cutoff: %d", kcf
			puts Slpf, kcf

		Slpf sprintfk "Bandwidth: %d", kbw
			puts Slpf, kbw

		Smix sprintfk "Delay Mix: %f", kmix
			puts Smix, kmix+1

	endif

	krms	rms	(ainL+ainR)

	ktrig	trigger	krms, kthreshold, 0

	Strig 	sprintfk "%d new delay triggered!", ktrig 
		puts Strig, (krms * ktrig)

	kdly	trandom	ktrig, 0, 1
	kdly	expcurve	kdly,8
	kMinDly	min	kdly1,kdly2
	kdly	=	(kdly * abs(kdly2 - kdly1) ) + kMinDly


	kramp	linseg	0,0.001,1

	kcf	portk	kcf, kramp * 0.05
	kbw	portk	kbw, kramp * 0.05

	kdly	portk	kdly, kporttime*kramp
	atime	interp	kdly

	kfback	trandom	ktrig, kfback1, kfback2

	;offset delay (no feedback)
	abuf	delayr	5
	afirst	deltap3	atime
	afirst	butbp	afirst,kcf,kbw
		delayw	ainL

	;left channel delay (note that 'atime' is doubled)
	abuf	delayr	10			;
	atapL	deltap3	atime*2
	atapL	clip	atapL,0,0.9
	atapL	butbp	atapL,kcf,kbw
		delayw	afirst+(atapL*kfback)

	 ;right channel delay (note that 'atime' is doubled)
	 abuf	delayr	10
	 atapR	deltap3	atime*2
	 atapR	clip	atapR,0,0.9
	 atapR	butbp	atapR,kcf,kbw
		delayw	ainR+(atapR*kfback)

	 ;create width control. note that if width is zero the result is the same as 'simple' mode
	 atapL	=	afirst+atapL+(atapR*(1-kwidth)) * klevel
	 atapR	=	atapR+(atapL*(1-kwidth)) * klevel

	;amixL		ntrpol		ainL, atapL, kmix	;CREATE A DRY/WET MIX BETWEEN THE DRY AND THE EFFECT SIGNAL
	;amixR		ntrpol		ainR, atapR, kmix	;CREATE A DRY/WET MIX BETWEEN THE DRY AND THE EFFECT SIGNAL

	amixL = (ainL * (1-kmix)) + (atapL * kmix)
	amixR = (ainR * (1-kmix)) + (atapR * kmix)

			xout		amixL, amixR
endop
