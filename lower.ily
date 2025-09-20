\version "2.24.4"
\include "./on-color.ily"
%\include "~/Projektfiler/Stylesheets/variabler.scm"
%\include "./my-repl-defuns.scm"

lower = \fixed c {

 r2  r2.  r2 
\set Staff.midiInstrument = "Harpsichord"
<>_\markup \fontsize #3 {
	      \override #'(font-name .
               "Courier") år}\magnifyMusic #7/5
{ < e e' >1 }

\set Staff.midiInstrument = "Harpsichord"
<>_\markup \fontsize #3 {
	      \override #'(font-name .
               "Courier") bak}\magnifyMusic #7/5
{ < g, g >2 < e e' >2 }

\set Staff.midiInstrument = "Xylophone"
\override NoteHead.color = #darkyellow
	   \override Stem.color = #darkyellow
	   \override Beam.color = #darkyellow
<>_\markup \fontsize #-2 \with-color #darkyellow {\override #'(font-name .
               "Linux Biolinum Keyboard O") oss} \tuplet 2/3 { < f a' >4 } \tuplet 2/3 { < a, cis' >4 } \tuplet 2/3 { < ees g' >4 } \tuplet 2/3 { < bes, d' >4 } \tuplet 2/3 { < bes, d' >4 } \revert NoteHead.color
	   \revert Stem.color
	   \revert Beam.color
\set Staff.midiInstrument = "Bright Acoustic Piano"
<>-\markup \fontsize #5 {\override #'(font-name .
               "Andika") –}
 r4  r4 
\set Staff.midiInstrument = "Bright Acoustic Piano"
<>-\markup \fontsize #5 {\override #'(font-name .
               "Andika") forventing}
 \tuplet 5/1 { r2 }  r2  r2.  r2.  r2.  r2. 
\set Staff.midiInstrument = "Bright Acoustic Piano"
<>-\markup \fontsize #5 {\override #'(font-name .
               "Andika") bringe.}
 r1..  r2.  \tuplet 5/1 { r4 }  r2.  r1.. 
\set Staff.midiInstrument = "Bright Acoustic Piano"
<>-\markup \fontsize #5 {\override #'(font-name .
               "Andika") 2024}
 r1 
\set Staff.midiInstrument = "Tubular Bells"
<>-\markup \fontsize #-4 \with-color #darkgreen \box \column {
  \override #'(font-name .
               "D050000L")
   \line {vært}
  \override #'(font-name .
               "Comic Sans")
   \line {vært}
  \override #'(font-name .
               "D050000L")
   \line { vært }
}\override NoteHead.color = #darkgreen
\override Stem.color = #darkgreen
\override Beam.color = #darkgreen
\xNotesOn g'4\marcato( g'2\marcato c'4\marcato g'4\marcato) \xNotesOff\revert NoteHead.color
   \revert Stem.color
   \revert Beam.color r2 
\set Staff.midiInstrument = "Harpsichord"
<>_\markup \fontsize #3 {
	      \override #'(font-name .
               "Courier") år}\magnifyMusic #7/5
{ < cis cis' >2. }
 r2  r2. 
\set Staff.midiInstrument = "Bright Acoustic Piano"
<>-\markup \fontsize #5 {\override #'(font-name .
               "Andika") jevne.}
 r1.  r2. 
\set Staff.midiInstrument = "Rock Organ"
<>^\markup {\override #'(font-name .
               "freemono") "noen" }  c4(\portato c4)\portato  r2 
\set Staff.midiInstrument = "Harpsichord"
<>_\markup \fontsize #3 {
	      \override #'(font-name .
               "Courier") år}\magnifyMusic #7/5
{ < a, a >2 < g, g >2. }

\set Staff.midiInstrument = "Harpsichord"
<>_\markup \fontsize #3 {
	      \override #'(font-name .
               "Courier") da}\magnifyMusic #7/5
{ < c, c >1 }
 \tuplet 5/1 { r4 }  r1  r2 
\set Staff.midiInstrument = "Bright Acoustic Piano"
<>-\markup \fontsize #5 {\override #'(font-name .
               "Andika") positiv}
 r1.. 
\set Staff.midiInstrument = "Bright Acoustic Piano"
<>-\markup \fontsize #5 {\override #'(font-name .
               "Andika") vending.}
 \tuplet 2/1 { r1 }  r2. 
