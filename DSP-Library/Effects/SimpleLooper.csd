/********************************************************

	SimpleLooper.csd
	Author: Bernt Isak Wærstad

	Arguments: Record/Play, Stop/start, Speed, Reverse, Audio Through
    Defaults:  0, 0, 0.5, 0, 1

	Description:

	A simple looper with speed control, but without overdub

		* Record/Play: 0 - 1 (Send a 1 to start recording, send a 1 again to 
							  stop recording and start playing the loop)
		* Stop/start: 0 - 1 (Toggles between loop stopped and loop playing)
		* Speed: 0x - 2x (Loop playback speed)
		* Reverse: 0 - 1 (Toggles normal and reverse playback)
		* Audio Through: 0 - 1 (Toggles audio coming through or not)


********************************************************/


	; empty table, size 882000 equals 20 seconds at 44.1kHz sr
	giLiveSamplTableLen 	init 882000;

;*********************************************************************
; SimpleLooper
;*********************************************************************
	opcode SimpleLooper, aakk, aakkkkk

	ainL, ainR, kRecPlayOvr, kStopStart, kSpeed, kReverse, kThrough xin

		kStopStart	init 0
		kPlaying 	init 0
	  	kOverdub init 0

	  	iLiveSamplAudioTableL ftgen 0, 0, giLiveSamplTableLen, 2, 0
	  	iLiveSamplAudioTableR ftgen 0, 0, giLiveSamplTableLen, 2, 0


	  	kSpeed 		init 0.5
	  	kReverse 	init 1 ; -1 or 1


		kReverse scale kReverse, 1, -1
	 	Srev sprintfk "Reverse on/off %d", kReverse
	 		puts Srev, kReverse + 1 


	 	kSpeed scale kSpeed, 2, 0
	 	kSpeed = kSpeed * kReverse
	 	Sspeed sprintfk "Loop speed %f", kSpeed
	 		puts Sspeed, kSpeed + 1 
	 	kSpeed port kSpeed, 0.05


		Srec sprintfk "Recording: %f", kRecPlayOvr
		   puts Srec, kRecPlayOvr+1


		kndx init 0
		kndx 	= trigger(kRecPlayOvr,0.5,0) == 1 ? 0 : kndx
		if kRecPlayOvr == 1 then

	        	tablew	ainL/0dbfs,a(kndx),iLiveSamplAudioTableL
	        	tablew	ainR/0dbfs,a(kndx),iLiveSamplAudioTableR
	        kndx	+=	ksmps
		endif

		kLength	= kndx


	    kRestart	trigger	kRecPlayOvr,0.5,1	; if switched to 'play'

	    if kRestart == 1 then
	    	kPlaying = 1
	    	;chnset kStopStart, "stopstart"
	    endif

	    if (changed(kStopStart) == 1) then
	    	kPlaying = (kPlaying + 1) %2
	    endif


		if (kRecPlayOvr == 0  && kPlaying == 1)  then

			Srec sprintfk "Playing: %f", kStopStart
				puts Srec, kStopStart+1

			; 1 over table length in seconds to get appropriate speed for phasor
			kreadFreq divz kSpeed, (kLength/sr), 0.0000001

			if kRestart == 1 then			; Restart loop playback from the beginning if play is retriggered
				 reinit RESTART_PLAYBACK
			endif
		RESTART_PLAYBACK:
		  	aPlayIdx    phasor  kreadFreq
		  	aLoopLen	interp kLength
		  	aPlayIdx	= aPlayIdx*aLoopLen

		  	aoutL tablei aPlayIdx, iLiveSamplAudioTableL
		 	aoutR tablei aPlayIdx, iLiveSamplAudioTableR


		else
		 	aoutL = 0
			aoutR = 0
		endif

		if kThrough == 1 then
			aoutL = aoutL + ainL
			aoutR = aoutR + ainR
		endif


	xout	aoutL, aoutR, kRecPlayOvr, kPlaying

	endop
;*********************************************************************



