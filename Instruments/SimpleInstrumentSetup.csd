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

;#include "UDOs/Monobomb-UDO.csd"
#include "../Effects/UDOs/Reverb.csd"
#include "../Effects/UDOs/Lowpass.csd"
#include "../Effects/UDOs/SolinaChorus.csd"


;#include "Monobomb-inc.csd"

massign 1, 2

instr 10

	icps cpsmidi
	iamp ampmidi 0.8


	a1 oscil iamp, icps

	chnmix a1, "MasterL"
	chnmix a1, "MasterR"
endin

instr 1

	icps cpsmidi
	iamp ampmidi 1

	; How does note on and off register?

	ktrigIns init 1
	instCount = 2
	kinstrnum[] init instCount
	kinstrnum fillarray 2, 3, 4

	if iamp > 0 && ktrigIns == 1 then
		kx = 1
		until kx >= instCount do 
			event "i", kinstrnum[kx-1], 0, -1, iamp, icps
			kx += 1
			printk2 kinstrnum[kx-1]
		od
		ktrigIns = 0
	endif

	krel release 
	if krel == 1 then
		kx = 1
		until kx >= instCount do 
			event "i", -kinstrnum[kx-1], 0, 1, iamp, icps
			kx += 1
		od
	endif
	

endin


instr 2

	;iamp = ampdbfs(p4)
	;ipch = p5

	ipch cpsmidi
	iamp ampmidi 0.8

	ampenv = madsr:a(1, 0.1, 0.95, 0.5)
	asig = vco2(0.5, ipch)
	asig = moogladder(asig, 6000, 0.1)

	asig *= ampenv * iamp 

	aL, aR pan2 asig, 0.55

	chnmix aL, "MasterL"
	chnmix aR, "MasterR"

endin

instr 3

	a1 oscil p4, p5

	;chnmix a1, "MasterL"
	chnmix a1, "MasterR"

endin


instr 4

	a1 oscil p4, p5*1.5

	chnmix a1, "MasterL"
	;chnmix a1, "MasterR"

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

	aL solina_chorus aL, 0.18, 0.6, 6, 0.2
	aR solina_chorus aR, 0.18, 0.6, 6, 0.2

	; Reverb arguments: decay, cutoff, mix
	arvbL, arvbR Reverb aL, aR, 0.85, 0.5, 1 ;gkpot0, gkpot1, gkswitch0
	
	aL ntrpol aL, arvbL, 0.8
	aR ntrpol aR, arvbR, 0.8

	; Lowpass_Stereo arguments: cutoff, resonance
	;aL, aR Lowpass_Stereo aL, aR, gkpot2, gkpot3

	outs aL, aR

endin


</CsInstruments>
<CsScore>
i99 0 86400
</CsScore>
</CsoundSynthesizer>


