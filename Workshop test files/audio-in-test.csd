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
; audio thru instrument
;***************************************************
	instr	1

	a1, a2 ins

	asig = a1 + a2
	krms rms asig
	printk2 krms

; audio out
	outs		a1, alpf

	endin


;***************************************************

</CsInstruments>
<CsScore>

; 	start	dur	
i1	0	86400

e

</CsScore>
</CsoundSynthesizer>
