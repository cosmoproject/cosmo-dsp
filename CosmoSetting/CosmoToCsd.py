import sys
from CosmoGraph.CosmoSettingGraph import CosmoSettingGraph

input_filename = sys.argv[1]
output_filename = sys.argv[2]

C_set = CosmoSettingGraph()

print 'Load Json file ' + input_filename
C_set.read_settings_json('CosmoSetting.json')

print 'Convert Json to Graph / csd structure.'
C_set.cosmo_settings_to_graph()

# print 'All nodes and edges'
# print C_set.nodes()
# print C_set.edges(data = True)

print 'Generate Csound File'
C_set.generate_csound_code_from_graph()

print 'Write Csound file .. ' + output_filename
C_set.write_csd(output_filename)
