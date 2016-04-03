<CsoundSynthesizer>
<CsOptions>
-odac:hw:1,0 -d -+rtaudio=ALSA -b128 -B1024 --sched=99 -+rtmidi=alsa -M hw:2 
</CsOptions>

<CsInstruments>

sr 		= 	44100	;SAMPLE RATE
ksmps 		= 	32	;NUMBER OF AUDIO SAMPLES IN EACH CONTROL CYCLE
nchnls 		= 	2	;NUMBER OF CHANNELS (2=STEREO)
0dbfs		=	1

massign	0,0
	
;Author: Iain McCurdy (2012)
;http://www.iainmccurdy.org	

giseqorder	ftgen	0,0,1024,-2,0	;ORDERED ROW OF NOTES (IN THE ORDER IN WHICH THEY WERE PLAYED)
giseqascend	ftgen	0,0,1024,-2,0	;ORDERED ROW OF NOTES (IN ASCENDING ORDER)
ginoteactive	ftgen	0,0,128,-2,0	;TABLE OF NOTE ON STATUSES 1=ON 0=OFF
giblank		ftgen	0,0,128,-2,0	;BLANK TABLE
gisine		ftgen	0,0,4096,10,1
giFletcherMunsonCurve	ftgen	0,0,-20000,-16,1,4000,-8,0.15, 20000-4000,0,0.15

giTempoMlt	ftgen	0,0,-8,-2,1/4,1/3,1/2,1,3/2,2,3,4	;TABLE OF TEMPO MULTIPLIERS - USED TO SCALE THE ARPEGGIO RATE WHEN IN TEMPO MODE
gasendL,gasendR	init	0					;GLOBAL VARIABLES USED TO SEND SIGNAL TO THE DELAY EFFECT

;UDO THAT SORTS A TABLE OF NUMBERS INTO ASCENDING ORDER
opcode	tabsort_ascnd2,0,ii
	iNumItems,ifn	xin
	iTabLen		=		ftlen(ifn)
	imax		table		0,ifn
	icount		=		1
	loop1:
	  ival		table		icount,ifn
	  imax 		= 		(ival>=imax?ival:imax)
	  		loop_lt		icount,1,iNumItems,loop1
	iTableBuffer	ftgentmp	0,0,iTabLen,-2, 0
	icount1		=		0
	loop2:
	  icount2	=		0
	  imin		=		imax
	  loop3:
	    ival	table		icount2,ifn
	    if ival<=imin then			
	      imin 	= 		ival
	      iloc 	= 		icount2 
	    endif
	    		loop_lt		icount2,1,iNumItems,loop3
			tableiw		imin,icount1,iTableBuffer
			tableiw		imax,iloc,ifn
			loop_lt		icount1,1,iNumItems,loop2
	icount		=		0
	loop4:
	ival		table		icount,iTableBuffer
			tableiw		ival,icount,ifn
			loop_lt		icount,1,iNumItems,loop4
endop

opcode	FreqShifter,a,aki
	ain,kfshift,ifn	xin					;READ IN INPUT ARGUMENTS
	areal, aimag hilbert ain				;HILBERT OPCODE OUTPUTS TWO PHASE SHIFTED SIGNALS, EACH 90 OUT OF PHASE WITH EACH OTHER
	asin 	oscili       1,    kfshift,     ifn,          0
	acos 	oscili       1,    kfshift,     ifn,          0.25	
	;RING MODULATE EACH SIGNAL USING THE QUADRATURE OSCILLATORS AS MODULATORS
	amod1	=		areal * acos
	amod2	=		aimag * asin	
	;UPSHIFTING OUTPUT
	aFS	= (amod1 - amod2)
		xout	aFS				;SEND AUDIO BACK TO CALLER INSTRUMENT
endop

