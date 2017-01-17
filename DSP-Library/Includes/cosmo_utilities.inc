opcode FadeSwitch, aa, aaaaik
	aInDryL, aInDryR, aInFxL, aInFxR, iFadetime, kFadeInOrOut xin

	if kFadeInOrOut == 1 then
		kDryWet linseg 0, iFadetime, 1
	elseif kFadeInOrOut == 0 then
		kDryWet linseg 1, iFadetime, 0
	endif

	aOutL ntrpol aInDryL, aInFxL, kDryWet
	aOutR ntrpol aInDryR, aInFxR, kDryWet

	xout aOutL, aOutR
endop

