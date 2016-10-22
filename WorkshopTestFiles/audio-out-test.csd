<CsoundSynthesizer>
<CsOptions>
-odac:hw:1,0 -iadc:hw:1 -b128 -B1024 -+rtaudio=ALSA -d -realtime --sched=99
</CsOptions>

<CsInstruments>

	sr = 44100  
	ksmps = 64
	nchnls = 2	
	0dbfs = 1

;***************************************************
; sinus player instrument
;***************************************************
	instr	1

	iamp		= 0.5
	ifreq		= 1000

	kfreq line 500, p3, 100
	
; audio generator

	a1		oscil	iamp, kfreq


; audio out
	outs		a1, a1

	endin


;***************************************************

</CsInstruments>
<CsScore>

; 	start	dur	
i1	0	5
i1  5   2

e

</CsScore>
</CsoundSynthesizer>
