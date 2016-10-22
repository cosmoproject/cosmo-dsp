<CsoundSynthesizer>
<CsOptions>
-odac:hw:1,0 -iadc:hw:1 -d -+rtaudio=ALSA -b128 -B1024 --realtime -j2
;-odac -iadc0 
;-n -d -+rtmidi=NULL -M0 -m0d 
</CsOptions>
<CsInstruments>
sr      = 44100
ksmps  	= 128
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


; --------------------------------------------------------
; Status LED - set LEDs to ON for 3 seconds to 
; indicate that Csound is running 
; --------------------------------------------------------

instr 999

k1 poscil 1, 1

gkled0 = k1
gkled1 = k1


endin

instr 1 
	#include "../Includes/adc_channels.inc"
	#include "../Includes/gpio_channels.inc"

	aL, aR ins

	;kgain = 3

	;aL *= kgain
	;aR *= kgain

	adlyL init 0
	adlyR init 0

	; Lowpass arguments: cutoff, resonance
	aL, aR Lowpass aL, aR, 0.8, 0.5, 0

	; Distortion arguments: level, drive, tone
	aL, aR Distortion aL, aR, 0.8, gkpot0, 0.5

	; Blur arguments: time, mix
	;aL, aR Blur aL, aR, 0.7, 0.5

	; Octaver arguments: pitch (-12 to +12semi), mix
	aL, aR Octaver aL, aR, gkpot2, gkswitch3

	; Chorus arguments: feed, mix
	;aL, aR Chorus aL, aR, 0.3, 0.5

	; RandDelay arguments: range, feedback, mix
	kRandDly = gkpot3 > 0.5 ? 1 : gkpot3
	kRandDly = kRandDly < 0.1 ? 0 : kRandDly
	aL, aR RandDelay aL, aR, gkpot3, 0.4, kRandDly 

	; Reverse arguments: time, drywet/bypass
	aL, aR Reverse aL, aR, 0.6, gkswitch2

	; MultiDelay arguments: multitap(on/off), dlytime, feed, cutoff, mix
	;aL, aR MultiDelay aL, aR

	; Hack arguments: drywet, freq
	kHack = gkpot1 < 0.1 ? 0 : 1
	aL, aR Hack aL, aR, kHack, gkpot1

	; Wobble arguments: freq, drywet
	;aL, aR Wobble aL, aR	

	; ResoFollow arguments: bf, bw, gain, num, ksep, ksep2, epmod, scalemode
	;aL, aR ResonatorFollower aL, aR, gkpot2, gkpot4, 1,  1, 1, 1, 0, 2; gkpot2, gkpot3, gkpot4,   0,      2 

	; TriggerDelay argumens: treshold, dly1, dly2, fb1, fb2, width, mix, level, porttime, centerfreq, bandwith 
	;adlyL, adlyR TriggerDelay aL, aR, 0.01, gkpot2, gkpot2 * 0.5, 0.1, 0.5, 1, 1, 1,  0.1, 0.8, 0.5
	;aL = aL + adlyL
	;aR = aR + adlyR

	; SineDelay arguments: range, feedback, drywet
	kSinDly = gkpot2 > 0.5 ? 0.5 : gkpot2 
	kSinDly = kSinDly < 0.1 ? 0 : kSinDly
	;aL, aR SineDelay aL, aR, gkpot2, 0.3, kSinDly

	; SquareMod arguments: freq, mix
	;kSquareMod = gkpot4 > 0.5 ? 1 : gkpot4 
	;aL, aR SquareMod aL, aR, gkpot4, kSquareMod

	; Lowpass arguments: cutoff, resonance
	aL, aR Lowpass aL, aR, gkpot5, 0.6, 0.5 ;gkpot2, gkpot3

	; SolinaChorus arguments: lfo1-freq, lfo1-amp, lfo2-freq, lfo2-amp
	;aL solina_chorus aL, 0.18, 0.6, 6, 0.2
	;aR solina_chorus aR, 0.18, 0.6, 6, 0.2

	; FakeGrainer arguments: drywet
	;aL, aR FakeGrainer aL, aR, 0.5

	; PartitionConv arguments: mix 
	;aL, aR PartitionConv aL, aR, 0.8

	gaL = aL + adlyL
	gaR = aR + adlyR

endin

instr 2
	aL = gaL
	aR = gaR

	#include "includes/gpio_channels.inc"

	; Reverb arguments: decay, cutoff, mix
	aL, aR Reverb aL, aR, 0.9, 0.5, gkpot6

	; ainL, ainR, kRecPlayOvr, kStopStart, kClear, kSpeed, kReverse, kThrough
	; SimpleLooper arguments, rec/play/ovr, stop/start, clear, speed, reverse, through
	aL, aR, kRecPlayOvr, kPlaying SimpleLooper aL, aR, gktoggle1, gktoggle0, 0, gkpot4, gkswitch4, 1

	gkled1 = kRecPlayOvr
	gkled0 = kPlaying

	aOutL = aL;(aL + adlyL)
	aOutR = aR;(aR + adlyR)

	;aOutL limit aOutL, 0.8, 0.95
	;aOutR limit aOutR, 0.8, 0.95

	; IF MONO OUT
	aOutL = aOutL + aOutR 
	
	outs aOutL, aOutR

endin

</CsInstruments>
<CsScore>
i1 0 86400
i2 0 86400
</CsScore>
</CsoundSynthesizer>



