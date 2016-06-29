;*********************************************************************
; Mono version
;*********************************************************************

opcode Lowpass, a, akkk
	ain, kfco, kres, kdist xin

	kfco expcurve kfco, 30
	kfco scale kfco, 12000, 30
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

	aout lpf18 ain, kfco, kres, kdist
	xout aout
endop


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

;*********************************************************************
; Stereo version
;*********************************************************************

opcode Lowpass, aa, aakkk
	ainL, ainR, kfco, kres, kdist xin

	kfco expcurve kfco, 30
	kfco scale kfco, 12000, 30
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

	aoutL lpf18 ainL, kfco, kres, kdist
	aoutR lpf18 ainR, kfco, kres, kdist

	xout aoutL, aoutR
endop

opcode Lowpass, aa, aakk
	ainL, ainR, kfco, kres xin

	aoutL, aoutR Lowpass ainL, ainR, kfco, kres, 0

	xout aoutL, aoutR
endop

opcode Lowpass, aa, aak
	ainL, ainR, kfco xin

	aoutL, aoutR Lowpass ainL, ainR, kfco, 0.3, 0

	xout aoutL, aoutR
endop

opcode Lowpass, aa, aa
	ainL, ainR xin

	aoutL, aoutR Lowpass ainL, ainR, 0.8, 0.3, 0

	xout aoutL, aoutR
endop

