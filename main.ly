\version "2.24.4"
\include "./upper.ily"
\include "./lower.ily"

#(set-global-staff-size 14)

\score {
   \new PianoStaff \with { instrumentName = "" }
   <<
     \new Staff = "upper" { \time 8/2 \upper }
     \new Staff = "lower" { \clef bass \lower }
   >>
  \layout {
      ragged-right = ##t
    \context {
      \Staff
      \omit TimeSignature
       % or:
      %\remove "Time_signature_engraver"
      \omit BarLine
      % or:
      %\remove "Bar_engraver"
    }
\context { \Score     forbidBreakBetweenBarLines = ##f }
\context { \Voice   \remove Forbid_line_break_engraver } }
   \midi { }
}
