(defun my-setup-buffers ()
    (interactive)
    (progn
      (find-file "main.ly")
      (geiser-lilypond-guile-switch)
    (with-current-buffer "*Geiser Lilypond-Guile REPL*"
      (my-simple-repl-mode 1)
;                (geiser-repl-import)
      )

    (switch-to-buffer "*Geiser Lilypond-Guile REPL*")
    (delete-other-windows)
    (split-window-horizontally)
    (other-window 1)
    (find-file "ly-display.pdf")
    (split-window-vertically)
    (other-window 1)
    (vterm)
    (with-current-buffer "*vterm*"
      (vterm--self-insert)
      (vterm-insert "cava")
      (vterm-send-return)
      (my-simple-repl-mode 1)
      )))

(defun my-shutdown-buffers ()
    (interactive)
    (progn
    (with-current-buffer "*Geiser Lilypond-Guile REPL*"
      (my-simple-repl-mode -1)
;                (geiser-repl-import)
      )
    (with-current-buffer "*vterm*"
      (my-simple-repl-mode -1)
      )))

(defun my-send ()
  (interactive)
  (geiser-repl-maybe-send))

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
	
	(global-hide-mode-line-mode 1) (setq inhibit-message t) (setq echo-keystrokes 0))

    (progn
      (setq command-error-function #'command-error-default-function)
      (global-hide-mode-line-mode -1) (setq inhibit-message nil) (setq echo-keystrokes 1))
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
	    map))

(define-minor-mode my-simple-repl-mode
  ""
  :global t
  :lighter "simple-repl"
     (if my-simple-repl-mode
	(progn 
	  (my-disable-minibuffer-mode 1)
	  (my-simple-background-mode 1)
	  (my-force-white-text-mode 1)
	  (my-invisible-paren-mode 1)
	  (show-paren-mode -1)
	  (set-face-attribute 'geiser-font-lock-repl-prompt nil
            		      :foreground (face-attribute 'default :background))
	  (set-face-attribute 'comint-highlight-prompt nil
            		      :foreground (face-attribute 'default :background))
		  )
       
       (progn
	 (my-disable-minibuffer-mode -1)
	 (my-simple-background-mode -1)
	 (my-force-white-text-mode -1)
	 (my-invisible-paren-mode -1)
	 (show-paren-mode 1)
	 (set-face-attribute 'geiser-font-lock-repl-prompt nil :foreground "yellow1")
	 (set-face-attribute 'comint-highlight-prompt nil :foreground "yellow1")
	 )
       ))

(setq-local original-face-remapping-alist face-remapping-alist)

(define-minor-mode my-force-white-text-mode
  "Change all text foreground colors to black."
    :global nil
    :lighter "all-white-text"
    (if my-force-white-text-mode
	(setq-local face-remapping-alist
		    (cl-loop for face in (face-list)
			     unless (or (eq face 'geiser-font-lock-repl-prompt) (eq face 'comint-highlight-prompt))
                             collect (cons face '(:foreground "#ffffff"))))

      (progn
        (setq-local face-remapping-alist original-face-remapping-alist)
        (setq-local original-face-remapping-alist nil)
      )))

(defun my-typing (string &optional delay-multiplier)
  "Type a string  with a tiny delay between each char,"
  (seq-doseq
      (char string)
    (let ((string-type (char-to-string char)))
      (if (char-equal char 32)
	  (progn (insert char) (sit-for 0.0025))
	(if (char-equal char 10)
	    (progn (insert char) (sit-for 0.0025))
	  (progn (insert char) (sit-for 0.00125))
	  )))))

