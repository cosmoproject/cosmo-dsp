/********************************************************

	SimpleLooper.csd
	Author: Bernt Isak Wærstad

	Arguments: Record_Play, Play_Stop, Speed, Reverse, CrossFadeDur, Audio_Through, LoopStart, LoopEnd

	Description:

	A simple looper with speed control, but without overdub

		* Record/Play: 0 - 1 (Send a 1 to start recording, send a 1 again to 
							  stop recording and start playing the loop)
		* Play/stop: 0 - 1 (Toggles between loop playing and stopped)
		* Speed: 0x - 1x (Loop playback speed)
		* Reverse: 0 - 1 (Toggles normal and reverse playback)
		* CrossFade Duration: Length of crossfade at loop point 
		* Audio Through: 0 - 1 (Toggles audio coming through or not)

		* LoopStart: Starting point for loop in seconds
		* LoopEnd: End point of loop in seconds 


********************************************************/

	; empty table, size 2646000 equals 60 seconds at 44.1kHz sr
	giLiveSamplTableLen 	init 2646000;

	; Default argument values

	#define Record_Play #0#
	#define Play_Stop #0#
	#define Speed #1#
	#define Reverse #0#
	#define CrossFadeDur #0.05#
	#define Audio_Through #1#

	#define LoopStart #0#
	#define LoopEnd #1#

	#define SpeedChange #0.01#

;*********************************************************************
; SimpleLooper
;*********************************************************************

	opcode SimpleLooper, aakk, aakOPOOPOP


	ainL, ainR, kRec, kPlayStopToggle, kSpeed, kReverse, kCrossFadeDur, kThrough, kLoopStart, kLoopEnd xin

	  	kndx init 0
	  	kLoopLength init 0
		kputstrig init 0
	  	aZero = 0

	  	iLiveSamplAudioTableL ftgen 0, 0, giLiveSamplTableLen, 2, 0
	  	iLiveSamplAudioTableR ftgen 0, 0, giLiveSamplTableLen, 2, 0

	  	kRec init $Record_Play
	  	kPlayStopToggle init $Play_Stop
	  	kSpeed init $Speed
	  	kReverse init $Reverse
	  	kCrossFadeDur init $CrossFadeDur
	  	kThrough init $Audio_Through
	  	kLoopStart init $LoopStart
	  	kLoopEnd init $LoopEnd


	  	print i(kCrossFadeDur)

	  	; ******************************
	  	; Controller value scalings
	  	; ******************************

	  	; Rec: 0 or 1
	  	kRec = kRec > 0.5 ? 1 : 0

	  	; PlayStopToggle: 0 or 1 
		kPlayStopToggle = kPlayStopToggle > 0.5 ? 1 : 0

		; Speed: 0 to 1, but with no forced normalization
	 	Sspeed sprintfk "Loop speed %f", kSpeed
	 		puts Sspeed, kSpeed + 1 
	 	kSpeed port kSpeed, $SpeedChange

	 	; Reverse: 0 or 1
	 	kReverse = kReverse > 0.5 ? 1 : 0
	 	Srev sprintfk "Reverse on/off %d", kReverse
	 		puts Srev, kReverse + 1 
	 	kLoopMode = kReverse

	 	; CrossFadeDur: 0.01 - 10 seconds
	 	kCrossFadeDur expcurve kCrossFadeDur, 30
	 	kCrossFadeDur scale kCrossFadeDur, 10, 0.01
	 	SCF sprintfk "Crossfade Dur: %f", kCrossFadeDur
	 		puts SCF, kCrossFadeDur 

	 	; Through
	 	kThrough = kThrough > 0.5 ? 1 : 0
	 	Sthru sprintfk "Looper Audio through: %d", kThrough
	 		puts Sthru, kThrough+1 

		; TODO: implement proper printing of loop length and 
		; use of Loop End 

	 	; Loop start point: 
	 	kLoopStart scale kLoopStart, kLoopLength-0.01, 0
	 	;Start sprintfk "Loop start: %f s", kLoopStart
	 	;	puts Start, kLoopStart+1 

	 	; Loop end point: 
	 	kLoopEnd scale kLoopEnd, kLoopLength, 0.01
	 	;Start sprintfk "Loop end: %f s", kLoopEnd
	 	;	puts Start, kLoopEnd+1 


	  	; ******************************
	  	; Play/rec toggle logic
	  	; ******************************

		; If kRec changes from 1 to 0, then...
	    kRecStopTrigger	trigger	kRec,0.5,1	
		; ...start playing loop
		if kRecStopTrigger == 1 then
	    	kPlay = 1
	    endif

		; If kRec changes from 0 to 1, then..
	    kRecStartTrigger trigger kRec,0.5,0	
	    ; ...stop playing loop
	    if kRecStartTrigger == 1 then
	    	kPlay = 0
	    endif


		; Toggle playback (start/stop) of loop
		if changed(kPlayStopToggle) == 1 then
			kPlay = (kPlay + 1) %2
		endif

	  	; ******************************
	    ; RECORDING 
	  	; ******************************

		Srec sprintfk "Recording: %f", kRec
		puts Srec, kRec+1

		; Reset kndx (table index) to 0 when start recording 
		kndx 	= trigger(kRec,0.5,0) == 1 ? 0 : kndx

		; As long as kRec = 1, write audio to table
		if kRec == 1 then

        	tablew	ainL/0dbfs,a(kndx),iLiveSamplAudioTableL
        	tablew	ainR/0dbfs,a(kndx),iLiveSamplAudioTableR
	        kndx	+=	ksmps
	        ; Loop length in seconds
	        kLoopLength	= kndx/sr

		endif

	  	; ******************************
		; PLAYBACK 
	  	; ******************************

		if (kPlay == 1)  then

			kputstrig += kRecStopTrigger
			puts "Playing loop\n", kputstrig+1

			; Restart loop playback from the beginning if play is retriggered
			if kRecStopTrigger == 1 then	
				 reinit RESTART_PLAYBACK
			endif

			if changed(kReverse) == 1 then 
				 reinit RESTART_PLAYBACK
			endif


		RESTART_PLAYBACK:
			kLoopLevel init 1

			aLoopL flooper2 kLoopLevel, kSpeed, kLoopStart, kLoopLength, kCrossFadeDur, iLiveSamplAudioTableL, 0, i(kLoopMode)
			aLoopR flooper2 kLoopLevel, kSpeed, kLoopStart, kLoopLength, kCrossFadeDur, iLiveSamplAudioTableR, 0, i(kLoopMode)

			kAntiClick linseg 0, 0.01, 1
		else
			kAntiClick linseg 1, 0.01, 0
		endif

		aLoopL ntrpol aZero, aLoopL, kAntiClick
		aLoopR ntrpol aZero, aLoopR, kAntiClick


		if kThrough == 1 then
			aoutL = aLoopL + ainL
			aoutR = aLoopR + ainR
		else
			aoutL = aLoopL
			aoutR = aLoopR
		endif


	xout	aoutL, aoutR, kRec, kPlay

	endop
;*********************************************************************


;*********************************************************************
; Overload UDO for COSMO Patcher
;*********************************************************************


	opcode SimpleLooper, aa, aakOPOOPOP

	ainL, ainR, kRec, kPlayStopToggle, kSpeed, kReverse, kCrossFadeDur, kThrough, kLoopStart, kLoopEnd xin

	aoutL, aoutR, k1, k2 SimpleLooper ainL, ainR, kRec, kPlayStopToggle, kSpeed, kReverse, kCrossFadeDur, kThrough, kLoopStart, kLoopEnd

	xout	aoutL, aoutR

	endop

