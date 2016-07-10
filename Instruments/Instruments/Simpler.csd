#include "../Effects/UDOs/FilePlay.csd"

instr Simpler

	iamp = p4
	icps = p5

	ipitch = icps / cpsmidinn(60)

	Sfile1 = "../SoundFiles/Cello Solo Legato - Short.aif"
	Sfile2 = "../SoundFiles/Vocal LR.aif"
	Sfile3 = "../SoundFiles/bank-machine-transaction.wav"
	Sfile4 = "../SoundFiles/berlin-dictatype-rapid-message.wav"

	kadsr = madsr:k(0.3, 0.1, 0.95, 0.5)

	kModAmp oscil 0.1, 0.1
	kModFreq oscil 2, 5 

	klfo lfo 0.01, kModFreq 
	kpitch = ipitch;+ (klfo)

	aL, aR FilePlay Sfile3, kpitch, 0, 1

	aL = (aL * iamp) * kadsr
	aR = (aR * iamp) * kadsr

	chnmix aL, "MasterL"
	chnmix aR, "MasterR"

endin