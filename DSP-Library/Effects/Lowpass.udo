/********************************************************

	Lowpass.udo
	Author: Bernt Isak Wærstad

	Arguments: Cutoff frequency, Resonance, Distortion [, Mode]
    Defaults:  0.8, 0.3, 0, 0

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
	A resonant lowpass filter (some with distortion)

********************************************************/

	; Default argument values
	#define Cutoff_frequency #0.8#
	#define Resonance #0.3#
	#define Distortion #0#

	; Toggle printing on/off
	#define PRINT #1#

	; Max and minimum values
	#define MAX_FREQ #19000#
	#define MIN_FREQ #20#
	#define MAX_RESO #1.25#
	#define MAX_DIST #1#


;*********************************************************************
; Lowpass - 1 in / 1 out
;*********************************************************************

opcode Lowpass, a, akkkO
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
			Sfco sprintfk "LPF Cutoff: %f", kfco
				puts Sfco, kfco

			Sres sprintfk "LPF Reso: %f", kres
				puts Sres, kres

			Sdist sprintfk "LPF Dist: %f", kdist
				puts Sdist, kdist
		endif

		kfco port kfco, 0.1
		kres port kres, 0.01
		kdist port kdist, 0.01

		aout lpf18 ain, kfco, kres, kdist

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

		kres scale kres, $MAX_RESO, 0

		if $PRINT == 1 then
			Sfco sprintfk "LPF Cutoff: %f", kfco
				puts Sfco, kfco

			Sres sprintfk "LPF Reso: %f", kres
				puts Sres, kres
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
		aout moogladder ain, kfco, kres
		; Add some distortion ??

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
		kres scale kres, $MAX_RESO*10, 0
		kdist scale kdist, $MAX_DIST*10, 1

		if $PRINT == 1 then
			Sfco sprintfk "LPF Cutoff: %f", kfco
				puts Sfco, kfco

			Sres sprintfk "LPF Reso: %f", kres
				puts Sres, kres

			Sdist sprintfk "LPF Dist: %f", kdist
				puts Sdist, kdist
		endif

		kfco port kfco, 0.1
		kres port kres, 0.01
		kdist port kdist, 0.01

		knonlinear = 1

		aout K35_lpf ain, kfco, kres, knonlinear, kdist

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
			Sfco sprintfk "LPF Cutoff: %f", kfco
				puts Sfco, kfco

			Sres sprintfk "LPF Reso: %f", kres
				puts Sres, kres
		endif

		kres port kres, 0.01
		kfco port kfco, 0.1
/*
		kdist scale kdist, $MAX_DIST, 0
		if $PRINT == 1 then
			Srev sprintfk "LPF Dist: %f", kdist
				puts Srev, kdist
		endif
		kdist port kdist, 0.01
*/

		aout zdf_2pole ain, kfco, kres
		; Add some distortion ??

	endif

	aout = 2 * taninv(aout) / 3.1415927 ; limit output

	xout aout
endop


;*********************************************************************
; Lowpass - 1 in / 2 out
;*********************************************************************

opcode Lowpass, aa, akkkO
	ain, kfco, kres, kdist, kmode xin

	aoutL Lowpass ain, kfco, kres, kdist, kmode
	aoutR Lowpass ain, kfco, kres, kdist, kmode

	xout aoutL, aoutR
endop


;*********************************************************************
; Lowpass - 2 in / 2 out
;*********************************************************************

opcode Lowpass, aa, aakkkO
	ainL, ainR, kfco, kres, kdist, kmode xin

	aoutL Lowpass ainL, kfco, kres, kdist, kmode
	aoutR Lowpass ainR, kfco, kres, kdist, kmode

	xout aoutL, aoutR
endop


;*********************************************************************
; Lowpass - 1 in / 1 out - Optional, named arguemnts
;*********************************************************************

opcode Lowpass, a, aS[]k[]
   	ain, Snames[], kvalues[] xin

    ifco init -1
    ires init -1
    idist init -1
	imode init -1

    kfco init $Cutoff_frequency
    kres init $Resonance
    kdist init $Distortion
	kmode init 0

    icnt = 0
    while icnt < lenarray(Snames) do
        if strcmp("cutoff",Snames[icnt]) == 0 then
            ifco = icnt
        elseif strcmp("resonance",Snames[icnt]) == 0 then
            ires = icnt
        elseif strcmp("distortion",Snames[icnt]) == 0 then
            idist = icnt
        elseif strcmp("mode",Snames[icnt]) == 0 then
            imode = icnt
        endif
        icnt += 1
    od

    if ifco >= 0 then
        kfco = kvalues[ifco]
    endif

    if ires >= 0 then
        kres = kvalues[ires]
    endif

    if idist >= 0 then
        kdist = kvalues[idist]
    endif

	if imode >= 0 then
		kmode = kvalues[imode]
	endif

	aout Lowpass ain, kfco, kres, kdist, kmode

	xout aout

endop



;*********************************************************************
; Lowpass - 1 in / 2 out - Optional, named arguemnts
;*********************************************************************

opcode Lowpass, aa, aS[]k[]
	ain, Snames[], kValues[] xin

	aoutL Lowpass ain, Snames, kValues
	aoutR Lowpass ain, Snames, kValues

	xout aoutL, aoutR
endop


;*********************************************************************
; Lowpass - 2 in / 2 out - Optional, named arguemnts
;*********************************************************************

opcode Lowpass, aa, aaS[]k[]
	ainL, ainR, Snames[], kValues[] xin

	aoutL Lowpass ainL, Snames, kValues
	aoutR Lowpass ainR, Snames, kValues

	xout aoutL, aoutR
endop
