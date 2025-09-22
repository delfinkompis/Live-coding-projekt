<CsoundSynthesizer>
<CsOptions>
-odac -Ma --midi-key-cps=4 --midi-velocity-amp=5
</CsOptions>
<CsInstruments>


sr = 44100 
0dbfs = 1 // maximum amplitude 
nchnls = 2 // number of channels
ksmps = 64 // number of samples in one control cycle

; Program 1 (my-pause) uses Instrument #1 (synth-choir).
pgmassign 1, 1
; Program 2 (my-god) uses Instrument #2 (default cupcake-sound).
pgmassign 2, 2
; Program 3 (my-liten) uses Instrument #3 (synth-flute).
pgmassign 3, 3
; Program 4 (my-stor) uses Instrument #4 (synth-strings).
pgmassign 4, 4
; Program 5 (my-rask) uses Instrument #3 (synth-flute).
pgmassign 5, 3
; Program 6 (my-treig) uses Instrument #1 (synth-choir).
pgmassign 6, 1
; Program 7 (my-tett) uses Instrument #3 (synth-flute).
pgmassign 7, 3
; Program 8 (my-tom) uses Instrument #4 (synth-string).
pgmassign 8, 4
; Program 9 (my-vit) uses Instrument #5 (my-horizontal-percussion).
pgmassign 9, 5
; Program 10 (my-svart) uses Instrument #7 (my-static noise).
pgmassign 10, 7
; Program 11 (my-rød) uses Instrument #1 (synth-choir).
pgmassign 11, 1
; Program 12 (my-blå) uses Instrument #5 (my-horizontal-percussion).
pgmassign 12, 5
; Program 13 (my-gul) uses Instrument #3 (synth-flute).
pgmassign 13, 3
; Program 14 (my-grønn) uses Instrument #4 (synth-strings).
pgmassign 14, 4
; Program 15 (my-lavt) uses Instrument #4 (synth-strings).
pgmassign 15, 4
; Program 16 (my-høyt) uses Instrument #3 (synth-flute).
pgmassign 16, 3
; Program 17 (my-artikkel) uses Instrument #1 (synth-choir).
pgmassign 17, 1
; Program 18 (my-to) uses Instrument #3 (synth-flute).
pgmassign 18, 3






;FUNCTION TABLES STORING DATA FOR VARIOUS VOICE FORMANTS

;BASS
giBF1 ftgen 0, 0, -5, -2, 600,   400, 250,   400,  350
giBF2 ftgen 0, 0, -5, -2, 1040, 1620, 1750,  750,  600
giBF3 ftgen 0, 0, -5, -2, 2250, 2400, 2600, 2400, 2400
giBF4 ftgen 0, 0, -5, -2, 2450, 2800, 3050, 2600, 2675
giBF5 ftgen 0, 0, -5, -2, 2750, 3100, 3340, 2900, 2950

giBDb1 ftgen 0, 0, -5, -2,   0,   0,   0,   0,   0
giBDb2 ftgen 0, 0, -5, -2,  -7, -12, -30, -11, -20
giBDb3 ftgen 0, 0, -5, -2,  -9,  -9, -16, -21, -32
giBDb4 ftgen 0, 0, -5, -2,  -9, -12, -22, -20, -28
giBDb5 ftgen 0, 0, -5, -2, -20, -18, -28, -40, -36

giBBW1 ftgen 0, 0, -5, -2,  60,  40,  60,  40,  40
giBBW2 ftgen 0, 0, -5, -2,  70,  80,  90,  80,  80
giBBW3 ftgen 0, 0, -5, -2, 110, 100, 100, 100, 100
giBBW4 ftgen 0, 0, -5, -2, 120, 120, 120, 120, 120
giBBW5 ftgen 0, 0, -5, -2, 130, 120, 120, 120, 120

;TENOR
giTF1 ftgen 0, 0, -5, -2,  650,  400,  290,  400,  350
giTF2 ftgen 0, 0, -5, -2, 1080, 1700, 1870,  800,  600
giTF3 ftgen 0, 0, -5, -2, 2650, 2600, 2800, 2600, 2700
giTF4 ftgen 0, 0, -5, -2, 2900, 3200, 3250, 2800, 2900
giTF5 ftgen 0, 0, -5, -2, 3250, 3580, 3540, 3000, 3300

giTDb1 ftgen 0, 0, -5, -2,   0,   0,   0,   0,   0
giTDb2 ftgen 0, 0, -5, -2,  -6, -14, -15, -10, -20
giTDb3 ftgen 0, 0, -5, -2,  -7, -12, -18, -12, -17
giTDb4 ftgen 0, 0, -5, -2,  -8, -14, -20, -12, -14
giTDb5 ftgen 0, 0, -5, -2, -22, -20, -30, -26, -26

