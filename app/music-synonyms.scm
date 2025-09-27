(format #t "music-synonyms started loading~%")

(define* (my-pause length-arg #:optional word-to-print wordclass)
  "Velklingende note"
  (let* (
	 (music
	  (string-append	   
	   (trim-lily 
	    (with-output-to-string
	      (lambda ()
		(display-lily-music
		 (durlist->rests
		  (* length-arg 0.25))))))))
	 (text
	  (string-append
	   "\n\\set Staff.midiInstrument = \\\"Bright Acoustic Piano\\\"\n" ;;midi program 1
	   "\\clef percussion\n"
	  "<>-\\markup \\fontsize #-1 {"
	  "\\override #'(font-name .
               \\\"Andika\\\") "
	  word-to-print
	  "}\n" music
	  )))
    (begin
      (format #t "legger inn pause~%~%")
      (cond ((equal? wordclass "NOUN")
	     (add-to-upper-inserts text)
	     (add-to-middle-inserts music)
	     (add-to-lower-inserts music))
	    ((equal? wordclass "VERB")
	     (add-to-upper-inserts music)
	     (add-to-middle-inserts text)
	     (add-to-lower-inserts music))
	    (else
	     (add-to-upper-inserts music)
	     (add-to-middle-inserts music)
	     (add-to-lower-inserts text))))
))


(define* (my-god length-arg #:optional word-to-print wordclass)
  "Velklingende note"
  (let* (
	 (total-dur (* length-arg 0.25))
	 (music
	  (string-append
	   ;;; CHANGE MIDI INSTRUMENT TO WEIRD SOUND
	   "\n\\set Staff.midiInstrument = \\\"Electric Grand Piano\\\"\n" ;; midi program 2
	   "\n\\clef treble\n"
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
		   (list total-dur))))))))
	 (text
	  (string-append
	music 
	"<>-\\markup {"
	word-to-print
	"}\n"))
	 (rests
	  (trim-lily 
	    (with-output-to-string
	      (lambda ()
		(display-lily-music
		 (durlist->rests
		  (* length-arg 0.25))))))))
    (begin
      (format #t "Kjører lily-input \"god\", legger inn bilde av iskrem.~%~%")
          (cond ((equal? wordclass "NOUN")
	     (add-to-upper-inserts text)
	     (add-to-middle-inserts rests)
	     (add-to-lower-inserts rests))
	    ((equal? wordclass "VERB")
	     (add-to-upper-inserts rests)
	     (add-to-middle-inserts text)
	     (add-to-lower-inserts rests))
	    (else
	     (add-to-upper-inserts rests)
	     (add-to-middle-inserts rests)
	     (add-to-lower-inserts text))))
	    ))

;; liten, mindre, små

(define* (my-liten length-arg #:optional word-to-print wordclass)
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
	   "\\set Staff.midiInstrument = \\\"Honky Tonk Piano\\\"\n" ;; midi program 3
	   "\\clef treble\n"
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
		  (* (expt 2 (inexact->exact (floor (/ (log length-arg) (log 2))))) 0.1875))))))))
	 (rests
	  (trim-lily 
	    (with-output-to-string
	      (lambda ()
		(display-lily-music
		 (durlist->rests
		  (* length-arg 0.25))))))))
    (begin
      (format #t "Bruker lilypond-insert \"liten\".  Kort, lys, note med pause etterpå.~%~%")
          (cond ((equal? wordclass "NOUN")
	     (add-to-upper-inserts music)
	     (add-to-middle-inserts rests)
	     (add-to-lower-inserts rests))
	    ((equal? wordclass "VERB")
	     (add-to-upper-inserts rests)
	     (add-to-middle-inserts music)
	     (add-to-lower-inserts rests))
	    (else
	     (add-to-upper-inserts rests)
	     (add-to-middle-inserts rests)
	     (add-to-lower-inserts music))))))

;; stor, gjev, vel

