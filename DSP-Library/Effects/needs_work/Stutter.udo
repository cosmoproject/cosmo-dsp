; TODO: make an "overload" version that calculates from BPM to ms
; Can be done for all delay fx etc. too
; Also - make a tap tempo UDO and introduce a global tempo variable
; Can we use something like #ifndef gkTempo gkTempo = 100 

;opcode StutterBPM, aa, aakkkk

/********************************************************

	Stutter.udo
	Author: Bernt Isak Wærstad

	Arguments: Trigger, Speed, MoveTime, HoldTime, Volume, InsertMix mix
    Defaults:  


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
	#define Speed #0.5#
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

	aIn, kStutterTrigg, kStutterSpeed, kMoveTime, kHoldTime, kVolume, kInsertMix xin

    ; Pick a random subdivision
;    kDelayTime = kStutterSpeed

    kMoveTime init $MoveTime
    kHoldTime init $HoldTime
    kStutterSpeed init $Speed
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
        iDelayTime = i(kStutterSpeed)
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

	aIn, kStutterTrigg, kStutterSpeed, kMoveTime, kHoldTime, kVolume, kInsertMix xin

	aL Stutter aIn, kStutterTrigg, kStutterSpeed, kMoveTime, kHoldTime, kVolume, kInsertMix
	aR Stutter aIn, kStutterTrigg, kStutterSpeed, kMoveTime, kHoldTime, kVolume, kInsertMix

	xout aL, aR 

endop

;*********************************************************************
; Stutter - 2 in / 2 out
;*********************************************************************


opcode Stutter, aa, aakkkkkk

	aInL, aInR, kStutterTrigg, kStutterSpeed, kMoveTime, kHoldTime, kVolume, kInsertMix xin

	aL Stutter aInL, kStutterTrigg, kStutterSpeed, kMoveTime, kHoldTime, kVolume, kInsertMix
	aR Stutter aInR, kStutterTrigg, kStutterSpeed, kMoveTime, kHoldTime, kVolume, kInsertMix

	xout aL, aR 
	
endop

/*
	;kStutterBang
	kStutterToggle = kStutterBang

	kFeedback init 0
	kTmp = 0

	printk2 kStutterBang

	if (kStutterBang == 1) then
		kFeedback = 0.97
 		;kFeedback delayk kTmp, 2 ; set to 0 after 0.5s
 	else
 		kFeedback = 0
 	endif

	kStutterPoint init 0.5

	kTrig metro 1

	if kTrig == 1 then
		kStutterPoint random 0.1, 0.5
	endif 

	aDelayL delayr 20
	aWetL	deltapi kStutterPoint
	aStuttL	= (aL + (aWetL * kFeedback))
			delayw aStuttL

	aDelayR delayr 20
	aWetR	deltapi kStutterPoint
	aStuttR	= (aR + (aWetR * kFeedback))
			delayw aStuttR


	aOutL = (aL * (1-kStutterBang)) + (aWetL)
	aOutR = (aR * (1-kStutterBang)) + (aWetR)

	if (kStutterBang == 0) && (kStutterToggle == 0) then
		aOutL = aL
		aOutR = aR
	endif

	xout aOutL, aOutR

endop
*/

/*


opcode Stutter, aa, aakkkk

	aL, aR, kOnOff, kChangeFreq, kStutterSpeed, kInsertMix xin



	; Todo: scale kStutterPoint by kStutterSpeed



	kStutterPoint init 0.3

	kTrig metro kChangeFreq
	if kTrig == 1 then
		kStutterPoint random 0.1, 2
	endif 

	if (kOnOff == 0) then
		kFeedback = 0
	else
		kFeedback = 1
	endif

	kOnOffInverse = kOnOff == 1 ? 0 : 1

	aDelayL delayr 6
	aWetL	deltapi kStutterPoint
			delayw ((aL*kOnOffInverse) + (aWetL * kFeedback))

	aDelayR delayr 6
	aWetR	deltapi kStutterPoint
			delayw ((aR*kOnOffInverse) + (aWetR *kFeedback))	

	if (kOnOff == 0) then
		aDelayL = 0
		aDelayR = 0
		aWetL = 0
		aWetR = 0
	endif

	aOutL = (aL * kInsertMix) + (aWetL * kOnOff)
	aOutR = (aR * kInsertMix) + (aWetR * kOnOff)

	if kOnOff == 0 then
		aOutL = aL
		aOutR = aR
	endif

	xout aOutL, aOutR

endop

*/