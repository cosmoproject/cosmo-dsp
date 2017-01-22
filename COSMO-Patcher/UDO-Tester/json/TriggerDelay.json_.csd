<CsoundSynthesizer>
<CsOptions>
;-odac:hw:2,0 -iadc:hw:2 -d -+rtaudio=ALSA -b128 -B512 -j1 -+rtmidi=alsa -Ma
-odac -iadc -Ma;-+rtmidi=coremidi -Ma ;Mac OSX 10.12.2
;-odac:hw:0,0 -iadc:hw:0 -d -+rtaudio=ALSA -b128 -B512 -j1 -+rtmidi=alsa -Ma ;ubuntu
;-n -d -+rtmidi=NULL -M0 -m0d
</CsOptions>
<CsInstruments>

	sr      = 44100
	ksmps  	= 64
	0dbfs	= 1
	nchnls 	= 2

 
	#include "../DSP-Library/Includes/cosmo_utilities.inc"

	#include "../DSP-Library/Effects/TriggerDelay.csd" 

	instr 1

		aL, aR ins

		adlyL = 0
		adlyR = 0

		gkCC31_CH1 ctrl7 1, 31, 0, 1
		gkCC34_CH1 ctrl7 1, 34, 0, 1
		gkCC38_CH1 ctrl7 1, 38, 0, 1
		gkCC36_CH1 ctrl7 1, 36, 0, 1
		gkCC29_CH1 ctrl7 1, 29, 0, 1
		gkCC28_CH1 ctrl7 1, 28, 0, 1
		gkCC30_CH1 ctrl7 1, 30, 0, 1
		gkCC35_CH1 ctrl7 1, 35, 0, 1
		gkCC32_CH1 ctrl7 1, 32, 0, 1
		gkCC33_CH1 ctrl7 1, 33, 0, 1
		gkCC37_CH1 ctrl7 1, 37, 0, 1

		aL, aR TriggerDelay aL, aR, gkCC28_CH1, gkCC29_CH1, gkCC30_CH1, gkCC31_CH1, gkCC32_CH1, gkCC33_CH1, gkCC34_CH1, gkCC35_CH1, gkCC36_CH1, gkCC37_CH1, gkCC38_CH1

		aOutL = (aL + adlyL)
		aOutR = (aR + adlyR)

		outs aOutL, aOutR

	endin

</CsInstruments>
<CsScore>
i1 0 86400
</CsScore>
</CsoundSynthesizer>