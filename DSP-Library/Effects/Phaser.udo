/********************************************************

	Phaser.udo
	Author: Bernt Isak Wærstad
    Based on code by Øyvind Brandtsegg

	Arguments: Rate, Feedback, Notches, Mix [, Mode, Wave, Stereo]
    Defaults: 0.2, 0.5, 0.5, 1, 1, 0.2, 0.3

	Rate: 0.01 - 10
	Feedback: 0 - 1
    Notches: 4 - 8
	Dry/wet mix: 0% - 100%
    [Optional]
	Mode:
		0: First order allpass
		1: Second order allpass
    Wave: 0 - 5 (Sine, Tri, Pulse, Saw, RevSaw)
    Stereo: Offset spacing on one side

	Description:
    A phaser with changeable waveform

********************************************************/

	; Default argument values
	#define Rate #0#
	#define Feedback #0.6#
	#define Notches ##
	#define Wave #0#
    #define Mix #1#
	#define Mode #0.2#
    #define Stereo #0.3#

	; Toggle printing on/off
	#define PRINT #0#

	; Max and minimum values
	#define MAX_FREQ #2000#
	#define MIN_FREQ #500#
    #define MAX_RATE #10#
    #define MIN_RATE #0.01#
    #define MAX_FEED #1#
    #define MIN_FEED #0#
    #define MAX_NOTCHES #8#
    #define MIN_NOTCHES #4#
    #define INIT_NOTCHES #4# 


;*********************************************************************
; Phaser - 1 in / 1 out
;*********************************************************************

opcode Phaser,a,akkkkPOO
    ain, krate, kfeed, knotches, kmix, kmode, kWave, kStereo xin

    ; ******************************
  	; Controller value scalings
  	; ******************************

    knotches init $MIN_NOTCHES

	kMaxFreq = $MAX_FREQ			; phaser max freq
	kMinFreq = $MIN_FREQ			; phaser min freq

    krate expcurve krate, 30
    krate scale krate, $MAX_RATE, $MIN_RATE
    krate limit krate, $MIN_RATE, $MAX_RATE

    kfeed scale kfeed, $MAX_FEED, $MIN_FEED
    kfeed limit kfeed, $MIN_FEED, $MAX_FEED

    knotches scale knotches, $MAX_NOTCHES, $MIN_NOTCHES
    knotches limit knotches, $MIN_NOTCHES, $MAX_NOTCHES

    kWave scale kWave, 5, 0

	if (kWave < 1) then  ; Sine
    	kLFO lfo 0.5, krate, 0
    elseif (kWave >= 1 && kWave < 2) then ; Tri
        kLFO lfo 0.5, krate, 1
    elseif (kWave >= 2 && kWave < 3) then ; Pulse
        kLFO lfo 0.5, krate, 3
    elseif (kWave >= 3 && kWave < 4) then ; Saw
        kLFO lfo 0.5, krate, 4
    elseif (kWave >= 4 && kWave < 5) then ; RevSaw
        kLFO lfo 0.5, krate, 5
    endif

    if $PRINT == 1 then 
        Srate sprintfk "Phaser rate %f", krate
            puts Srate, krate+1
        Sfeed sprintfk "Phaser feed %f", kfeed
            puts Sfeed, kfeed+1
        Snotches sprintfk "Phaser notches %d", knotches
            puts Snotches, knotches+1
        Smix sprintfk "Phaser mix %f", kmix
            puts Smix, kmix+1
        Smode sprintfk "Phaser mode %d", kmode
            puts Smode, kmode+1
        Swave sprintfk "Phaser wave %d", kWave
            puts Swave, kWave+1

    endif

	kFreq		= ((kLFO+0.5)*(kMaxFreq-kMinFreq))+kMinFreq	; scale and offset LFO
	iMode		= 2		; notch spacing mode (1=harmonic, 2=interval)
	kSep		= 1 + kStereo
    kres        = 0.5

	if kmode == 0 then 
        aPhaser 	phaser1 ain, kFreq, knotches, kres
    elseif kmode == 1 then 
        aPhaser phaser2 ain, 	kFreq, kres, knotches, iMode, kSep, kfeed
     endif

    aOut		= ((ain*sqrt(1-kmix)) + (aPhaser*sqrt(kmix)))

; audio out
	xout	aOut

endop

;*********************************************************************
; Phaser - 1 in / 2 out
;*********************************************************************

opcode Phaser,aa,akkkkPOO
    ain, krate, kres, knotches, kmix, kmode, kWave, kStereo xin

    aL Phaser ain, krate, kres, knotches, kmix, kmode, kWave, 0
    aR Phaser ain, krate, kres, knotches, kmix, kmode, kWave, kStereo

    xout aL, aR 
endop

;*********************************************************************
; Phaser - 2 in / 2 out
;*********************************************************************

opcode Phaser,aa,aakkkkPOO
    ainL, ainR, krate, kres, knotches, kmix, kmode, kWave, kStereo xin

    aL Phaser ainL, krate, kres, knotches, kmix, kmode, kWave, 0
    aR Phaser ainR, krate, kres, knotches, kmix, kmode, kWave, kStereo

    xout aL, aR 
endop
