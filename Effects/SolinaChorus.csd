/********************************************************

  SolinaChorus.csd
  Author: Steven Yi
  Stereo version: Kevin Welsh (tgrey)
  COSMO UDO adaptation: Bernt Isak Wærstad

  Arguments: LFO1 Frequency, LFO1 Amp, LFO2 Frequency, LFO2 Amp, Dry/wet mix, [, Stereo mode on/off]
  Defaults:  0.2, 0.3, 0.4, 0.3, 0.5

  Stereo mode is optional

  Solina Chorus, based on Solina String Ensemble Chorus Module

   based on:

   J. Haible: Triple Chorus
   http://jhaible.com/legacy/triple_chorus/triple_chorus.html

   Hugo Portillo: Solina-V String Ensemble
   http://www.native-instruments.com/en/reaktor-community/reaktor-user-library/entry/show/4525/

   Parabola tabled shape borrowed from Iain McCurdy delayStereoChorus.csd:
   http://iainmccurdy.org/CsoundRealtimeExamples/Delays/delayStereoChorus.csd


*********************************************************/



gi_solina_parabola ftgen 0, 0, 65537, 19, 0.5, 1, 180, 1

;; 3 sine wave LFOs, 120 degrees out of phase
opcode sol_lfo_3, aaa, kkk
  kfreq, kamp, kstereo xin

  if kstereo = 1 then
    kphase = .5
  else
    kphase = 0
  endif

  aphs phasor kfreq, i(kphase)

  a0   = tablei:a(aphs, gi_solina_parabola, 1, 0, 1)
  a120 = tablei:a(aphs, gi_solina_parabola, 1, 0.333, 1)
  a240 = tablei:a(aphs, gi_solina_parabola, 1, -0.333, 1)

  xout (a0 * kamp), (a120 * kamp), (a240 * kamp)
endop

opcode SolinaChorus, a, akkkkk

  aLeft, klfo_freq1, klfo_amp1, klfo_freq2, klfo_amp2, kdrywet xin

  imax = 100

  ;; slow lfo
  as1, as2, as3 sol_lfo_3 klfo_freq1, klfo_amp1, 0

  ;; fast lfo
  af1, af2, af3  sol_lfo_3 klfo_freq2, klfo_amp2, 0

  at1 = limit(as1 + af1 + 5, 0.0, imax)
  at2 = limit(as2 + af2 + 5, 0.0, imax)
  at3 = limit(as3 + af3 + 5, 0.0, imax)

  a1 vdelay3 aLeft, at1, imax
  a2 vdelay3 aLeft, at2, imax
  a3 vdelay3 aLeft, at3, imax

  asolina = (a1 + a2 + a3) / 3

  aout ntrpol asolina, aLeft, kdrywet

xout aout
endop

opcode SolinaChorus, aa, aakkkkkP

  aLeft, aRight, klfo_freq1, klfo_amp1, klfo_freq2, klfo_amp2, kdrywet, kstereo_mode xin

  imax = 100

  ;; slow lfo
  as1, as2, as3 sol_lfo_3 klfo_freq1, klfo_amp1, 0

  ;; fast lfo
  af1, af2, af3  sol_lfo_3 klfo_freq2, klfo_amp2, 0

;; slow lfo
  asr1, asr2, asr3 sol_lfo_3 klfo_freq1, klfo_amp1, kstereo_mode

  ;; fast lfo
  afr1, afr2, afr3  sol_lfo_3 klfo_freq2, klfo_amp2, kstereo_mode

  at1 = limit(as1 + af1 + 5, 0.0, imax)
  at2 = limit(as2 + af2 + 5, 0.0, imax)
  at3 = limit(as3 + af3 + 5, 0.0, imax)

  atr1 = limit(asr1 + afr1 + 5, 0.0, imax)
  atr2 = limit(asr2 + afr2 + 5, 0.0, imax)
  atr3 = limit(asr3 + afr3 + 5, 0.0, imax)

  aL1 vdelay3 aLeft, at1, imax
  aL2 vdelay3 aLeft, at2, imax
  aL3 vdelay3 aLeft, at3, imax

  aR1 vdelay3 aRight, atr1, imax
  aR2 vdelay3 aRight, atr2, imax
  aR3 vdelay3 aRight, atr3, imax

  aSolinaL = (aL1 + aL2 + aL3) / 3
  aSolinaR = (aR1 + aR2 + aR3) / 3

  aOutL ntrpol aSolinaL, aLeft, kdrywet
  aOutR ntrpol aSolinaR, aRight, kdrywet

  xout aOutL, aOutR

endop
