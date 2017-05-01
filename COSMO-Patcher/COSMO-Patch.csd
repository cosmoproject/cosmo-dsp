<CsoundSynthesizer>
<CsOptions>
;-odac:hw:2,0 -iadc:hw:2 -d -+rtaudio=ALSA -b128 -B512 -j1 -+rtmidi=alsa -Ma
-odac -iadc -Ma -m0d ;-+rtmidi=coremidi -Ma ;Mac OSX 10.12.2
;-odac:hw:0,0 -iadc:hw:0 -d -+rtaudio=ALSA -b128 -B512 -j1 -+rtmidi=alsa -Ma ;ubuntu
;-n -d -+rtmidi=NULL -M0 -m0d
</CsOptions>
<CsInstruments>

	sr      = 44100
	ksmps  	= 64
	0dbfs	= 1
	nchnls 	= 2

 
	#include "../DSP-Library/Includes/cosmo_utilities.inc"

	#include "../DSP-Library/Effects/Lowpass.csd" 
	#include "../DSP-Library/Effects/RandDelay.csd" 
	#include "../DSP-Library/Effects/Reverb.csd" 

	instr 1

		aL, aR ins

		adlyL = 0
		adlyR = 0


	 	gkswitch0 chnget "M0"
	 	gkswitch1 chnget "M1"
	 	gkswitch2 chnget "M2"
	 	gkswitch3 chnget "M3"
	 	gkswitch4 chnget "M4"
	 	gkswitch5 chnget "M5"
	 	gkswitch6 chnget "M6"
	 	gkswitch7 chnget "M7"
	 	
	 	gktoggle0 chnget "T0"
	 	gktoggle1 chnget "T1"
	 	gktoggle2 chnget "T2"
	 	gktoggle3 chnget "T3"
	 	gktoggle4 chnget "T4"
	 	gktoggle5 chnget "T5"
	 	gktoggle6 chnget "T6"
	 	gktoggle7 chnget "T7"
	 	
	 	gkled0 init 0
	 	gkled1 init 0
	 	gkled2 init 0
	 	gkled3 init 0
	 	gkled4 init 0
	 	gkled5 init 0
	 	gkled6 init 0
	 	gkled7 init 0
	 	
	 	chnset gkled0, "L0"
	 	chnset gkled1, "L1"
	 	chnset gkled2, "L2"
	 	chnset gkled3, "L3"
	 	chnset gkled4, "L4"
	 	chnset gkled5, "L5"
	 	chnset gkled6, "L6"
	 	chnset gkled7, "L7"
	 	
	 	gkpot0 chnget "P0"
	 	gkpot1 chnget "P1"
	 	gkpot2 chnget "P2"
	 	gkpot3 chnget "P3"
	 	gkpot4 chnget "P4"
	 	gkpot5 chnget "P5"
	 	gkpot6 chnget "P6"
	 	gkpot7 chnget "P7"
	 	
	 	
		aL, aR Lowpass aL, aR, gkpot0, 0.3, 0.0
		aL, aR RandDelay aL, aR, gkpot2, gkpot0, gkpot1
		aL, aR Reverb aL, aR, 0.85, 0.5, gkpot2

		aOutL = (aL + adlyL)
		aOutR = (aR + adlyR)

		outs aOutL, aOutR

	endin

</CsInstruments>
<CsScore>
i1 0 86400
</CsScore>
</CsoundSynthesizer>
