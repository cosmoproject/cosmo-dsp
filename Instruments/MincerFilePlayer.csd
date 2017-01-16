; MincerFilePlayer.csd
; Written by Iain McCurdy, 2014

; Three modes of playback are offered:
; 1. Manual Pointer
;     Pointer position is determined by the long horizontal slider 'Manual Pointer'.
; 2. Mouse Scrubber
;     Pointer position is determined by the mouse's X position over the waveform view. Playback is also started and stopped using right-click.
; 3. Loop Region
;     A region that has been highlighted using left-click and drag is looped using a method and speed chosen in the 'LOOP REGION' GUI area.
;     Speed can be random-modulated by increasing Mod.Range. The nature of the modulation is changed using 'Rate 1' and 'Rate 2'. The random function generator is jspline.

; Transpose can be expressed either in semitones or a simple ratio. Select mode 'Semitones' or 'Ratio'

; MOD. POINTER section contains controls which modulate the pointer position using a 'sample-and-hold' type random function
; 
 
; All three of the above methods are playable from a MIDI keyboard (first activate the 'MIDI' checkbox).
;  Transposition for MIDI activated notes is governed bu both the MIDI key played and the setting for 'Transpose'
<CsoundSynthesizer>

<CsOptions>
-odac:hw:1,0 -d -+rtaudio=ALSA -b512 -B2048 --sched=99 -+rtmidi=alsa -M hw:2 -d
</CsOptions>

<CsInstruments>

sr = 44100
ksmps = 256
nchnls = 2
0dbfs=1

massign	0,3

gichans		init	0		; 
giReady		init	0		; flag to indicate function table readiness

giFFTSizes[]	array	32768, 16384, 8192, 4096, 2048, 1024, 512, 256, 128, 64, 32, 16, 8, 4	; an array is used to store FFT window sizes
giTriangle		ftgen	0,0,4097,7,0,2048,1,2048,0
giRectSine		ftgen	0,0,4097,19,1,0.5,0,1
gSfilepath	init	""
gkFileLen	init	0


instr	1
  #include "Includes/adc_channels.inc"
  #include "Includes/gpio_channels.inc"

 /* PORTAMENTO TIME FUNCTION */
 kporttimeW	chnget	"portamento"
 krampup	linseg	0,0.001,1
 kporttime	=	krampup * kporttimeW	

 /* SHOW HIDE INTERVAL MODE (SEMITONES OR RATIO) WIDGETS */
 kIntervalMode	chnget	"IntervalMode"
 if changed(kIntervalMode)==1 then				; semitones mode
  if kIntervalMode==1 then
  	chnset	"visible(0)","RatioPlant_ident"
  	chnset	"visible(1)","SemitonesPlant_ident"
  else								; ratio mode
  	chnset	"visible(1)","RatioPlant_ident"
  	chnset	"visible(0)","SemitonesPlant_ident"
  endif
 endif
 /* DEFINE TRANSPOSITION RATIO BASED ON INTERVAL MODE CHOICE */
 if kIntervalMode==1 then					; semitones mode
 	kSemitones	chnget	"Semitones"
  kSemitones = 1
 	;kSnap		chnget	"Snap"
 	;if kSnap==1 then
 	; if frac(kSemitones)!=0 then
 	;  kSemitones	=	round(kSemitones)
 	;  		chnset	kSemitones,"Semitones"
 	; endif
 	;endif
  	kSemitones	portk	kSemitones,kporttime
  	gktranspose	=	semitone(kSemitones)	
 else								; ratio mode
 	kNumerator	chnget	"Numerator"
  kNumerator = 3
 	kDenominator	chnget	"Denominator"
  kDenominator = 2
 	gkRatio		=	kNumerator/kDenominator
 	gktranspose	portk	gkRatio,kporttime	
 endif

 gkr1		chnget	"r1"	; pointer/note mode select (radio buttons):	manual
 gkr2		chnget	"r2"	; 						mouse
 gkr3		chnget	"r3"	; 						loop
 gkmode		=	(gkr1) + (gkr2*2) + (gkr3*3)
 gkmode = 0
 gkloop		chnget	"loop"
 gkloop = 1
 gkMIDI		chnget	"MIDI"
 gkMIDI = 1
 gklock		chnget	"lock"
 gklock = 1
 gkfreeze	chnget	"freeze"
 gkfreeze	=	1-gkfreeze
 gklevel	chnget	"level"
 gklevel = 1
 gkFFTSize	chnget	"FFTSize"
 gkFFTSize = 4
 gSfilepath	chnget	"filename"
 kNewFileTrg	changed	gSfilepath		; if a new file is loaded generate a trigger
 gkLoopStart	chnget	"beg"			; Click-and-drag region beginning in sample frames
 gkLoopStart = 0
 gkLoopLen	chnget	"len"			; Click-and-drag region length in sample frames
 gkLoopLen = gkpot2
 gkLoopLen	limit	gkLoopLen,1,gkFileLen	
 ;gkLoopLen = gkFileLen
 gkLoopMode	chnget	"LoopMode"
 gkLoopMode = 0
 gkSpeed	chnget	"Speed"
 gkSpeed scale gkpot1, 4, 0.1

 gkModRange	chnget	"ModRange"
 gkModRange = 0
 if gkModRange>0 then
  gkRate1	chnget	"Rate1"
  gkRate2	chnget	"Rate2"
  kMod		jspline	gkModRange,gkRate1,gkRate2
  kSpeed2	=	gkSpeed + kMod
  gkSpeed	=	kSpeed2
 endif
 gkPtrModRange	chnget	"PtrModRange"
 gkPtrModRange = 0
 gkPtrRate1	chnget	"PtrRate1"
 gkPtrRate2	chnget	"PtrRate2"

 gkMOUSE_DOWN_RIGHT	chnget	"MOUSE_DOWN_RIGHT"		; Read in mouse right click status
 kStartScrub		trigger	gkMOUSE_DOWN_RIGHT,0.5,0	; generate a momentary trigger whenver right mouse button is clicked
 
 if gkMOUSE_DOWN_RIGHT==1 && gkmode==2 then
  kMOUSE_X	chnget	"MOUSE_X"
  kMOUSE_Y	chnget	"MOUSE_Y"
  if kStartScrub==1 then 					; prevent initial portamento when a new note is started using right click
   reinit RAMP_FUNC
  endif
  RAMP_FUNC:
  krampup	linseg	0,0.001,1
  rireturn
  kMOUSE_X	portk	(kMOUSE_X - 5) / 1045, kporttime			; Mouse X to pointer position
  kMOUSE_Y	limit	1 - ((kMOUSE_Y - 5) / 150), 0, 1		; Mouse Y transposition
  gapointer	interp	kMOUSE_X
  kSemitones	chnget	"Semitones"
  gktranspose	portk	((kMOUSE_Y*2)-1)*kSemitones,kporttime		; Transposition is scaled using transposition value derived either from 'Semitone' slider or 'Ratio' numberboxes
  gktranspose	=	semitone(gktranspose)
  gklevel	portk	kMOUSE_Y*gklevel + (1-gklevel), kporttime*krampup
  schedkwhen	kStartScrub,0,0,2,0,-1
 else
  kpointer	chnget	"pointer"
  kpointer = gkpot0
  kpointer	portk	kpointer,kporttime
  gapointer	interp	kpointer
 endif
                                
 if kNewFileTrg==1 then				; if a new file has been loaded...
  event	"i",99,0,0				; call instrument to update sample storage function table 
 endif  
 
 if changed(gkmode+gkMIDI)==1 then
  if gkmode==1||gkmode==3&&gkMIDI==0 then
   event	"i",2,0,-1
  endif
 endif
