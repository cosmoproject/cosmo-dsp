<CsoundSynthesizer>
<CsOptions>
-odac:hw:1,0 -d -+rtaudio=ALSA -b128 -B512 -+rtmidi=alsa -Ma -m0
;-odac -iadc0 -Ma
</CsOptions>
<CsInstruments>
sr      = 44100
ksmps  	= 64
0dbfs	= 1
nchnls 	= 2

#include "../Effects/UDOs/Reverb.csd"
#include "../Effects/UDOs/Lowpass.csd"
#include "../Effects/UDOs/SolinaChorus.csd"

instr 999

k1 poscil 1, 1

gkled0 = k1
gkled1 = k1


endin

opcode MarimbaEmulator, a, ii
iAmplitude, iFrequency xin
;iAmplitude = ampdb(iAmplitude)
aEnvelope = transeg:a(iAmplitude, 0.5, -6, 0)
aOut = oscil:a(aEnvelope, iFrequency, -1)
xout aOut
endop

opcode StringSynth, 0, ii

iamp, icps xin


	ampenv = madsr:a(1, 0.1, 0.95, 0.5)
	asig = vco2(0.5, icps)
	asig = moogladder(asig, 6000, 0.1)

	asig *= ampenv * iamp 

	aL, aR pan2 asig, 0.55

	chnmix aL, "MasterL"
	chnmix aR, "MasterR"

endop


opcode SineSynth1, 0, ii

	iamp, icps xin

	ampenv = madsr:a(1, 0.1, 0.95, 0.5)
	a1 oscil 0.5, icps

	a1 *= ampenv * iamp 

	chnmix a1, "MasterL"
	chnmix a1, "MasterR"
endop


instr 1

	iamp ampmidi 0.8
	icps cpsmidi
	kNoteOff = 0; release

	aL init 0
	aR init 0

	if kNoteOff == 0 then
		StringSynth iamp, icps	
		SineSynth1 iamp, icps
		SineSynth1 iamp, icps*1.5
	else
		StringSynth 0, 0			
		SineSynth1 0, 0					
		SineSynth1 0, 0 
	endif 

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
	arvbL, arvbR Reverb aL, aR, gkpot0, gkpot1, gkpot7
	
	aL ntrpol aL, arvbL, 0.8
	aR ntrpol aR, arvbR, 0.8

	; Lowpass_Stereo arguments: cutoff, resonance
	;aL, aR Lowpass_Stereo aL, aR, gkpot2, gkpot3

	outs aL, aR

endin


</CsInstruments>
<CsScore>
i999 0 3
i99 0 86400
</CsScore>
</CsoundSynthesizer>


