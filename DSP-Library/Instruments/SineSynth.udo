/********************************************************

	SineSynth.csd
	Author: Bernt Isak Wærstad

	Arguments: Attack, Release
    Defaults: 0.1, 0.5

    Attack: 0.01s - 3s
    Release: 0.01s - 5s

	Description:
	A sine based synth

********************************************************/

opcode SineSynth, aa, aaiikk
	aL, aR, iamp, icps, katt, krel xin

	katt scale katt, 3, 0.1
	krel scale krel, 5, 0.1

	iatt = i(katt)
	irel = i(krel)

	kampenv = madsr:k(iatt, 0.1, 0.95, irel)
	a1 poscil 0.5, icps * 1.5 
	a2 poscil 0.3, icps * 2
	a3 poscil 0.2, icps * 3
	a4 poscil 0.1, icps * 5

	a1 *= kampenv * iamp 

	a1_L, a1_R pan2 a1, 0.45

	xout aL + a1_L, aR + a1_R

endop
