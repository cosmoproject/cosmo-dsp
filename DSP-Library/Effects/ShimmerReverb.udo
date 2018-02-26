/*
m_reverb - a reverberator built on reverbsc with freeze and shimmer

Author: Jeanette C. with many thanks to the Csound community for their great
support!
COSMO UDO adaptation: Bernt Isak Wærstad

DESCRIPTION
m_reverb is a reverberator built on Csound's reverbsc opcode with optional
shimmer and reverb freeze.

SYNTAX
aout_l, aout_r m_reverb ain_l, ain_r, klevel, kfeedback, kdamp, kshimmer, \
		kfreeze_trigger, kfreeze_off, iwindow

INITIALIZATION
iwindow - Number of the window function for the pitchshifter, a triangle is
	suggested

PERFORMANCE
aout_l, aout_r - Stereo output of the reverb unit
ain_l, ain_r - Stereo input into the reverb unit
klevel - Output level of the reverb effect (0 = bypass/off)
kfeedback - Feedback or reverb time, between 0 <= feedback < 1
kdamp - Low frequency damping in Hertz
kshimmer - Level of the shimmer effect, between 0 and 1
kfreeze_trigger - Start/stop input into the freeze. Start and stop have a
	fade time.
	1: record into freeze
	!=1: don't record into freeze
kfreeze_off - If set to one, will stop the frozen audio with a fade

CREDITS
*/

opcode m_reverb, aa, aakkkkkki
	ainl, ainr, klevel, kfbk, kdamp, kshimmer, kfreeze_trigger, kfreeze_off, iwin xin

	; Limit some parameters to secure ranges and setup some basics
	kfreeze_time init 0
	kfbk limit kfbk, 0, .9
	kshimmer limit kshimmer, 0, (.9 - kfbk * .5555)
	denorm ainl, ainr

	apitchl init 0
	apitchr init 0
	arevl, arevr reverbsc (ainl*klevel+apitchl*kshimmer*.2), (ainr*klevel+apitchr*kshimmer*.2), kfbk, kdamp
	apitchl PitchShifter arevl, 2, (kshimmer*.5), .1, iwin
	apitchr PitchShifter arevr, 2, (kshimmer*.5), .1, iwin

	; Freezing
	; Fade in and out, when conditions are right
	if (kfreeze_trigger >0) then
		kfreeze_time = 1
	endif
	kfreeze_trigger port kfreeze_trigger, .02

	if (kfreeze_off == 1) then
		kfreeze_time = kfbk
		kfreeze_time port kfreeze_time, .5
	endif

	; Set the input signal
	afinl = arevl * kfreeze_trigger
	afinr = arevr * kfreeze_trigger
	afreezel, afreezer reverbsc afinl, afinr, kfreeze_time, kdamp

	aoutl = (arevl+afreezel*.5) + apitchl *.5
	aoutr = (arevr+afreezer*.5) + apitchr *.5
	xout aoutl, aoutr
endop
