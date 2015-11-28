<CsoundSynthesizer>
<CsOptions>
-odac:hw:1,0 -iadc:hw:1 -d -+rtaudio=ALSA -b128 -B512
;-odac -iadc0
</CsOptions>
<CsInstruments>
sr      = 44100
ksmps  	= 32
0dbfs	= 1
nchnls 	= 2

giSine ftgen 0, 0, 4096, 10, 1
#include "UDOs/Reverb.csd"
#include "UDOs/Lowpass.csd"
#include "UDOs/SquareMod.csd"
#include "UDOs/MultiDelay.csd"

instr 1 
	#include "includes/adc_channels.inc"
	#include "includes/gpio_channels.inc"

	gaL, gaR ins

	kgain = 10
	gaL = gaL * kgain
	gaR = gaR * kgain

	gaL, gaR Reverb gaL, gaR, gkpot1, gkswitch0

	gaL, gaR MultiDelay_Stereo gaL, gaR, gkswitch3, gkpot5, gkpot6, 0.6, gkswitch2

	if (gkswitch0 == 1) then
		gkled0 = 1
	elseif (gkswitch0 == 0) then
		gkled0 = 0
	endif

	if (gkswitch1 == 1) then
		gkled1 = 1
	elseif (gkswitch1 == 0) then
		gkled1 = 0
	endif

	if (gkswitch2 == 1) then
		gkled2 = 1
	elseif (gkswitch2 == 0) then
		gkled2 = 0
	endif

	if (gkswitch3 == 1) then
		gkled3 = 1
	elseif (gkswitch3 == 0) then
		gkled3 = 0
	endif

	gaL, gaR SquareMod gaL, gaR, gkpot0, gkswitch1

	gaL, gaR Lowpass_Stereo gaL, gaR, gkpot2, gkpot4

	gaL, gaR Reverb gaL, gaR, 0.8, 0.8, 0.3
	
	outs gaL, gaR 

endin


</CsInstruments>
<CsScore>
i1 0 86400
</CsScore>
</CsoundSynthesizer>


