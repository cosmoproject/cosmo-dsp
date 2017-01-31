<CsoundSynthesizer>
<CsOptions>
;-odac:hw:2,0 -iadc:hw:2 -d -+rtaudio=ALSA -b128 -B512 -j1 -+rtmidi=alsa -Ma
-odac -iadc -Ma -m0d ;-+rtmidi=coremidi -Ma ;Mac OSX 10.12.2
;-odac:hw:0,0 -iadc:hw:0 -d -+rtaudio=ALSA -b128 -B512 -j1 -+rtmidi=alsa -Ma ;ubuntu
;-n -d -+rtmidi=NULL -M0 -m0d
</CsOptions>
<CsInstruments>

	sr      = 44100
	ksmps  	= 64
	0dbfs	= 1
	nchnls 	= 2

 
	#include "../DSP-Library/Includes/cosmo_utilities.inc"

	#include "../DSP-Library/Effects/Hack.csd" 
	#include "../DSP-Library/Effects/AnalogDelay.csd" 
	#include "../DSP-Library/Effects/Reverse.csd" 
	#include "../DSP-Library/Effects/Reverb.csd" 

	instr 1

		aL, aR ins

		adlyL = 0
		adlyR = 0


	 	 gkCC23_CH1 ctrl7 1, 23, 0, 1
	 	 gkCC22_CH1 ctrl7 1, 22, 0, 1
	 	 gkCC21_CH1 ctrl7 1, 21, 0, 1

		aL, aR Hack aL, aR, gkCC23_CH1, gkCC21_CH1
		aL, aR AnalogDelay aL, aR, gkCC21_CH1, gkCC22_CH1, gkCC23_CH1
		aL, aR Reverse aL, aR, 0.5, gkCC22_CH1
		aL, aR Reverb aL, aR, 0.9, 0.5, 0.5

		aOutL = (aL + adlyL)
		aOutR = (aR + adlyR)

		outs aOutL, aOutR

	endin

</CsInstruments>
<CsScore>
i1 0 86400
</CsScore>
</CsoundSynthesizer>