(define* (my-stor length-arg #:optional word-to-print wordclass)
  "Stor note"
  (let* (
	 (total-dur (* length-arg 0.25))
	 (possible-pitches (map (lambda (x) (+ 19 x)) '(0 2 4 6 7 9 10 12)))
	 (music
	  (string-append
	   	   ;;; CHANGE MIDI INSTRUMENT TO WEIRD SOUND
	   "\n\\set Staff.midiInstrument = \\\"Electric Piano 1\\\"\n" ;; midi program 4
	   "\\clef treble\n"
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
	    ))
	 (rests
	  (trim-lily 
	    (with-output-to-string
	      (lambda ()
		(display-lily-music
		 (durlist->rests
		  (* length-arg 0.25))))))))
    (begin
      (format #t "Bruker lilypond-insert \"stor\".  Lang, lys note harmonisert med kvinter.~%~%")
      (cond ((equal? wordclass "NOUN")
	     (add-to-upper-inserts music)
	     (add-to-middle-inserts rests)
	     (add-to-lower-inserts rests))
	    ((equal? wordclass "VERB")
	     (add-to-upper-inserts rests)
	     (add-to-middle-inserts music)
	     (add-to-lower-inserts rests))
	    (else
	     (add-to-upper-inserts rests)
	     (add-to-middle-inserts rests)
	     (add-to-lower-inserts music))))))



;; passe, bare, vanlig
(define* (my-rask length-arg #:optional word-to-print wordclass)
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
	 (music
	  (string-append
	   	   ;;; CHANGE MIDI INSTRUMENT TO WEIRD SOUND
	   "\n\\set Staff.midiInstrument = \\\"Electric Piano 2\\\"\n" ;; midi program 5
	   "\\clef treble\n"
	   "<>_\\markup \\smallCaps \\fontsize #4 {"
	   word-to-print
	   "}"
	   	   "\\magnifyMusic #6/7"
	    (with-output-to-string
	      (lambda ()
		(display-lily-music
		 (add-articulations
		 (add-slur
		  (pitchlist->lily
		   (map (lambda (x) (list-ref possible-pitches (random (length possible-pitches)))) durs)
		   durs)) "tenuto"))))))
	 (rests
	  (trim-lily 
	    (with-output-to-string
	      (lambda ()
		(display-lily-music
		 (durlist->rests
		  (* length-arg 0.25))))))))
    (begin
      (format #t "Bruker lilypond-insert \"rask\".  Kjapt, kromatisk löp.~%~%")
(cond ((equal? wordclass "NOUN")
	     (add-to-upper-inserts music)
	     (add-to-middle-inserts rests)
	     (add-to-lower-inserts rests))
	    ((equal? wordclass "VERB")
	     (add-to-upper-inserts rests)
	     (add-to-middle-inserts music)
	     (add-to-lower-inserts rests))
	    (else
	     (add-to-upper-inserts rests)
	     (add-to-middle-inserts rests)
	     (add-to-lower-inserts music)))
       )))

(define* (my-treig length-arg #:optional word-to-print wordclass)
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
	   "\\clef bass\n"
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
		   durs) 12))))))
	 (rests (trim-lily 
	    (with-output-to-string
	      (lambda ()
		(display-lily-music
		 (durlist->rests
		  (* length-arg 0.25))))))))
    (begin
      (format #t "Bruker lilypond-insert \"treig\".  Liten gamut, store avstander, harmonisert med oktaver.~%~%")
      (cond ((equal? wordclass "NOUN")
	     (add-to-upper-inserts music)
	     (add-to-middle-inserts rests)
	     (add-to-lower-inserts rests))
	    ((equal? wordclass "VERB")
	     (add-to-upper-inserts rests)
	     (add-to-middle-inserts music)
	     (add-to-lower-inserts rests))
	    (else
	     (add-to-upper-inserts rests)
	     (add-to-middle-inserts rests)
	     (add-to-lower-inserts music))))))

