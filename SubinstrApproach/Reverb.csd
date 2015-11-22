
instr Reverb

	kRev_Mix init 0.5
	kRev_Decay init 0.85
	kRev_Cutoff init 7000

	kRev_Mix = p5
	kRev_Decay = p6 
	kRev_Cutoff = p7

	SchnName strget p4
	Sleft sprintf "%s_L", SchnName
	Sright sprintf "%s_R", SchnName

	aL chnget Sleft
	aR chnget Sright

	aReverbL, aReverbR reverbsc aL, aR, kRev_Decay, kRev_Cutoff

	aOutL = (aL * (1-kRev_Mix)) + (aReverbL * kRev_Mix) 
	aOutR = (aR * (1-kRev_Mix)) + (aReverbR * kRev_Mix) 

a0 = 0
	chnset a0, Sleft
	chnset a0, Sright

	outs aOutL, aOutR

endin