\version "2.24.4"
\include "./on-color.ily"
%\include "~/Projektfiler/Stylesheets/variabler.scm"
%\include "./my-repl-defuns.scm"

upper = \fixed c {

 \tuplet 5/1 { s4 } <>^\markup \fontsize #1 { 
	   	     \override #'(font-name .
               "Latin modern sans demi cond")er }\magnifyMusic #11/10
{
  c''32\tenuto e''32\tenuto ees''16\tenuto gis''32\tenuto d''16\tenuto fis''32\tenuto c''16\tenuto c''16\tenuto ees''16\tenuto e''16\tenuto gis''16\tenuto
}
 s2  s1. <>^\markup \fontsize #1 { 
	   	     \override #'(font-name .
               "Latin modern sans demi cond")tid }\magnifyMusic #11/10
{
  d''32\tenuto d''16\tenuto ees''32\tenuto f''32\tenuto gis''16\tenuto c''16\tenuto d''32\tenuto e''16\tenuto f''32\tenuto cis''16\tenuto c''16\tenuto ees''32\tenuto cis''16\tenuto f''16\tenuto gis''32\tenuto gis''32\tenuto ees''16\tenuto
}
 s2.  s1. \harmonicsOn
 ees'2(\portato cis'8\portato c'8\portato c'4\portato cis'2)\portato <>_\markup {
	   	     \override #'(font-name .
               "Comic Neue, Bold")lyse}\harmonicsOff