endin

instr	99	; load sound file
 gSfilepath = "SoundFiles/Vocal LR.aif"
 gichans	filenchnls	gSfilepath			; derive the number of channels (mono=1,stereo=2) in the sound file
 gitableL	ftgen	1,0,0,1,gSfilepath,0,0,1
 if gichans==2 then
  gitableR	ftgen	2,0,0,1,gSfilepath,0,0,2
 endif
 giReady 	=	1					; if no string has yet been loaded giReady will be zero
 gkFileLen	init	ftlen(1)
 

endin

instr	2	; non-midi
 if gkmode!=1 && gkmode!=3 && gkMOUSE_DOWN_RIGHT!=1 || gkMIDI==1 then
  turnoff
 endif
 if giReady = 1 then				; i.e. if a file has been loaded
  aenv	linsegr	0,0.01,1,0.01,0			; simple de-click envelope
    
  iFileLen	=	ftlen(gitableL)/sr
  
  if i(gkmode)==3 then
   if gkLoopMode==1 then
    apointer	phasor	(sr*gkSpeed)/gkLoopLen
   elseif gkLoopMode==2 then
    apointer	phasor	-(sr*gkSpeed)/gkLoopLen
   elseif gkLoopMode==3 then
    apointer	poscil	1,(sr*gkSpeed*0.5)/gkLoopLen,giTriangle
   elseif gkLoopMode==4 then
    apointer	poscil	1,(sr*gkSpeed*0.5)/gkLoopLen,giRectSine
   endif
   apointer	=		(apointer * (gkLoopLen/sr)) + (gkLoopStart/sr)
  else
   apointer	=	gapointer*iFileLen
  endif

  /* RANDOM POINTER MODULATION */
  if gkPtrModRange>0 then
   kRndPtrRate	init	random(i(gkPtrRate1),i(gkPtrRate2))
   kRndPtrTrig	metro	kRndPtrRate
   kRndPtrRate	trandom	kRndPtrTrig,gkPtrRate1,gkPtrRate2
   kRndPtrPos	trandom	kRndPtrTrig,-gkPtrModRange*iFileLen,gkPtrModRange*iFileLen
   apointer	+=	interp(kRndPtrPos)
  endif
  
  ktrig	changed		gkFFTSize
  if ktrig==1 then
   reinit RESTART
  endif
  RESTART:
  if gichans=1 then
   a1	mincer		apointer, gklevel, gktranspose, gitableL, gklock, giFFTSizes[i(gkFFTSize)-1]
  	outs	a1*aenv,a1*aenv                                                                                                                                          
  elseif gichans=2 then
   a1	mincer		apointer, gklevel, gktranspose, gitableL, gklock, giFFTSizes[i(gkFFTSize)-1]
   a2	mincer		apointer, gklevel, gktranspose, gitableR, gklock, giFFTSizes[i(gkFFTSize)-1]
  	outs	a1*aenv,a2*aenv
 endif