;This instrument needs to be last in order for the 'hold' function to work properly. I'm not sure why.
instr	ScanWidgets
	gkintvl		chnget	"intvl"
	gkintvl init 7
	gkcycles	chnget	"cycles"
	gkcycles init 5
	gktempo		chnget	"tempo"		;INTERNAL GUI CONTROL
	gktempo init 120

	gkCyUpDn	chnget	"CyUpDn"
	gkCyUpDn init 1
	gkTempoMlt	chnget	"TempoMlt"
	gkTempoMlt init 3

	gkhold		chnget	"hold"
	gkhold init 0
	gkmode		chnget	"mode"
	gkmode init 1

	gkswing		chnget	"swing"	
	gkswing init 0.1
	gkpause		chnget	"pause"
	gkpause init 0
	gkonoff		chnget	"onoff"
	gkonoff init 1
	gkAatt		chnget	"Aatt"
	gkAatt init 0.001
	gkAdec		chnget	"Adec"
	gkAdec init 0.001
	gkAsus		chnget	"Asus"
	gkAsus init 1
	gkArel		chnget	"Arel"
	gkArel init 0.01
	gkEnvAmt	chnget	"EnvAmt"
	gkEnvAmt init 0.5
	gkatt		chnget	"att"
	gkatt init 0.001
	gkdec		chnget	"dec"
	gkdec init 0.5
	gksus		chnget	"sus"
	gksus init 0.5
	gkrel		chnget	"rel"
	gkrel init 0.1
	gkres		chnget	"res"
	gkres init 0.5
	gkdist		chnget	"dist"
	gkdist init 0
	gkKybdTrk	chnget	"KybdTrk"
	gkKybdTrk init 1
	gkFiltType	chnget	"FiltType"
	gkFiltType init 0
	gkLFOdep	chnget	"LFOdep"
	gkLFOdep init 0.15
	gkLFOrate	chnget	"LFOrate"
	gkLFOrate init 0.07
	gkwave		chnget	"wave"
	gkwave init 2
	gkOctTrans	chnget	"OctTrans"
	gkOctTrans init 4
	gkSemiTrans	chnget	"SemiTrans"
	gkSemiTrans init 11
	gkNotePort	chnget	"NotePort"
	gkNotePort init 0
	gkSynLev	chnget	"SynLev"
	gkSynLev init 0.3
	gksubosc	chnget	"subosc"
	gksubosc init 0
	gkFShift	chnget	"FShift"	
	gkFShift init 0
	gkDryWet	chnget	"DryWet"
	gkDryWet init 0.1
	gkDlyTim	chnget	"DlyTim"
	gkDlyTim init 4
	gkDlyFB		chnget	"DlyFB"	
	gkDlyFB init 0.5
	gkZeroFS	chnget	"ZeroFS"
	kzero		=	0
	if changed(gkZeroFS)==1 then
	 chnset	kzero,"FShift"
	endif
endin

instr	ScanMIDI	;SCAN INCOMING MIDI AND TRIGGER NOTES IN INSTRUMENT 'NoteLayer'
	insno 	nstrnum "NoteLayer"
	kstatus, kchan, kdata1, kdata2  midiin; read in midi
	if kstatus==144||kstatus==128 then
	 if kdata2>0&&kstatus==144 then				;IF VELOCITY IS GREATER THAN 0 (I.E. FOR SOME KEYBOARDS VELOCITY ZERO IS A NOTE OFF)
	  kAlreadyActiveStatus	table	kdata1,ginoteactive	;CHECK IF THIS NOTE IS ALREADY ACTIVE (POSSIBLE IF HOLD IS ON).
	  if kAlreadyActiveStatus==0 then			;IF THIS NOTE IS NOT ALREADY ACTIVE...
	   event "i",insno+(kdata1*0.001),0,3600,kdata1	;
	  endif
	 else
	  if gkhold==0 then
	   turnoff2	insno+(kdata1*0.001),4,1
	  endif
	 endif
	elseif kstatus==128&&gkhold==0 then		;IF MIDI KEYBOARD USES NOTE OFF STATUS BYTE
	 turnoff2	insno+(kdata1*0.001),4,1
	endif
endin	

