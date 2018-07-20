<CsoundSynthesizer>
<CsOptions>
-odac:hw:1,0 -iadc:hw:1 -m0d -+rtaudio=ALSA -Ma -b128 -B512 -j4 --realtime
</CsOptions>
<CsInstruments>
sr      = 44100
ksmps  	= 64
0dbfs	= 1
nchnls 	= 2

	kbak1 init 1
	kbak2 init 1
	kbak3 init 1
	gkSpeed1 init 1
	gkSpeed2 init 1
	gkSpeed3 init 1

	gktoggle4 init 0
	gktoggle5 init 0
	gktoggle6 init 0
	gktoggle7 init 0	

	kOverdub1 init 0
	kOverdub2 init 0
	kOverdub3 init 0

	initc7	15,21,0
	initc7	15,22,0
	initc7  15,23,0
	initc7  15,24,0
	initc7  15,25,0.5
	initc7  15,26,0
	initc7  15,27,0.3
	initc7  15,28,0.3
	initc7  15,41,1
	initc7  15,42,1
	initc7  15,43,1
	initc7  15,44,0.5
	initc7  15,45,0.2
	initc7  15,46,0.3
	initc7  15,47,0.5
	initc7  15,48,0.5

#include "Effects/SimpleLooper1.udo"
#include "Effects/SimpleLooper2.udo"
#include "Effects/SimpleLooper3.udo"
;#include "Effects/Convolution.udo"
;#include "Effects/FadeSwitch.udo"
;#include "Effects/FakeGrainer.udo"
#include "Effects/Lowpass.udo"
#include "Effects/MultiDelay.udo"
;#include "Effects/Octaver.udo"
#include "Effects/RandDelay.udo"
;#include "Effects/Repeater.udo"
;#include "Effects/Resonator.udo"
#include "Effects/Reverb.udo"
;#include "Effects/Reverse.udo"
#include "Effects/Wobble.udo"

instr 1 
	#include "../Includes/adc_channels.inc"
	#include "../Includes/gpio_channels.inc"

gkLCpot1		ctrl7	15, 21, 0, 1	;LaunchControl 1-16
gkLCpot2		ctrl7	15, 22, 0, 1
gkLCpot3		ctrl7   15, 23, 0, 1
kLCpot4		ctrl7   15, 24, 0, 1
kLCpot5		ctrl7   15, 25, 0, 1
kLCpot6		ctrl7   15, 26, 0, 1
kLCpot7		ctrl7   15, 27, 0, 1
kLCpot8		ctrl7   15, 28, 0, 1
gkLCpot9		ctrl7	15, 41, 0, 1
gkLCpot10	ctrl7	15, 42, 0, 1
gkLCpot11	ctrl7   15, 43, 0, 1
kLCpot12	ctrl7   15, 44, 0, 1
kLCpot13	ctrl7   15, 45, 0, 1
kLCpot14	ctrl7   15, 46, 0, 1
kLCpot15	ctrl7   15, 47, 0, 1
kLCpot16	ctrl7   15, 48, 0, 1

;kLCpot1         ctrl7   1, 24, 0, 1	;Evolution X-Session 1-16
;kLCpot2         ctrl7   1, 25, 0, 1
;kLCpot3         ctrl7   1, 26, 0, 1
;kLCpot4         ctrl7   1, 27, 0, 1
;kLCpot5         ctrl7   1, 28, 0, 1
;kLCpot6         ctrl7   1, 29, 0, 1
;kLCpot7         ctrl7   1, 30, 0, 1
;kLCpot8         ctrl7   1, 31, 0, 1
;kLCpot9         ctrl7   1, 16, 0, 1
;kLCpot10        ctrl7   1, 17, 0, 1
;kLCpot11        ctrl7   1, 18, 0, 1
;kLCpot12        ctrl7   1, 19, 0, 1
;kLCpot13        ctrl7   1, 20, 0, 1
;kLCpot14        ctrl7   1, 21, 0, 1
;kLCpot15        ctrl7   1, 22, 0, 1
;kLCpot16        ctrl7   1, 23, 0, 1

	ainL, ainR ins

	if (gkpot0 - 0.5) < 0 then
	kbak1 = -1
	else kbak1 = 1
	endif

	if (gkpot1 - 0.5) < 0 then
	kbak2 = -1
	else kbak2 = 1
	endif

	if (gkpot2 - 0.5) < 0 then
	kbak3 = -1
	else kbak3 = 1
	endif


	if gkswitch3 == 1 then
        gkSpeed1 = semitone(round(abs(gkpot0 - 0.5) * 24) - 12) * kbak1
        gkSpeed2 = semitone(round(abs(gkpot1 - 0.5) * 48) - 12) * kbak2
        gkSpeed3 = semitone(round(abs(gkpot2 - 0.5) * 72) - 12) * kbak3
        kAltpot3 = gkpot3
        kAltpot7 = gkpot7
	else
        gkSpeed1 = ((round(abs(gkpot0 - 0.5) * 12) + 2) / 4) * kbak1
        gkSpeed2 = ((round(abs(gkpot1 - 0.5) * 12) + 3) / 4) * kbak2
        gkSpeed3 = ((round(abs(gkpot2 - 0.5) * 12) + 5) / 4) * kbak3
        kAltpot0 = gkpot0
        kAltpot1 = gkpot1
        kAltpot2 = gkpot2
        kAltpot3 = gkpot3
        kAltpot4 = gkpot4
        kAltpot5 = gkpot5
        kAltpot6 = gkpot6
        kAltpot7 = gkpot7
	endif

	if gkswitch0 == 1 then
	kOverdub1 = gktoggle6
	else kOverdub1 = 0
	endif

	if gkswitch1 == 1 then
	kOverdub2 = gktoggle6
        else kOverdub2 = 0
        endif

	if gkswitch2 == 1 then
	kOverdub3 = gktoggle6
        else kOverdub3 = 0
        endif

