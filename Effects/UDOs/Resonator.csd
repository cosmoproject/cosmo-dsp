/********************************************************

	Resonantor.csd
	Author: Iain McCurdy (2012)
	COSMO UDO adaptation: Bernt Isak Wærstad (2015)

	Arguments: Base frequency, Bandwidth, Number of filters, Separation octaves, Separation seminotes, Separation mode[0-2], 

	NB!! THIS UDO DOES NOT HAVE NORMALIZED ARGUMENTS!!! 

	Use either "Resonantor" or "ResonatorFollower" - the latter includes an envelope follower filter on the input signal

	Resony is an implementation of a stack of second-order bandpass filters whose centre frequencies are arithmetically related. 

	Original notes by Iain McCurdy (from Cabbage version)

	*	Separation mode can be:
		
		0: Octaves (Total)
		1: Herz
		2: Octaves (Adjacent)

	* 	The 'bandwidth' and 'scaling mode' parameters are as they are in the reson opcode. 
	
	*	'inum' (number of filters) defines the number of filters in the stack. 
	
	*	'ksep' (separation) normally defines the separation between the lowest and highest filter in the stack in octaves. 
		How this relates to what the actual centre frequencies of filters will be differs depending upon which separation 
		mode has been selected. This is explained below. Note that in this example the operation of 'ksep' has been modified 
		slightly to allow the opcode to be better controlled from the GUI. These modifications are clarified below. Separation 
		can be defined in octaves adjusting 'Sep.oct.' or in semitones adjusting 'Sep.semi.'.

	*	'kbf' (base frequency) defines the centre frequency of the first filter. In 'oct.total' separation mode the pitch 
		interval between the base frequency and (base frequency + separation) is divided into equal intervals according to 
		the number of filters that have been selected. Note that no filter is created at the frequency of 
		(base frequency + separation). For example: if separation=1 and num.filters=2, filters will be created at the base 
		frequency and a tritone above the base frequency (i.e. an interval of 1/2 and an octave). I suspect this is a mistake 
		in the opcode implementation so in this example I rescale the separation interval before passing it to the resony opcode 
		so that the interval between the lowest and highest filter in this mode will always be the interval defined in the GUI.
		A further option I have provided allows the defined interval to be the interval between adjacent filters rather than 
		the interval from lowest to highest. If 'hertz' separation mode is selected behaviour is somewhat curious. I have made 
		some modifications to the values passed to the opcode to make this mode more controllable. Without these modifications, 
		if number of filters is '1' no filters would be created. The frequency relationship between filters in the stack always 
		follows the harmonic series. Both 'Base Frequency' and 'Separation' normally shift this harmonic stack of filters up or
		down, for this reason I have disabled user control of 'Separation' in this example, instead a value equal to the 
		'Number of Filters' will always be used for 'Separation'. This ensures that a harmonic stack will always be created built
		upon 'Base Frequency' as the fundamental. Negative values for 'separation' are allowed whenever 'separation mode' 
		is 'octaves' (if this is the case, the stack of frequencies will extend below the base frequency). Negative values 
		for 'separation' when 'separation mode' is 'hertz' will cause filters to 'explode'. As 'Separation' is fixed at 
		'Number of Filters' in this example this explosion will not occur.


********************************************************/


;A UDO IS CREATED WHICH ENCAPSULATES THE MODIFICATIONS TO THE resony OPCODE DISCUSSED IN THIS EXAMPLE 
opcode	resony2,a,akkikii
	ain, kbf, kbw, inum, ksep , isepmode, iscl	xin

	;IF 'Octaves (Total)' MODE SELECTED...
	if isepmode==0 then
	 irescale	divz	inum,inum-1,1	;PREVENT ERROR IS NUMBER OF FILTERS = ZERO
	 ksep = ksep * irescale			;RESCALE SEPARATION
	
	;IF 'Hertz' MODE SELECTED...	
	elseif isepmode==1 then
	 inum	=	inum + 1
	 ksep	=	inum

	;IF 'Octaves (Adjacent)' MODE SELECTED...
	elseif isepmode==2 then 
	 irescale	divz	inum,inum-1,1	;PREVENT ERROR IS NUMBER OF FILTERS = ZERO
	 ksep = ksep * irescale			;RESCALE SEPARATION
	 ksep = ksep * (inum-1)			;RESCALE SEPARATION INTERVAL ACCORDING TO THE NUMBER OF FILTERS CHOSEN
	 isepmode	=	0
	endif

	aout 		resony 	ain, kbf, kbw, inum, ksep , isepmode, iscl, 0
			xout	aout
endop


