<CsoundSynthesizer>
<CsOptions>
-odac:hw:2,0 -iadc:hw:2 -b512 -B1024 -+rtaudio=ALSA -d --sched=99
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

;***************************************************
; oparroy in 
;***************************************************
	instr	2

	#include "oparroy.inc"

	Sswitch sprintf "Toggle switch %ld", gktoggle0
		puts Sswitch, gktoggle0 + 1

	Spot sprintf "Poteniometer %f", gkpot0
		puts Spot, gkpot0 + 1

	; LFO pulsating LED with PWM

	klfo oscil 1, 0.1

	gkPWM0 = klfo 

	endin


;***************************************************

</CsInstruments>
<CsScore>

; 	start	dur	
i1	0	86400
i2	0	86400

e

</CsScore>
</CsoundSynthesizer>
