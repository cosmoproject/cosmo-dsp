/********************************************************

	Blur.csd
	Author: Bernt Isak Wærstad

	Arguments: Blur time, Dry/wet mix
    Defaults:  0.2, 0.8

	Blur time: 0.1s - 2s
	Dry/wet mix: 0% - 100%

	Description:
	A spectral blur effect - very CPU intensive!

********************************************************/

opcode Blur, aa, aakk

	ainL, ainR, kBlurTime, kDryWet xin

	ain = ainL + ainR

	kBlurTime expcurve kBlurTime, 10
	kBlurTime scale kBlurTime, 2, 0.1
	Scut sprintfk "Blur Time: %ds", kBlurTime
		puts Scut, kBlurTime

	kDryWet scale kDryWet, 1, 0
	Srev sprintfk "Blur Mix: %f", kDryWet
		puts Srev, kDryWet+1

	ifftsize	=		4096
	ioverlap	=		ifftsize / 4
	iwinsize	=		ifftsize
	iwinshape	=		1; von-Hann window

	fftin		pvsanal	ain, ifftsize, ioverlap, iwinsize, iwinshape; fft-analysis of the audio-signal

	fftblur		pvsblur	fftin, kBlurTime, 2; blur

	aBlur		pvsynth	fftblur; resynthesis

	aOutL ntrpol ainL, aBlur, kDryWet
	aOutR ntrpol ainR, aBlur, kDryWet

	xout aOutL, aOutR

endop

opcode Blur, a, akk

	ain, kBlurTime, kDryWet xin

	aOut1, aOut2 Blur ain, ain, kBlurTime, kDryWet

	xout aOut1
endop

/*
True Stereo version - much CPU for little effect

opcode Blur, aa, aakk

	ainL, ainR, kBlurTime, kDryWet xin

	aOutL Blur ainL, kBlurTime, kDryWet
	aOutR Blur ainR, kBlurTime, kDryWet

	xout aOutL, aOutR
endop
*/
