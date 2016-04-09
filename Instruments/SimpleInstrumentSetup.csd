<CsoundSynthesizer>
<CsOptions>
-odac:hw:1,0 -d -+rtaudio=ALSA -b128 -B512 -+rtmidi=alsa -M hw:2 -m0
;-odac -iadc0
</CsOptions>
<CsInstruments>
sr      = 44100
ksmps  	= 64
0dbfs	= 1
nchnls 	= 2

#include "UDOs/Monobomb-UDO.csd"
#include "../Effects/UDOs/Reverb.csd"
#include "../Effects/UDOs/Lowpass.csd"

#include "Monobomb-inc.csd"

instr 1 

	icps cpsmidi
	iamp ampmidi

	instrnum = 2

	if iamp > 0 then
		event "i", instrnum, 0, -1, icps, iamp
	endif
	xtratim

		event "i", -instrnum, 0, 1

	

endin


instr 99
	#include "includes/adc_channels.inc"
	#include "includes/gpio_channels.inc"
	#include "includes/switch2led.inc"


	; Reverb arguments: decay, cutoff, mix
	aL, aR Reverb aL, aR, gkpot0, gkpot1, gkswitch0
	; Lowpass_Stereo arguments: cutoff, resonance
	aL, aR Lowpass_Stereo aL, aR, gkpot2, gkpot3

	outs aL, aR

endin


</CsInstruments>
<CsScore>
i99 0 86400
</CsScore>
</CsoundSynthesizer>


