<CsoundSynthesizer>
<CsOptions>
-odac -Ma --midi-key-cps=4 --midi-velocity-amp=5
</CsOptions>
<CsInstruments>

massign 0, 1  ; assign all MIDI channels to instrument 1
sr = 44100 // sample rate
0dbfs = 1 // maximum amplitude (0 dB) is 1
nchnls = 2 // number of channels is 2 (stereo)
ksmps = 64 // number of samples in one control cycle (audio vector)

instr 1
  // get p4 from the score line as amplitude
    iAmp ampmidi 1
  iFreq cpsmidi
  // settings for madsr envelope
    iMidiKey = notnum()  ; capture the MIDI note number
  iMidiVel = veloc()


    ; Rest of your instrument code remains the same
  iAtt, iDec, iSus, iRel = 0.1, 0.4, 0.6, 0.7
  kEnv = madsr:k(iAtt,iDec,iSus,iRel)
  iCutoff, iRes = 5000, 0.4
  aVco1 = vco2:a(iAmp,iFreq)
  aVco2 = vco2:a(iAmp,iFreq*0.99)
  aLp = moogladder:a((aVco1+aVco2)/2,iCutoff*kEnv,iRes)
  outall(aLp*kEnv)
endin

</CsInstruments>
<CsScore>
// empty score as we expect midi to trigger the instrument

</CsScore>
</CsoundSynthesizer>
