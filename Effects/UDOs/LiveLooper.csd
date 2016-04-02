; LiveLooper.csd
; Written by Iain McCurdy 2015

; A simple instrument for recording a sample and then playing it back as a loop with a crossfade employed to smooth the join between the beginning and the end of the loop  (flooper2 opcode).
; Maximum loop time is about a minute and a half at sr = 44100

; The crossfade curve shape and its duration can be modified to suit the material being looped 
; The curve shape is based on a fragment of a sine curve 
; If a dip in power is heard at the crossfade point, 'Shape' should be lowered. Conversely, if a hump in power is heard, 'Shape' should be raised.

; The loop can also be played back using the MIDI keyboard (or an external keyboard) in which case the loop will be transposed according to the note played. 
; Unison will be middle C (NN#60). 

; NB. Loop Mode = "Fwd/Bwd" does not seem to crossfade properly when fading from the backwards pass to the forwards pass. Maybe a bug in flooper2?


;massign 0,3

giCF_Curve	ftgen	1,0,8193,-7,0,8192,1	; CROSSFADE CURVE
giCF_Curve2	ftgen	2,0,8193,-7,1,8192,0	; CROSSFADE CURVE
giBufferL	ftgen	3,0,1048576*4,2,0	; AUDIO BUFFER (LEFT CHANNEL)
giBufferR	ftgen	4,0,1048576*4,2,0	; AUDIO BUFFER (RIGHT CHANNEL)
gitri		ftgen	0,0,4096,-7,0,2048,1,2048,0

gkLoopDuration	init	0			; LOOP DURATION (WILL BE UPDATED WHILE RECORDING)
              

opcode  Record, k, aakk
  ainL, ainR, kRecord, kLoopDuration xin
 if kRecord == 1 then       ; IF RECORD BUTTON IS NO LONGER ACTIVE (I.E. STOP OR PLAY HAVE BEEN PRESSED)...
 
  Srev sprintfk "Recording %f", kRecord
    puts Srev, kRecord + 1 


 p3 = (ftlen(giBufferL)-1)/sr   ; p3 (INSTRUMENT DURATION) LIMITED TO THE LENGTH OF THE FUNCTION TABLE
 aPtr line  0,1,sr        ; POINTER FOR WRITING INTO THE FUNCTION TABLE
 kLoopDuration line  0, 1, 1     ; LOOP DURATION   
  tablew  ainL,aPtr,giBufferL    ; WRITE LEFT CHANNEL TO TABLE
  tablew  ainR,aPtr,giBufferR    ; WRITE RIGHT CHANNEL TO TABLE

  xout kLoopDuration

  endif

  printk2 kRecord

  if changed(kRecord) == 1 then
    printk2 kLoopDuration
  endif 

endop


;instr  300 ; Play
opcode Play, aa, kkkk
kPlay, kCFDuration, kLoopMode, kLoopDuration xin

   iMIDIActiveValue = 1   ; IF MIDI ACTIVATED
   iMIDIflag    = 0   ; IF BUTTON ACTIVATED
   mididefault  iMIDIActiveValue, iMIDIflag ; IF NOTE IS MIDI ACTIVATED REPLACE iMIDIflag WITH iMIDIActiveValue 

   if iMIDIflag==0 then       ; IF PLAYBACK HAS BEEN TRIGGERED BY THE GUI BUTTON...
    kpitch  =   1   ; ...PITCH=1 (NO TRANSPOSITION)
   else           ; OTHERWISE (TRIGGERED BY MIDI KEYBOARD)
    kpitch  =   cpsmidi()/cpsmidinn(60)   ; DERIVE RATIO BASED ON NOTE NUMBER 60 AS THE POINT OF UNISON (IE. RATIO=1) 
   endif            ; END OF CONDITIONAL BRANCH
  

if kPlay==1 then ;&&iMIDIflag!=0 then 


  Srev2 sprintfk "Playing %f", kPlay
    puts Srev2, kPlay + 1 


   kloopstart = 0     ; ALWAYS START LOOP FROM THE BEGINNING
   kCFDuration limit kCFDuration,0.01,kLoopDuration/2  ; LIMIT CROSSFADE DURATION TO PREVENT GLITCHES IF CROSSFADE DURATION IS LONG AND RECORDING IS SHORT
   istart   = 0     ; INITIAL START (BEFORE LOOPING)
   iskip    = 0     ; INITIALISATION SKIPPING
   if changed(kLoopMode)==1 then     ; IF LOOP MODE HAS BEEN CHANGED...
    reinit UpdateFlooper        ; ...REINITIALISE FROM LABEL 'UpdateFlooper'
   endif            ; END OF CONDITIONAL BRANCH
   kAntiClick cossegr 0,0.1,1,36000,1,0.1,0 ; cossegr DOESN'T SEEM TO WORK PROPERLY AT THE MOMENT :-(
   UpdateFlooper:         ; LABEL. BEGIN REINITIALISATION PASS FROM HERE

   kLoopLevel = 1

   ; INSTANTIATE flooper2 TWICE. ONCE FOR EACH STEREO CHANNEL
 ;  aL flooper2  kLoopLevel*kAntiClick, kpitch, kloopstart, kLoopDuration, kCFDuration, giBufferL, istart, i(kLoopMode)-1, giCF_Curve, iskip
 ;  aR flooper2  kLoopLevel*kAntiClick, kpitch, kloopstart, kLoopDuration, kCFDuration, giBufferR, istart, i(kLoopMode)-1, giCF_Curve, iskip
 
 ;   aL flooper2 1, 1, 0, kLoopDuration, 0, giBufferL
 ;   aR flooper2 1, 1, 0, kLoopDuration, 0, giBufferR

  andx phasor 1/kLoopDuration
  aL table andx, giBufferL, 0
  aR table andx, giBufferR, 0

  ;aL  poscil  0.2,440
 ;aR = aL

    xout  aL,aR ; SEND AUDIO TO OUTPUT
 
endif

endop



opcode LiveLooper_Stereo, aa, aakkkkkkkk 
  ainL, ainR, kRecord, kPlay, kStop, kDryLevel, kLoopLevel, kLoopMode, kCFDuration, kShape xin

 ;gaL,gaR	ins				; READ AUDIO INPUT
; gaL	poscil	0.2,440
 ;gaR	=	gaL

 kLoopDuration init 0

 kShape	init	0.5				; CURVE INITIAL VALUE (TO AVOID AN INITIAL ZERO)
 kShape scale kShape, 2, 0.25 

; CROSSFADE DURATION
 kCFDuration scale kCFDuration, 4, 0

 kPortTime	linseg	0,0.01,0.05		; RAMPING UP PORTAMENTO TIME
 
 ;gkDryLevel	chnget	"DryLevel"		; DRY (LIVE) LEVEL
 ;gkLoopLevel	chnget	"LoopLevel"		; LOOPER LEVEL
 
 kDryLevel	portk	kDryLevel,kPortTime	; SMOOTH CHANGES TO DRY LEVEL VALUE
 kLoopLevel	portk	kLoopLevel,kPortTime	; SMOOTH CHANGES TO LOOPER LEVEL
 
 kLoopMode	init	1			; INITIAL VALUE OF LOOP MODE (TO AVOID AN INITIAL ZERO)
 
 ktrig	changed	kShape				; GENERATE A TRIGGER (TO REBUILD CROSSFADE FUNCTION) IF SHAPE CONTROL IS MOVED
 if ktrig==1 then				; IF A TRIGGER HAS BEEN GENERATED
  reinit RebuildCurve				; BEGIN A REINITIALISATION PASS FROM THE LABEL 'RebuildCurve'
 endif						; END OF CONDITIONAL BRANCH
 RebuildCurve:					; LABEL. START REINITIALISATION FROM HERE
 icount	=	0				; COUNTER FIRST VALUE
 iftlen	=	ftlen(giCF_Curve)		; FUNCTION TABLE LENGTH
 loop:								; LOOP BEGINNING                                            
 ix	=	icount/(iftlen)                                  
 iy	=	((sin((ix+1.5)*$M_PI)*0.5)+0.5)^i(kShape)	; APPLY FORMULA TO DERIVE Y        
 	tableiw iy,icount,giCF_Curve				; WRITE Y VALUE TO TABLE                         
 iy	=	((sin((ix+0.5)*$M_PI)*0.5)+0.5)^i(kShape)	; APPLY FORMULA TO DERIVE Y        
 	tableiw iy,icount,giCF_Curve2				; **THE SECOND TABLE IS ESSENTIALLY FOR DISPLAY PURPOSES ONLY**
 loop_lt,icount,1,iftlen,loop					; 
 rireturn							; RETURN FROM REINITIALISATION PASS
 
 ;if trigger(kRecord,0.5,0)==1 then		; IF RECORD BUTTON IS PRESSED...
  ;event	"i",200,0,0.1				; ...START RECORD INSTRUMENT
  kLoopDuration Record ainL, ainR, kRecord, kLoopDuration
 ;endif						; END OF CONDITIONAL BRANCH



 if trigger(kPlay,0.5,0)==1 then		; IF PLAY BUTTON IS PRESSED...
  aLoopL, aLoopR Play kPlay, kCFDuration, kLoopMode, kLoopDuration
  ;event	"i",300,0,-1				; ...START PLAY INSTRUMENT WITH A HELD NOTE
 endif						; END OF CONDITIONAL BRANCH
 	xout	(ainL*kDryLevel) + (aLoopL*kLoopLevel), (ainR*kDryLevel) + (aLoopR*kLoopLevel)	; DRY (LIVE) OUTPUT
endop


