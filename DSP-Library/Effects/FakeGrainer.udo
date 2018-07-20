/********************************************************

	FakeGrainer.csd
	Author: Alex Hofmann
	COSMO UDO adaptation: Bernt Isak Wærstad

	Arguments: Dry/wet mix
    Defaults:  1.0

	Dry/wet mix: 0% - 100%

	Description:
	An effect that sounds like granular synthesis

********************************************************/

	; Default argument values
	#define DryWet_Mix #1#

	; Toggle printing on/off
	#define PRINT #0#

	; Max and minimum values
	#define GRAIN_FREQ #35#
	#define FILTER_FREQ #300#	

;*********************************************************************
; FakeGrainer - 1 in / 1 out
;*********************************************************************

opcode FakeGrainer, a, ak

	ain, kDryWet xin

	kDryWet init $DryWet_Mix

	kDryWet scale kDryWet, 1, 0

	if ($PRINT == 1) then
		Smix sprintfk "FakeGrain Mix: %f", kDryWet
			puts Smix, kDryWet+1
	endif

	aMod lfo 1, $GRAIN_FREQ, 3
	aMod butlp aMod, $FILTER_FREQ

	aGrain = ain * aMod

	aOut ntrpol ain, aGrain, kDryWet

	xout aOut
endop

;*********************************************************************
; FakeGrainer - 1 in / 2 out
;*********************************************************************

opcode FakeGrainer, aa, ak

	ain, kDryWet  xin

	aOutL FakeGrainer ain, kDryWet
	aOutR FakeGrainer ain, kDryWet

	xout aOutL, aOutR

endop

;*********************************************************************
; FakeGrainer - 2 in / 2 out
;*********************************************************************

opcode FakeGrainer, aa, aak

	ainL, ainR, kDryWet  xin

	aOutL FakeGrainer ainL, kDryWet
	aOutR FakeGrainer ainR, kDryWet

	xout aOutL, aOutR

endop

