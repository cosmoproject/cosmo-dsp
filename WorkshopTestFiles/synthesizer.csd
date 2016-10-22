	<CsoundSynthesizer>
<CsOptions>
-odac:hw:1,0 -iadc:hw:1 -d -+rtaudio=ALSA -b128 -B1024 --sched=99 
;-odac
</CsOptions>
<CsInstruments>
sr      = 44100
ksmps  	= 64
0dbfs	= 1
nchnls 	= 2


instr 1

	#include "../Includes/adc_channels.inc"
	#include "../Includes/gpio_channels.inc"

	;----------------------
	; Synthesizer!
	;----------------------

	kOsc1running init 0
	kOsc2running init 0
	kOsc3running init 0
	kOsc4running init 0

; ------------------------------------------------------

	if (gkswitch0 == 1 && kOsc1running == 0) then
		gkled0 = 1
		Sswitch sprintfk "Osc 1: %f", gkswitch0
			puts Sswitch, gkswitch0+1  

    		event "i", 2, 0, -1
    		kOsc1running = 1

	elseif (gkswitch0 == 0 && kOsc1running == 1) then
		gkled0 = 0
		aAddSynth[0] = 0
		Sswitch sprintfk "Osc 1: %f", gkswitch0
			puts Sswitch, gkswitch0+1  

	    event "i", -2, 0, 1
	    kOsc1running = 0

	endif

; ------------------------------------------------------

	if (gkswitch1 == 1 && kOsc2running == 0) then
		gkled1 = 1
		Sswitch sprintfk "Osc 2: %f", gkswitch1
			puts Sswitch, gkswitch1+1  

    		event "i", 3, 0, -1
    		kOsc2running = 1

	elseif (gkswitch1 == 0 && kOsc2running == 1) then
		gkled1 = 0
		Sswitch sprintfk "Osc 2: %f", gkswitch1
			puts Sswitch, gkswitch1+1  

	    event "i", -3, 0, 1
	    kOsc2running = 0

	endif

; ------------------------------------------------------

	if (gkswitch2 == 1 && kOsc3running == 0) then
		gkled2 = 1
		Sswitch sprintfk "Osc 3: %f", gkswitch2
			puts Sswitch, gkswitch2+1  

    		event "i", 4, 0, -1
    		kOsc3running = 1

	elseif (gkswitch2 == 0 && kOsc3running == 1) then
		gkled2 = 0
		Sswitch sprintfk "Osc 3: %f", gkswitch2
			puts Sswitch, gkswitch2+1  

	    event "i", -4, 0, 1
	    kOsc3running = 0

	endif

; ------------------------------------------------------

	if (gkswitch3 == 1 && kOsc4running == 0) then
		gkled3 = 1
		Sswitch sprintfk "Osc 4: %f", gkswitch3
			puts Sswitch, gkswitch3+1  

    		event "i", 5, 0, -1
    		kOsc4running = 1

	elseif (gkswitch3 == 0 && kOsc4running == 1) then
		gkled3 = 0
		Sswitch sprintfk "Osc 4: %f", gkswitch3
			puts Sswitch, gkswitch3+1  

	    event "i", -5, 0, 1
	    kOsc4running = 0

	endif

; ------------------------------------------------------

endin



instr 2
  kfreq scale gkpot0, 3000, 50
  Sfreq sprintfk "OSC1 frequency: %f", kfreq
    puts Sfreq, kfreq+1  
  kfreq portk kfreq, 0.1

  irelease = 0.3
  iamp = 0.2
  xtratim irelease
  krel init 0
  krel release
  if (krel == 1) kgoto rel
    kamp = iamp
    kgoto done 
  rel:
    kamp linseg iamp, irelease, 0
  done:

  a1 poscil kamp, kfreq 

  outs a1, a1
endin

instr 3
  kfreq scale gkpot1, 3000, 50
  Sfreq sprintfk "OSC2 frequency: %f", kfreq
    puts Sfreq, kfreq+1  
  kfreq portk kfreq, 0.1

  irelease = 0.3
  iamp = 0.2
  xtratim irelease
  krel init 0
  krel release
  if (krel == 1) kgoto rel
    kamp = iamp
    kgoto done 
  rel:
    kamp linseg iamp, irelease, 0
  done:

  a1 poscil kamp, kfreq 

  outs a1, a1
endin

instr 4
  kfreq scale gkpot2, 3000, 50
  Sfreq sprintfk "OSC3 frequency: %f", kfreq
    puts Sfreq, kfreq+1  
  kfreq portk kfreq, 0.1

  irelease = 0.3
  iamp = 0.2
  xtratim irelease
  krel init 0
  krel release
  if (krel == 1) kgoto rel
    kamp = iamp
    kgoto done 
  rel:
    kamp linseg iamp, irelease, 0
  done:

  a1 poscil kamp, kfreq 

  outs a1, a1
endin

instr 5
  kfreq scale gkpot3, 3000, 50
  Sfreq sprintfk "OSC4 frequency: %f", kfreq
    puts Sfreq, kfreq+1  
  kfreq portk kfreq, 0.1

  irelease = 0.3
  iamp = 0.2
  xtratim irelease
  krel init 0
  krel release
  if (krel == 1) kgoto rel
    kamp = iamp
    kgoto done 
  rel:
    kamp linseg iamp, irelease, 0
  done:

  a1 poscil kamp, kfreq 

  outs a1, a1
endin


</CsInstruments>
<CsScore>
i1 0 86400
</CsScore>
</CsoundSynthesizer>





