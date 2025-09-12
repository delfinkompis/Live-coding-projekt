\version "2.24.4"
\include "./on-color.ily"
%\include "~/Projektfiler/Stylesheets/variabler.scm"
%\include "./my-repl-defuns.scm"

lower = \fixed c {

 s2. 
 s2. 
<>_\markup {
	   \with-color #yellow \on-color #red \pad-markup #0.2
"å"
	   }\override NoteHead.color = #red
  \override Stem.color = #red
  \override Beam.color = #red \tuplet 2/3 { g8 } g4)\staccato 
\revert NoteHead.color
  \revert Stem.color
  \revert Beam.color
<>-\markup \fontsize #5 {\override #'(font-name .
               "Andika") lyte}
 s1 
 s2 
<>-\markup \fontsize #5 {\override #'(font-name .
               "Andika") standard}
 \tuplet 2/1 { s1 } 
<>-\markup \fontsize #5 {\override #'(font-name .
               "Andika") mikrofonen}
 \tuplet 5/1 { s2 } 
 \tuplet 5/1 { s4 } 
 s2. 
<>-\markup \fontsize #5 {\override #'(font-name .
               "Andika") som}
 s2. 
 s2. 
<>-\markup \fontsize #5 {\override #'(font-name .
               "Andika") kobles}
 s1. 
 s2. 
<>-\markup \fontsize #5 {\override #'(font-name .
               "Andika") musikk.}
 s1.. 
}
