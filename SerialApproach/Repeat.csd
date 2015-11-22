
giSquare	ftgen	0, 0, 4097, 7, 1, 2048, 1, 0, -1, 2048, -1

instr Repeat
	gkRepeat_Speed init 0.8
	gkRepeat_Mix init 0.5

;giSquare	ftgen	0, 0, 4097, 7, 1, 2048, 1, 0, -1, 2048, -1,

/*	
	gkRev_Decay scale gkRev_Decay, 1, 0
	Sfb sprintfk "Reverb Decay: %f", gkRev_Decay
		puts Sfb, gkRev_Decay 
*/

	kFeedback metro 0.5
	;kFeedback oscil 1, 0.1, giSquare
	aWetLRepeat init 0.0

	gkRepeat_Mix scale gkRepeat_Mix, 0.5, 0.1
	aRange tone a(gkRepeat_Mix), 2

	iFadetime = 0.01
	aInVol linseg 0, iFadetime, 1
	aDelayL delayr 1
	aWetLRepeat deltapi aRange		
				delayw (gaL+(aWetLRepeat*kFeedback)) * aInVol	

	gaRepeatL = aWetLRepeat
	gaRepeatR = aWetLRepeat


	gaL = (gaL * sqrt(1-gkRepeat_Mix)) + (gaRepeatL * sqrt(gkRepeat_Mix)) 
	gaR = (gaR * sqrt(1-gkRepeat_Mix)) + (gaRepeatR * sqrt(gkRepeat_Mix)) 


endin