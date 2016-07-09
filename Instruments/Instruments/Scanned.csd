;Author: Giorgio Zucco (2012)

giInit		ftgen 0, 0, 128, 10, 1

; Masses
giMasses 	ftgen 0, 0, 128, -7,  1, 128, .8
; Spring matrices
giSpring 	ftgen 0, 0, 16384, -23, "data/string-128"
; Centering force
giCenter 	ftgen 0, 0, 128, -7, 0, 64, 6, 64, 0
; Damping
giDamp	 	ftgen 0, 0, 128, -7, 1, 128, .0001
; Initial velocity
giVelo		ftgen 0, 0, 128, -7, .02, 128, 0
; Trajectories
giTraj1			ftgen 0, 0, 128, -5, .001, 32, 64, 64, 96, 32

giTraj2			ftgen 0, 0, 128, -7, 0, 128, 128   

instr	Scanned

	;channel

	krate  	= 0.07 ; 0.01 - 0.2
	ksemil	= -12 ; -12 - 12 
	kcut 	= 12000 ; cutoff
	kreso	= 0.3
	kspread = 0.5 ; 0 - 1


	klfoamp		= 0; 0 - 4
	klforate	= 0; 0.1 - 10
	klfoamp2	= 0; 0 - 1000	;lfo x filter
	klforate2	= 0; 0 - 10 

	;midi

	iamp	= p4
	icps 	= p5
	;lfo
	klfo	lfo	klfoamp,klforate,2
	;kfreq =	cpsmidinn(imidinn+kbend+int(ksemi1))+klfo ;controllo midi
	kfreq =	icps + klfo 

	;scanned
	ktrig	changed	krate
	if	ktrig	=	1	then
		reinit	play
	endif

play:
	;irate	=	i(krate)
	/*
	ifnvel	=	6
	ifnmass	=	2
	ifnstif	=	3
	ifnctr	=	4
	ifndamp	=	5
	*/

	ifnvel	=	giVelo
	ifnmass	=	giMasses
	ifnstif	=	giSpring
	ifnctr	=	giCenter
	ifndamp	=	giDamp

	kmass	=	2
	kstif	=	.1
	kcentr	=	.1
	kdamp	=	-.01
	ileft	=	.5
	iright	=	.5
	kpos	=	0
	ky	=	0
	ain	=	0
	idisp	=	1
	id	=	2

	scanu	giInit,.01+i(krate),ifnvel,ifnmass,ifnstif,ifnctr,ifndamp,kmass,kstif, kcentr,kdamp,ileft,iright,kpos,ky,ain,idisp,id

	asig1	scans	iamp,kfreq,giTraj2,id
	asig2	scans	iamp,kfreq,giTraj1,id
	;filter	
	klfofilter	lfo	klfoamp2,klforate2,3
	amoog1	moogladder2	asig1,kcut+klfofilter,kreso
	amoog2	moogladder2	asig2,kcut+klfofilter,kreso
	aout1	balance	amoog1,asig1
	aout2	balance	amoog2,asig2

	;master
	aL	clip	aout1,0,.9
	aR	clip	aout2,0,.9


	aoutL = ((aL * kspread) + (aR * (1 - kspread))) *.5  
	aoutR = ((aL * (1-kspread)) + (aR * kspread))   *.5

	kadsr = madsr:k(1, 0.1, 0.95, 0.5)

	aoutL = aoutL*kadsr
	aoutR = aoutR*kadsr

    chnmix aoutL, "MasterL"
    chnmix aoutR, "MasterR"

endin


