\version "2.24.4"
\include "./on-color.ily"
%\include "~/Projektfiler/Stylesheets/variabler.scm"
%\include "./my-repl-defuns.scm"

lower = \fixed c {

 r2 
\set Staff.midiInstrument = "Bright Acoustic Piano"
<>-\markup \fontsize #-1 {\override #'(font-name .
               "Andika") vekk}
 r1  r1. 
\set Staff.midiInstrument = "Bright Acoustic Piano"
<>-\markup \fontsize #-1 {\override #'(font-name .
               "Andika") inputfile}
 \tuplet 1/9 { r4*1/9 }  r2.  r2 
\set Staff.midiInstrument = "Bright Acoustic Piano"
<>-\markup \fontsize #-1 {\override #'(font-name .
               "Andika") skjører}
 r1.. 
\set Staff.midiInstrument = "Bright Acoustic Piano"
<>-\markup \fontsize #-1 {\override #'(font-name .
               "Andika") kommande,}
 \tuplet 1/9 { r4*1/9 }  r2.  r2.  r2 
\set Staff.midiInstrument = "Bright Acoustic Piano"
<>-\markup \fontsize #-1 {\override #'(font-name .
               "Andika") ta...}
 \tuplet 1/5 { r4*1/5 } 
}
