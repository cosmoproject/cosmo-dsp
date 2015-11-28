<CsoundSynthesizer>
<CsOptions>
-odac:hw:1,0 -iadc:hw:1 -d -+rtaudio=ALSA -b1024 -B2048 -realtime --sched=99
</CsOptions>
<CsInstruments>

sr = 44100
ksmps = 512
nchnls = 2
0dbfs = 1

; empty table, live audio input buffer used for granulation
giTablen  = 131072
giLive    ftgen 0,0,giTablen,2,0

; sigmoid rise/decay shape for fof2, half cycle from bottom to top
giSigRise ftgen 0,0,8192,19,0.5,1,270,1		

; test sound
;giSample  ftgen 0,0,524288,1,"fox.wav", 0,0,0


instr 1
; test sound, replace with live input
  	aL, aR ins
  	a1 = aL + aR
 ; 	  outs aL * 0.5, aR * 0.5
          chnmix a1, "liveAudio"
          chnmix a1, "dryAudio"
endin

instr 2
; write live input to buffer (table)
  a1      chnget "liveAudio"
  gkstart tablewa giLive, a1, 0
  if gkstart < giTablen goto end
  gkstart = 0
  end:
  a0      = 0
          chnset a0, "liveAudio"
endin


instr 3

	#include "includes/adc_channels.inc"



	aOut[]	init 2

	kfeed scale gkpot4, 1, 0
	Sfb sprintfk "Feedback: %f", kfeed
		puts Sfb, kfeed+1  

	kdlytime scale gkpot5, 2.8, 0.1
	Scut sprintfk "Delay time: %fs", kdlytime
		puts Scut, kdlytime

	kgrainRate scale gkpot0, 50, 1
	Scut sprintfk "Grain rate: %fs", kgrainRate
		puts Scut, kgrainRate

	kgrainDur scale gkpot1, 10, 0.5
	Scut sprintfk "Grain dur: %fs", kgrainDur
		puts Scut, kgrainDur


; delay parameters
  kDelTim = kdlytime;0.5			; delay time in seconds (max 2.8 seconds)
  kFeed   = kfeed;0.8
; delay time random dev
  kTmod	  = 0.2
  kTmod   rnd31 kTmod, 1
  kDelTim = kDelTim+kTmod
; delay pitch random dev
  kFmod   linseg 0, 1, 0, 1, 0.1, 2, 0, 1, 0
  kFmod	  rnd31 kFmod, 1
 ; grain delay processing
  kamp	  = ampdbfs(-8)
  kfund   = kgrainRate;25 ; grain rate
  kform   = (1+kFmod)*(sr/giTablen) ; grain pitch transposition
  koct    = 0
  kband   = 0
  kdur    = kgrainDur / kfund; 2.5 / kfund ; duration relative to grain rate
  kris    = 0.5*kdur
  kdec    = 0.5*kdur
  kphs    = (gkstart/giTablen)-(kDelTim/(giTablen/sr)) ; calculate grain phase based on delay time
  kgliss  = 0
  a1     fof2 1, kfund, kform, koct, kband, kris, kdur, kdec, 100, \
      giLive, giSigRise, 86400, kphs, kgliss
 ;         outch     2, a1*kamp

    a1 = a1 * kamp

	;----------------------
	; Lowpass Filter 
	;----------------------

	gkpot6 logcurve gkpot6, 0.05
	klpf scale gkpot6, 12000, 100
	Slpf sprintfk "LPF Cutoff: %d", klpf
		puts Slpf, klpf

	klpf port klpf, 0.1

	aOut[0] lpf18 a1, klpf, 0.72, 0.7
	aOut[1] lpf18 a1, klpf+20, 0.65, 0.7

	;----------------------

          chnset a1*kFeed, "liveAudio"

    aDry chnget "dryAudio"
    a0 = 0
    	chnset a0, "dryAudio"
    aDry = 0

	outs aOut[0]*3 + aDry*0.5, aOut[1]*3 + aDry*0.5


endin



</CsInstruments>
<CsScore>
i1 0 86400
i2 0 86400
i3 0 86400
</CsScore>
</CsoundSynthesizer>







