(use-modules (srfi srfi-1))
(use-modules (guile-user))

(import (ice-9 popen))
(import (ice-9 rdelim))
(import (ice-9 threads))
;(import (lily))
(set! %load-should-auto-compile #t)
(set! %load-path (cons "/opt/guile/share/guile/site/2.2/" %load-path))
;(use-modules (fibers))
					;(import (fibers channels))
(format #t "~%~%my-repl-defuns-web started loading")
(primitive-load "repl-variabler-web.scm")
(primitive-load "music-synonyms.scm")

(define (trim-lily s)
  (string-top-tail (string-top s)))

(define (flush-music-to-files)
  "Legg inn all musikk i filer"
  (let ((upper-music (get-output-string music-inserts-upper-port))
        (lower-music (get-output-string music-inserts-lower-port)))
    (when (or (> (string-length upper-music) 0)
              (> (string-length lower-music) 0))
      (let ((commands '()))
         (when (> (string-length upper-music) 0)
           (set! commands (cons (string-append "./insert-music.sh upper.ily \"" upper-music "\"") commands)))
        (when (> (string-length lower-music) 0)
          (set! commands (cons (string-append "./insert-music.sh lower.ily \"" lower-music "\"") commands)))
;:        (set! commands (cons "GUILE_AUTO_COMPILE=0 lilypond -dno-point-and-click --loglevel=NONE --output=ly-display ./main.ly & GUILE_AUTO_COMPILE=0 lilypond -dno-point-and-click --loglevel=NONE --output=ly-display ./main-midi.ly & wait && echo \"Ferdig med å kompilere partitur og midi\"" commands))
(set! commands (cons "echo \"ferdig med å skrive over filer, begynner å kompilere lilypond\"" commands))
(set! commands (cons "GUILE_AUTO_COMPILE=0 lilypond -dbackend=cairo --pdf -dno-point-and-click --loglevel=NONE -djobcount=$(nproc) --output=ly-display main.ly & GUILE_AUTO_COMPILE=0 lilypond -dno-point-and-click -dbackend=null --loglevel=NONE --output=ly-display main-midi.ly & wait && echo \"Ferdig med å kompilere partitur og midi\"" commands))

;	time GUILE_AUTO_COMPILE=0 ./lilypond-new/lilypond-2.25.28/bin/lilypond -dbackend=cairo -dgs-never-embed-fonts=#t -dno-point-and-click --loglevel=DEBUG -djobcount=$(nproc) --output=ly-display ./main.ly & GUILE_AUTO_COMPILE=0 ./lilypond-new/lilypond-2.25.28/bin/lilypond -dno-point-and-click -dbackend=null --loglevel=NONE --output=ly-display ./main-midi.ly & wait && echo "done"

        (system (string-join (reverse commands) " && "))))
    
    (set! music-inserts-upper-port (open-output-string))
    (set! music-inserts-lower-port (open-output-string))))

 (define synonym-db (make-hash-table))

 (define (load-synonym-database)
   "Load synonyms from static file"
   (catch #t
     (lambda ()
       (call-with-input-file "synonyms.txt"
         (lambda (port)
           (set-port-encoding! port "UTF-8")
           (let loop ((line (read-line port)))
             (unless (eof-object? line)
               (let ((parts (string-split line #\space)))
                 (when (>= (length parts) 2)
                   (hash-set! synonym-db (car parts) 
                             (cons (cadr parts) 
                                   (hash-ref synonym-db (car parts) '())))))
               (loop (read-line port)))))))
     (lambda (key . args)
       (display "Warning: Could not load synonym file\n")
       #f)))

 (define (my-fetch-synonyms ord)
   (hash-ref synonym-db ord '()))

 (load-synonym-database)


;(use-modules (fibers) (fibers scheduler))

(define new-wordlist '())
(define old-wordlist '())


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
  (let ((new-wordlist (my-read-file file-name)))
    (when (> (length new-wordlist) (length old-wordlist))
      (let* ((words-to-process (take-right new-wordlist (- (length new-wordlist) (length old-wordlist)))))
	     (for-each (lambda (word) 
                                    (word->lily (string-downcase word))) 
		       words-to-process)
	     (format #t "Skriver over filer og kompilerer lily~%~%")
	     (flush-music-to-files)
	     (format #t "Ferdig med å skrive over og kompilere~%~%")))
  (set! old-wordlist new-wordlist)))

(define synonym-cache (make-hash-table))


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
  (call-with-input-file file-name
    (lambda (port)
      (filter (lambda (word) (not (string=? word "")))
              (string-split (read-string port) char-set:whitespace)))))


;; TODO give lily-commands lengde-argument som speiler antall bokstaver i ord

(define* (word->lily ord #:optional (counter 0) (original-word-length (string-length ord)) (original-word ord))
  (format #t "Leter etter synonymer for ordet ~a.~%" original-word)
  (if (member ord (map car lilywords))
      (let ((func (assoc-ref lilywords ord)))
	(begin (format #t "Lager lilypond input av synonymet ~a. Opprinelig ord hadde ~d bokstaver.'~%" ord original-word-length) (func original-word-length original-word)))
      (let* ((synonym-list (filter (lambda (x) (not (equal? x ""))) (my-fetch-synonyms ord)))
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
    (set! new-wordlist (filter (lambda (x) (not (equal? x ""))) (my-read-file "input.txt")))
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
