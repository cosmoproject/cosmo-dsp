/*
rslider bounds(5, 10, 70, 70), text("Dlytim"), channel("DelayTime"), range(0.0001, 0.25, 0.5, 0.25, 0.00001) 
rslider bounds(5, 10, 7, 7), text("Dlytim"), channel("DelayTime0"), range(0.0, 1.0, 0.5) 

rslider bounds(80, 10, 70, 70), text("DlyConf"), channel("DelayConfig"), range(1.0, 4.0, 2, 1, 1) 

rslider bounds(155, 10, 70, 70), text("FiltFq"), channel("FiltFq"), range(100, 15000, 1000, 0.35) 
rslider bounds(155, 10, 7, 7), text("FiltFq0"), channel("FiltFq0"), range(0.0, 1.0, .5) 

rslider bounds(230, 10, 70, 70), text("Feedback"), channel("Feedback"), range(0.0, 0.99999999, 0.3, 1.9, 0.0001) 
rslider bounds(230, 10, 7, 7), text("Feedback0"), channel("Feedback0"), range(0.0, 1.0, 0.3, 1.9, 0.0001) 

rslider bounds(450, 10, 70, 70), text("D.timMult"), channel("DtimMult"), range(0.7, 1.3, 1.0) 
hostbpm channel("bpm")
*/

	giFeedMap	ftgen	0, 0, 128, 7, 0, 64, 0.5, 22, 0.96, 42, 0.9999

/********************************************************

	StereoDelay.udo
	Author: Øyvind Brandtsegg
	Bernt Isak Wærstad

	Arguments: DelayTime, DelayConfig, FreqCutoff, Feedback, DryWet_Mix, Mode
    Defaults:  0.5, 0, 0.5, 0, 0.3, 0.5, 0

	Delay Time: 0.0001 - 14 seconds
	Delay Config: 1 - 4
		1: 1/1
		2: 4/3
		3: 2/3
		4: 8/5

	Cutoff freq: 100Hz - 15000Hz
	Dry/wet mix: 0% - 100%
	Mode: 

		0: Tempo Stereo Delay
		1: 

	Description:


********************************************************/

	; Default argument values
	#define DelayTime #0.5#
	#define DelayConfig #0#
	#define FreqCutoff #0.5#
	#define Feedback #0.3#
	#define DryWet_Mix #0.5#
	#define Mode #0#

	; Toggle printing on/off
	#define PRINT #0#

	; Max and minimum values
	#define MAX_FREQ #12000#
	#define MIN_FREQ #200#	


;****************************************************************
; Stereo Delay - 2 in / 2 out
;****************************************************************

opcode StereoDelay, aa, aakkkkkk

	aL, aR, kDlyTime, kDlyConfig, kFreqCutoff, kFeedback, kMix, kMode xin
;	a1, a2, kDlytim0, kDlyConf, kffrq0, kfblevl0, kMix xin

/*
	kbpm		chnget "bpm"			; host tempo bpm
	if kbpm < 1 then
	kbpm = 130
	endif
	kbpm = 120
	kbpm_cps	= kbpm/60			; host tempo as cps
*/

	kDlyConf scale kDlyConf, 4.99, 0

	kbpm_cps = 0.5

	kDlytim0 scale kDlytim0, 1, 0.00001 

	imaxdel		= 14					; maximum delay time
	;kDlytim		chnget "DelayTime"			; Delay time, relative to host tempo
	;kDlyMult        chnget "DtimMult"
	kDlytim 	init 0.5
