<CsoundSynthesizer>
<CsOptions>
; real-time audio in and out are both activated
-iadc -odac -d -m0 -Ma
</CsOptions>

<CsInstruments>

sr 	= 	44100
ksmps 	= 	32
nchnls 	= 	2

#include "../DSP-Library/Includes/cosmo_utilities.inc"

#include "../DSP-Library/Effects/needs_work/ClipSampler.udo"
#include "../DSP-Library/Effects/needs_work/Stutter.udo"

instr 1 

    kKey sensekey 
    krec init 0
    kclip init 0
    kplay init 0

    krec ctrl7 1, 50, 0, 1

    kclip0 ctrl7 1, 20, 0, 1
    kclip1 ctrl7 1, 21, 0, 1
    kclip2 ctrl7 1, 22, 0, 1
    kclip3 ctrl7 1, 23, 0, 1
    kclip4 ctrl7 1, 24, 0, 1
    kclip5 ctrl7 1, 25, 0, 1
    kclip6 ctrl7 1, 26, 0, 1
    kclip7 ctrl7 1, 27, 0, 1
    kclip8 ctrl7 1, 28, 0, 1
    kclip9 ctrl7 1, 29, 0, 1

    kplay = kclip0+kclip1+kclip2+kclip3+kclip4+kclip5+kclip6+kclip7+kclip8+kclip9
    kplay limit kplay, 0, 1

    if kclip0 == 1 then
        kclip = 0
    elseif kclip1 == 1 then
        kclip = 1
    elseif kclip2 == 1 then
        kclip = 2
    elseif kclip3 == 1 then
        kclip = 3
    elseif kclip4 == 1 then
        kclip = 4
    elseif kclip5 == 1 then
        kclip = 5
    elseif kclip6 == 1 then
        kclip = 6
    elseif kclip7 == 1 then
        kclip = 7
    elseif kclip8 == 1 then
        kclip = 8
    elseif kclip9 == 1 then
        kclip = 9
    endif
    
    /*
    if kKey=114 && krec == 0 then
        krec = 1
    elseif kKey=114 && krec = 1 then
        krec = 0
    endif
    */


    /*
    if kKey=49 && kplay == 0 then
        kplay = 1
        kclip = 0
    elseif kKey=49 && kplay = 1 then
        kplay = 0
    endif

    if kKey=50 && kplay == 0 then
        kplay = 1
        kclip = 1
    elseif kKey=50 && kplay = 1 then
        kplay = 0
    endif

    if kKey=51 && kplay == 0 then
        kplay = 1
        kclip = 2
    elseif kKey=51 && kplay = 1 then
        kplay = 0
    endif
    */

    kTrig ctrl7 1, 55, 0, 1


    ain inch 1
    iBuf BufCrt1 60

    kf BufRec1 ain, iBuf, krec, 0, 0, 0

    aOut ClipPlay1 iBuf, kplay, kclip, 1, 1, 0

;	aIn, kStutterTrigg, kStutterSpeed, kMoveTime, kHoldTime, kVolume, kInsertMix xin

    kSwitch init 0
   ; printk2 kTrig

    if kTrig == 1 && changed(kTrig) == 1 then
        kSwitch = (kSwitch+1) % 2
    endif

    kTrig1 = kSwitch
    kTrig2 = 1-kSwitch
    printk2 kSwitch

	aStutt1 Stutter aOut, kTrig1, 0.25, 0.6, 0.2, 1, 1
	aStutt2 Stutter aOut, kTrig2, 0.4, 0.05, 0.3, 1, 1

    outs aOut, aStutt1+aStutt2

endin

</CsInstruments>
<CsScore>
i 1 0 3600 ; Sense keyboard activity. Start recording - playback.
</CsScore>
</CsoundSynthesizer>