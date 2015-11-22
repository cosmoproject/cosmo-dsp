<CsoundSynthesizer>
<CsOptions>
-odac:hw:1,0 -iadc:hw:1 -d -+rtaudio=ALSA -b128 -B1024 
</CsOptions>
<CsInstruments>
sr      = 44100
ksmps  	= 32
0dbfs	= 1
nchnls 	= 2

giSine ftgen 0, 0, 4096, 10, 1


instr 1

	#include "includes/adc_channels.inc"



; FM

	kfmidx scale gkpot0, 0, 10
	Sidx sprintfk "[Pot1] FM index: %f", kfmidx
		puts Sidx, kfmidx+1  

	kfmfreq scale gkpot1, 0.1, 500
	Sfm sprintfk "[Pot2] FM freq: %f", kfmfreq
		puts Sfm, kfmfreq+1  

; LPF18

	klpfreq scale gkpot2, 50, 20000
	Slp sprintfk "[Pot3] Lowpass cutoff: %f", klpfreq
		puts Slp, klpfreq+1  

; OSC

	koscvol1 scale gkpot3, 0, 0.8
	Svol1 sprintfk "[Pot4] OSC1 volume: %f", koscvol1
		puts Svol1, koscvol1+1  

	koscvol2 scale gkpot4, 0, 0.8
	Svol2 sprintfk "[Pot5] OSC2 volume: %f", koscvol2
		puts Svol2, koscvol2+1  

	koscvol3 scale gkpot5, 0, 0.8
	Svol3 sprintfk "[Pot6] OSC3 volume: %f", koscvol3
		puts Svol3, koscvol3+1  

	koscvol4 scale gkpot6, 0, 0.8
	Svol4 sprintfk "[Pot7] OSC2 volume: %f", koscvol4
		puts Svol4, koscvol4+1  

	koscvol5 scale gkpot7, 0, 0.8
	Svol5 sprintfk "[Pot8] OSC3 volume: %f", koscvol5
		puts Svol5, koscvol5+1  
		

	afm poscil kfmidx*kfmfreq, kfmfreq

	a1 poscil koscvol1 + afm, 200
	a2 poscil koscvol2 + afm, 202
	a3 poscil koscvol3 + afm, 350
	a4 poscil koscvol4 + afm, 520
	a5 poscil koscvol5 + afm, 740

	asynth = a1 + a2 + a3 + a4 + a5

	asynth lpf18 asynth, klpfreq, 0.5, 0

	outs asynth, asynth
	
endin


</CsInstruments>
<CsScore>
i1 0 86400
</CsScore>
</CsoundSynthesizer>







