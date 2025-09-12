\version "2.24.4"
\include "./on-color.ily"
%\include "~/Projektfiler/Stylesheets/variabler.scm"
%\include "./my-repl-defuns.scm"

upper = \fixed c {

<>^\markup {\override #'(font-name .
               "freemono") "opp" }  fis'''8(\flageolet f'''8\flageolet gis'''2\flageolet ees'''8)\flageolet 
<>^\markup \fontsize #1 { 
	   	     \override #'(font-name .
               "Latin modern sans demi cond")til }\magnifyMusic #11/10
{
  cis''16\tenuto gis''32\tenuto ees''32\tenuto e''16\tenuto f''16\tenuto fis''32\tenuto c''32\tenuto f''16\tenuto cis''32\tenuto c''32\tenuto e''16\tenuto ees''16\tenuto g''32\tenuto ees''16\tenuto f''16\tenuto e''16\tenuto
}

 s4 
 s1 
<>^\markup {\override #'(font-name .
               "freemono") "på" }  cis'''2(\flageolet ees'''8)\flageolet 
 \tuplet 2/1 { s1 } 
 \tuplet 5/1 { s2 } 
<>^\markup {\override #'(font-name .
               "freemono") "etter" }  f'''4(\flageolet g'''2\flageolet ees'''8\flageolet gis'''8\flageolet f'''4\flageolet fis'''2)\flageolet 
<>^\markup {\override #'(font-name .
               "freemono") "ord" }  g'''8(\flageolet fis'''4\flageolet ees'''2)\flageolet 
 s2. 
<>^\markup {\override #'(font-name .
               "freemono") "kan" }  f'''8(\flageolet gis'''8\flageolet f'''4\flageolet f'''8\flageolet cis'''8\flageolet ees'''8)\flageolet 
 s1. 
<>^\markup \fontsize #1 { 
	   	     \override #'(font-name .
               "Latin modern sans demi cond")til }\magnifyMusic #11/10
{
  gis''16\tenuto fis''16\tenuto fis''16\tenuto c''32\tenuto gis''32\tenuto f''32\tenuto c''32\tenuto g''16\tenuto gis''16\tenuto g''16\tenuto g''32\tenuto fis''16\tenuto g''32\tenuto c''16\tenuto c''16\tenuto f''32\tenuto
}

 s1.. 
}

