<CsoundSynthesizer>
<CsOptions>
;-odac:hw:1,0 -iadc:hw:1 -d -+rtaudio=ALSA -b512 -B2048 -j4 --realtime
-odac -iadc0 -b128 -B512 -m0d -Ma
</CsOptions>
<CsInstruments>
sr      = 44100
ksmps  	= 128
0dbfs	= 1
nchnls 	= 2

#include "../DSP-Library/Includes/cosmo_utilities.inc"

#include "../DSP-Library/Effects/Reverb.udo"
#include "../DSP-Library/Effects/BitCrusher.udo"
#include "../DSP-Library/Effects/SimpleLooper.udo"
#include "../DSP-Library/Effects/Lowpass.udo"
#include "../DSP-Library/Effects/Repeater2.udo"


instr 1 
	#include "../DSP-Library/Includes/adc_channels.inc"
	#include "../DSP-Library/Includes/gpio_channels.inc"

	aL, aR ins


	kRec ctrl7 1, 0, 0, 1
	kCF ctrl7 1, 8, 0, 1
	kStop ctrl7 1, 7, 0, 1
	kReverse ctrl7 1, 6, 0, 1
	konoff ctrl7 1, 10, 0, 1

;ainL, ainR, 									kRec, kPlayStopToggle, kSpeed, kReverse, kCrossFadeDur, kThrough, L Start, L End
;	aL, aR, kRecPlay,kStop SimpleLooper aL, aR, kRec, kStop, 				1, 			kReverse, 		kCF, 			1, 0, 1

	;aL, aR SimpleLooper aL,aR, kRec

	;aL, aR Lowpass aL, aR, 0.5, 0, 1, 0

	aL, aR Repeater2 aL, aR, 0, 0.3, konoff, 0, 0

	outs aL, aR

endin


</CsInstruments>
<CsScore>
i1 0 86400
</CsScore>
</CsoundSynthesizer>


