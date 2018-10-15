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

	; Default argument values
	#define Level #0.6#
	#define Drive #0.3#
	#define Tone #0.8#
	#define Mix #1#

	; Toggle printing on/off
	#define PRINT #1#

	; Max and minimum values
	#define MAX_LEVEL #0.8#
	#define MIN_TONE #200#
	#define MAX_TONE #12000#
	#define MAX_DIST #0.5#
	#define MIN_DIST #0.01#

;*********************************************************************
; Distortion - 1 in / 1 out
;*********************************************************************

opcode	Distortion, a, akkkkO

	ain,klevel,kdrive,ktone,kmix, kmode	xin							;READ IN INPUT ARGUMENTS

	klevel scale klevel, $MAX_LEVEL, 0
	kdrive expcurve kdrive, 10
	kdrive scale kdrive, $MAX_DIST, $MIN_DIST
	kLPF expcurve ktone, 30
	kLPF scale kLPF, $MAX_TONE, $MIN_TONE

	if $PRINT == 1 then 		
		Slev sprintfk "Dist level: %f", klevel
			puts Slev, klevel
		Sdrive sprintfk "Dist drive: %f", kdrive
			puts Sdrive, kdrive
		Stone sprintfk "Dist tone: %fHz", kLPF
			puts Stone, kLPF
		Smix sprintfk "Dist mix: %f", kmix
			puts Smix, kmix + 1
	endif

	klevel port klevel, 0.01		
	kdrive port kdrive, 0.01
	kLPF port kLPF, 0.1

	aOut init 0 

	; ******************************
	; Distort1 + LPF18
	; ******************************

	if kmode == 0 then 
		kGainComp1	logcurve	ktone,700					;LOGARITHMIC RESCALING OF ktone TO CREAT A GAIN COMPENSATION VARIABLE FOR WHEN TONE IS LOWERED
		kGainComp1	scale		kGainComp1,1,5					;RESCALE GAIN COMPENSATION VARIABLE

		kpregain	=		(kdrive*100)					;DEFINE PREGAIN FROM kdrive
		kpostgain	=		0.5 * (((1-kdrive) * 0.4) + 0.6)		;DEFINE POSTGAIN FROM kdrive

		aDist		distort1	ain*(32768/0dbfs), kpregain, kpostgain, 0, 0	;CREATE DISTORTION SIGNAL
		aDist		lpf18		aDist/(32768/0dbfs), kLPF, 0.3, kdrive			;LOWPASS FILTER DISTORTED SIGNAL

		aOut ntrpol ain, (aDist*klevel*kGainComp1), kmix  ;RESCALE WITH USER LEVEL CONTROL AND GAIN COMPENSATION
	endif

	xout aOut				
endop

;*********************************************************************
; Distortion - 1 in / 2 out
;*********************************************************************

opcode	Distortion, aa, akkkkO

	ain,klevel,kdrive,ktone,kmix, kmode	xin		

	aOutL Distortion ain,klevel,kdrive,ktone,kmix, kmode
	aOutR Distortion ain,klevel,kdrive,ktone,kmix, kmode

	xout	aOutL, aOutR
endop

;*********************************************************************
; Distortion - 2 in / 2 out
;*********************************************************************

opcode	Distortion, aa, aakkkkO

	ainL, ainR,klevel,kdrive,ktone,kmix, kmode	xin		

	aOutL Distortion ainL,klevel,kdrive,ktone,kmix, kmode
	aOutR Distortion ainR,klevel,kdrive,ktone,kmix, kmode

	xout	aOutL, aOutR
endop

