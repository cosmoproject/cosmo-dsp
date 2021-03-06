/********************************************************

	Highpass.udo
	Author: Bernt Isak Wærstad

	Arguments: Cutoff_frequency, Resonance, Distortion [, Mode]
    Defaults:  0.8, 0.3, 0 [, 0]

	Cutoff frequency: 20Hz - 19000Hz
	Resonance: 0 - 1.25
	Distortion: 0 - 1

	Optional arguments:
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
    #define Mode #0# 

	; Toggle printing on/off
	#define PRINT #1#

	; Max and minimum values
	#define MAX_FREQ #19000#
	#define MIN_FREQ #20#
	#define MAX_RESO #1.25#
	#define MAX_DIST #1#


;*********************************************************************
; Highpass - 1 in / 1 out
;*********************************************************************

opcode Highpass, a, akkkO
	ain, kfco, kres, kdist, kmode xin

	; ******************************
	; LPF18
	; ******************************

	if kmode == 0 then
	  	; ******************************
	  	; Controller value scalings
	  	; ******************************

		kfco expcurve kfco, 30
		kfco scale kfco, $MAX_FREQ, $MIN_FREQ
		kfco limit kfco, $MIN_FREQ, $MAX_FREQ

		kdist scale kdist, $MAX_DIST, 0
		kres scale kres, $MAX_RESO, 0

		if $PRINT == 1 then
			Sfco sprintfk "HPF Cutoff: %.2f", kfco
				puts Sfco, kfco

			Sres sprintfk "HPF Reso: %.2f", kres
				puts Sres, kres

			Sdist sprintfk "HPF Dist: %.2f", kdist
				puts Sdist, kdist
		endif

		kfco port kfco, 0.1
		kres port kres, 0.01
		kdist port kdist, 0.01

		alowpass lpf18 ain, kfco, kres, kdist
		; Lowpass to highpass
		aout = ain - alowpass

	; ******************************
	; Moogladder
	; ******************************

	elseif kmode == 1 then

		; ******************************
	  	; Controller value scalings
	  	; ******************************

		kfco expcurve kfco, 30
		kfco scale kfco, $MAX_FREQ, $MIN_FREQ
		kfco limit kfco, $MIN_FREQ, $MAX_FREQ

		kres scale kres, $MAX_RESO*25, 0.5

		if $PRINT == 1 then
			Sres sprintfk "HPF Reso: %f", kres
				puts Sres, kres
			Sfco sprintfk "HPF Cutoff: %f", kfco
				puts Sfco, kfco
		endif
		
		kfco port kfco, 0.1
		kres port kres, 0.01
/*
		kdist scale kdist, $MAX_DIST, 0
		if $PRINT == 1 then
			Srev sprintfk "LPF Dist: %f", kdist
				puts Srev, kdist
		endif
		kdist port kdist, 0.01
*/
		alowpass moogladder ain, kfco, kres
		; Add some distortion ??

		; Lowpass to highpass
		aout = ain - alowpass

	; ******************************
	; K35
	; ******************************

	elseif kmode == 2 then

		; ******************************
	  	; Controller value scalings
	  	; ******************************


		kfco expcurve kfco, 30
		kfco scale kfco, $MAX_FREQ, $MIN_FREQ
		kfco limit kfco, $MIN_FREQ, $MAX_FREQ

		kdist scale kdist, $MAX_DIST*10, 1
		kres scale kres, $MAX_RESO*10, 0



		if $PRINT == 1 then
			Sfco sprintfk "HPF Cutoff: %.2f", kfco
				puts Sfco, kfco

			Sres sprintfk "HPF Reso: %.2f", kres
				puts Sres, kres

			Sdist sprintfk "HPF Dist: %.2f", kdist
				puts Sdist, kdist
		endif

		kfco port kfco, 0.1
		kres port kres, 0.01
		kdist port kdist, 0.01

		knonlinear = 1

		aout K35_hpf ain, kfco, kres, knonlinear, kdist

	; ******************************
	; ZDF
	; ******************************

	elseif kmode == 3 then

		; ******************************
	  	; Controller value scalings
	  	; ******************************

		kfco expcurve kfco, 30
		kfco scale kfco, $MAX_FREQ, $MIN_FREQ
		kfco limit kfco, $MIN_FREQ, $MAX_FREQ

		kres scale kres, $MAX_RESO*25, 0.5
		if $PRINT == 1 then
			Sres sprintfk "HPF Reso: %f", kres
				puts Sres, kres
			Sfco sprintfk "HPF Cutoff: %f", kfco
				puts Sfco, kfco
		endif
		
		kfco port kfco, 0.1
		kres port kres, 0.01

/*
		kdist scale kdist, $MAX_DIST, 0
		if $PRINT == 1 then
			Srev sprintfk "LPF Dist: %f", kdist
				puts Srev, kdist
		endif
		kdist port kdist, 0.01
*/

		aout zdf_2pole ain, kfco, kres, 1
		; Add some distortion ??

	endif
	
	aout = 2 * taninv(aout) / 3.1415927 ; limit output

	xout aout
endop
;*********************************************************************
; Highpass - 1 in / 2 out
;*********************************************************************

opcode Highpass, aa, akkkO
	ain, kfco, kres, kdist, kmode xin

	aOutL Highpass ain, kfco, kres, kdist, kmode
	aOutR Highpass ain, kfco, kres, kdist, kmode

	xout aOutL, aOutR

endop

;*********************************************************************
; Highpass - 2 in / 2 out
;*********************************************************************

opcode Highpass, aa, aakkkO
	ainL, ainR, kfco, kres, kdist, kmode xin

	aOutL Highpass ainL, kfco, kres, kdist, kmode
	aOutR Highpass ainR, kfco, kres, kdist, kmode

	xout aOutL, aOutR

endop
