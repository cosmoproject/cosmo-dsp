<CsoundSynthesizer>
<CsOptions>
;-odac:hw:2,0 -iadc:hw:2 -d -+rtaudio=ALSA -b128 -B512 -j1 -+rtmidi=alsa -Ma
-odac -iadc -+rtmidi=coremidi -Ma ;Mac OSX 10.12.2
;-odac:hw:0,0 -iadc:hw:0 -d -+rtaudio=ALSA -b128 -B512 -j1 -+rtmidi=alsa -Ma ;ubuntu
;-n -d -+rtmidi=NULL -M0 -m0d
</CsOptions>
<CsInstruments>
sr      = 44100
ksmps  	= 64
0dbfs	= 1
nchnls 	= 2

 
	 	 #include "../Effects/UDOs/RandDelay.csd" 
	 	 #include "../Effects/UDOs/Lowpass.csd" 
	 	 #include "../Effects/UDOs/Reverb.csd" 

instr 1
	#include "../Includes/midi_cc.inc"

	aL, aR ins

	adlyL = 0
	adlyR = 0
	 aL, aR RandDelay aL, aR, gkpot2, gkpot0, gkpot1
	 aL, aR Lowpass aL, aR, gkpot0, 0.3, 0.0
	 aL, aR Reverb aL, aR, 0.85, 0.5, gkpot2

aOutL = (aL + adlyL)
aOutR = (aR + adlyR)

outs aOutL, aOutR

endin

</CsInstruments>
<CsScore>
i1 0 86400
</CsScore>
</CsoundSynthesizer>
