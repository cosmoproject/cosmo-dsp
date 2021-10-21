/********************************************************

    PitchTracker.udo
    Author: Bernt Isak Wærstad

    Arguments: Mode, [Smoothing]
    Defaults:  0, 0

    Mode: 
        0: pitch (less CPU intensive)
        1: ptrack (SFT based)
    [Optional]
    Smoothing: 0.01s - 0.1s

    Description:
    Pitch tracker outputing frequency and amplitude

********************************************************/
	
    ; Default argument values
    #define Smoothing #0#
    #define dB_Thresh #10#
	#define HOP_SIZE #1024#

	; Toggle printing on/off
	#define PRINT #0#

	; Max and minimum values
    #define MAX_SMOOTH #0.1#
    #define MIN_SMOOTH #0.01#  
    #define LOW_PITCH #150#      
    #define HIGH_PITCH #3000#    

;*********************************************************************
; Pitchtracker - 1 in / 1 out
;*********************************************************************

opcode	PitchTracker, kk, akO
	ain, kmode, ksmooth xin

    ; ******************************
  	; Controller value scalings
  	; ******************************

    ksmooth scale ksmooth, $MAX_SMOOTH, $MIN_SMOOTH
    ksmooth limit ksmooth, $MIN_SMOOTH, $MAX_SMOOTH

    if kmode == 0 then 
		iupdate = 0.001	;high definition
		ilow = octcps($LOW_PITCH)
		ihi = octcps($HIGH_PITCH)
		idbthresh = $dB_Thresh

		koct, kamp pitch ain, iupdate, ilow, ihi, idbthresh
		kfreq = cpsoct(koct)
		kamp = kamp*.00005
    elseif kmode == 1 then 
        kfreq,kamp ptrack ain, $HOP_SIZE
    endif 

    if $PRINT == 1 then
        Spitch_f sprintfk "Pitchtrack freq: %d", kfreq
            puts Spitch_f, kfreq + 1
        Spitch_a sprintfk "Pitchtrack amp: %d", kamp
            puts Spitch_a, kamp + 1
    endif

    kfreq portk kfreq, ksmooth
    kamp portk kamp, ksmooth

    xout kfreq, kamp
endop

;*********************************************************************
; Pitchtracker - 2 in / 1 out
;*********************************************************************

opcode	PitchTracker, kk, aakO
	ainL, ainR, ksmooth xin

    ainMono = (ainL + ainR) * 0.5
    kfreq, kamp PitchTracker ainMono, ksmooth 

    xout kfreq, kamp
endop
