import os
from os import listdir
from os.path import isfile, join
import string, inspect
from tabulate import tabulate

#mypath = '/home/iwkah/Documents/Programming/cosmo-dsp/DSP-Library/Effects'
#mypath = '/Users/elk/Programming/cosmoProject/cosmo-dsp/DSP-Library/Effects'
fileDir = os.path.dirname(__file__)
mypath = os.path.join(fileDir, '../Effects/')
onlyfiles = sorted([f for f in listdir(mypath) if isfile(join(mypath, f))])
# print onlyfiles


udos = []
for csd in onlyfiles:
    arguments = []
    arguments.append(csd)
    filename = join(mypath + '/' + str(csd))
    with open(filename) as UDO_file:
        for line in UDO_file:
            # if 'Arguments' in line:
            #     argTokens = line.split(',')
            #     print argTokens
            if 'Arguments' in line:
                colPos = line.find(':')
                if colPos is not -1:
                    b = line[colPos+1:]
                    arguments.append(b)
    udos.append(arguments)
print udos

head = ['UDO', 'Arguments']
#print tabulate(udos, headers = head,  tablefmt = 'latex')
latexTable = tabulate(udos, headers = head,  tablefmt = 'latex')
latexTable = latexTable.replace(',', ' \par')
print latexTable

markupTable = tabulate(udos, headers = head, tablefmt = 'pipe')
print markupTable

filename = os.path.join(fileDir, '../Effects/README.md')
with open(filename, 'w+') as readme_file:
    readme_file.write('## List of supported effect UDOs: \n')
    readme_file.write(markupTable)
    readme_file.close


# x = ['o', 'arg'],['x', '14, ds, 123, 34'], ['y', 'asd, \par asd \par, ad, wer']
# print tabulate(x,headers = 'firstrow', tablefmt = 'latex')
