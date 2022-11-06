/********************************************************

    EuclideanSequencer.udo
    Author: Steven Yi 
    Url: https://github.com/kunstmusik/csound-live-code/blob/master/livecode.orc#L419-L457 
    COSMO adaptation: Bernt Isak Wærstad

    Arguments: Attack, Release, Gain [, Smoothing]
    Defaults:  0.5, 0.5, 0, 0

    Attack: 0.01 - 10s
    Release: 0.01 - 10s
    Gain: 1x - 20x
    [Optional]
    Smoothing: 0.01 - 1s

    Description:
    Iterative Euclidean Beat Generator returning 1 and 0's 

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
; EuclideanSequencer - 1 in / 1 out
;*********************************************************************

opcode	EuclideanSequencer, k, ii
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

opcode EuclideanSequencer, k, ii
    ihits, isteps xin

    Sleft = "1"
    Sright = "0"

    ileft = ihits
    iright = isteps - ileft

    while iright > 1 do
        if (iright > ileft) then
            iright = iright - ileft 
            Sleft = strcat(Sleft, Sright)
        else
            itemp = iright
            iright = ileft - iright
            ileft = itemp 
            Stemp = Sleft
            Sleft = strcat(Sleft, Sright)
            Sright = Stemp
        endif
    od

    Sout = ""
    indx = 0 
    while (indx < ileft) do
        Sout = strcat(Sout, Sleft)
        indx += 1
    od
    indx = 0 
    while (indx < iright) do
        Sout = strcat(Sout, Sright)
        indx += 1
    od

    xout Sout
endop

