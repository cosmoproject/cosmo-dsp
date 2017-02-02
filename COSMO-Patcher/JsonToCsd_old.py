""" Convert COSMO .json mappings to Csound Instrument files (.csd)

python JsonToCsd.py [input .json] [output .csd] export [output directory]
e.g python JsonToCsd.py MIDI-Patch.json MyCOSMO.csd export ../../MyCOSMO/
"""

import sys
from CosmoGraph.CosmoPatcherGraph import CosmoPatcherGraph


input_filename = sys.argv[1]
output_filename = sys.argv[2]
mode = sys.argv[3]

C_set = CosmoPatcherGraph()


if (mode == 'export'):
	output_path = sys.argv[4]
	C_set.export_patch(input_filename, output_filename, output_path)
else:
    print 'Load Json file ' + input_filename
    C_set.read_settings_json(input_filename)

    print 'Convert Json to Graph / csd structure.'
    C_set.cosmo_settings_to_graph()

    print 'Generate Csound File'
    C_set.generate_csound_code_from_graph()

    print 'Write Csound file .. ' + output_filename
    C_set.write_csd(output_filename)
