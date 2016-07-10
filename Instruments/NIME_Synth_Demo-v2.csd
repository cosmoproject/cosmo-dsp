<CsoundSynthesizer>
<CsOptions>
-odac:hw:1,0 -iadc:hw:1,0 -d -+rtaudio=ALSA -b128 -B512 -+rtmidi=alsa -Ma -m0
;-odac -iadc0 -Ma
</CsOptions>
<CsInstruments>
sr      = 44100
ksmps  	= 64
0dbfs	= 1
nchnls 	= 2




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

instr 1

	iamp ampmidi 0.5
	icps cpsmidi
	inum notnum

	
	i_instrnum[] init 1
	
	i_instrnum[0] nstrnum "Simpler"
;	i_instrnum[1] nstrnum "CrazyPluck"
;	i_instrnum[2] nstrnum "Scanned"	


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


instr 99
	#include "includes/adc_channels.inc"
	#include "includes/gpio_channels.inc"

	aL init 0
	aR init 0
	aL chnget "MasterL"
	aR chnget "MasterR"
	a0 = 0
	chnset a0, "MasterL"
	chnset a0, "MasterR"

	ainL, ainR ins
	ainL atone ainL, 75
	ainR atone ainR, 75

	kgateL rms ainL
	kgateR rms ainR
	kmuteL = kgateL > 0.005 ? 1 : 0
	kmuteR = kgateR > 0.005 ? 1 : 0
	kmuteL port kmuteL, 0.3
	kmuteR port kmuteR, 0.3

	aL = aL + (ainL * kmuteL)
	aR = aR + (ainR * kmuteR)

	; Reverse arguments: time, drywet/bypass
	aL, aR Reverse aL, aR, 0.6, gkswitch2

	; Distortion arguments: level, drive, tone
	aL, aR Distortion aL, aR, 0.8, gkpot0, 0.5

	; Hack arguments: drywet, freq
	kHack = gkpot1 < 0.1 ? 0 : 1
	aL, aR Hack aL, aR, kHack, gkpot1

	; RandDelay arguments: range, feedback, mix
	kRandDly = gkpot3 > 0.5 ? 1 : gkpot3
	kRandDly = kRandDly < 0.1 ? 0 : kRandDly
	aL, aR RandDelay aL, aR, gkpot3, 0.4, kRandDly 


	aL solina_chorus aL, 0.18, 0.6, 6, 0.2
	aR solina_chorus aR, 0.18, 0.6, 6, 0.2

	kFeed scale gkpot7, 0.5, 0.3
	kDlyTime scale gkpot7, 0, 1
	aL, aR MultiDelay aL, aR, 1, kDlyTime, kFeed, 0.5, gkswitch5*0.5

	; Reverb arguments: decay, cutoff, mix
	kRevDecay scale gkpot5, 0.98, 0.8
	aL, aR Reverb aL, aR, kRevDecay, 0.5, gkpot5

	; Lowpass arguments: cutoff, resonance
	aL, aR Lowpass aL, aR, gkpot6, 0.7, 0.5 ;gkpot2, gkpot3

	; SimpleLooper arguments, rec/play/ovr, stop/start, clear, speed, reverse, through
	kSuperSpeed scale gkpot4, 1, 6
	kSpeed = gkswitch3 < 1 ? gkpot4 : kSuperSpeed
	gkswitch4 = gkswitch4 == 1 ? 0 : 1
	aL, aR, kRec,kPlaying SimpleLooper aL, aR, gktoggle1, gktoggle0, 0, kSpeed, gkswitch4, 1
	gkled0 = kPlaying
	gkled1 = gktoggle1

	; FOR MONO OUT
	aL = (aL + aR) * 0.5

	outs aL, aR

endin

; --------------------------------------------------------
; Status LED - set LEDs to ON for 3 seconds to 
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


