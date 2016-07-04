
	giLiveSamplTableLen 	init 262144;
	; empty table, size 262144 equals 5.9 seconds at 44.1kHz sr
	giLiveSamplAudioTableL	ftgen	0, 0, giLiveSamplTableLen, 2, 0	
	giLiveSamplAudioTableR	ftgen	0, 0, giLiveSamplTableLen, 2, 0	

;*********************************************************************
; Record
;*********************************************************************

	opcode Record, 0, aak

		ainL, ainR, kRecord xin

		kndx init 0

		kndx 	= trigger(kRecord,0.5,0) == 1 ? 0 : kndx

		if kRecord == 1 then 

	        	tablew	ainL/0dbfs,a(kndx),giLiveSamplAudioTableL
	        	tablew	ainR/0dbfs,a(kndx),giLiveSamplAudioTableR
	        kndx	+=	ksmps

		endif 

		gkLength	= kndx

	endop

;*********************************************************************
; Play
;*********************************************************************

	opcode Play, aa, kk

		kSpeed, kRestart xin

		; 1 over table length in seconds to get appropriate speed for phasor
		kreadFreq divz kSpeed, (gkLength/sr), 0.0000001 

		if kRestart == 1 then			; Restart loop playback from the beginning if play is retriggered
			 reinit RESTART_PLAYBACK
		endif
	RESTART_PLAYBACK:
	  	aPlayIdx    phasor  kreadFreq  
	  	aLoopLen	interp gkLength
	  	aPlayIdx	= aPlayIdx*aLoopLen

	  	aoutL tablei aPlayIdx, giLiveSamplAudioTableL
	 	aoutR tablei aPlayIdx, giLiveSamplAudioTableR

	 	xout aoutL, aoutR

 	endop


;*********************************************************************
; SimpleLooper
;*********************************************************************
	opcode SimpleLooper, aa, aakkkkkk

	ainL, ainR, kRecPlayOvr, kStopStart, kClear, kSpeed, kReverse, kThrough xin

		kStopStart	init 0

	  	kSpeed 		init 1
	  	keverse 	init 1 ; -1 or 1

	 	kSpeed = kSpeed * kReverse

	  	kOverdub init 0


	  	;kRecPlayOvr += kOverdub

	  	; This if wont work as kRecPlayOvr needs to be check by Record all the time. The triggering
	  	; could be moved out to the main instrument.
	  	; The whole programatic flow should be re-thought

	  	;if (kRecPlayOvr == 1) then
		Record ainL, ainR, kRecPlayOvr
		;endif


	    kRestart	trigger	kRecPlayOvr,0.5,1	; if switched to 'play'

	    if kRestart == 1 then
	    	kStopStart = 0 

	    	;chnset kStopStart, "stopstart"
	    endif

		
		if (kRecPlayOvr == 0  && kStopStart == 0)  then

			aoutL, aoutR Play kSpeed, kRestart

		 else
		 	aoutL = 0
			aoutR = 0
		endif
		
		;aoutL = ainL
		;aoutR = ainR
		if kThrough == 1 then 
			aoutL = aoutL + ainL
			aoutR = aoutR + ainR
		endif


	xout	aoutL, aoutR

	endop
;*********************************************************************










