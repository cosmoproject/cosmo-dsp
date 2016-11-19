<CsoundSynthesizer>
<CsOptions>
-odac:hw:2,0 -iadc:hw:2 -d -+rtaudio=ALSA -b128 -B512 -j1 -+rtmidi=alsa -Ma
;-odac -iadc0 
;-n -d -+rtmidi=NULL -M0 -m0d 
</CsOptions>
<CsInstruments>
sr      = 44100
ksmps  	= 64
0dbfs	= 1
nchnls 	= 2


#include "UDOs/Lowpass.csd"
#include "UDOs/RandDelay.csd"
#include "UDOs/Reverb.csd"


instr 1 
	#include "../Includes/midi_cc.inc"
	
	aL, aR ins

	adlyL = 0
	adlyR = 0
	printk 0.5, gkpot0

	; Lowpass arguments: cutoff, resonance
	aL, aR Lowpass aL, aR, gkpot0, 0.7, 0.5 ;gkpot2, gkpot3

	; RandDelay arguments: range, feedback, mix
	aL, aR RandDelay aL, aR, gkpot2, gkpot3, gkpot4 

	; Reverb arguments: decay, cutoff, mix
	aL, aR Reverb aL, aR, gkpot5, 0.5, gkpot6

	
	aOutL = (aL + adlyL)
	aOutR = (aR + adlyR)
	
	outs aOutL, aOutR

endin

</CsInstruments>
<CsScore>
i1 0 86400
</CsScore>
</CsoundSynthesizer>