\harmonicsOn
 e'2(\portato ees'4\portato f'2\portato c'4)\portato <>_\markup {
	   	     \override #'(font-name .
               "Comic Neue, Bold")dager}\harmonicsOff
 s2 <>^\markup \fontsize #1 { 
	   	     \override #'(font-name .
               "Latin modern sans demi cond")mer }\magnifyMusic #11/10
{
  fis''16\tenuto fis''16\tenuto ees''32\tenuto d''16\tenuto fis''16\tenuto fis''32\tenuto g''16\tenuto c''32\tenuto c''16\tenuto c''32\tenuto c''16\tenuto ees''32\tenuto f''16\tenuto f''16\tenuto fis''16\tenuto
}
 \tuplet 9/1 { s4 }  s1  \tuplet 5/1 { s4 }  \tuplet 2/1 { s1 }  s4  s1.  s2  \tuplet 5/1 { s4 }  s1.. <>^\markup {\override #'(font-name .
               "freemono") "fra" }  cis'''4(\flageolet gis'''8\flageolet ees'''2)\flageolet  \tuplet 9/1 { s4 }  \tuplet 2/1 { s1 } <>^\markup \fontsize #1 { 
	   	     \override #'(font-name .
               "Latin modern sans demi cond")er }\magnifyMusic #11/10
{
  f''16\tenuto e''16\tenuto c''32\tenuto g''16\tenuto gis''16\tenuto gis''32\tenuto d''32\tenuto gis''16\tenuto fis''16\tenuto ees''32\tenuto ees''32\tenuto
}
<>^\markup \fontsize #1 { 
	   	     \override #'(font-name .
               "Latin modern sans demi cond")den }\magnifyMusic #11/10
{
  cis''32\tenuto f''16\tenuto d''16\tenuto c''32\tenuto e''16\tenuto d''16\tenuto ees''16\tenuto cis''16\tenuto g''32\tenuto c''32\tenuto e''16\tenuto fis''16\tenuto g''16\tenuto fis''16\tenuto d''16\tenuto
}
\magnifyMusic #2/1 { \tuplet 2/1 { < g'' d''' >1 } }
 s1.  s2. <>^\markup \fontsize #1 { 
	   	     \override #'(font-name .
               "Latin modern sans demi cond")lange }\magnifyMusic #11/10
{
  d''32\tenuto fis''16\tenuto gis''32\tenuto g''32\tenuto ees''32\tenuto fis''32\tenuto fis''16\tenuto d''16\tenuto cis''16\tenuto g''32\tenuto g''32\tenuto cis''16\tenuto c''16\tenuto gis''16\tenuto d''32\tenuto g''16\tenuto c''16\tenuto e''32\tenuto e''16\tenuto c''16\tenuto f''32\tenuto e''16\tenuto c''16\tenuto g''16\tenuto c''32\tenuto g''16\tenuto
}
\harmonicsOn
 c'8(\portato e'2\portato ees'4\portato c'2)\portato <>_\markup {
	   	     \override #'(font-name .
               "Comic Neue, Bold")dager}\harmonicsOff
 s1 <>^\markup \fontsize #1 { 
	   	     \override #'(font-name .
               "Latin modern sans demi cond")til }\magnifyMusic #11/10
{
  f''16\tenuto g''32\tenuto g''32\tenuto d''32\tenuto fis''32\tenuto gis''16\tenuto fis''16\tenuto d''32\tenuto e''16\tenuto g''16\tenuto d''16\tenuto d''32\tenuto ees''16\tenuto fis''16\tenuto gis''16\tenuto d''32\tenuto
}
 s1  s2  \tuplet 2/1 { s1 }  \tuplet 5/1 { s4 }  \tuplet 2/1 { s1 }  s1. <>^\markup \fontsize #1 { 
	   	     \override #'(font-name .
               "Latin modern sans demi cond")til }\magnifyMusic #11/10
{
  fis''32\tenuto d''16\tenuto fis''16\tenuto g''16\tenuto f''16\tenuto d''16\tenuto g''16\tenuto fis''32\tenuto d''16\tenuto e''16\tenuto e''16\tenuto fis''32\tenuto gis''32\tenuto f''32\tenuto d''32\tenuto cis''16\tenuto
}
 s1.  \tuplet 5/1 { s4 } <>^\markup \fontsize #1 { 
	   	     \override #'(font-name .
               "Latin modern sans demi cond")til }\magnifyMusic #11/10
{
  g''32\tenuto e''32\tenuto cis''16\tenuto ees''32\tenuto fis''32\tenuto ees''16\tenuto cis''32\tenuto ees''32\tenuto fis''16\tenuto ees''16\tenuto d''16\tenuto ees''16\tenuto f''32\tenuto g''16\tenuto g''32\tenuto f''16\tenuto g''16\tenuto
}
 \tuplet 5/1 { s4 } <>^\markup {\override #'(font-name .
               "freemono") "for" }  g'''8(\flageolet f'''4\flageolet g'''8\flageolet fis'''8\flageolet cis'''4)\flageolet  s4  s1  \tuplet 9/1 { s4 }  s1.  s1. <>^\markup {\override #'(font-name .
               "freemono") "med" }  gis'''4(\flageolet gis'''4\flageolet gis'''2)\flageolet  \tuplet 5/1 { s4 }  s1. \magnifyMusic #7/5 cis''8\tenuto( ees''8\tenuto cis''8\tenuto) <>_\markup \smallCaps \fontsize #4 {i} \tuplet 2/1 { s1 }  s2.  s1  s2. <>^\markup \fontsize #1 { 
	   	     \override #'(font-name .
               "Latin modern sans demi cond")mer }\magnifyMusic #11/10
{
  c''16\tenuto gis''16\tenuto e''16\tenuto d''16\tenuto gis''16\tenuto cis''16\tenuto c''16\tenuto f''32\tenuto d''32\tenuto cis''16\tenuto c''16\tenuto c''16\tenuto g''16\tenuto g''16\tenuto
}
 s1  s2  s1..  \tuplet 2/1 { s1 }  \tuplet 2/1 { s1 } <>^\markup \fontsize #1 { 
	   	     \override #'(font-name .
               "Latin modern sans demi cond")er }\magnifyMusic #11/10
{
  ees''16\tenuto c''32\tenuto ees''32\tenuto gis''16\tenuto gis''32\tenuto g''16\tenuto ees''16\tenuto ees''16\tenuto cis''16\tenuto d''16\tenuto
}
 s1  s2  \tuplet 5/1 { s4 }  s2.  s2.  s2.  s1.  \tuplet 11/1 { s4 } <>^\markup {\override #'(font-name .
               "freemono") "mange" }  ees'''2(\flageolet fis'''4\flageolet fis'''2\flageolet cis'''4)\flageolet  \tuplet 2/1 { s1 }  \tuplet 5/1 { s4 } <>^\markup \fontsize #1 { 
	   	     \override #'(font-name .
               "Latin modern sans demi cond")å }\magnifyMusic #11/10
{
  f''32\tenuto cis''32\tenuto g''16\tenuto e''16\tenuto cis''32\tenuto e''32\tenuto cis''32\tenuto
}
 s2  s2  s2.  \tuplet 5/1 { s4 }  s2. <>^\markup \fontsize #1 { 
	   	     \override #'(font-name .
               "Latin modern sans demi cond")på }\magnifyMusic #11/10
{
  e''32\tenuto ees''32\tenuto g''16\tenuto e''16\tenuto d''16\tenuto e''16\tenuto c''16\tenuto f''16\tenuto g''32\tenuto fis''16\tenuto
}
 \tuplet 9/1 { s4 }  
}