\set Staff.midiInstrument = "Rock Organ"
<>^\markup {\override #'(font-name .
               "freemono") "andre" }  \tuplet 5/1 { e16 } \tuplet 5/1 { e16 }  \tuplet 5/1 { r4 } 
\set Staff.midiInstrument = "Bright Acoustic Piano"
<>-\markup \fontsize #5 {\override #'(font-name .
               "Andika") –}
 r4 
\set Staff.midiInstrument = "Harpsichord"
<>_\markup \fontsize #3 {
	      \override #'(font-name .
               "Courier") året}\magnifyMusic #7/5
{ < cis cis' >1 < a, a >2 }

\set Staff.midiInstrument = "Harpsichord"
<>_\markup \fontsize #3 {
	      \override #'(font-name .
               "Courier") da}\magnifyMusic #7/5
{ < c, c >2. }
 r2. 
\set Staff.midiInstrument = "Bright Acoustic Piano"
<>-\markup \fontsize #5 {\override #'(font-name .
               "Andika") raste.}
 r1.  r2. 
\set Staff.midiInstrument = "Xylophone"
\override NoteHead.color = #darkyellow
	   \override Stem.color = #darkyellow
	   \override Beam.color = #darkyellow
<>_\markup \fontsize #-2 \with-color #darkyellow {\override #'(font-name .
               "Linux Biolinum Keyboard O") oss} < c e' >4 \tuplet 2/3 { < cis eis' >8 } \tuplet 2/3 { < a, cis' >4 } \tuplet 2/3 { < cis eis' >8 } < bes, d' >4 \revert NoteHead.color
	   \revert Stem.color
	   \revert Beam.color r4 
\set Staff.midiInstrument = "Bright Acoustic Piano"
<>-\markup \fontsize #5 {\override #'(font-name .
               "Andika") familien}
 \tuplet 2/1 { r1 }  r2.  \tuplet 5/1 { r4 } 
\set Staff.midiInstrument = "Tubular Bells"
<>-\markup \fontsize #-4 \with-color #darkgreen \box \column {
  \override #'(font-name .
               "D050000L")
   \line {vært}
  \override #'(font-name .
               "Comic Sans")
   \line {vært}
  \override #'(font-name .
               "D050000L")
   \line { vært }
}\override NoteHead.color = #darkgreen
\override Stem.color = #darkgreen
\override Beam.color = #darkgreen
\xNotesOn bes'4\marcato( bes'4\marcato a'4\marcato c'2\marcato) \xNotesOff\revert NoteHead.color
   \revert Stem.color
   \revert Beam.color r2 
\set Staff.midiInstrument = "Harpsichord"
<>_\markup \fontsize #3 {
	      \override #'(font-name .
               "Courier") år}\magnifyMusic #7/5
{ < c, c >1 }

\set Staff.midiInstrument = "Harpsichord"
<>_\markup \fontsize #3 {
	      \override #'(font-name .
               "Courier") da}\magnifyMusic #7/5
{ < g, g >2. }

\set Staff.midiInstrument = "Bright Acoustic Piano"
<>-\markup \fontsize #5 {\override #'(font-name .
               "Andika") vi}
 r2 
\set Staff.midiInstrument = "Bright Acoustic Piano"
<>-\markup \fontsize #5 {\override #'(font-name .
               "Andika") virkelig}
 \tuplet 2/1 { r1 }  r2.  r1  r2 
\set Staff.midiInstrument = "Bright Acoustic Piano"
<>-\markup \fontsize #5 {\override #'(font-name .
               "Andika") prøve.}
 r1.  r2 
\set Staff.midiInstrument = "Harpsichord"
<>_\markup \fontsize #3 {
	      \override #'(font-name .
               "Courier") år}\magnifyMusic #7/5
{ < cis cis' >2 < g, g >2 }

\set Staff.midiInstrument = "Harpsichord"
<>_\markup \fontsize #3 {
	      \override #'(font-name .
               "Courier") da}\magnifyMusic #7/5
{ < e e' >2 < g, g >1 }

\set Staff.midiInstrument = "Bright Acoustic Piano"
<>-\markup \fontsize #5 {\override #'(font-name .
               "Andika") vi}
 r2  r2. 
