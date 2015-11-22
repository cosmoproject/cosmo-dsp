
instr Delay
	gkDelay_Time init 450 ;ms
	gkDelay_Feed init 0.8
	gkDelay_Mix init 0.5

	aFeedL init 0
	aFeedR init 0
/*	
	gkRev_Decay scale gkRev_Decay, 1, 0
	Sfb sprintfk "Reverb Decay: %f", gkRev_Decay
		puts Sfb, gkRev_Decay 
*/

	kdlytime port gkDelay_Time, 0.1
	adlytime interp kdlytime
	adlytime tone adlytime, 50 ;?? Test this value


	gaDelayL vdelay3 gaL + aFeedL, adlytime*0.99, 1500
	gaDelayR vdelay3 gaR + aFeedR, adlytime*1.01, 1500

	; Cross feeding
	aFeedL = (gaDelayL * gkDelay_Feed * 0.7) + (gaDelayR * gkDelay_Feed * 0.3)
	aFeedR = (gaDelayR * gkDelay_Feed * 0.7) + (gaDelayL * gkDelay_Feed * 0.3)

	; Low pass feedback
	aFeedL tone aFeedL, 4500
	aFeedR tone aFeedR, 4300

	gaL = (gaL * sqrt(1-gkDelay_Mix)) + (gaDelayL * sqrt(gkDelay_Mix))
	gaR = (gaR * sqrt(1-gkDelay_Mix)) + (gaDelayR * sqrt(gkDelay_Mix)) 



endin