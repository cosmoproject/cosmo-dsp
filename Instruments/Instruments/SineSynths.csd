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

