<CsoundSynthesizer>
<CsOptions>
-odac:hw:1,0 -iadc:hw:1 -d -+rtaudio=ALSA -b128 -B1024 
;-odac
</CsOptions>
<CsInstruments>
sr      = 44100
ksmps  	= 32
0dbfs	= 1
nchnls 	= 2

giSine ftgen 0, 0, 4096, 10, 1


instr 1

	#include "../Includes/adc_channels.inc"


; FM

	kfmidx scale gkpot0, 4, 0
	Sidx sprintfk "[Pot1] FM index: %f", kfmidx
		puts Sidx, kfmidx+1  
	kfmidx portk kfmidx, 0.1

	gkpot1 expcurve gkpot1, 30
	kfmfreq scale gkpot1, 500, 0.1
	;kfmfreq logcurve kfmfreq, 2
	Sfm sprintfk "[Pot2] FM freq: %f", kfmfreq
		puts Sfm, kfmfreq+1  
 	kfmfreq portk kfmfreq, 0.1

; LPF18

	gkpot2 expcurve gkpot2, 30
	klpfreq scale gkpot2, 5000, 200
	Slp sprintfk "[Pot3] Lowpass cutoff: %f", klpfreq
		puts Slp, klpfreq+1  
	klpfreq portk klpfreq, 0.1

; OSC

	koscvol1 scale gkpot3, 0.2, 0
	Svol1 sprintfk "[Pot4] OSC1 volume: %f", koscvol1
		puts Svol1, koscvol1+1  

	koscvol2 scale gkpot4, 0.2, 0
	Svol2 sprintfk "[Pot5] OSC2 volume: %f", koscvol2
		puts Svol2, koscvol2+1  

	koscvol3 scale gkpot5, 0.2, 0
	Svol3 sprintfk "[Pot6] OSC3 volume: %f", koscvol3
		puts Svol3, koscvol3+1  

	koscvol4 scale gkpot6, 0.2, 0
	Svol4 sprintfk "[Pot7] OSC4 volume: %f", koscvol4
		puts Svol4, koscvol4+1  

	koscvol5 scale gkpot7, 0.2, 0
	Svol5 sprintfk "[Pot8] OSC5 volume: %f", koscvol5
		puts Svol5, koscvol5+1  


	afm poscil kfmidx*kfmfreq, kfmfreq

	a1 poscil koscvol1, 200 + afm
	a2 poscil koscvol2, 300 + afm
	a3 poscil koscvol3, 400 + afm
	a4 poscil koscvol4, 500 + afm
	a5 poscil koscvol5, 600 + afm

	asynth = a1 + a2 + a3 + a4 + a5

	asynth lpf18 asynth, klpfreq, 0.7, 0

	outs asynth, asynth
	
endin


</CsInstruments>
<CsScore>
i1 0 86400
</CsScore>
</CsoundSynthesizer>