;; hell, stappa, tett

(define* (my-tett length-arg #:optional word-to-print wordclass)
  "Tette kromatiske noter"
  (let* (
	 (possible-durations '(1/16 1/32 1/16))
	 (total-dur (* length-arg 0.25))
	 (durs (let loop ((dur-list '()) (dur-sum 0))
		 (if (> dur-sum (* total-dur 0.5))
		     dur-list
		     (let ((new-dur (list-ref possible-durations (random (length possible-durations)))))
		       (loop (append dur-list (list new-dur))
			     (+ dur-sum new-dur))
		       ))))
	 (possible-pitches '(12 13 14 15 16 17 18 19 20))
	 (music
	  (string-append
	   "\n\\set Staff.midiInstrument = \\\"Clav\\\"\n" ;; midi program 7
	   "\\clef treble\n"
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
		  (* total-dur 0.25))))))))
	 (rests
	  (trim-lily 
	    (with-output-to-string
	      (lambda ()
		(display-lily-music
		 (durlist->rests
		  (* length-arg 0.25))))))))
    (begin
      (format #t "Bruker lilypond-insert \"tett\".  Raske, tette kromatiske bevegelser i mellomregistret.~%~%")
      (cond ((equal? wordclass "NOUN")
	     (add-to-upper-inserts music)
	     (add-to-middle-inserts rests)
	     (add-to-lower-inserts rests))
	    ((equal? wordclass "VERB")
	     (add-to-upper-inserts rests)
	     (add-to-middle-inserts music)
	     (add-to-lower-inserts rests))
	    (else
	     (add-to-upper-inserts rests)
	     (add-to-middle-inserts rests)
	     (add-to-lower-inserts music))))))

;; tom, lett, få

(define* (my-tom length-arg #:optional word-to-print wordclass)
  "Velklingende note"
  (let* (
	 (possible-durations '(0.25 0.5 0.125))
	 (total-dur (* length-arg 0.25))
	 (possible-pitches (map (lambda (x) (- x 12)) '(0 1 2 3 4 5 6 7)))

	 (music 
	  (string-append
	   "\n\\set Staff.midiInstrument = \\\"Celesta\\\"\n" ;; midi program 8
	   "\\clef bass\n"
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
	   ))
	 (rests
(trim-lily 
	    (with-output-to-string
	      (lambda ()
		(display-lily-music
		 (durlist->rests
		  (* length-arg 0.25))))))))
    (begin
      (format #t "Bruker lilypond-insert \"tom\" - kort oktavintervall omringa av pauser~%~%")
      (cond ((equal? wordclass "NOUN")
	     (add-to-upper-inserts music)
	     (add-to-middle-inserts rests)
	     (add-to-lower-inserts rests))
	    ((equal? wordclass "VERB")
	     (add-to-upper-inserts rests)
	     (add-to-middle-inserts music)
	     (add-to-lower-inserts rests))
	    (else
	     (add-to-upper-inserts rests)
	     (add-to-middle-inserts rests)
	     (add-to-lower-inserts music))))))


(define* (my-vit length-arg #:optional word-to-print wordclass)
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
	   "\\clef bass\n"
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
	   ))
	 (rests
	  (trim-lily 
	    (with-output-to-string
	      (lambda ()
		(display-lily-music
		 (durlist->rests
		  (* length-arg 0.25)))))
	    )))
    
    (begin
      (format #t "Bruker lilypond-insert \"vit\".  Flageolettnoter. ~%~%")
(cond ((equal? wordclass "NOUN")
	     (add-to-upper-inserts music)
	     (add-to-middle-inserts rests)
	     (add-to-lower-inserts rests))
	    ((equal? wordclass "VERB")
	     (add-to-upper-inserts rests)
	     (add-to-middle-inserts music)
	     (add-to-lower-inserts rests))
	    (else
	     (add-to-upper-inserts rests)
	     (add-to-middle-inserts rests)
	     (add-to-lower-inserts music))))))

(define* (my-svart length-arg #:optional word-to-print wordclass)
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
	   "\n\\clef treble"
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

	   ))
	 (rests (trim-lily 
	    (with-output-to-string
	      (lambda ()
		(display-lily-music
		 (durlist->rests
		  (* length-arg 0.25))))))))
    (begin
      (format #t "Bruker lilypond-insert \"svart\".  Svarte noter (clusterformasjoner).~%~%")
      (cond ((equal? wordclass "NOUN")
	     (add-to-upper-inserts music)
	     (add-to-middle-inserts rests)
	     (add-to-lower-inserts rests))
	    ((equal? wordclass "VERB")
	     (add-to-upper-inserts rests)
	     (add-to-middle-inserts music)
	     (add-to-lower-inserts rests))
	    (else
	     (add-to-upper-inserts rests)
	     (add-to-middle-inserts rests)
	     (add-to-lower-inserts music))))))

(define* (my-rød length-arg #:optional word-to-print wordclass)
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
	 (music
	  (string-append
	   "<>_\\markup {
	   \\with-color #yellow \\on-color #red \\pad-markup #0.2
\\\"" word-to-print "\\\"
	   }"
"\n\\clef bass"
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
	   ))
	 (rests (trim-lily 
	    (with-output-to-string
	      (lambda ()
		(display-lily-music
		 (durlist->rests
		  (* length-arg 0.25))))))))
    (begin
      (format #t "Bruker lilypond-insert \"rød\".  Røde noter med stakkatoprikker.~%~%")
(cond ((equal? wordclass "NOUN")
	     (add-to-upper-inserts music)
	     (add-to-middle-inserts rests)
	     (add-to-lower-inserts rests))
	    ((equal? wordclass "VERB")
	     (add-to-upper-inserts rests)
	     (add-to-middle-inserts music)
	     (add-to-lower-inserts rests))
	    (else
	     (add-to-upper-inserts rests)
	     (add-to-middle-inserts rests)
	     (add-to-lower-inserts music))))))

(define* (my-blå length-arg #:optional word-to-print wordclass)
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
	   "\n\\clef treble"
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
		   durs)))))
	   "\n\\revert NoteHead.color
  \\revert Stem.color
  \\revert Beam.color"
	   "\n\\revert NoteHead.style"	   
					;	 word-to-display
	   ))
	 (rests (trim-lily 
	    (with-output-to-string
	      (lambda ()
		(display-lily-music
		 (durlist->rests
		  (* length-arg 0.25))))))))
    (begin
      (format #t "Bruker lilypond-insert \"blå\".  Blåe skråe noter.~%~%")
      (cond ((equal? wordclass "NOUN")
	     (add-to-upper-inserts music)
	     (add-to-middle-inserts rests)
	     (add-to-lower-inserts rests))
	    ((equal? wordclass "VERB")
	     (add-to-upper-inserts rests)
	     (add-to-middle-inserts music)
	     (add-to-lower-inserts rests))
	    (else
	     (add-to-upper-inserts rests)
	     (add-to-middle-inserts rests)
	     (add-to-lower-inserts music))))))

