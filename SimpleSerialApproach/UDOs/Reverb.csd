opcode Reverb, aa, aakkk
	ainL, ainR, kRev_Decay, kRev_Cutoff, kRev_Mix xin

	kRev_Decay scale kRev_Decay, 1, 0
	Srev sprintfk "Reverb Decay: %f", kRev_Decay
		puts Srev, kRev_Decay+1


	kRev_Cutoff scale kRev_Cutoff, 20000, 200
	Srev sprintfk "Reverb Cutoff: %f", kRev_Cutoff
		puts Srev, kRev_Cutoff 


	kRev_Mix scale kRev_Mix, 1, 0
	Srev sprintfk "Reverb Mix: %f", kRev_Mix
		puts Srev, kRev_Mix+1 


	kRev_Decay init 0.85
	kRev_Cutoff init 7000
	kRev_Mix init 0.5

	arevL, arevR reverbsc ainL, ainR, kRev_Decay, kRev_Cutoff
	aoutL = (ainL * (1-kRev_Mix)) + (arevL * kRev_Mix) 
	aoutR = (ainR * (1-kRev_Mix)) + (arevR * kRev_Mix) 
	xout aoutL, aoutR
endop

opcode Reverb, aa, aakk
	ainL, ainR, kRev_Decay, kRev_Cutoff xin

	kRev_Mix = 0.5

	kRev_Decay scale kRev_Decay, 1, 0
	Srev sprintfk "Reverb Decay: %f", kRev_Decay
		puts Srev, kRev_Decay+1


	kRev_Cutoff scale kRev_Cutoff, 20000, 200
	Srev sprintfk "Reverb Cutoff: %f", kRev_Cutoff
		puts Srev, kRev_Cutoff 


	kRev_Mix scale kRev_Mix, 1, 0
	Srev sprintfk "Reverb Mix: %f", kRev_Mix
		puts Srev, kRev_Mix+1 


	kRev_Decay init 0.85
	kRev_Cutoff init 7000
	kRev_Mix init 0.5

	arevL, arevR reverbsc ainL, ainR, kRev_Decay, kRev_Cutoff
	aoutL = (ainL * (1-kRev_Mix)) + (arevL * kRev_Mix) 
	aoutR = (ainR * (1-kRev_Mix)) + (arevR * kRev_Mix) 
	xout aoutL, aoutR
endop

opcode Reverb, aa, aak
	ainL, ainR, kRev_Decay xin

	kRev_Cutoff = 0.4
	kRev_Mix = 0.5

	kRev_Decay scale kRev_Decay, 1, 0
	Srev sprintfk "Reverb Decay: %f", kRev_Decay
		puts Srev, kRev_Decay+1


	kRev_Cutoff scale kRev_Cutoff, 20000, 200
	Srev sprintfk "Reverb Cutoff: %f", kRev_Cutoff
		puts Srev, kRev_Cutoff 


	kRev_Mix scale kRev_Mix, 1, 0
	Srev sprintfk "Reverb Mix: %f", kRev_Mix
		puts Srev, kRev_Mix+1 


	kRev_Decay init 0.85
	kRev_Cutoff init 7000
	kRev_Mix init 0.5

	arevL, arevR reverbsc ainL, ainR, kRev_Decay, kRev_Cutoff
	aoutL = (ainL * (1-kRev_Mix)) + (arevL * kRev_Mix) 
	aoutR = (ainR * (1-kRev_Mix)) + (arevR * kRev_Mix) 
	xout aoutL, aoutR
endop


opcode Reverb, aa, aa
	ainL, ainR xin

	kRev_Decay = 0.85
	kRev_Cutoff = 0.4
	kRev_Mix = 0.5

	kRev_Decay scale kRev_Decay, 1, 0
	Srev sprintfk "Reverb Decay: %f", kRev_Decay
		puts Srev, kRev_Decay+1


	kRev_Cutoff scale kRev_Cutoff, 20000, 200
	Srev sprintfk "Reverb Cutoff: %f", kRev_Cutoff
		puts Srev, kRev_Cutoff 


	kRev_Mix scale kRev_Mix, 1, 0
	Srev sprintfk "Reverb Mix: %f", kRev_Mix
		puts Srev, kRev_Mix+1 


	kRev_Decay init 0.85
	kRev_Cutoff init 7000
	kRev_Mix init 0.5

	arevL, arevR reverbsc ainL, ainR, kRev_Decay, kRev_Cutoff
	aoutL = (ainL * (1-kRev_Mix)) + (arevL * kRev_Mix) 
	aoutR = (ainR * (1-kRev_Mix)) + (arevR * kRev_Mix) 
	xout aoutL, aoutR
endop





	