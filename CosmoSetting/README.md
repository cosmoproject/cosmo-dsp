## Description

This configuration script allows to define Controllers (Knobs/Pots) directly to effect parameters, without manually editing a Csound file.

From the CosmoSetting.json the controller mappings are used to generate a Csound instrument (.csd), based on the used UDOs in this (DSP-Library/Effects) repository.

## Install

    pip install -r CosmoGraph/requirements.txt

    ('pip' - is the package manager for python, you can install it via apt-get or homebrew )

## Run

    ./run.sh

## Edit Knob Mapping

    nano CosmoSetting.json


## Edit Csound Settings

    nano CosmoGraph/Intro.csd


## Run with filenames

        python CosmoGraph/CosmoToCsd.py CosmoSetting.json workfile.csd
        csound workfile.csd