giTBW1 ftgen 0, 0, -5, -2,  80,  70,  40,  40,  40
giTBW2 ftgen 0, 0, -5, -2,  90,  80,  90,  80,  60
giTBW3 ftgen 0, 0, -5, -2, 120, 100, 100, 100, 100
giTBW4 ftgen 0, 0, -5, -2, 130, 120, 120, 120, 120
giTBW5 ftgen 0, 0, -5, -2, 140, 120, 120, 120, 120


;ALTO
giAF1 ftgen 0, 0, -5, -2,  800,  400,  350,  450,  325
giAF2 ftgen 0, 0, -5, -2, 1150, 1600, 1700,  800,  700
giAF3 ftgen 0, 0, -5, -2, 2800, 2700, 2700, 2830, 2530
giAF4 ftgen 0, 0, -5, -2, 3500, 3300, 3700, 3500, 2500
giAF5 ftgen 0, 0, -5, -2, 4950, 4950, 4950, 4950, 4950

giADb1 ftgen 0, 0, -5, -2,   0,   0,   0,   0,   0
giADb2 ftgen 0, 0, -5, -2,  -4, -24, -20,  -9, -12
giADb3 ftgen 0, 0, -5, -2, -20, -30, -30, -16, -30
giADb4 ftgen 0, 0, -5, -2, -36, -35, -36, -28, -40
giADb5 ftgen 0, 0, -5, -2, -60, -60, -60, -55, -64

giABW1 ftgen 0, 0, -5, -2, 50,   60,  50,  70,  50
giABW2 ftgen 0, 0, -5, -2, 60,   80, 100,  80,  60
giABW3 ftgen 0, 0, -5, -2, 170, 120, 120, 100, 170
giABW4 ftgen 0, 0, -5, -2, 180, 150, 150, 130, 180
giABW5 ftgen 0, 0, -5, -2, 200, 200, 200, 135, 200

;SOPRANO
giSF1 ftgen 0, 0, -5, -2,  800,  350,  270,  450,  325
giSF2 ftgen 0, 0, -5, -2, 1150, 2000, 2140,  800,  700
giSF3 ftgen 0, 0, -5, -2, 2900, 2800, 2950, 2830, 2700
giSF4 ftgen 0, 0, -5, -2, 3900, 3600, 3900, 3800, 3800
giSF5 ftgen 0, 0, -5, -2, 4950, 4950, 4950, 4950, 4950

giSDb1 ftgen 0, 0, -5, -2,   0,   0,   0,   0,   0
giSDb2 ftgen 0, 0, -5, -2,  -6, -20, -12, -11, -16
giSDb3 ftgen 0, 0, -5, -2, -32, -15, -26, -22, -35
giSDb4 ftgen 0, 0, -5, -2, -20, -40, -26, -22, -40
giSDb5 ftgen 0, 0, -5, -2, -50, -56, -44, -50, -60

giSBW1 ftgen 0, 0, -5, -2,  80,  60,  60,  70,  50
giSBW2 ftgen 0, 0, -5, -2,  90,  90,  90,  80,  60
giSBW3 ftgen 0, 0, -5, -2, 120, 100, 100, 100, 170
giSBW4 ftgen 0, 0, -5, -2, 130, 150, 120, 130, 180
giSBW5 ftgen 0, 0, -5, -2, 140, 200, 120, 135, 200

  // Soundfile attribution  Myron C Baker, CC BY-SA 4.0 <https://creativecommons.org/licenses/by-sa/4.0>, via Wikimedia Commons
giSoundFile   ftgen   0, 0, 0, 1, "./australian-bird.wav", 0, 0, 0


instr 1 // synth-choir
  iStartFund cpsmidi
  iGlide = 0
  iGlideTime = 1
  iEndFund = iStartFund + iGlide

  kFund    expon     iStartFund,iGlideTime,iEndFund

iStartVow = 0.5
iVowTime = 0.8  
  iEndVow = 0.8

  kVow     line      iStartVow,iVowTime,iEndVow               ; vowel select

  iStartBand = 2
  iBandTime = 0.5
  iEndBand = 2
  
  kBW      line      iStartBand,iBandTime,iEndBand               ; bandwidth factor
  
  if (iStartFund < 170) then
    ; if low pitch then bass
    iVoice = 0
  elseif (iStartFund < 265) then
      ; if higher pitch then tenor
    iVoice = 1
  elseif (iStartFund < 330) then
          ; etc...
    iVoice = 2
  elseif (iStartFund < 440) then
    iVoice = 3
  endif
   
    
