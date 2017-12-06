#!/usr/bin/env python
'''
looks at all the files in the dsp effects folder DSP-Library/Effects
and makes a JSON file with available effects and their arguments
'''
from os import listdir
from os.path import isfile, join, splitext
import logging
import json


def main():
    '''
    main method
    MUST parameterise paths and log level
    and use these as default values
    '''
    effects_path = '../../DSP-Library/Effects'
    out_path = 'webapp/scripts/'
    out_file = 'effects.json'
    arguments_line = 'Arguments:'
    logging.info('Gathering available effects from %s', effects_path)
    files = [f for f in listdir(effects_path) if isfile(join(effects_path, f))]
    effects_json = {}
    for effect in files:
        logging.debug('Effect: %s', effect)
        with open(join(effects_path, effect)) as effect_file:
            for line in effect_file:
                line = line.strip()
                if line.startswith(arguments_line):
                    args = [arg.strip() for arg in
                            line.split(arguments_line)[-1].split(',')]
                    effects_json[splitext(effect)[0]] = args
                    logging.debug('Arguments: %s', args)
    with open(join(out_path, out_file), 'w+') as out_effects:
        # could we take a backup in case of exceptions
        # so that the GUI doesn't fail?
        out_effects.write(json.dumps(effects_json))
        logging.info('%s written to %s successfully.', out_file, out_path)
    return


if __name__ == "__main__":
    logging.basicConfig(level=logging.INFO,
                        format='%(asctime)s - %(levelname)s: %(message)s')
    main()

__author__ = "Saranya Balasubramanian"
__license__ = "MIT"
__version__ = "0.1"
__email__ = "balasubramanian@mdw.ac.at"
__status__ = "work in progress"
