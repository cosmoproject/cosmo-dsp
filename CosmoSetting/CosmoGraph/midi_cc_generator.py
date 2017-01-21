import os

def gen():
	midiVars = []
	for chn in range (1, 17):
		for cc in range(1,128):
			midiVars.append("gkCC%i_ch%i ctrl7 %i, %i, 0, 1" % (cc, chn, chn, cc))
	return midiVars

print gen()


def write_csd():
	fileDir = os.path.dirname(__file__)
	filename = os.path.join(fileDir, "all_midi_cc.inc")
	var = gen() 
	with open(filename, 'w+') as midi_cc_file:
		midi_cc_file.write(";name  ctrl7  midi-ch, midi-cc, min, max\n")
		for i in range(len(var)):
			midi_cc_file.write(var[i] + "\n")
		midi_cc_file.close

write_csd()