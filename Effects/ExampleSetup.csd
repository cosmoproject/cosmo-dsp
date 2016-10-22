<CsoundSynthesizer>
<CsOptions>
-odac:hw:1,0 -iadc:hw:1 -d -+rtaudio=ALSA -b128 -B512 -j4
;-odac -iadc0 
;-n -d -+rtmidi=NULL -M0 -m0d 
</CsOptions>
<CsInstruments>
sr      = 44100
ksmps  	= 64
0dbfs	= 1
nchnls 	= 2

#include "UDOs/Reverb.csd"
#include "UDOs/Lowpass.csd"
#include "UDOs/SquareMod.csd"
#include "UDOs/MultiDelay.csd"
#include "UDOs/TriggerDelay.csd"
#include "UDOs/Resonator.csd"

#include "UDOs/Reverse.csd"
#include "UDOs/RandDelay.csd"
#include "UDOs/Blur.csd"

instr 1 
	#include "../Includes/adc_channels.inc"
	#include "../Includes/gpio_channels.inc"

	aL, aR ins

	;kgain = 3

	;aL *= kgain
	;aR *= kgain
	adlyL = 0
	adlyR = 0


	gkpot6 = gkpot6 < 0.5 ? 0 : 1

	; Lowpass arguments: cutoff, resonance
	aL, aR Lowpass aL, aR, gkpot3, 0.7, 0.5 ;gkpot2, gkpot3

	; RandDelay arguments: range, feedback, mix
	aL, aR RandDelay aL, aR, gkpot4, gkpot1, gkpot6 

	; Revers arguments: time
	;aL, aR Reverse aL, aR, gkpot5

;	ResoFollow arguments: bf, bw, gain, num, ksep, ksep2, epmod, scalemode
;	aL, aR ResonatorFollower aL, aR, gkpot0, gkpot1, 1,   gkpot2, gkpot3, gkpot4,   0,      2 


;	adlyL, adlyR TriggerDelay aL, aR, gkpot0, gkpot1, gkpot2, gkpot3, gkpot4, 1, 0.5, 1, gkpot5, 0.8, 0.5

	; Reverb arguments: decay, cutoff, mix
	aL, aR Reverb aL, aR, gkpot0, 0.5, gkswitch3

;	aL = 0
;	aR = 0



/*
		adlyL, adlyR MultiDelay aL, aR, gkswitch3, gkpot5, gkpot6, 1, gkswitch2

		aL, aR Reverb aL + adlyL, aR + adlyR, gkpot1, gkswitch0
		aL, aR SquareMod aL, aR, gkpot0, gkswitch1
		aL, aR Lowpass_Stereo aL, aR, gkpot2, gkpot4
		aL, aR Reverb aL, aR, 0.8, 0.8, 0.3
*/		
	aOutL = (aL + adlyL)
	aOutR = (aR + adlyR)

	;aOutL limit aOutL, 0.8, 0.95
	;aOutR limit aOutR, 0.8, 0.95

	; IF MONO OUT
	aOutL = aOutL + aOutR 
	
	outs aOutL, aOutR

endin

</CsInstruments>
<CsScore>
i1 0 86400
</CsScore>
</CsoundSynthesizer>



