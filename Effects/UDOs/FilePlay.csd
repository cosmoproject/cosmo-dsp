/********************************************************

	FilePlay.csd
	Author: Joachim Heintz

	Arguments: Filename, Playback speed[, Start offset, Loop on/off]

	Last two arguments are optional

	A file player that gives stereo output regardless your soundfile is mono or stereo

********************************************************/


opcode FilePlay, aa, Skoo		
	Sfil, kspeed, iskip, iloop	xin
	ichn		filenchnls	Sfil
	if ichn == 1 then
		aL		diskin2	Sfil, kspeed, iskip, iloop
		aR		=		aL
	else
		aL, aR	diskin2	Sfil, kspeed, iskip, iloop
	endif
		xout		aL, aR
endop