;  iVoice   =         p10                    ; voice select

    iStartSource = 0.2
  iSourceTime = 0.5
  iEndSource = 0.2
  
  kSrc     line      iStartSource,iSourceTime,iEndSource             ; source mix

  aNoise   pinkish   3                      ; pink noise
  aVCO     vco2      1.2,kFund,2,0.02       ; pulse tone
  aInput   ntrpol    aVCO,aNoise,kSrc       ; input mix

  ; read formant cutoff frequenies from tables
  kCF1     tablei    kVow*5,giBF1+(iVoice*15)
  kCF2     tablei    kVow*5,giBF1+(iVoice*15)+1
  kCF3     tablei    kVow*5,giBF1+(iVoice*15)+2
  kCF4     tablei    kVow*5,giBF1+(iVoice*15)+3
  kCF5     tablei    kVow*5,giBF1+(iVoice*15)+4
  ; read formant intensity values from tables
  kDB1     tablei    kVow*5,giBF1+(iVoice*15)+5
  kDB2     tablei    kVow*5,giBF1+(iVoice*15)+6
  kDB3     tablei    kVow*5,giBF1+(iVoice*15)+7
  kDB4     tablei    kVow*5,giBF1+(iVoice*15)+8
  kDB5     tablei    kVow*5,giBF1+(iVoice*15)+9
  ; read formant bandwidths from tables
  kBW1     tablei    kVow*5,giBF1+(iVoice*15)+10
  kBW2     tablei    kVow*5,giBF1+(iVoice*15)+11
  kBW3     tablei    kVow*5,giBF1+(iVoice*15)+12
  kBW4     tablei    kVow*5,giBF1+(iVoice*15)+13
  kBW5     tablei    kVow*5,giBF1+(iVoice*15)+14
  ; create resonant formants byt filtering source sound
  aForm1   reson     aInput, kCF1, kBW1*kBW, 1     ; formant 1
  aForm2   reson     aInput, kCF2, kBW2*kBW, 1     ; formant 2
  aForm3   reson     aInput, kCF3, kBW3*kBW, 1     ; formant 3
  aForm4   reson     aInput, kCF4, kBW4*kBW, 1     ; formant 4
  aForm5   reson     aInput, kCF5, kBW5*kBW, 1     ; formant 5

  ; formants are mixed and multiplied both by intensity values derived
  ; from tables and by the on-screen gain controls for each formant
  aMix     sum     aForm1*ampdbfs(kDB1), aForm2*ampdbfs(kDB2),
  aForm3*ampdbfs(kDB3), aForm4*ampdbfs(kDB4), aForm5*ampdbfs(kDB5)
  iAmp ampmidi 1
  kEnv linsegr 0,0.1,1,0.5,0     ; an amplitude envelope
  outs aMix*kEnv*iAmp, aMix*kEnv*iAmp ; send audio to outputs
endin

instr 2 // bird sound
  // Soundfile attribution  Myron C Baker, CC BY-SA 4.0 <https://creativecommons.org/licenses/by-sa/4.0>, via Wikimedia Commons
// MONO FILE
  iAmp ampmidi 1   ; amplitude
  iLoopEnd = nsamp(giSoundFile)/sr; loop end (end of file)
  aSig flooper2 iAmp,1,0,iLoopEnd,0,giSoundFile
  outs aSig, aSig
endin

instr 3 // flute sound
  iAmp ampmidi 1
  iFreq cpsmidi
  ares STKFlute iFreq, iAmp

  kEnv madsr 0.5,0.5,0.5,0.1 

  outs ares*kEnv, ares*kEnv
  // todo? add resonance/formants
endin

instr 4 // string sound
  iAmp ampmidi 1
  iFreq cpsmidi
  ares vco2 iAmp, iFreq, 12 // base sawtooth (imode=12)
  kVib lfo iAmp, 4 // Vibrato
  kEnv madsr    0.25,0.25,0.5,0.1 // more agressive envelope

  outs ares*kVib*kEnv, ares*kVib*kEnv
  // todo? add resonance/formants
endin

instr 5 // horizontal sounding percussion noises (snare resonance) / filtered noise
  // get p4 from the score line as amplitude
  iAmp ampmidi 1
  iFreq cpsmidi
  aSig noise iAmp,0.5
  aSig reson aSig,iFreq,iFreq*0.1 ; filter audio signal
  kEnv madsr 0.5,0.5,0.5,0.1
  outs aSig*kEnv, aSig*kEnv
endin



instr 6
  iAmp ampmidi 1
  iFreq cpsmidi
  aSig noise iAmp,0.5
  aSig reson aSig,iFreq,iFreq*0.1 ; filter audio signal
  kEnv madsr 0.05,0.05,0.25,0.1 
  outs aSig*kEnv, aSig*kEnv
endin

instr 7 // horizontal sounding percussion noises (snare resonance) / filtered noise
  // get p4 from the score line as amplitude
  iAmp ampmidi 1
  iFreq cpsmidi
  aSig noise iAmp,0.5
  aSig reson aSig,iFreq,iFreq*0.1 ; filter audio signal
  kEnv madsr 0.5,0.5,0.5,0.1 
  outs aSig*kEnv, aSig*kEnv
endin

instr 1000
  Sfile = p4
  p3 = filelen(Sfile)
  a1, a2 diskin2 Sfile, 1;$TEMPO
;  outs a1, a2
endin

</CsInstruments>
<CsScore>
i 1000 0 1 "./speech-scaled.mp3" 

</CsScore>
</CsoundSynthesizer>
