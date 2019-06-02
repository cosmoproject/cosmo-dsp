/********************************************************

	SimpleLooper.csd
	Author: Bernt Isak Wærstad

	Arguments: Record_Play, Play_Stop, Speed, Reverse, CrossFadeDur, Audio_Through, LoopStart, LoopEnd

	Description:

	A simple looper with speed control (no overdub)

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

	; Toggle printing on/off
	#define PRINT #0#

;*********************************************************************
; Ducking UDO to avoid clicking at loop points
;*********************************************************************

opcode ducking, a, aakkk
    ainput, andx, kloopstart, kloopend, kducktime xin

    kenv init 1
    kidx = 0
	kloopstart init 0
	kloopend init 0
	kloopstart /= sr 
	kloopend /= sr
	klooplen = (kloopend - kloopstart)
    kducktime scale kducktime, klooplen*0.45, 0

	kducktime limit kducktime, 0, klooplen*0.45

	while (kidx < ksmps) do
		kbuffer_idx = andx[kidx]
		if (kbuffer_idx > (kloopend-kducktime)) then
			;kenv = ((klooplen - kbuffer_idx)/klooplen) * (1/kducktime)
			kenv = ((klooplen - kbuffer_idx)/kducktime)
		endif
	    if (kbuffer_idx > kloopstart) && (kbuffer_idx < kducktime) then
            kenv = (kbuffer_idx * (1/kducktime))
        endif
        kidx += 1	
	od 

	aenv interp kenv
    xout ainput*aenv
endop

;*********************************************************************
; SimpleLooper - 1 in / 1 out - ctrl args out
;*********************************************************************

	opcode SimpleLooper, akk, akOPOOPOP

	ain, kRec, kPlayStopToggle, kSpeed, kReverse, kCrossFadeDur, kThrough, kLoopStart, kLoopEnd xin

	  	kndx init 0
	  	kLoopLength init 0
		kputstrig init 0
	  	aZero = 0

	  	iLiveSamplAudioTable1 ftgen 0, 0, giLiveSamplTableLen, 2, 0
	  	iLiveSamplAudioTable2 ftgen 0, 0, giLiveSamplTableLen, 2, 0

	  	kRec init $Record_Play
	  	kPlayStopToggle init $Play_Stop
	  	kSpeed init $Speed
	  	kReverse init $Reverse
	  	kCrossFadeDur init $CrossFadeDur
	  	kThrough init $Audio_Through
	  	kLoopStart init $LoopStart
	  	kLoopEnd init $LoopEnd
		kRecDur init 1
		kRecTable init 0

	  	; ******************************
	  	; Controller value scalings
	  	; ******************************

	  	; Rec: 0 or 1
	  	kRec = kRec > 0.5 ? 1 : 0

	  	; PlayStopToggle: 0 or 1 
		kPlayStopToggle = kPlayStopToggle > 0.5 ? 1 : 0

	 	; Reverse: 0 or 1
	 	kReverse = kReverse > 0.5 ? 1 : 0
	 	kLoopMode = kReverse

	 	; CrossFadeDur: 0.01 - 10 seconds
	 	kCrossFadeDur expcurve kCrossFadeDur, 30
	 	kCrossFadeDur scale kCrossFadeDur, 10, 0.01

	 	; Through
	 	kThrough = kThrough > 0.5 ? 1 : 0
		
		; Loop start point: 
	 	kLoopStart limit kLoopStart, 0, 1
	 	; Loop end point: 
	 	kLoopEnd limit kLoopEnd, 0, 1

		if $PRINT == 1 then 
			Sspeed sprintfk "Loop speed %f", kSpeed
				puts Sspeed, kSpeed + 1 
			Srev sprintfk "Reverse on/off %d", kReverse
				puts Srev, kReverse + 1 
			SCF sprintfk "Crossfade Dur: %f", kCrossFadeDur
				puts SCF, kCrossFadeDur 
			Sthru sprintfk "Looper Audio through: %d", kThrough
				puts Sthru, kThrough+1 
			Start sprintfk "Loop start: %f s", kLoopStart
				puts Start, kLoopStart+1 
			Start sprintfk "Loop end: %f s", kLoopEnd
				puts Start, kLoopEnd+1 
			if trigger(kRec,0.5,1) == 1 then
				Start sprintfk "Loop length: %.02f s", kRecDur/sr
					puts Start, kRecDur+1 
			endif
		endif

		; Speed: 0 to 1, but with no forced normalization
	 	kSpeed port kSpeed, $SpeedChange

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
			kRecTable = (kRecTable+1) % 2
			Srectable sprintfk "Recording to buffer%d", kRecTable
				puts Srectable, kRecTable+1
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
			if kRecTable == 0 then 
        		tablew	ain/0dbfs,a(kndx),iLiveSamplAudioTable1
			else 
				tablew	ain/0dbfs,a(kndx),iLiveSamplAudioTable2
			endif
	        kndx	+=	ksmps
	        ; Loop length in seconds
	        kRecDur	= kndx
		endif


	  	; ******************************
		; PLAYBACK 
	  	; ******************************

		kPlay port kPlay, 0.5
	
		aLoop init 0
		aLoop ntrpol aZero, aLoop, kPlay

		if (kPlay > 0 && kRec == 0)  then
			kputstrig += kRecStopTrigger
			puts "Playing loop\n", kputstrig+1

			; Restart loop playback from the beginning if play is retriggered
			if kRecStopTrigger == 1 then	
				 reinit RESTART_PLAYBACK
			endif

			if changed(kReverse) == 1 then 
				 reinit RESTART_PLAYBACK
			endif
	
			kLoopStart	portk	kLoopStart, 0.05		;APPLY PORTAMENTO SMOOTHING TO CHANGES OF LOOP BEGIN SLIDER
			kLoopEnd	portk	kLoopEnd, 0.05		;APPLY PORTAMENTO SMOOTHING TO CHANGES OF LOOP END SLIDER
			kLoopStart	=	kLoopStart * kRecDur
			kLoopEnd	=	kLoopEnd * kRecDur

			kLoopLength	=	kLoopEnd - kLoopStart

		RESTART_PLAYBACK:
			kLoopLevel init 1

			kPlayRate divz kSpeed, (kLoopLength/sr), 0.000001
			aPlayIdx phasor kPlayRate
			
			kLoopStart = (kLoopStart < kLoopEnd ? kLoopStart : kLoopEnd)
			aLoopLength interp abs(kLoopLength) 
			aLoopStart interp kLoopStart
			aPlayIdx = (aPlayIdx*aLoopLength) + aLoopStart

			aLoop init 0
			;aLoop flooper2 kLoopLevel, kSpeed, kLoopStart, kLoopLength, kCrossFadeDur, iLiveSamplAudioTable, 0, i(kLoopMode)
			;aLoop lposcil3 1, kSpeed, kLoopStart*sr, kLoopLength*sr, iLiveSamplAudioTable   
			  
			if kRecTable == 0 then 
				;aLoop flooper2 kLoopLevel, kSpeed, kLoopStart, kLoopLength, kCrossFadeDur, iLiveSamplAudioTable1, 0, i(kLoopMode)
				aLoop tablei aPlayIdx, iLiveSamplAudioTable1 ;, 0, 0, 1
			else 
				;aLoop flooper2 kLoopLevel, kSpeed, kLoopStart, kLoopLength, kCrossFadeDur, iLiveSamplAudioTable2, 0, i(kLoopMode)
				aLoop tablei aPlayIdx, iLiveSamplAudioTable2 ;, 0, 0, 1
			endif
			aLoop ducking aLoop, aPlayIdx/sr, kLoopStart, kLoopEnd, 0.1
		endif

		if kThrough == 1 then
			aout = aLoop + ain
		else
			aout = aLoop
		endif

	xout aout, kRec, kPlay

	endop

;*********************************************************************
; SimpleLooper - 1 in / 1 out - no ctrl args out
;*********************************************************************

	opcode SimpleLooper, a, akOPOOPOP
		ain, kRec, kPlayStopToggle, kSpeed, kReverse, kCrossFadeDur, kThrough, kLoopStart, kLoopEnd xin

		aout, k1, k2 SimpleLooper ain, kRec, kPlayStopToggle, kSpeed, kReverse, kCrossFadeDur, kThrough, kLoopStart, kLoopEnd

		xout aout
	endop

;*********************************************************************
; SimpleLooper - 1 in / 2 out 
;*********************************************************************

	opcode SimpleLooper, aakk, akOPOOPOP
		ain, kRec, kPlayStopToggle, kSpeed, kReverse, kCrossFadeDur, kThrough, kLoopStart, kLoopEnd xin

		aoutL, kRecStatus, kPlayStatus SimpleLooper ain, kRec, kPlayStopToggle, kSpeed, kReverse, kCrossFadeDur, kThrough, kLoopStart, kLoopEnd
		aoutR SimpleLooper ain, kRec, kPlayStopToggle, kSpeed, kReverse, kCrossFadeDur, kThrough, kLoopStart, kLoopEnd

		xout aoutL, aoutR, kRecStatus, kPlayStatus
	endop

	opcode SimpleLooper, aa, akOPOOPOP
		ain, kRec, kPlayStopToggle, kSpeed, kReverse, kCrossFadeDur, kThrough, kLoopStart, kLoopEnd xin

		aoutL SimpleLooper ain, kRec, kPlayStopToggle, kSpeed, kReverse, kCrossFadeDur, kThrough, kLoopStart, kLoopEnd
		aoutR SimpleLooper ain, kRec, kPlayStopToggle, kSpeed, kReverse, kCrossFadeDur, kThrough, kLoopStart, kLoopEnd

		xout aoutL, aoutR
	endop

;*********************************************************************
; SimpleLooper - 2 in / 2 out 
;*********************************************************************

	opcode SimpleLooper, aakk, aakOPOOPOP
		ainL, ainR, kRec, kPlayStopToggle, kSpeed, kReverse, kCrossFadeDur, kThrough, kLoopStart, kLoopEnd xin

		aoutL, kRecStatus, kPlayStatus SimpleLooper ainL, kRec, kPlayStopToggle, kSpeed, kReverse, kCrossFadeDur, kThrough, kLoopStart, kLoopEnd
		aoutR SimpleLooper ainR, kRec, kPlayStopToggle, kSpeed, kReverse, kCrossFadeDur, kThrough, kLoopStart, kLoopEnd

		xout aoutL, aoutR, kRecStatus, kPlayStatus
	endop

	opcode SimpleLooper, aa, aakOPOOPOP
		ainL, ainR, kRec, kPlayStopToggle, kSpeed, kReverse, kCrossFadeDur, kThrough, kLoopStart, kLoopEnd xin

		aoutL SimpleLooper ainL, kRec, kPlayStopToggle, kSpeed, kReverse, kCrossFadeDur, kThrough, kLoopStart, kLoopEnd
		aoutR SimpleLooper ainR, kRec, kPlayStopToggle, kSpeed, kReverse, kCrossFadeDur, kThrough, kLoopStart, kLoopEnd

		xout aoutL, aoutR
	endop
