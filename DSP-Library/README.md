## List of effects: 
| UDO              | Arguments                                                                                                                                    |
|:-----------------|:---------------------------------------------------------------------------------------------------------------------------------------------|
| Ampmod.udo       | ModOffset, ModFreq, ModFreqMulti, Mix [, mode, ModIndex, Feed, ModWave]                                                                      |
| Autopan.udo      | Amount, Rate, Phase [, Wave]                                                                                                                 |
| Bitcrusher.udo   | Bits, Fold, Level, DryWet_Mix                                                                                                                |
| Blur.udo         | Blur time, Gain, Dry/wet mix[, StereoMode]                                                                                                   |
| Chorus.udo       | Feedback, Dry/wet mix                                                                                                                        |
| Distortion.udo   | Level, Drive, Tone, Dry/wet mix                                                                                                              |
| Flanger.udo      | Rate, Depth, Offset, Feed, Mix [, Wave]                                                                                                      |
| Highpass.udo     | Cutoff_frequency, Resonance, Distortion [, Mode]                                                                                             |
| Lowpass.udo      | Cutoff frequency, Resonance, Distortion [, Mode]                                                                                             |
| MultiDelay.udo   | Multi tap on/off, Delay time, Feedback, Cutoff, Dry/wet mix                                                                                  |
| Phaser.udo       | Rate, Feedback, Notches, Mix [, Mode, Wave, Stereo]                                                                                          |
| PitchShifter.udo | Semitones, Dry/wet mix [, Slide, Formant, Delay, Feedback]                                                                                   |
| Repeater.udo     | Range, Repeat_time, On_off [, MixMode]                                                                                                       |
| Reverb.udo       | DecayTime, HighFreq_Cutoff, DryWet_Mix, Mode                                                                                                 |
| Reverse.udo      | Reverse_time, Speed, Dry/wet mix                                                                                                             |
| SSB.udo          | ModFreq, ModFreqMulti, Balance, Mix                                                                                                          |
| SimpleLooper.udo | Record_Play, Play_Stop, Speed, Reverse, CrossFadeDur, Audio_Through, LoopStart, LoopEnd                                                      |
| TapeDelay.udo    | DelayTime, Feedback, Filter, Mix [, StereoMode]                                                                                              |
| TriggerDelay.udo | Threshold, DelayTime Min, DelayTime Max, Feedback Min, Feedback Max, Width, Level, Portamento time, Cutoff frequency, Bandwidth, Dry/wet mix |
| Volume.udo       | Level                                                                                                                                        |

## List of modulators:
| UDO                  | Arguments                                     |
|:---------------------|:----------------------------------------------|
| EnvelopeFollower.udo | Attack, Release, Gain [, Smoothing]           |
| LFO.udo              | Rate [, Wave, Smoothing]                      |
| OnsetDetection.udo   | Db_Diff, Min_Time, Min_Db [, Delay, Rms_Freq] |
| PitchTracker.udo     | [Smoothing]                                   |