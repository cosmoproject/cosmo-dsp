"""
Internal test script for Json-to-csd converter (CosmoPatcherGraph).

It reads all available UDOs and generates Json mappings for each available
argument. Then it reads all generated Json files and uses the functions in
CosmoPatcherGraph to convert them back into Csound code.

"""

from os import listdir
import os
from os.path import isfile, join
import string, inspect
import json
from collections import OrderedDict
import sys
from CosmoGraph.CosmoPatcherGraph import CosmoPatcherGraph


# Read all Csound UDOS in Effect Library
fileDir = os.path.dirname(__file__)
mypath = os.path.join(fileDir, '../DSP-Library/Effects/')
onlyfiles = sorted([f for f in listdir(mypath) if isfile(join(mypath, f))])
# print onlyfiles


def _open_COSMO_UDO_read_args(udoName):
    defaultValues = []
    arguments = []
    print '..reading csd ' + str(udoName)
    fileDir = os.path.dirname(__file__)
    filename = os.path.join(fileDir, '../DSP-Library/Effects/'
                            + str(udoName))
    with open(filename) as UDO_file:
        for line in UDO_file:
            if 'Arguments' in line:
                colPos = line.find(':')
                if colPos is not -1:
                    b = line[colPos+1:]
                    b = b.replace('\n','')
                    argTokens = b.split(',')
                    #arguments.append(argTokens)
            if 'Defaults' in line:
                colPos = line.find(':')
                if colPos is not -1:
                    b = line[colPos+1:]
                    defaultValues = [float(string.strip(elem))
                                     for elem in (b.split(','))]
    #udo_inputs = {'argNames': arguments, 'defaultValues': defaultValues}
    # print udo_inputs
    return argTokens


def write_json(fileName, content_json):
    fileDir = os.path.dirname(__file__)
    mypath = os.path.join(fileDir, '../TestAllUdos/')
    if not os.path.exists(mypath):
            os.makedirs(mypath)
    filename = os.path.join(fileDir, '../TestAllUdos/' + fileName[:-4] + '.json')
    with open(filename, 'w+') as json_file:
        json_file.write(content_json)
        json_file.close
    pass


## --- make Json from UDOS ---

start_cc_num = 20

for file_name in onlyfiles:
    cc_dict = {}
    udo_inputs = _open_COSMO_UDO_read_args(file_name)
    # udo_inputs['argNames']
    print udo_inputs
    for idx, arg in enumerate(udo_inputs):
        cc_num = 'CC%s_CH%s' % (start_cc_num+idx, 1)
        udo_dict = {}
        udo_dict = {file_name[:-4] : arg}
        cc_dict[cc_num] = udo_dict

    main_dict = {'MIDI-Patch': cc_dict}
    #print main_dict
    write_json(file_name, json.dumps(main_dict, indent=2))

## --- make csd's from JSON ----
mypathT = os.path.join(fileDir, '../TestAllUdos/')
generated_json_f = sorted([f for f in listdir(mypathT) if isfile(join(mypathT, f))])
for file_name in generated_json_f:
    C_set = CosmoPatcherGraph()
    fileDir = os.path.dirname(__file__)
    input_filename = os.path.join(fileDir, '../TestAllUdos/' + file_name)
    print 'Load Json file ' + input_filename
    C_set.read_settings_json(input_filename)

    print 'Convert Json to Graph / csd structure.'
    C_set.cosmo_settings_to_graph()

    # print 'All nodes and edges'
    # print C_set.nodes()
    # print C_set.edges(data = True)

    print 'Generate Csound File'
    C_set.generate_csound_code_from_graph()
    output_filename = mypathT + file_name + '.csd'
    print 'Write Csound file .. ' + output_filename
    C_set.write_csd(output_filename)
