/********************************************************

	LFO.udo
	Author: Bernt Isak Wærstad

	Arguments: Rate [, Wave, Smoothing]
    Defaults: 0.2, 0, 0
    [Optional]
    Wave: 
        0: Sine
        1: Tri
        2: Square
        3: Saw
        4: RevSaw
        5: Random
        6: Smooth Random

	Description:
    An LFO with changeable waveform

********************************************************/

	; Default argument values
	#define Rate #0.2#
	#define Wave #0#
    #define Smoothing #0# 

	; Toggle printing on/off
	#define PRINT #0#

	; Max and minimum values
    #define MAX_RATE #10#
    #define MIN_RATE #0.01#
    #define MAX_SMOOTH_K #1#
    #define MIN_SMOOTH_K #0#
    #define MAX_SMOOTH_A #10#
    #define MIN_SMOOTH_A #100#


;*********************************************************************
; LFO - 1 out (k-rate)
;*********************************************************************

opcode	LFO, k, kOO
	krate, kWave, ksmooth xin

    ; ******************************
  	; Controller value scalings
  	; ******************************
    kamp = 0.5

    krate scale krate, $MAX_RATE, $MIN_RATE
    krate limit krate, $MIN_RATE, $MAX_RATE

    ksmooth scale ksmooth, $MAX_SMOOTH_K, $MIN_SMOOTH_K
    ksmooth limit ksmooth, $MIN_SMOOTH_K, $MAX_SMOOTH_K

    kWave scale kWave, 7, 0

	if (kWave < 1) then  ; Sine
    	kLFO lfo kamp, krate, 0
        Swave_select strcpyk "Sine"
    elseif (kWave >= 1 && kWave < 2) then ; Tri
        kLFO lfo kamp, krate, 1
        Swave_select strcpyk "Triangle"
    elseif (kWave >= 2 && kWave < 3) then ; Square
        kLFO lfo kamp, krate, 3
        Swave_select strcpyk "Square"
    elseif (kWave >= 3 && kWave < 4) then ; Saw
        kLFO lfo kamp, krate, 4
        Swave_select strcpyk "Saw"
    elseif (kWave >= 4 && kWave < 5) then ; RevSaw
        kLFO lfo kamp, krate, 5
        Swave_select strcpyk "Reversed Saw"
    elseif (kWave >= 5) && (kWave < 6) then   
        kLFO randomh 0.5-(kamp*0.5), 0.5+(kamp*0.5), krate, 3 
        Swave_select strcpyk "Random"
    elseif (kWave >= 6) then 
        kRND_end init 0

        ktrig metro krate 

        if ktrig == 1 then 
            kRND_start = kRND_end
        endif
        kRND_end randomh 0.5-(kamp*0.5), 0.5+(kamp*0.5), krate, 3 

        klength = kRND_end - kRND_start
        ktime = (krate * klength)/kr
        
        kLFO trigphasor ktrig, (krate * klength)/kr, kRND_start, kRND_end, kRND_start

        Swave_select strcpyk "Smooth random"
    endif   
    
    if $PRINT == 1 then
        Srate sprintfk "LFO rate: %.3f", krate
            puts Srate, krate+1
        Swave sprintfk "LFO waveform: %s", Swave_select
            puts Swave, kWave+1
        Smooth sprintfk "LFO smoothing: %.3fms", ksmooth
            puts Smooth, ksmooth+1
    endif
    kLFO portk kLFO, ksmooth

    xout kLFO

endop 

;*********************************************************************
; LFO - 2 out (k-rate)
;*********************************************************************

opcode	LFO, kk, kOO
	krate, kWave, ksmooth xin

    kLFO1 LFO krate, kWave, ksmooth
    kLFO2 LFO krate, kWave, ksmooth

    xout kLFO1, kLFO2
endop

;*********************************************************************
; LFO - 1 out (a-rate)
;*********************************************************************

opcode	LFO, a, kOO
	krate, kWave, ksmooth xin

    ; ******************************
  	; Controller value scalings
  	; ******************************
    kamp = 0.5

    krate scale krate, $MAX_RATE, $MIN_RATE
    krate limit krate, $MIN_RATE, $MAX_RATE

    ksmooth scale ksmooth, $MAX_SMOOTH_A, $MIN_SMOOTH_A
    ksmooth limit ksmooth, $MIN_SMOOTH_A, $MAX_SMOOTH_A

    kWave scale kWave, 7, 0

	if (kWave < 1) then  ; Sine
    	aLFO lfo kamp, krate, 0
        Swave_select strcpyk "Sine"
    elseif (kWave >= 1 && kWave < 2) then ; Tri
        aLFO lfo kamp, krate, 1
        Swave_select strcpyk "Triangle"
    elseif (kWave >= 2 && kWave < 3) then ; Square
        aLFO lfo kamp, krate, 3
        Swave_select strcpyk "Square"
    elseif (kWave >= 3 && kWave < 4) then ; Saw
        aLFO lfo kamp, krate, 4
        Swave_select strcpyk "Saw"
    elseif (kWave >= 4 && kWave < 5) then ; RevSaw
        aLFO lfo kamp, krate, 5
        Swave_select strcpyk "Reversed Saw"
    elseif (kWave >= 5) && (kWave < 6) then   
        aLFO randomh 0.5-(kamp*0.5), 0.5+(kamp*0.5), krate, 3 
        Swave_select strcpyk "Random"
    elseif (kWave >= 6) then 
        aRND_end init 0

        ktrig metro krate 

        if ktrig == 1 then 
            aRND_start = aRND_end
        endif
        aRND_end randomh 0.5-(kamp*0.5), 0.5+(kamp*0.5), krate, 3 

        klength = k(aRND_end)- k(aRND_start)
        ktime = (krate * klength)/kr
        
        aLFO trigphasor ktrig, (krate * klength)/kr, k(aRND_start), k(aRND_end), k(aRND_start)

        Swave_select strcpyk "Smooth random"
    endif   
    
    if $PRINT == 1 then
        Srate sprintfk "LFO rate: %.3f", krate
            puts Srate, krate+1
        Swave sprintfk "LFO waveform: %s", Swave_select
            puts Swave, kWave+1
        Smooth sprintfk "LFO smoothing: %.3fms", ksmooth
            puts Smooth, ksmooth+1
    endif
    aLFO butlp aLFO, ksmooth

    xout aLFO

endop 

;*********************************************************************
; LFO - 2 out (a-rate)
;*********************************************************************

opcode	LFO, aa, kOO
	krate, kWave, ksmooth xin

    aLFO1 LFO krate, kWave, ksmooth
    aLFO2 LFO krate, kWave, ksmooth

    xout aLFO1, aLFO2
endop