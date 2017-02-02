""" Convert COSMO .json mappings to Csound Instrument files (.csd)

python JsonToCsd.py [input .json] [output .csd] -e [output directory]
e.g python JsonToCsd.py MIDI-Patch.json MyCOSMO.csd export ../../MyCOSMO/
"""

import argparse
import os
from CosmoGraph.CosmoPatcherGraph import CosmoPatcherGraph

C_set = CosmoPatcherGraph()

parser = argparse.ArgumentParser()
parser.add_argument('-e', '--export', help = 'Export to..',
                    type=str)
parser.add_argument('inputfile', type=str)
parser.add_argument('outputfile', type=str)

args = parser.parse_args()

input_filename = args.inputfile
output_filename = args.outputfile

if args.export:
    if os.path.isdir(args.export):
        print 'Folder exists..please choose a new folder name.'
    else:
        print str('Exporting %s to %s into Folder: %s' % (input_filename,output_filename,args.export))
        output_path = args.export
    	C_set.export_patch(input_filename, output_filename, output_path)
else:
    print 'Converting %s to %s ' % (input_filename, output_filename)
    print 'Load Json file ' + input_filename
    C_set.read_settings_json(input_filename)

    print 'Convert Json to Graph / csd structure.'
    C_set.cosmo_settings_to_graph()

    print 'Generate Csound File'
    C_set.generate_csound_code_from_graph()

    print 'Write Csound file .. ' + output_filename
    C_set.write_csd(output_filename)
