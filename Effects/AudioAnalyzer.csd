/********************************************************

    EXPERIMENTAL!

    AudioAnalyzer.csd
    Author: Bernt Isak Wærstad

    Arguments: Delay time, Feedback, Dry/wet mix
    Defaults:  0.4, 0.7, 0.5

    Audio analyzer with a quick and a slow envelope follower -
    available as control signals through the chn channels
    "EnvelopeFollower" and "EnvelopeFollowerSlow"

********************************************************/


opcode	AudioAnalyzer, aa, aa
	ainL, ainR     xin

    ; Send audio to instruments
    chnset ainL, "AudioInLeft"
    chnset ainR, "AudioInRight"

    ainMono     = (ainL + ainR) * 0.75
    chnset ainMono, "AudioInMono"

    afollow follow2 ainMono * 4, 0.1, 0.1
    kfollow downsamp afollow
    kfollow portk kfollow, 0.1

    afollowSlow follow2 ainMono * 4, 2, 2
    kfollowSlow downsamp afollowSlow
    kfollowSlow portk kfollowSlow, 0.1

    chnset kfollow, "EnvelopeFollower"
    chnset kfollowSlow, "EnvelopeFollowerSlow"

    xout ainL, ainR

endop
