This configuration script allows to map Controllers (Knobs/Pots) directly to effect parameters, without manually editing a Csound file.
From the CosmoSetting.json the controller mappings are used to generate a .csd, based on the used UDOs in this cosmo-dsp repository.

## Run

    ./run.sh

## Edit Knob Mapping

    nano CosmoSetting.json


## Edit Csound Settings

    nano CosmoGraph/Intro.csd


## Run with filenames

        python CosmoToCsd.py CosmoSetting.json workfile.csd
        csound workfile.csd
