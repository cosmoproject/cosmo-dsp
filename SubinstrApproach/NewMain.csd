
<CsoundSynthesizer>
<CsOptions>
-odac 
</CsOptions>
<CsInstruments>


#include "Reverb.csd"

instr 1

	aL, aR ins

	aInput = aL + aR * 0.5

	#define SETUP_SEND_FX(FXNAME'FXTYPE)
		#

		;aL, aR subinstr "$FXTYPE", "$FXNAME", 0.5, 0.9, 6000 
		aL, aR subinstr "Reverb", "Reverb1", 0.5, 0.9, 6000 

		chnmix aL, "MasterL"
		chnmix aR, "MasterR"
		#

/*
#define SEND_TO(INPUT'FXNAME'AMOUNT)
		#
		chnmix $INPUT * $AMOUNT, "$FXNAME._L"
		chnmix $INPUT * $AMOUNT, "$FXNAME._R"
		#
*/
	$SETUP_SEND_FX(Reverb1'Reverb)
;	$SEND_TO(aInput, Reverb1, 0.5)
	;$ROUTE_TO(aInput, Master)

	aOutL chnget "MasterL"
	aOutR chnget "MasterR" 

/*
#define	TURN_ON(NAME)
	#
	i$NAME	nstrnum	"$NAME"
	kOnTrig$NAME	trigger	gk$NAME,0.5,0
	if kOnTrig$NAME==1 then		;IF BUTTON IS TURNED ON...
	 event	"i",i$NAME,0,3600
	endif
	#
	$TURN_ON(Record)
	$TURN_ON(PlayOnce)
	$TURN_ON(PlayLoop)
*/
	outs aOutL, aOutR

endin

</CsInstruments>

/*

instr	1	;READ IN WIDGETS AND START AND STOP THE VARIOUS RECORDING AND PLAYBACK INSTRUMENTS
	gitablelen	=	ftlen(gistorageL)	;DERIVE TABLE LENGTH
	
	gkRecord	chnget	"Record"		;READ IN CABBAGE WIDGET CHANNELS
	gkPause		chnget	"Pause"
	gkPlayLoop	chnget	"PlayLoop"
	gkPlayOnce	chnget	"PlayOnce"
	gkPlayOnceTrig	changed	gkPlayOnce
	gkSpeed		chnget	"Speed"
	gkPitch		chnget	"Pitch"
	gkLoopBeg	chnget	"LoopBeg"
	gkLoopEnd	chnget	"LoopEnd"
	gkInGain	chnget	"InGain"
	gkOutGain	chnget	"OutGain"

#define	TURN_ON(NAME)
	#
	i$NAME	nstrnum	"$NAME"
	kOnTrig$NAME	trigger	gk$NAME,0.5,0
	if kOnTrig$NAME==1 then		;IF BUTTON IS TURNED ON...
	 event	"i",i$NAME,0,3600
	endif
	#
	$TURN_ON(Record)
	$TURN_ON(PlayOnce)
	$TURN_ON(PlayLoop)
endin


*/

<CsScore>
i1 0 86400
</CsScore>

</CsoundSynthesizer>

