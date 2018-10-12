<CsoundSynthesizer>
<CsOptions>
;-odac:hw:2,0 -iadc:hw:2 -d -+rtaudio=ALSA -b128 -B512 -j1 -+rtmidi=alsa -Ma
-odac -iadc -b128 -B 1024 -Ma -+rtmidi=coremidi -Ma ;Mac OSX 10.12.2
;-odac:hw:0,0 -iadc:hw:0 -d -+rtaudio=ALSA -b128 -B512 -j1 -+rtmidi=alsa -Ma ;ubuntu
;-n -d -+rtmidi=NULL -M0 -m0d
</CsOptions>
<CsInstruments>

	sr      = 44100
	ksmps  	= 32
	0dbfs	= 1
	nchnls 	= 2


	;#include "../DSP-Library/Includes/cosmo_utilities.inc"

    #include "../DSP-Library/Effects/Blur.udo"
    #include "../DSP-Library/Effects/Chorus.udo"
    #include "../DSP-Library/Effects/FakeGrainer.udo"
    #include "../DSP-Library/Effects/Hack.udo"
    #include "../DSP-Library/Effects/Highpass.udo"
    #include "../DSP-Library/Effects/Lowpass.udo"
    #include "../DSP-Library/Effects/RandDelay.udo"
    #include "../DSP-Library/Effects/Reverb.udo"
    #include "../DSP-Library/Effects/Reverse.udo"
    #include "../DSP-Library/Effects/SineDelay.udo"
    #include "../DSP-Library/Effects/TapeDelay.udo"
    #include "../DSP-Library/Effects/Tremolo.udo"
    #include "../DSP-Library/Effects/TriggerDelay.udo"
    #include "../DSP-Library/Effects/Volume.udo"
    #include "../DSP-Library/Effects/Wobble.udo"

	instr 1

		aL, aR ins

        alfo lfo 0.5, 1, 1
        ;klfo tonek klfo, 2
        aL oscili alfo, 220
        aR oscili alfo, 260

		adlyL = 0
		adlyR = 0

		; MIDI in for testing...
		gkCC21_CH1 ctrl7 1, 21, 0, 1
        gkCC21_CH1 port gkCC21_CH1, .1

		gkCC22_CH1 ctrl7 1, 22, 0, 1
        gkCC22_CH1 port gkCC22_CH1, .1

		gkCC23_CH1 ctrl7 1, 23, 0, 1
        gkCC23_CH1 port gkCC23_CH1, .1

		gkCC24_CH1 ctrl7 1, 24, 0, 1
        gkCC24_CH1 port gkCC24_CH1, .1

		;--------------------------

        ; aL, aR Blur aL, aR, 0.3, 0.5, 0.3, 0.2
		; aL, aR Chorus aL, aR, gkCC21_CH1, gkCC22_CH1
        ; aL, aR FakeGrainer aL, aR, 0.5
        ; aL, aR Hack aL, aR, 0.3, 0.5
        ; aL, aR Highpass aL, aR, 0.8, 0.3, 0, 1 ;make mode optional?
        ; aL, aR Lowpass aL, aR, 0.8, 0.3, 0, 1
        ; aL, aR RandDelay aL, aR, 0.5, 0.1, 0.2, 0.5
        aL, aR Reverb aL, aR, gkCC21_CH1, gkCC22_CH1, gkCC23_CH1, 1
        ; aL, aR Reverse aL, aR, 0.1, 0, 0.5
        ; aL, aR SineDelay aL, aR, 0.8, 0.3, 0.1, 0.3, 0.5
        ; aL, aR TapeDelay aL, aR, 0.2, 0.4, 0.5, 0.4, 0
        ; aL, aR Tremolo aL, aR, 0.8, 1
        ; aL, aR TriggerDelay aL, aR, 1, 0.1, 0.2, 0.5, 0.9, 1, 1, 0.1, 0.5, 0.1, 0.5
        ; aL, aR Volume aL, aR, 1
        ; aL, aR Wobble aL, aR, 0.2, 0.5


		aOutL = (aL + adlyL)
		aOutR = (aR + adlyR)

		outs aOutL, aOutR

	endin

</CsInstruments>
<CsScore>
i1 0 86400
</CsScore>
</CsoundSynthesizer>
