/********************************************************

    EXPERIMENTAL!

    AudioAnalyzer.csd
    Author: Bernt Isak Wærstad

    Arguments: Attack, Release, Gain
    Defaults:  0.5, 0.5, 0.5

    Attack: 0.01 - 10 seconds
    Release: 0.01 - 10 seconds
    Gain: 0.1 - 10

    Audio analyzer with a quick, a slow and an adjustable
    envelope follower - available as control signals 
    through the chn channels "EnvelopeFollower", 
    "EnvelopeFollowerQuick" and "EnvelopeFollowerSlow"

********************************************************/


opcode	AudioAnalyzer, aa, aakkk
	ainL, ainR, katt, krel, kgain xin

    katt scale katt, 10, 0.01
    krel scale krel, 10, 0.01
    kgain scale kgain, 10, 0.1    


    ; Send audio to instruments
    chnset ainL, "AudioInLeft"
    chnset ainR, "AudioInRight"

    ainMono     = (ainL + ainR) * 0.75

    afollow follow2 ainMono * 4, katt, krel
    kfollow downsamp afollow
    kfollow portk kfollow, 0.01

    afollowQuick follow2 ainMono * 4, 0.1, 0.1
    kfollowQuick downsamp afollowQuick
    kfollowQuick portk kfollowQuick, 0.01

    afollowSlow follow2 ainMono * 4, 2, 2
    kfollowSlow downsamp afollowSlow
    kfollowSlow portk kfollowSlow, 0.1

    chnset kfollow, "EnvelopeFollower"
    chnset kfollowQuick, "EnvelopeFollowerQuick"    
    chnset kfollowSlow, "EnvelopeFollowerSlow"

    xout ainL, ainR

endop
