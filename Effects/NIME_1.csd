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

#include "UDOs/Blur.csd"
#include "UDOs/Chorus.csd"
#include "UDOs/Convolution.csd"
#include "UDOs/Distortion.csd"
#include "UDOs/FakeGrainer.csd"
#include "UDOs/Hack.csd"
#include "UDOs/Lowpass.csd"
#include "UDOs/MultiDelay.csd"
#include "UDOs/Octaver.csd"
#include "UDOs/RandDelay.csd"
#include "UDOs/Resonator.csd"
#include "UDOs/Reverb.csd"
#include "UDOs/Reverse.csd"
#include "UDOs/SimpleLooper.csd"
#include "UDOs/SineDelay.csd"
#include "UDOs/SolinaChorus.csd"
#include "UDOs/SquareMod.csd"
#include "UDOs/TriggerDelay.csd"
#include "UDOs/Wobble.csd"


instr 1 
	#include "includes/adc_channels.inc"
	#include "includes/gpio_channels.inc"
	#include "includes/switch2led.inc"

	aL, aR ins

	;kgain = 3

	;aL *= kgain
	;aR *= kgain
	adlyL = 0
	adlyR = 0


	gkpot6 = gkpot6 < 0.5 ? 0 : 1

	; Lowpass arguments: cutoff, resonance
	aL, aR Lowpass aL, aR, 0.8, 0.5, 0

	; Distortion arguments: level, drive, tone
	aL, aR Distortion aL, aR, 0.8, gkpot0, 0.5

	; Blur arguments: time, mix
	;aL, aR Blur aL, aR, 0.7, 0.5

	; Octaver arguments: pitch (-12 to +12semi), mix
	aL, aR Octaver aL, aR, 1, 0.5 * gkswitch2

	; Chorus arguments: feed, mix
	;aL, aR Chorus aL, aR, 0.3, 0.5

	; RandDelay arguments: range, feedback, mix
	aL, aR RandDelay aL, aR, gkpot3, 0.4, 0.75 * gkswitch4 

	; Reverse arguments: time, drywet/bypass
	aL, aR Reverse aL, aR, 0.5, gkswitch5

	; MultiDelay arguments: multitap(on/off), dlytime, feed, cutoff, mix
	;aL, aR MultiDelay aL, aR

	; Hack arguments: drywet, freq
	kHack = gkpot1 < 0.1 ? 0 : 1
	;aL, aR Hack aL, aR, kHack, gkpot1

	; Wobble arguments: freq, drywet
	;aL, aR Wobble aL, aR	

	; ResoFollow arguments: bf, bw, gain, num, ksep, ksep2, epmod, scalemode
	;aL, aR ResonatorFollower aL, aR, gkpot0, gkpot1, 1,   gkpot2, gkpot3, gkpot4,   0,      2 

	; TriggerDelay argumens: treshold, dly1, dly2, fb1, fb2, width, mix, level, porttime, centerfreq, bandwith 
	;adlyL, adlyR TriggerDelay aL, aR, gkpot0, gkpot1, gkpot2, gkpot3, gkpot4, 1, 0.5, 1, gkpot5, 0.8, 0.5

	; SineDelay arguments: range, feedback, drywet
	kSinDly = gkpot3 > 0.5 ? 0.5 : gkpot3 
	aL, aR SineDelay aL, aR, gkpot3, 0.3, kSinDly

	; SquareMod arguments: freq, mix
	kSquareMod = gkpot4 > 0.5 ? 0.5 : gkpot4 
	aL, aR SquareMod aL, aR, gkpot4, kSquareMod

	; Lowpass arguments: cutoff, resonance
	aL, aR Lowpass aL, aR, gkpot5, 0.7, 0.5 ;gkpot2, gkpot3

	; SolinaChorus arguments: lfo1-freq, lfo1-amp, lfo2-freq, lfo2-amp
	;aL solina_chorus aL, 0.18, 0.6, 6, 0.2
	;aR solina_chorus aR, 0.18, 0.6, 6, 0.2

	; FakeGrainer arguments: drywet
	;aL, aR FakeGrainer aL, aR, 0.5

	; PartitionConv arguments: mix 
	;aL, aR PartitionConv aL, aR, 0.8

	; Reverb arguments: decay, cutoff, mix
	aL, aR Reverb aL, aR, 0.9, 0.5, gkpot6

	; SimpleLooper arguments, rec/play/ovr, stop/start, clear, speed, reverse, through
	aL, aR SimpleLooper aL, aR, gkswitch0, gkswitch1, 0, 1, gkswitch3, 1


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