endif
endin

instr	3	; midi triggered instrument
 if giReady = 1 then						; i.e. if a file has been loaded
  icps	cpsmidi							; read in midi note data as cycles per second
  iamp	ampmidi	0.7					; read in midi velocity (as a value within the range 0 - 1)
  iMidiRef	chnget	"MidiRef"				; MIDI unison reference note
  iMidiRef = 60
  iFrqRatio		=	icps/cpsmidinn(iMidiRef)	; derive playback speed from note played in relation to a reference note (MIDI note 60 / middle C)                                          
 
  iAttTim	chnget	"AttTim"		; read in amplitude envelope attack time widget
  iAttTim = 0.01
  iRelTim	chnget	"RelTim"		; read in amplitude envelope attack time widget     
  iRelTim = 0.05                                                                                                                              
  if iAttTim>0 then				;                                       
   kenv	linsegr	0,iAttTim,1,iRelTim,0
  else								
   kenv	linsegr	1,iRelTim,0			; attack time is zero so ignore this segment of the envelope (a segment of duration zero is not permitted
  endif
  kenv	expcurve	kenv,8			; remap amplitude value with a more natural curve
  aenv	interp		kenv			; interpolate and create a-rate envelope

  iFileLen	=	ftlen(gitableL)/sr

  if i(gkmode)==3 then
   if gkLoopMode==1 then
    apointer	phasor	(sr*gkSpeed)/gkLoopLen
   elseif gkLoopMode==2 then
    apointer	phasor	-(sr*gkSpeed)/gkLoopLen
   elseif gkLoopMode==3 then
    apointer	poscil	1,(sr*gkSpeed*0.5)/gkLoopLen,giTriangle
   elseif gkLoopMode==4 then
    apointer	poscil	1,(sr*gkSpeed*0.5)/gkLoopLen,giRectSine
   endif
   apointer	=		(apointer * (gkLoopLen/sr)) + (gkLoopStart/sr)
  else                                                
   apointer	=	gapointer*iFileLen
  endif

  /* RANDOM POINTER MODULATION */
  if gkPtrModRange>0 then
   kRndPtrRate	init	random(i(gkPtrRate1),i(gkPtrRate2))
   kRndPtrTrig	metro	kRndPtrRate
   kRndPtrRate	trandom	kRndPtrTrig,gkPtrRate1,gkPtrRate2
   kRndPtrPos	trandom	kRndPtrTrig,-gkPtrModRange*iFileLen,gkPtrModRange*iFileLen
   apointer	+=	interp(kRndPtrPos)
  endif
                                                                        
  ktrig	changed		gkFFTSize
  if ktrig==1 then
   reinit RESTART
  endif
  RESTART:
  if gichans=1 then
   a1	mincer		apointer, gklevel*iamp, iFrqRatio*gktranspose, gitableL, gklock, giFFTSizes[i(gkFFTSize)-1]
  	outs	a1*aenv,a1*aenv
  elseif gichans=2 then
   a1	mincer		apointer, gklevel*iamp, iFrqRatio*gktranspose, gitableL, gklock, giFFTSizes[i(gkFFTSize)-1]
   a2	mincer		apointer, gklevel*iamp, iFrqRatio*gktranspose, gitableR, gklock, giFFTSizes[i(gkFFTSize)-1]

  	outs	a1*aenv,a2*aenv
  endif
  
 endif

endin

instr 4
  icps  cpsmidi             ; read in midi note data as cycles per second
  iamp  ampmidi 0.7           ; read in midi velocity (as a value within the range 0 - 1)
  iMidiRef = 60
  iFrqRatio   = icps/cpsmidinn(iMidiRef)  ; derive playback speed from note played in relation to a reference note (MIDI note 60 / middle C)                                          

      atime line   0,5,2.5

    asig mincer atime, iamp, iFrqRatio, gitableL, 0
      outs asig, asig
endin

</CsInstruments>  

<CsScore>
i 99 0 1
i 1 0 10000

</CsScore>

</CsoundSynthesizer>
