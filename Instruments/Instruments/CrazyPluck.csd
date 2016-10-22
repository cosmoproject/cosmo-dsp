
;Author: Giorgio Zucco (2012)


instr	OnePluck	

;a1	pluck	(p4*1-p6)/p6,p5,p5,0,1
ival	=	(p4*1-p6)
a1	pluck	ival/p6,p5,p5,0,1

; Or using the new csound 6 function syntax
;a1	=	pluck((p4*1-p6)/p6,p5,p5,0,1)


aout	clip	a1,0,0dbfs
	
kenv	adsr	0.01,.5,.2,.1	;inviluppo

chnmix aout*kenv, "MasterL"
chnmix aout*kenv, "MasterR"

;outs	aout*kenv,aout*kenv

endin


instr	CrazyPluck

giamp	= p4	;controllo midi
gifreq	= p5

instrument	nstrnum "OnePluck"	;strumento da controllare
inum=1	;per attivare la sezione loop
idelay = 0

;inumber	chnget	"number"	;numero di eventi da generare	
inumber		= 10 ; 1 - 50

idur	=	2	;durata evento	

;iratio	chnget	"ratio"	;1,1,1,1.2	;slider che controlla il pitch transpose
iratio  = 1.1

;itime	chnget	"time"	;1,2,.001,.1	;slider che controlla il delay tra un evento e il successivo
itime 	= 0.1

;irndtime	chnget	"random"	;1,3,.001,.1 ;slider che controlla la variazione random del ritardo
irndtime 	= 0.05

loop:	;inizia la sezione da reiterare

gifreq	=	gifreq*iratio	;pitch controllato da slider 1
idelay	=	idelay+itime+rnd(irndtime)	;delay controllato da slider 2 e 3



event_i "i",instrument,idelay,idur,giamp,gifreq,abs(inumber)

loop_le inum,1,abs(inumber),loop	;ripete il processo per 20 istanze (inumber)

endin


