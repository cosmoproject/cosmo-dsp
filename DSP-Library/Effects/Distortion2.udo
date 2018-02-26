/********************************************************

	Distortion.csd
	Author: Alex Hofmann
	COSMO UDO adaptation: Bernt Isak Wærstad

	Arguments: Level, Drive, Tone, Dry/wet mix
    Defaults:  0.6, 0.3, 0.8, 1

	Level: 0 - 0.8
	Drive: 0.01 - 0.5
	Tone: 200Hz - 12000Hz
	Dry/wet mix: 0% - 100%

    Description:
	A distortion effect

********************************************************/

;*********************************************************************
; Mono version
;*********************************************************************

opcode	Distortion, a, akkkk

	ain,klevel,kdrive,ktone,kmix	xin							;READ IN INPUT ARGUMENTS

	klevel scale klevel, 0.8, 0
	Srev sprintfk "Dist level: %f", klevel
		puts Srev, klevel
	klevel port klevel, 0.01

	kdrive expcurve kdrive, 10
	kdrive scale kdrive, 0.5, 0.01
	Srev sprintfk "Dist drive: %f", kdrive
		puts Srev, kdrive
	kdrive port kdrive, 0.01

	kLPF expcurve ktone, 30
	kLPF scale kLPF, 12000, 200
	Srev sprintfk "Dist tone: %fHz", kLPF
		puts Srev, kLPF
	kLPF port kLPF, 0.1

	Smix sprintfk "Dist mix: %f", kmix
		puts Smix, kmix + 1







instr	1
	gklimit		chnget	"limit"				;READ WIDGETS...
	gkmethod	chnget	"method"			;
	gkmethod	init	1
	gkmethod	init	i(gkmethod)-1
	gkarg		chnget	"arg"
	gklevel		chnget	"level"				;
	
	;asigL, asigR	diskin2	"Seashore.wav",1,0,1		;OPTIONALLY USE A BUILT-IN WAVEFORM FOR TESTING
	asigL, asigR	ins
	
	kSwitch		changed		gklimit, gkmethod, gkarg	;GENERATE A MOMENTARY '1' PULSE IN OUTPUT 'kSwitch' IF ANY OF THE SCANNED INPUT VARIABLES CHANGE. (OUTPUT 'kSwitch' IS NORMALLY ZERO)
	if	kSwitch=1	then	;IF A VARIABLE CHANGE INDICATOR IS RECEIVED...
		reinit	START		;...BEGIN A REINITIALISATION PASS FROM LABEL 'START' 
	endif				;END OF CONDITIONAL BRANCHING
	START:				;LABEL
	
	/* clip meter */
	krmsL		rms		asigL
	krmsR		rms		asigR
	kon	=	1
	koff	=	0
	if(krmsL>gklimit||krmsR>gklimit) then
	 	chnset	kon,"clip_light"
	else
	 	chnset	koff,"clip_light"
	endif		
	/*------------*/
	
	
	aL		clip 		asigL, i(gkmethod), i(gklimit), i(gkarg)
	aR		clip 		asigR, i(gkmethod), i(gklimit), i(gkarg)
	rireturn			;RETURN TO PERFORMANCE PASSES FROM INITIALISATION PASS
	;		outs		aL*gklevel*(1/(gklimit^0.5)), aR*gklevel*(1/(gklimit^0.5))		;pdclip OUTPUTS ARE SENT TO THE SPEAKERS
			outs		aL*gklevel, aR*gklevel							;pdclip OUTPUTS ARE SENT TO THE SPEAKERS
endin
		







	kGainComp1	logcurve	ktone,700					;LOGARITHMIC RESCALING OF ktone TO CREAT A GAIN COMPENSATION VARIABLE FOR WHEN TONE IS LOWERED
	kGainComp1	scale		kGainComp1,1,5					;RESCALE GAIN COMPENSATION VARIABLE

	kpregain	=		(kdrive*100)					;DEFINE PREGAIN FROM kdrive
	kpostgain	=		0.5 * (((1-kdrive) * 0.4) + 0.6)		;DEFINE POSTGAIN FROM kdrive

	aDist		distort1	ain*(32768/0dbfs), kpregain, kpostgain, 0, 0	;CREATE DISTORTION SIGNAL
	aDist		lpf18		aDist/(32768/0dbfs), kLPF, 0.3, kdrive			;LOWPASS FILTER DISTORTED SIGNAL

	aOut ntrpol ain, (aDist*klevel*kGainComp1), kmix  ;RESCALE WITH USER LEVEL CONTROL AND GAIN COMPENSATION

	xout aOut				
endop




opcode	Distortion, a, akk

	ain,klevel,kdrive	xin

	aOut Distortion ain, klevel, kdrive, 0.6, 1

	xout	aOut
endop

opcode	Distortion, a, ak

	ain,klevel	xin

	aOut Distortion ain, klevel, 0.5, 0.6, 1

	xout	aOut
endop

opcode	Distortion, a, a

	ain	xin

	aOut Distortion ain, 0.5, 0.5, 0.7, 1

	xout	aOut
endop

;*********************************************************************
; Stereo version
;*********************************************************************


opcode	Distortion, aa, aakkkk

	ainL,ainR,klevel,kdrive,ktone,kmix	xin				;READ IN INPUT ARGUMENTS

	aOutL Distortion ainL, klevel, kdrive, ktone, kmix 
	aOutR Distortion ainR, klevel, kdrive, ktone, kmix 

	xout aOutL, aOutR				
endop
