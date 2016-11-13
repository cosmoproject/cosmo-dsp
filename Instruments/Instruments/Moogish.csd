;***************************************************
;ftables
;***************************************************

	giSine		ftgen	0, 0, 65536, 10, 1	; sine
	giSaw		ftgen	0, 0, 8192, 7, 1, 8192, -1 ; saw

;***************************************************
; Moogish - sinus player instrument
;***************************************************

instr Moogish

	kamp1 		= 1 	; 0 - 1
	kfat		= 0.5 	; 0 - 1
	kamp2		= 0.5
	kamp3		= 0.3	; 0 - 1
	kamp4		= 0.2	; 0 - 1
	kamp5		= 0.1
	kamp6		= 0.05
	kfiltLFO 	= 0.3		; 0 - 5
	kdist		= 10	; 0 - 40
	kampSubsub	= 0.6	; 0 - 1
	kampSub		= 0.8	; 0 - 1

	katk		= 1		; 0.001 - 5
	krel 		= 1		; 0.1 - 3
	kvibFreq	= 5		; 0 - 80
	kvibAmp		= 0.3	; 0 - 100

	kLPFres		= 0.7	; 0.1 - 1
	kLPFfreq	= 3000  ; 100 - 18000

	kvol		= 0.7

	iamp		= p4 
	ifreq		= p5

	iatk	= i(katk)
	irel 	= i(krel)
	kenv madsr iatk, 0, 1, irel
	kamp = iamp ;* kenv

; modulators
	klfo		oscil kvibAmp, kvibFreq, giSine
	amod		oscil 0.25, kvibFreq, giSine
	amod = (amod + 0.75)
	amp  = 	iamp * amod

	kfreq = ifreq + klfo

; audio generator
	a1		oscil	kamp*kamp1, kfreq, giSaw
	a2		oscil	kamp*kamp2, (kfreq)*2, giSine
	a3		oscil	kamp*kamp3, (kfreq)*3, giSine
	a4		oscil	kamp*kamp4, (kfreq)*4, giSine
	a5		oscil 	kamp*kamp5, (kfreq)*5, giSine
	a6		oscil	kamp*kamp6, (kfreq)*6, giSine
	
	a2		oscil 	kamp*kfat, (kfreq) * 0.998, giSaw
	a3		oscil 	kamp*kfat, (kfreq) * 1.002, giSaw


	asub		oscil	kamp*kampSub, (kfreq)*0.5, giSaw
	aSubsub		oscil	kamp*kampSubsub, (kfreq)*0.25, giSaw

	asynth = (a1 + a2 + a3 + asub + aSubsub) * 0.5

	asynth = asynth * amod

	asynth = asynth * kenv

	kfilterLFO oscil kfiltLFO*400, kfiltLFO*0.5, giSine

	kLPFfreq = kLPFfreq+kfilterLFO
	if kLPFfreq <= 0 then
		kLPFfreq = 0
	endif

	aout lpf18 asynth, kLPFfreq+100, 0, kdist

	kscale = kdist / 40
	kscale scale kscale, 0.5, 1

	aout = aout * kscale

	aoutL moogladder2 aout, kLPFfreq, kLPFres

	; SolinaChorus arguments: lfo1-freq, lfo1-amp, lfo2-freq, lfo2-amp, dry/wet
	aoutL SolinaChorus aoutL, 0.18, 0.6, 6, 0.2, 1

	aoutR = aoutL

; audio out
	kdelMix = 0.5

	chnmix aoutL, "MasterL"
	chnmix aoutR, "MasterR"
	chnmix aoutL * kdelMix, "DelayL"
	chnmix aoutR * kdelMix, "DelayR"

endin

