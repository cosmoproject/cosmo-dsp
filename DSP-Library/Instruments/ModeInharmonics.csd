/*

Mode Inharmonics

Original programmed by: Øyvind Brandtsegg
Adaptation for COSMO DSP by: Bernt Isak Wærstad


*/
<CsoundSynthesizer>
<CsOptions>
-odac:hw:1,0 -iadc:hw:1 -d -+rtaudio=ALSA -b128 -B1024 --sched=99 -+rtmidi=alsa ;-M hw:2
</CsOptions>
<CsInstruments>

	sr = 44100  
	ksmps = 64
	nchnls = 2	
	0dbfs = 1
        massign 1,2

giSine		ftgen	0, 0, 65536, 10, 1	; sine

;FUNCTION TABLES STORING MODAL FREQUENCY RATIOS===================================================================================================================================
;plucked string
girtos1		ftgen	0,0,-20, -2, 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20
;dahina
girtos2		ftgen	0,0,-6,-2, 1, 2.89, 4.95, 6.99, 8.01, 9.02
;banyan
girtos3		ftgen	0,0,-6,-2, 1, 2.0, 3.01, 4.01, 4.69, 5.63
;xylophone
girtos4		ftgen	0,0,-6,-2, 1, 3.932, 9.538, 16.688, 24.566, 31.147
;tibetan bowl (180mm)
girtos5		ftgen	0,0,-7,-2, 1, 2.77828, 5.18099, 8.16289, 11.66063, 15.63801, 19.99
;spinel sphere with diameter of 3.6675mm
girtos6		ftgen	0,0,-24,-2, 1, 1.026513174725, 1.4224916858532, 1.4478690202098, 1.4661959580455, 1.499452545408, 1.7891839345101, 1.8768994627782, 1.9645945254541, 1.9786543873113, 2.0334612432847, 2.1452852391916, 2.1561524686621, 2.2533435661294, 2.2905090816065, 2.3331798413917, 2.4567715528268, 2.4925556408289, 2.5661806088514, 2.6055768738808, 2.6692760296751, 2.7140956766436, 2.7543617293425, 2.7710411870043 
;pot lid
girtos7		ftgen	0,0,-6,-2, 1, 3.2, 6.23, 6.27, 9.92, 14.15
;red cedar wood plate
girtos8		ftgen	0,0,-4,-2, 1, 1.47, 2.09, 2.56
;tubular bell
girtos9		ftgen	0,0,-10,-2, 272/437, 538/437, 874/437, 1281/437, 1755/437, 2264/437, 2813/437, 3389/437, 4822/437, 5255/437
;redwood wood plate
girtos10	ftgen	0,0,-4,-2, 1, 1.47, 2.11, 2.57
;douglas fir wood plate
girtos11	ftgen	0,0,-4,-2, 1, 1.42, 2.11, 2.47
;uniform wooden bar
girtos12	ftgen	0,0,-6,-2, 1, 2.572, 4.644, 6.984, 9.723, 12
;uniform aluminum bar
girtos13	ftgen	0,0,-6,-2, 1, 2.756, 5.423, 8.988, 13.448, 18.680
;vibraphone 1
girtos14	ftgen	0,0,-6,-2, 1, 3.984, 10.668, 17.979, 23.679, 33.642
;vibraphone 2
girtos15	ftgen	0,0,-6,-2, 1, 3.997, 9.469, 15.566, 20.863, 29.440
;Chalandi plates
girtos16	ftgen	0,0,-5,-2, 1, 1.72581, 5.80645, 7.41935, 13.91935
;tibetan bowl (152 mm)
girtos17	ftgen	0,0,-7,-2, 1, 2.66242, 4.83757, 7.51592, 10.64012, 14.21019, 18.14027
;tibetan bowl (140 mm)	
girtos18	ftgen	0,0,-5,-2, 1, 2.76515, 5.12121, 7.80681, 10.78409
;wine glass
girtos19	ftgen	0,0,-5,-2, 1, 2.32, 4.25, 6.63, 9.38
;small handbell
girtos20	ftgen	0,0,-22,-2, 1, 1.0019054878049, 1.7936737804878, 1.8009908536585, 2.5201981707317, 2.5224085365854, 2.9907012195122, 2.9940548780488, 3.7855182926829, 3.8061737804878, 4.5689024390244, 4.5754573170732, 5.0296493902439, 5.0455030487805, 6.0759908536585, 5.9094512195122, 6.4124237804878, 6.4430640243902, 7.0826219512195, 7.0923780487805, 7.3188262195122, 7.5551829268293 
;albert clock bell belfast
girtos21	ftgen	0,0,-22,-2, 2.043260,1.482916,1.000000,3.328848,4.761811,1.477056,0.612007,2.661295,1.002793,4.023776,0.254139,2.043916,4.032463,2.659438,4.775560,5.500494,3.331014,0.809697,2.391301, 0.254098,1.901476,2.366563    ;,0.614968,2.046543,1.814887,3.130744,2.484426,0.558874,0.801697,0.070870,3.617036,2.782656
;wood block
girtos22	ftgen	0,0,4,-2,	915/915,1540/915,1863/915,3112/915

