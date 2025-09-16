\version "2.24.4"
\include "./on-color.ily"
%\include "~/Projektfiler/Stylesheets/variabler.scm"
%\include "./my-repl-defuns.scm"

lower = \fixed c {

<>-\markup \fontsize #5 {\override #'(font-name .
               "Andika") våren}
 \tuplet 5/1 { s4 }  s2 <>-\markup \fontsize #5 {\override #'(font-name .
               "Andika") en}
 s2 \override NoteHead.color = #darkyellow
	   \override Stem.color = #darkyellow
	   \override Beam.color = #darkyellow
<>_\markup \fontsize #-2 \with-color #darkyellow {\override #'(font-name .
               "Linux Biolinum Keyboard O") herlig}
  \tuplet 2/3 { < a, cis' >4 } < bes, d' >4 \tuplet 2/3 { < bes, d' >4 } < b dis'' >4 \tuplet 2/3 { < f a' >8 } < b dis'' >4 \tuplet 2/3 { < f a' >4 } \tuplet 2/3 { < c e' >8 } \tuplet 2/3 { < bes, d' >4 }
\revert NoteHead.color
	   \revert Stem.color
	   \revert Beam.color s2. <>-\markup \fontsize #5 {\override #'(font-name .
               "Andika") med}
 s2. <>-\markup \fontsize #5 {\override #'(font-name .
               "Andika") lange,}
 s1.  s1  \tuplet 5/1 { s4 } <>-\markup \fontsize #5 {\override #'(font-name .
               "Andika") og}
 s2  s2. <>-\markup \fontsize #5 {\override #'(font-name .
               "Andika") aktivitet}
 \tuplet 9/1 { s4 } <>-\markup \fontsize #5 {\override #'(font-name .
               "Andika") ute.}
 s1 <>_\markup {
	   \with-color #yellow \on-color #red \pad-markup #0.2
"solen"
	   }\override NoteHead.color = #red
  \override Stem.color = #red
  \override Beam.color = #red
  b8(\staccato b8\staccato \tuplet 2/3 { b8 } g8\staccato \tuplet 2/3 { g8 } b4\staccato \tuplet 2/3 { c'8 } b4\staccato a4)\staccato

\revert NoteHead.color
  \revert Stem.color
  \revert Beam.color<>-\markup \fontsize #5 {\override #'(font-name .
               "Andika") begynner}
 \tuplet 2/1 { s1 } <>-\markup \fontsize #5 {\override #'(font-name .
               "Andika") å}
 s4 <>-\markup \fontsize #5 {\override #'(font-name .
               "Andika") varme,}
 s1. <>-\markup \fontsize #5 {\override #'(font-name .
               "Andika") og}
 s2 <>-\markup \fontsize #5 {\override #'(font-name .
               "Andika") snøen}
 \tuplet 5/1 { s4 } <>-\markup \fontsize #5 {\override #'(font-name .
               "Andika") smelter}
 s1..  s2. <>-\markup \fontsize #5 {\override #'(font-name .
               "Andika") fjellene.}
 \tuplet 9/1 { s4 } <>-\markup \fontsize #5 {\override #'(font-name .
               "Andika") sommeren}
 \tuplet 2/1 { s1 }  s2  s2.  \tuplet 2/1 { s1 } <>-\markup \fontsize #5 {\override #'(font-name .
               "Andika") tiden,}
 s1. <>-\markup \fontsize #5 {\override #'(font-name .
               "Andika") med}
 s2.  \tuplet 5/1 { s4 }  \tuplet 5/1 { s4 } <>-\markup \fontsize #5 {\override #'(font-name .
               "Andika") helt}
 s1  s2. <>_\markup \fontsize #3 {
	      \override #'(font-name .
               "Courier")sent}\magnifyMusic #7/5
{ < a, a >2. < a, a >1 }
<>-\markup \fontsize #5 {\override #'(font-name .
               "Andika") på}
 s2 <>-\markup \fontsize #5 {\override #'(font-name .
               "Andika") kvelden.}
 \tuplet 2/1 { s1 } <>-\markup \fontsize #5 {\override #'(font-name .
               "Andika") mange}
 \tuplet 5/1 { s4 } <>-\markup \fontsize #5 {\override #'(font-name .
               "Andika") nordmenn}
 \tuplet 2/1 { s1 } <>-\markup \fontsize #5 {\override #'(font-name .
               "Andika") reiser}
 s1.  s2. <>-\markup \fontsize #5 {\override #'(font-name .
               "Andika") kysten}
 s1. <>-\markup \fontsize #5 {\override #'(font-name .
               "Andika") eller}
 \tuplet 5/1 { s4 }  s2. <>-\markup \fontsize #5 {\override #'(font-name .
               "Andika") hytta}
 \tuplet 5/1 { s4 }  s2. <>-\markup \fontsize #5 {\override #'(font-name .
               "Andika") å}
 s4 <>-\markup \fontsize #5 {\override #'(font-name .
               "Andika") nyte}
 s1 <>-\markup \fontsize #5 {\override #'(font-name .
               "Andika") sommeren.}
 \tuplet 9/1 { s4 } <>-\markup \fontsize #5 {\override #'(font-name .
               "Andika") høsten}
 s1. <>-\markup \fontsize #5 {\override #'(font-name .
               "Andika") kommer}
 s1.  s2. <>-\markup \fontsize #5 {\override #'(font-name .
               "Andika") vakre}
 \tuplet 5/1 { s4 } <>-\markup \fontsize #5 {\override #'(font-name .
               "Andika") farger}
 s1.  s4 <>-\markup \fontsize #5 {\override #'(font-name .
               "Andika") naturen,}
 \tuplet 2/1 { s1 } <>-\markup \fontsize #5 {\override #'(font-name .
               "Andika") men}
 s2. <>-\markup \fontsize #5 {\override #'(font-name .
               "Andika") også}
 s1 <>-\markup \fontsize #5 {\override #'(font-name .
               "Andika") med}
 s2.  s2. <>-\markup \fontsize #5 {\override #'(font-name .
               "Andika") regn}
 s1 <>-\markup \fontsize #5 {\override #'(font-name .
               "Andika") og}
 s2 <>-\markup \fontsize #5 {\override #'(font-name .
               "Andika") mørkere}
 s1.. <>-\markup \fontsize #5 {\override #'(font-name .
               "Andika") kvelder.}
 \tuplet 2/1 { s1 } <>-\markup \fontsize #5 {\override #'(font-name .
               "Andika") vinteren}
 \tuplet 2/1 { s1 }  s2 <>-\markup \fontsize #5 {\override #'(font-name .
               "Andika") kald}
 s1 <>-\markup \fontsize #5 {\override #'(font-name .
               "Andika") og}
 s2 <>-\markup \fontsize #5 {\override #'(font-name .
               "Andika") mørk,}
 \tuplet 5/1 { s4 } <>-\markup \fontsize #5 {\override #'(font-name .
               "Andika") med}
 s2. <>-\markup \fontsize #5 {\override #'(font-name .
               "Andika") snø}
 s2. <>-\markup \fontsize #5 {\override #'(font-name .
               "Andika") som}
 s2. <>-\markup \fontsize #5 {\override #'(font-name .
               "Andika") dekker}
 s1. <>-\markup \fontsize #5 {\override #'(font-name .
               "Andika") landskapet.}
 \tuplet 11/1 { s4 }  \tuplet 5/1 { s4 } <>-\markup \fontsize #5 {\override #'(font-name .
               "Andika") nordmenn}
 \tuplet 2/1 { s1 } <>-\markup \fontsize #5 {\override #'(font-name .
               "Andika") liker}
 \tuplet 5/1 { s4 }  s4 <>-\markup \fontsize #5 {\override #'(font-name .
               "Andika") gå}
 s2 <>-\markup \fontsize #5 {\override #'(font-name .
               "Andika") på}
 s2 <>-\markup \fontsize #5 {\override #'(font-name .
               "Andika") ski}
 s2. <>-\markup \fontsize #5 {\override #'(font-name .
               "Andika") eller}
 \tuplet 5/1 { s4 } <>-\markup \fontsize #5 {\override #'(font-name .
               "Andika") dra}
 s2.  s2 <>-\markup \fontsize #5 {\override #'(font-name .
               "Andika") afterski.}
 \tuplet 9/1 { s4 }  
}
