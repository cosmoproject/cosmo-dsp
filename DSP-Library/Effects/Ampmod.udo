/********************************************************

	Ampmod.udo
	Author: Bernt Isak Wærstad

	Arguments: 	ModOffset, ModFreq, ModFreqMulti, Mix [, mode, ModIndex, Feed, ModWave]
    Defaults:  

	Modoffset: 0 - 1 (0 is AM, 1 is RM)
	ModFreq: 0.05Hz - 30Hz 
	ModFreqMulti: 1 - 100 (frequency multiplier)
	Dry/wet mix: 0% - 100%
	Mode:

		0: Simple AM
		1: Julian Parker RM

	ModIndex: 1 - 10
	Feed: 0% - 100%
	ModWave: 0 - 5 (Sine, Tri, Pulse, Saw, RevSaw)

	Description:
	A flexible amplitude modulator

********************************************************/

	; Default argument values
	#define ModOffset #0#
	#define ModIndex #0#
	#define ModFreq #0.25#
	#define ModFreqMulti #0#
	#define Mode #0#
	#define ModIndex #0#
	#define Feed #0#
	#define ModWave #0#

	; Toggle printing on/off
	#define PRINT #0#

	; Max and minimum values
	#define MAX_MOD_IDX #10#
	#define MIN_MOD_IDX #1#
	#define MAX_MOD_FREQ #30#
	#define MIN_MOD_FREQ #0.05#
	#define MAX_MOD_FREQ_MULTI #100#
	#define MIN_MOD_FREQ_MULTI #1#
	

;*********************************************************************
; Ampmod - 1 in / 1 out
;*********************************************************************

opcode Ampmod,a,akkkkOOPO

	aIn, kmodOffset, kmodFreq, kmodFreqMulti, kmix, kmode, kmodIndex, kfeed, kWave  xin

	kmodOffset scale kmodOffset, 0.5, 0
	kmodOffset limit kmodOffset, 0, 0.5

	kmodIndex scale kmodIndex, $MAX_MOD_IDX, $MIN_MOD_IDX

	kmodFreq expcurve kmodFreq, 30
	kmodFreq scale kmodFreq, $MAX_MOD_FREQ, $MIN_MOD_FREQ
	kmodFreqMulti scale kmodFreqMulti, $MAX_MOD_FREQ_MULTI, $MIN_MOD_FREQ_MULTI
	kmodFreq *= kmodFreqMulti

	kmix scale kmix, 1, 0
	kmix limit kmix, 0, 1

	if $PRINT = 1 then 
		Smodoff sprintfk "Modulation offset %f", kmodOffset
			puts Smodoff, kmodOffset + 1 
		Smodidx sprintfk "Modulation index %f", kmodIndex
			puts Smodidx, kmodIndex + 1 
		Smodfreq sprintfk "Modulation frequency %f", kmodFreq
			puts Smodfreq, kmodFreq +1
		Smodmix sprintfk "Ampmod mix %f", kmix
			puts Smodmix, kmix + 1 
		Sfeed sprintfk "Ampmod feedback %f", kfeed
			puts Sfeed, kfeed+1
	endif

	kmodIndex port kmodIndex, 0.01
	kmodFreq port kmodFreq, 0.05

	kmode = kmode > 0.5 ? 1 : 0

	itab chnget "ringmod.table"

	; TABLE INIT

	if(itab == 0) then
		; generate table according to formula 2 in document
		itablen = 2^16
		itab ftgen 0, 0, itablen, -2, 0
		i_vb = 0.2
		i_vl = 0.4
		i_h = .1
		i_vl_vb_denom = ((2 * i_vl) - (2 * i_vb))
		i_vl_add =  i_h * ( ((i_vl - i_vb)^2) / i_vl_vb_denom)
		i_h_vl = i_h * i_vl

		indx = 0

		chnset itab, "ringmod.table"

		ihalf = itablen / 2

		until (indx >= itablen) do
		iv = (indx - ihalf) / ihalf
		iv = abs(iv)


		if(iv <= i_vb) then
			tableiw 0, indx, itab, 0, 0, 2
		elseif(iv <= i_vl) then
			ival = i_h * ( ((iv - i_vb)^2) / i_vl_vb_denom)
			tableiw ival, indx, itab, 0, 0, 2
		else
			ival = (i_h * iv) - i_h_vl + i_vl_add
			tableiw ival, indx, itab, 0, 0, 2
		endif
		indx += 1
		od

	endif

	; END TABLE INIT

	if (kWave < 1) then  ; Sine
    	aMod lfo 0.5, kmodFreq, 0
    elseif (kWave >= 1 && kWave < 2) then ; Tri
        aMod lfo 0.5, kmodFreq, 1
    elseif (kWave >= 2 && kWave < 3) then ; Pulse
        aMod lfo 0.5, kmodFreq, 3
    elseif (kWave >= 3 && kWave < 4) then ; Saw
        aMod lfo 0.5, kmodFreq, 4
    elseif (kWave >= 4 && kWave < 5) then ; RevSaw
        aMod lfo 0.5, kmodFreq, 5
    endif

	aMod	+= kmodOffset
	aMod	*= kmodIndex

	iSine		ftgen	0, 0, 65536, 10, 1	; sine
	aFeed		init 0

	if kmode == 0 then 
		kPostGain = (kmodIndex > 1) ? 1/kmodIndex : 1  
		aAM 		= (aIn+aFeed) * (aMod) * kPostGain
	elseif kmode = 1 then 

		ain1 = ((aIn+aFeed) * .5) 
		amod2 = aMod + ain1
		ain2 = aMod - ain1

		asig1 table3 amod2, itab, 1, 0.5
		asig2 table3 amod2 * -1, itab, 1, 0.5
		asig3 table3 ain2, itab, 1, 0.5
		asig4 table3 ain2 * -1, itab, 1, 0.5

		asiginv = (asig3 + asig4) * -1

		aAM sum asig1, asig2, asiginv
	endif

	aFeed = aAM * kfeed
	aOut ntrpol aIn, aAM, kmix
		
	xout aOut 

endop

;*********************************************************************
; Ampmod - 1 in / 2 out
;*********************************************************************

opcode Ampmod,aa,akkkkOOPO

	aIn, kmodOffset, kmodFreq, kmodFreqMulti, kmix, kmode, kmodIndex, kfeed, kWave  xin

	aL Ampmod aIn, kmodOffset, kmodFreq, kmodFreqMulti, kmix, kmode, kmodIndex, kfeed, kWave  
	aR Ampmod aIn, kmodOffset, kmodFreq, kmodFreqMulti, kmix, kmode, kmodIndex, kfeed, kWave   

	xout aL, aR 
endop

;*********************************************************************
; Ampmod - 2 in / 2 out
;*********************************************************************

opcode Ampmod,aa,aakkkkOOPO

	aInL, aInR, kmodOffset, kmodFreq, kmodFreqMulti, kmix, kmode, kmodIndex, kfeed, kWave    xin

	aL Ampmod aInL, kmodOffset, kmodFreq, kmodFreqMulti, kmix, kmode, kmodIndex, kfeed, kWave 
	aR Ampmod aInR, kmodOffset, kmodFreq, kmodFreqMulti, kmix, kmode, kmodIndex, kfeed, kWave  

	xout aL, aR 
endop
