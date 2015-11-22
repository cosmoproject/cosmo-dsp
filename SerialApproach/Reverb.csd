
instr Reverb
	gkRev_Decay init 0.85
	gkRev_Cutoff init 7000
	gkRev_Mix init 0.5

/*	
	gkRev_Decay scale gkRev_Decay, 1, 0
	Sfb sprintfk "Reverb Decay: %f", gkRev_Decay
		puts Sfb, gkRev_Decay 
*/

	gaReverbL, gaReverbR reverbsc gaL, gaR, gkRev_Decay, gkRev_Cutoff

	gaL = (gaL * (1-gkRev_Mix)) + (gaReverbL * gkRev_Mix) 
	gaR = (gaR * (1-gkRev_Mix)) + (gaReverbR * gkRev_Mix) 


endin