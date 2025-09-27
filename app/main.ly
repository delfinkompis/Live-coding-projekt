\version "2.25.28"

\include "./upper.ily"
\include "./lower.ily"
\include "./middle.ily"

%#(set! paper-alist (cons '("my size" . (cons (* 50 cm) (* 200 cm))) paper-alist))
%#(set-default-paper-size "my size")
#(set-global-staff-size 14)


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
   \new StaffGroup
   <<
     \new Staff = "upper" \with {
  instrumentName = "substantiv" } { \clef percussion \global \upper }
     \new Staff = "middle" \with {
  instrumentName = "verb" } { \clef percussion \global \middle }
     \new Staff = "lower" \with {
       instrumentName = "røkla" } { \clef percussion \global \lower }
   >>
   \layout { 
       ragged-right = ##t
     \context {
       \Staff
       \omit TimeSignature
       \omit BarLine
     }
     \context { \Score forbidBreakBetweenBarLines = ##f }
     \context { \Voice \remove Forbid_line_break_engraver } }
}