\set Staff.midiInstrument = "Bright Acoustic Piano"
<>-\markup \fontsize #5 {\override #'(font-name .
               "Andika") blitt}
 \tuplet 5/1 { r4 }  r1  r2. 
\set Staff.midiInstrument = "Bright Acoustic Piano"
<>-\markup \fontsize #5 {\override #'(font-name .
               "Andika") bevisst}
 r1..  r2  r2.  r2. 
\set Staff.midiInstrument = "Bright Acoustic Piano"
<>-\markup \fontsize #5 {\override #'(font-name .
               "Andika") betyr}
 \tuplet 5/1 { r4 }  r2.  r2.  r4 
\set Staff.midiInstrument = "Bright Acoustic Piano"
<>-\markup \fontsize #5 {\override #'(font-name .
               "Andika") livet.}
 r1.  r4 
\set Staff.midiInstrument = "Bright Acoustic Piano"
<>-\markup \fontsize #5 {\override #'(font-name .
               "Andika") kjernen}
 r1..  r2  r2.  r4 
\set Staff.midiInstrument = "Tubular Bells"
<>-\markup \fontsize #-4 \with-color #darkgreen \box \column {
  \override #'(font-name .
               "D050000L")
   \line {være}
  \override #'(font-name .
               "Comic Sans")
   \line {være}
  \override #'(font-name .
               "D050000L")
   \line { være }
}\override NoteHead.color = #darkgreen
\override Stem.color = #darkgreen
\override Beam.color = #darkgreen
\xNotesOn bes'8\marcato( e'8\marcato c''2\marcato bes'2\marcato) \xNotesOff\revert NoteHead.color
   \revert Stem.color
   \revert Beam.color
\set Staff.midiInstrument = "Xylophone"
\override NoteHead.color = #darkyellow
	   \override Stem.color = #darkyellow
	   \override Beam.color = #darkyellow
<>_\markup \fontsize #-2 \with-color #darkyellow {\override #'(font-name .
               "Linux Biolinum Keyboard O") menneske}
  < bes, d' >4 \tuplet 2/3 { < cis eis' >8 } \tuplet 2/3 { < b dis'' >4 } \tuplet 2/3 { < bes, d' >8 } < c' e'' >4 \tuplet 2/3 { < cis eis' >8 } \tuplet 2/3 { < cis eis' >8 } \tuplet 2/3 { < a, cis' >4 } < c' e'' >4 \tuplet 2/3 { < f a' >4 } \tuplet 2/3 { < c' e'' >8 } \tuplet 2/3 { < c e' >4 } \tuplet 2/3 { < f a' >8 } \tuplet 2/3 { < f a' >8 } \tuplet 2/3 { < a, cis' >4 }
\revert NoteHead.color
	   \revert Stem.color
	   \revert Beam.color r1.  r2. 
\set Staff.midiInstrument = "Bright Acoustic Piano"
<>-\markup \fontsize #5 {\override #'(font-name .
               "Andika") at}
 r2  \tuplet 5/1 { r4 }  r2 
\set Staff.midiInstrument = "Xylophone"
\override NoteHead.color = #darkyellow
	   \override Stem.color = #darkyellow
	   \override Beam.color = #darkyellow
<>_\markup \fontsize #-2 \with-color #darkyellow {\override #'(font-name .
               "Linux Biolinum Keyboard O") oss} < cis eis' >4 < a, cis' >4 \tuplet 2/3 { < bes, d' >8 } \tuplet 2/3 { < c' e'' >8 } \tuplet 2/3 { < f a' >8 } \tuplet 2/3 { < b dis'' >4 } \revert NoteHead.color
	   \revert Stem.color
	   \revert Beam.color r2  \tuplet 5/1 { r4 }  r2. 
\set Staff.midiInstrument = "Bright Acoustic Piano"
<>-\markup \fontsize #5 {\override #'(font-name .
               "Andika") smerte}
 r1.  r2 
\set Staff.midiInstrument = "Bright Acoustic Piano"
<>-\markup \fontsize #5 {\override #'(font-name .
               "Andika") motgang.}
 \tuplet 2/1 { r1 } 
\set Staff.midiInstrument = "Rock Organ"
<>^\markup {\override #'(font-name .
               "freemono") "noen" }  d4(\portato d4)\portato 