instr	NoteLayer				;THIS INSTRUMENT IS TRIGGERED FOR EACH NOTE PLAYED ON THE KEYBOARD
	inum	=	p4			;READ IN MIDI NOTE NUMBER		
	tableiw	1,inum,ginoteactive
	iNNotes	active	"NoteLayer"		;SENSE THE NUMBER INSTANCES OF THIS INSTRUMENT (I.E. MIDI NOTES) ARE BEING HELD AT I-TIME.
	tableiw	inum,iNNotes-1,giseqorder	;WRITE THE NOTE NUMBER OF THIS NOTE TO THE NEXT LOCATION IN THE ORDERED ROW OF NOTES (giseqorder)
	tableicopy	giseqascend,giseqorder	;COPY THE LIST OF NOTES (IN THE ORDER IN WHICH THEY WERE PLAYED) INTO THE TABLE OF NOTES TO BE SORTED INTO ASCENDING ORDER
	tabsort_ascnd2	iNNotes,giseqascend	;UDO CALLED THAT ORDERS THE LIST OF NOTES INTO ASCENDING ORDER
	
	krelease	release			;SENSE WHEN THIS NOTE HAS BEEN RELEASED
	if krelease==1 then			;IF THIS NOTE HAS BEEN RELEASED (FINAL K-RATE CYCLE)...
	 tablew	0,inum,ginoteactive
	 ;AS THIS NOTE HAS BEEN RELEASED IT WILL HAVE TO BE REMOVED FROM THE ORDERED ROW OF NOTE (giseqorder). ALL NOTES *AFTER* IT IN THE ROW WILL HAVE TO BE SHUNTED BACK ONE PLACE.
	 kShuntNdx	=	iNNotes		;INITIAL SHUNT INDEX (THE LOCATION TO WHICH THE NOTE NUMBER FOR THIS NOTE WAS WRITTEN)
	 kNNotes	active	"NoteLayer"	;FIND THE NUMBER OF INSTANCES OF THIS INSTRUMENT (I.E. NOTES BEING HELD) NOW
	 SHUNT_ROW:				;A LABEL. THE SHUNTING PROCEDURE LOOPS FROM HERE.
	 kval	table	kShuntNdx, giseqorder	;READ THE NOTE NUMBER JUST AFTER THIS ONE IN THE SEQUENCE ROW...
	 	tablew	kval, kShuntNdx-1, giseqorder	;AND MOVE IT BACK ONE PLACE
	 loop_lt	kShuntNdx,1,kNNotes,SHUNT_ROW	;LOOP BACK AND REPEAT THE SHUNTING PROCEDURE UNTIL THE NEW ROW IS COMPLETE
	endif
	
	kHoldOff	trigger	gkhold,0.5,1	;IF HOLD GOES FROM '1'/'ON' TO '0'/'OFF' GENERATE A TRIGGER IMPULSE
	if kHoldOff==1 then			;IF HOLD GOES FROM 'ON' TO 'OFF'... 
	 turnoff				;TURN THIS (AND ALL OTHER) NOTES OFF
	endif					;END OF CONDITIONAL BRANCH

	if iNNotes==1 then			;IF THIS IS THE FIRST NOTE OF AN ARPEGGIO TO BE PLAYED...
	 event_i "i","Arpeggiator",0,-1		;START ARPEGGIATOR INSTRUMENT WITH A 'HELD' NOTE. SEND IT THE MIDI NOTE NUMBER.
	endif					;END OF CONDITIONAL BRANCH

	insnoArp 	nstrnum "Arpeggiator"
	if gkonoff==0 then
	 turnoff2	insnoArp,0,1
	 tablecopy	ginoteactive,giblank		;ERASE NOTE STATUSES TABLE
	 turnoff
	endif
endin


