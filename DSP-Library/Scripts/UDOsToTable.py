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
for csd in onlyfiles:
    arguments = []
    arguments.append(csd)
    filename = join(mypath + '/' + str(csd))
    with open(filename) as UDO_file:
        for line in UDO_file:
            if 'Arguments' in line:
                colPos = line.find(':')
                if colPos is not -1:
                    b = line[colPos+1:]
                    arguments.append(b)
    udos.append(arguments)
print udos

# make LATEX table, used in NIME 2017 paper
head = ['UDO', 'Arguments']
latexTable = tabulate(udos, headers = head,  tablefmt = 'latex')
latexTable = latexTable.replace(',', ' \par')
print latexTable

# make Markup table
markupTable = tabulate(udos, headers = head, tablefmt = 'pipe')
print markupTable

# export Markup table into README.me file
filename = os.path.join(fileDir, '../Effects/README.md')
with open(filename, 'w+') as readme_file:
    readme_file.write('## List of supported effect UDOs: \n')
    readme_file.write(markupTable)
    readme_file.close
