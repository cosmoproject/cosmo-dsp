/********************************************************

	Stutter.udo
	Author: Bernt Isak Wærstad

	Arguments: Trigger, Speed, MoveTime, HoldTime, Volume, InsertMix mix
    Defaults:  0, 0.5, 

	Trigger: 0 - 1
	Speed: 0.1Hz - 10Hz
	ModulationIdx: 0 - 5 
	Volume: 0% - 100%
	Dry/wet mix: 0% - 100%

	Description:
	A SinMod Delay

********************************************************/

	; Default argument values
	#define Trigg #0# 
	#define Tempo #0.5#
	#define MoveTime #0.3#
	#define HoldTime #0.5#
	#define Volume #1#
	#define InsertMix #0#

	; Toggle printing on/off
	#define PRINT #0#

	; Max and minimum values
	#define MAX_MOVE #1.5#
	#define MIN_MOVE #0.1#	

	#define MAX_HOLD #1.5#
	#define MIN_HOLD #0.1#	

;*********************************************************************
; Stutter - 1 in / 1 out
;*********************************************************************


opcode Stutter, a, akkkkkk

	aIn, kStutterTrigg, kStutterTempo, kMoveTime, kHoldTime, kVolume, kInsertMix xin

    ; Pick a random subdivision
;    kDelayTime = kStutterSpeed

    kMoveTime init $MoveTime
    kHoldTime init $HoldTime
    kStutterTempo init $Tempo
	kStutterTrigg init $Trigg
	kVolume init $Volume
	kInsertMix init $InsertMix

    if kStutterTrigg == 1 && changed(kStutterTrigg) == 1 then 
        reinit STUTTER
    endif

	STUTTER:					;LABEL CALLED 'STUTTER'
        aStutter init 0
        aFeed init 0
        kFeed init 0

        iHoldTime = i(kHoldTime)
        iMoveTime = i(kMoveTime)
        iDelayTime = i(kStutterTempo)

        iFrac random 0.125, 2
        iFracDlyTime = iDelayTime * iFrac

        iMinVal = ksmps/sr

		; How to avoid reinit??? 
		
		; COULD THIS LINSEG BE STORED IN A VALUE INSTEAD?
		; OR MAYBE THE NEW EUGENS CAN FIX THIS INSTEAD 

        aStutterMove linseg iMinVal , iMoveTime, iFracDlyTime, iHoldTime, iFracDlyTime, iMoveTime, iMinVal
        kFeed        linseg 0, iMoveTime, 1, iHoldTime, 1, iMoveTime, 0
 
    aDelayL delayr 6
    aStutter deltapi aStutterMove      
    aFeed = (aStutter * kFeed)
    aFeed lpf18 aFeed, 14000, 0.2, 0.35 
        delayw aIn + aFeed 


    aOut = ((aStutter*kFeed)*kVolume) ;+ aIn

    xout aOut
endop

;*********************************************************************
; Stutter - 1 in / 2 out
;*********************************************************************


opcode Stutter, aa, akkkkkk

	aIn, kStutterTrigg, kStutterTempo, kMoveTime, kHoldTime, kVolume, kInsertMix xin

	aL Stutter aIn, kStutterTrigg, kStutterTempo, kMoveTime, kHoldTime, kVolume, kInsertMix
	aR Stutter aIn, kStutterTrigg, kStutterTempo, kMoveTime, kHoldTime, kVolume, kInsertMix

	xout aL, aR 

endop

;*********************************************************************
; Stutter - 2 in / 2 out
;*********************************************************************


opcode Stutter, aa, aakkkkkk

	aInL, aInR, kStutterTrigg, kStutterTempo, kMoveTime, kHoldTime, kVolume, kInsertMix xin

	aL Stutter aInL, kStutterTrigg, kStutterTempo, kMoveTime, kHoldTime, kVolume, kInsertMix
	aR Stutter aInR, kStutterTrigg, kStutterTempo, kMoveTime, kHoldTime, kVolume, kInsertMix

	xout aL, aR 
	
endop

; TODO: make an "overload" version that calculates from BPM to ms
; Can be done for all delay fx etc. too
; Also - make a tap tempo UDO and introduce a global tempo variable
; Can we use something like #ifndef gkTempo gkTempo = 100 

;opcode StutterBPM, aa, aakkkk
