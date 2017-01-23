/********************************************************

	Blur.csd
	Author: Bernt Isak Wærstad

	Arguments: Blur time, Gain, StereoMode, Dry/wet mix
    Defaults:  0.2, 0,  0.8

	Blur time: 0.1s - 3s
	Gain: 1 - 5
	Stereo Mode: 0 - 1 (off below 0.5, on above)
	Dry/wet mix: 0% - 100%

	Description:
	A spectral blur effect - very CPU intensive! 

********************************************************/

opcode Blur, aa, aakkkk

	ainL, ainR, kBlurTime, kGain, kStereoMode, kDryWet xin

	kBlurTime expcurve kBlurTime, 10
	kBlurTime scale kBlurTime, 3, 0.1
	Scut sprintfk "Blur Time: %fs", kBlurTime
		puts Scut, kBlurTime

	kGain scale kGain, 5, 1
	Sgain sprintfk "Blur Gain: %f", kGain
		puts Sgain, kGain+1

	kDryWet scale kDryWet, 1, 0
	Srev sprintfk "Blur Mix: %f", kDryWet
		puts Srev, kDryWet+1

	kStereoMode = kStereoMode > 0.5 ? 1 : 0
	Sstereo sprintfk "Blur Stereo on/off: %d", kStereoMode
		puts Sstereo, kStereoMode + 1

	ifftsize	=		4096
	ioverlap	=		ifftsize / 4
	iwinsize	=		ifftsize
	iwinshape	=		1; von-Hann window

	if kStereoMode == 1 then
		fftinL		pvsanal	ainL, ifftsize, ioverlap, iwinsize, iwinshape; fft-analysis of the audio-signal
		fftinR		pvsanal	ainR, ifftsize, ioverlap, iwinsize, iwinshape; fft-analysis of the audio-signal

		fftblurL	pvsblur	fftinL, kBlurTime, 3; blur
		fftblurR	pvsblur	fftinR, kBlurTime, 3; blur

		aBlurL		pvsynth	fftblurL; resynthesis
		aBlurR		pvsynth	fftblurR; resynthesis
	else 
		ainMono = (ainL + ainR) * 0.5
		fftin		pvsanal	ainMono, ifftsize, ioverlap, iwinsize, iwinshape; fft-analysis of the audio-signal
		fftblur		pvsblur	fftin, kBlurTime, 3; blur
		aBlur		pvsynth	fftblur; resynthesis

		aBlurL = aBlur 
		aBlurR = aBlur
	endif 

	aOutL ntrpol ainL, aBlurL * kGain, kDryWet
	aOutR ntrpol ainR, aBlurR * kGain, kDryWet

	xout aOutL, aOutR

endop