\set Staff.midiInstrument = "Bright Acoustic Piano"
<>-\markup \fontsize #5 {\override #'(font-name .
               "Andika") rammes}
 r1.  r1..  r2. 
\set Staff.midiInstrument = "Bright Acoustic Piano"
<>-\markup \fontsize #5 {\override #'(font-name .
               "Andika") andre.}
 r1. 
\set Staff.midiInstrument = "Bright Acoustic Piano"
<>-\markup \fontsize #5 {\override #'(font-name .
               "Andika") men}
 r2. 
\set Staff.midiInstrument = "Bright Acoustic Piano"
<>-\markup \fontsize #5 {\override #'(font-name .
               "Andika") dessverre}
 \tuplet 9/1 { r4 }  r1.. 
\set Staff.midiInstrument = "Bright Acoustic Piano"
<>-\markup \fontsize #5 {\override #'(font-name .
               "Andika") ingen}
 \tuplet 5/1 { r4 } 
\set Staff.midiInstrument = "Bright Acoustic Piano"
<>-\markup \fontsize #5 {\override #'(font-name .
               "Andika") unna}
 r1  r4 
\set Staff.midiInstrument = "Bright Acoustic Piano"
<>-\markup \fontsize #5 {\override #'(font-name .
               "Andika") oppleve}
 r1.. 
\set Staff.midiInstrument = "Bright Acoustic Piano"
<>-\markup \fontsize #5 {\override #'(font-name .
               "Andika") vonde}
 \tuplet 5/1 { r4 }  r1  r4 
\set Staff.midiInstrument = "Bright Acoustic Piano"
<>-\markup \fontsize #5 {\override #'(font-name .
               "Andika") livet.}
 r1.  r1  r2  r2  r2 
\set Staff.midiInstrument = "Xylophone"
\override NoteHead.color = #darkyellow
	   \override Stem.color = #darkyellow
	   \override Beam.color = #darkyellow
<>_\markup \fontsize #-2 \with-color #darkyellow {\override #'(font-name .
               "Linux Biolinum Keyboard O") oss} \tuplet 2/3 { < a, cis' >4 } \tuplet 2/3 { < f a' >4 } \tuplet 2/3 { < a, cis' >4 } < f a' >4 \tuplet 2/3 { < ees g' >8 } \revert NoteHead.color
	   \revert Stem.color
	   \revert Beam.color r2 
\set Staff.midiInstrument = "Bright Acoustic Piano"
<>-\markup \fontsize #5 {\override #'(font-name .
               "Andika") nødt}
 r1  r2.  r4  \tuplet 5/1 { r4 } 
\set Staff.midiInstrument = "Bright Acoustic Piano"
<>-\markup \fontsize #5 {\override #'(font-name .
               "Andika") måter}
 \tuplet 5/1 { r4 }  r4  r2.  r4  r2. 
\set Staff.midiInstrument = "Bright Acoustic Piano"
<>-\markup \fontsize #5 {\override #'(font-name .
               "Andika") på,}
 r2.  r2 
\set Staff.midiInstrument = "Bright Acoustic Piano"
<>-\markup \fontsize #5 {\override #'(font-name .
               "Andika") prøve}
 \tuplet 5/1 { r4 }  r4  \tuplet 5/1 { r4 } 
\set Staff.midiInstrument = "Xylophone"
\override NoteHead.color = #darkyellow
	   \override Stem.color = #darkyellow
	   \override Beam.color = #darkyellow
<>_\markup \fontsize #-2 \with-color #darkyellow {\override #'(font-name .
               "Linux Biolinum Keyboard O") oss} \tuplet 2/3 { < cis eis' >4 } \tuplet 2/3 { < b dis'' >4 } < cis eis' >4 < c e' >4 \revert NoteHead.color
	   \revert Stem.color
	   \revert Beam.color
\set Staff.midiInstrument = "Bright Acoustic Piano"
<>-\markup \fontsize #5 {\override #'(font-name .
               "Andika") gjennom.}
 \tuplet 2/1 { r1 } 
\set Staff.midiInstrument = "Bright Acoustic Piano"
<>-\markup \fontsize #5 {\override #'(font-name .
               "Andika") vi}
 r2  r1.. 
\set Staff.midiInstrument = "Rock Organ"
<>^\markup {\override #'(font-name .
               "freemono") "noen" }  c4(\portato c4)\portato 
