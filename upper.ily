\version "2.24.4"
\include "./on-color.ily"
%\include "~/Projektfiler/Stylesheets/variabler.scm"
%\include "./my-repl-defuns.scm"

upper = \fixed c {

<>^\markup {\override #'(font-name .
               "freemono") "ta" } 
\set Staff.midiInstrument = "Drawbar Organ"
 cis'''4(\flageolet f'''8\flageolet g'''4)\flageolet  r1 
\set Staff.midiInstrument = "Percussive Organ"
<>^\markup {\override #'(font-name .
               "freemono") "første" }  < f' gis' c'' >4(\staccato < e' gis' cis'' >4\staccato < e' gis' b' >2\staccato < ees' g' b' >2)\staccato  \tuplet 1/9 { r4*1/9 } 
\set Staff.midiInstrument = "Percussive Organ"
<>^\markup {\override #'(font-name .
               "freemono") "før" }  < ees' gis' c'' >4(\staccato < e' g' c'' >4\staccato < f' a' c'' >2)\staccato 
\set Staff.midiInstrument = "Percussive Organ"
<>^\markup {\override #'(font-name .
               "freemono") "du" }  < ees' fis' c'' >8(\staccato < e' g' c'' >8\staccato < e' g' cis'' >4)\staccato  r1..  \tuplet 1/9 { r4*1/9 } 
\set Staff.midiInstrument = "Percussive Organ"
<>^\markup {\override #'(font-name .
               "freemono") "for" }  < e' a' c'' >8(\staccato < fis' a' d'' >2\staccato < f' bes' d'' >2)\staccato 
\set Staff.midiInstrument = "Percussive Organ"
<>^\markup {\override #'(font-name .
               "freemono") "det" }  < e' gis' c'' >8(\staccato < ees' fis' c'' >4\staccato < e' a' c'' >8\staccato < e' g' cis'' >2)\staccato 
\set Staff.midiInstrument = "Electric Piano 2"
<>_\markup \smallCaps \fontsize #4 {må}\magnifyMusic #6/7 e''8\tenuto( \tuplet 3/2 { cis''8*3/2 } c''8\tenuto cis''8\tenuto bes'8\tenuto)  \tuplet 1/5 { r4*1/5 } 
}
