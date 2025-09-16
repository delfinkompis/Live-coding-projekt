(use-modules (srfi srfi-1))
(use-modules (guile-user))

(import (ice-9 popen))
(import (ice-9 rdelim))
(import (ice-9 threads))
(import (lily))
(set! %load-path (cons "/opt/guile/share/guile/site/2.2/" %load-path))
(import (fibers))
(import (fibers channels))
(load "repl-variabler.scm")

(define (trim-lily s)
  (string-top-tail (string-top s)))

(define* (my-ly-play-and-display ly-file csd-instrument #:optional type-arg)
  "Display a lilypond file (arg1) as a pdf arg play it using a specified csound instrument (arg2)
if &optional = 0, display only pdf.  If &optional = 1, play only sound., if 2, do both"
  (cond ((= type-arg 0)
	 (begin
	   (system (string-append "GUILE_AUTO_COMPILE=0 lilypond " "-dno-point-and-click --loglevel=NONE --output=ly-display " ly-file))
	   ))
	((= type-arg 1)
	 (begin
	   (system (string-append "sed -i '$a\\\\bookOutputSuffix \" " ly-file " \"\n\\midi {}' temp.ly"))
	   (system (string-append "GUILE_AUTO_COMPILE=0 lilypond " "-dpreview=no -dno-print-pages -dno-point-and-click --output=ly-display" ly-file))
	   (system (string-append "csound -F " ly-file ".mid " csd-instrument ".csd"))
	   ))

	(else
	 (begin
	   (system (string-append "sed -i '$a\\\\bookOutputSuffix \"" ly-file "\"\n\\midi {}' temp.ly"))
	   (system (string-append "GUILE_AUTO_COMPILE=0 lilypond " "-dno-point-and-click --output=ly-display" ly-file))
	   (system (string-append "csound -F " ly-file ".mid " csd-instrument ".csd"))
	   ))
	))







					;% (define sorter gjennom kategori i ordbokapi)

(use-modules (fibers) (fibers scheduler))

(define new-wordlist '("a" "b" "c"))
(define old-wordlist '("a" "b" "c"))

(define file-cache (make-hash-table))

(define (my-read-file-cached file-name)
  (let ((last-modified (stat:mtime (stat file-name))))
    (let ((cached (hash-ref file-cache file-name)))
      (if (and cached (= (car cached) last-modified))
          (cdr cached)  ; Return cached result
          (let ((result (my-read-file file-name)))
            (hash-set! file-cache file-name (cons last-modified result))
            result)))))

(define lily-output-cache (make-hash-table))

(define (cached-word->lily word length original-word)
  "Cache lily output to avoid regenerating identical music"
  (let ((cache-key (list word length)))
    (or (hash-ref lily-output-cache cache-key)
        (let ((result (word->lily-uncached word length original-word)))
          (hash-set! lily-output-cache cache-key result)
          result))))

;; Use string ports instead of repeated concatenation
(define music-inserts-upper-port (open-output-string))
(define music-inserts-lower-port (open-output-string))

(define (add-to-upper-inserts music)
  (display music music-inserts-upper-port))

(define (add-to-lower-inserts music)
  (display music music-inserts-lower-port))

(define (get-upper-inserts)
  (get-output-string music-inserts-upper-port))

(define (get-lower-inserts)
  (get-output-string music-inserts-lower-port))


(define (batch-operations operations)
  ""
  (let ((batch-command (string-join operations " && ")))
    (system batch-command)))

(define (my-monitor file-name)
  (let
      ((new-wordlist (filter (lambda (x) (not (equal? x ""))) (my-read-file-cached "./input.txt"))))
    (when (> (length new-wordlist) (length old-wordlist))
	  (let* ((words-to-process (take-right new-wordlist (- (length new-wordlist) (length old-wordlist))))
		 (operations (map (lambda (word) 
                                    (word->lily (string-downcase word))) 
				  words-to-process)))
	      (format #t "Kompilerer lilypond~%")
	      (batch-operations
	       (list (string-append "./insert-music.sh " "./upper.ily" " \"" (get-upper-inserts) " \"")
	       (string-append "./insert-music.sh " "./lower.ily" " \"" (get-lower-inserts) " \"")
	       (string-append "GUILE_AUTO_COMPILE=0 lilypond -dno-point-and-click --loglevel=NONE --output=ly-display ./main.ly")))
	    (format #t "Ferdig med å kompilere lilypond~%~%")
	    )
	  )
  (set! old-wordlist new-wordlist)))

(define synonym-cache (make-hash-table))


(define (my-fetch-synonyms ord)
  (or (hash-ref synonym-cache ord)
      (let* ((port (open-input-pipe (string-append "./grep-fetch-synonyms.sh " ord)))
             (str (read-string port))
             (result (string-split str #\newline)))
        (close-pipe port)
        (hash-set! synonym-cache ord result)
        result)))


;; SEARCH FOR STRING IN INPUT.TXT
;; take new elements

(define (group-list ls sep filter)
  (letrec ((iter (lambda (ls0 ls1)
		   (cond
		    ((null? ls0) (list ls1))
		    ((eqv? (car ls0) sep) 
		     (cons ls1 (iter (cdr ls0) '())))
		    ((eqv? (car ls0) filter)
                     (iter (cdr ls0) ls1))
		    (else (iter (cdr ls0) (cons (car ls0) ls1)))))))
    (map reverse (iter ls '()))))


(define (my-read-file file-name)
  (with-input-from-file file-name
    (lambda ()
      (let loop((ls1 '()) (c (read-char)))
	(if (eof-object? c)
	    (map list->string (group-list (reverse ls1) #\space #\newline)) 
	    (loop (cons c ls1) (read-char)))))))

;; TODO give lily-commands lengde-argument som speiler antall bokstaver i ord
(define* (word->lily ord #:optional (counter 0) (original-word-length (string-length ord)) (original-word ord))
  (if (member ord (map car lilywords))
      (let ((func (assoc-ref lilywords ord)))
	(begin (format #t "Lager lilypond input av synonymet ~a. Opprinelig ord hadde ~d bokstaver.'~%" ord original-word-length) (func original-word-length original-word)))
      (let* ((synonym-list (remove "" (my-fetch-synonyms ord)))
	     (available-lilywords (lset-intersection equal? synonym-list (map car lilywords))))
	;; om det finns lily-kommando, kör kommandon
	(if (not (null? available-lilywords))
	    (let ((func (assoc-ref lilywords (car available-lilywords))))
	      (begin (format #t "Lager lilyscript input av synonymet ~a. Opprinelig ord hadde ~d bokstaver.~%" ord original-word-length)
		     (func original-word-length original-word)))
	    ;; ELSE, om counter är låg, försök igen
	    (if (null? synonym-list)
		(begin
		  (format #t "Fant ingen passende synonymer.  Legger inn en ~d lang pause.~%~%" original-word-length)
		  (my-pause original-word-length original-word)
		  )
		(if (<= counter 5)
		    (let ((synonym (list-ref synonym-list (random (length synonym-list)))))
		      (format #t "Prøver igjen for ~d. gang.  Bruker nå synonymet ~a.~%" (+ 1 counter) synonym)
		      (word->lily synonym (+ counter 1) original-word-length original-word))
		    (begin
		      (format #t "Fant ingen passende synonymer.  Legger inn en ~d lang pause.~%~%" original-word-length)
		  (my-pause original-word-length original-word)		      
		      )
		    
		    )

		)))))

;; tilslut, om inget annat går, RETURN ingenting


(define (check-new-words file-name)
  (begin  
    (set! new-wordlist (filter (lambda (x) (not (equal? x ""))) (my-read-file-cached "./input.txt")))
    (begin
      (display new-wordlist)
      (let ((new-wordcount (- (length new-wordlist) (length old-wordlist))))
	(if (<= new-wordcount 0) (format #t "ingen nye ord")
	    (let ((wordlist (take-right new-wordlist new-wordcount)))
	      (map (lambda (word) (word->lily (string-downcase word))) wordlist))
	    )
	))
    (set! old-wordlist new-wordlist)
    ))


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
	  "<>-\\markup \\fontsize #5 {"
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
	   	   ;;; CHANGE MIDI INSTRUMENT BACK
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
	"}\n" "\"")))
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
		 (if (> dur-sum total-dur)
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
	   "\\magnifyMusic #7/5"
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

	   "<>_\\markup \\smallCaps \\fontsize #4 {"
	   word-to-print
	   "}"
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
		 (if (> dur-sum total-dur)
		     dur-list
		     (let ((new-dur (list-ref possible-durations (random (length possible-durations)))))
		       (loop (append dur-list (list new-dur))
			     (+ dur-sum new-dur))
		       ))))
	 (possible-pitches (map (lambda (x) (- x 24)) '(0 7 9 16 13)))
	 (music
	  (string-append
	   "<>_\\markup \\fontsize #3 {
	      \\override #'(font-name .
               \\\"Courier\\\")"
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
		 (if (> dur-sum total-dur)
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

	   "<>^\\markup \\fontsize #1 { 
	   	     \\override #'(font-name .
               \\\"Latin modern sans demi cond\\\")"
	   word-to-print
	   " }"
	   
	   "\\magnifyMusic #11/10\n"
	    (with-output-to-string
	      (lambda ()
		(display-lily-music
		 (add-articulations
		  (pitchlist->lily
		   (map (lambda (x) (list-ref possible-pitches (random (length possible-pitches)))) durs)
		   durs) "tenuto"))))

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


;;;
(define* (my-vit length-arg #:optional word-to-print)
  "Hvite noter (flageolettnotasjon)"
  (let* (
	 (possible-durations '(0.25 0.5 0.125))
	 (total-dur (* length-arg 0.25))
	 (possible-pitches '(0 1 2 3 4 5 0 0 4))
	 (durs (let loop ((dur-list '()) (dur-sum 0))
		 (if (> dur-sum total-dur)
		     dur-list
		     (let ((new-dur (list-ref possible-durations (random (length possible-durations)))))
		       (loop (append dur-list (list new-dur))
			     (+ dur-sum new-dur))
		       ))))
	 (output-file "upper.ily")
(other-file "lower.ily")
	 (music
	  (string-append
	   "\\harmonicsOn\n"
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
	   "<>_\\markup {
	   	     \\override #'(font-name .
               \\\"Comic Neue, Bold\\\")"
	   word-to-print
	   "}"
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
	   "<>_\\markup \\fontsize #1 { 
	   	     \\override #'(font-name .
               \\\"Cabin, Oblique Bold\\\")
	    \\with-color #white \\on-color #black \\pad-markup #0.2
	   \\\"" word-to-print "\\\"
	    }"
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
		 (if (> dur-sum total-dur)
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
		 (if (> dur-sum total-dur)
		     dur-list
		     (let ((new-dur (list-ref possible-durations (random (length possible-durations)))))
		       (loop (append dur-list (list new-dur))
			     (+ dur-sum new-dur))
		       ))))
	 
	 (output-file "upper.ily")
(other-file "lower.ily")
	 (music
	  (string-append
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
		 (if (> dur-sum total-dur)
		     dur-list
		     (let ((new-dur (list-ref possible-durations (random (length possible-durations)))))
		       (loop (append dur-list (list new-dur))
			     (+ dur-sum new-dur))
		       ))))
	 

	 (music
	  (string-append
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
		 (if (> dur-sum total-dur)
		     dur-list
		     (let ((new-dur (list-ref possible-durations (random (length possible-durations)))))
		       (loop (append dur-list (list new-dur))
			     (+ dur-sum new-dur))
		       ))))
	 
	 (music
	  (string-append
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
		 (if (> dur-sum total-dur)
		     dur-list
		     (let ((new-dur (list-ref possible-durations (random (length possible-durations)))))
		       (loop (append dur-list (list new-dur))
			     (+ dur-sum new-dur))
		       ))))
	 (output-file "lower.ily")
(other-file "upper.ily")
	 (music
	  (string-append
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
	   "<>_\\markup \\italic \\box \\lower #4 \\fontsize #-2  { \""
	   word-to-print
	   "\" }"
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
		 (if (> dur-sum total-dur)
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
    ("nok" . ,(lambda (arg1 arg2) (my-tett arg1 arg2)))
    ("herre" . ,(lambda (arg1 arg2) (my-gul arg1 arg2)))
    ("foran" . ,(lambda (arg1 arg2) (my-rask arg1 arg2)))
    ("bak" . ,(lambda (arg1 arg2) (my-treig arg1 arg2)))
    ("framfor" . ,(lambda (arg1 arg2) (my-rask arg1 arg2)))
    ("meget" . ,(lambda (arg1 arg2) (my-god arg1 arg2)))
    ("man" . ,(lambda (arg1 arg2) (my-gul arg1 arg2)))
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
    ("fine" . ,(lambda (arg1 arg2) (my-liten arg1 arg2)))   
    ("se" . ,(lambda (arg1 arg2) (my-høyt arg1 arg2)))
    ("full" . ,(lambda (arg1 arg2) (my-tett arg1 arg2)))
    ("tett" . ,(lambda (arg1 arg2) (my-tett arg1 arg2)))
    ("rask" . ,(lambda (arg1 arg2) (my-rask arg1 arg2)))
    ("fort" . ,(lambda (arg1 arg2) (my-rask arg1 arg2)))
    ("treig" . ,(lambda (arg1 arg2) (my-treig arg1 arg2)))
    ("langsom" . ,(lambda (arg1 arg2) (my-treig arg1 arg2)))
    ("tom" . ,(lambda (arg1 arg2) (my-tom arg1 arg2)))
    ("hvit" . ,(lambda (arg1 arg2) (my-vit arg1 arg2)))
    ("svart" . ,(lambda (arg1 arg2) (my-svart arg1 arg2)))
    ("rød" . ,(lambda (arg1 arg2) (my-rød arg1 arg2)))
    ("blå" . ,(lambda (arg1 arg2) (my-blå arg1 arg2)))
    ("lav" . ,(lambda (arg1 arg2) (my-lavt arg1 arg2)))
    ("fisk" . ,(lambda (arg1 arg2) (my-blå arg1 arg2)))
    ))


