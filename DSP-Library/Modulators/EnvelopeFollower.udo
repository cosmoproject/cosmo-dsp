/********************************************************

    EnvelopeFollower.udo
    Author: Bernt Isak Wærstad

    Arguments: Attack, Release, Gain [, Smoothing]
    Defaults:  0.5, 0.5, 0, 0

    Attack: 0.01 - 10s
    Release: 0.01 - 10s
    Gain: 1x - 20x
    [Optional]
    Smoothing: 0.01 - 1s

    Description:
    Envelope follower with adjustable attack, release and 
    input gain.  

********************************************************/
	
    ; Default argument values
	#define Attack #0.5# 
	#define Release #0.5#
	#define Gain #0#
    #define Smoothing #0#

	; Toggle printing on/off
	#define PRINT #0#

	; Max and minimum values
	#define MAX_ATT #10#
	#define MIN_ATT #0.01#	
	#define MAX_RLS #10#
	#define MIN_RLS #0.01# 
    #define MAX_GAIN #20#
    #define MIN_GAIN #1#
    #define MAX_SMOOTH #1#
    #define MIN_SMOOTH #0.01#   


;*********************************************************************
; EnvelopeFollower - 1 in / 1 out
;*********************************************************************

opcode	EnvelopeFollower, k, akkkO
	ain, katt, krel, kgain, ksmooth xin

    ; ******************************
  	; Controller value scalings
  	; ******************************

    katt scale katt, $MAX_ATT, $MIN_ATT
    katt limit katt, $MIN_ATT, $MAX_ATT

    krel scale krel, $MAX_RLS, $MIN_RLS
    krel limit krel, $MIN_RLS, $MAX_RLS
    
    kgain scale kgain, $MAX_GAIN, $MIN_RLS
    kgain limit kgain, $MIN_RLS, $MAX_GAIN

    ksmooth scale ksmooth, $MAX_SMOOTH, $MIN_SMOOTH
    ksmooth limit ksmooth, $MIN_SMOOTH, $MAX_SMOOTH

    afollow follow2 ain * kgain, katt, krel
    kfollow downsamp afollow
    kfollow portk kfollow, ksmooth

    xout kfollow
endop

;*********************************************************************
; EnvelopeFollower - 2 in / 1 out
;*********************************************************************

opcode	EnvelopeFollower, k, aakkkO
    ainL, ainR, katt, krel, kgain, ksmooth xin

    ainMono = (ainL + ainR) * 0.5
    kfollow EnvelopeFollower ainMono, katt, krel, kgain, ksmooth 

    xout kfollow

endop

;*********************************************************************
; EnvelopeFollower - 2 in / 2 out
;*********************************************************************

opcode	EnvelopeFollower, kk, aakkkO
    ainL, ainR, katt, krel, kgain, ksmooth xin

    kfollowL EnvelopeFollower ainL, katt, krel, kgain, ksmooth 
    kfollowR EnvelopeFollower ainR, katt, krel, kgain, ksmooth 

    xout kfollowL, kfollowR
endop
