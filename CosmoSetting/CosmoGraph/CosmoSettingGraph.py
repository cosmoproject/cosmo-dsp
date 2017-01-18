import json
import os
import networkx as nx
import string
from collections import OrderedDict


class CosmoSettingGraph(nx.DiGraph):
    # Topics will be stored as Nodes in a Graph
    def __init__(self):
        super(CosmoSettingGraph, self).__init__()

    def read_settings_json(self, path):
        with open(path) as data_file:
            self.jdata = json.load(data_file, object_pairs_hook=OrderedDict)
            print json.dumps(self.jdata, indent=2)

    def cosmo_settings_to_graph(self):
        controllers = [ctrl for ctrl in self.jdata['CosmoController']]
        lastFX = 'In'
        self.add_node('In', type='UDO')
        for ctrl in controllers:
            # controllers to nodes
            self.add_node(ctrl, type='ctrl')
            for fx in self.jdata['CosmoController'][ctrl]:
                # print data['CosmoController'][ctrl][fx]
                # udos to nodes
                print fx
                if fx not in self.nodes():
                    # print fx
                    self.add_node(fx, type='UDO')
                    if lastFX:
                        self.add_edge(lastFX, fx, type='a', color='red')
                        print 'combined ' + str(lastFX) + ' and ' + str(fx)
                    lastFX = fx
                # connect UDOS and Controllers
                self.add_edge(ctrl, fx, type='k', color='blue',
                              input=self.jdata['CosmoController'][ctrl][fx])
        self.add_node('Out', type='UDO')
        self.add_edge(lastFX, 'Out', type='a', color='red')

    def _open_COSMO_UDO_read_args(self, udoName):
        print '..reading csd ' + str(udoName)
        fileDir = os.path.dirname(__file__)
        filename = os.path.join(fileDir, '../../DSP-Library/Effects/'
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
                                    '\t \t #include "../DSP-Library/Effects/'
                                    + udo
                                    + '.csd" \n'
                                    )
                self.csnd_code_lines.append(
                                    '\t aL, aR '
                                    + str(udo)
                                    + ' aL, aR, '
                                    + argsSt + '\n'
                                    )

    def write_csd(self, csd_file_name):
        fileDir = os.path.dirname(__file__)
        filename = os.path.join(fileDir, '../' + csd_file_name)
        with open(filename, 'w+') as csd_file:
            with open(os.path.join(fileDir, 'Intro.csd')) as intro:
                with open(os.path.join(fileDir,
                                       'InstrumentDefBegin.csd')) as instrDef:
                    with open(os.path.join(fileDir, 'Outro.csd')) as outro:
                        csd_file.write(intro.read())
                        for idx, item in enumerate(self.csnd_code_includes):
                            csd_file.write(self.csnd_code_includes[idx])
                        csd_file.write(instrDef.read())
                        for idx, item in enumerate(self.csnd_code_lines):
                            csd_file.write(self.csnd_code_lines[idx])
                        csd_file.write(outro.read())
                        csd_file.close

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
# C_set = CosmoSettingGraph()
# # C_set.open_COSMO_UDO_read_args('Lowpass')
# print 'Load Json'
# # json is read correctly, using 'OrderedDict'
# C_set.read_settings_json('2CosmoSetting.json')
#
# print 'Json to Graph'
# # graph connects FX modules in correct order (lastfx in correct if statement)
# C_set.cosmo_settings_to_graph()
# C_set.print_fx_in_order()
# C_set.generate_csound_code_from_graph()
# # C_set.write_csd()
#


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
