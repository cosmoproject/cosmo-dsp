<CsoundSynthesizer>
<CsOptions>
;-odac:hw:1,0 -d -+rtaudio=ALSA -b128 -B512 -+rtmidi=alsa -M hw:2 -m0
-odac -iadc0 -Ma
</CsOptions>
<CsInstruments>
sr      = 44100
ksmps  	= 64
0dbfs	= 1
nchnls 	= 2

#include "../Effects/UDOs/Reverb.csd"
#include "../Effects/UDOs/Lowpass.csd"
#include "../Effects/UDOs/SolinaChorus.csd"


instr 1

	icps cpsmidi
	iamp ampmidi 0.5

	
	i_instrnum[] init 3
	i_instrnum fillarray 3, 4, 2

	/*
	i_instrnum[0] nstrnum "StringSynth"
	i_instrnum[1] nstrnum "SineSynth1"
	i_instrnum[2] nstrnum "SineSynth2"
	*/

	kndx init 0
	ktrigger init 1


	if (ktrigger == 1) then 
;		event "i", 4, 0, -1, iamp, icps

		until kndx == lenarray(i_instrnum) do
			event "i", i_instrnum[kndx], 0, -1, iamp, icps
			kndx += 1
		od

	endif

	kNoteOff release

	if kNoteOff == 1 then
;		event "i", -4, 0, 1

		kndx = 0
		until kndx == lenarray(i_instrnum) do
			event "i", -i_instrnum[kndx], 0, 1
			kndx += 1

		od 

	endif

	ktrigger = 0

endin


instr 2, StringSynth

	iamp = ampdbfs(p4)
	icps = p5


	ampenv = madsr:a(1, 0.1, 0.95, 0.5)
	asig = vco2(0.5, icps)
	asig = moogladder(asig, 6000, 0.1)

	asig *= ampenv * iamp 

	aL, aR pan2 asig, 0.55

	chnmix aL, "MasterL"
	chnmix aR, "MasterR"

endin

instr 3, SineSynth1

	iamp = ampdbfs(p4)
	icps = p5

	ampenv = madsr:a(1, 0.1, 0.95, 0.5)
	a1 oscil 0.5, icps

	a1 *= ampenv * iamp 

	chnmix a1, "MasterL"
	chnmix a1, "MasterR"

endin


instr 4, SineSynth2

	iamp = ampdbfs(p4)
	icps = p5

	ampenv = madsr:a(1, 0.1, 0.95, 0.5)
	a1 oscil 0.5, icps * 1.5

	a1 *= ampenv * iamp 

	chnmix a1, "MasterL"
	chnmix a1, "MasterR"

endin


instr 99
	#include "includes/adc_channels.inc"
	#include "includes/gpio_channels.inc"
	#include "includes/switch2led.inc"

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

	; Reverb arguments: decay, cutoff, mix
	arvbL, arvbR Reverb aL, aR, 0.85, 0.5, 1 ;gkpot0, gkpot1, gkswitch0
	
	aL ntrpol aL, arvbL, 0.8
	aR ntrpol aR, arvbR, 0.8

	; Lowpass_Stereo arguments: cutoff, resonance
	;aL, aR Lowpass_Stereo aL, aR, gkpot2, gkpot3
*/
	outs aL, aR

endin


</CsInstruments>
<CsScore>
i99 0 86400
</CsScore>
</CsoundSynthesizer>


