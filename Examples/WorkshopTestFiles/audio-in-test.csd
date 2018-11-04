<CsoundSynthesizer>
<CsOptions>
;-odac:hw:2,0 -iadc:hw:2 -b512 -B1024 -+rtaudio=ALSA -d --sched=99
-odac:hw:1,0 -iadc:hw:1 -b512 -B1024 -+rtaudio=ALSA -d --sched=99

</CsOptions>

<CsInstruments>

	sr = 44100  
	ksmps = 128
	nchnls = 2	
	0dbfs = 1

;***************************************************
; audio thru instrument
;***************************************************
	instr	1

	a1, a2 ins

	asig = a1 + a2
	krms rms asig
	;printk2 krms

; audio out
	outs		a1, a2

	endin


;***************************************************

</CsInstruments>
<CsScore>

; 	start	dur	
i1	0	86400

e

</CsScore>
</CsoundSynthesizer>