(define* (my-gul length-arg #:optional word-to-print wordclass)
  "gul note"
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
	   "\n\\clef bass"
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
	   \\revert Beam.color"))
	    (rests (trim-lily 
	    (with-output-to-string
	      (lambda ()
		(display-lily-music
		 (durlist->rests
		  (* length-arg 0.25))))))))
    (begin
      (format #t "Bruker lilypond-insert \"gul\".  Gul note harmonisert med terser.~%~%")
      (cond ((equal? wordclass "NOUN")
	     (add-to-upper-inserts music)
	     (add-to-middle-inserts rests)
	     (add-to-lower-inserts rests))
	    ((equal? wordclass "VERB")
	     (add-to-upper-inserts rests)
	     (add-to-middle-inserts music)
	     (add-to-lower-inserts rests))
	    (else
	     (add-to-upper-inserts rests)
	     (add-to-middle-inserts rests)
	     (add-to-lower-inserts music))))))

(define* (my-grønn length-arg #:optional word-to-print wordclass)
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
	   "\n\\clef treble"
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
   ))
	 (rests (trim-lily 
	    (with-output-to-string
	      (lambda ()
		(display-lily-music
		 (durlist->rests
		  (* length-arg 0.25)))))
	    )))
    (begin
      (format #t "Bruker lilypond-insert \"grønn\".  Grønne kryssnoter.~%~%")
(cond ((equal? wordclass "NOUN")
	     (add-to-upper-inserts music)
	     (add-to-middle-inserts rests)
	     (add-to-lower-inserts rests))
	    ((equal? wordclass "VERB")
	     (add-to-upper-inserts rests)
	     (add-to-middle-inserts music)
	     (add-to-lower-inserts rests))
	    (else
	     (add-to-upper-inserts rests)
	     (add-to-middle-inserts rests)
	     (add-to-lower-inserts music)))
	    )))

