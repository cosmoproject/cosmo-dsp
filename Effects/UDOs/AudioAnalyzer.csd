;***************************************************
opcode	AudioAnalyzer, aa, aa
	ainL, ainR     xin

    ; Send audio to instruments
    chnset ainL, "AudioInLeft"
    chnset ainR, "AudioInRight"

    ainMono     = ainL + ainR 
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


    