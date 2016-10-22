opcode Reverb, aa, aakkk
	ainL, ainR, kRev_Decay, kRev_Cutoff, kRev_Mix xin

	kRev_Decay scale kRev_Decay, 1, 0
	Srev sprintfk "Reverb Decay: %f", kRev_Decay
		puts Srev, kRev_Decay+1
	kRev_Decay port kRev_Decay, 0.1


	kRev_Cutoff scale kRev_Cutoff, 12000, 200
	Srev sprintfk "Reverb Cutoff: %f", kRev_Cutoff
		puts Srev, kRev_Cutoff 


	kRev_Mix scale kRev_Mix, 1, 0
	Srev sprintfk "Reverb Mix: %f", kRev_Mix
		puts Srev, kRev_Mix+1 

	kRev_Mix port kRev_Mix, 0.05

	kRev_Decay init 0.85
	kRev_Cutoff init 7000
	kRev_Mix init 0.5

	if (kRev_Mix > 0.1) then
		arevL, arevR reverbsc ainL, ainR, kRev_Decay, kRev_Cutoff

		aoutL ntrpol ainL, arevL, kRev_Mix
		aoutR ntrpol ainR, arevR, kRev_Mix

	else
		aoutL = ainL
		aoutR = ainR
	endif
	
	xout aoutL, aoutR
endop

opcode Reverb, aa, aakk
	ainL, ainR, kRev_Decay, kRev_Cutoff xin

	aoutL, aoutR Reverb ainL, ainR, kRev_Decay, kRev_Cutoff, 0.5

	xout aoutL, aoutR
endop

opcode Reverb, aa, aak
	ainL, ainR, kRev_Decay xin

	aoutL, aoutR Reverb ainL, ainR, kRev_Decay, 0.5, 0.5

	xout aoutL, aoutR
endop

opcode Reverb, aa, aa
	ainL, ainR xin

	aoutL, aoutR Reverb ainL, ainR, 0.85, 0.5, 0.5

	xout aoutL, aoutR
endop
