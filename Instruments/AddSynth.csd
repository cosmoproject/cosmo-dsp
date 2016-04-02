	<CsoundSynthesizer>
<CsOptions>
-odac:hw:1,0 -iadc:hw:1 -d -+rtaudio=ALSA -b128 -B1024 --sched=99 -+rtmidi=alsa -M hw:2
</CsOptions>
<CsInstruments>
sr      = 44100
ksmps  	= 64
0dbfs	= 1
nchnls 	= 2


massign 1, 10

; Pots

instr 1 

  #include "includes/adc_channels.inc"
  #include "includes/gpio_channels.inc"


; ---- OSC 1 -----

  kfreq scale gkpot0, 300, 0.1 
  Sfreq sprintfk "OSC1 frequency: %f", kfreq
    puts Sfreq, kfreq+1  
  gkfreq portk kfreq, 0.1

; ---- OSC 2 -----

  kfreq2 scale gkpot1, 400, 0.1
  Sfreq sprintfk "OSC2 frequency: %f", kfreq2
    puts Sfreq, kfreq2+1  
  gkfreq2 portk kfreq2, 0.1

; ---- OSC 3 -----

  kfreq3 scale gkpot2, 500, 5
  Sfreq sprintfk "OSC3 frequency: %f", kfreq3
    puts Sfreq, kfreq3+1 
  gkfreq3 portk kfreq3, 0.1

; ---- OSC 4 -----

  kfreq4 scale gkpot3, 200, 1
  Sfreq sprintfk "OSC4 frequency: %f", kfreq4
    puts Sfreq, kfreq4+1  
  gkfreq4 portk kfreq4, 0.1

endin

instr 10


	;----------------------
	; Synthesizer!
	;----------------------

	kOsc1running init 0
	kOsc2running init 0
	kOsc3running init 0
	kOsc4running init 0
 
  iamp    ampmidi 0.2
  ifreq   cpsmidi

  iatk  = 0.1
  irel  = 0.7
  kenv madsr iatk, 0, 1, irel
  kamp = iamp * kenv

; ---- Fundamental ----

  afund poscil kamp, ifreq

; ---- OSC 1 -----

  a1 poscil kamp, ifreq + gkfreq 

; ---- OSC 2 -----

  a2 poscil kamp, ifreq + gkfreq2 

; ---- OSC 3 -----

  a3 poscil kamp, ifreq + gkfreq3 

; ---- OSC 4 -----

  a4 poscil kamp, ifreq + gkfreq4


; ---- OUTPUT -----

  aOutL = afund + ((a1 + a2 + a3 + a4) * 0.3) 
  aOutR = aOutL

  outs aOutL, aOutR

  /*
  kfreq = k(ifreq)

  a1 poscil kamp, ifreq
  outs a1,a1
*/
endin


</CsInstruments>
<CsScore>
i 1 0 86400
</CsScore>
</CsoundSynthesizer>





