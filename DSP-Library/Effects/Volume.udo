/********************************************************

	Volume.csd
	Author: Alex Hofmann
	COSMO UDO adaptation: Bernt Isak Wærstad

	Arguments: Level
    Defaults:  1

    Level: 0% - 100%

	Description
	Volume leveler 

********************************************************/

	; Default argument values
	#define Level #1# 

	; Toggle printing on/off
	#define PRINT #0#

	; Max and minimum values
	#define MAX_VOL #1#

;*********************************************************************
; Volume - 1 in / 1 out
;*********************************************************************

opcode Volume, a, ak

	ain, kVol xin

	kVol expcurve kVol, 30

	if ($PRINT == 1) then
		Svol sprintfk "Volume %f", kVol
			puts Svol, kVol
	endif

	kVol port kVol, 0.005

	aOut = ain * kVol

	xout aOut
endop

;*********************************************************************
; Volume - 1 in / 2 out
;*********************************************************************

opcode Volume, aa, ak

	ain, kVol xin

	aOutL, aOutR Volume ain, kVol

	xout aOutL, aOutR

endop

;*********************************************************************
; Volume - 2 in / 2 out
;*********************************************************************

opcode Volume, aa, aak

	ainL, ainR, kVol xin

	aOutL Volume ainL, kVol
	aOutR Volume ainR, kVol

	xout aOutL, aOutR

endop
