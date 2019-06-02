<CsoundSynthesizer>
<CsOptions>
; OS X
-odac -iadc0 -b128 -B512 -m0d
</CsOptions>
<CsInstruments>
sr      = 44100
ksmps  	= 64
0dbfs	= 1
nchnls 	= 2

#include "../DSP-Library/Includes/cosmo-dsp.inc"

instr 1
	aL, aR ins

	; All arguments are normalized (0-1)

	; Lowpass arguments: cutoff, resonance, distortion, mode
	aL, aR Lowpass aL, aR, 0.6, 0.7, 0.5, 0

	; Reverb arguments: decay, cutoff, mix
	aL, aR Reverb aL, aR, 0.9, 0.5, 0.2

	outs aL, aR

endin


</CsInstruments>
<CsScore>
i1 0 86400
</CsScore>
</CsoundSynthesizer>
