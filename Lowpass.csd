#include "Filters/Lowpass.udo"
instr Lowpass
	gkLP_freq init 1500
	gkLP_res init 0.8
	gkLP_dist init 0.5

/*	
	#include "includes/adc_channels.inc"

	gkLP_freq scale gkpot6, 1, 0
	Sfb sprintfk "LP freq: %f", gkLP_freq
		puts Sfb, gkLP_freq 
*/

	gaL, gaR Lowpass_Stereo gaL, gaR, gkLP_freq, gkLP_res, gkLP_dist

	gaLowpassL = gaL
	gaLowpassR = gaR

endin