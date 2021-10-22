# This file updates the Readme.md file with the list of UDOS.
# Terminal:
# pip install tabulate
# python UDOsToTable.py
# Alex Hofmann (2017-19)

import os
from os import listdir
from os.path import isfile, join
import string, inspect
from tabulate import tabulate

fileDir = os.path.dirname(__file__)

def get_udo_args(fileDir, path):
    # read all file names in directory
    mypath = os.path.join(fileDir, path)

    onlyfiles = sorted([f for f in listdir(mypath) if isfile(join(mypath, f))])
    # print onlyfiles

    # read Arguments given in UDOs
    udos = []
    for udo in onlyfiles:
        if udo[-4:] == '.udo':
            arguments = []
            arguments.append(udo)
            filename = join(mypath + '/' + str(udo))
            with open(filename) as UDO_file:
                for line in UDO_file:
                    if 'Arguments' in line:
                        colPos = line.find(':')
                        if colPos is not -1:
                            b = line[colPos+1:]
                            arguments.append(b)
            udos.append(arguments)
    print(udos)
    return udos 

fx_udos = get_udo_args(fileDir, '../Effects')
mod_udos = get_udo_args(fileDir, '../Modulators')



# create master include file
fXFilePath = '#include "../Effects/'
modFilePath = '#include "../Modulators/'

filename = os.path.join(fileDir, '../Includes/cosmo-dsp.inc')
with open(filename, 'w+') as include_file:
    for udo in fx_udos:
        include_file.write(fXFilePath + udo[0] + '"\n')
    for udo in mod_udos:
        include_file.write(modFilePath + udo[0] + '"\n')
    include_file.close


# make LATEX table, used in NIME 2017 paper
head = ['UDO', 'Arguments']
latexTable = tabulate(fx_udos, headers=head,  tablefmt='latex')
latexTable = latexTable.replace(',', ' \par')
print(latexTable)

# make Markup tables
markupTable_fx = tabulate(fx_udos, headers=head, tablefmt='pipe')
print(markupTable_fx)
markupTable_mod = tabulate(mod_udos, headers=head, tablefmt='pipe')
print(markupTable_mod)

# export Markup table into README.me file
filename = os.path.join(fileDir, '../README.md')
with open(filename, 'w+') as readme_file:
    readme_file.write('## List of effects: \n')
    readme_file.write(markupTable_fx)
    readme_file.write('\n\n## List of modulators:\n')
    readme_file.write(markupTable_mod)
    readme_file.close
