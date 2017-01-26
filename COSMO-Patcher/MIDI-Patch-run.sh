rm workfile.csd
python JsonToCsd.py run MIDI-Patch.json workfile.csd
csound workfile.csd
