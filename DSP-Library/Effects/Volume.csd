/********************************************************

	Volume.csd
	Author: Alex Hofmann
	COSMO UDO adaptation: Bernt Isak Wærstad

	Arguments: Level
    Defaults:  0.5

    Level: 0% - 100%

	Description
	Volume leveler 

********************************************************/

opcode Volume, aa, aak

	ainL, ainR, kVol xin

	kVol expcurve kVol, 30
	Srev sprintfk "Volume %f", kVol
		puts Srev, kVol
	kVol port kVol, 0.005

	aOutL = ainL * kVol
	aOutR = ainR * kVol

	xout aOutL, aOutR
endop
