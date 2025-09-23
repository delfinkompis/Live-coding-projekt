(define* (my-pause length-arg #:optional word-to-print)
  "Velklingende note"
  (let* (
	 (music
	  (string-append
	   
	   (trim-lily 
	    (with-output-to-string
	      (lambda ()
		(display-lily-music
		 (durlist->rests
		  (* length-arg 0.25)))))
	    )
	   ))
	 (text
	  (string-append
	   "\n\\set Staff.midiInstrument = \\\"Bright Acoustic Piano\\\"\n" ;;midi program 1
	  "<>-\\markup \\fontsize #-1 {"
	  "\\override #'(font-name .
               \\\"Andika\\\") "
	  word-to-print
	  "}\n" music
	  )))
    (begin
      (format #t "legger inn pause~%~%")
      (add-to-upper-inserts music)
      (add-to-lower-inserts text)
)))


(define* (my-god length-arg #:optional word-to-print)
  "Velklingende note"
  (let* (
	 (total-dur (* length-arg 0.25))
	 (music
	  (string-append
	   ;;; CHANGE MIDI INSTRUMENT TO WEIRD SOUND
	   "\n\\set Staff.midiInstrument = \\\"Electric Grand Piano\\\"\n" ;; midi program 2
	   "<>-\\markup {"
	   "\\override #'(font-name .
               \\\"Comic sans\\\") "
	   "\\\""
	   word-to-print
	   "\\\" }\n"
	   
	   "\\once \\override NoteHead.stencil = #ly:text-interface::print
	    \\once \\override NoteHead.text =
	    \\markup {
		     \\general-align #Y #CENTER {
						\\epsfile #X #5 \\\"./cupcake.eps\\\"

     }
   }"

           (trim-lily
	    (with-output-to-string
	      (lambda ()
		(display-lily-music
		  (pitchlist->lily
		   (list 11)
		   (list total-dur)))))
	    ))))
    (begin
      (format #t "Kjører lily-input \"god\", legger inn bilde av iskrem.~%~%")
      (add-to-lower-inserts
       (string-append
	music 
	"<>-\\markup {"
	word-to-print
	"}\n"))
      (add-to-upper-inserts
	    (trim-lily 
	    (with-output-to-string
	      (lambda ()
		(display-lily-music
		 (durlist->rests
		  (* length-arg 0.25)))))
	    ))
      )
    ))

;; liten, mindre, små

(define* (my-liten length-arg #:optional word-to-print)
  "Liten note"
  (let* ((possible-durations '(0.25 0.5 0.125))
	 ;; Note-dur er 25% av det vanlige.  Variablen brukes bare for første note, 
	 (note-dur (* length-arg 0.0625))
	 (possible-pitches '(0 2 4 6 7 9 10 12))
	 (output-file "upper.ily")
(other-file "lower.ily")
	 (music
	  (string-append
	   	   ;;; CHANGE MIDI INSTRUMENT TO WEIRD SOUND
	   "\n\\set Staff.midiInstrument = \\\"Honky Tonk Piano\\\"\n" ;; midi program 3
	   "<>-\\markup \\fontsize #-2 {"
	   "\\override #'(font-name .
               \\\"Comic sans\\\") "
	   "\\\""
	   word-to-print
	   "\\\" }\n"
	   
	   "\\magnifyMusic #1/2\n"
	    (with-output-to-string
	      (lambda ()
	        (display-lily-music
	    	(add-articulations 
	    	    	  (pitchlist->lily
	    	   (list-ref possible-pitches (random (length possible-pitches)))
	    	   (list note-dur)) "staccato"))))
	   (trim-lily
	    (with-output-to-string
	      (lambda ()
		(display-lily-music
		 (durlist->rests
		  (* (expt 2 (inexact->exact (floor (/ (log length-arg) (log 2))))) 0.1875)))))
	    )
	   )
	  ))
    (begin
      (format #t "Bruker lilypond-insert \"liten\".  Kort, lys, note med pause etterpå.~%~%")
      (add-to-upper-inserts music)
 
      (add-to-lower-inserts
	    (trim-lily 
	    (with-output-to-string
	      (lambda ()
		(display-lily-music
		 (durlist->rests
		  (* length-arg 0.25)))))
	    ))
      )))






;; stor, gjev, vel

(define* (my-stor length-arg #:optional word-to-print)
  "Stor note"
  (let* (
	 (total-dur (* length-arg 0.25))
	 (possible-pitches (map (lambda (x) (+ 19 x)) '(0 2 4 6 7 9 10 12)))
	 (music
	  (string-append
	   	   ;;; CHANGE MIDI INSTRUMENT TO WEIRD SOUND
	   "\n\\set Staff.midiInstrument = \\\"Electric Piano 1\\\"\n" ;; midi program 4
	   "<>-\\markup \\fontsize #2 {"
	   "\\override #'(font-name .
               \\\"Cabin, Bold\\\") "
	   "\\\""
	   word-to-print
	   "\\\" }\n"
	   "\\magnifyMusic #2/1 "
	    (with-output-to-string
	      (lambda ()
		(display-lily-music
		 (make-harmony
		  (pitchlist->lily
		    (list-ref possible-pitches (random (length possible-pitches)))
		    (list total-dur)) 7))))
	    	   )))
    (begin
      (format #t "Bruker lilypond-insert \"stor\".  Lang, lys note harmonisert med kvinter.~%~%")
      (add-to-upper-inserts music)
      (add-to-lower-inserts
	    (trim-lily 
	    (with-output-to-string
	      (lambda ()
		(display-lily-music
		 (durlist->rests
		  (* length-arg 0.25)))))
	    ))
      )))



;; passe, bare, vanlig
(define* (my-rask length-arg #:optional word-to-print)
  "Raske noter"
  (let* ((possible-durations '(1/24 1/12 1/8))
	 (total-dur (* length-arg 0.25))
	 (durs (let loop ((dur-list '()) (dur-sum 0))
		 (if (>= dur-sum total-dur)
		     dur-list
		     (let ((new-dur (list-ref possible-durations (random (length possible-durations)))))
		       (loop (append dur-list (list new-dur))
			     (+ dur-sum new-dur))
		       ))))
	 (possible-pitches '(12 13 15 16 11 10))
	 (output-file "upper.ily")
(other-file "lower.ily")
	 (music
	  (string-append
	   	   ;;; CHANGE MIDI INSTRUMENT TO WEIRD SOUND
	   "\n\\set Staff.midiInstrument = \\\"Electric Piano 2\\\"\n" ;; midi program 5
	   "<>_\\markup \\smallCaps \\fontsize #4 {"
	   word-to-print
	   "}"
	   	   "\\magnifyMusic #6/7"
	   (trim-lily 
	    (with-output-to-string
	      (lambda ()
		(display-lily-music
		 (add-articulations
		 (add-slur
		  (pitchlist->lily
		   (map (lambda (x) (list-ref possible-pitches (random (length possible-pitches)))) durs)
		   durs)) "tenuto"))))
	   )


	   )))
    (begin
      (format #t "Bruker lilypond-insert \"rask\".  Kjapt, kromatisk löp.~%~%")
      (add-to-upper-inserts music)
      (add-to-lower-inserts
       (trim-lily 
	    (with-output-to-string
	      (lambda ()
		(display-lily-music
		 (durlist->rests
		  (* length-arg 0.25)))))
	    ))
      )))

(define* (my-treig length-arg #:optional word-to-print)
  "Treig note"
  (let* ((possible-durations '(0.5 0.75 1))
	 (total-dur (* length-arg 0.25))
	 (durs (let loop ((dur-list '()) (dur-sum 0))
		 (if (>= dur-sum total-dur)
		     dur-list
		     (let ((new-dur (list-ref possible-durations (random (length possible-durations)))))
		       (loop (append dur-list (list new-dur))
			     (+ dur-sum new-dur))
		       ))))
	 (possible-pitches (map (lambda (x) (- x 24)) '(0 7 9 16 13)))
	 (music
	  (string-append
	   "\n\\set Staff.midiInstrument = \\\"Harpsichord\\\"\n" ;; midi program 6
	   "<>_\\markup \\fontsize #3 {
	      \\override #'(font-name .
               \\\"Courier\\\") "
	   word-to-print
	   "}"
	   
	   "\\magnifyMusic #7/5\n"
	    (with-output-to-string
	      (lambda ()
		(display-lily-music
		 (make-harmony
		  (pitchlist->lily
		   (map (lambda (x) (list-ref possible-pitches (random (length possible-pitches)))) durs)
		   durs) 12))))

	   )))
    (begin
      (format #t "Bruker lilypond-insert \"treig\".  Liten gamut, store avstander, harmonisert med oktaver.~%~%")
      (add-to-lower-inserts music)
      (add-to-upper-inserts
			   (trim-lily 
	    (with-output-to-string
	      (lambda ()
		(display-lily-music
		 (durlist->rests
		  (* length-arg 0.25)))))
	    ))
      )))

;; full, hel, riktig

(define* (my-tett length-arg #:optional word-to-print)
  "Tette kromatiske noter"
  (let* (
	 (possible-durations '(1/16 1/32 1/16))
	 (total-dur (* length-arg 0.25))
	 (durs (let loop ((dur-list '()) (dur-sum 0))
		 (if (> dur-sum (* total-dur 0.25))
		     dur-list
		     (let ((new-dur (list-ref possible-durations (random (length possible-durations)))))
		       (loop (append dur-list (list new-dur))
			     (+ dur-sum new-dur))
		       ))))
	 (possible-pitches '(12 13 14 15 16 17 18 19 20))
	 (output-file "upper.ily")
(other-file "lower.ily")
	 (music
	  (string-append
	   "\n\\set Staff.midiInstrument = \\\"Clav\\\"\n" ;; midi program 7
	   "<>^\\markup \\fontsize #1 { 
	   	     \\override #'(font-name .
               \\\"Latin modern sans demi cond\\\") "
	   word-to-print
	   " }"
	   
	   "\\magnifyMusic #11/10\n"
	   (trim-lily 
	    (with-output-to-string
	      (lambda ()
		(display-lily-music
		 (durlist->rests
		  (* total-dur 0.25)))))
	    )
	   
	    (with-output-to-string
	      (lambda ()
		(display-lily-music
		 (add-articulations
		  (pitchlist->lily
		   (map (lambda (x) (list-ref possible-pitches (random (length possible-pitches)))) durs)
		   durs) "tenuto"))))
	    (trim-lily 
	    (with-output-to-string
	      (lambda ()
		(display-lily-music
		 (durlist->rests
		  (* total-dur 0.25)))))
	    )

	   )))
    (begin
      (format #t "Bruker lilypond-insert \"tett\".  Raske, tette kromatiske bevegelser i mellomregistret.~%~%")
(add-to-upper-inserts music)
            (add-to-lower-inserts
 (trim-lily 
	    (with-output-to-string
	      (lambda ()
		(display-lily-music
		 (durlist->rests
		  (* length-arg 0.25)))))
	    ))
      )))
;; tom, lett, 

(define* (my-tom length-arg #:optional word-to-print)
  "Velklingende note"
  (let* (
	 (possible-durations '(0.25 0.5 0.125))
	 (total-dur (* length-arg 0.25))
	 (possible-pitches (map (lambda (x) (- x 12)) '(0 1 2 3 4 5 6 7)))

	 (music 
	  (string-append
	   "\n\\set Staff.midiInstrument = \\\"Celesta\\\"\n" ;; midi program 8
	   (trim-lily 
	    (with-output-to-string
	      (lambda ()
		(display-lily-music
		 (durlist->rests
		  (* total-dur 1/3)))))
	    )
	   "<>^\\markup \\bold \\fontsize #-2 {"
	   word-to-print
	   "}"
	   
	   "\\magnifyMusic #5/7\n"
	   (with-output-to-string
	      (lambda ()
		(display-lily-music
		 (add-articulations  
		  (make-harmony
		  (pitchlist->lily
		   (list-ref possible-pitches (random (length possible-pitches)))
		   (list (* total-dur 1/6))) 12) "staccato"))))
	 
	   (trim-lily 
	    (with-output-to-string
	      (lambda ()
		(display-lily-music
		 (durlist->rests
		  (* total-dur 1/2)))))
	    )
	   )))
    (begin
      (format #t "Bruker lilypond-insert \"tom\" - kort oktavintervall omringa av pauser~%~%")
      (add-to-lower-inserts music)
      (add-to-upper-inserts (trim-lily 
	    (with-output-to-string
	      (lambda ()
		(display-lily-music
		 (durlist->rests
		  (* length-arg 0.25)))))
	    ))
      )))

(define* (my-vit length-arg #:optional word-to-print)
  "Hvite noter (flageolettnotasjon)"
  (let* (
	 (possible-durations '(0.25 0.5 0.125))
	 (total-dur (* length-arg 0.25))
	 (possible-pitches '(0 1 2 3 4 5 0 0 4))
	 (durs (let loop ((dur-list '()) (dur-sum 0))
		 (if (>= dur-sum total-dur)
		     dur-list
		     (let ((new-dur (list-ref possible-durations (random (length possible-durations)))))
		       (loop (append dur-list (list new-dur))
			     (+ dur-sum new-dur))
		       ))))
	 (output-file "upper.ily")
(other-file "lower.ily")
	 (music
	  (string-append
	   "\n\\set Staff.midiInstrument = \\\"Glockenspiel\\\"\n" ;; midi program 9
	   "\\harmonicsOn\n"
	   "<>_\\markup {
	   	     \\override #'(font-name .
               \\\"Comic Neue, Bold\\\") "
	   word-to-print
	   "}"

	   (trim-lily 
	    (with-output-to-string
	      (lambda ()
		(display-lily-music
		 (add-slur
		  (add-articulations
		  (pitchlist->lily
		   (map (lambda (x) (list-ref possible-pitches (random (length possible-pitches)))) durs)
		   durs) "portato")))))
	    )
	   "\\harmonicsOff\n"
	   )))
    (begin
      (format #t "Bruker lilypond-insert \"vit\".  Flageolettnoter. ~%~%")
(add-to-upper-inserts music)
(add-to-lower-inserts
 (trim-lily 
	    (with-output-to-string
	      (lambda ()
		(display-lily-music
		 (durlist->rests
		  (* length-arg 0.25)))))
	    ))
      )))

(define* (my-svart length-arg #:optional word-to-print)
  "Cluster"
  (let* (
	 (possible-durations '(0.25 0.5 0.125))
	 (total-dur (* length-arg 0.25))
	 (possible-pitches '(0 2 4 6 7 9 10 12))
	 	 
	 (output-file "upper.ily")
(other-file "lower.ily")
	 (music
	  (string-append
	   	   "<>_\\markup \\fontsize #1 { 
	   	     \\override #'(font-name .
               \\\"Cabin, Oblique Bold\\\")
	    \\with-color #white \\on-color #black \\pad-markup #0.2
	   \\\"" word-to-print "\\\"
	    }"
	   "\n\\set Staff.midiInstrument = \\\"Music Box\\\"\n" ;; midi program 10
	   
	   (trim-lily 
	    (with-output-to-string
	      (lambda ()
		(display-lily-music
		 (make-harmony
		   (make-harmony
		    (pitchlist->lily
		     (list-ref possible-pitches (random (length possible-pitches)))
		     (list total-dur))
		    (list-ref '(3 4 5) (random 3)))
		   (list-ref '(1 2) (random 2)))
		  )))
	    )

	   )))
    (begin
      (format #t "Bruker lilypond-insert \"svart\".  Svarte noter (clusterformasjoner).~%~%")
      (add-to-upper-inserts music)
(add-to-lower-inserts (trim-lily 
	    (with-output-to-string
	      (lambda ()
		(display-lily-music
		 (durlist->rests
		  (* length-arg 0.25)))))
	    ))
      )))



(define* (my-rød length-arg #:optional word-to-print)
  "Rød note"
  (let* (
	 (possible-durations '(1/12 1/8 1/4 1/12))
	 (total-dur (* length-arg 0.25))
	 (possible-pitches (map (lambda (x) (- x 12)) '(4 5 7 9 11 12)))
	 (durs (let loop ((dur-list '()) (dur-sum 0))
		 (if (>= dur-sum total-dur)
		     dur-list
		     (let ((new-dur (list-ref possible-durations (random (length possible-durations)))))
		       (loop (append dur-list (list new-dur))
			     (+ dur-sum new-dur))
		       ))))
	 
	 (output-file "lower.ily")
(other-file "upper.ily")
	 (music
	  (string-append
	   "<>_\\markup {
	   \\with-color #yellow \\on-color #red \\pad-markup #0.2
\\\"" word-to-print "\\\"
	   }"
	   "\n\\set Staff.midiInstrument = \\\"Vibraphone\\\"\n" ;; midi program 11
	     "\\override NoteHead.color = #red
  \\override Stem.color = #red
  \\override Beam.color = #red"
	   
	   (trim-lily 
	    (with-output-to-string
	      (lambda ()
		(display-lily-music
		 (add-slur
		  (add-articulations
		  (pitchlist->lily
		   (map (lambda (x) (list-ref possible-pitches (random (length possible-pitches)))) durs)
		   durs) "staccato")))))
	    )
	   "\n\\revert NoteHead.color
  \\revert Stem.color
  \\revert Beam.color"
	   )))
    (begin
      (format #t "Bruker lilypond-insert \"rød\".  Røde noter med stakkatoprikker.~%~%")
(add-to-lower-inserts music)
      (add-to-upper-inserts
            (trim-lily 
	    (with-output-to-string
	      (lambda ()
		(display-lily-music
		 (durlist->rests
		  (* length-arg 0.25)))))
	    ))
      )))

(define* (my-blå length-arg #:optional word-to-print)
  "Blå noter"
  (let* (
	 (possible-durations '(1 2 1.5))
	 (total-dur (* length-arg 0.25))
	 (possible-pitches '(12))
	 (durs (let loop ((dur-list '()) (dur-sum 0))
		 (if (>= dur-sum total-dur)
		     dur-list
		     (let ((new-dur (list-ref possible-durations (random (length possible-durations)))))
		       (loop (append dur-list (list new-dur))
			     (+ dur-sum new-dur))
		       ))))
	 
	 (output-file "upper.ily")
(other-file "lower.ily")
	 (music
	  (string-append
	   	   "\n\\set Staff.midiInstrument = \\\"Marimba\\\"\n" ;; midi program 12
	   "<>_\\markup \\box \\fontsize #3 {
	   \\with-color #cyan \\pad-markup #0.2
\\\"" word-to-print "\\\"
	   }"

"\\override NoteHead.color = #darkcyan\n"
"\\override Stem.color = #darkcyan\n"
	   "\\override Beam.color = #darkcyan\n"
	   "\\override NoteHead.style = #'slash\n"
	   (trim-lily 
	    (with-output-to-string
	      (lambda ()
		(display-lily-music
		  (pitchlist->lily
		   (map (lambda (x) (list-ref possible-pitches (random (length possible-pitches)))) durs)
		   durs))))
	    )
	   "\n\\revert NoteHead.color
  \\revert Stem.color
  \\revert Beam.color"
	   "\n\\revert NoteHead.style"	   
					;	 word-to-display
	   )))
    (begin
      (format #t "Bruker lilypond-insert \"blå\".  Blåe skråe noter.~%~%")
(add-to-upper-inserts music)
      (add-to-lower-inserts (trim-lily 
	    (with-output-to-string
	      (lambda ()
		(display-lily-music
		 (durlist->rests
		  (* length-arg 0.25)))))
	    ))

      )))

(define* (my-gul length-arg #:optional word-to-print)
  "Velklingende note"
  (let* ((possible-durations '(1/12 1/6 1/4))
	 (total-dur (* length-arg 0.25))
	 ;; två oktaver ner
	 (possible-pitches (map (lambda (x) (- x 24)) '(9 10 12 13 15 17 23 24)))
	 (durs (let loop ((dur-list '()) (dur-sum 0))
		 (if (>= dur-sum total-dur)
		     dur-list
		     (let ((new-dur (list-ref possible-durations (random (length possible-durations)))))
		       (loop (append dur-list (list new-dur))
			     (+ dur-sum new-dur))
		       ))))
	 

	 (music
	  (string-append
	   	   "\n\\set Staff.midiInstrument = \\\"Xylophone\\\"\n" ;; midi program 13
	   "\\override NoteHead.color = #darkyellow
	   \\override Stem.color = #darkyellow
	   \\override Beam.color = #darkyellow\n"

	   "<>_\\markup \\fontsize #-2 \\with-color #darkyellow {"
	   "\\override #'(font-name .
               \\\"Linux Biolinum Keyboard O\\\") "
	    word-to-print
	    "}"
	    
	   (trim-lily 
	    (with-output-to-string
	      (lambda ()
		(display-lily-music
		 (make-harmony  
		   (pitchlist->lily
		    (map (lambda (x) (list-ref possible-pitches (random (length possible-pitches)))) durs)
		    durs) 16))))
	      )

	    "\\revert NoteHead.color
	   \\revert Stem.color
	   \\revert Beam.color"

	    )))
    (begin
      (format #t "Bruker lilypond-insert \"gul\".  Gul note harmonisert med terser.~%~%")
(add-to-lower-inserts music)
(add-to-upper-inserts (trim-lily 
	    (with-output-to-string
	      (lambda ()
		(display-lily-music
		 (durlist->rests
		  (* length-arg 0.25)))))
	    ))
      )))

(define* (my-grønn length-arg #:optional word-to-print)
  "Velklingende note"
  (let* ((possible-durations '(0.25 0.5 0.125))
	 (total-dur (* length-arg 0.25))
	 (possible-pitches '(0 2 4 6 7 9 10 12))
	 (durs (let loop ((dur-list '()) (dur-sum 0))
		 (if (>= dur-sum total-dur)
		     dur-list
		     (let ((new-dur (list-ref possible-durations (random (length possible-durations)))))
		       (loop (append dur-list (list new-dur))
			     (+ dur-sum new-dur))
		       ))))
	 
	 (music
	  (string-append
	   	  "\n\\set Staff.midiInstrument = \\\"Tubular Bells\\\"\n" ;; midi program 14
	   "<>-\\markup \\fontsize #-4 \\with-color #darkgreen \\box \\column {
  \\override #'(font-name .
               \\\"D050000L\\\")
   \\line {" word-to-print "}
  \\override #'(font-name .
               \\\"Comic Sans\\\")
   \\line {" word-to-print "}
  \\override #'(font-name .
               \\\"D050000L\\\")
   \\line { " word-to-print " }
}"
   "\\override NoteHead.color = #darkgreen\n"
   "\\override Stem.color = #darkgreen\n"
   "\\override Beam.color = #darkgreen\n"
	   "\\xNotesOn"
	   (trim-lily 
	    (with-output-to-string
	      (lambda ()
		(display-lily-music
		 (add-articulations
		  (add-slur
		   (pitchlist->lily
		    (map (lambda (x) (list-ref possible-pitches (random (length possible-pitches)))) durs)
		    durs)) "marcato"))))
	    )
	   "\\xNotesOff"
   "\\revert NoteHead.color
   \\revert Stem.color
   \\revert Beam.color"
	   )))
    (begin
      (format #t "Bruker lilypond-insert \"grønn\".  Grønne kryssnoter.~%~%")
      (add-to-lower-inserts music)
(add-to-upper-inserts (trim-lily 
	    (with-output-to-string
	      (lambda ()
		(display-lily-music
		 (durlist->rests
		  (* length-arg 0.25)))))
	    ))
      )))

(define* (my-lavt length-arg #:optional word-to-print)
  "Velklingende note"
  (let* (
	 (possible-durations '(0.25 0.5 0.125))
	 (total-dur (* length-arg 0.25))
	 (possible-pitches '(-24 -22 -20 -19 -17))
	 (durs (let loop ((dur-list '()) (dur-sum 0))
		 (if (>= dur-sum total-dur)
		     dur-list
		     (let ((new-dur (list-ref possible-durations (random (length possible-durations)))))
		       (loop (append dur-list (list new-dur))
			     (+ dur-sum new-dur))
		       ))))
	 (output-file "lower.ily")
(other-file "upper.ily")
	 (music
	  (string-append
	   "\n\\set Staff.midiInstrument = \\\"Dulcimer\\\"\n" ;; midi program 15
	   	   "<>_\\markup \\italic \\box \\lower #4 \\fontsize #-2  { \\\""
	   word-to-print
	   "\\\" }"

	   (trim-lily
	   (with-output-to-string
	     (lambda ()
	       (display-lily-music
		(make-harmony
		(add-articulations 		
		  (pitchlist->lily
		   (list-ref possible-pitches (random (length possible-pitches)))
		   (list total-dur)) "tenuto") 12))))
	   )
	   )))
    (begin
      (format #t "Bruker lilypond-insert \"lav\".  Dyp note med oktavdobling.~%~%")
      (add-to-lower-inserts music)
      (add-to-upper-inserts (trim-lily 
	    (with-output-to-string
	      (lambda ()
		(display-lily-music
		 (durlist->rests
		  (* length-arg 0.25)))))
	    ))
      )))

(define* (my-høyt length-arg #:optional word-to-print)
  "Velklingende note"
  (let* (
	 (possible-durations '(0.25 0.5 0.125))
	 (total-dur (* length-arg 0.25))
	 (durs (let loop ((dur-list '()) (dur-sum 0))
		 (if (>= dur-sum total-dur)
		     dur-list
		     (let ((new-dur (list-ref possible-durations (random (length possible-durations)))))
		       (loop (append dur-list (list new-dur))
			     (+ dur-sum new-dur))
		       ))))
	 (possible-pitches '(25 27 29 30 31 32))

	 (music
	  (string-append
	   "<>^\\markup {"
	   "\\override #'(font-name .
               \\\"freemono\\\") "
	   "\\\""
	   word-to-print
	   "\\\" } "
	   	  "\n\\set Staff.midiInstrument = \\\"Drawbar Organ\\\"\n" ;; midi program 16
	   (trim-lily 
	    (with-output-to-string
	      (lambda ()
		(display-lily-music
		 (add-slur
		  (add-articulations
		  (pitchlist->lily
		   (map (lambda (x) (list-ref possible-pitches (random (length possible-pitches)))) durs)
	       	   durs) "flageolet"))))))

	   )))
    (begin
      (format #t "Bruker lilypond-insert \"høyt\" med en høy velklingende note~%~%")
      (add-to-upper-inserts music)

     (add-to-lower-inserts (trim-lily 
	    (with-output-to-string
	      (lambda ()
		(display-lily-music
		 (durlist->rests
		  (* length-arg 0.25)))))
	    ))

      )))


(define* (my-artikkel length-arg #:optional word-to-print)
  "Velklingende note"
  (let* (
	 (possible-durations '(0.25 0.5 0.125))
	 (total-dur (* length-arg 0.25))
	 (durs (let loop ((dur-list '()) (dur-sum 0))
		 (if (>= dur-sum total-dur)
		     dur-list
		     (let ((new-dur (list-ref possible-durations (random (length possible-durations)))))
		       (loop (append dur-list (list new-dur))
			     (+ dur-sum new-dur))
		       ))))
	 (possible-pitches '((5 9 12) (5 8 12) (4 7 12) (3 7 12) (3 8 12) (4 9 12) (4 8 12) (3 6 12)))

	 (music
	  (string-append
	   "\n\\set Staff.midiInstrument = \\\"Percussive Organ\\\"\n" ;; midi program 17
	   "<>^\\markup {"
	   "\\override #'(font-name .
               \\\"freemono\\\") "
	   "\\\""
	   word-to-print
	   "\\\" } "
	   (trim-lily 
	    (with-output-to-string
	      (lambda ()
		(display-lily-music
		 (add-slur
		  (add-articulations
		   (chordlist->lily
		    (riemann (list-ref possible-pitches (random (length possible-pitches))) (length durs))
	;	   (map (lambda (x) (list-ref possible-pitches (random (length possible-pitches)))) durs)
	       	   durs) "staccato"))))))
	   )))
    (begin
      (format #t "Bruker lilypond-insert \"artikkel\" for artikler og småord~%~%")
      (add-to-upper-inserts music)

     (add-to-lower-inserts (trim-lily 
	    (with-output-to-string
	      (lambda ()
		(display-lily-music
		 (durlist->rests
		  (* length-arg 0.25)))))
	    ))

     )))

(define* (my-to length-arg #:optional word-to-print)
  "Velklingende note"
  (let* (
	 (possible-durations '(0.25 0.5 0.125))
	 (total-dur (* length-arg 0.25))
	 (durs (let loop ((dur-list '()) (dur-sum 0))
		 (if (>= dur-sum total-dur)
		     dur-list
		     (let ((new-dur (list-ref possible-durations (random (length possible-durations)))))
		       (loop (append dur-list (list new-dur))
			     (+ dur-sum new-dur))
		       ))))
	 (possible-pitches '(-10 -8 -12 -11 -9 -7 -10))
	 (music
	  (string-append
	   "\n\\set Staff.midiInstrument = \\\"Rock Organ\\\"\n" ;; midi program 18
	   "<>^\\markup {"
	   "\\override #'(font-name .
               \\\"freemono\\\") "
	   "\\\""
	   word-to-print
	   "\\\" } "
	   (trim-lily 
	    (with-output-to-string
	      (lambda ()
		(display-lily-music
		 (add-slur
		  (add-articulations
		   (let ((half-dur (* total-dur 1/4)))
			 (pitchlist->lily
			  (list-ref possible-pitches (random (length possible-pitches)))
			  (list half-dur half-dur))) "portato"))))))
	   )))
    (begin
      (format #t "Bruker lilypond-insert \"to\".  To små noter~%~%")
      (add-to-lower-inserts music)

     (add-to-upper-inserts (trim-lily 
	    (with-output-to-string
	      (lambda ()
		(display-lily-music
		 (durlist->rests
		  (* length-arg 0.25)))))
	    ))

      )))

(define lilywords
  `(("best" . ,(lambda (arg1 arg2) (my-god arg1 arg2)))
    ("liten" . ,(lambda (arg1 arg2) (my-liten arg1 arg2)))
    ("stor" . ,(lambda (arg1 arg2) (my-stor arg1 arg2)))
    ("stort" . ,(lambda (arg1 arg2) (my-stor arg1 arg2)))
    ("de" . ,(lambda (arg1 arg2) (my-tett arg1 arg2)))
    ("mot" . ,(lambda (arg1 arg2) (my-rød arg1 arg2)))
    ("alt" . ,(lambda (arg1 arg2) (my-tett arg1 arg2)))
    ("vis" . ,(lambda (arg1 arg2) (my-stor arg1 arg2)))
    ("disse" . ,(lambda (arg1 arg2) (my-tett arg1 arg2)))
    ("god" . ,(lambda (arg1 arg2) (my-god arg1 arg2)))
    ("godt" . ,(lambda (arg1 arg2) (my-god arg1 arg2)))
    ("bra" . ,(lambda (arg1 arg2) (my-god arg1 arg2)))
    ("nettopp" . ,(lambda (arg1 arg2) (my-rask arg1 arg2)))
    ("vel" . ,(lambda (arg1 arg2) (my-god arg1 arg2)))
    ("heller" . ,(lambda (arg1 arg2) (my-høyt arg1 arg2)))
    ("opp" . ,(lambda (arg1 arg2) (my-høyt arg1 arg2)))
    ("possessiv" . ,(lambda (arg1 arg2) (my-tett arg1 arg2)))
    ("bedre" . ,(lambda (arg1 arg2) (my-god arg1 arg2)))
    ("mann" . ,(lambda (arg1 arg2) (my-gul arg1 arg2)))
    ("minst" . ,(lambda (arg1 arg2) (my-liten arg1 arg2)))
    ("mindre" . ,(lambda (arg1 arg2) (my-liten arg1 arg2)))
    ("ennå" . ,(lambda (arg1 arg2) (my-rask arg1 arg2)))
    ("da" . ,(lambda (arg1 arg2) (my-treig arg1 arg2)))
    ("stå" . ,(lambda (arg1 arg2) (my-høyt arg1 arg2)))
    ("hun" . ,(lambda (arg1 arg2) (my-gul arg1 arg2)))
    ("han" . ,(lambda (arg1 arg2) (my-gul arg1 arg2)))
    ("nok" . ,(lambda (arg1 arg2) (my-artikkel arg1 arg2)))
    ("herre" . ,(lambda (arg1 arg2) (my-gul arg1 arg2)))
    ("foran" . ,(lambda (arg1 arg2) (my-rask arg1 arg2)))
    ("bak" . ,(lambda (arg1 arg2) (my-treig arg1 arg2)))
    ("framfor" . ,(lambda (arg1 arg2) (my-rask arg1 arg2)))
    ("meget" . ,(lambda (arg1 arg2) (my-god arg1 arg2)))
    ("man" . ,(lambda (arg1 arg2) (my-gul arg1 arg2)))
    ("oss" . ,(lambda (arg1 arg2) (my-gul arg1 arg2)))
    ("vente" . ,(lambda (arg1 arg2) (my-treig arg1 arg2)))
    ("tydelig" . ,(lambda (arg1 arg2) (my-rød arg1 arg2)))
    ("måtte" . ,(lambda (arg1 arg2) (my-rask arg1 arg2)))
    ("menneske" . ,(lambda (arg1 arg2) (my-gul arg1 arg2)))
    ("mer" . ,(lambda (arg1 arg2) (my-tett arg1 arg2)))
    ("oppe" . ,(lambda (arg1 arg2) (my-høyt arg1 arg2)))
    ("rett" . ,(lambda (arg1 arg2) (my-stor arg1 arg2)))
    ("viss" . ,(lambda (arg1 arg2) (my-treig arg1 arg2)))
    ("vesle" . ,(lambda (arg1 arg2) (my-liten arg1 arg2)))
    ("glad" . ,(lambda (arg1 arg2) (my-god arg1 arg2)))
    ("ad" . ,(lambda (arg1 arg2) (my-tett arg1 arg2)))
    ("nå" . ,(lambda (arg1 arg2) (my-rask arg1 arg2)))
    ("ren" . ,(lambda (arg1 arg2) (my-tom arg1 arg2)))
    ("borte" . ,(lambda (arg1 arg2) (my-tom arg1 arg2)))
    ("ute" . ,(lambda (arg1 arg2) (my-grønn arg1 arg2)))
    ("ned" . ,(lambda (arg1 arg2) (my-lavt arg1 arg2)))
    ("bort" . ,(lambda (arg1 arg2) (my-liten arg1 arg2)))
    ("lett" . ,(lambda (arg1 arg2) (my-tom arg1 arg2)))
    ("mørke" . ,(lambda (arg1 arg2) (my-svart arg1 arg2)))
    ("mørk" . ,(lambda (arg1 arg2) (my-svart arg1 arg2)))
    ("lys" . ,(lambda (arg1 arg2) (my-vit arg1 arg2)))
    ("ikke" . ,(lambda (arg1 arg2) (my-høyt arg1 arg2)))
    ("fin" . ,(lambda (arg1 arg2) (my-liten arg1 arg2)))
    ("herlig" . ,(lambda (arg1 arg2) (my-liten arg1 arg2)))
    ("fine" . ,(lambda (arg1 arg2) (my-liten arg1 arg2)))   
    ("se" . ,(lambda (arg1 arg2) (my-høyt arg1 arg2)))
    ("full" . ,(lambda (arg1 arg2) (my-tett arg1 arg2)))
    ("helt" . ,(lambda (arg1 arg2) (my-tett arg1 arg2)))
    ("hel" . ,(lambda (arg1 arg2) (my-tett arg1 arg2)))    
    ("tett" . ,(lambda (arg1 arg2) (my-tett arg1 arg2)))
    ("mange" . ,(lambda (arg1 arg2) (my-tett arg1 arg2)))
    ("jevn" . ,(lambda (arg1 arg2) (my-tett arg1 arg2)))
    ("rask" . ,(lambda (arg1 arg2) (my-rask arg1 arg2)))
    ("fort" . ,(lambda (arg1 arg2) (my-rask arg1 arg2)))
    ("treig" . ,(lambda (arg1 arg2) (my-treig arg1 arg2)))
    ("langsom" . ,(lambda (arg1 arg2) (my-treig arg1 arg2)))
    ("tom" . ,(lambda (arg1 arg2) (my-tom arg1 arg2)))
    ("hvit" . ,(lambda (arg1 arg2) (my-vit arg1 arg2)))
    ("snø" . ,(lambda (arg1 arg2) (my-vit arg1 arg2)))
    ("ski" . ,(lambda (arg1 arg2) (my-vit arg1 arg2)))
    ("svart" . ,(lambda (arg1 arg2) (my-svart arg1 arg2)))
    ("rød" . ,(lambda (arg1 arg2) (my-rød arg1 arg2)))
    ("blå" . ,(lambda (arg1 arg2) (my-blå arg1 arg2)))
    ("lav" . ,(lambda (arg1 arg2) (my-lavt arg1 arg2)))
    ("fisk" . ,(lambda (arg1 arg2) (my-blå arg1 arg2)))
    ("er" . ,(lambda (arg1 arg2) (my-artikkel arg1 arg2)))
    ("en" . ,(lambda (arg1 arg2) (my-artikkel arg1 arg2)))
    ("og" . ,(lambda (arg1 arg2) (my-artikkel arg1 arg2)))
    ("å" . ,(lambda (arg1 arg2) (my-artikkel arg1 arg2)))
    ("i" . ,(lambda (arg1 arg2) (my-artikkel arg1 arg2)))
    ("til" . ,(lambda (arg1 arg2) (my-artikkel arg1 arg2)))
    ("år" . ,(lambda (arg1 arg2) (my-treig arg1 arg2)))
    ("noen" . ,(lambda (arg1 arg2) (my-to arg1 arg2)))
    ("to" . ,(lambda (arg1 arg2) (my-to arg1 arg2)))
    ("annen" . ,(lambda (arg1 arg2) (my-to arg1 arg2)))
    ))