<bsbPanel>
 <label>Widgets</label>
 <objectName/>
 <x>944</x>
 <y>155</y>
 <width>422</width>
 <height>206</height>
 <visible>true</visible>
 <uuid/>
 <bgcolor mode="nobackground">
  <r>255</r>
  <g>255</g>
  <b>255</b>
 </bgcolor>
 <bsbObject type="BSBKnob" version="2">
  <objectName>P0</objectName>
  <x>23</x>
  <y>17</y>
  <width>80</width>
  <height>80</height>
  <uuid>{fa06a4c9-d17f-43cf-9138-22437742aa1e}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <minimum>0.00000000</minimum>
  <maximum>1.00000000</maximum>
  <value>0.34000000</value>
  <mode>lin</mode>
  <mouseControl act="jump">continuous</mouseControl>
  <resolution>0.01000000</resolution>
  <randomizable group="0">false</randomizable>
 </bsbObject>
 <bsbObject type="BSBKnob" version="2">
  <objectName>P1</objectName>
  <x>124</x>
  <y>17</y>
  <width>80</width>
  <height>80</height>
  <uuid>{c8218ac6-f35b-4dfc-80cd-143cf4e0942e}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <minimum>0.00000000</minimum>
  <maximum>1.00000000</maximum>
  <value>1.00000000</value>
  <mode>lin</mode>
  <mouseControl act="jump">continuous</mouseControl>
  <resolution>0.01000000</resolution>
  <randomizable group="0">false</randomizable>
 </bsbObject>
 <bsbObject type="BSBKnob" version="2">
  <objectName>P2</objectName>
  <x>221</x>
  <y>16</y>
  <width>80</width>
  <height>80</height>
  <uuid>{693d12d9-cecb-49aa-8dc3-70be95dca4aa}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <minimum>0.00000000</minimum>
  <maximum>1.00000000</maximum>
  <value>0.25000000</value>
  <mode>lin</mode>
  <mouseControl act="jump">continuous</mouseControl>
  <resolution>0.01000000</resolution>
  <randomizable group="0">false</randomizable>
 </bsbObject>
 <bsbObject type="BSBKnob" version="2">
  <objectName>P3</objectName>
  <x>314</x>
  <y>16</y>
  <width>80</width>
  <height>80</height>
  <uuid>{0eebf160-aef3-4f4c-b737-4156d1a85d4a}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <minimum>0.00000000</minimum>
  <maximum>1.00000000</maximum>
  <value>0.92000000</value>
  <mode>lin</mode>
  <mouseControl act="jump">continuous</mouseControl>
  <resolution>0.01000000</resolution>
  <randomizable group="0">false</randomizable>
 </bsbObject>
 <bsbObject type="BSBKnob" version="2">
  <objectName>P4</objectName>
  <x>24</x>
  <y>106</y>
  <width>80</width>
  <height>80</height>
  <uuid>{7e764715-0547-44ef-8d62-1d41f052384c}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <minimum>0.00000000</minimum>
  <maximum>1.00000000</maximum>
  <value>0.86000000</value>
  <mode>lin</mode>
  <mouseControl act="jump">continuous</mouseControl>
  <resolution>0.01000000</resolution>
  <randomizable group="0">false</randomizable>
 </bsbObject>
 <bsbObject type="BSBKnob" version="2">
  <objectName>P5</objectName>
  <x>125</x>
  <y>106</y>
  <width>80</width>
  <height>80</height>
  <uuid>{d45c3f79-5d44-4eea-9def-3de790acb90c}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <minimum>0.00000000</minimum>
  <maximum>1.00000000</maximum>
  <value>0.89000000</value>
  <mode>lin</mode>
  <mouseControl act="jump">continuous</mouseControl>
  <resolution>0.01000000</resolution>
  <randomizable group="0">false</randomizable>
 </bsbObject>
 <bsbObject type="BSBKnob" version="2">
  <objectName>P6</objectName>
  <x>221</x>
  <y>107</y>
  <width>80</width>
  <height>80</height>
  <uuid>{608b01de-29f8-4892-8558-1d499cc1ad26}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <minimum>0.00000000</minimum>
  <maximum>1.00000000</maximum>
  <value>0.92000000</value>
  <mode>lin</mode>
  <mouseControl act="jump">continuous</mouseControl>
  <resolution>0.01000000</resolution>
  <randomizable group="0">false</randomizable>
 </bsbObject>
 <bsbObject type="BSBKnob" version="2">
  <objectName>P7</objectName>
  <x>314</x>
  <y>107</y>
  <width>80</width>
  <height>80</height>
  <uuid>{eab75137-4f40-4466-8d9e-f15947f311d1}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <minimum>0.00000000</minimum>
  <maximum>1.00000000</maximum>
  <value>0.92000000</value>
  <mode>lin</mode>
  <mouseControl act="jump">continuous</mouseControl>
  <resolution>0.01000000</resolution>
  <randomizable group="0">false</randomizable>
 </bsbObject>
</bsbPanel>
<bsbPresets>
</bsbPresets>
