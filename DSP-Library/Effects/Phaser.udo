/********************************************************

	Phaser.udo
	Author: Bernt Isak Wærstad
    Based on code by Øyvind Brandtsegg

	Arguments: Rate, Resonance, Notches, Wave, Mix, Mode 
    Defaults: 0, 0.6, 0.75, 0, 0.5, 0

	Rate: 0.001 - 10
	Resonance: 0 - 1
    Notches: 1 - 8
    Wave: 0 - 5 (Sine, Tri, Pulse, Saw, RevSaw)
	Dry/wet mix: 0% - 100%
	Mode:

		0: First order allpass
		1: Second order allpass

	Description:
    A phaser

********************************************************/

	; Default argument values
	#define Rate #0#
	#define Resonance #0.6#
	#define Notches #0.75#
	#define Wave #0#
    #define Mix #0.5#
	#define Mode #0#

	; Toggle printing on/off
	#define PRINT #0#

	; Max and minimum values
	#define MAX_FREQ #1800#
	#define MIN_FREQ #300#
    #define MAX_RATE #10#
    #define MIN_RATE #0.001#
    #define INIT_NOTCHES #4# 


;*********************************************************************
; Phaser - 1 in / 1 out
;*********************************************************************

opcode Phaser,a,akkkkkO
    ain, krate, kres, knotches, kWave, kmix, kmode xin

; phaser
	kMaxFreq	= $MAX_FREQ			; phaser max freq
	kMinFreq	= $MIN_FREQ			; phaser min freq

    krate expcurve krate, 30
    krate scale krate, $MAX_RATE, $MIN_RATE

    kres scale kres, 1, 0
    kres limit kres, 0, 1

    knotches scale knotches, 8, 1
    knotches limit knotches, 1, 8
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
        Sres sprintfk "Phaser resonance %f", kres
            puts Sres, kres+1
        Snotches sprintfk "Phaser notches %d", knotches
            puts Snotches, knotches+1
        Smix sprintfk "Phaser mix %f", kmix
            puts Smix, kmix+1
    endif

	kFreq		= ((kLFO+0.5)*(kMaxFreq-kMinFreq))+kMinFreq	; scale and offset LFO
	iMode		= 2		; notch spacing mode (1=harmonic, 2=interval)
	iSep		= 1.3	; notch spacing value
	kQ		    = 0.5	; Q of each node

	if kmode == 0 then 
        inotches	= 4					; number of phasing notches
        aPhaser 	phaser1 ain, kFreq, inotches*2, kres
    elseif kmode == 1 then 
    	aPhaser 	phaser2 ain, kFreq, kQ, knotches, iMode, iSep, kres 
    endif

	aOut ntrpol ain, aPhaser, kmix

; audio out
	xout	aOut

endop

;*********************************************************************
; Phaser - 1 in / 2 out
;*********************************************************************

opcode Phaser,aa,akkkkkO
    ain, krate, kres, knotches, kWave, kmix, kmode xin

    aL Phaser ain, krate, kres, knotches, kWave, kmix, kmode
    aR Phaser ain, krate, kres, knotches, kWave, kmix, kmode

    xout aL, aR 
endop

;*********************************************************************
; Phaser - 2 in / 2 out
;*********************************************************************

opcode Phaser,aa,aakkkkkO
    ainL,ainR, krate, kres, knotches, kWave, kmix, kmode xin

    aL Phaser ainL, krate, kres, knotches, kWave, kmix, kmode
    aR Phaser ainR, krate, kres, knotches, kWave, kmix, kmode

    xout aL, aR 
endop