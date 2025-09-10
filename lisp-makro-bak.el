(defun my-typing (string &optional delay-multiplier)
  "type a macro with a tiny delay "
  (seq-doseq
      (char "ab ba
ba ab")
    (let ((string (char-to-string char)))
      (if (char-equal char 32)
	  (progn (sit-for 0.15) (insert char) (sit-for 1))
	(if (char-equal char 10)
	    (progn (sit-for 2) (insert char) (sit-for 2))
	  (progn (sit-for 0.15) (insert char))
	  )
	)
      )
    )
  )

(defun my-send ()
  (geiser-repl-maybe-send) )


(define-minor-mode my-simple-background-mode
  ""
  :global t
  :lighter "simple-background"
  (let* ((default-bg (face-background 'fringe)) (custom-bg "#000000"))
    (if my-simple-background-mode
	(progn
	(set-face-attribute 'vertical-border nil
            		    :foreground custom-bg)
	(fringe-mode 0)
	(set-face-attribute 'internal-border nil
			    :background custom-bg)
	(set-background-color custom-bg)
	)
      (progn
      (set-face-attribute 'vertical-border nil
            		:foreground default-bg)
        (set-face-attribute 'internal-border nil
            		    :background default-bg)
	(set-background-color default-bg)
	(set-face-attribute 'vertical-border nil
            			  :foreground default-bg)
	(fringe-mode nil)
	)
    )
    )
  )

(define-minor-mode my-disable-minibuffer-mode
  "removes the display of modeline and minibuffer"
  :global t
  :lighter ""
  (if my-disable-minibuffer-mode
      (progn
	(defun my-command-error-function (data context caller)
	  "Ignore the buffer-read-only, beginning-of-buffer,
end-of-buffer signals; pass the rest to the default handler."
	  (when (not (memq (car data) '(buffer-read-only
					beginning-of-buffer
					end-of-buffer)))
	    (command-error-default-function data context caller)))
	(setq command-error-function #'my-command-error-function)
	
	(global-hide-mode-line-mode) (setq inhibit-message t) (setq echo-keystrokes 0))

    (progn
      (setq command-error-function #'command-error-default-function)
      (global-hide-mode-line-mode 0) (setq inhibit-message nil) (setq echo-keystrokes 1))
    ))





(defun my-invisible-open-paren ()
      "insert invis open paren"
  (interactive)
  (let ((background (face-attribute 'default :background))
        (inhibit-modification-hooks t)
        (pos (point)))
    (insert "(")
    ;; Use an overlay instead of text properties (overlays have higher precedence)
    (let ((overlay (make-overlay pos (1+ pos) nil t nil)))
      ;; Set face properties on the overlay with high priority
      (overlay-put overlay 'face `(:foreground ,background :inherit nil))
      (overlay-put overlay 'priority 1000))))

(defun my-invisible-close-paren ()
    "insert invis close paren"
    (interactive)
  (let ((background (face-attribute 'default :background))
        (inhibit-modification-hooks t)
        (pos (point)))
    (insert ")")
    ;; Use an overlay instead of text properties (overlays have higher precedence)
    (let ((overlay (make-overlay pos (1+ pos) nil t nil)))
      ;; Set face properties on the overlay with high priority
      (overlay-put overlay 'face `(:foreground ,background :inherit nil))
      (overlay-put overlay 'priority 1000))))

(define-minor-mode my-invisible-paren-mode
  "makes parens invisible"
  :lighter " invisible-paren"
  :keymap (let ((map (make-sparse-keymap)))
	    (define-key map (kbd "(") 'my-invisible-open-paren)
	    (define-key map (kbd ")") 'my-invisible-close-paren)
	    map)
  )

