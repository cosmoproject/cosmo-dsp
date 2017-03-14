import os


with open('all_midi_cc.inc', 'w+') as csound_midi:
	csound_midi.write(";name  ctrl7  midi-ch, midi-cc, min, max\n")
	for chn in range(1,17):
		for cc in range(1,128):
			csound_midi.write("gkCHN%i_CC%i ctrl7 %i, %i, 0, 1\n" % (chn, cc, chn, cc))
	csound_midi.close