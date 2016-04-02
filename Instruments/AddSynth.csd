	<CsoundSynthesizer>
<CsOptions>
-odac:hw:1,0 -iadc:hw:1 -d -+rtaudio=ALSA -b128 -B1024 --sched=99 -M0
;-odac
</CsOptions>
<CsInstruments>
sr      = 44100
ksmps  	= 64
0dbfs	= 1
nchnls 	= 2


instr 1

	#include "includes/adc_channels.inc"
	#include "includes/gpio_channels.inc"

	;----------------------
	; Synthesizer!
	;----------------------

	kOsc1running init 0
	kOsc2running init 0
	kOsc3running init 0
	kOsc4running init 0
 
  iamp    ampmidi 0.5
  ifreq   cpsmidi


; ---- OSC 1 -----

  kfreq scale gkpot0, 3000, 50
  Sfreq sprintfk "OSC1 frequency: %f", kfreq
    puts Sfreq, kfreq+1  
  kfreq portk kfreq, 0.1

  a1 poscil iamp, ifreq + kfreq 

; ---- OSC 2 -----

  kfreq scale gkpot1, 3000, 50
  Sfreq sprintfk "OSC2 frequency: %f", kfreq
    puts Sfreq, kfreq+1  
  kfreq portk kfreq, 0.1

  a2 poscil iamp, ifreq + kfreq 

; ---- OSC 3 -----

  kfreq scale gkpot2, 3000, 50
  Sfreq sprintfk "OSC3 frequency: %f", kfreq
    puts Sfreq, kfreq+1  
  kfreq portk kfreq, 0.1

  a3 poscil iamp, ifreq + kfreq 

; ---- OSC 4 -----

  kfreq scale gkpot3, 3000, 50
  Sfreq sprintfk "OSC4 frequency: %f", kfreq
    puts Sfreq, kfreq+1  
  kfreq portk kfreq, 0.1

  a4 poscil iamp, ifreq + kfreq 


; ---- OUTPUT -----

  aOutL = a1 + a2 + a3 + a4
  aOutR = aOutL

  outs aOutL, aOutR
endin


</CsInstruments>
<CsScore>

</CsScore>
</CsoundSynthesizer>





