## Description

This configuration script allows to map Controllers (Knobs/Pots) directly to effect parameters, without manually editing a Csound file.

From the CosmoSetting.json the controller mappings are used to generate a Csound instrument (.csd), based on the used UDOs in this (DSP-Library/Effects) repository.

## Install

    pip install -r CosmoGraph/requirements.txt

    ('pip' - is the package manager for python, you can install it via apt-get or homebrew )

## Run with a MIDI-Controller

    ./MIDI-Patch-run.sh

## Edit Knob Mapping

    nano MIDI-Patch.json


## Edit Csound Settings

    nano CosmoGraph/Intro.csd

## Run with a Cosmo-Box

        ./COSMO-Patch-run.sh

## Edit Knob Mapping

        nano COSMO-Patch.json


## Edit Csound Settings

        nano CosmoGraph/Intro.csd


## Run with filenames

        python CosmoGraph/CosmoToCsd.py MIDI-Patch.json workfile.csd
        csound workfile.csd
