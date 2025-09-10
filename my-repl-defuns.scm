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
					;(set! %load-path (cons "/usr/share/lilypond/2.24.4/" %load-path))
					;(set! %load-path (cons "/home/hjallis/Projektfiler/Live-coding-projekt/" %load-path))

;;TODO, ersätt total-dur-multiplier med konstant

;;hjelpefunksjon for å ta vekk den første og de siste to karakterene i streng (ta bort formateringa rundt display-lily uttrykkene)










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



(define (my-monitor file-name)
  (let
      ((new-wordlist (filter (lambda (x) (not (equal? x ""))) (my-read-file "./input.txt"))))
    (if (> (length new-wordlist) (length old-wordlist))
	  (let* ((words-to-process (take-right new-wordlist (- (length new-wordlist) (length old-wordlist))))
		 (operations (map (lambda (word) 
                                    (word->lily (string-downcase word))) 
				  words-to-process)))
	    (format #t "Kompilerer lilypond~%")
	    (my-ly-play-and-display "./main.ly" "a" 0)
	    (format #t "Ferdig med å kompilere lilypond~%~%")
	    )
	  (format #t "ingen nye ord")))
  
  (set! old-wordlist new-wordlist)
   
    )


					;(define scheduler-thread
					;  (call-with-new-thread
					;    (lambda () (run-fibers scheduler))))


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
    (set! new-wordlist (filter (lambda (x) (not (equal? x ""))) (my-read-file "./input.txt")))
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






					;(define (my-get-strings)
;; de n siste element i nye listen over ord som ikke er del av den gamle lista


					;((new-elements (take-right new-list (- (length new-list) (length old-list))))
;; sjekk alle nye ord
;; (map (lambda (ord)



;; (if 


;; ;; gi en pause ellers
;; (min-pause)


;; (new-elements))

;; (new e)
;; ()




;; OM STRENGEN MATCHER ET AV ORDENE MED TILHØRENDE LILYPOND-MAKRO, KJØR MAKROEN
					;(system (string-append "" ly-file))
;; OM STRING MATCHER ET ARTIKKELNAVN I ORDBØKENE, VELG EN AV ARTIKLENE

;;;; OM ET AV SYNONYMENE MATCHER ET AV ORDENE MED TILHØRENDE LILYPOND-MAKRO, KJØR DENNE MAKROEN

;;;; ELLERS, PRØVE Å SØKE OPP SYNONYMET, OG SJEKK VIDERE ETTER LILYPOND-MAKRO

;;;; OM ORDET IKKE HAR SYNONYMER, SJEKK OPP OM EN DEL AV DEFINISJONEN MATCHER EN LILYPOND MAKRO

;;;;; ELLERS, PRØVE Å SØKE OPP DEFINISJONEN, OG SJEKK VIDERE ETTER LILYPOND-MAKRO,

;; OM MASKINEN HAR PRØVD 5+ GANGER OG FEILET, GI OPP OG PRINTT EN PAUSE I NOTENE



;;;; OM ET AV ORDENE  


;; ELSE, return a rest;




;;; lilypond-kommandon shortlist

;; lys
;; 
;;rett
;; gal


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
      (system (string-append "./insert-music.sh " output-file " \"" music "\""))
      (system (string-append "./insert-music.sh " other-file " \"" (trim-lily 
	    (with-output-to-string
	      (lambda ()
		(display-lily-music
		 (durlist->rests
		  (* length-arg 0.25)))))
	    ) "\""))
      )))






;; stor, gjev, vel

(define* (my-stor length-arg #:optional word-to-print)
  "Stor note"
  (let* (
	 (total-dur (* length-arg 0.25))
	 (possible-pitches (map (lambda (x) (+ 19 x)) '(0 2 4 6 7 9 10 12)))
	 (output-file "upper.ily")
(other-file "lower.ily")
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
(system (string-append "./insert-music.sh " output-file " \"" music "\""))
 (system (string-append "./insert-music.sh " other-file " \"" (trim-lily 
	    (with-output-to-string
	      (lambda ()
		(display-lily-music
		 (durlist->rests
		  (* length-arg 0.25)))))
	    ) "\""))
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

	   "<>_\\markup {"
	   word-to-print
	   "}"
	   )))
    (begin
      (format #t "Bruker lilypond-insert \"rask\".  Kjapt, kromatisk löp.~%~%")
(system (string-append "./insert-music.sh " output-file " \"" music "\""))
 (system (string-append "./insert-music.sh " other-file " \"" (trim-lily 
	    (with-output-to-string
	      (lambda ()
		(display-lily-music
		 (durlist->rests
		  (* length-arg 0.25)))))
	    ) "\""))
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
	 (output-file "lower.ily")
(other-file "upper.ily")
	 (music
	  (string-append
	   "\\magnifyMusic #7/5\n"
	    (with-output-to-string
	      (lambda ()
		(display-lily-music
		 (make-harmony
		  (pitchlist->lily
		   (map (lambda (x) (list-ref possible-pitches (random (length possible-pitches)))) durs)
		   durs) 12))))
	   "<>_\\markup {"
	   word-to-print
	   "}"
	   )))
    (begin
      (format #t "Bruker lilypond-insert \"treig\".  Liten gamut, store avstander, harmonisert med oktaver.~%~%")
(system (string-append "./insert-music.sh " output-file " \"" music "\""))
 (system (string-append "./insert-music.sh " other-file " \"" (trim-lily 
	    (with-output-to-string
	      (lambda ()
		(display-lily-music
		 (durlist->rests
		  (* length-arg 0.25)))))
	    ) "\""))
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
	   	   "<>^\\markup { "
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
(system (string-append "./insert-music.sh " output-file " \"" music "\""))
 (system (string-append "./insert-music.sh " other-file " \"" (trim-lily 
	    (with-output-to-string
	      (lambda ()
		(display-lily-music
		 (durlist->rests
		  (* length-arg 0.25)))))
	    ) "\""))
      )))
;; tom, lett, 

(define* (my-tom length-arg #:optional word-to-print)
  "Velklingende note"
  (let* (
	 (possible-durations '(0.25 0.5 0.125))
	 (total-dur (* length-arg 0.25))
	 (possible-pitches (map (lambda (x) (- x 12)) '(0 1 2 3 4 5 6 7)))
	 (output-file "upper.ily")
(other-file "lower.ily")
;	 (pause-file "lower.ily")
	 (music
	  
	  (string-append
	   (trim-lily 
	    (with-output-to-string
	      (lambda ()
		(display-lily-music
		 (durlist->rests
		  (* total-dur 1/3)))))
	    )

	   "\\magnifyMusic #5/7\n"
	   (with-output-to-string
	      (lambda ()
		(display-lily-music
		 (add-articulations  
		  (make-harmony
		  (pitchlist->lily
		   (list-ref possible-pitches (random (length possible-pitches)))
		   (list (* total-dur 1/6))) 12) "staccato"))))
	   "<>^\\markup {"
	   word-to-print
	   "}"
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
(system (string-append "./insert-music.sh " output-file " \"" music "\""))
 (system (string-append "./insert-music.sh " other-file " \"" (trim-lily 
	    (with-output-to-string
	      (lambda ()
		(display-lily-music
		 (durlist->rests
		  (* length-arg 0.25)))))
	    ) "\""))
;      (system (string-append "./insert-music.sh " pause-file " \"" (with-output-to-string (durlist->rests length-arg)) "\""))
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
	   "<>^\\markup {"
	   word-to-print
	   "}"
	   "\\harmonicsOff\n"
	   )))
    (begin
      (format #t "Bruker lilypond-insert \"vit\".  Flageolettnoter. ~%~%")
(system (string-append "./insert-music.sh " output-file " \"" music "\""))
 (system (string-append "./insert-music.sh " other-file " \"" (trim-lily 
	    (with-output-to-string
	      (lambda ()
		(display-lily-music
		 (durlist->rests
		  (* length-arg 0.25)))))
	    ) "\""))
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
	 
	   "<>_\\markup { \""
	   word-to-print
	   "\" }"
	   )))
    (begin
      (format #t "Bruker lilypond-insert \"svart\".  Svarte noter (clusterformasjoner).~%~%")
(system (string-append "./insert-music.sh " output-file " \"" music "\""))
 (system (string-append "./insert-music.sh " other-file " \"" (trim-lily 
	    (with-output-to-string
	      (lambda ()
		(display-lily-music
		 (durlist->rests
		  (* length-arg 0.25)))))
	    ) "\""))
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
	   "\\override NoteHead.color = #red\n"
	   
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
	   "\n<>_\\markup { "
	   word-to-print
	   "}"
	   "\n\\revert NoteHead.color\n"
	   )))
    (begin
      (format #t "Bruker lilypond-insert \"rød\".  Røde noter med stakkatoprikker.~%~%")
(system (string-append "./insert-music.sh " output-file " \"" music "\""))
 (system (string-append "./insert-music.sh " other-file " \"" (trim-lily 
	    (with-output-to-string
	      (lambda ()
		(display-lily-music
		 (durlist->rests
		  (* length-arg 0.25)))))
	    ) "\""))
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
	   "\\override NoteHead.color = #blue\n"
	   "\\override NoteHead.style = #'slash\n"
	   (trim-lily 
	    (with-output-to-string
	      (lambda ()
		(display-lily-music
		  (pitchlist->lily
		   (map (lambda (x) (list-ref possible-pitches (random (length possible-pitches)))) durs)
		   durs))))
	    )
	   "\n\\revert NoteHead.color"
	   "\n\\revert NoteHead.style"	   
					;	 word-to-display
	   )))
    (begin
            (format #t "Bruker lilypond-insert \"blå\".  Blåe skråe noter.~%~%")
(system (string-append "./insert-music.sh " output-file " \"" music "\""))
 (system (string-append "./insert-music.sh " other-file " \"" (trim-lily 
	    (with-output-to-string
	      (lambda ()
		(display-lily-music
		 (durlist->rests
		  (* length-arg 0.25)))))
	    ) "\""))

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
	 
	 (output-file "lower.ily")
(other-file "upper.ily")
	 (music
	  (string-append
	   "\\override NoteHead.color = #yellow\n"
	   
	   (trim-lily 
	    (with-output-to-string
	      (lambda ()
		(display-lily-music
		 (make-harmony  
		   (pitchlist->lily
		    (map (lambda (x) (list-ref possible-pitches (random (length possible-pitches)))) durs)
		    durs) 16))))
	      )
	    "<>_\\markup {"
	    word-to-print
	    "}"
	    	   "\n\\revert NoteHead.color"
	    )))
    (begin
      (format #t "Bruker lilypond-insert \"gul\".  Gul note harmonisert med terser.~%~%")
(system (string-append "./insert-music.sh " output-file " \"" music "\""))
 (system (string-append "./insert-music.sh " other-file " \"" (trim-lily 
	    (with-output-to-string
	      (lambda ()
		(display-lily-music
		 (durlist->rests
		  (* length-arg 0.25)))))
	    ) "\""))
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
	 
	 (output-file "lower.ily")
(other-file "upper.ily")
	 (music
	  (string-append
	   "\\override NoteHead.color = #green\n"
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
	   "<>^\\markup {"
	   word-to-print
	   "}"
	      "\\revert NoteHead.color"
	   )))
    (begin
      (format #t "Bruker lilypond-insert \"grønn\".  Grønne kryssnoter.~%~%")
(system (string-append "./insert-music.sh " output-file " \"" music "\""))
 (system (string-append "./insert-music.sh " other-file " \"" (trim-lily 
	    (with-output-to-string
	      (lambda ()
		(display-lily-music
		 (durlist->rests
		  (* length-arg 0.25)))))
	    ) "\""))
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
	   "<>_\\markup { \""
	   word-to-print
	   "\" }"
	   )))
    (begin
      (format #t "Bruker lilypond-insert \"lav\".  Dyp note med oktavdobling.~%~%")p
(system (string-append "./insert-music.sh " output-file " \"" music "\""))
 (system (string-append "./insert-music.sh " other-file " \"" (trim-lily 
	    (with-output-to-string
	      (lambda ()
		(display-lily-music
		 (durlist->rests
		  (* length-arg 0.25)))))
	    ) "\""))
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


	 (output-file "upper.ily")
(other-file "lower.ily")
	 (music
	  (string-append
	   (trim-lily 
	    (with-output-to-string
	      (lambda ()
		(display-lily-music
		 (add-slur
		  (add-articulations
		  (pitchlist->lily
		   (map (lambda (x) (list-ref possible-pitches (random (length possible-pitches)))) durs)
	       	   durs) "flageolet"))))))
	 	   "\\magnifyMusic #5/7\n"
	   "<>-\\markup { \""
	   word-to-print
	   "\" } "
	   )))
    (begin
      (format #t "Bruker lilypond-insert \"høyt\" med en høy velklingende note~%~%")
      (system (string-append "./insert-music.sh " output-file " \"" music "\""))
      (system (string-append "./insert-music.sh " other-file " \"" (trim-lily 
	    (with-output-to-string
	      (lambda ()
		(display-lily-music
		 (durlist->rests
		  (* length-arg 0.25)))))
	    ) "\""))
					;TODO flytt kompilering til post-read-file
      )))

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
	   )))
    (begin
      (format #t "legger inn pause~%~%")
            (system (string-append "./insert-music.sh " "./upper.ily" " \"" music "\""))
      (system (string-append "./insert-music.sh "   "./lower.ily" " \"" "\\magnifyMusic #5/7\n"
	   "<>-\\markup {"
	   word-to-print
	   "}\n" music "\"")))
      ))

(define lilywords
  `(("best" . ,(lambda (arg1 arg2) (my-høyt arg1 arg2)))
    ("liten" . ,(lambda (arg1 arg2) (my-liten arg1 arg2)))
    ("stor" . ,(lambda (arg1 arg2) (my-stor arg1 arg2)))
    ("stort" . ,(lambda (arg1 arg2) (my-stor arg1 arg2)))
    ("de" . ,(lambda (arg1 arg2) (my-tett arg1 arg2)))
    ("mot" . ,(lambda (arg1 arg2) (my-rød arg1 arg2)))
    ("alt" . ,(lambda (arg1 arg2) (my-tett arg1 arg2)))
    ("vis" . ,(lambda (arg1 arg2) (my-stor arg1 arg2)))
    ("disse" . ,(lambda (arg1 arg2) (my-tett arg1 arg2)))
    ("god" . ,(lambda (arg1 arg2) (my-stor arg1 arg2)))
    ("nettopp" . ,(lambda (arg1 arg2) (my-rask arg1 arg2)))
    ("vel" . ,(lambda (arg1 arg2) (my-stor arg1 arg2)))
    ("heller" . ,(lambda (arg1 arg2) (my-høyt arg1 arg2)))
    ("opp" . ,(lambda (arg1 arg2) (my-høyt arg1 arg2)))
    ("possessiv" . ,(lambda (arg1 arg2) (my-tett arg1 arg2)))
    ("enda" . ,(lambda (arg1 arg2) (my-rask arg1 arg2)))
    ("bedre" . ,(lambda (arg1 arg2) (my-stor arg1 arg2)))
    ("mann" . ,(lambda (arg1 arg2) (my-gul arg1 arg2)))
    ("jeg" . ,(lambda (arg1 arg2) (my-høyt arg1 arg2)))
    ("minst" . ,(lambda (arg1 arg2) (my-liten arg1 arg2)))
    ("mindre" . ,(lambda (arg1 arg2) (my-liten arg1 arg2)))
    ("ennå" . ,(lambda (arg1 arg2) (my-rask arg1 arg2)))
    ("da" . ,(lambda (arg1 arg2) (my-treig arg1 arg2)))
    ("stå" . ,(lambda (arg1 arg2) (my-høyt arg1 arg2)))
    ("så" . ,(lambda (arg1 arg2) (my-treig arg1 arg2)))
    ("en" . ,(lambda (arg1 arg2) (my-tom arg1 arg2)))
    ("hun" . ,(lambda (arg1 arg2) (my-gul arg1 arg2)))
    ("han" . ,(lambda (arg1 arg2) (my-gul arg1 arg2)))
    ("nok" . ,(lambda (arg1 arg2) (my-tett arg1 arg2)))
    ("herre" . ,(lambda (arg1 arg2) (my-gul arg1 arg2)))
    ("foran" . ,(lambda (arg1 arg2) (my-rask arg1 arg2)))
    ("bak" . ,(lambda (arg1 arg2) (my-høyt arg1 arg2)))
    ("framfor" . ,(lambda (arg1 arg2) (my-rask arg1 arg2)))
    ("meget" . ,(lambda (arg1 arg2) (my-stor arg1 arg2)))
    ("man" . ,(lambda (arg1 arg2) (my-gul arg1 arg2)))
    ("tydelig" . ,(lambda (arg1 arg2) (my-rød arg1 arg2)))
    ("måtte" . ,(lambda (arg1 arg2) (my-rask arg1 arg2)))
    ("menneske" . ,(lambda (arg1 arg2) (my-gul arg1 arg2)))
    ("mer" . ,(lambda (arg1 arg2) (my-tett arg1 arg2)))
    ("oppe" . ,(lambda (arg1 arg2) (my-høyt arg1 arg2)))
    ("rett" . ,(lambda (arg1 arg2) (my-stor arg1 arg2)))
    ("viss" . ,(lambda (arg1 arg2) (my-treig arg1 arg2)))
    ("vesle" . ,(lambda (arg1 arg2) (my-liten arg1 arg2)))
    ("glad" . ,(lambda (arg1 arg2) (my-høyt arg1 arg2)))
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

(define (insert-word word)
  "legg in markup i nota"
  (system (string-append "./insert-music.sh " output-file " \"" "<>^\\markup" word "\""))
  )
