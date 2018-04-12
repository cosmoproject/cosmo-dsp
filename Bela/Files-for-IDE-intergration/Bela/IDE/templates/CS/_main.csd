<CsoundSynthesizer>
<CsOptions>
-m0d
</CsOptions>
<CsInstruments>
ksmps = 32
nchnls = 2
0dbfs = 1

;------------------------------------------------------
;	Audio in/out and analoge in to control gain
;------------------------------------------------------

	instr 1
		aL, aR ins
		
		kGain init 0.5
		kGain chnget "analogeIn0"
		
		outs aL * kGain,aR * kGain
	endin

;------------------------------------------------------
;	Digital in/out - use a switch to turn an LED 
;	on and off. See comments at bottom for wiring
;------------------------------------------------------
	
	instr 2
		kSwitchPin = 0 
		kLED_Pin = 1
		
		kSwitch digiInBela, kSwitchPin
		digiOutBela kLED_Pin, kSwitch
	endin

</CsInstruments>
<CsScore>
i1 0 86400
i2 0 86400
</CsScore>
</CsoundSynthesizer>
