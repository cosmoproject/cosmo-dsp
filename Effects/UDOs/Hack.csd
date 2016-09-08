/*
#define PI #3.1592654#

opcode MyDryWetSwitch, aa, aaaaik
aInDryL, aInDryR, aInFxL, aInFxR, iFadetime, kend xin
;iFadetime = 1
;kend      release   ;get a "1" if instrument is turned off

if kend == 0 then 
	kFadeInOrOut = 1 
	elseif kend == 1 then 
	kFadeInOrOut = 0 
	endif
;printk 0.3, kend
if kFadeInOrOut == 1 then
	  	aDryWet linseg 0, iFadetime, 1
	  elseif kFadeInOrOut == 0 then
	    	aDryWet linseg 1, iFadetime, 0
	  endif
;printk 0.5, kFadeInOrOut
aPiPos = $PI*0.5*aDryWet;
aOutL = (aInDryL*cos(aPiPos)) + (aInFxL * sin(aPiPos))
aOutR = (aInDryR*cos(aPiPos)) + (aInFxR * sin(aPiPos))
xout aOutL, aOutR
xtratim 1
endop

*/
opcode Hack, aa, aakk

	ainL, ainR, kDryWet, kFreq  xin
	

	kFreq expcurve kFreq, 30
	kFreq scale kFreq, 45, 0.5
	Srev sprintfk "Hack freq: %fHz", kFreq
		puts Srev, kFreq 
	kFreq port kFreq, 0.1

	kDryWet scale kDryWet, 1, 0
	Srev sprintfk "Hack Mix: %f", kDryWet
		puts Srev, kDryWet+1 

	aMod lfo 1, kFreq, 3
	aMod butlp aMod, 300

	aHackL = ainL * (aMod)
	aHackR = ainR * (aMod)
	
	aOutL ntrpol ainL, aHackL, kDryWet
	aOutR ntrpol ainR, aHackR, kDryWet

	xout aOutL, aOutR
	
endop

opcode Hack, aa, aak

	ainL, ainR, kDryWet  xin
	
	aOutL, aOutR Hack ainL, ainR, kDryWet, 0.5

	xout aOutL, aOutR
	
endop

opcode Hack, aa, aa

	ainL, ainR  xin
	
	aOutL, aOutR Hack ainL, ainR, 1, 0.5

	xout aOutL, aOutR
	
endop

