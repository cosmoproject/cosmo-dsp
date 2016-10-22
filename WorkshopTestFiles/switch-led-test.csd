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

	#include "../Includes/adc_channels.inc"
	#include "../Includes/gpio_channels.inc"

	aAddSynth[] init 8 ;{0, 0, 0, 0, 0, 0, 0, 0}

	;----------------------
	; Button and LED test
	;----------------------

	if (gkswitch0 == 1) then
		gkled0 = 1
		aAddSynth[0] oscil 0.2, 200
		Sswitch0 sprintfk "Switch1: %f", gkswitch0
			puts Sswitch0, gkswitch0+1  
	elseif (gkswitch0 == 0) then
		gkled0 = 0
		aAddSynth[0] = 0
		Sswitch0 sprintfk "Switch1: %f", gkswitch0
			puts Sswitch0, gkswitch0+1  
	endif


	if (gkswitch1 == 1) then
		gkled1 = 1
		aAddSynth[1] oscil 0.2, 300
		Sswitch1 sprintfk "Switch2: %f", gkswitch1
			puts Sswitch1, gkswitch1+1  
	elseif (gkswitch1 == 0) then
		gkled1 = 0
		aAddSynth[1] = 0
		Sswitch1 sprintfk "Switch2: %f", gkswitch1
			puts Sswitch1, gkswitch1+1  
	endif


	if (gkswitch2 == 1) then
		gkled2 = 1
		aAddSynth[2] oscil 0.2, 400
		Sswitch2 sprintfk "Switch3: %f", gkswitch2
			puts Sswitch2, gkswitch2+1  
	elseif (gkswitch2 == 0) then
		gkled2 = 0
		aAddSynth[2] = 0
		Sswitch2 sprintfk "Switch3: %f", gkswitch2
			puts Sswitch2, gkswitch2+1  
	endif


	if (gkswitch3 == 1) then
		gkled3 = 1
		aAddSynth[3] oscil 0.2, 500
		Sswitch3 sprintfk "Switch4: %f", gkswitch3
			puts Sswitch3, gkswitch3+1  
	elseif (gkswitch3 == 0) then
		gkled3 = 0
		aAddSynth[3] = 0
		Sswitch3 sprintfk "Switch4: %f", gkswitch3
			puts Sswitch3, gkswitch3+1  
	endif


	if (gkswitch4 == 1) then
		gkled4 = 1
		aAddSynth[4] oscil 0.2, 600
		Sswitch4 sprintfk "Switch5: %f", gkswitch4
			puts Sswitch4, gkswitch4+1  
	elseif (gkswitch4 == 0) then
		gkled4 = 0
		aAddSynth[4] = 0
		Sswitch4 sprintfk "Switch5: %f", gkswitch4
			puts Sswitch4, gkswitch4+1  
	endif


	if (gkswitch5 == 1) then
		gkled5 = 1
		aAddSynth[5] oscil 0.2, 700
		Sswitch5 sprintfk "Switch6: %f", gkswitch5
			puts Sswitch5, gkswitch5+1  
	elseif (gkswitch5 == 0) then
		gkled5 = 0
		aAddSynth[5] = 0
		Sswitch5 sprintfk "Switch6: %f", gkswitch5
			puts Sswitch5, gkswitch5+1  
	endif


	if (gkswitch6 == 1) then
		gkled6 = 1
		aAddSynth[6] oscil 0.2, 800
		Sswitch6 sprintfk "Switch7: %f", gkswitch6
			puts Sswitch6, gkswitch6+1  
	elseif (gkswitch6 == 0) then
		gkled6 = 0
		aAddSynth[6] = 0
		Sswitch6 sprintfk "Switch7: %f", gkswitch6
			puts Sswitch6, gkswitch6+1  
	endif


	if (gkswitch7 == 1) then
		gkled7 = 1
		aAddSynth[7] oscil 0.2, 900
		Sswitch7 sprintfk "Switch8: %f", gkswitch7
			puts Sswitch7, gkswitch7+1  
	elseif (gkswitch7 == 0) then
		gkled7 = 0
		aAddSynth[7] = 0
		Sswitch7 sprintfk "Switch8: %f", gkswitch7
			puts Sswitch7, gkswitch7+1  
	endif



	aOut = (aAddSynth[0] + aAddSynth[1] + aAddSynth[2] + aAddSynth[3] + aAddSynth[4] + aAddSynth[5] + aAddSynth[6] + aAddSynth[7]) * 0.5

	outs aOut, aOut

endin


</CsInstruments>
<CsScore>
i1 0 86400
</CsScore>
</CsoundSynthesizer>







<bsbPanel>
 <label>Widgets</label>
 <objectName/>
 <x>896</x>
 <y>203</y>
 <width>200</width>
 <height>330</height>
 <visible>true</visible>
 <uuid/>
 <bgcolor mode="nobackground">
  <r>255</r>
  <g>255</g>
  <b>255</b>
 </bgcolor>
 <bsbObject type="BSBButton" version="2">
  <objectName>M0</objectName>
  <x>51</x>
  <y>21</y>
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
  <x>50</x>
  <y>58</y>
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
  <x>50</x>
  <y>94</y>
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
  <x>50</x>
  <y>130</y>
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
 <bsbObject type="BSBButton" version="2">
  <objectName>M4</objectName>
  <x>49</x>
  <y>165</y>
  <width>100</width>
  <height>30</height>
  <uuid>{8bea2661-b1cc-4746-80ec-c1373c525b4d}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <type>value</type>
  <pressedValue>1.00000000</pressedValue>
  <stringvalue/>
  <text>Switch4</text>
  <image>/</image>
  <eventLine>i1 0 10</eventLine>
  <latch>true</latch>
  <latched>false</latched>
 </bsbObject>
 <bsbObject type="BSBButton" version="2">
  <objectName>M5</objectName>
  <x>49</x>
  <y>200</y>
  <width>100</width>
  <height>30</height>
  <uuid>{d4729623-226f-4311-83ad-1d176074f0ca}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <type>value</type>
  <pressedValue>1.00000000</pressedValue>
  <stringvalue/>
  <text>Switch5</text>
  <image>/</image>
  <eventLine/>
  <latch>true</latch>
  <latched>false</latched>
 </bsbObject>
 <bsbObject type="BSBButton" version="2">
  <objectName>M6</objectName>
  <x>48</x>
  <y>236</y>
  <width>100</width>
  <height>30</height>
  <uuid>{c65c5cb8-5b83-483f-b05d-0c0b29ae219b}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <type>value</type>
  <pressedValue>1.00000000</pressedValue>
  <stringvalue/>
  <text>Switch6</text>
  <image>/</image>
  <eventLine>i1 0 10</eventLine>
  <latch>true</latch>
  <latched>false</latched>
 </bsbObject>
 <bsbObject type="BSBButton" version="2">
  <objectName>M7</objectName>
  <x>48</x>
  <y>272</y>
  <width>100</width>
  <height>30</height>
  <uuid>{2dcb34d0-1bb7-4211-adba-52550c2a9b7f}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <type>value</type>
  <pressedValue>1.00000000</pressedValue>
  <stringvalue/>
  <text>Switch7</text>
  <image>/</image>
  <eventLine>i1 0 10</eventLine>
  <latch>true</latch>
  <latched>false</latched>
 </bsbObject>
</bsbPanel>
<bsbPresets>
</bsbPresets>