;	if kLCpot2 > 0.5 then
;	kRep = 1
;	else kRep = 0
;	endif

	;Wobble arguments: kFreq, kDryWet
	ainL, ainR Wobble ainL, ainR, kLCpot4, kLCpot12

	; Reverb arguments: decay, cutoff, mix
	ainL, ainR Reverb ainL, ainR, kLCpot8, 0.8, kLCpot16

	; MultiDelay arguments: multitap, time, feedback, feed, LPF cutoff, mix
	gaMDLoutL, gaMDLoutR MultiDelay ainL, ainR, 0, gkpot3, kLCpot7, kLCpot15, gkpot7

	; RandDelay arguments: range, feedback, mix
	gaRDLoutL, gaRDLoutR RandDelay ainL, ainR, kLCpot6, kLCpot5, kLCpot13

	; SimpleLooper arguments: RecPlay, StopStart, Clear, Speed, Reverse, Thru
	; BasicLooper arguments: RecPlay, StopStart, Clear, Speed, Reverse, Thru, OctD, OctU
/*
	aLoop1L, aLoop1R, gkled1, gkled0 SimpleLooper1 aMDLoutL + aRDLoutL, aMDLoutR + aRDLoutR, kOverdub1, gktoggle4, 1, kSpeed1, 1, 0
	aLoop2L, aLoop2R, gkled3, gkled2 SimpleLooper2 aMDLoutL + aRDLoutL, aMDLoutR + aRDLoutR, kOverdub2, gktoggle5, 1, kSpeed2, 1, 0
	aLoop3L, aLoop3R, gkled5, gkled4 SimpleLooper3 aMDLoutL + aRDLoutL, aMDLoutR + aRDLoutR, kOverdub3, gktoggle7, 1, kSpeed3, 1, 0
*/
	; Lowpass arguments: cutoff, resonance

	gkled0 = abs(gkled0-1)
	gkled1 = abs(gkled1-1)
	gkled2 = abs(gkled2-1)
	gkled3 = abs(gkled3-1)
	gkled4 = abs(gkled4-1)
	gkled5 = abs(gkled5-1)
	gkled6 = abs(gktoggle6-1)
	gkled7 = abs(gkswitch7-1)

	aoutL = 0;aLoop1L * kLvol1 + aLoop2L * kLvol2 + aLoop3L * kLvol3 + aLoop1R * kLvol1 + aLoop2R * kLvol2 + aLoop3R * kLvol3
	aoutR = gaRDLoutL + gaMDLoutL + gaRDLoutR + gaMDLoutR ; + aLoop1R * kLvol1 + aLoop2R * kLvol2 + aLoop3R * kLvol3

	outs aoutL, aoutR

endin

instr 2

	kLvol1 init 1
	kLvol1 = gkpot4^2

	aLoop1L, aLoop1R, gkled1, gkled0 SimpleLooper1 gaMDLoutL + gaRDLoutL, gaMDLoutR + gaRDLoutR, gkOverdub1, gktoggle4, 1, gkSpeed1, 1, 0
	aLoop1L, aLoop1R Lowpass aLoop1L, aLoop1R, gkLCpot9, gkLCpot1, 0.5

    a0 = 0
    outs (aLoop1L + aLoop1R) * kLvol1, a0

endin


instr 3

	kLvol2 init 1
	kLvol2 = gkpot5^2

	aLoop2L, aLoop2R, gkled3, gkled2 SimpleLooper2 aMDLoutL + gaRDLoutL, gaMDLoutR + gaRDLoutR, gkOverdub2, gktoggle5, 1, gkSpeed2, 1, 0
	aLoop2L, aLoop2R Lowpass aLoop2L, aLoop2R, gkLCpot10, gkLCpot2, 0.5

    a0 = 0

    outs (aLoop2L+aLoop2R) * kLvol2, a0
endin

instr 4

	kLvol3 init 1
	kLvol3 = gkpot6^2

	aLoop3L, aLoop3R, gkled5, gkled4 SimpleLooper3 gaMDLoutL + gaRDLoutL, gaMDLoutR + gaRDLoutR, gkOverdub3, gktoggle7, 1, gkSpeed3, 1, 0
	aLoop3L, aLoop3R Lowpass aLoop3L, aLoop3R, gkLCpot11, gkLCpot3, 0.5

    a0 = 0
    outs (aLoop3L + aLoop3R) * kLvol3, a0
endin



</CsInstruments>
<CsScore>
i1 0 86400
</CsScore>
</CsoundSynthesizer>
