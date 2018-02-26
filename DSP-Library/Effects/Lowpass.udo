
/********************************************************

	Lowpass.udo
	Author: Bernt Isak Wærstad

	Arguments: Cutoff frequency, Resonance, Distortion
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
	A resonant lowpass filter with distortion

********************************************************/

	; Default argument values

	#define Cutoff_frequency #0.8# 
	#define Resonance #0.3#
	#define Distortion #0#

;*********************************************************************
; Lowpass - Mono
;*********************************************************************

opcode Lowpass, a, akkkk
	ain, kfco, kres, kdist, kmode xin

	if kmode == 0 then 
	  	; ******************************
	  	; Controller value scalings
	  	; ******************************

		kfco expcurve kfco, 30
		kfco scale kfco, 20000, 30
		Srev sprintfk "LPF Cutoff: %f", kfco
			puts Srev, kfco
		kfco port kfco, 0.1

		kres scale kres, 0.9, 0
		Srev sprintfk "LPF Reso: %f", kres
			puts Srev, kres
		kres port kres, 0.01

		kdist scale kdist, 0.9, 0
		Srev sprintfk "LPF Dist: %f", kdist
			puts Srev, kdist
		kdist port kdist, 0.01

		; ******************************
		; LPF18
		; ******************************

		aout lpf18 ain, kfco, kres, kdist
	
	elseif kmode == 1 then

		; ******************************
	  	; Controller value scalings
	  	; ******************************

		kfco expcurve kfco, 30
		kfco scale kfco, 20000, 30
		Srev sprintfk "LPF Cutoff: %f", kfco
			puts Srev, kfco
		kfco port kfco, 0.1

		kres scale kres, 0.9, 0
		Srev sprintfk "LPF Reso: %f", kres
			puts Srev, kres
		kres port kres, 0.01

/*
		kdist scale kdist, 0.9, 0
		Srev sprintfk "LPF Dist: %f", kdist
			puts Srev, kdist
		kdist port kdist, 0.01
*/
		; ******************************
		; Moogladder
		; ******************************

		aout moogladder ain, kfco, kres
		; Add some distortion ??

	elseif kmode == 2 then
/*
		; ******************************
	  	; Controller value scalings
	  	; ******************************

		kfco expcurve kfco, 30
		kfco scale kfco, 20000, 30
		Srev sprintfk "LPF Cutoff: %f", kfco
			puts Srev, kfco
		kfco port kfco, 0.1

		kres scale kres, 0.9, 0
		Srev sprintfk "LPF Reso: %f", kres
			puts Srev, kres
		kres port kres, 0.01

		kdist scale kdist, 0.9, 0
		Srev sprintfk "LPF Dist: %f", kdist
			puts Srev, kdist
		kdist port kdist, 0.01

		; ******************************
		; k35
		; ******************************

		aout k35 ain, kfco, kres
		; Add some distortion ??

	elseif kmode == 3 then

		; ******************************
	  	; Controller value scalings
	  	; ******************************

		kfco expcurve kfco, 30
		kfco scale kfco, 20000, 30
		Srev sprintfk "LPF Cutoff: %f", kfco
			puts Srev, kfco
		kfco port kfco, 0.1

		kres scale kres, 0.9, 0
		Srev sprintfk "LPF Reso: %f", kres
			puts Srev, kres
		kres port kres, 0.01

		kdist scale kdist, 0.9, 0
		Srev sprintfk "LPF Dist: %f", kdist
			puts Srev, kdist
		kdist port kdist, 0.01

		; ******************************
		; ZDF
		; ******************************

		aout zdf ain, kfco, kres
		; Add some distortion ??
*/
	endif

	xout aout
endop



/*
opcode Lowpass, a, akk
	ain, kfco, kres xin

	aout Lowpass ain, kfco, kres, 0

	xout aout
endop

opcode Lowpass, a, ak
	ain, kfco  xin

	aout Lowpass ain, kfco, 0.3, 0

	xout aout
endop

opcode Lowpass, a, a
	ain xin

	aout Lowpass ain, 0.8 , 0.3, 0

	xout aout
endop

*/ 

;*********************************************************************
; Lowpass - Stereo
;*********************************************************************

opcode Lowpass, aa, aakkkk
	ainL, ainR, kfco, kres, kdist, kmode xin

	aoutL Lowpass ainL, kfco, kres, kdist, kmode
	aoutR Lowpass ainR, kfco, kres, kdist, kmode

	xout aoutL, aoutR
endop


