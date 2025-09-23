(format #t "riemann started loading")

(define major-transf '((0 -1 0) (1 0 1) (0 0 2) (1 0 2) (-1 -1 1) (0 1 2) (0 1 1) (0 -1 2) (1 0 3) (-2 -3 0) (-1 -1 0) (0 0 1)))

(define minor-transf '((0 1 0) (-1 0 -1) (0 0 1) (-1 0 1) (-1 -1 0) (0 2 1) (0 2 2) (-2 -2 0) (-1 -1 1) (-1 0 0) (0 1 1)))

(define major-first-transf '((0 0 1) (-1 0 -2) (1 2 0) (1 1 0) (-1 0 0) (0 1 1) (-1 1 0) (0 2 0) (0 2 1) (-1 -1 0) (0 0 1) (0 1 0) (-1 0 -1)))

(define minor-first-transf '((0 0 -2) (2 1 0) (2 2 0) (0 -1 -1) (1 0 0) (-1 0 -2) (-1 0 -1) (0 1 0) (0 1 -1) (1 2 0) (0 -1 0) (1 0 1) (0 0 -1) (1 1 0)))

(define major-second-transf '((0 -1 -2) (0 -2 -2) (1 0 -1) (2 0 0) (2 1 0) (0 -1 0) (1 -1 0) (1 0 1) (2 0 1) (0 0 -1) (1 1 0) (0 -2 0) (2 0 2) (1 0 0) (0 -1 -1)))

(define minor-second-transf '((0 -1 -1) (0 -2 -1) (1 0 0) (1 -1 0) (2 0 1) (-1 -2 0) (0 -2 0) (1 0 2) (1 -1 1) (2 0 2) (-1 -1 0) (0 0 1) (-1 -3 0) (0 -2 1) (0 -1 0) (1 0 1)))

(define aug-transf '((0 0 -1) (0 -1 -1) (1 1 0) (1 0 0) (-1 -1 0) (0 -1 0) (1 0 1) (0 0 1) (-1 0 0) (-1 0 -1) (0 1 0) (0 1 1) (-1 -2 0) (0 -1 1) (1 0 2)))

(define dim-transf '((-1 0 -3) (0 0 -2) (2 2 0) (2 3 0) (0 1 -2) (1 1 0) (0 0 -1) (-1 0 -1) (0 1 0) (-2 0 -3) (0 2 0) ( 0 2 -1) (1 3 0) (-1 0 -2) (0 1 -1) (1 2 0)))



(define (get-intervals list)
  "takes intervals between all notes in a list"
  (map (lambda (x y) (- y x)) list (cdr list)))

(define (riemann start-chords num-chords)
  "Makes nested pitchlist from and including starting-chord (for use with chordlist->lily akkording to riemann-transformation."
  (let*
      ((lst (if (not (any list? start-chords)) (list start-chords) start-chords))
       (current-chord (last lst))
       (current-intervals (get-intervals current-chord)))
 
    (if (>= (length lst) num-chords)
	lst ;escape clause
	(cond
	 ((equal? current-intervals '(4 3))
	  (riemann (append lst (list (map + (list-ref major-transf (random (length major-transf))) current-chord))) num-chords))


	 ((equal? current-intervals '(3 4))
	  (riemann (append lst (list (map + (list-ref minor-transf (random (length minor-transf))) current-chord))) num-chords))

	 ((equal? current-intervals '(3 5))
	  (riemann (append lst (list (map + (list-ref major-first-transf (random (length major-first-transf))) current-chord))) num-chords))

	 ((equal? current-intervals '(4 5))
	  (riemann (append lst (list (map + (list-ref minor-first-transf (random (length minor-first-transf))) current-chord))) num-chords))

	 ((equal? current-intervals '(5 4))
	  (riemann (append lst (list (map + (list-ref major-second-transf (random (length major-second-transf))) current-chord))) num-chords))

	 ((equal? current-intervals '(5 3))
	  (riemann (append lst (list (map + (list-ref minor-second-transf (random (length minor-second-transf))) current-chord))) num-chords))
	 
	 ((equal? current-intervals '(4 4))
	  (riemann (append lst (list (map + (list-ref aug-transf (random (length aug-transf))) current-chord))) num-chords))
	 
	 ((equal? current-intervals '(3 6))
	  (riemann (append lst (list (map + (list-ref dim-transf (random (length dim-transf))) current-chord))) num-chords))
	 (else (make-list num-chords current-chord))
	 ))))
