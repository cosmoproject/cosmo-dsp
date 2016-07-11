#define PI #3.1592654#

opcode FadeSwitch, aa, aaaaik
	aInDryL, aInDryR, aInFxL, aInFxR, iFadetime, kFadeInOrOut xin

	if kend == 0 then 
		kFadeInOrOut = 1 
	elseif kend == 1 then 
		kFadeInOrOut = 0 
	endif

	if kFadeInOrOut == 1 then
		kDryWet linseg 0, iFadetime, 1
	elseif kFadeInOrOut == 0 then
		kDryWet linseg 1, iFadetime, 0
	endif

	aOutL ntrpol aInDryL, aInFxL, aDryWet
	aOutR ntrpol aInDryR, aInFxR, aDryWet

	xout aOutL, aOutR
endop