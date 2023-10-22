/********************************************************

	Autopan.udo
	Author: Bernt Isak Wærstad

	Arguments: Amount, Rate, Phase [, Wave]
    Defaults: 0.5, 0.25, 0.5, 0

	Amount: 0% - 100%
	Rate: 0.01Hz - 100Hz 
	Phase: 0 - 360 degrees
    [Optional]
    Wave: 
        0: Sine
        1: Tri
        2: Square
        3: Saw
        4: Random
        5: Smooth Random

	Description:
    An automatic panning effect with variable waveform

********************************************************/

	; Default argument values
	#define Amount #0.5#
	#define Rate #0.25#
	#define Phase #0.5#
    #define Wave #0#
    #define Smoothing_Lowpass #100# ; Smoothing lowpass filter 

	; Toggle printing on/off
	#define PRINT #0#

	; Max and minimum values
	#define MAX_RATE #50#
	#define MIN_RATE #0.01#
    #define MAX_AMOUNT #1#
    #define MIN_AMOUNT #0#
    #define MAX_PHASE #1#
    #define MIN_PHASE #0#

;*********************************************************************
; Autopan - 2 in / 2 out
;*********************************************************************

opcode Autopan,aa,aakkkO

    aInL, aInR, kamount, krate, kphase, kWave xin

    ; ******************************
  	; Controller value scalings
  	; ******************************

    kphase scale kphase, $MAX_PHASE, $MIN_PHASE
    kphase limit kphase, $MIN_PHASE, $MAX_PHASE

    krate expcurve krate, 30
    krate scale krate, $MAX_RATE, $MIN_RATE
    krate limit krate, $MIN_RATE, $MAX_RATE

    kamount scale kamount, $MAX_AMOUNT, $MIN_AMOUNT
    kamount limit kamount, $MIN_AMOUNT, $MAX_AMOUNT

    kWave scale kWave, 6, 0

    iSine		ftgen	0, 0, 4096, 10, 1	
    iTri		ftgen	0, 0, 4096, 7, 0, 1024, 1, 2048, -1, 1024, 0
    iSquare		ftgen	0, 0, 4096, 7, 1, 2048, 1, 0, -1, 2048, -1
    iSaw		ftgen   0, 0, 4096, 7, 1, 4096, -1	

    if (kWave < 4) then 
        if (kWave < 1) then  ; Sine
    	    kfn = iSine
            Swave_select strcpyk "Sine"
        elseif (kWave >= 1 && kWave < 2) then ; Tri
            kfn = iTri
            Swave_select strcpyk "Triangle"
        elseif (kWave >= 2 && kWave < 3) then ; Pulse
            kfn = iSquare
            Swave_select strcpyk "Square"
        elseif (kWave >= 3 && kWave < 4) then ; Saw
            kfn = iSaw
            Swave_select strcpyk "Sawtooth"
        endif
        aModL	osciliktp krate, kfn, 0.0
        aModR	osciliktp krate, kfn, kphase
        aModL   *= 0.5
        aModR   *= 0.5
        aModL   += 0.5
        aModR   += 0.5 
        aModL   *= kamount
        aModR   *= kamount  
        aModL   += 1-kamount 
        aModR   += 1-kamount 
    elseif (kWave >= 4) && (kWave < 5) then   
        aModL randomh 0.5-(kamount*0.5), 0.5+(kamount*0.5), krate, 3 
        aModR randomh 0.5-(kamount*0.5), 0.5+(kamount*0.5), krate, 3 
        Swave_select strcpyk "Random"
    elseif (kWave >= 5) then 
        aModL_end init 0
        aModR_end init 0

        ktrig metro krate 

        if ktrig == 1 then 
            aModL_start = aModL_end
            aModR_start = aModR_end 
        endif
        aModL_end randomh 0.5-(kamount*0.5), 0.5+(kamount*0.5), krate, 3 
        aModR_end randomh 0.5-(kamount*0.5), 0.5+(kamount*0.5), krate, 3 

        kstart_L = k(aModL_start)
        kend_L = k(aModL_end)
        klength_L = kend_L - kstart_L
        ktime_L = (krate * klength_L)/sr

        kstart_R = k(aModR_start)
        kend_R = k(aModR_end)
        klength_R = kend_R - kstart_R
        ktime_R = (krate * klength_R)/sr
        
        aModL trigphasor ktrig, (krate * klength_L)/sr, kstart_L, kend_L, kstart_L
        aModR trigphasor ktrig, (krate * klength_R)/sr, kstart_R, kend_R, kstart_R

        Swave_select strcpyk "Smooth random"
    endif
    
    aModL butlp aModL, $Smoothing_Lowpass
    aModR butlp aModR, $Smoothing_Lowpass

    if $PRINT == 1 then
        Sphase sprintfk "Autopan phase: %f", kphase
            puts Sphase, kphase+1
        Srate sprintfk "Autopan rate: %f", krate
            puts Srate, krate+1
        Samount sprintfk "Autopan amount: %f", kamount
            puts Samount, kamount+1
        Swave sprintfk "Autopan waveform: %s", Swave_select
            puts Swave, kWave+1
        
    endif

	aL		= aInL * (aModL)
	aR		= aInR * (aModR)
    a0 = 0
    xout aL, aR
endop 

;*********************************************************************
; Autopan - 1 in / 2 out
;*********************************************************************

opcode Autopan,aa,akkkO

    ain, kamount, krate, kphase, kWave  xin    

    aL, aR Autopan ain, ain, kamount, krate, kphase, kWave
 
    xout aL, aR 
endop
