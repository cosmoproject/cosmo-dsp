/********************************************************

	Blur.udo
	Author: Bernt Isak Wærstad

	Arguments: Blur time, Gain, Dry/wet mix[, StereoMode]
    Defaults:  0.2, 0, 0.8, 1

	Blur time: 0.1s - 3s
	Gain: 1 - 5
	Dry/wet mix: 0% - 100%

	[2i/2o only] 
	Stereo Mode: 0 - 1 (off below 0.5, on above)


	Description:
	A spectral blur effect - very CPU intensive! 

********************************************************/

	; Default argument values
	#define Blur_Time #0.2# 
	#define Gain #0#
	#define DryWet_Mix #0.8#
	#define StereoMode #1#

	; Toggle printing on/off
	#define PRINT #0#

	; Max and minimum values
	#define FFT_SIZE #4096#
	#define MAX_TIME #3#
	#define MIN_TIME #0.1#
	#define MAX_GAIN #5#
	#define MIN_GAIN #1#

;*********************************************************************
; Spectral Blur - 1 in / 1 out
;*********************************************************************

opcode Blur, a, akkk

	ain, kBlurTime, kGain, kDryWet xin

	kBlurTime expcurve kBlurTime, 10
	kBlurTime scale kBlurTime, $MAX_TIME, $MIN_TIME
	kGain scale kGain, $MAX_GAIN, $MIN_GAIN	
	kDryWet scale kDryWet, 1, 0

	if $PRINT == 1 then 
		Stime sprintfk "Blur Time: %fs", kBlurTime
			puts Stime, kBlurTime

		Sgain sprintfk "Blur Gain: %f", kGain
			puts Sgain, kGain+1

		Smix sprintfk "Blur Mix: %f", kDryWet
			puts Smix, kDryWet+1
	endif

	ifftsize	=		$FFT_SIZE
	ioverlap	=		ifftsize / 4
	iwinsize	=		ifftsize
	iwinshape	=		1; von-Hann window

	fftin		pvsanal	ain, ifftsize, ioverlap, iwinsize, iwinshape; fft-analysis of the audio-signal
	fftblur		pvsblur	fftin, kBlurTime, 3; blur
	aBlur		pvsynth	fftblur; resynthesis

	aOut ntrpol ain, aBlur * kGain, kDryWet

	xout aOut

endop

;*********************************************************************
; Spectral Blur - 1 in / 2 out
;*********************************************************************

opcode Blur, aa, akkk

	ain, kBlurTime, kGain, kDryWet xin

	aOutL Blur ain, kBlurTime, kGain, kDryWet
	aOutR Blur ain, kBlurTime, kGain, kDryWet

	xout aOutL, aOutR

endop

;*********************************************************************
; Spectral Blur - 2 in / 2 out
;*********************************************************************

opcode Blur, aa, aakkkk

	ainL, ainR, kBlurTime, kGain, kDryWet, kStereoMode xin

	kStereoMode = kStereoMode > 0.5 ? 1 : 0
	if $PRINT == 1 then 
		Sstereo sprintfk "Blur Stereo on/off: %d", kStereoMode
			puts Sstereo, kStereoMode + 1
	endif

	if kStereoMode == 1 then 
		aOutL Blur ainL, kBlurTime, kGain, kDryWet
		aOutR Blur ainR, kBlurTime, kGain, kDryWet
	else
		ainMono = (ainL + ainR) * 0.5
		aOutL Blur ainMono, kBlurTime, kGain, kDryWet
		aOutR Blur ainMono, kBlurTime, kGain, kDryWet
	endif

	xout aOutL, aOutR

endop
