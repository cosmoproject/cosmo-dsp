<CsoundSynthesizer>
<CsOptions>
-odac 
</CsOptions>
<CsInstruments>
sr      = 44100
ksmps  	= 128
0dbfs	= 1
nchnls 	= 2

opcode TestUDO, k, kP 

	k1, koptional xin

	koptional init 84

	printk 1, k1
	printk 1, koptional, 10

	xout k1

endop


instr 1 

	kdummy TestUDO 42

endin


</CsInstruments>
<CsScore>
i1 0 4
</CsScore>
</CsoundSynthesizer>

	