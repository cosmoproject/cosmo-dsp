<CsoundSynthesizer>
<CsOptions>
;-odac:hw:1,0 -iadc:hw:1 -d -+rtaudio=ALSA -b512 -B2048 -j4 --realtime
-odac -iadc0 -b128 -B512 -m0d
</CsOptions>
<CsInstruments>
sr      = 44100
ksmps  	= 64
0dbfs	= 1
nchnls 	= 2

#include "../DSP-Library/Includes/cosmo_utilities.inc"

#include "../DSP-Library/Effects/Blur.udo"
#include "../DSP-Library/Effects/Chorus.udo"
#include "../DSP-Library/Effects/FakeGrainer.udo"
#include "../DSP-Library/Effects/Hack.udo"
#include "../DSP-Library/Effects/Highpass.udo"
#include "../DSP-Library/Effects/Lowpass.udo"
#include "../DSP-Library/Effects/RandDelay.udo"
#include "../DSP-Library/Effects/Reverb.udo"
#include "../DSP-Library/Effects/Reverse.udo"
#include "../DSP-Library/Effects/SineDelay.udo"
#include "../DSP-Library/Effects/TapeDelay.udo"
#include "../DSP-Library/Effects/Tremolo.udo"
#include "../DSP-Library/Effects/TriggerDelay.udo"
#include "../DSP-Library/Effects/Volume.udo"
#include "../DSP-Library/Effects/Wobble.udo"


#include "../DSP-Library/Effects/needs_work/Stutter.udo"

instr 100 
	#include "../DSP-Library/Includes/adc_channels.inc"
	#include "../DSP-Library/Includes/gpio_channels.inc"

	aL, aR ins

	aL, aR diskin2 "Tom Dooley - Kurer - Kun Melodi.wav"
	;aL diskin2 "1112_FenderDeluxe_SM57_ISA.wav"
	;aR = aL
	;aL, aR diskin2 "7_8-bossa.wav"
	
	; Name of pots: gkpotX
	; Name of switches: gkswitchX or gktoggleX
	; Name of LEDs: gkledX
	kPreset = 1
	kLP_mode = 0

;	aIn, kStutterTrigg, kStutterSpeed, kMoveTime, kHoldTime, kInsertMix xin

	kTrig metro 0.5

;	ain, kRange, kFrequency, kFeedback, kDryWet, id xin

	koptargs[] init 2

	klfo oscil 0.5, 0.3
	klfo += 1
	koptargs[0] = klfo

	klfo2 oscil 0.5, 0.5
	klfo2 += 1
	koptargs[1] = klfo2

	aL Stutter aL, kTrig, 0.5, 0.6, 0.2, 0.5,1
	aR Stutter aR, kTrig, 0.6, 0.05, 0.6, 0.5, 1

	aL SineDelay aL, 0.1, 0.1, 0.5, koptargs
	aR SineDelay aR, 0.15, 0.2, 0.3, koptargs

	if kPreset == 1 then

		; Lowpass arguments: cutoff, resonance, distortion, mode
		;aL, aR Lowpass aL, aR, 0.6, 0.7, 0.5, kLP_mode 

		krev_mode = oscil:k(1,0.2) > 0 ? 1 : 0

		; Reverb arguments: decay, cutoff, mix
		;aL, aR Tremolo aL, aR, 0.5, 1

	elseif kPreset == 2 then

			; Lowpass arguments: cutoff, resonance, distortion, mode
		aL, aR Lowpass aL, aR, 0.6, 0.7, 0.5 , kLP_mode

	endif

;	Arguments: DelayTime, Feedback, Filter, Distortion, Modulation, Mix [, StereoMode]
;    Defaults:  0.2, 0.4, 0.5, 0, 0, 0.4, 0

	aL, aR Blur aL, aR 

	aL, aR Chorus aL, aR 
	
	aL, aR FakeGrainer aL, aR 

	aL, aR Hack aL, aR 

	aL, aR Highpass aL, aR 

	aL, aR Lowpass aL, aR 
	aL, aR RandDelay aL, aR 
	aL, aR Reverb aL, aR 
	aL, aR Reverse aL, aR 
	aL, aR SineDelay aL, aR 
	
	aL, aR TapeDelay aL, aR, 0.3, 0.5, 0.5, 0, 0, 0.5, 1

	aL, aR Tremolo aL, aR 
	aL, aR TriggerDelay aL, aR 
	aL, aR Volume aL, aR 
	aL, aR Wobble aL, aR 

	outs aL, aR

endin


</CsInstruments>
<CsScore>
i100 0 86400
</CsScore>
</CsoundSynthesizer>


