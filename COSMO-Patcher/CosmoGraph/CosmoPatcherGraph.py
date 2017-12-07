import json
import os
import sys
import networkx as nx
import string
from collections import OrderedDict
from subprocess import call
from sys import platform

def is_number(s):
    try:
        float(s)
        return True
    except ValueError:
        return False


def is_number(s):
    try:
        float(s)
        return True
    except ValueError:
        pass

    try:
        import unicodedata
        unicodedata.numeric(s)
        return True
    except (TypeError, ValueError):
        pass
    return False


class CosmoPatcherGraph(nx.DiGraph):
    """ Converter of JSON-based conroller mappings (.json) to Csound file (.csd)

    Controller inputs and UDOs assigned in the .json will be stored as Nodes
    in a graph.


    """
    def __init__(self):
        super(CosmoPatcherGraph, self).__init__()
        self.import_dsp_path = '../DSP-Library/'
        self.include_dsp_path = '../DSP-Library/'
        self.csnd_code_includes = []
        self.csnd_code_lines = []

    def set_include_dsp_path(self, path):
        self.include_dsp_path = path

    def read_settings_json(self, path):
        with open(path) as data_file:
            self.jdata = json.load(data_file, object_pairs_hook=OrderedDict)
            print json.dumps(self.jdata, indent=2)
            # check if a COSMO or MIDI Patch is given
            for keys in self.jdata.items():
                if 'MIDI-Patch' in keys:
                    print 'MIDI'
                    self.controller_type = 'MIDI-Patch'
                elif 'COSMO-Patch' in keys:
                    print 'COSMO'
                    self.controller_type = 'COSMO-Patch'
                elif 'CsOptions' in keys:
                    print 'found CsOptions'
                    self.Csoptions = keys
                    print self.Csoptions
                else:
                    print 'invalid'
                    sys.exit('Json input not valid. '
                             'Neihter a MIDI nor a COSMO-Patch.')

    def cosmo_settings_to_graph(self):
            controllers = [ctrl for ctrl in self.jdata[self.controller_type]]
            lastFX = 'In'
            self.add_node('In', type='UDO')
            for ctrl in controllers:
                # controllers to nodes, add 'gk' non numbers
                if not is_number(ctrl):
                    ctrl_var = "gk%s" % ctrl
                else:
                    ctrl_var = str(ctrl)
                self.add_node(ctrl_var, type='ctrl')
                for fx in self.jdata[self.controller_type][ctrl]:
                    # udos to nodes
                    print fx
                    # make sure udos are only once in the graph
                    if fx not in self.nodes():
                        # print fx
                        self.add_node(fx, type='UDO')
                        if lastFX:
                            self.add_edge(lastFX, fx, type='a', color='red')
                            print 'combined ' + str(lastFX) + ' and ' + str(fx)
                        lastFX = fx
                    # connect UDOS and Controller Variables
                    self.add_edge(fx, ctrl_var, type='k', color='blue',
                                  input=self.jdata[self.controller_type][ctrl][fx]) # Is this required or unused??
            self.add_node('Out', type='UDO')
            self.add_edge(lastFX, 'Out', type='a', color='red')

    def _open_COSMO_UDO_read_args(self, udoName):
        print '..reading csd ' + str(udoName)
        fileDir = os.path.dirname(__file__)
        filename = os.path.join(fileDir, '../' + self.import_dsp_path
                                + 'Effects/'
                                + str(udoName)
                                + '.csd')
        with open(filename) as UDO_file:
            # search for Arguments and Defaults in UDO.csd header
            for line in UDO_file:
                if 'Arguments' in line:
                    argTokens = line.split(',')
                    # print argTokens
                if 'Defaults' in line:
                    colPos = line.find(':')
                    if colPos is not -1:
                        b = line[colPos+1:]
                        defaultValues = [float(string.strip(elem))
                                         for elem in (b.split(','))]
        udo_inputs = {'argNames': argTokens, 'defaultValues': defaultValues}
        # print udo_inputs
        return udo_inputs

    def _find_pos_in_args(self, argTokens, userArg):
        # add case for wrong argument used
        pos_in_arguments = None
        for idx, item in enumerate(argTokens):
            if userArg in argTokens[idx]:
                # print idx
                pos_in_arguments = idx
        return pos_in_arguments

    def _fill_none_with_defaults(self, udo_inputs, args):
        for idx, arg in enumerate(args):
            if arg is None:
                args[idx] = udo_inputs['defaultValues'][idx]
        return args

    def print_fx_in_order(self):
        print '----- printing FX in connected order ----- '
        print nx.has_path(self, 'In', 'Out')
        print nx.shortest_path(self, 'In', 'Out')
        return

    def _controller_ins(self):
        # Generate Csound MIDI CC code using 'ctrl7' opcode or 'chnget' opcode for GPIO
        if self.controller_type == 'MIDI-Patch':
            ctrls = [c for c in self.nodes() if self.node[c]['type'] == 'ctrl']
            for ctrl in ctrls:
                if 'CC' in ctrl:
                    midi_data = ctrl.split("_")
                    cc = midi_data[0]
                    chn = midi_data[1]
                    ctrl7 = "\t \t %s_%s ctrl7 %s, %s, 0, 1" % (cc, chn, chn.strip("CHN"), cc.strip("gkCC"))
                    self.csnd_code_lines.append(ctrl7 + '\n')
            self.csnd_code_lines.append('\n')
        elif self.controller_type == 'COSMO-Patch':
                fileDir = os.path.dirname(__file__)
                filename = os.path.join(fileDir, '../' + self.import_dsp_path
                                        + 'Includes/gpio_channels.inc')
                with open(filename) as csd_gpio_channels:
                    for line in csd_gpio_channels:
                        print line
                        line = '\t \t' + line
                        self.csnd_code_lines.append(line)

                filename = os.path.join(fileDir, '../' + self.import_dsp_path
                                        + 'Includes/adc_channels.inc')
                with open(filename) as csd_gpio_channels:
                    for line in csd_gpio_channels:
                        print line
                        line = '\t \t' + line
                        self.csnd_code_lines.append(line)

    def generate_csound_code_from_graph(self):
        print '-- Graph to CSD --'
        self._controller_ins()
        if nx.has_path(self, 'In', 'Out'):
            fx_chain = nx.shortest_path(self, 'In', 'Out')
            fx_chain = fx_chain[1:-1]
            print fx_chain
            for udo in fx_chain:
                udo_inputs = self._open_COSMO_UDO_read_args(udo)
                args = [None] * len(udo_inputs['argNames'])
                edges = self.edges(udo, data=True)
                print edges
                if len(edges) > 0:  # some nodes have zero edges going into it
                    for edge in edges:
                        if edge[2]['type'] == 'k':  # k-connections from UDOs
                            argNameInUDO = edge[2]['input']
                            pos = self._find_pos_in_args(
                                            udo_inputs['argNames'],
                                            argNameInUDO)
                            # print pos
                            args[pos] = edge[1]
                # print args
                args = self._fill_none_with_defaults(udo_inputs, args)
                argsSt = ', '.join(str(x) for x in args)
                self.csnd_code_includes.append(
                                    '\t#include "' + self.include_dsp_path
                                    + 'Effects/'
                                    + udo
                                    + '.csd" \n'
                                    )
                self.csnd_code_lines.append(
                                    '\t\taL, aR '
                                    + str(udo)
                                    + ' aL, aR, '
                                    + argsSt + '\n'
                                    )


    def generate_CsOptions(self):
        userDeviceName = 'cosmo1' # TODO read out from MIDI Patcher..
        if platform == "linux" or platform == "linux2":
            print 'linux'

            system_details = os.uname()
            if system_details[4] == 'x86_64':
                print 'x86_64'
                csOptions = self.Csoptions[1]['Linux']
            elif system_details[4] == 'armv7l' & system_details[1] == userDeviceName:
                print system_details[1]
                csOptions = self.Csoptions[1][system_details[1]]

        elif platform == "darwin":
            print 'OS X'
            csOptions = self.Csoptions[1]['Mac']
        elif platform == "win32":
             print 'Windows...'
             csOptions = self.Csoptions[1]['Win']

        beginCsoundFile ="<CsoundSynthesizer> \n <CsOptions> \n"
        closeOptionsCsoundFile = "\n</CsOptions>\n"
        beginInstrDef = "<CsInstruments>\n \n sr = 44100 \n ksmps = 64 \n 0dbfs	= 1 \n nchnls = 2 \n"
        CsFileIntro = str(beginCsoundFile + csOptions + closeOptionsCsoundFile + beginInstrDef)
        print CsFileIntro
        return CsFileIntro

    def write_csd(self, csd_file_name):
        fileDir = os.path.dirname(__file__)
        filename = os.path.join(fileDir, '../' + csd_file_name)
        with open(filename, 'w+') as csd_file:
            #with open(os.path.join(fileDir, 'Intro.csd')) as intro:
                with open(os.path.join(fileDir,
                                       'InstrumentDefBegin.csd')) as instrDef:
                    with open(os.path.join(fileDir, 'Outro.csd')) as outro:
            #            csd_file.write(intro.read())
                        csd_file.write(self.generate_CsOptions())
                        csd_file.write('\t#include "' + self.include_dsp_path
                                       + 'Includes/cosmo_utilities.inc"\n\n')
                        for idx, item in enumerate(self.csnd_code_includes):
                            csd_file.write(self.csnd_code_includes[idx])
                        csd_file.write(instrDef.read())
                        csd_file.write("\n")
                        for idx, item in enumerate(self.csnd_code_lines):
                            csd_file.write(self.csnd_code_lines[idx])
                        csd_file.write(outro.read())
                        csd_file.close

    def print_udos(self):
        udos = [u for u in self.nodes() if self.node[u]['type'] == 'UDO']
        print self.nodes(data=True)
        print udos
        return


    def export_patch(self, json_file, csd_file_name, export_path):
        print 'Load Json file ' + json_file
        self.read_settings_json(json_file)

        print 'Convert Json to Graph / csd structure.'
        self.cosmo_settings_to_graph()

        # Change dsp_path to export directory
        self.set_include_dsp_path("")

        print 'Generate Csound code'
        self.generate_csound_code_from_graph()

        print 'Write Csound file'
        self.write_csd(csd_file_name)

        print "\n\n\n"

        call(["mkdir", export_path])
        call(["mkdir", export_path+'Includes/'])
        call(["mkdir", export_path+'Effects'])

        # Copy include files
        call(["cp", self.import_dsp_path+'Includes/cosmo_utilities.inc', export_path+'Includes/'])
        call(["cp", self.import_dsp_path+'Includes/adc_channels.inc', export_path+'Includes/'])
        call(["cp", self.import_dsp_path+'Includes/gpio_channels.inc', export_path+'Includes/'])

        print 'Export all csd files to ' + export_path
        call(["mv", csd_file_name, export_path])

        # Copy all UDO files in use
        udos = [u for u in self.nodes() if self.node[u]['type'] == 'UDO']
        print udos
        for x in udos:
            udo_file = '%sEffects/%s.csd' % (self.import_dsp_path, x)
            call(["cp", udo_file, export_path+"Effects/"])
