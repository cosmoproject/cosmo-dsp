/********************************************************

	Distortion.csd
	Author: Alex Hofmann
	COSMO UDO adaptation: Bernt Isak Wærstad

	Arguments: Level, Drive, Tone (low pass filter)
    Defaults:  0.6, 0.3, 0.8

	Level: 0 - 0.8
	Drive: 0.01 - 0.4
	Tone: 200Hz - 12000Hz

    Description:
	A distortion effect

********************************************************/

;*********************************************************************
; Mono version
;*********************************************************************

opcode	Distortion, a, akkk

	ain,klevel,kdrive,ktone	xin							;READ IN INPUT ARGUMENTS

	klevel scale klevel, 0.8, 0
	Srev sprintfk "Dist level: %f", klevel
		puts Srev, klevel
	klevel port klevel, 0.01

	kdrive expcurve kdrive, 10
	kdrive scale kdrive, 0.4, 0.01
	Srev sprintfk "Dist drive: %f", kdrive
		puts Srev, kdrive
	kdrive port kdrive, 0.01

	kLPF expcurve ktone, 30
	kLPF scale kLPF, 12000, 200
	Srev sprintfk "Dist tone: %fHz", kLPF
		puts Srev, kLPF
	kLPF port kLPF, 0.1

	kGainComp1	logcurve	ktone,700					;LOGARITHMIC RESCALING OF ktone TO CREAT A GAIN COMPENSATION VARIABLE FOR WHEN TONE IS LOWERED
	kGainComp1	scale		kGainComp1,1,5					;RESCALE GAIN COMPENSATION VARIABLE

	kpregain	=		(kdrive*100)					;DEFINE PREGAIN FROM kdrive
	kpostgain	=		0.5 * (((1-kdrive) * 0.4) + 0.6)		;DEFINE POSTGAIN FROM kdrive

	aDist		distort1	ain*(32768/0dbfs), kpregain, kpostgain, 0, 0	;CREATE DISTORTION SIGNAL
	aDist		butlp		aDist/(32768/0dbfs), kLPF			;LOWPASS FILTER DISTORTED SIGNAL

			xout		aDist*klevel*kGainComp1				;SEND AUDIO BACK TO CALLER INSTRUMENT. RESCALE WITH USER LEVEL CONTROL AND GAIN COMPENSATION
endop

opcode	Distortion, a, akk

	ain,klevel,kdrive	xin

	aOut Distortion ain, klevel, kdrive, 0.6

	xout	aOut
endop

opcode	Distortion, a, ak

	ain,klevel	xin

	aOut Distortion ain, klevel, 0.5, 0.6

	xout	aOut
endop

opcode	Distortion, a, a

	ain	xin

	aOut Distortion ain, 0.5, 0.5, 0.7

	xout	aOut
endop

;*********************************************************************
; Stereo version
;*********************************************************************


opcode	Distortion, aa, aakkk

	ainL,ainR,klevel,kdrive,ktone	xin				;READ IN INPUT ARGUMENTS

	klevel scale klevel, 0.8, 0
	Srev sprintfk "Dist level: %f", klevel
		puts Srev, klevel
	klevel port klevel, 0.01

	kdrive expcurve kdrive, 10
	kdrive scale kdrive, 0.4, 0.01
	Srev sprintfk "Dist drive: %f", kdrive
		puts Srev, kdrive
	kdrive port kdrive, 0.01

	kLPF expcurve ktone, 30
	kLPF scale kLPF, 12000, 200
	Srev sprintfk "Dist tone: %fHz", kLPF
		puts Srev, kLPF
	kLPF port kLPF, 0.1

	kGainComp1	logcurve	ktone,700					;LOGARITHMIC RESCALING OF ktone TO CREAT A GAIN COMPENSATION VARIABLE FOR WHEN TONE IS LOWERED
	kGainComp1	scale		kGainComp1,1,5					;RESCALE GAIN COMPENSATION VARIABLE

	kpregain	=		(kdrive*100)					;DEFINE PREGAIN FROM kdrive
	kpostgain	=		0.5 * (((1-kdrive) * 0.4) + 0.6)		;DEFINE POSTGAIN FROM kdrive

	aDistL		distort1	ainL*(32768/0dbfs), kpregain, kpostgain, 0, 0	;CREATE DISTORTION SIGNAL
	aDistL		butlp		aDistL/(32768/0dbfs), kLPF			;LOWPASS FILTER DISTORTED SIGNAL

	aDistR		distort1	ainR*(32768/0dbfs), kpregain, kpostgain, 0, 0	;CREATE DISTORTION SIGNAL
	aDistR		butlp		aDistR/(32768/0dbfs), kLPF			;LOWPASS FILTER DISTORTED SIGNAL



			xout		aDistL*klevel*kGainComp1, aDistR*klevel*kGainComp1 				;SEND AUDIO BACK TO CALLER INSTRUMENT. RESCALE WITH USER LEVEL CONTROL AND GAIN COMPENSATION
endop

opcode	Distortion, aa, aakk

	ainL,ainR,klevel,kdrive	xin

	aOutL,aOutR Distortion ainL,ainR, klevel, kdrive, 0.6

	xout	aOutL,aOutR
endop

opcode	Distortion, aa, aak

	ainL,ainR,klevel	xin

	aOutL,aOutR Distortion ainL,ainR, klevel, 0.5, 0.6

	xout	aOutL,aOutR
endop

opcode	Distortion, aa, aa

	ainL,ainR	xin

	aOutL,aOutR Distortion ainL,ainR, 0.5, 0.5, 0.7

	xout	aOutL,aOutR
endop
