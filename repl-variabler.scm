
;\version "2.24.4"
;%\include "mikrotonaleforteikn.ily"
;\include "../Stödfiler/arrows.ily"

(define (transpose pitches interval)
   "transposes list of pitch classes by the given pitch class interval"
   (map (lambda (i) (modulo (+ i interval) 12)) pitches))

(define (invert pitches)
   "invert list of pitch classes, using the first given pitch-class as an axis"
(let* ((axis (car pitches)))
  (map (lambda (i) (modulo (+ (* (- i axis) -1) axis) 12)) pitches)
))

(define (retrograde pitches)
"retrograde the given pitch list"
  (if (null? pitches)
     '()
     (append (retrograde (cdr pitches)) (list (car pitches)))
  )
  )

(define (prime-form pitches)
   "simplify a group of pitch-classes by transposing and interval inversion"
   (let ((max-iterations (length pitches)))
     (let loop ((index 0) (current-pitches pitches))
       (if (< index max-iterations)
           (let* ((simplified-list
                   (map (lambda (i) (if (> i 6) (- i 12) i)) current-pitches))
                  (central-tone (apply min simplified-list))
                  (raw-list (map (lambda (i) (modulo (+ (- 12 central-tone) i) 12)) simplified-list))
                  (next-pitches (if (equal? (apply min raw-list) 0)
                                    raw-list 
                                    (map (lambda (i) (modulo (+ (- 12 central-tone) i) 12)) raw-list))))
             (loop (+ index 1) next-pitches))
           current-pitches))))

(define (pitch-class->pitch pc)
"return a lilypond pitch object, given a pitch class and an octave"
		      (let* ((pitch-map '((0 . (0 . 0))   ; C
					  (1 . (0 . 1/2))   ; C#
					  (2 . (1 . 0))   ; D
					  (3 . (2 . -1/2))   ; Eb
					  (4 . (2 . 0))   ; E
					  (5 . (3 . 0))   ; F
					  (6 . (3 . 1/2))   ; F#
					  (7 . (4 . 0))   ; G
					  (8 . (4 . 1/2))   ; G#
					  (9 . (5 . 0))   ; A
					  (10 . (6 . -1/2))  ; Bb
					  (11 . (6 . 0))
					  )
					) ; B
			     (pitch-class (modulo pc 12))
			     (oct (floor (/ pc 12)))
			    (mapping (assoc pitch-class pitch-map))
			     (note-num (car (cdr mapping)))
			     (alter (cdr (cdr mapping)))
)
			 (ly:make-pitch oct note-num alter)
			     )
		      )


