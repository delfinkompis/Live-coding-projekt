#(define-module (my-repl-defuns)

#(import (ice-9 load-path))
#(import (ice-9 popen))
#(import (ice-9 rdelim))


#(set! %load-path (cons "/usr/share/lilypond/2.24.4/" %load-path))
#(set! %load-path (cons "/home/hjallis/Projektfiler/Live-coding-projekt/" %load-path))

#(define (group-list ls sep)
  (letrec ((iter (lambda (ls0 ls1)
		   (cond
		    ((null? ls0) (list ls1))
		    ((eqv? (car ls0) sep) 
		     (cons ls1 (iter (cdr ls0) '())))
		    (else (iter (cdr ls0) (cons (car ls0) ls1)))))))
    (map reverse (iter ls '()))))


#(define (my-read-file file-name)
  (with-input-from-file file-name
    (lambda ()
      (let loop((ls1 '()) (c (read-char)))
	(if (eof-object? c)
	    (map list->string (group-list (reverse ls1) #\Linefeed))  ; *
	    (loop (cons c ls1) (read-char)))))))




#(define* (my-ly-play-and-display ly-file csd-instrument #:optional type)
  "Display a lilypond file (arg1) as a pdf arg play it using a specified csound instrument (arg2)
if &optional = 0, display only pdf.  If &optional = 1, play only sound., if 2, do both"
  (cond ((equal? type 0)
	 (begin
	   (system (string-append "GUILE_AUTO_COMPILE=0 lilypond " "-dno-point-and-click --loglevel=NONE --output=ly-display.pdf " ly-file))
	  ))
	((equal? type 1)
	 (begin
	  (system (string-append "sed -i '$a\\\\bookOutputSuffix \" " ly-file " \"\n\\midi {}' temp.ly"))
	  (system (string-append "GUILE_AUTO_COMPILE=0 lilypond " "-dpreview=no -dno-print-pages -dno-point-and-click" ly-file))
	  (system (string-append "csound -F " ly-file ".mid " csd-instrument ".csd"))
	  ))

	(else
	 (begin
	  (system (string-append "sed -i '$a\\\\bookOutputSuffix \"" ly-file "\"\n\\midi {}' temp.ly"))
	  (system (string-append "GUILE_AUTO_COMPILE=0 lilypond " "-dno-point-and-click --output=ly-display.pdf" ly-file))
	  (system (string-append "csound -F " ly-file ".mid " csd-instrument ".csd"))
	  ))
	))




#(define (rød)
  "Rød note"
  (let* ((possible-durations '(0.25 0.5 0.125))
       (possible-pitches '(0 2 4 6 7 9 10 12))
       (output-file "main.ly")
       (music
	(string-append
	 "\\override NoteHead.color = #red\n"
(string-trim-both 
	 (with-output-to-string
	   (lambda ()
	     (display-lily-music
	      (pitchlist->lily
	       (list (list-ref possible-pitches (random (length possible-pitches))))
	       (list (list-ref possible-durations (random (length possible-durations))))))))
	     (string->char-set "{}\n"))
	 "\\revert NoteHead.color")))
(begin
 (system (string-append "./insert-music.sh " output-file " \"" music "\""))
 (my-ly-play-and-display output-file "a" 0)
)))


#(define (blå)
  "Blå note"
  (let* ((possible-durations '(0.25 0.5 0.125))
       (possible-pitches '(0 2 4 6 7 9 10 12))
       (output-file "main.ly")
       (music
	(string-append
	 "\\override NoteHead.color = #red\n"
(string-trim-both 
	 (with-output-to-string
	   (lambda ()
	     (display-lily-music
	      (pitchlist->lily
	       (list (list-ref possible-pitches (random (length possible-pitches))))
	       (list (list-ref possible-durations (random (length possible-durations))))))))
	     (string->char-set "{}\n"))
	 "\\revert NoteHead.color")))
(begin
 (system (string-append "./insert-music.sh " output-file " \"" music "\""))
 (my-ly-play-and-display output-file "a" 0)
)))

#(define (gul)
  "Gul note"
  (let* ((possible-durations '(0.25 0.5 0.125))
       (possible-pitches '(0 2 4 6 7 9 10 12))
       (output-file "main.ly")
       (music
	(string-append
	 "\\override NoteHead.color = #red\n"
(string-trim-both 
	 (with-output-to-string
	   (lambda ()
	     (display-lily-music
	      (pitchlist->lily
	       (list (list-ref possible-pitches (random (length possible-pitches))))
	       (list (list-ref possible-durations (random (length possible-durations))))))))
	     (string->char-set "{}\n"))
	 "\\revert NoteHead.color")))
(begin
 (system (string-append "./insert-music.sh " output-file " \"" music "\""))
 (my-ly-play-and-display output-file "a" 0)
)))

#(define (grønn)
  "Grønn note"
  (let* ((possible-durations '(0.25 0.5 0.125))
       (possible-pitches '(0 2 4 6 7 9 10 12))
       (output-file "main.ly")
       (music
	(string-append
	 "\\override NoteHead.color = #red\n"
(string-trim-both 
	 (with-output-to-string
	   (lambda ()
	     (display-lily-music
	      (pitchlist->lily
	       (list (list-ref possible-pitches (random (length possible-pitches))))
	       (list (list-ref possible-durations (random (length possible-durations))))))))
	     (string->char-set "{}\n"))
	 "\\revert NoteHead.color")))
(begin
 (system (string-append "./insert-music.sh " output-file " \"" music "\""))
 (my-ly-play-and-display output-file "a" 0)
)))

(define (min-pause)
  "Grønn note"
  (let* ((possible-durations '(0.25 0.5 0.125))
       (possible-pitches '(0 2 4 6 7 9 10 12))
       (output-file "main.ly")
       (music
	(string-append
	 "\\override NoteHead.color = #red\n"
(string-trim-both 
	 (with-output-to-string
	   (lambda ()
	     (display-lily-music
	      (pitchlist->lily
	       (list (list-ref possible-pitches (random (length possible-pitches))))
	       (list (list-ref possible-durations (random (length possible-durations))))))))
	     (string->char-set "{}\n"))
	 "\\revert NoteHead.color")))
(begin
 (system (string-append "./insert-music.sh " output-file " \"" music "\""))
 (my-ly-play-and-display output-file "a" 0)
)))

;% (define sorter gjennom kategori i ordbokapi)



#(define (my-monitor input-file)
   (sleep 5)
   (my-read-file input-file)))




#(define (my-fetch-synonyms ord)
(let*
    ((port (open-input-pipe (string-append "./fetch-synonyms.sh " ord)))
  (str (read-string port)))
(close-pipe port)
str
))

;; SEARCH FOR STRING IN INPUT.TXT
;; take new elements
(define (my-get-strings)
;; de n siste element i nye listen over ord som ikke er del av den gamle lista
((new-elements (take-right new-list (- (length new-list) (length old-list))))
;; sjekk alle nye ord
(map (lambda (ord)



(if 


;; gi en pause ellers
(min-pause)


(new-elements))

(new e)
()




;; OM STRENGEN MATCHER ET AV ORDENE MED TILHØRENDE LILYPOND-MAKRO, KJØR MAKROEN
(system (string-append "" ly-file))
;; OM STRING MATCHER ET ARTIKKELNAVN I ORDBØKENE, VELG EN AV ARTIKLENE

;;;; OM ET AV SYNONYMENE MATCHER ET AV ORDENE MED TILHØRENDE LILYPOND-MAKRO, KJØR DENNE MAKROEN

;;;; ELLERS, PRØVE Å SØKE OPP SYNONYMET, OG SJEKK VIDERE ETTER LILYPOND-MAKRO

;;;; OM ORDET IKKE HAR SYNONYMER, SJEKK OPP OM EN DEL AV DEFINISJONEN MATCHER EN LILYPOND MAKRO

;;;;; ELLERS, PRØVE Å SØKE OPP DEFINISJONEN, OG SJEKK VIDERE ETTER LILYPOND-MAKRO,

;; OM MASKINEN HAR PRØVD 5+ GANGER OG FEILET, GI OPP OG PRINTT EN PAUSE I NOTENE



;;;; OM ET AV ORDENE  


;; ELSE, return a rest;




;;; lilypond-kommandon shortlist

;;

;;
;;
;; liten, mindre, små
;; stor, gjev, vel
;; passe, bare, vanlig
;; bra, gjerne, flott, god
;; full, hel, riktig
;; tom, lett, 
