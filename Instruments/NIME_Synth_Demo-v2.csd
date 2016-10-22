<CsoundSynthesizer>
<CsOptions>
;-odac:hw:1,0 -iadc:hw:1 -d -+rtaudio=ALSA -b128 -B1024 -+rtmidi=alsa -Ma -m0 --sched=99 
-odac:hw:1,0 -iadc:hw:1 -d -+rtaudio=ALSA -b128 -B1024
;-odac -iadc0 -Ma
</CsOptions>
<CsInstruments>
sr      = 44100
ksmps  	= 64
0dbfs	= 1
nchnls 	= 2


	#include "../Effects/UDOs/FadeSwitch.csd"

	#include "../Effects/UDOs/AnalogDelay.csd"
	#include "../Effects/UDOs/BasicLooper.csd"
	#include "../Effects/UDOs/Blur.csd"
	#include "../Effects/UDOs/Chorus.csd"
	#include "../Effects/UDOs/Convolution.csd"
	#include "../Effects/UDOs/Distortion.csd"
	#include "../Effects/UDOs/FakeGrainer.csd"
	#include "../Effects/UDOs/Hack.csd"
	#include "../Effects/UDOs/Lowpass.csd"
	#include "../Effects/UDOs/MultiDelay.csd"
	#include "../Effects/UDOs/Octaver.csd"
	#include "../Effects/UDOs/RandDelay.csd"
	#include "../Effects/UDOs/Repeater.csd"
	#include "../Effects/UDOs/Resonator.csd"
	#include "../Effects/UDOs/Reverb.csd"
	#include "../Effects/UDOs/Reverse.csd"
	#include "../Effects/UDOs/SimpleLooper.csd"
	#include "../Effects/UDOs/SineDelay.csd"
	#include "../Effects/UDOs/SolinaChorus.csd"
	#include "../Effects/UDOs/SquareMod.csd"
	#include "../Effects/UDOs/TriggerDelay.csd"
	#include "../Effects/UDOs/Wobble.csd"


#include "Instruments/StringSynth.csd"
#include "Instruments/SineSynths.csd"
#include "Instruments/Moogish.csd"
#include "Instruments/CrazyPluck.csd"
#include "Instruments/Scanned.csd"
#include "Instruments/Simpler.csd"


massign 3, 3

instr 1

	iamp ampmidi 0.5
	icps cpsmidi
	inum notnum

	
	i_instrnum[] init 1
	
;	i_instrnum[0] nstrnum "Simpler"
	i_instrnum[0] nstrnum "SineSynth1"
;	i_instrnum[0] nstrnum "Scanned"	


	kndx init 0
	ktrigger init 1

	if (ktrigger == 1) then 
		kndx = 0
		until (kndx == lenarray(i_instrnum)) do
			kinstrNum = i_instrnum[kndx]
			event "i", kinstrNum +(inum*0.001), 0, -1, iamp, icps

			Sprint sprintfk "%f: Starting instrument %f", kndx, i_instrnum[kndx]
				puts Sprint, kndx

			kndx = kndx + 1
		od
		ktrigger = 0
	endif

	kNoteOff release


	if kNoteOff == 1 then
		kndx = 0
		until kndx == lenarray(i_instrnum) do
			kinstrNum = i_instrnum[kndx]
			event "i", -kinstrNum-(inum*0.001), 0, 1
			kndx += 1
		od 

	endif

	xtratim 1/kr

	ktrigger = 0

endin

gk60 init 0
gk61 init 0
gk62 init 0
gk63 init 0
gk64 init 0
gk65 init 0
gk66 init 0
gk67 init 0
gk68 init 0
gk69 init 0
gk70 init 0
gk71 init 0
gk72 init 0


instr 3

inote notnum 

if inote == 60 then
	gk60 = 1
	krel release 
	if krel == 1 then
		gk60 = 0
	endif
elseif inote == 61 then
	gk61 = 1
	krel release 
	if krel == 1 then
		gk61 = 0
	endif
elseif inote == 62 then
	gk62 = 1
	krel release 
	if krel == 1 then
		gk62 = 0
	endif
elseif inote == 63 then
	gk63 = 1
	krel release 
	if krel == 1 then
		gk63 = 0
	endif
elseif inote == 64 then
	gk64 = 1
	krel release 
	if krel == 1 then
		gk64 = 0
	endif
; Analog Delay ON/OFF
elseif inote == 65 then
	gk65 = 1
	krel release 
	if krel == 1 then
		gk65 = 0
	endif
elseif inote == 70 then
	gk70 = 1
	krel release 
	if krel == 1 then
		gk70 = 0
	endif
elseif inote == 72 then
	gk72 = 1
	krel release 
	if krel == 1 then
		gk72 = 0
	endif
endif
endin



