gkClipSlots[] init 20
gkClipIdx init 0

opcode BufCrt1, i, io
    ilen, inum xin
    ift       ftgen     inum, 0, -(ilen*sr), 2, 0
    xout      ift
endop

opcode BufCrt2, ii, io ;creates a stereo buffer
    ilen, inum xin ;ilen = length of the buffer (table) in seconds
    iftL      ftgen     inum, 0, -(ilen*sr), 2, 0
    iftR      ftgen     inum, 0, -(ilen*sr), 2, 0
    xout      iftL, iftR
endop

opcode BufRec1, k, aikkkk ;records to a buffer
    ain, ift, krec, kstart, kend, kwrap xin
	
    setksmps	1
    kendsmps	=		kend*sr ;end point in samples
    kendsmps	=		(kendsmps == 0 || kendsmps > ftlen(ift) ? ftlen(ift) : kendsmps)
    kfinished	=		0

    knew  changed	krec ;1 if record just started
    if krec == 1 then

        if knew == 1 then
            kndx = gkClipSlots[gkClipIdx] 
            ;kndx = kstart * sr - 1 ;first index to write
            ; = kndx
            printks   "recording: %d\n", 0, gkClipIdx
        endif
        
        printks  ".", 0.25       ; print '.' every quarter of a second


    /*
        if kndx >= kendsmps-1 && kwrap == 1 then
            kndx = -1
        endif
        */
        if kndx < kendsmps-1 then
            kndx = kndx + 1
            andx = kndx
                tabw ain, andx, ift
        else
            kfinished =	1
        endif
    elseif krec == 0 && knew == 1 then
        gkClipIdx += 1
        gkClipSlots[gkClipIdx] = kndx 
        printks  "\\nMade loop from %d to %d \\n", 0, gkClipSlots[gkClipIdx-1], gkClipSlots[gkClipIdx] 
        printks "\Number of clips: %d\nNumber of idx: %d\n", 0, gkClipIdx/2, gkClipIdx
    endif

 	xout kfinished
endop
/*
opcode BufRec2, k, aaiikkkk ;records to a stereo buffer

    ainL, ainR, iftL, iftR, krec, kstart, kend, kwrap xin
    kfin      BufRec1     ainL, iftL, krec, kstart, kend, kwrap
    kfin      BufRec1     ainR, iftR, krec, kstart, kend, kwrap
    xout      kfin
endop
*/