;	kDlytim0	chnget "DelayTime0"			; Delay time, relative to host tempo
	kDlytimMap	= (kDlytim0*kDlytim0*kDlytim0*2)+0.00001	; Delay time map

	kDlytimMapChange changed kDlytimMap
	if kDlytimMapChange > 0 then
			kDlytim = kDlytimMap
	endif

	kbtpo		= kDlytim * 1/kbpm_cps			; basic tempo unit for delay time, follow hosttempo
	
	;kDlyConf	chnget "DelayConfig"			; stereo delay config
	;kfblevl		chnget "Feedback"			; delay feedback
	;kfblevl0	chnget "Feedback0"			; delay feedback
	;kfblevlMap	logcurve kfblevl0, 30			; mapping
	kfblevl init 0.5
	kfblevlMap	table kfblevl0, giFeedMap, 1		; mapping

	kfbleMapChange	changed kfblevlMap
	if kfbleMapChange > 0 then
			kfblevl = kfblevlMap
	endif

	kfblevl		tonek kfblevl, 2

	kffrq1		init 6000 ;chnget "FiltFq"				; feedback filter freq
	;kffrq0		chnget "FiltFq0"			; feedback filter freq
	kffrqMap	= (kffrq0*kffrq0*kffrq0*15000)+100	; mapping
	kffrqMapChange	changed kffrqMap
	if kffrqMapChange > 0 then
			kffrq1 = kffrqMap
	endif

	kffrq1		tonek kffrq1, 2

	klfo		oscil kffrq1*0.2, kbpm_cps*0.25 ; filter lfo
	kffrq		= kffrq1 + klfo
	;kMix		chnget "Mix"				; wet/dry
	
	kMix		tonek kMix, 2

	kDlyConf init 1
	kDlyConf	= round(kDlyConf)
	if kDlyConf == 1 kgoto dlyconfig1
	if kDlyConf == 2 kgoto dlyconfig2
	if kDlyConf == 3 kgoto dlyconfig3
	if kDlyConf == 4 kgoto dlyconfig4

	dlyconfig1:
		ksubL		= 1
		ksubR		= 1.01
	goto contin
	dlyconfig2:
		ksubL		= 1
		ksubR		= 1.33333	; 4/3
	goto contin
	dlyconfig3:
		ksubL		= 1
		ksubR		= 1.5		; 2/3
	goto contin
	dlyconfig4:
		ksubL		= 2
		ksubR		= 1.25		; 8/5
	contin: 

	kdeltL		= kbtpo / ksubL		; calculate subdivision 
	kdeltR		= kbtpo / ksubR		; calculate subdivision 
	kdeltL		limit	kdeltL, 1/kr, imaxdel
	kdeltR		limit	kdeltR, 1/kr, imaxdel

	adeltL		upsamp 	kdeltL				; smoothing
	adeltR		upsamp 	kdeltR				; smoothing
	adeltL		tone	adeltL, 2			; smoothing
	adeltR		tone	adeltR, 2			; smoothing

	adummy		delayr imaxdel				; establish delay line
	aDlyL		deltapi adeltL 				; tap delay Left
	adelwL		= a1 + (aDlyL*kfblevl)			; mix input and feedback
	adelwL		butterlp adelwL, kffrq			; filter delay signal
			delayw	adelwL				; write source to delay line

	adummy		delayr imaxdel				; establish delay line
	aDlyR		deltapi adeltR				; tap delay Right
	adelwR		= a1 + (aDlyR*kfblevl)			; mix input and feedback
	adelwR		butterlp adelwR, kffrq			; filter delay signal
			delayw	adelwR				; write source to delay line

	aL		dcblock2 (aDlyL*kMix)+(a1*(1-kMix))
	aR		dcblock2 (aDlyR*kMix)+(a1*(1-kMix))

			xout aL, aR

endop

;****************************************************************
; Stereo Delay - 1 in / 2 out
;****************************************************************

opcode StereoDelay, aa, akkkkkk
	aMono, kDlyTime, kDlyConfig, kFreqCutoff, kFeedback, kMix, kMode xin

	aL, aR StereoDelay aMono, aMono, kDlyTime, kDlyConfig, kFreqCutoff, kFeedback, kMix, kMode

	xout aL, aR 
endop


;****************************************************************
; Stereo Delay - 1 in / 1 out
;****************************************************************

opcode StereoDelay, a, akkkkkk
	aMono, kDlyTime, kDlyConfig, kFreqCutoff, kFeedback, kMix, kMode xin

	aL, aR StereoDelay aMono, aMono, kDlyTime, kDlyConfig, kFreqCutoff, kFeedback, kMix, kMode

	xout (aL + aR) * 0.5
endop