instr 99
	#include "../Includes/gpio_channels.inc"
	#include "../Includes/adc_channels.inc"

	aL init 0
	aR init 0
	aL chnget "MasterL"
	aR chnget "MasterR"
	a0 = 0
	chnset a0, "MasterL"
	chnset a0, "MasterR"
/*
	aL solina_chorus aL, 0.18, 0.6, 6, 0.2
	aR solina_chorus aR, 0.18, 0.6, 6, 0.2
*/
; --------------------------------------
; AUDIO INPUT
; --------------------------------------
	ainL, ainR ins
	ainL atone ainL, 75
	ainR atone ainR, 75


	kgateL rms ainL
	kgateR rms ainR
	kmuteL = kgateL > 0.001 ? 1 : 0
	kmuteR = kgateR > 0.001 ? 1 : 0
	kmuteL port kmuteL, 0.3
	kmuteR port kmuteR, 0.3

; bypass gate
	kmuteL = 1
	kmuteR = 1

	aL = aL + (ainL * kmuteL)
	aR = aR + (ainR * kmuteR)


	kgain = 3
	ainL *= kgain
	ainR *= kgain
; --------------------------------------
	
	kLoopSpeed init 1
/*	kLoopSpeed *= gk61
	kLoopSpeed *= gk63
*/

	gktoggle0 init 0

	; SimpleLooper arguments, rec/play/ovr, stop/start, clear, speed, reverse, through
	kSuperSpeed scale gkpot4, 1, 6
	kSpeed = gkswitch3 < 1 ? gkpot4 : kSuperSpeed
	gkswitch4 = gkswitch4 == 1 ? 0 : 1
	;aL, aR,kR,kP SimpleLooper aL, aR, gk60, gk62, 0, kLoopSpeed, gk64, 1
	aL, aR, kRec,kPlaying SimpleLooper aL, aR, gktoggle1, gktoggle0, 0, kSpeed, gkswitch4, 1
	gkled0 = kPlaying
	gkled1 = gktoggle1

	; Distortion arguments: level, drive, tone
	aL, aR Distortion aL, aR, 0.8, gkpot0, 0.5


	; Octaver arguments: pitch (-12 to +12semi), mix
;	aL, aR Octaver aL, aR,1, 0.5;gkpot2, gk65*0.5 

	; Repeater arguments: range, on/off
;	aL, aR Repeater aL, aR, gkpot2, gk72

	; Hack arguments: drywet, freq
	kHack = gkpot1 < 0.1 ? 0 : 1
	kHack port kHack, 0.05
	aL, aR Hack aL, aR, kHack, gkpot1

	; RandDelay arguments: range, feedback, mix
	kRandDly = gkpot3 > 0.7 ? 1 : gkpot3
	kRandDly = kRandDly < 0.1 ? 0 : kRandDly
	kRandDly port kRandDly, 0.01
	aL, aR RandDelay aL, aR, gkpot3, 0.4, kRandDly 

	kFeed scale gkpot7, 0.5, 0.3
	kDlyTime scale gkpot7, 0, 1
	aL, aR MultiDelay aL, aR, 1, kDlyTime, kFeed, 0.5, gkswitch5*0.5


	; Reverse arguments: time, drywet/bypass
	aL, aR Reverse aL, aR, 0.6, gkswitch2

	aL, aR AnalogDelay aL, aR, kDlyTime * 1.5, kFeed * 1.5, gk65 * 0.5

	; Reverb arguments: decay, cutoff, mix
	kRevDecay scale gkpot5, 0.98, 0.8
	aL, aR Reverb aL, aR, kRevDecay, 0.5, gkpot5

	; Lowpass arguments: cutoff, resonance
	aL, aR Lowpass aL, aR, gkpot6, 0.6, 0.5 ;gkpot2, gkpot3

	; SimpleLooper arguments, rec/play/ovr, stop/start, clear, speed, reverse, through
	;aL, aR, kRec,kPlaying SimpleLooper aL, aR, gktoggle1, gktoggle0, 0, kSpeed, gkswitch4, 1
	aL, aR,kR,kP BasicLooper aL, aR, gk60, gk62, 0, kLoopSpeed, gk64, 1, gk61, gk63

	; Repeater arguments: range, on/off
	aL, aR RepeaterLong aL, aR, gkpot2, gk70


	; FOR MONO OUT
;	aL = (aL + aR) * 0.5

	outs aL, aR

endin

; --------------------------------------------------------
; Status LED - set LEDs to ON for 2 seconds to 
; indicate that Csound is running 
; --------------------------------------------------------

instr 999

k1 poscil 1, 1

gkled0 = k1
gkled1 = k1


endin

</CsInstruments>
<CsScore>
i999 0 2

i99 0 86400
</CsScore>
</CsoundSynthesizer>


