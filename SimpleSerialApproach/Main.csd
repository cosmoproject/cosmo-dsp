<CsoundSynthesizer>
<CsOptions>
;-odac:hw:1,0 -iadc:hw:1 -d -+rtaudio=ALSA -b128 -B512
-odac -iadc0
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

instr 1 
	#include "includes/adc_channels.inc"
	#include "includes/gpio_channels.inc"

	gaL, gaR ins

	gaL, gaR Reverb gaL, gaR
	gaL, gaR Lowpass_Stereo gaL, gaR, 3000
	gaL, gaR SquareMod gaL, gaR, 0.7, 1
	
	outs gaL, gaR  

endin


</CsInstruments>
<CsScore>
i1 0 86400
</CsScore>
</CsoundSynthesizer>

<bsbPanel>
 <label>Widgets</label>
 <objectName/>
 <x>100</x>
 <y>100</y>
 <width>320</width>
 <height>240</height>
 <visible>true</visible>
 <uuid/>
 <bgcolor mode="nobackground">
  <r>255</r>
  <g>255</g>
  <b>255</b>
 </bgcolor>
</bsbPanel>
<bsbPresets>
</bsbPresets>