(define* (my-lavt length-arg #:optional word-to-print wordclass)
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
	   "\n\\clef bass\n"
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
	   ))
	 (rests (trim-lily 
	    (with-output-to-string
	      (lambda ()
		(display-lily-music
		 (durlist->rests
		  (* length-arg 0.25)))))
	    )))
    (begin
      (format #t "Bruker lilypond-insert \"lav\".  Dyp note med oktavdobling.~%~%")
(cond ((equal? wordclass "NOUN")
	     (add-to-upper-inserts music)
	     (add-to-middle-inserts rests)
	     (add-to-lower-inserts rests))
	    ((equal? wordclass "VERB")
	     (add-to-upper-inserts rests)
	     (add-to-middle-inserts music)
	     (add-to-lower-inserts rests))
	    (else
	     (add-to-upper-inserts rests)
	     (add-to-middle-inserts rests)
	     (add-to-lower-inserts music))))))

(define* (my-høyt length-arg #:optional word-to-print wordclass)
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
	   "\n\\clef treble"
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

	   ))
	 (rests (trim-lily 
	    (with-output-to-string
	      (lambda ()
		(display-lily-music
		 (durlist->rests
		  (* length-arg 0.25)))))
	    )))
    (begin
      (format #t "Bruker lilypond-insert \"høyt\" med en høy velklingende note~%~%")
(cond ((equal? wordclass "NOUN")
	     (add-to-upper-inserts music)
	     (add-to-middle-inserts rests)
	     (add-to-lower-inserts rests))
	    ((equal? wordclass "VERB")
	     (add-to-upper-inserts rests)
	     (add-to-middle-inserts music)
	     (add-to-lower-inserts rests))
	    (else
	     (add-to-upper-inserts rests)
	     (add-to-middle-inserts rests)
	     (add-to-lower-inserts music)))
      )))


