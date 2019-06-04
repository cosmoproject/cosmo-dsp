/********************************************************

	Limiter.udo
	Author: Bernt Isak Wærstad

	Arguments: [Mode, Threshold, Gain]
    Defaults:  0.9, 0

	Threshold: 
    Gain: 1 - 10

	Optional arguments:
	Mode:
		0: Atan limiter
		1: Limiter
        2: Wrap
        3: Mirror

	Description:
    A limiter 

********************************************************/

	; Default argument values
	#define Threshold #0.9#
	#define Gain #0#

	; Toggle printing on/off
	#define PRINT #1#

;*********************************************************************
; Limiter - 1 in / 1 out
;*********************************************************************

opcode Limiter, a, aOPO
    ain, kmode, ktreshold, kgain xin
    
    kgain limit kgain, 0, 1
    kgain scale kgain, 10, 1
    ain *= kgain

    klow = 0.25
    khigh = -1


    if kmode == 0 then 
        ; Atan limiter
        aout = 2 * taninv(ain) / 3.1415927
    elseif kmode == 1 then 
        ; Limiter 
        aout limit ain, klow, khigh
    elseif kmode == 2 then 
        ; Wrap limiting
        aout wrap ain, klow, khigh
    elseif kmode == 3 then
        ; Mirror limiting
        aout mirror ain, klow, khigh
    endif

    xout aout
endop

;*********************************************************************
; Limiter - 1 in / 2 out
;*********************************************************************

opcode Limiter, aa, aOPO
    ain, kmode, ktreshold, kgain xin
    
    aL Limiter ain, kmode, ktreshold, kgain
    aR Limiter ain, kmode, ktreshold, kgain

    xout aL, aR 
endop

;*********************************************************************
; Limiter - 2 in / 2 out
;*********************************************************************

opcode Limiter, aa, aaOPO
    ainL, ainR, kmode, ktreshold, kgain xin
    
    aL Limiter ainL, kmode, ktreshold, kgain
    aR Limiter ainR, kmode, ktreshold, kgain

    xout aL, aR 
endop