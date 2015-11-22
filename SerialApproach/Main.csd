<CsoundSynthesizer>
<CsOptions>
-odac:hw:1,0 -iadc:hw:1 -d -+rtaudio=ALSA -b128 -B512
</CsOptions>
<CsInstruments>
sr      = 44100
ksmps  	= 32
0dbfs	= 1
nchnls 	= 2

giSine ftgen 0, 0, 4096, 10, 1

instr 1 

gaL, gaR ins

gaDryL = gaL
gaDryR = gaR

kGain = 1

gaL = gaL * kGain
gaR = gaR * kGain

endin

instr 2

gkLP_freq oscil 3000, 0.5
gkLP_freq += 3500

endin

;#include "Lowpass.csd"
; 			|
; 			V
#include "Reverb.csd"
; 			|
; 			V
#include "Delay.csd"
; 			|
; 			V
;#include "Distortion.csd"
; 			|
; 			V
#include "Repeat.csd"

instr 99

	outs gaL, gaR  

endin

</CsInstruments>
<CsScore>
i1 0 86400
i2 0 86400

;i "Lowpass" 0 86400
i "Delay" 0 86400
i "Reverb" 0 86400
;i "Distortion" 0 86400
i "Repeat" 0 86400
i 99 0 86400
</CsScore>
</CsoundSynthesizer>







