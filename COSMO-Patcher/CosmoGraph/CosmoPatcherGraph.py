import json
import os
import networkx as nx
import string
from collections import OrderedDict
from subprocess import call


class CosmoPatcherGraph(nx.DiGraph):
    # Ctls and UDOS will be stored as Nodes in a Graph
    def __init__(self):
        super(CosmoPatcherGraph, self).__init__()
        self.import_dsp_path = '../DSP-Library/'
        self.include_dsp_path = '../DSP-Library/'
        self.csound_ctrl7 = []

    def set_include_dsp_path(self, path):
        self.include_dsp_path = path

    def read_settings_json(self, path):
        with open(path) as data_file:
            self.jdata = json.load(data_file, object_pairs_hook=OrderedDict)
            print json.dumps(self.jdata, indent=2)

    def cosmo_settings_to_graph(self):
        controllers = [ctrl for ctrl in self.jdata['MIDI-Patch']]
        lastFX = 'In'
        self.add_node('In', type='UDO')
        for ctrl in controllers:
            # controllers to nodes, add gk for Csound code

            ctrl_var = "gk%s" % ctrl
            self.add_node(ctrl_var, type='ctrl')
            for fx in self.jdata['MIDI-Patch'][ctrl]:
                # print data['MIDI-Patch'][ctrl][fx]
                # udos to nodes
                print fx
                if fx not in self.nodes():
                    # print fx
                    self.add_node(fx, type='UDO')
                    if lastFX:
                        self.add_edge(lastFX, fx, type='a', color='red')
                        print 'combined ' + str(lastFX) + ' and ' + str(fx)
                    lastFX = fx
                # connect UDOS and Controller Variables
                self.add_edge(fx, ctrl_var, type='k', color='blue',
                              input=self.jdata['MIDI-Patch'][ctrl][fx]) # Is this required or unused??


        self.add_node('Out', type='UDO')
        self.add_edge(lastFX, 'Out', type='a', color='red')

    def cosmo_settings_to_cosmo_graph(self):
        controllers = [ctrl for ctrl in self.jdata['COSMO-Patch']]
        lastFX = 'In'
        self.add_node('In', type='UDO')

        for ctrl in controllers:
            # controllers to nodes, add gk for Csound code

            ctrl_var = "gk%s" % ctrl
            self.add_node(ctrl_var, type='ctrl')
            for fx in self.jdata['COSMO-Patch'][ctrl]:
                # print data['MIDI-Patch'][ctrl][fx]
                # udos to nodes
                print fx
                if fx not in self.nodes():
                    # print fx
                    self.add_node(fx, type='UDO')
                    if lastFX:
                        self.add_edge(lastFX, fx, type='a', color='red')
                        print 'combined ' + str(lastFX) + ' and ' + str(fx)
                    lastFX = fx
                # connect UDOS and Controller Variables
                self.add_edge(fx, ctrl_var, type='k', color='blue',
                              input=self.jdata['COSMO-Patch'][ctrl][fx]) # Is this required or unused??


        self.add_node('Out', type='UDO')
        self.add_edge(lastFX, 'Out', type='a', color='red')

    def _open_COSMO_UDO_read_args(self, udoName):
        print '..reading csd ' + str(udoName)
        fileDir = os.path.dirname(__file__)
        filename = os.path.join(fileDir, '../' + self.import_dsp_path + 'Effects/'
                                + str(udoName)
                                + '.csd')
        with open(filename) as UDO_file:
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

    def generate_csound_code_from_graph(self):
        print '-- Graph to CSD --'
        self.csnd_code_includes = []
        self.csnd_code_lines = []

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
                                    '\t#include "' + self.include_dsp_path + 'Effects/'
                                    + udo
                                    + '.csd" \n'
                                    )
                self.csnd_code_lines.append(
                                    '\t\taL, aR '
                                    + str(udo)
                                    + ' aL, aR, '
                                    + argsSt + '\n'
                                    )

    def write_csd(self, csd_file_name):
        fileDir = os.path.dirname(__file__)
        filename = os.path.join(fileDir, '../' + csd_file_name)
        # Generate Csound MIDI CC code using ctrl7 opcode
        self.generate_ctrl7_statements()
        with open(filename, 'w+') as csd_file:
            with open(os.path.join(fileDir, 'Intro.csd')) as intro:
                with open(os.path.join(fileDir,
                                       'InstrumentDefBegin.csd')) as instrDef:
                    with open(os.path.join(fileDir, 'Outro.csd')) as outro:
                        csd_file.write(intro.read())
                        csd_file.write('\t#include "' + self.include_dsp_path + 'Includes/cosmo_utilities.inc"\n\n')
                        for idx, item in enumerate(self.csnd_code_includes):
                            csd_file.write(self.csnd_code_includes[idx])
                        csd_file.write(instrDef.read())
                        for ctrl7 in self.csound_ctrl7:
                                csd_file.write("\t\t%s\n" % ctrl7)
                        csd_file.write("\n")
                        for idx, item in enumerate(self.csnd_code_lines):
                            csd_file.write(self.csnd_code_lines[idx])
                        csd_file.write(outro.read())
                        csd_file.close

    def generate_ctrl7_statements(self):
        ctrls = [c for c in self.nodes() if self.node[c]['type'] == 'ctrl']
        for ctrl in ctrls:
            midi_data = ctrl.split("_")
            cc = midi_data[0]
            chn = midi_data[1]
            ctrl7 = "%s_%s ctrl7 %s, %s, 0, 1" % (cc, chn, chn.strip("CHN"), cc.strip("gkCC"))
            self.csound_ctrl7.append(ctrl7)


    def print_udos(self):
        udos = [u for u in self.nodes() if self.node[u]['type'] == 'UDO']
        print self.nodes(data = True)
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



    # def plot(self):
    #     import matplotlib.pyplot as plt
    #     myPos = nx.shell_layout(self)
    #     # nx.draw_networkx(self, pos=myPos)
    #     udos = [u for u in self.nodes() if self.node[u]['type'] == 'UDO']
    #     nx.draw_networkx_nodes(self, myPos,
    #                            nodelist=udos,
    #                            node_color='r',
    #                            node_size=500,
    #                            alpha=0.8)
    #     nx.draw_networkx_labels(self, myPos)
    #     ctrls = [c for c in self.nodes() if self.node[c]['type'] == 'ctrl']
    #     # nx.draw_networkx_nodes(self, myPos,
    #     #                nodelist=ctrls,
    #     #                node_color='g',
    #     #                node_size=500,
    #     #                alpha=0.8)
    #     # nx.draw_networkx_edge_labels(self, pos=myPos)
    #     plt.show()
    #     return


# -- debugging

#C_set = CosmoPatcherGraph()
# C_set.open_COSMO_UDO_read_args('Lowpass')
#print 'Load Json'
# json is read correctly, using 'OrderedDict'
#C_set.read_settings_json('MIDI-Patch.json')

#print 'Json to Graph'
# graph connects FX modules in correct order (lastfx in correct if statement)
#C_set.cosmo_settings_to_graph()
#C_set.print_fx_in_order()
#C_set.generate_csound_code_from_graph()
#C_set.print_udos()
#C_set.write_csd('test.csd')



# ---- test
# C_set.plot()
# print C_set.successors('Wobble')
# print C_set.out_edges()
#
# print 'All nodes and edges'
# print C_set.nodes()
# print C_set.edges(data = True)
#
# C_set.generate_csound_code_from_graph()
# C_set.write_csd()
