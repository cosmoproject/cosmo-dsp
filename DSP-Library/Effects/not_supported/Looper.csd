
/********************************************************

	EXPERIMENTAL!

	Looper.csd
	Author: Bernt Isak Wærstad

	Arguments: Record/Play/Overdub, Stop/start, Clear, Speed, Reverse, Audio Through, Octave Down, Octave Up
    Defaults:  0, 0, 0, 1, 0, 1, 0, 0
    Output arguments: Record/Play/Overdub, Playing
    Defaults: 0, 0


	Description:
	A looper with overdub (not properly implemented)
	
		* Record/Play: Send a 1 to start recording, send a 1 again to stop recording and start playing the loop
		* Stop/start: Toggles between loop stopped and loop playing
		* Clear: Not implemented
		* Speed: Loop playback speed
		* Reverse: Toggles normal and reverse playback
		* Audio Through: Toggles audio coming through or not
		* Octave Down: Playback speed and pitch one octave down
		* Octave Up: Playback speed and pitch one octave up

********************************************************/


	giLiveSamplTableLen 	init 882000;
	; empty table, size 882000 equals 20 seconds at 44.1kHz sr

;*********************************************************************
; BasicLooper
;*********************************************************************
	opcode Looper, aakk, aakkkkkkkk

	ainL, ainR, kRecPlayOvr, kStopStart, kClear, kSpeed, kReverse, kThrough, kOctDown, kOctUp xin

		kStopStart	init 0
		kPlaying 	init 0
		kOverdub 	init 0
		kndx init 0

		iLiveSamplAudioTableL	ftgen	0, 0, giLiveSamplTableLen, 2, 0
		iLiveSamplAudioTableR	ftgen	0, 0, giLiveSamplTableLen, 2, 0
		iTmpAudioTableL			ftgen	0, 0, giLiveSamplTableLen, 2, 0
		iTmpAudioTableR			ftgen	0, 0, giLiveSamplTableLen, 2, 0


	  	kSpeedMulti init 1
	  	kReverse 	init 1 ; -1 or 1

		kReverse scale kReverse, 1, -1
	 	kSpeed = kSpeed * kReverse

	  	; TEST THIS
	  	printk2 kOctUp
	  	if trigger(kOctUp, 0.5, 2) == 1 then
	  		kSpeedMulti = kSpeedMulti * 2
	 	elseif trigger(kOctDown, 0.5, 2) == 1 then
	  		kSpeedMulti = kSpeedMulti * 0.5
	  	endif

		kndx 	= trigger(kRecPlayOvr,0.5,0) == 1 ? 0 : kndx

		;***********************************
		; Recorder
		;***********************************
		if kRecPlayOvr == 1 && kPlaying == 0 then
    		tablew	ainL/0dbfs,a(kndx),iLiveSamplAudioTableL
    		tablew	ainR/0dbfs,a(kndx),iLiveSamplAudioTableR
   			kndx	+=	ksmps
   			kLength	= kndx

   			; Stop recording if past buffer size
   			/*
   			if kndx >= giLiveSamplTableLen then
   				kRecPlayOvr = 0
   				kPlaying = 1
   			endif
   			*/
		elseif kRecPlayOvr == 1 && kPlaying == 1 then
			kOverdub = 1
		elseif kRecPlayOvr == 0 && kPlaying == 1 then
			kOverdub = 0
		endif

		Srec sprintfk "Recording: %f", kRecPlayOvr
		   puts Srec, kRecPlayOvr+1

		;***********************************


		; If kRecPlayOvr is set to OFF, restart playback
	    kRestart trigger kRecPlayOvr,0.5,1	; if switched to 'play'
	    if kRestart == 1 then
	    	kPlaying = 1
	    	kSpeedMulti = 1
	    endif

	    ; Toggle kPlaying if kStopStart is toggeled
	    if (changed(kStopStart) == 1) then
	    	kPlaying = (kPlaying + 1) % 2
	    	kRestart trigger kPlaying,0.5,0
	    endif

		Srec sprintfk "Playing: %f", kPlaying
		   puts Srec, kPlaying+1

		;***********************************
		; Player
		;***********************************
		if (kPlaying == 1)  then
			; 1 over table length in seconds to get appropriate speed for phasor
			kreadFreq divz kSpeed * kSpeedMulti, (kLength/sr), 0.0000001

			if kRestart == 1 then			; Restart loop playback from the beginning if play is retriggered
				 reinit RESTART_PLAYBACK
			endif
		RESTART_PLAYBACK:
		  	aPlayIdx    phasor  kreadFreq
		  	aLoopLen	interp kLength
		  	aPlayIdx	= aPlayIdx*aLoopLen

		  	if kOverdub == 0 then
			  	aLoopL tablei aPlayIdx, iLiveSamplAudioTableL
			 	aLoopR tablei aPlayIdx, iLiveSamplAudioTableR
			else
			 	aPlayL tablei aPlayIdx, iLiveSamplAudioTableL
			 	aPlayR tablei aPlayIdx, iLiveSamplAudioTableR
			 	aLoopL = aPlayL + ainL
			 	aLoopR = aPlayR + ainR
			 	tablew aLoopL/0dbfs,aPlayIdx,iLiveSamplAudioTableL
    			tablew aLoopR/0dbfs,aPlayIdx,iLiveSamplAudioTableR
    		endif
    		aoutL = aLoopL
    		aoutR = aLoopR
		else
		 	aEmpty = 0
		 	aoutL = 0
    		aoutR = 0
		endif

		; Add FlipSwitch code
		;aoutL, aoutR FadeSwitch aEmpty, aEmpty, aLoopL, aLoopR, 0.1, kPlaying

		if kThrough == 1 then
			aoutL = aoutL + ainL
			aoutR = aoutR + ainR
		endif


	xout	aoutL, aoutR, kRecPlayOvr, kPlaying

	endop
;*********************************************************************
