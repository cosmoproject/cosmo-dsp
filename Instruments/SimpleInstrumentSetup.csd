<CsoundSynthesizer>
<CsOptions>
;-odac:hw:1,0 -d -+rtaudio=ALSA -b128 -B512 -+rtmidi=alsa -M hw:2 -m0
-odac -iadc0 -Ma -d
</CsOptions>
<CsInstruments>
sr      = 44100
ksmps  	= 64
0dbfs	= 1
nchnls 	= 2


	#include "../Effects/UDOs/FadeSwitch.csd"

	#include "../Effects/UDOs/AudioAnalyzer.csd"
	
	#include "../Effects/UDOs/AnalogDelay.csd"
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
#include "Instruments/ModeInharmonics.csd"
#include "Instruments/CrazyPluck.csd"
#include "Instruments/Scanned.csd"
#include "Instruments/Simpler.csd"

massign 1, 2

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


instr 2

	iamp ampmidi 0.5
	icps cpsmidi
	inum notnum

	
	i_instrnum[] init 1
	
	i_instrnum[0] nstrnum "ModeInharmonics" ;+ (inum*0.001)
;	i_instrnum[1] nstrnum "CrazyPluck"
;	i_instrnum[2] nstrnum "Scanned"	


	kndx init 0
	ktrigger init 1

	if (ktrigger == 1) then 
		kinstrNum = i_instrnum[0]
		event "i", kinstrNum +(inum*0.001), 0, -1, iamp, icps

		ktrigger = 0
	endif

	kNoteOff release


	if kNoteOff == 1 then
		kinstrNum = i_instrnum[0]
		event "i", -kinstrNum-(inum*0.001), 0, 1
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

	aL, aR AudioAnalyzer aL, aR

	; Reverb arguments: decay, cutoff, mix
	arvbL, arvbR Reverb aL, aR, 0.85, 0.5, 1 ;gkpot0, gkpot1, gkswitch0
	
	aL ntrpol aL, arvbL, 0.5
	aR ntrpol aR, arvbR, 0.5

	; Lowpass_Stereo arguments: cutoff, resonance
	;aL, aR Lowpass_Stereo aL, aR, gkpot2, gkpot3

	outs aL, aR

endin


</CsInstruments>
<CsScore>
i99 0 86400
</CsScore>
</CsoundSynthesizer>


