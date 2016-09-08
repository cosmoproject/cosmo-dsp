opcode PartitionConv, aa, aak
	ainL, ainR, kConv_Mix xin

	kConv_Mix scale kConv_Mix, 1, 0
	Srev sprintfk "Convolution Mix: %f", kConv_Mix
		puts Srev, kConv_Mix+1 

	kConv_Mix init 0.5


; Define partion size.
; Larger values require less CPU but result in more latency.
; Smaller values produce lower latency but may cause -
; - realtime performance issues
ipartitionsize	=	  4096

aconvL	        pconvolve ainL, "../SoundFiles/ImpulseResponses/Castello de Gualtieriis_ir1.wav" ,ipartitionsize
;aconvL	        pconvolve ainL, "../SoundFiles/ImpulseResponses/balance-mastering-teufelsberg-IR-01-44100-24bit.wav" ,ipartitionsize, 1
;aconvR	        pconvolve ainR, "../SoundFiles/ImpulseResponses/balance-mastering-teufelsberg-IR-01-44100-24bit.wav" ,ipartitionsize, 2

aconvR = aconvL
; create a delayed version of the input signal that will sync -
; - with convolution output

adelL           delay     ainL, ipartitionsize/sr
adelR			delay     ainR, ipartitionsize/sr
; create a dry/wet mix
aMixL           ntrpol    adelL, aconvL*0.1,kConv_Mix
aMixR           ntrpol    adelR, aconvR*0.1,kConv_Mix


	xout aMixL, aMixR
endop




	