(define* (my-artikkel length-arg #:optional word-to-print wordclass)
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
	 (possible-pitches '((-2 2 5) (-2 1 5) (-3 0 5) (-4 0 5) (-4 1 5) (-3 2 5) (-3 1 5) (-4 -1 5) (-10 -6 -3) (-10 -7 -3) (-11 -8 -3) (-12 -8 -3) (-12 -7 -3) (-11 -6 -3) (-11 -7 -3) (-12 -9 -3)))

	 (music
	  (string-append
	   
	   "\n\\set Staff.midiInstrument = \\\"Percussive Organ\\\"\n" ;; midi program 17
	   "\\clef alto\n"
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
	   ))
	 (rests (trim-lily 
	    (with-output-to-string
	      (lambda ()
		(display-lily-music
		 (durlist->rests
		  (* length-arg 0.25)))))
	    )))
    (begin
      (format #t "Bruker lilypond-insert \"artikkel\" for artikler og småord~%~%")
(cond ((equal? wordclass "NOUN")
	     (add-to-upper-inserts music)
	     (add-to-middle-inserts rests)
	     (add-to-lower-inserts rests))
	    ((equal? wordclass "VERB")
	     (add-to-upper-inserts rests)
	     (add-to-middle-inserts music)
	     (add-to-lower-inserts rests))
	    (else
	     (add-to-upper-inserts rests)
	     (add-to-middle-inserts rests)
	     (add-to-lower-inserts music))))))

(define* (my-to length-arg #:optional word-to-print wordclass)
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
	   "\\clef bass\n"
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
	   ))
	 (rests (trim-lily 
	    (with-output-to-string
	      (lambda ()
		(display-lily-music
		 (durlist->rests
		  (* length-arg 0.25)))))
	    )))
    (begin
      (format #t "Bruker lilypond-insert \"to\".  To små noter~%~%")
(cond ((equal? wordclass "NOUN")
	     (add-to-upper-inserts music)
	     (add-to-middle-inserts rests)
	     (add-to-lower-inserts rests))
	    ((equal? wordclass "VERB")
	     (add-to-upper-inserts rests)
	     (add-to-middle-inserts music)
	     (add-to-lower-inserts rests))
	    (else
	     (add-to-upper-inserts rests)
	     (add-to-middle-inserts rests)
	     (add-to-lower-inserts music))))))

