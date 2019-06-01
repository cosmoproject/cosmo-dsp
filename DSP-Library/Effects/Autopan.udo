/********************************************************

	Autopan.udo
	Author: Bernt Isak Wærstad

	Arguments: Amount, Rate, Phase
    Defaults: 0.5, 0.25, 1

	Amount: 0% - 100%
	Rate: 0.01Hz - 100Hz 
	Phase: 0 - 360 degrees

	Description:
    An automatic panning effect

********************************************************/

	; Default argument values
	#define Amount #0.5#
	#define Rate #0.25#
	#define Phase #1#
	#define Shape #0#


	; Toggle printing on/off
	#define PRINT #1#

	; Max and minimum values
	#define MAX_RATE #100#
	#define MIN_RATE #0.01#


;*********************************************************************
; Autopan - 2 in / 2 out
;*********************************************************************

opcode Autopan,aa,aakkk

    aInL, aInR, kamount, krate, kphase xin

    kphase limit kphase, 0, 1
    krate expcurve krate, 30
    krate scale krate, 100, 0.01
    kamount limit kamount, 0, 1

    if $PRINT == 1 then
        Sphase sprintfk "Autopan phase: %f", kphase
            puts Sphase, kphase+1
        Srate sprintfk "Autopan rate: %f", krate
            puts Srate, krate+1
        Samount sprintfk "Autopan amount: %f", kamount
            puts Samount, kamount+1
    endif

    iSine		ftgen	0, 0, 65536, 10, 1	; sine

    aModL	osciliktp krate, iSine, 0.0
	aModR	osciliktp krate, iSine, kphase
    aModL   *= 0.5
    aModR   *= 0.5
    aModL   += 0.5
    aModR   += 0.5 

    	; (square root) equal power panning
	aL		= aInL * sqrt(aModL)
	aR		= aInR * sqrt(aModR)

    xout aL, aR 
endop 

;*********************************************************************
; Autopan - 1 in / 2 out
;*********************************************************************

opcode Autopan,aa,akkk

    aIn, kamount, krate, kphase xin    

    aL, aR Autopan aIn, aIn, kamount, krate, kphase
 
    xout aL, aR 
endop