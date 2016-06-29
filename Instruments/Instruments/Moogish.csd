<CsoundSynthesizer>
<CsOptions>
;-odac2 -b128 -B256	-Ma	; realtime audio out
-odac:hw:1,0 -iadc:hw:1 -d -+rtaudio=ALSA -b128 -B1024 --sched=99 -+rtmidi=alsa -M hw:2
</CsOptions>
<CsInstruments>

	sr = 44100  
	ksmps = 64
	nchnls = 2	
	0dbfs = 1

;***************************************************
;ftables
;***************************************************

	giSine		ftgen	0, 0, 65536, 10, 1	; sine
	giSaw		ftgen	0, 0, 8192, 7, 1, 8192, -1 ; saw

	massign 1, 20

;***************************************************
; controller instrument
;***************************************************
	instr	10 
	
		initc7 6, 0, 1
		initc7 6, 16, 0.001 ; attack
		initc7 6, 17, 0.5	; release
		initc7 6, 18, 0.0	; vib. freq
		initc7 6, 19, 0.0	; vib. amp
		initc7 6, 20, 0.8	; delay mix
		initc7 6, 22, 0.5	; LPF res 

		initc7 6, 0, 1
		initc7 6, 1, 0
		initc7 6, 2, 0
		initc7 6, 3, 0
		initc7 6, 4, 0
		initc7 6, 5, 0
		initc7 6, 6, 0
		initc7 6, 7, 0



	gkamp1 	ctrl7 6, 0, 0, 1
	gkfat 	ctrl7 6, 1, 0, 1
	gkamp3 	ctrl7 6, 2, 0, 1
	gkamp4 	ctrl7 6, 3, 0, 1
	gkfiltLFO 	ctrl7 6, 4, 0, 5
	gkdist 	ctrl7 6, 5, 0, 40
	gkampSubsub 	ctrl7 6, 6, 0, 1
	gkampSub ctrl7 6, 7, 0, 1

	gkatk 	ctrl7 6, 16, 0.001, 5
	gkrel 	ctrl7 6, 17, 0.1, 3

	gkvibFreq	ctrl7 6, 18, 0.0, 80
	gkvibAmp	ctrl7 6, 19, 0.0, 100

	gkdelMix	ctrl7 6, 20, 0, 1

	gkLPFres	ctrl7 6, 22, 0.1, 0.95
	gkLPFfreq	ctrl7 6, 23, 100, 18000

	;gkLPFfreq = 10000

		initc7 9, 2, 1
	gavol ctrl7 9, 2, 0, 0.75
	gavol butlp gavol, 5


/*
	key sensekey
	printk2 key, 15 
	ktrig changed key

	ktoggle init 0

	if (ktrig == 1 && key == 49) then
		if (ktoggle == 0) then
			event "i", 90, 0, -1
			ktoggle = 1
			printks "starting delay...", 0
		else
			event "i", -90, 0, 1
			ktoggle = 0
			printks "stopping delay...", 0
		endif
	endif
*/
	endin

;***************************************************
; sinus player instrument
;***************************************************

	instr 20

	iamp		ampmidi 0.5
	ifreq		cpsmidi

	iatk	= i(gkatk)
	irel 	= i(gkrel)
	kenv madsr iatk, 0, 1, irel
	kamp = iamp ;* kenv

; modulators
	klfo		oscil gkvibAmp, gkvibFreq, giSine
	amod		oscil 0.25, gkvibFreq, giSine
	amod = (amod + 0.75)
	amp  = 	iamp * amod

	kfreq = ifreq + klfo

; audio generator
	a1		oscil	kamp*gkamp1, kfreq, giSaw
/*
	a2		oscil	kamp*gkamp2, (kfreq)*2, giSine
	a3		oscil	kamp*gkamp3, (kfreq)*3, giSine
	a4		oscil	kamp*gkamp4, (kfreq)*4, giSine
	a5		oscil 	kamp*gkamp5, (kfreq)*5, giSine
	a6		oscil	kamp*gkamp6, (kfreq)*6, giSine
	*/
	a2		oscil 	kamp*gkfat, (kfreq) * 0.998, giSaw
	a3		oscil 	kamp*gkfat, (kfreq) * 1.002, giSaw


	asub		oscil	kamp*gkampSub, (kfreq)*0.5, giSaw
	aSubsub		oscil	kamp*gkampSubsub, (kfreq)*0.25, giSaw

	asynth = (a1 + a2 + a3 + asub + aSubsub) * 0.5

	asynth = asynth * amod

	asynth = asynth * kenv

	kfilterLFO oscil gkfiltLFO*400, gkfiltLFO*0.5, giSine

	gkLPFfreq = gkLPFfreq+kfilterLFO
	if gkLPFfreq <= 0 then
		gkLPFfreq = 0
	endif
	;printk2  kfilterLFO


	aout lpf18 asynth, gkLPFfreq+100, 0, gkdist

	kscale = gkdist / 40
	kscale scale kscale, 0.5, 1

	aout = aout * kscale

	aoutL moogladder aout, gkLPFfreq, gkLPFres
;	aoutL moogvcf2 aout, gkLPFfreq, gkLPFres

	;aoutL balance amoog, asynth

	aoutR = aoutL


; audio out
	gkdelMix = 0.5

	chnmix aoutL, "MasterL"
	chnmix aoutR, "MasterR"
	chnmix aoutL * gkdelMix, "DelayL"
	chnmix aoutR * gkdelMix, "DelayR"

	endin

	; DELAY + REV
	instr 90 

	initc7 	6, 20, 0.5
	initc7  6, 21, 1
	kfeed 		ctrl7 6, 20, 0, 0.99
	kdelTime	ctrl7 6, 21, 1, 2000

	asigL chnget "DelayL" 
	asigR chnget "DelayR"

	asig = (asigL + asigR)*0.5

	afeed init 0

	printk2 kdelTime

	kdel port kdelTime, 0.5
	adelTime interp kdel

	afx vdelay3 asig + afeed, adelTime, 3000
	afeed = afx * kfeed

	afxL,afxR reverbsc afx, afx, 0.8, 8000

	chnmix afxL, "MasterL"
	chnmix afxR, "MasterR"
	a0 = 0

	chnset a0, "DelayL"
	chnset a0, "DelayR"
	endin

	; MASTER
	instr 99

	aoutL chnget "MasterL"
	aoutR chnget "MasterR"

	;gavol ctrl7 9, 2, 0, 1
	;gavol butlp avol, 10

	a0 = 0
	outch 1, aoutL*gavol
	outch 2, aoutR*gavol

	chnset a0, "MasterL"
	chnset a0, "MasterR"

	endin 

;***************************************************

</CsInstruments>
<CsScore>

; 	start	dur	amp		freq
i10	0 	 86400
i90	0	 86400
i99 0 	 86400
e

</CsScore>
</CsoundSynthesizer>
