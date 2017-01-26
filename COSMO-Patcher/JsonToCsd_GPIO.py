import sys
from CosmoGraph.CosmoPatcherGraph import CosmoPatcherGraph

mode = sys.argv[1]
input_filename = sys.argv[2]
output_filename = sys.argv[3]

C_set = CosmoPatcherGraph()

if (mode == 'run'):

	print 'Load Json file ' + input_filename
	C_set.read_settings_json(input_filename)

	print 'Convert Json to Graph / csd structure.'
	C_set.cosmo_settings_to_cosmo_graph()

	# print 'All nodes and edges'
	# print C_set.nodes()
	# print C_set.edges(data = True)

	print 'Generate Csound File'
	C_set.generate_csound_code_from_graph()

	print 'Write Csound file .. ' + output_filename
	C_set.write_csd(output_filename)

elif (mode == 'export'):
	output_path = sys.argv[4]
	C_set.export_patch(input_filename, output_filename, output_path)
else:
	print "Wrong arguments. See README.md for instructions"