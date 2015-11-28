opcode Lowpass, a, akkk
	ain, kfco, kres, kdist xin
	aout lpf18 ain, kfco, kres, kdist
	xout aout
endop

opcode Lowpass, a, akk
	ain, kfco, kres xin
	aout lpf18 ain, kfco, kres, 0
	xout aout
endop

opcode Lowpass, a, ak
	ain, kfco xin
	aout lpf18 ain, kfco, 0.8, 0
	xout aout
endop



opcode Lowpass_Stereo, aa, aakkk
	ainL, ainR, kfco, kres, kdist xin
	aoutL lpf18 ainL, kfco, kres, kdist
	aoutR lpf18 ainR, kfco, kres, kdist

	xout aoutL, aoutR
endop

opcode Lowpass_Stereo, aa, aakk
	ainL, ainR, kfco, kres xin
	aoutL lpf18 ainL, kfco, kres, 0
	aoutR lpf18 ainR, kfco, kres, 0

	xout aoutL, aoutR
endop

opcode Lowpass_Stereo, aa, aak
	ainL, ainR, kfco xin
	aoutL lpf18 ainL, kfco, 0.8, 0
	aoutR lpf18 ainR, kfco, 0.8, 0

	xout aoutL, aoutR
endop
