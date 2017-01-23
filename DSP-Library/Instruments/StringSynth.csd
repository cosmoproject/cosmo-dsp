/********************************************************

	SineSynth.csd
	Based on code by Steven Yi
	Author: Bernt Isak Wærstad

	Arguments: Attack, Release
    Defaults: 0.1, 0.5

    Attack: 0.1s - 3s
    Release: 0.1s - 5s

	Description:
	A saw based string synth

********************************************************/



opcode StringSynth, aa, aaiikk
	aL, aR, iamp, icps, katt, krel xin

	katt scale katt, 3, 0.1
	krel scale krel, 5, 0.1

	iatt = i(katt)
	irel = i(krel)

	kampenv = madsr:k(iatt, 0.1, 0.95, irel)
	asig = vco2(0.5, icps)
	asig = moogladder2(asig, 6000, 0.1)

	asig *= kampenv * iamp 

	asig_L, asig_R pan2 asig, 0.55

	aL += asig_L
	aR += asig_R

	; SolinaChorus arguments: lfo1-freq, lfo1-amp, lfo2-freq, lfo2-amp dry/wet
	aL SolinaChorus aL, 0.18, 0.6, 6, 0.2, 1
	aR SolinaChorus aR, 0.18, 0.6, 6, 0.2, 1

	xout aL, aR

endop

/*
instr StringSynth

	iamp = ampdbfs(p4)
	icps = p5


	Sprint sprintfk "Starting instrument 2: %f", icps
		puts Sprint, k(icps)


	kampenv = madsr:k(1, 0.1, 0.95, 0.5)
	asig = vco2(0.5, icps)
	asig = moogladder2(asig, 6000, 0.1)

	asig *= kampenv * iamp 

	aL, aR pan2 asig, 0.55

	; SolinaChorus arguments: lfo1-freq, lfo1-amp, lfo2-freq, lfo2-amp dry/wet
	aL SolinaChorus aL, 0.18, 0.6, 6, 0.2, 1
	aR SolinaChorus aR, 0.18, 0.6, 6, 0.2, 1


	chnmix aL, "MasterL"
	chnmix aR, "MasterR"

endin
*/