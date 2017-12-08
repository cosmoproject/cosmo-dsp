<CsoundSynthesizer> 
 <CsOptions> 
-odac -iadc -Ma -m0d 
</CsOptions>
<CsInstruments>
 
 sr = 44100 
 ksmps = 64 
 0dbfs	= 1 
 nchnls = 2 
	#include "../DSP-Library/Includes/cosmo_utilities.inc"

	#include "../DSP-Library/Effects/Wobble.csd" 
	#include "../DSP-Library/Effects/RandDelay.csd" 
	#include "../DSP-Library/Effects/Chorus.csd" 
	#include "../DSP-Library/Effects/Reverb.csd" 
	#include "../DSP-Library/Effects/Volume.csd" 

	instr 1

		aL, aR ins

		adlyL = 0
		adlyR = 0


	 	 gkCC23_CH1 ctrl7 1, 23, 0, 1
	 	 gkCC22_CH1 ctrl7 1, 22, 0, 1
	 	 gkCC24_CH1 ctrl7 1, 24, 0, 1
	 	 gkCC21_CH1 ctrl7 1, 21, 0, 1

		aL, aR Wobble aL, aR, gkCC21_CH1, 0.5
		aL, aR RandDelay aL, aR, gkCC23_CH1, gkCC21_CH1, 0.5
		aL, aR Chorus aL, aR, 0.4, gkCC22_CH1
		aL, aR Reverb aL, aR, 0.85, 0.5, gkCC23_CH1
		aL, aR Volume aL, aR, gkCC24_CH1

		aOutL = (aL + adlyL)
		aOutR = (aR + adlyR)

		outs aOutL, aOutR

	endin

</CsInstruments>
<CsScore>
i1 0 86400
</CsScore>
</CsoundSynthesizer>
