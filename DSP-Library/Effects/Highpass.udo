
/********************************************************

	Highpass.udo
	Author: Bernt Isak Wærstad

	Arguments: Cutoff_frequency, Resonance, Distortion
    Defaults:  0.8, 0.3, 0

	Cutoff frequency: 30Hz - 12000Hz
	Resonance: 0 - 0.9
	Distortion: 0 - 0.9
	Mode:
		0: lpf18 
		1: moogladder
		2: k35
		3: zdf

	Description:
	Resonant highpass filters (some with distortion)

********************************************************/

	; Default argument values
	#define Cutoff_frequency #0.8# 
	#define Resonance #0.3#
	#define Distortion #0#

;*********************************************************************
; Highpass - 1 in / 1 out
;*********************************************************************

opcode Highpass, a, akkkk 

	ain, kfco, kres, kdist, kmode xin

	#include "Lowpass.udo"

	; TODO: Scale and print frequency correctly for highpass 

	alowpass Lowpass ain, kfco, kres, kdist, kmode

	; Lowpass to highpass 
	aout = ain - alowpass

	xout aout 

endop

;*********************************************************************
; Highpass - '' in / 2 out
;*********************************************************************

opcode Highpass, a, aakkk

	ain, kfco, kres, kdist, kmode xin

	aOutL Highpass ain, kfco, kres, kdist, kmode
	aOutR Highpass ain, kfco, kres, kdist, kmode

	xout aOutL, aOutR

endop

;*********************************************************************
; Highpass - 2 in / 2 out
;*********************************************************************

opcode Highpass, aa, aakkk

	ainL,ainR, kfco, kres, kdist, kmode xin

	aOutL Highpass ainL, kfco, kres, kdist, kmode
	aOutR Highpass ainR, kfco, kres, kdist, kmode

	xout aOutL, aOutR

endop

