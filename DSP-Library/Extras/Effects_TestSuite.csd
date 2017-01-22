<CsoundSynthesizer>
<CsOptions>
-n -d -+rtmidi=NULL -M0 -m0d 
</CsOptions>
<CsInstruments>
; Initialize the global variables. 
sr = 44100
ksmps = 32
nchnls = 2
0dbfs = 1

#include "../Includes/cosmo_utilities.inc"

#include "../Effects/AnalogDelay.csd"
#include "../Effects/AudioAnalyzer.csd"
#include "../Effects/Blur.csd"
#include "../Effects/Chorus.csd"
#include "../Effects/Distortion.csd"
#include "../Effects/FakeGrainer.csd"
#include "../Effects/Hack.csd"
#include "../Effects/Looper.csd"
#include "../Effects/Lowpass.csd"
#include "../Effects/MultiDelay.csd"
#include "../Effects/PitchShifter.csd"
#include "../Effects/RandDelay.csd"
#include "../Effects/Repeater.csd"
#include "../Effects/Reverb.csd"
#include "../Effects/Reverse.csd"
#include "../Effects/Resonator.csd"
#include "../Effects/SimpleLooper.csd"
#include "../Effects/SineDelay.csd"
#include "../Effects/SolinaChorus.csd"
#include "../Effects/SquareMod.csd"
#include "../Effects/Tremolo.csd"
#include "../Effects/TriggerDelay.csd"
#include "../Effects/Volume.csd"
#include "../Effects/Wobble.csd"




instr 1

	#include "../Includes/adc_channels.inc"
	#include "../Includes/gpio_channels.inc"

	aL, aR ins


;	AnalogDelay
;	Arguments: Delay time, Feedback, Dry/wet mix
	aL, aR AnalogDelay aL, aR, 0.5, 0.5, 0.5

;	AudioAnalyzer
;   Arguments: Attack, Release, Gain
	aL, aR AudioAnalyzer aL, aR, 0.5, 0.5, 0.5

;	Blur
;	Arguments: Blur time, Dry/wet mix
	aL, aR Blur aL, aR, 0.2, 0.8

;	Chorus
;	Arguments: Feedback, Dry/wet mix
	aL, aR Chorus aL, aR, 0.4, 0.5

;	Distortion
;	Arguments: Level, Drive, Tone (low pass filter)
	aL, aR Distortion aL, aR, 0.6, 0.4, 0.8

;	FakeGrainer
;	Arguments: Dry/wet mix
	aL, aR FakeGrainer aL, aR, 0.2

;	Hack
;	Arguments: Frequency, Dry/wet mix
	aL, aR Hack aL, aR, 0.3, 0.5


;	Looper
;	Arguments: Record/Play/Overdub, Stop/start, Clear, Speed, Reverse, Audio Through, Octave Down, Octave Up
;   Output arguments: Record/Play/Overdub, Playing
	aLoopL, aLoopR, kPlaying, kRecing Looper aL, aR, 0, 0, 0, 1, 0, 1, 0, 0
	aL = aL + aLoopL
	aR = aR + aLoopR
	

;	Lowpass
;	Arguments: Cutoff frequency, Resonance, Distortion
	aL, aR Lowpass aL, aR, 0.8, 0.4, 0

;	MultiDelay
;	Arguments: Multi tap on/off, Delay time, Feedback, Cutoff, Dry/wet mix
	aL, aR MultiDelay aL, aR, 1, 0.5, 0.4, 0.9, 0.5

;	PitchShifter
;	Arguments: Seminotes (+/- 1 octave), Stereo mode, Dry/wet mix
	aL, aR PitchShifter aL, aR, 1, 0, 0.5

;	RandDelay
;	Arguments: Range, Feedback, Dry/wet mix
	aL, aR RandDelay aL, aR, 0.5, 0.2, 0.5

;	Repeater
;	Arguments: Range, On/off
	aL, aR Repeater aL, aR, 0.8, 0

;	Resonantor
;	Arguments: Base frequency, Bandwidth, Number of filters, Separation octaves, Separation seminotes, Separation mode[0-2], 
	; !!! NEEDS NORMALIZED ARGUMENTS !!!

;	Reverb
;	Arguments: Decay time, Cutoff frequency, Dry/wet mix
	aL, aR Reverb aL, aR, 0.8, 0.5, 0.3

;	Reverse
;	Arguments: Reverse time, Dry/wet mix
	aL, aR Reverse aL, aR, 0.5, 0.5

;  	SimpleLooper  
;	Arguments: Record/Play, Stop/start, Speed, Reverse, Audio Through
	aSimpLoopL, aSimpLoopR, kPlaying, kRecing SimpleLooper aL, aR, gkswitch0, gkswitch1, 1, 0, 1
	aL = aL + aSimpLoopL
	aR = aR + aSimpLoopR

;	SineDelay
;	Arguments: Range(in seconds), Feedback, Dry/wet mix
	aL, aR SineDelay aL, aR, 0.8, 0.3, 0.5

;	Solina Chorus 
;	Arguments: LFO1 Frequency, LFO1 Amp, LFO2 Frequency, LFO2 Amp, Dry/wet mix, [, Stereo mode on/off]
 	aL, aR SolinaChorus aL, aR, 0.18, 0.6, 6, 0.2, 1, 1

;	SquareMod
;	Arguments: Frequency, Dry/wet mix
	aL, aR SquareMod aL, aR, 0.8, 0.5

;	Tremolo
;	Arguments: Frequency, On/off
 	aL, aR Tremolo aL, aR, 0.8, 1

;	TriggerDelay
;	Arguments: 	Threshold, DelayTime Min, DelayTime Max, Feedback Min,
;				Feedback Max, Width, Level, Portamento time,
;				Center frequency, Bandwidth, Dry/wet mix

	aL, aR TriggerDelay aL, aR, 0.8, 0.1, 0.3, 0.3, 0.5, 0.2, 0.5, 0.2, 0.5, 0.1, 0.3

;	Volume
;	Arguments: Level
	aL, aR Volume aL, aR, 0.5

;	Wobble
;	Arguments: Frequency, Dry/wet mix
	aL, aR Wobble aL, aR, 0.5, 0.5


	aOutL = aL 
	aOutR = aR 

	outs aOutL, aOutR
	

endin


</CsInstruments>
<CsScore>
;causes Csound to run for about 7000 years...
f0 z
;starts instrument 1 and runs it for a week
i1 0 [60*60*24*7] 

</CsScore>
</CsoundSynthesizer>