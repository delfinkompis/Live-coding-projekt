\version "2.24.4"
\include "./on-color.ily"
%\include "~/Projektfiler/Stylesheets/variabler.scm"
%\include "./my-repl-defuns.scm"

upper = \fixed c {


\set Staff.midiInstrument = "Percussive Organ"
<>^\markup {\override #'(font-name .
               "freemono") "en" }  < ees' fis' c'' >8(\staccato < ees' fis' bes' >4\staccato < d' fis' b' >4)\staccato  r2  r2.  r1 
 r1  r1  r1..  \tuplet 1/5 { r4*1/5 } 
\set Staff.midiInstrument = "Percussive Organ"
<>^\markup {\override #'(font-name .
               "freemono") "i" }  < f' gis' c'' >2\staccato  r1 

\set Staff.midiInstrument = "Percussive Organ"
<>^\markup {\override #'(font-name .
               "freemono") "hold" }  < e' gis' c'' >2(\staccato < ees' gis' b' >8\staccato < e' g' b' >8\staccato < d' f' b' >4)\staccato  r1  r1..  \tuplet 1/5 { r4*1/5 } 
\set Staff.midiInstrument = "Percussive Organ"
<>^\markup {\override #'(font-name .
               "freemono") "i" }  < e' a' c'' >8(\staccato < ees' fis' c'' >2)\staccato  r1 

\set Staff.midiInstrument = "Percussive Organ"
<>^\markup {\override #'(font-name .
               "freemono") "hold" } 
  < f' a' c'' >8(\staccato < f' gis' c'' >8\staccato < e' g' c'' >8\staccato < e' gis' cis'' >8\staccato < e' gis' c'' >8\staccato < e' g' cis'' >8\staccato < fis' a' cis'' >2)\staccato

\set Staff.midiInstrument = "Clav"
<>^\markup \fontsize #1 { 
	   	     \override #'(font-name .
               "Latin modern sans demi cond") inne }\magnifyMusic #11/10
 r4 {
  ees''16\tenuto gis''16\tenuto fis''32\tenuto g''32\tenuto c''32\tenuto ees''32\tenuto f''16\tenuto
}
 r4  r1..  \tuplet 1/5 { r4*1/5 } 
\set Staff.midiInstrument = "Percussive Organ"
<>^\markup {\override #'(font-name .
               "freemono") "i" }  < e' a' c'' >2\staccato  r1 
}