giTypes         ftgen   0, 0, 32, -2, girtos1, girtos2, girtos3, girtos4, girtos5, girtos6, girtos7, girtos8, girtos9, girtos10, girtos11, girtos12, girtos13, girtos14, girtos15,
                                      girtos16, girtos17, girtos18, girtos19, girtos20, girtos21, girtos22

opcode ModePartial2, a, aiiikkkkk
    a1, itab, ipartial, inumpartials, ktransp, kQ, kdamp, kaDevamp, kfDevamp xin

    ifq             table ipartial, itab
    iaDevFq         random 1.0, 5.0
    aDev            randi kaDevamp, iaDevFq
    ifDevFq         random 1.0, 5.0
    kfDev           randi kfDevamp, ifDevFq 
    apartial        mode a1, limit(ifq*ktransp, 40, sr/4)*(1+kfDev), kQ
    
    if kdamp >= 0.01 then
    	kamp	        = ((inumpartials-ipartial+2)^(-kdamp))*(kdamp+1)
    else
        kamp            = 1
    endif
    amp             interp tonek(kamp,10)
    aout            = apartial*(1+aDev)*kamp
    if ipartial < inumpartials then
        anextsig    ModePartial2 a1, itab, ipartial+1, inumpartials, ktransp, kdamp, kQ, kaDevamp, kfDevamp
        aout        = aout+anextsig
    endif
    
    xout aout
endop

;***************************************************
	instr	ModeInharmonics_AudioInput
		ain     inch 2
        ain     = ain * 1
        chnset ain, "audio"

        afollow follow2 ain * 4, 0.1, 0.1
        kfollow downsamp afollow
        kfollow portk kfollow, 0.1

        kfreq = 400 ;+ (kfollow * 3000)
        chnset kfreq, "freq"

        ;printk2 kfreq
        ;printk2 kfollow

    endin

        
instr ModeInharmonics

    kfreq expcurve gkpot0, 10
    kfreq scale kfreq, 1000, 100
    Scut sprintfk "Frequency: %dHz", kfreq
        puts Scut, kfreq

	iamp		= 0.8;ampdbfs(-5)
	iNote		= 60;notnum
	icps		= 440;cpsmidinn(iNote)
    kcps = kfreq ;chnget "freq"

; amp envelope
	iattack		= 0.001
	idecay		= 0.3
	isustain 	= 0.7
	irelease	= 0.7
	amp		madsr	iattack, idecay, isustain, irelease

; external audio in
    ain             chnget "audio"
                        
    kQ expcurve gkpot1, 10
    kQ scale kQ, 4000, 1
    kQ init 600
    Scut sprintfk "Q: %d", kQ
        puts Scut, kQ

; mode
    ;kQ              chnget "Q"
    ;kQ = 600
    kdamp           chnget "damp"
    kdamp = 1
    kdamp           = kdamp+0.01
    itype           chnget "Instr"
    itype = 5
    itype           = itype-1
    itabNum         table itype, giTypes
    inumpartials    = ftlen(itabNum)
    kaDevamp        chnget "devAmp"
    kaDevamp = 0
    kfDevamp        chnget "devFq"
    kfDevamp = 0
    
    seed 0
    a1  ModePartial2 ain, itabNum, 0, inumpartials, kcps, kQ, kdamp, kaDevamp, kfDevamp

; apply amp envelope
	a1		= a1 * amp
    aL, aR pan2 a1, 0.45

    chnmix aL, "MasterL"
    chnmix aR, "MasterR"

endin