(define lilywords
  `(("best" . ,(lambda (arg1 arg2 arg3) (my-god arg1 arg2 arg3)))
    ("liten" . ,(lambda (arg1 arg2 arg3) (my-liten arg1 arg2 arg3)))
    ("stor" . ,(lambda (arg1 arg2 arg3) (my-stor arg1 arg2 arg3)))
    ("stort" . ,(lambda (arg1 arg2 arg3) (my-stor arg1 arg2 arg3)))
;    ("de" . ,(lambda (arg1 arg2 arg3) (my-tett arg1 arg2 arg3)))
    ("inne" . ,(lambda (arg1 arg2 arg3) (my-tett arg1 arg2 arg3)))
    ("holde" . ,(lambda (arg1 arg2 arg3) (my-tett arg1 arg2 arg3)))
    ("mot" . ,(lambda (arg1 arg2 arg3) (my-rød arg1 arg2 arg3)))
    ("alt" . ,(lambda (arg1 arg2 arg3) (my-tett arg1 arg2 arg3)))
    ("vis" . ,(lambda (arg1 arg2 arg3) (my-stor arg1 arg2 arg3)))
    ("disse" . ,(lambda (arg1 arg2 arg3) (my-tett arg1 arg2 arg3)))
    ("god" . ,(lambda (arg1 arg2 arg3) (my-god arg1 arg2 arg3)))
    ("godt" . ,(lambda (arg1 arg2 arg3) (my-god arg1 arg2 arg3)))
    ("bra" . ,(lambda (arg1 arg2 arg3) (my-god arg1 arg2 arg3)))
    ("nettopp" . ,(lambda (arg1 arg2 arg3) (my-rask arg1 arg2 arg3)))
    ("vel" . ,(lambda (arg1 arg2 arg3) (my-god arg1 arg2 arg3)))
    ("heller" . ,(lambda (arg1 arg2 arg3) (my-høyt arg1 arg2 arg3)))
    ("opp" . ,(lambda (arg1 arg2 arg3) (my-høyt arg1 arg2 arg3)))
    ("possessiv" . ,(lambda (arg1 arg2 arg3) (my-tett arg1 arg2 arg3)))
    ("bedre" . ,(lambda (arg1 arg2 arg3) (my-god arg1 arg2 arg3)))
    ("mann" . ,(lambda (arg1 arg2 arg3) (my-gul arg1 arg2 arg3)))
    ("minst" . ,(lambda (arg1 arg2 arg3) (my-liten arg1 arg2 arg3)))
    ("mindre" . ,(lambda (arg1 arg2 arg3) (my-liten arg1 arg2 arg3)))
    ("ennå" . ,(lambda (arg1 arg2 arg3) (my-rask arg1 arg2 arg3)))
    ("da" . ,(lambda (arg1 arg2 arg3) (my-treig arg1 arg2 arg3)))
    ("stå" . ,(lambda (arg1 arg2 arg3) (my-høyt arg1 arg2 arg3)))
    ("hun" . ,(lambda (arg1 arg2 arg3) (my-gul arg1 arg2 arg3)))
    ("han" . ,(lambda (arg1 arg2 arg3) (my-gul arg1 arg2 arg3)))
    ("nok" . ,(lambda (arg1 arg2 arg3) (my-artikkel arg1 arg2 arg3)))
    ("herre" . ,(lambda (arg1 arg2 arg3) (my-gul arg1 arg2 arg3)))
    ("foran" . ,(lambda (arg1 arg2 arg3) (my-rask arg1 arg2 arg3)))
    ("bak" . ,(lambda (arg1 arg2 arg3) (my-treig arg1 arg2 arg3)))
    ("framfor" . ,(lambda (arg1 arg2 arg3) (my-rask arg1 arg2 arg3)))
    ("meget" . ,(lambda (arg1 arg2 arg3) (my-god arg1 arg2 arg3)))
    ("man" . ,(lambda (arg1 arg2 arg3) (my-gul arg1 arg2 arg3)))
    ("oss" . ,(lambda (arg1 arg2 arg3) (my-gul arg1 arg2 arg3)))
    ("vente" . ,(lambda (arg1 arg2 arg3) (my-treig arg1 arg2 arg3)))
    ("tydelig" . ,(lambda (arg1 arg2 arg3) (my-rød arg1 arg2 arg3)))
    ("måtte" . ,(lambda (arg1 arg2 arg3) (my-rask arg1 arg2 arg3)))
    ("menneske" . ,(lambda (arg1 arg2 arg3) (my-gul arg1 arg2 arg3)))
    ("mer" . ,(lambda (arg1 arg2 arg3) (my-tett arg1 arg2 arg3)))
    ("oppe" . ,(lambda (arg1 arg2 arg3) (my-høyt arg1 arg2 arg3)))
    ("rett" . ,(lambda (arg1 arg2 arg3) (my-stor arg1 arg2 arg3)))
    ("viss" . ,(lambda (arg1 arg2 arg3) (my-treig arg1 arg2 arg3)))
    ("vesle" . ,(lambda (arg1 arg2 arg3) (my-liten arg1 arg2 arg3)))
    ("glad" . ,(lambda (arg1 arg2 arg3) (my-god arg1 arg2 arg3)))
    ("ad" . ,(lambda (arg1 arg2 arg3) (my-tett arg1 arg2 arg3)))
    ("nå" . ,(lambda (arg1 arg2 arg3) (my-rask arg1 arg2 arg3)))
    ("ren" . ,(lambda (arg1 arg2 arg3) (my-tom arg1 arg2 arg3)))
    ("borte" . ,(lambda (arg1 arg2 arg3) (my-tom arg1 arg2 arg3)))
    ("ute" . ,(lambda (arg1 arg2 arg3) (my-grønn arg1 arg2 arg3)))
    ("ned" . ,(lambda (arg1 arg2 arg3) (my-lavt arg1 arg2 arg3)))
    ("bort" . ,(lambda (arg1 arg2 arg3) (my-liten arg1 arg2 arg3)))
    ("lett" . ,(lambda (arg1 arg2 arg3) (my-tom arg1 arg2 arg3)))
    ("mørke" . ,(lambda (arg1 arg2 arg3) (my-svart arg1 arg2 arg3)))
    ("mørk" . ,(lambda (arg1 arg2 arg3) (my-svart arg1 arg2 arg3)))
    ("lys" . ,(lambda (arg1 arg2 arg3) (my-vit arg1 arg2 arg3)))
    ("ikke" . ,(lambda (arg1 arg2 arg3) (my-høyt arg1 arg2 arg3)))
    ("fin" . ,(lambda (arg1 arg2 arg3) (my-liten arg1 arg2 arg3)))
    ("herlig" . ,(lambda (arg1 arg2 arg3) (my-liten arg1 arg2 arg3)))
    ("fine" . ,(lambda (arg1 arg2 arg3) (my-liten arg1 arg2 arg3)))   
    ("se" . ,(lambda (arg1 arg2 arg3) (my-høyt arg1 arg2 arg3)))
    ("full" . ,(lambda (arg1 arg2 arg3) (my-tett arg1 arg2 arg3)))
    ("helt" . ,(lambda (arg1 arg2 arg3) (my-tett arg1 arg2 arg3)))
    ("hel" . ,(lambda (arg1 arg2 arg3) (my-tett arg1 arg2 arg3)))    
    ("tett" . ,(lambda (arg1 arg2 arg3) (my-tett arg1 arg2 arg3)))
    ("mange" . ,(lambda (arg1 arg2 arg3) (my-tett arg1 arg2 arg3)))
    ("jevn" . ,(lambda (arg1 arg2 arg3) (my-tett arg1 arg2 arg3)))
    ("rask" . ,(lambda (arg1 arg2 arg3) (my-rask arg1 arg2 arg3)))
    ("fort" . ,(lambda (arg1 arg2 arg3) (my-rask arg1 arg2 arg3)))
    ("treig" . ,(lambda (arg1 arg2 arg3) (my-treig arg1 arg2 arg3)))
    ("langsom" . ,(lambda (arg1 arg2 arg3) (my-treig arg1 arg2 arg3)))
    ("tom" . ,(lambda (arg1 arg2 arg3) (my-tom arg1 arg2 arg3)))
    ("hvit" . ,(lambda (arg1 arg2 arg3) (my-vit arg1 arg2 arg3)))
    ("snø" . ,(lambda (arg1 arg2 arg3) (my-vit arg1 arg2 arg3)))
    ("ski" . ,(lambda (arg1 arg2 arg3) (my-vit arg1 arg2 arg3)))
    ("svart" . ,(lambda (arg1 arg2 arg3) (my-svart arg1 arg2 arg3)))
    ("rød" . ,(lambda (arg1 arg2 arg3) (my-rød arg1 arg2 arg3)))
    ("blå" . ,(lambda (arg1 arg2 arg3) (my-blå arg1 arg2 arg3)))
    ("lav" . ,(lambda (arg1 arg2 arg3) (my-lavt arg1 arg2 arg3)))
    ("fisk" . ,(lambda (arg1 arg2 arg3) (my-blå arg1 arg2 arg3)))
    ("er" . ,(lambda (arg1 arg2 arg3) (my-artikkel arg1 arg2 arg3)))
    ("en" . ,(lambda (arg1 arg2 arg3) (my-artikkel arg1 arg2 arg3)))
    ("og" . ,(lambda (arg1 arg2 arg3) (my-artikkel arg1 arg2 arg3)))
    ("å" . ,(lambda (arg1 arg2 arg3) (my-artikkel arg1 arg2 arg3)))
    ("i" . ,(lambda (arg1 arg2 arg3) (my-artikkel arg1 arg2 arg3)))
    ("til" . ,(lambda (arg1 arg2 arg3) (my-artikkel arg1 arg2 arg3)))
    ("år" . ,(lambda (arg1 arg2 arg3) (my-treig arg1 arg2 arg3)))
    ("noen" . ,(lambda (arg1 arg2 arg3) (my-to arg1 arg2 arg3)))
    ("to" . ,(lambda (arg1 arg2 arg3) (my-to arg1 arg2 arg3)))
    ("annen" . ,(lambda (arg1 arg2 arg3) (my-to arg1 arg2 arg3)))
    ))
