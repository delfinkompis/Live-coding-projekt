\version "2.24.4"
\include "./on-color.ily"
%\include "~/Projektfiler/Stylesheets/variabler.scm"
%\include "./my-repl-defuns.scm"

lower = \fixed c {

 r2 
\set Staff.midiInstrument = "Rock Organ"
<>^\markup {\override #'(font-name .
               "freemono") "to" }  e8(\portato e8)\portato 
\set Staff.midiInstrument = "Bright Acoustic Piano"
<>-\markup \fontsize #-1 {\override #'(font-name .
               "Andika") tre}
 r2. 
\set Staff.midiInstrument = "Bright Acoustic Piano"
<>-\markup \fontsize #-1 {\override #'(font-name .
               "Andika") fire}
 r1 

\set Staff.midiInstrument = "Bright Acoustic Piano"
<>-\markup \fontsize #-1 {\override #'(font-name .
               "Andika") hold}
 r1 
\set Staff.midiInstrument = "Bright Acoustic Piano"
<>-\markup \fontsize #-1 {\override #'(font-name .
               "Andika") inne}
 r1 
\set Staff.midiInstrument = "Bright Acoustic Piano"
<>-\markup \fontsize #-1 {\override #'(font-name .
               "Andika") knappen}
 r1.. 
\set Staff.midiInstrument = "Bright Acoustic Piano"
<>-\markup \fontsize #-1 {\override #'(font-name .
               "Andika") hallo}
 \tuplet 1/5 { r4*1/5 }  r4 
\set Staff.midiInstrument = "Bright Acoustic Piano"
<>-\markup \fontsize #-1 {\override #'(font-name .
               "Andika") luka}
 r1 
 r1 
\set Staff.midiInstrument = "Bright Acoustic Piano"
<>-\markup \fontsize #-1 {\override #'(font-name .
               "Andika") inne}
 r1 
\set Staff.midiInstrument = "Bright Acoustic Piano"
<>-\markup \fontsize #-1 {\override #'(font-name .
               "Andika") knappen}
 r1.. 
\set Staff.midiInstrument = "Bright Acoustic Piano"
<>-\markup \fontsize #-1 {\override #'(font-name .
               "Andika") hallo}
 \tuplet 1/5 { r4*1/5 }  r4 
\set Staff.midiInstrument = "Bright Acoustic Piano"
<>-\markup \fontsize #-1 {\override #'(font-name .
               "Andika") luka}
 r1 
 r1  r1 
\set Staff.midiInstrument = "Bright Acoustic Piano"
<>-\markup \fontsize #-1 {\override #'(font-name .
               "Andika") knappen}
 r1.. 
\set Staff.midiInstrument = "Bright Acoustic Piano"
<>-\markup \fontsize #-1 {\override #'(font-name .
               "Andika") hallo}
 \tuplet 1/5 { r4*1/5 }  r4 
\set Staff.midiInstrument = "Bright Acoustic Piano"
<>-\markup \fontsize #-1 {\override #'(font-name .
               "Andika") luka}
 r1 
}
