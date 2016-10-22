instr SineSynth1

	iamp = ampdbfs(p4)
	icps = p5

	Sprint sprintfk "Starting instrument 3: %f", icps
		puts Sprint, k(icps)

	kampenv = madsr:k(1, 0.1, 0.95, 0.5)
	a1 oscil 0.5, icps * 1.5
	a2 oscil 0.3, icps * 2
	a3 oscil 0.2, icps * 3
	a4 oscil 0.1, icps * 5

	a1 *= kampenv * iamp 

	aL, aR pan2 a1, 0.45

	chnmix aL, "MasterL"
	chnmix aR, "MasterR"

endin

instr PolySineSynth1

	iattack init 1
	irelease init 0.5

	iamp = ampdbfs(p4)
	icps = p5
	iattack = p6
	irelease = p7 



	print iattack
	print irelease

	kampenv = madsr:k(iattack, 0.1, iamp, irelease)
	a1 oscil 0.5, icps
	a2 oscil 0.3, icps * 1.5
	a3 oscil 0.2, icps * 2

	asynth = a1+a2+a3

	asynth *= kampenv

	aL, aR pan2 asynth, 0.55

	chnmix aL, "MasterL"
	chnmix aR, "MasterR"

endin