(define (power-of-2? int)
   (cond
 ((equal? int 1) #t)
 ((or (< int 1) (odd? int)) #f)
(else (power-of-2? (/ int 2)))))
(define (float->duration number)
"Input a float as a fraction of a whole note.  Outputs a suitable lily-duration object"
(let* (
       (fraction (rationalize (inexact->exact number) 1/1000))
       (numerator (numerator fraction))
       (denominator (denominator fraction))
       (log2-denom (inexact->exact (floor (/ (log denominator) (log 2)))))
       (dur-surplus (- numerator (expt 2 (floor (/ (log numerator) (log 2))))))
       (dotcount (inexact->exact (/ (- (sqrt (+ 1 (* 8 dur-surplus))) 1) 2))))
  (if (and (power-of-2? denominator)
	   (<= fraction 1)
	   (or (equal? dur-surplus 0) (>= dur-surplus (/ numerator 3)))
)
      (if (or (equal? numerator 1) (even? numerator))
;; no dots
	  (ly:make-duration log2-denom)
	  ;; how many dots?
	  (ly:make-duration (- log2-denom 1) dotcount)
)
      ;; Tuplet case
      (if (< fraction 1) (let* (
				(nearest-power-of-2 (expt 2 log2-denom))
				(ratio-num (* numerator nearest-power-of-2))
			   (ratio-denom denominator))
			   (ly:make-duration log2-denom 0 ratio-num ratio-denom))
	  ;; Longa & breve case
	  (cond ((equal? fraction 3/2) (ly:make-duration 0 1))
		((equal? fraction 7/4) (ly:make-duration 0 2))
		(else (ly:make-duration log2-denom 0 numerator 1))
)
)
)))
(define (pitchlist->lily pitches durations) 
   "Return a seq-mus object according to the duration(s) or pitch(es) One of the objects must be a list. single-octave"
   (make-sequential-music
      (map (lambda (i)
             (let* (
		    (dur
		     (if (list? durations)
			 (float->duration (list-ref durations i))
			 (float->duration durations))
)
		    (pitch
		     (if (list? pitches)
			 (pitch-class->pitch (list-ref pitches i))
			 (pitch-class->pitch pitches))
		    )
		    (scale (ly:duration-scale dur))
		    (tuplet? (not (= 1 scale)))
		    (base-dur (ly:make-duration
			      (ly:duration-log dur)
			      (ly:duration-dot-count dur)
			      )))
	        (if tuplet?
		 (let* ((scale-num (numerator scale))
			(scale-denom (denominator scale)))
		   #{ \tuplet #(cons scale-num scale-denom)
		     { $pitch $base-dur } #})
		   #{ $pitch $base-dur #})))
             (iota (if (list? durations) (length durations) (length pitches)))
	     )))

(define (durlist->rests durations) 
   "Return a seq-mus object according to the duration(s) or pitch(es) One of the objects must be a list. single-octave"
   (make-sequential-music
      (map (lambda (i)
             (let* (
		    (dur
		     (if (list? durations)
			 (float->duration (list-ref durations i))
			 (float->duration durations))
)
		    
		    (scale (ly:duration-scale dur))
		    (tuplet? (not (= 1 scale)))
		    (base-dur (ly:make-duration
			      (ly:duration-log dur)
			      (ly:duration-dot-count dur)
			      )))
	        (if tuplet?
		 (let* ((scale-num (numerator scale))
			(scale-denom (denominator scale)))
		   #{ \tuplet #(cons scale-num scale-denom)
		     { r $base-dur } #})
		   #{ r $base-dur #})))
             (iota (if (list? durations) (length durations) 1))
	     )))

(define (durlist->rests durations) 
   "Return a seq-mus object according to the duration(s) or pitch(es) One of the objects must be a list. single-octave"
   (make-sequential-music
      (map (lambda (i)
             (let* (
		    (dur
		     (if (list? durations)
			 (float->duration (list-ref durations i))
			 (float->duration durations))
)
		    
		    (scale (ly:duration-scale dur))
		    (tuplet? (not (= 1 scale)))
		    (base-dur (ly:make-duration
			      (ly:duration-log dur)
			      (ly:duration-dot-count dur)
			      )))
	        (if tuplet?
		 (let* ((scale-num (numerator scale))
			(scale-denom (denominator scale)))
		   #{ \tuplet #(cons scale-num scale-denom)
		     { s $base-dur } #})
		   #{ s $base-dur #})))
             (iota (if (list? durations) (length durations) 1))
	     )))

(define (remove x lst)
  (cond ((null? lst) '())
        ((equal? x (car lst)) (cdr lst))
        (else (cons (car lst) (remove x (cdr lst))))))

(define (permutations lst)
  (if (null? lst) '(())
      (let ((res '()))
        (for-each
         (lambda (x)
           (set! res
                 (append res 
                         (map
                          (lambda (y) (cons x y)) 
                          (permutations (remove x lst))))))
         lst)
        res)))

(define (nshuffle lst)
  (let ((m (map identity lst)))
    (do ((i (length m) (- i 1)))
        ((< i 2) m)
      (let* ((j (random i))
             (p1 (list-tail m j))
             (p2 (list-tail m (- i 1)))
             (t (car p1)))
        (set-car! p1 (car p2))
        (set-car! p2 t)))))

(define (add-slur seq-mus-arg)
  (if (ly:music? seq-mus-arg)
  (let ((lst (ly:music-property seq-mus-arg 'elements)))
    (cond ((or (null? lst) (null? (cdr lst))) lst)
    (else
     (let*
	 ((first-el (first lst))
       (last-el (last lst))
       (middle (cdr (reverse (cdr (reverse lst))))))
(begin
		  (set! (ly:music-property first-el 'articulations)
			(cons (make-music 'SlurEvent 'span-direction -1)
			      (ly:music-property first-el 'articulations)))
		 
		  (set! (ly:music-property last-el 'articulations)
			(cons (make-music 'SlurEvent 'span-direction 1)
			      (ly:music-property last-el 'articulations)))
		  (make-sequential-music lst))))))
  seq-mus-arg
  ))

(define (add-articulation-to-note note-event articulation-type-arg)
  "Add an ArticulationEvent (string) to the articulations of `note-event'."
  (set! (ly:music-property note-event 'articulations)
        (cons (make-music 'ArticulationEvent
                'articulation-type articulation-type-arg)
              (ly:music-property note-event 'articulations)))
  note-event)

(define (add-articulations seq-mus-arg articulation-type-arg)
(let
    ((lst (ly:music-property seq-mus-arg 'elements))
     )
  (begin
    (map (lambda (x) (add-articulation-to-note x articulation-type-arg)) lst)
    (make-sequential-music lst))))
    
;  http://lsr.di.unimi.it/LSR/Item?id=445

;LSR by Jay Anderson.
;modyfied by Simon Albrecht on March 2014.
;=> http://lilypond.1069038.n5.nabble.com/LSR-445-error-td160662.
(define (harmonize-up m t)
 (let* (
      (new-note (ly:music-deep-copy m))
      (new-pitch (ly:make-pitch
	(ly:pitch-octave (ly:music-property m 'pitch))
        (ly:pitch-notename (ly:music-property m 'pitch))
        (ly:pitch-alteration (ly:music-property m 'pitch)))))
   (set! (ly:music-property new-note 'pitch) (ly:pitch-transpose new-pitch (pitch-class->pitch t)))
  new-note))

(define (make-harmony mus arg) 
  (music-map (lambda (x) (harmonize x arg)) (event-chord-wrap! mus)))

(define (harmonize-chord elements t)
 (cond ((null? elements) elements)
     ((eq? (ly:music-property (car elements) 'name) 'NoteEvent)
       (cons (car elements)
             (cons (harmonize-up (car elements) t)
                   (harmonize-chord (cdr elements) t))))
     (else (cons (car elements) (harmonize-chord (cdr elements ) t)))))

(define (harmonize music t)
 (if (eq? (ly:music-property music 'name) 'EventChord)
       (ly:music-set-property! music 'elements (harmonize-chord
(ly:music-property music 'elements) t)))
 music)

(define (string-trim-if-both string char-set)
(let ((chars (char-set->list char-set))
      (stringlist (string->list string)))
  (if (and (member (first stringlist) chars) (member (last stringlist) chars))
      (string-trim-both string char-set)
      string
      )))
;;; end of lsr snippet

;;; snippet from  https://rosettacode.org/wiki/Substring/Top_and_tail#Scheme
(define (string-top s)
  (if (string=? s "") s (substring s 0 (- (string-length s) 1))))

(define (string-tail s)
  (if (string=? s "") s (substring s 1 (string-length s))))

(define (string-top-tail s)
  (string-tail (string-top s)))

;;;;;;;;;;; end of snippet

(define (harmonize-music-two seq-mus-arg interval)
(let
    ((lst (ly:music-property seq-mus-arg 'elements))
     )
  (begin
    (map (lambda (x) (harmonize x interval)) lst)
    (make-sequential-music lst))))
