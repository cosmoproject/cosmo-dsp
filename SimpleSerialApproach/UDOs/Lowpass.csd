opcode Lowpass, a, akkk
	ain, kfco, kres, kdist xin
	kfco scale kfco, 20000, 50
	kfco port kfco, 0.1
	aout lpf18 ain, kfco, kres, kdist
	xout aout
endop

opcode Lowpass, a, akk
	ain, kfco, kres xin
	kfco scale kfco, 20000, 50
	kfco port kfco, 0.1
	aout lpf18 ain, kfco, kres, 0
	xout aout
endop

opcode Lowpass, a, ak
	ain, kfco xin
	kfco scale kfco, 20000, 50
	kfco port kfco, 0.1
	aout lpf18 ain, kfco, 0.8, 0
	xout aout
endop



opcode Lowpass_Stereo, aa, aakkk
	ainL, ainR, kfco, kres, kdist xin
	kfco scale kfco, 20000, 50
	kfco port kfco, 0.1
	aoutL lpf18 ainL, kfco, kres, kdist
	aoutR lpf18 ainR, kfco, kres, kdist

	xout aoutL, aoutR
endop

opcode Lowpass_Stereo, aa, aakk
	ainL, ainR, kfco, kres xin

	kfco expcurve kfco, 30
	kfco scale kfco, 12000, 30
	Srev sprintfk "LPF Cutoff: %f", kfco
		puts Srev, kfco 
	kfco port kfco, 0.1

	kres scale kres, 0.9, 0
	Srev sprintfk "LPF Reso: %f", kres
		puts Srev, kres 
	kres port kres, 0.01

	aoutL lpf18 ainL, kfco, kres, 0
	aoutR lpf18 ainR, kfco, kres, 0

	xout aoutL, aoutR
endop

opcode Lowpass_Stereo, aa, aak
	ainL, ainR, kfco xin

	kfco expcurve kfco, 30
	kfco scale kfco, 12000, 30
	Srev sprintfk "LPF Cutoff: %f", kfco
		puts Srev, kfco 
	kfco port kfco, 0.1

	aoutL lpf18 ainL, kfco, 0.8, 0
	aoutR lpf18 ainR, kfco, 0.8, 0

	xout aoutL, aoutR
endop
