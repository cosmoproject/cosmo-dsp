## Description

This configuration script allows to map controllers (knobs/pots) directly to effect parameters, without manually editing a Csound file (.csd).

From the mappings in the .json files, Csound instruments (.csd) are generated, using the UDOs in this (DSP-Library/Effects) repository.

## Install

    sudo pip install -r CosmoGraph/requirements.txt

    ('pip' - is the package manager for python, you can install it via apt-get or homebrew )

## Run with a MIDI-Controller

    ./MIDI-Patch-run.sh

### Edit MIDI knob Mapping

    nano MIDI-Patch.json

### Edit Csound Settings

    nano CosmoGraph/Intro.csd

## Run with a COSMO-Box

        ./COSMO-Patch-run.sh

### Edit COSMO knob Mapping

        nano COSMO-Patch.json


### Edit Csound Settings

        nano CosmoGraph/Intro.csd


## Run with filenames

        python JsonToCsd.py MIDI-Patch.json workfile.csd
        csound workfile.csd

## Collect all files and save to a specified folder
        python JsonToCsd.py [input json file] [output csd file] -e [output directory]
        e.g python JsonToCsd.py MIDI-Patch.json MyCOSMO.csd -e ../../MyCOSMO/
