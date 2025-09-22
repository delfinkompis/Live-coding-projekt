\version "2.24.4"

\include "./upper.ily"
\include "./lower.ily"

%#(set! paper-alist (cons '("my size" . (cons (* 50 cm) (* 200 cm))) paper-alist))
%#(set-default-paper-size "my size")
#(set-global-staff-size 10)


\paper { %systems-per-page = #1
  top-margin = 0\mm
  bottom-margin = 0\mm
  left-margin = 5\mm
  right-margin = 0\mm

}

%% ser finere ut uten tupletnumbers
global = { \override TupletNumber.text = "" \time 32/2 }
  \header {
    tagline = ##f
  }

\score {
   \new PianoStaff \with { instrumentName = "" }
   <<
     \new Staff = "upper" { \global \upper }
     \new Staff = "lower" { \clef bass \global \lower }
   >>
   \layout { 
       ragged-right = ##t
     \context {
       \Staff
       \omit TimeSignature
       \omit BarLine
     }
     \context { \Score     forbidBreakBetweenBarLines = ##f }
     \context { \Voice   \remove Forbid_line_break_engraver } }
}