instr	Arpeggiator	
	krelease	release				;SENSE END OF NOTE (1)
	kporttime	linseg	0,0.001,0.05

	ktrans		=	((gkOctTrans-7)*12)+(gkSemiTrans-12)

	kHoldOff	trigger	gkhold,0.5,1		;IF HOLD GOES FROM '1'/'ON' TO '0'/'OFF' GENERATE A TRIGGER IMPULSE
	if kHoldOff==1 then				;IF HOLD GOES FROM 'ON' TO 'OFF'... 
	 tablecopy	ginoteactive,giblank		;ERASE NOTE STATUSES TABLE
	 turnoff					;TURN THIS INSTRUMENT OFF
	endif						;END OF CONDITIONAL BRANCH

	kNNotes	active	"NoteLayer"			;NUMBER OF INSTR 1 (MIDI NOTES) BEING HELD. SPECIFICALLY WE ARE INTERESTED IN WHETHER ALL NOTES HAVE BEEN RELEASED	
	
	if kNNotes==0&&gkhold==0 then			;IF ALL MIDI KEYBOARD NOTES HAVE BEEN RELEASED...
	 turnoff					;...TURN THIS INSTRUMENT OFF
	endif						;END OF CONDITIONAL BRANCH

	kswingval1	scale	gkswing,1/1.5,1
	kswingval2	scale	gkswing,1/0.5,1
	kswingstep	init	0
	kswingval	init	(i(gkswing)*0.5) + 1
	
	kTempoMlt	table	gkTempoMlt-1,giTempoMlt
	
	gkrate	=	(gktempo/60)*kTempoMlt*4*(1-gkpause)		;DERIVE TEMPO FROM BPM AND TEMPO MULTIPLIER
	
	ktrigger	metro	gkrate*kswingval			;METRONOME TO TRIGGER NOTES OF THE ARPEGGIO. PHASE OFFSET (P2) PREVENTS A SEARCH FOR A NEW NOTE WHEN THE FIRST NOTE OF AN ARPEGGIO HAS BEEN PLAYED

	;SET REQUIRED INITIAL SETTINGS DEPENDING ON ARPEGGIATOR MODE
	ktrig	changed	gkmode
	if ktrig==1 then
	 reinit	RESET_START_VALS
	endif
	RESET_START_VALS:
	kcount1	init	0
	kcount2	init	0
	kndx	init	0
	kcycle	init	0
	kCycleDir	init	0
	if i(gkmode)==1 then				;IF UP MODE...
	 kcount1	init	0
	 kcount2	init	0
	 kndx	init	0
	 kdir	init	1
	elseif i(gkmode)==2 then			;IF DOWN MODE...
	 kcount1	init	0
	 kcount2	init	0
	 kndx	init	i(kNNotes)-1
	 kdir	init	-1
	elseif i(gkmode)==3 then			;IF UP AND DOWN MODE...
	 kdir	init	1
	 kcount1	init	0
	 kcount2	init	0
	 kndx	init	0
	elseif i(gkmode)==4 then			;RANDOM DIRECTION MODE...
	 kdir	init	1
	 kcount1	init	0
	 kcount2	init	0
	 kndx	init	0
	elseif i(gkmode)==5 then			;RANDOM PICK MODE...
	 kcount1	init	0
	 kcount2	init	0
	 kndx	init	0
	elseif i(gkmode)==6 then			;SEQUENCE PLAY MODE...
	 kcount1	init	0
	 kcount2	init	0
	 kndx	init	0
	 kdir	init	1
	endif
	rireturn
	
	if ktrigger==1&&krelease!=1 then		;IF A TRIGGER FOR A NEW NOTE HAS BEEN ISSUED AND WE ARE NOT IN A RELEASE STAGE...

 	 ktrans		=	((gkOctTrans-4)*12)+(gkSemiTrans-12)

	 kswingstep	=	abs(kswingstep-1)
	 kswingval	=	(kswingstep=0?kswingval1:kswingval2)
	
	 ;UP
	 if gkmode==1 then				;IF 'UP' DIRECTION MODE IS SELECTED...
	  knum		table	kndx,giseqascend	;READ NOTE NUMBER
	  knum		=	knum+(gkintvl*kcycle)
	  kcount1	=	kcount1 + 1
	  ktrig		changed	kNNotes
	  if ktrig==1 then				;IF NOTES ARE ADDED OR TAKEN AWAY FROM THE ROW SINCE THE LAST ITERATION
	   kcount1	=	kndx+1
	  endif	  
	  if kndx==kNNotes-1 then
	   kcount2	=	kcount2+1
	   if gkCyUpDn==1 then
	    kcycle	wrap	kcount2,0,gkcycles+1
	   else
	    kcycle	mirror	kcount2,0,gkcycles
	   endif	    
	  endif	  
	  kndx		wrap	kcount1,-0.5,kNNotes-0.5  
	  


	 ;DOWN
	 elseif gkmode==2 then				;IF 'DOWN' DIRECTION MODE IS SELECTED...
	  knum		table	kndx,giseqascend	;READ NOTE NUMBER
	  knum		=	knum+(gkintvl*kcycle)
	  if kndx==0 then
	   kcount2	=	kcount2+1
	   if gkCyUpDn==1 then
	    kcycle	wrap	kcount2,0,gkcycles+1
	   else
	    kcycle	mirror	kcount2,0,gkcycles
	   endif	    
	  endif	  
	  kcount1	=	kcount1 - 1
	  ktrig		changed	kNNotes
	  if ktrig==1 then				;IF NOTES ARE ADDED OR TAKEN AWAY FROM THE ROW SINCE THE LAST ITERATION
	   kcount1	=	kndx-1
	  endif	  
	  kndx		wrap	kcount1,-0.5,kNNotes-0.5  



	
	 ;UP-DOWN
	 elseif gkmode==3 then				;IF 'UP<->DOWN' DIRECTION MODE IS SELECTED...
	  if gkcycles==0 then
	   if kNNotes==1 then
	    kdir	=	0
	   elseif kndx=0 then				;OR IF... THE INDEX IS POINTING TO THE FIRST NOTE IN THE LIST, WE NEED TO CHANGE DIRECTION TO UP FOR THE NEXT NOTE AFTER THIS ONE
	    kdir	=	1			;CHANGE DIRECTION TO UP
	   elseif kndx=(kNNotes-1) then			;IF THE INDEX IS POINTING TO THE LAST NOTE IN THE LIST, WE NEED TO CHANGE DIRECTION TO DOWN FOR THE NEXT NOTE AFTER THIS ONE
	    kdir	=	-1			;CHANGE DIRECTION TO DOWN
	   endif					;END OF CONDITIONAL
	   kndx	=	kndx + kdir
	   knum		table	kndx,giseqascend	;READ NOTE NUMBER
	   kgoto PLAY_A_NOTE				;GO STRAIGHT TO PLAYING THIS NEW NOTE

	  else
	   kndx		limit	kndx,0,kNNotes-1
	   knum		table	kndx,giseqascend	;READ NOTE NUMBER
	   knum		=	knum+(gkintvl*kcycle)
	   kcount	init	i(kndx)
	   kcount	=	kcount + 1
	   kndx		mirror	kcount,0,kNNotes-1
	   if kndx==0 then
	    kcount2	init	i(kcycle)
	    kcount2	=	kcount2+1	    
	    if gkCyUpDn==1 then
	     kcycle	wrap	kcount2,0,gkcycles+1
	    else
	     kcycle	mirror	kcount2,0,gkcycles
	    endif	    
	   endif
	   
	   kgoto PLAY_A_NOTE				;GO STRAIGHT TO PLAYING THIS NEW NOTE
	  endif
	 
	 
	 
	 
	 
	 
	 
	 
	 
	 
	 
	 
	 
	 ;RANDOM DIRECTION
	 elseif gkmode==4 then
	  if kndx==(kNNotes-1) then			;IF THE INDEX IS POINTING TO THE LAST NOTE IN THE LIST, WE NEED TO CHANGE DIRECTION TO DOWN FOR THE NEXT NOTE AFTER THIS ONE
	   kdir	=	-1				;CHANGE DIRECTION TO DOWN
	  elseif kndx==0 then				;OR IF... THE INDEX IS POINTING TO THE FIRST NOTE IN THE LIST, WE NEED TO CHANGE DIRECTION TO UP FOR THE NEXT NOTE AFTER THIS ONE
	   kdir	=	1				;CHANGE DIRECTION TO UP
	  endif						;END OF CONDITIONAL
	  knum		table	kndx,giseqascend	;READ NOTE NUMBER	
	  if gkcycles>0 then
	   knum	=	knum+(gkintvl*kcycle)
	  endif	
	  if kndx==(kNNotes-1) then
	   kcycle	wrap	kcycle+1,0,gkcycles+1
	  elseif kndx==0 then	
	   kcycle	wrap	kcycle-1,0,gkcycles+1
	  endif
	  kndx	=	kndx+kdir			;INCREMENT INDEX FOR THE NEXT NOTE AFTER THIS ONE
	  kgoto PLAY_A_NOTE				;GO STRAIGHT TO PLAYING THIS NEW NOTE


	 
	 ;RANDOM PICK (RANDOMLY CHOOSE ANY NOTE CURRENTLY BEING HELD)
	 elseif gkmode==5 then
	  kRndNdx	random	0,kNNotes		;CREATE RANDOM INDEX
	  knum		table	kRndNdx,giseqorder	;READ NOTE FROM NOTE LIST USING RANDOM INDEX
	  knum	=	knum+(gkintvl*kcycle)
	  if kndx==kNNotes-1 then
	   kcount2	=	kcount2 + 1
	   if gkCyUpDn==1 then
	    kcycle	wrap	kcount2,0,gkcycles+1
	   else
	    kcycle	mirror	kcount2,0,gkcycles
	   endif
	  endif
	  kndx	wrap	kndx+1,0,kNNotes		;INCREMENT THE COUNTER BUT WRAP IT AROUND IF IT STRAYS BEYOND THE VALUE CORRESPONDING TO THE NUMBER OF NOTES BEING HELD (I.E. THE LENGTH OF THE SEQUENCE)
	  kgoto	PLAY_A_NOTE				;GO STRAIGHT TO PLAYING THIS NEW NOTE


	
	 ;SEQUENCE PLAY (PLAYS NOTES IN THE ORDER IN WHICH THEY WERE ORIGINALLY PLAYED)
	 else
	  knum	table	kndx,giseqorder			;READ NOTE VALUE FROM TABLE
	  if gkcycles!=0 then
	   knum	=	knum+(gkintvl*kcycle)
	  endif	
	  if kndx==kNNotes-1 then
	   kcount2	=	kcount2 + 1
	   if gkCyUpDn==1 then
	    kcycle	wrap	kcount2,0,gkcycles+1
	   else
	    kcycle	mirror	kcount2,0,gkcycles
	   endif
	  endif
	  kndx	wrap	kndx+1,0,kNNotes		;INCREMENT THE COUNTER BUT WRAP IT AROUND IF IT STRAYS BEYOND THE VALUE CORRESPONDING TO THE NUMBER OF NOTES BEING HELD (I.E. THE LENGTH OF THE SEQUENCE) 
	  kgoto PLAY_A_NOTE				;GO STRAIGHT TO PLAYING THIS NEW NOTE
	 endif
	endif
	
	
	
	
	
	PLAY_A_NOTE:
	if gkmode==4&&ktrigger==1 then			;IF RANDOM DIRECTION MODE HAS BEEN CHOSEN, CHOOSE A NEW RANDOM DIRECTION FOR THE NEXT STEP 
	 kdir	random	0,1.999999			;
	 kdir	=	(int(kdir)*2)-1			;kdir WILL BE EITHER -1 OR 1
	endif

	;PORTAMENTO ADDED TO NOTE NUMBER CHANGES
	kporttime	linseg	0,0.001,0.1
	knum2		portk	knum+ktrans,kporttime*gkNotePort
	kcps		limit	cpsmidinn(knum2),0,10000
	kAmpScale	table	kcps,giFletcherMunsonCurve
	
	a1	vco2	gkSynLev*kAmpScale,kcps,12		;TRIANGLE WAVE OSCILLATOR
	a2	vco2	gkSynLev*kAmpScale,kcps,10		;SQUARE WAVE OSCILLATOR
	a3	vco2	gkSynLev*kAmpScale,kcps,0,0.5		;SAWTOOTH WAVE OSCILLATOR
  	a4	pinkish	gkSynLev				;PINK NOISE
		
	ifadecurve	ftgenonce	0,0,1024,20,2		;HANNING WINDOW USED FOR THE CROSSFADING CURVES
	kamp1	table	(((gkwave-1)/3)*1.5)+0.5,ifadecurve,1	;TRIANGLE WAVE AMPLITUDE CONTROL EACH OF THE AMPLITUDES ARE OFFSET WITH RESPECT TO EACH OTHER. NOTE THAT IF INDEX IS LESS THAN 0 IT WILL ACTUALLY HOLD READING AT ZERO IF ITS GREATER THAN '1' IT WILL HOLD AT 1
	kamp2	table	(((gkwave-1)/3)*1.5),ifadecurve,1	;SQUARE WAVE AMPLITUDE CONTROL
	kamp3	table	(((gkwave-1)/3)*1.5)-0.5,ifadecurve,1	;SAW WAVE AMPLITUDE CONTROL
	kamp4	table	(((gkwave-1)/3)*1.5)-1,ifadecurve,1	;PINK NOISE AMPLITUDE CONTROL
	aamp1	interp	kamp1
	aamp2	interp	kamp2
	aamp3	interp	kamp3
	aamp4	interp	kamp4
	a1	sum	a1*aamp1,a2*aamp2,a3*aamp3,a4*aamp4
	
	;SUB-OSCILLATOR
	if gksubosc==1 then
	 asub	vco2	gkSynLev*kAmpScale*0.6,kcps*0.25,10	
	 a1	=	a1 + asub
	endif
	
	if ktrigger==1 then
	 reinit RETRIGGER_ENVELOPES
	endif
	RETRIGGER_ENVELOPES:

	/*AMPLITUDE ENVELOPE*/
	if gkAatt+gkAdec=0.002&&gkAsus==1 kgoto SKIP_AMP_ENV	;IF ATTACK AND/OR DECAY TIME ARE AT THEIR MINIMUM SETTINGS AND SUSTAIN LEVEL IS MAXIMUM IGNORE AMPLITUDE ENVELOPE CREATION AND IMPLEMENTATION - I.E. WE WIL HAVE SIMPLY A SUSTAINING INSTRUMENT  
	iAatt	=	i(gkAatt)
	iAdec	=	i(gkAdec)
	iAsus	=	i(gkAsus)
	iArel	=	i(gkArel)	
	iAsustim	=	abs((1/i(gkrate))-iAatt-iArel)+0.0001	;DERIVE SUSTAIN TIME FROM ARPEGGIATOR RATE AND THE OTHER ENVELOPE SEGMENT DURATIONS
	kAenv	linsegr	0,iAatt,1,iAdec,i(gkAsus),iAsustim,i(gkAsus),iArel,0	;AMPLITUDE ENVELOPE
	a1	=	a1*kAenv
	SKIP_AMP_ENV:
	
	/*FILTER ENVELOPE*/
	iatt	=	i(gkatt)
	idec	=	i(gkdec)
	isus	=	i(gksus)
	irel	=	i(gkrel)
	isustim	=	abs((1/i(gkrate))-iatt-irel)+0.0001	;DERIVE SUSTAIN TIME FROM ARPEGGIATOR RATE AND THE OTHER ENVELOPE SEGMENT DURATIONS
	kfenv	linsegr	0,iatt,1,idec,0,isustim,0,irel,0	;FILTER ENVELOPE
	kfenv	=	(kfenv*(1-gksus))+gksus
	rireturn

	/*FILTER LFO*/
	kLFO	lfo	gkLFOdep,gkLFOrate,0			;CREATE AN LFO. SINE WAVE SHAPE  
	kEnvAmt	portk	gkEnvAmt,kporttime
	kEnvAmt	limit	kEnvAmt+kLFO,0,1			;ADD LFO TO ENVELOPE AMOUNT VARIABLE AND LIMIT THE RESULT TO LIE WITHIN 0 AND 1
	
	/*FILTER KEYBOARD TRACKING*/
	if gkKybdTrk=0 then					;IF KEYBOARD TRACKING IS OFF...
	 ;NON-KEYBOARD TRACKING FILTER
	 kcfoct	=	((kfenv*8)+6)*(kEnvAmt^0.25)
	else							;OTHERWISE (KEYBOARD TRACKING IS OFF
	 ;KEYBOARD TRACKING FILTER
	 kcfoct	=	octcps(kcps)+((kfenv*7*(kEnvAmt^0.75))-2)	;KEYBOARD TRACKING
	endif
	
	/*FILTER*/
	kcf	limit	cpsoct(kcfoct),20,sr/3			;PROTECT AGAINST OUT OF RANGE FILTER VALUES	 
	kres	portk	gkres,kporttime				;SMOOTH CHANGES MADE TO RESONANCE SETTING
	if gkFiltType==1 then					;CHOOSE FILTER TYPE
	 kdist	portk	gkdist,kporttime			;SMOOTH CHANGES MADE TO DISTORTION SETTING
	 a1	lpf18	a1,kcf,kres*0.98, (kdist^2)*10		;LOWPASS
	 kdmp	scale	kdist^0.2,0.06,1			;CREATE A FUNCTION THAT WILL DAMPEN SIGNAL AMPLITUDE WHEN LOWPASS FILTER DISTORTION IS INCREASED
	 a1	=	a1*kdmp					;
	else
	 ;aflt	butbp	a1,kcf,kcf * (2-((kres^0.5)*1.9))	;BANDPASS
	 kcf	limit	kcf,20,sr*0.4
	 kbw	limit	(kcf*(kres^8))*0.7, 1, sr/4
	 aflt	rbjeq	a1,kcf,1,kbw,1,4;BANDPASS

	 a1	balance	aflt,a1/4,1				;EVEN OUT LEVEL OF FILTER OUTPUT SIGNAL TO COMPENSATE FOR SIGNAL POWER LOSS WHEN BANDWIDTH ('q') IS NARROW
	endif
	
	aenv	linsegr	0,0.001,1,0.005,0			;ANTI-CLICK ENVELOPE
	a1	=	a1*aenv					;APPLY ENVELOPE
	
	/*FREQUENCY SHIFTER*/
	if gkFShift==0 kgoto SKIP_FSHIFT			;IF F.SHIFT VALUE = 0, BYPASS THE EFFECT
	gkFShift	portk	gkFShift,kporttime
	a1	FreqShifter	a1,gkFShift,gisine		;CALL UDO
	SKIP_FSHIFT:
	
	;EFFECT WET/DRY MIX CONSTRUCTION
	iWet	ftgentmp	0,0,512,-7,0,256,1,256,1	;RESCALING FUNCTION FOR WET LEVEL CONTROL
	iDry	ftgentmp	0,0,512,-7,1,256,1,256,0	;RESCALING FUNCTION FOR DRY LEVEL CONTROL
	kWet	table	gkDryWet, iWet, 1			;RESCALE WET LEVEL CONTROL ACCORDING TO FUNCTION TABLE iWet
	kDry	table	gkDryWet, iDry, 1			;RESCALE DRY LEVEL CONTROL ACCORDING TO FUNCTION TABLE iWet	
	gasendL	=	gasendL+a1*kWet
	gasendR	=	gasendR+a1*kWet
	if gkDryWet>0 then
	 a1	=	a1*kDry
	endif
	 	outs	a1,a1
	
endin



instr	Effects
	if gkDryWet==0 kgoto SKIP_DELAY
	kTempoMlt	table	gkTempoMlt-1,giTempoMlt

	ktime	limit	(60*gkDlyTim)/(gktempo*8*kTempoMlt),ksmps/sr,10	;DERIVE TEMPO FROM BPM AND TEMPO MULTIPLIER
	atime	interp	ktime
	kfback	=	0.5
	
	;offset delay (no feedback)
	abuf	delayr	10
	afirst	deltap3	atime
		delayw	gasendL

	;left channel delay (note that 'atime' is doubled) 
	abuf	delayr	20			;
	atapL	deltap3	atime*2
		delayw	afirst+(atapL*gkDlyFB)

	;right channel delay (note that 'atime' is doubled) 
	abuf	delayr	20
	atapR	deltap3	atime*2
		delayw	gasendR+(atapR*gkDlyFB)
		outs	atapL, atapR
	SKIP_DELAY:
		clear	gasendL, gasendR
endin

</CsInstruments>

<CsScore>
i "ScanWidgets" 0 [3600*24*7]		;SCAN GUI WIDGETS
i "ScanMIDI" 0 [3600*24*7]		;SCANS FOR MIDI NOTE EVENTS
i "Effects" 0 [3600*24*7]		;EFFECTS
</CsScore>

</CsoundSynthesizer>