opcode Resonator, aa, aakkkkkkkk

	kporttime	linseg	0,0.001,0.005,1,0.005	;CREATE A VARIABLE FUNCTION THAT RAPIDLY RAMPS UP TO A SET VALUE	

	ainL, ainR, kbf, kbw, kgain, knum, ksep, ksep2, ksepmode, kscl xin


	kbf expcurve kbf, 10
	kbf scale kbf, 20000, 20
	kbf init 900
	Slpf sprintfk "BF: %dHz", kbf
		puts Slpf, kbf

	kbw logcurve kbw, 0.0001
	kbw scale kbw, 1000, 0.01
	kbw init 13
	Slpf sprintfk "BW: %dHz", kbw
		puts Slpf, kbw

	kgain scale kgain, 1, 0.0001
	kgain init 30
	Smix sprintfk "Gain: %f", kgain
		puts Smix, kgain+1 

	knum scale knum, 80, 1
	knum init 10
	Smix sprintfk "Num.: %f", knum
		puts Smix, knum+1 

	ksep scale ksep, 11, -11
	ksep init 2
	Smix sprintfk "Sep.Oct: %f", ksep
		puts Smix, ksep+1 

	ksep2 scale ksep2, 48, -48
	ksep2 init 24
	Smix sprintfk "Sep.Semi: %f", ksep2
		puts Smix, ksep2+1 



	kbf	portk	kbf, kporttime		;SMOOTH MOVEMENT OF SLIDER VARIABLE TO CREATE BASE FREQUENCY

	ksep	portk	ksep, kporttime	;SMOOTH MOVEMENT OF SLIDER VARIABLE

	kSwitch		changed	kscl, knum, ksepmode		;GENERATE A MOMENTARY '1' PULSE IN OUTPUT 'kSwitch' IF ANY OF THE SCANNED INPUT VARIABLES CHANGE. (OUTPUT 'kSwitch' IS NORMALLY ZERO)
	if	kSwitch=1	then		;IF I-RATE VARIABLE CHANGE TRIGGER IS '1'...
		reinit	START			;BEGIN A REINITIALISATION PASS FROM LABEL 'START'
	endif
	START:
	
	isepmode	init	i(ksepmode)
	inum		init	i(knum)	
	iscl		init	i(kscl)
	
	;CALL resony2 UDO
	aresL 		resony2 ainL, kbf, kbw, inum, ksep , isepmode, iscl
	aresR 		resony2	ainR, kbf, kbw, inum, ksep , isepmode, iscl

	rireturn	;RETURN FROM REINITIALISATION PASS TO PERFORMANCE TIME PASSES
			xout	aresL * kgain, aresR * kgain	;SEND FILTER OUTPUT TO THE AUDIO OUTPUTS AND SCALE USING THE FLTK SLIDER VARIABLE gkgain
endop

opcode ResonatorFollower, aa, aakkkkkkkk

	kporttime	linseg	0,0.001,0.005,1,0.005	;CREATE A VARIABLE FUNCTION THAT RAPIDLY RAMPS UP TO A SET VALUE	

	ainL, ainR, kbf, kbw, kgain, knum, ksep, ksep2, ksepmode, kscl xin


	kbf expcurve kbf, 10
	kbf scale kbf, 20000, 20
	kbf init 900
	Slpf sprintfk "BF: %dHz", kbf
		puts Slpf, kbf

	kbw logcurve kbw, 0.0001
	kbw scale kbw, 1000, 0.01
	kbw init 13
	Slpf sprintfk "BW: %dHz", kbw
		puts Slpf, kbw

	kgain scale kgain, 1, 0.0001
	kgain init 30
	Smix sprintfk "Gain: %f", kgain
		puts Smix, kgain+1 

	knum scale knum, 80, 1
	knum init 10
	Smix sprintfk "Num.: %f", knum
		puts Smix, knum+1 

	ksep scale ksep, 11, -11
	ksep init 2
	Smix sprintfk "Sep.Oct: %f", ksep
		puts Smix, ksep+1 

	ksep2 scale ksep2, 48, -48
	ksep2 init 24
	Smix sprintfk "Sep.Semi: %f", ksep2
		puts Smix, ksep2+1 



	kbf	portk	kbf, kporttime		;SMOOTH MOVEMENT OF SLIDER VARIABLE TO CREATE BASE FREQUENCY

	;krms rms (ainL + ainR) * 0.5
	;printk2 krms
	afollow follow2 (ainL + ainR) * 0.5, 0.1, 0.1
	kfollow downsamp afollow

	kbwmod scale kfollow, 0.8, 1.5
	kbfmod scale kfollow, 100, 0
	;kbfmod port kbfmod, 0.2

	kbw = kbw * kbwmod
	kbf = kbf + kbfmod

	ksep	portk	ksep, kporttime	;SMOOTH MOVEMENT OF SLIDER VARIABLE

	kSwitch		changed	kscl, knum, ksepmode		;GENERATE A MOMENTARY '1' PULSE IN OUTPUT 'kSwitch' IF ANY OF THE SCANNED INPUT VARIABLES CHANGE. (OUTPUT 'kSwitch' IS NORMALLY ZERO)
	if	kSwitch=1	then		;IF I-RATE VARIABLE CHANGE TRIGGER IS '1'...
		reinit	START			;BEGIN A REINITIALISATION PASS FROM LABEL 'START'
	endif
	START:
	
	isepmode	init	i(ksepmode)
	inum		init	i(knum)	
	iscl		init	i(kscl)
	
	;CALL resony2 UDO
	aresL 		resony2 ainL, kbf, kbw, inum, ksep , isepmode, iscl
	aresR 		resony2	ainR, kbf, kbw, inum, ksep , isepmode, iscl

	rireturn	;RETURN FROM REINITIALISATION PASS TO PERFORMANCE TIME PASSES
			xout	aresL * kgain, aresR * kgain	;SEND FILTER OUTPUT TO THE AUDIO OUTPUTS AND SCALE USING THE FLTK SLIDER VARIABLE gkgain
endop

