/* ----------------------------------------------------
	SquareMod.csd
	Author: Alex Hofmann
	COSMO UDO adaptaion: Bernt Isak Wærstad

	Arguments: Frequency, Mix
    Defaults:  0.8, 0.5

---------------------------------------------------- */

opcode MykLinExp, k, kiiii
	kInValue, iInLow ,iInHigh, iOutLow, iOutHigh xin


	kBase = (iOutHigh/iOutLow)
	kPow = ((kInValue-iInLow)/(iInHigh-iInLow))
	kOutputExpValue pow kBase, kPow


	xout kOutputExpValue*iOutLow
endop

opcode SquareMod, aa, aakk
	ainL, ainR, kFreq, kMix xin


	kFreq MykLinExp kFreq, 0, 1, 0.5, 45
	Srev sprintfk "Freq: %f", kFreq

	kMix scale kMix, 1, 0
	Srev sprintfk "SquareMod Mix: %f", kMix
		puts Srev, kMix+1

	kMix init 0.5
	kFreq init 25


	aMod lfo 1, kFreq, 3
	aMod butlp aMod, 300
	aFXL = ainL * aMod
	aFXR = ainR * aMod


	aoutL = (ainL * (1-kMix)) + (aFXL * kMix)
	aoutR = (ainR * (1-kMix)) + (aFXR * kMix)
	xout aoutL, aoutR
endop