\set Staff.midiInstrument = "Bright Acoustic Piano"
<>-\markup \fontsize #5 {\override #'(font-name .
               "Andika") skuffer}
 r1.. 
\set Staff.midiInstrument = "Bright Acoustic Piano"
<>-\markup \fontsize #5 {\override #'(font-name .
               "Andika") inni}
 r1 
\set Staff.midiInstrument = "Xylophone"
\override NoteHead.color = #darkyellow
	   \override Stem.color = #darkyellow
	   \override Beam.color = #darkyellow
<>_\markup \fontsize #-2 \with-color #darkyellow {\override #'(font-name .
               "Linux Biolinum Keyboard O") oss} < ees g' >4 < bes, d' >4 \tuplet 2/3 { < bes, d' >8 } \tuplet 2/3 { < f a' >4 } \tuplet 2/3 { < bes, d' >4 } \revert NoteHead.color
	   \revert Stem.color
	   \revert Beam.color r2.  r4 
\set Staff.midiInstrument = "Bright Acoustic Piano"
<>-\markup \fontsize #5 {\override #'(font-name .
               "Andika") sortere}
 r1..  r4 
\set Staff.midiInstrument = "Bright Acoustic Piano"
<>-\markup \fontsize #5 {\override #'(font-name .
               "Andika") følelser}
 \tuplet 2/1 { r1 }  r2 
\set Staff.midiInstrument = "Bright Acoustic Piano"
<>-\markup \fontsize #5 {\override #'(font-name .
               "Andika") plassere}
 \tuplet 2/1 { r1 } 
\set Staff.midiInstrument = "Bright Acoustic Piano"
<>-\markup \fontsize #5 {\override #'(font-name .
               "Andika") ansvar}
 r1.  r2.  r2.  \tuplet 5/1 { r4 } 
\set Staff.midiInstrument = "Bright Acoustic Piano"
<>-\markup \fontsize #5 {\override #'(font-name .
               "Andika") hjemme.}
 r1.. 
\set Staff.midiInstrument = "Bright Acoustic Piano"
<>-\markup \fontsize #5 {\override #'(font-name .
               "Andika") vi}
 r2 
\set Staff.midiInstrument = "Bright Acoustic Piano"
<>-\markup \fontsize #5 {\override #'(font-name .
               "Andika") trenger}
 r1.. 
\set Staff.midiInstrument = "Bright Acoustic Piano"
<>-\markup \fontsize #5 {\override #'(font-name .
               "Andika") også}
 r1 
\set Staff.midiInstrument = "Bright Acoustic Piano"
<>-\markup \fontsize #5 {\override #'(font-name .
               "Andika") skuffer}
 r1..  r2.  r2.  r2.  r2. 
\set Staff.midiInstrument = "Xylophone"
\override NoteHead.color = #darkyellow
	   \override Stem.color = #darkyellow
	   \override Beam.color = #darkyellow
<>_\markup \fontsize #-2 \with-color #darkyellow {\override #'(font-name .
               "Linux Biolinum Keyboard O") oss} < b dis'' >4 \tuplet 2/3 { < c e' >4 } < ees g' >4 < bes, d' >4 \revert NoteHead.color
	   \revert Stem.color
	   \revert Beam.color
\set Staff.midiInstrument = "Bright Acoustic Piano"
<>-\markup \fontsize #5 {\override #'(font-name .
               "Andika") styrke,}
 r1.. 
\set Staff.midiInstrument = "Bright Acoustic Piano"
<>-\markup \fontsize #5 {\override #'(font-name .
               "Andika") mening}
 r1.  r2 
\set Staff.midiInstrument = "Bright Acoustic Piano"
<>-\markup \fontsize #5 {\override #'(font-name .
               "Andika") glede.}
 r1. 
\set Staff.midiInstrument = "Bright Acoustic Piano"
<>-\markup \fontsize #5 {\override #'(font-name .
               "Andika") kanskje}
 r1..  r1.. 
\set Staff.midiInstrument = "Bright Acoustic Piano"
<>-\markup \fontsize #5 {\override #'(font-name .
               "Andika") vi}
 r2  r2  r2. 
\set Staff.midiInstrument = "Bright Acoustic Piano"
<>-\markup \fontsize #5 {\override #'(font-name .
               "Andika") kommode.}
 \tuplet 2/1 { r1 } 
}
