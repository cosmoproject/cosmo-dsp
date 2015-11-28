	<CsoundSynthesizer>
<CsOptions>
;-odac:hw:1,0 -iadc:hw:1 -d -+rtaudio=ALSA -b128 -B1024 --sched=99 
	-odac
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

  a1 poscil 0.2, kfreq 

  outs a1, a1
endin

instr 3
  kfreq scale gkpot1, 3000, 50
  Sfreq sprintfk "OSC2 frequency: %f", kfreq
    puts Sfreq, kfreq+1  
  kfreq portk kfreq, 0.1

  a1 poscil 0.2, kfreq 

  outs a1, a1
endin

instr 4
  kfreq scale gkpot2, 3000, 50
  Sfreq sprintfk "OSC3 frequency: %f", kfreq
    puts Sfreq, kfreq+1  
  kfreq portk kfreq, 0.1

  a1 poscil 0.2, kfreq 

  outs a1, a1
endin

instr 5
  kfreq scale gkpot3, 3000, 50
  Sfreq sprintfk "OSC4 frequency: %f", kfreq
    puts Sfreq, kfreq+1  
  kfreq portk kfreq, 0.1

  a1 poscil 0.2, kfreq 

  outs a1, a1
endin


</CsInstruments>
<CsScore>
i1 0 86400
</CsScore>
</CsoundSynthesizer>







<bsbPanel>
 <label>Widgets</label>
 <objectName/>
 <x>914</x>
 <y>515</y>
 <width>462</width>
 <height>154</height>
 <visible>true</visible>
 <uuid/>
 <bgcolor mode="nobackground">
  <r>255</r>
  <g>255</g>
  <b>255</b>
 </bgcolor>
 <bsbObject type="BSBButton" version="2">
  <objectName>M0</objectName>
  <x>20</x>
  <y>107</y>
  <width>100</width>
  <height>30</height>
  <uuid>{a7bda10e-dcb6-4281-a438-d8fba050b6e1}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <type>value</type>
  <pressedValue>1.00000000</pressedValue>
  <stringvalue/>
  <text>Switch0	</text>
  <image>/</image>
  <eventLine/>
  <latch>true</latch>
  <latched>false</latched>
 </bsbObject>
 <bsbObject type="BSBButton" version="2">
  <objectName>M1</objectName>
  <x>128</x>
  <y>107</y>
  <width>100</width>
  <height>30</height>
  <uuid>{2fbb4f2f-f001-4d35-9111-f1fa185c1223}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <type>value</type>
  <pressedValue>1.00000000</pressedValue>
  <stringvalue/>
  <text>Switch1</text>
  <image>/</image>
  <eventLine/>
  <latch>true</latch>
  <latched>false</latched>
 </bsbObject>
 <bsbObject type="BSBButton" version="2">
  <objectName>M2</objectName>
  <x>233</x>
  <y>107</y>
  <width>100</width>
  <height>30</height>
  <uuid>{7c31a1b1-cb68-4ddb-b656-243ed7f2f8b2}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <type>value</type>
  <pressedValue>1.00000000</pressedValue>
  <stringvalue/>
  <text>Switch2</text>
  <image>/</image>
  <eventLine/>
  <latch>true</latch>
  <latched>false</latched>
 </bsbObject>
 <bsbObject type="BSBButton" version="2">
  <objectName>M3</objectName>
  <x>337</x>
  <y>106</y>
  <width>100</width>
  <height>30</height>
  <uuid>{f05d8717-9d71-42e3-81aa-06de34aefa11}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <type>value</type>
  <pressedValue>1.00000000</pressedValue>
  <stringvalue/>
  <text>Switch3</text>
  <image>/</image>
  <eventLine>i1 0 10</eventLine>
  <latch>true</latch>
  <latched>false</latched>
 </bsbObject>
 <bsbObject type="BSBKnob" version="2">
  <objectName>P0</objectName>
  <x>32</x>
  <y>21</y>
  <width>80</width>
  <height>80</height>
  <uuid>{fe8fc880-037c-4d78-a0d6-e6145291d3ca}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <minimum>0.00000000</minimum>
  <maximum>1.00000000</maximum>
  <value>0.55000000</value>
  <mode>lin</mode>
  <mouseControl act="jump">continuous</mouseControl>
  <resolution>0.01000000</resolution>
  <randomizable group="0">false</randomizable>
 </bsbObject>
 <bsbObject type="BSBKnob" version="2">
  <objectName>P1</objectName>
  <x>136</x>
  <y>20</y>
  <width>80</width>
  <height>80</height>
  <uuid>{d15fa49c-23c4-491b-a9f8-adbd4c7950dd}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <minimum>0.00000000</minimum>
  <maximum>1.00000000</maximum>
  <value>0.14000000</value>
  <mode>lin</mode>
  <mouseControl act="jump">continuous</mouseControl>
  <resolution>0.01000000</resolution>
  <randomizable group="0">false</randomizable>
 </bsbObject>
 <bsbObject type="BSBKnob" version="2">
  <objectName>P2</objectName>
  <x>240</x>
  <y>20</y>
  <width>80</width>
  <height>80</height>
  <uuid>{8b4b0930-0c43-47ab-b25e-2b97297e2706}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <minimum>0.00000000</minimum>
  <maximum>1.00000000</maximum>
  <value>0.65000000</value>
  <mode>lin</mode>
  <mouseControl act="jump">continuous</mouseControl>
  <resolution>0.01000000</resolution>
  <randomizable group="0">false</randomizable>
 </bsbObject>
 <bsbObject type="BSBKnob" version="2">
  <objectName>P3</objectName>
  <x>345</x>
  <y>19</y>
  <width>80</width>
  <height>80</height>
  <uuid>{451da4ce-3756-4586-8466-f30d87796dd3}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <minimum>0.00000000</minimum>
  <maximum>1.00000000</maximum>
  <value>0.59000000</value>
  <mode>lin</mode>
  <mouseControl act="jump">continuous</mouseControl>
  <resolution>0.01000000</resolution>
  <randomizable group="0">false</randomizable>
 </bsbObject>
</bsbPanel>
<bsbPresets>
</bsbPresets>