opcode ClipPlay1, a, ikkkkk
    ift, kplay, kclip, kspeed, kvol, kwrap xin
    ;kstart = begin of playing the buffer in seconds
    ;kend = end of playing in seconds. 0 means the end of the table
    ;kwrap = 0: no wrapping. stops at kend (positive speed) or kstart
    ;  (negative speed).this makes just sense if the direction does not
    ;  change and you just want to play the table once
    ;kwrap = 1: wraps between kstart and kend
    ;kwrap = 2: wraps between 0 and kend
    ;kwrap = 3: wraps between kstart and end of table
    ;CALCULATE BASIC VALUES
    kfin		init		0
    kfade init 0

    ; todo: add check that kclipIdx is not bigger than gkClipIdx
    ;kclipIdx   =   kclip 

    kftlen      =   (gkClipSlots[kclip+1] - gkClipSlots[kclip])/sr
    kstart      =   gkClipSlots[kclip]
    kend		=   gkClipSlots[kclip+1]
    kstart01	=   kstart/kftlen ;start in 0-1 range
    kend01		=	kend/kftlen ;end in 0-1 range
    kfqbas		=	(1/kftlen) * kspeed ;basic phasor frequency

    if changed(kplay) == 1 then
        printks  "\n Playing clip idx %d of %d", 0, kclip, gkClipIdx

     ;   printks  "\\nPlaying loop from %d to %d \\n", 0, gkClipSlots[kclipIdx], gkClipSlots[kclipIdx+1] 
        printks  "\\nPlaying loop from %f to %f \\n", 0, kstart, kend
     ;   printks  "\\nPlaying loop from %f to %f \\n", 0, kstart01, kend01

    endif

    if kplay == 1 && (changed(kplay) == 1 || changed(kclip) == 1) then
        reinit NEW_CLIP
    endif 

    if kplay == 1 then
        kfade = 1
        kfade port kfade, 0.01

        kLoopLevel = 1
        kCrossFadeDur = 0.1
        kLoopMode = 0
        kLoopLength = kend - kstart
        
        NEW_CLIP:
            iOffset = i(kstart)
            prints "\nPlaying from idx %d\n", iOffset

        andx phasor kfqbas
        aout table3 andx*kLoopLength, ift, 0, iOffset
       ; aout flooper2 kLoopLevel, kspeed, kstart, kend-kstart, kCrossFadeDur, ift, 0, i(kLoopMode)
    else
        kfade = 0
        kfade port kfade, 0.01
        aout = 0
    endif

    xout aout*kfade
    /*
    if kplay == 1 && kfin == 0 then
        ;1. STOP AT START- OR ENDPOINT IF NO WRAPPING REQUIRED (kwrap=0)
        if kwrap == 0 then
            ; -- phasor freq so that 0-1 values match distance start-end
            kfqrel		=		kfqbas / (kend01-kstart01)
            andxrel	phasor 	kfqrel ;index 0-1 for distance start-end
            ; -- final index for reading the table (0-1)
            andx		=		andxrel * (kend01-kstart01) + (kstart01)
            kfirst		init		1 ;don't check condition below at the first k-cycle (always true)
            kndx		downsamp	andx
            kprevndx	init		0
            ;end of table check:
            ;for positive speed, check if this index is lower than the previous one
            if kfirst == 0 && kspeed > 0 && kndx < kprevndx then
                kfin		=		1
                ;for negative speed, check if this index is higher than the previous one
            else
                kprevndx	=		(kprevndx == kstart01 ? kend01 : kprevndx)
                if kfirst == 0 && kspeed < 0 && kndx > kprevndx then
                    kfin		=		1
                endif
                kfirst		=		0 ;end of first cycle in wrap = 0
            endif
            ;sound out if end of table has not yet reached
            asig		table3		andx, ift, 1	
            kprevndx	=		kndx ;next previous is this index
        ;2. WRAP BETWEEN START AND END (kwrap=1)
        elseif kwrap == 1 then
            kfqrel		=		kfqbas / (kend01-kstart01) ;same as for kwarp=0
            andxrel	phasor 	kfqrel
            andx		=		andxrel * (kend01-kstart01) + (kstart01)
            asig		table3		andx, ift, 1	;sound out
            ;3. START AT kstart BUT WRAP BETWEEN 0 AND END (kwrap=2)
        elseif kwrap == 2 then
            kw2first	init		1
            if kw2first == 1 then ;at first k-cycle:
                reinit		wrap3phs ;reinitialize for getting the correct start phase
                kw2first	=		0
            endif
            kfqrel		=		kfqbas / kend01 ;phasor freq so that 0-1 values match distance start-end
            wrap3phs:
            andxrel	phasor 	kfqrel, i(kstart01) ;index 0-1 for distance start-end
                    rireturn	;end of reinitialization
            andx		=		andxrel * kend01 ;final index for reading the table
            asig		table3		andx, ift, 1	;sound out
        ;4. WRAP BETWEEN kstart AND END OF TABLE(kwrap=3)
        elseif kwrap == 3 then
            kfqrel		=		kfqbas / (1-kstart01) ;phasor freq so that 0-1 values match distance start-end
            andxrel	phasor 	kfqrel ;index 0-1 for distance start-end
            andx		=		andxrel * (1-kstart01) + kstart01 ;final index for reading the table
            asig		table3		andx, ift, 1	
        endif
    else ;if either not started or finished at wrap=0
        asig		=		0 ;don't produce any sound
    endif
  	xout		asig*kvol, kfin
    */
endop

