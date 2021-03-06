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

# read all file names in directory
fileDir = os.path.dirname(__file__)
mypath = os.path.join(fileDir, '../Effects/')
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

# create master include file
fXFilePath = '#include "../Effects/'
filename = os.path.join(fileDir, '../Includes/cosmo-dsp.inc')
with open(filename, 'w+') as include_file:
    for udo in udos:
        include_file.write(fXFilePath + udo[0] + '"\n')
    include_file.close


# make LATEX table, used in NIME 2017 paper
head = ['UDO', 'Arguments']
latexTable = tabulate(udos, headers=head,  tablefmt='latex')
latexTable = latexTable.replace(',', ' \par')
print(latexTable)

# make Markup table
markupTable = tabulate(udos, headers=head, tablefmt='pipe')
print(markupTable)

# export Markup table into README.me file
filename = os.path.join(fileDir, '../README.md')
with open(filename, 'w+') as readme_file:
    readme_file.write('## List of effects: \n')
    readme_file.write(markupTable)
    readme_file.close
