/********************************************************

	Flanger.udo
	Author: Bernt Isak Wærstad
    Based on code by Øyvind Brandtsegg

	Arguments: Rate, Depth, Offset, Feed, Mix [, Wave] 
    Defaults: 0.1, 0.5, 0.2, 0.6, 0.5, 0

	Rate: 0.01 - 15 (in ms)
	Depth: 0 - 10 (in ms)
    Feed: 0% - 100%
    Offset: 0 - 0.5s
	Dry/wet mix: 0% - 100%
    [Optional]
    Wave: 0 - 5 (Sine, Tri, Pulse, Saw, RevSaw)

	Description:
    A flanger with changeable waveform 

********************************************************/

	; Default argument values
	#define Rate #0.1#
	#define Depth #0.5#
    #define Offset #0.2#
    #define Feed #0.9#
	#define Wave #0#
    #define Mix #0.5#

	; Toggle printing on/off
	#define PRINT #0#

	; Max and minimum values
    #define MAX_RATE #15#
    #define MIN_RATE #0.01#
    #define MAX_DEPTH #10#
	#define MIN_DEPTH #0#
    #define MAX_OFFSET #0.5#
    #define MIN_OFFSET #0#
    #define MAX_FEED #1#
    #define MIN_FEED #0#

;*********************************************************************
; Flanger - 1 in / 1 out
;*********************************************************************

opcode Flanger,a,akkkkkO
    ain, krate, kdepth, koffset, kfeed, kmix, kWave  xin

    ; ******************************
  	; Controller value scalings
  	; ******************************

    krate expcurve krate, 30
    krate scale krate, $MAX_RATE, $MIN_RATE
    krate limit krate, $MIN_RATE, $MAX_RATE

    kdepth scale kdepth, $MAX_DEPTH, $MIN_DEPTH
    kdepth limit kdepth, $MIN_DEPTH, $MAX_DEPTH

    koffset scale koffset, $MAX_OFFSET, $MIN_OFFSET
    koffset limit koffset, $MIN_OFFSET, $MAX_OFFSET

    kfeed scale kfeed, $MAX_FEED, $MIN_FEED
    kfeed limit kfeed, $MIN_FEED, $MAX_FEED

    kWave scale kWave, 5, 0

	if (kWave < 1) then  ; Sine
    	aLFO lfo 0.5, krate, 0
    elseif (kWave >= 1 && kWave < 2) then ; Tri
        aLFO lfo 0.5, krate, 1
    elseif (kWave >= 2 && kWave < 3) then ; Pulse
        aLFO lfo 0.5, krate, 3
    elseif (kWave >= 3 && kWave < 4) then ; Saw
        aLFO lfo 0.5, krate, 4
    elseif (kWave >= 4 && kWave < 5) then ; RevSaw
        aLFO lfo 0.5, krate, 5
    endif

    if $PRINT == 1 then 
        Srate sprintfk "Flanger rate %f", krate
            puts Srate, krate+1
        Sdepth sprintfk "Flanger depth %f", kdepth
            puts Sdepth, kdepth+1
        Soffset sprintfk "Flanger offset %f", koffset
            puts Soffset, koffset+1
        Sfeed sprintfk "Flanger feed %f", kfeed
            puts Sfeed, kfeed+1
        Smix sprintfk "Flanger mix %f", kmix
            puts Smix, kmix+1
    endif

    ; Flanger
    aDepth      init    $Depth
	aDepth		interp 	kdepth				; flanger depth (in milliseconds)

	aDelayTime	= ((aLFO+0.5)*aDepth)+koffset	; scale and offset LFO
	iMaxDelay	= 0.1
	iWindowSize	= 4
	aFeed		init 0
	aFlanger 	vdelayx ain+aFeed, aDelayTime*0.001, iMaxDelay, iWindowSize
	aFeed		= aFlanger*kfeed
	
    aOut		= ((ain*sqrt(1-kmix)) + (aFlanger*sqrt(kmix)))
 
; audio out
	xout	aOut

endop

;*********************************************************************
; Flanger - 1 in / 2 out
;*********************************************************************

opcode Flanger,aa,akkkkkO
    ain, krate, kdepth, koffset, kfeed, kmix, kWave xin

    aL Flanger ain, krate, kdepth, koffset, kfeed, kmix, kWave
    aR Flanger ain, krate, kdepth, koffset, kfeed, kmix, kWave

    xout aL, aR 
endop

;*********************************************************************
; Flanger - 2 in / 2 out
;*********************************************************************

opcode Flanger,aa,aakkkkkO
    ainL,ainR, krate, kdepth, koffset, kfeed, kmix, kWave xin

    aL Flanger ainL, krate, kdepth, koffset, kfeed, kmix, kWave
    aR Flanger ainR, krate, kdepth, koffset, kfeed, kmix, kWave

    xout aL, aR 
endop
