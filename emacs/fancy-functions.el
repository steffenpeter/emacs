
(defun inform () "Inform on cursor position  (msm)."
  (interactive)
  (setq char (following-char))
; (setq lines (count-lines (point-min) (point-max)))
  (save-excursion
      (beginning-of-line)
      (setq line (1+ (count-lines 1 (point)))))
  (setq lines (count-lines 1 (point-max)))
  (message "Char: %-3s (%d O%o X%x)  %d of %d  line %d of %d  col %d of %d"
    (single-key-description char) char char char (point) (point-max)
    line lines (+ 1 (current-column)) (line-len))
  )


(defun file-inform () "Inform on current file  (msm)"
  (interactive)
  (setq lines (count-lines 1 (point-max)))
  (if (= (point-max) 1) (setq saf "") (setq saf "s"))
  (if (= lines 1)       (setq suf "") (setq suf "s"))
  (message "%s   %d byte%s, %d line%s"
    buffer-file-truename (point-max) saf lines suf) )


(defun goto-position (strn) 
  "Moves point to the position specified as line.col (msms).
Also accepts: top top bot eof." 
  (interactive "sGoto position: ")
  (catch 'done 
    (if (string= strn "") (error "No position given"))
    (setq strn (substring strn (string-match "[^ ]" strn)))
    (setq strn (substring strn 0 (string-match " " strn)))
    (if (or (string= strn "top") (string= strn "tof")) 
        (progn
          (goto-char (point-min))
          (throw 'done nil)))
    (if (or (string= strn "bot") (string= strn "eof"))
        (progn
          (goto-char (point-max))
          (throw 'done nil)))
    (setq strn (substring strn (string-match "[^ ]" strn)))
    (setq strn (substring strn 0 (string-match " " strn)))
    (if (not (string-match "\\." strn)) (setq strn (concat strn ".")))
    (setq i (string-match "\\." strn))
    (setq aa (substring strn 0 i))
    (setq bb (substring strn (1+ i) ))
;    (message "go to line %s, column %s" aa bb)
    (if (string= aa "") nil
      (goto-line (string-to-int aa))
      )
    (if (string= bb "") nil
      (if (> (string-to-int bb) (line-len))
          (message "Column exceeds length; wrapped"))
      (goto-char (bol-point))
      (forward-char (1- (string-to-int bb))
      ))
    )
  )

(defun change-hyphens () "Change - to = in current line"
  (interactive)
  (save-excursion
    (end-of-line)
    (setq z (point))
    (beginning-of-line)
    (while (search-forward "-" z t)
      (replace-match "=" nil t))
    )  
  )

;; ------- claw C code back into reasonable style ------

(defun c-format-stuff ()
  (goto-char (point-min))
  (while  (search-forward "," (point-max) t) 
    ;; remove spaces before ,
    (save-excursion
      (backward-char 2)
      (while (looking-at " ")
         (delete-horizontal-space)
         (backward-char 1)
      )
    )
    ;; insert space after ,
    (if (not (looking-at " ")) 
        (insert " ")
    )
  )
)

(defun claw-back-bracket () 
  "Removes leading and trailing spaces in an (..) expression (msm)."
  "Call this when point is at the opening ( character."
  (if (not (looking-at "(")) (error "Not at ("))

  ;; remove spaces after '(' and before ')'
  (save-excursion
    (forward-char 1)
    (if (looking-at " ") (delete-horizontal-space)) 
    (backward-char 1)
    (forward-sexp)
    (backward-char 2)
    (if (looking-at " ") (delete-horizontal-space)) 
    ;; change () to ( )
    (if (looking-at "()") 
        (progn (forward-char 1) (insert " ")))
    )
  ;; want exactly one space before (...) unless only whitespace before
  (setq doit 1)
  (save-excursion
    (backward-char 1)
    (if (looking-at "\"") (setq doit 0))
    (if (looking-at "(") (setq doit 0))
    (if (looking-at "*") (setq doit 0))
    (if (looking-at "!") (setq doit 0))
    (beginning-of-line)
    (if (looking-at " *(") (setq doit 0))
    (if (looking-at "#") (setq doit 0))
    )
  (if (= doit 1) 
      (progn
        (backward-char 1)
        (if (looking-at " ") (delete-horizontal-space) (forward-char 1)) 
        (if (looking-at "(") (insert " "))
        )
    )
  )

(defun c-format-brackets () 
  (goto-char (point-min))
  (while  (search-forward "(" (point-max) t)
    (save-excursion
      (backward-char 1)
      (claw-back-bracket)
      )
    )
  )

(defun claw-back-bracespace () 
  "Helps to remove whitespace after bracket in KEYWORD (....)   {"
  "Call after successful search to KEYWORD. (msm)"
  (while (looking-at " ") (forward-char 1))
  (if (looking-at "[^(]")
      ( )
    (forward-sexp)
    (setq doit 0)
    (save-excursion 
      (while (looking-at "[ \n]") (forward-char 1))
      (if (looking-at "{") (setq doit 1))
      )
    (if (= doit 1)
        (progn 
          (while (looking-at "[ \n]") (delete-char 1))
          (insert " ")
          )
      )
    
    )
  )

(defun claw-back-elsespace ()
  "Helps to remove whitespace after bracket in KEYWORD {"
  "Call after successful search to KEYWORD. (msm)"
  (setq doit 0)
  (save-excursion 
    (while (looking-at "[ \n]") (forward-char 1))
    (if (looking-at "{") (setq doit 1))
    )
  (if (= doit 1)
      (progn 
        (while (looking-at "[ \n]") (delete-char 1))
        (insert " ")
        )
    )
  )


(defun c-format-braces ()
  (goto-char (point-min))
; (while (re-search-forward "^ *if" (point-max) t)
  (while (re-search-forward " if" (point-max) t)
    (claw-back-bracespace) )
  
  (goto-char (point-min))
  (while (re-search-forward " while" (point-max) t)
    (claw-back-bracespace) )
  
  (goto-char (point-min))
  (while (re-search-forward " switch" (point-max) t)
    (claw-back-bracespace) )
  
  (goto-char (point-min))
  (while (re-search-forward " else" (point-max) t)
    (claw-back-elsespace) )

  )



(defun c-format-buffer() (interactive)
  (save-excursion
    (c-format-stuff)
    (c-format-braces)
    (c-format-brackets)
    (indent-region (point-min) (point-max) nil)
    )
  )



; ------- bookmark stuff ------

(defun bookmark-help () (interactive)
  (message "cmds:  set  jumpto  edit  rename  delete  insert  write  load"))

(defun Bookmark-help () (interactive)
  (message "cmds:  jumpto(=RET)  file  M-write  M-load  del  x_del  rename  toggle"))

(defun bookmark-lsave () "Save bookmarks to local .emacs-bkmmrks (msm)"
  (interactive)
  (bookmark-save nil ".emacs-bkmrks") )

(defun bookmark-lload () "Load bookmarks from local .emacs-bkmmrks (msm)"
  (interactive)
  (bookmark-load ".emacs-bkmrks" 1))

(defun bookmark-jumpc () "Jump to bookmark and recenter (msm)"
  (interactive)
  (bookmark-jump)
  )

(defun bookmark-jump (str)
  "Jump to bookmark BOOKMARK (a point in some file).  
You may have a problem using this function if the value of variable
`bookmark-alist' is nil.  If that happens, you need to load in some
bookmarks.  See help on function `bookmark-load' for more about
this.

If the file pointed to by BOOKMARK no longer exists, `bookmark-jump'
asks you to specify a different file to use instead.  If you specify
one, it also updates BOOKMARK to refer to that file."
  (interactive (progn (bookmark-try-default-file)
                      (let* ((completion-ignore-case
                              bookmark-completion-ignore-case)
                             (default 
                               (or (and 
                                    (assoc bookmark-current-bookmark
                                           bookmark-alist)
                                    bookmark-current-bookmark)
                                   (and (assoc (buffer-name (current-buffer))
                                               bookmark-alist)
                                        (buffer-name (current-buffer)))))
                             (str
                              (completing-read
                               (if default 
                                   (format "Jump to bookmark (%s): "
                                           default)
                                 "Jump to bookmark: ")
                               bookmark-alist
                               nil
                               0)))
                        (and (string-equal "" str)
                             (setq str default))
                        (list str))))
  (let ((cell (bookmark-jump-noselect str)))
    (and cell
         (switch-to-buffer (car cell))
         (goto-char (cdr cell)) (recenter 0)
         )))



(defun edit-init-bookmarks () 
  "Display a list of existing bookmarks; init Bookmark map if needed."
  (interactive)
  (list-bookmarks)
  (if bookmark-init ( )
    (message "Init Bookmark map..")
    (define-key Bookmark-menu-mode-map "h"  'Bookmark-help)              ; h
    (define-key Bookmark-menu-mode-map "" 'Bookmark-menu-this-window)  ; v
    (define-key Bookmark-menu-mode-map "j"  'Bookmark-menu-this-window)  ; j
    (define-key Bookmark-menu-mode-map "ì"  'bookmark-lload)  ; M-l
    (define-key Bookmark-menu-mode-map "÷"  'bookmark-lsave)  ; M-w
    (define-key Bookmark-menu-mode-map "f"  'Bookmark-menu-locate)  ; f
    (setq bookmark-init 1)
    )
  )

; ------- list-select -------

(defun list-select (&optional strn) "MSM list-select" (interactive)
  (catch 'done
    (if (not strn)
        (setq strn 
              (read-from-minibuffer (format "    ls [%s] " savestrn))))
    (if (equal strn "") (setq strn savestrn))
    (if (string= (buffer-name) "*Occur*")
        (progn  
          (kill-buffer "*Occur*") 
          (if (equal strn "") nil (list-select strn))
          (throw 'done nil)))
        (if (and (get-buffer "*Occur*") (equal strn savestrn)) 
        (progn
          (message "Switching back to existing *Occur* buffer")
          (switch-to-buffer "*Occur*")
          (throw 'done nil)
          ))
    (if (equal strn " ") (setq strn "---"))
    (setq savestrn strn)
    (next-line 1)
    (save-excursion 
      (if (not (re-search-backward strn (point-min) t)) 
          (setq lookfor strn)
        (beginning-of-line) 
        (setq lookfor (buffer-substring (point) (eol-point)))
        ))
    (save-excursion (beginning-of-buffer) (list-matching-lines strn))
    (pop-to-buffer "*Occur*")
    (search-forward lookfor) (move-to-column 5)
    (setq xx (- (count-lines (point-min) (point-max)) 1))
;    (delete-other-windows)
    (if (equal xx 0) (progn (message "none found") (kill-buffer "*Occur*") )
      (message "%d occurences found" xx))
    )
  )

(defun kill-occur-buffer () (interactive) (kill-buffer "*Occur*"))

(defun occur-pgdown () (interactive)
  (other-window 1) (scroll-up nil) (other-window 1)
  )

(defun occur-pgup () (interactive)
  (other-window 1) (scroll-down nil) (other-window 1)
  )

(defun occur-next-key () (interactive)
       (message "ONK")
  (next-line 1)
  (occur-mode-goto-occurrence) 
  (recenter 0) 
  (other-window 1)
  )

(defun occur-previous-key () (interactive)
  (previous-line 1)
  (occur-mode-goto-occurrence) 
  (recenter 0) 
  (other-window 1)
  )

(defun goto-occur-line () (interactive)
 (setq ll (line-num))
 (occur-mode-goto-occurrence)
; (delete-other-windows) 
 (if (= ll 1) (beginning-of-buffer))
 (recenter 0) 
; next line: kills the buffer after leaving it
 (kill-buffer "*Occur*")   
)

(defun goto-occur-line-keep () (interactive)
 (setq ll (line-num))
 (occur-mode-goto-occurrence) 
; (delete-other-windows) 
 (if (= ll 1) (beginning-of-buffer))
 (recenter 0) 
 (other-window 1)
 )

; ------- comment out/in regions ------------------
(defun comment-general-region (start end xx arg)
  (setq cc (substring xx 0 1))
  (save-excursion
    (goto-char end) 
    (while (> (point) start)
      (next-line -1)   
      (beginning-of-line)
      (if arg 
          (if (and 
               (not (looking-at " *\n")) 
               (not (looking-at cc)))
              (progn
                (if (looking-at "  ") (delete-char 2))
                (insert xx)))
        (if (looking-at xx) 
            (progn
              (delete-char 2) (insert "  "))
          ))
      (beginning-of-line)
      ) 
    ) 
  )

(defun comment-c-region (pos1 pos2 arg)
  (save-excursion
    (goto-char end) 
    (while (> (point) start)
      (next-line -1)   
      (beginning-of-line)
      (if arg 
          (if (and
               (not (looking-at " *\n")) 
               (not (looking-at " */\\*")))
              (progn (insert "/*| ") (end-of-line) (insert " |*/")))
        (if (looking-at "/\\*|") 
            (progn
              (delete-char 3)
              (if (search-forward "|*/" (eol-point) t)
                  (progn (goto-char (match-beginning 0)) (delete-char 3))
                )
              )
          )
        )
        (beginning-of-line)
      ) 
    ) 
  )

(defun comment-region (pos1 pos2 arg)
  (setq start (min pos1 pos2))
  (setq end   (max pos1 pos2))
  
  (setq xx "NONE")             ; get comment characters from mode
  (if (string= major-mode "emacs-lisp-mode") (setq xx ";|"))
  (if (string= major-mode "fortran-mode")    (setq xx "c|"))
  (if (string= major-mode "tex-mode")        (setq xx "%|"))
  (if (string= major-mode "plain-tex-mode")  (setq xx "%|"))
  (if (string= major-mode "latex-mode")      (setq xx "%|"))
  (if (string= major-mode "text-mode")       (setq xx "> "))
  (if (string= major-mode "c-mode")          (setq xx "/*"))
  
  (progn
    (setq fname (buffer-name))
    (setq iii (string-match "\\." fname))
    (setq extension "NONE")
    (if iii (setq extension (substring fname (match-end 0))))
    (if (string= extension "ps")   (setq xx "%|"))
    (if (string= extension "eps")  (setq xx "%|"))
    (if (string= extension "tex")  (setq xx "%|"))
    (if (string= extension "abc")  (setq xx "%|"))
    (if (string= extension "ms")   (setq xx "%|"))
    (if (string= extension "mas")  (setq xx "%|"))
    (if (string= extension "c")    (setq xx "/*"))
    (if (string= extension "cc")   (setq xx "//"))
    )
  
  (if (string= xx "NONE") (setq xx "#"))    ; default 
  
  (if (string= xx "/*") 
      (comment-c-region start end arg)
    (comment-general-region start end xx arg)
    )
  )

(defun comment-out () 
  "Insert comment chars for lines in region (msm)"
  (interactive)
  (comment-region (point) (mark) t))
   
(defun comment-in  () 
  "Remove comment chars for lines in region (msm)"
  (interactive)
  (comment-region (point) (mark) nil))

; ------- indentations -----

(setq tab-width-msm 3)     ; tab width 

(defun indent-to-previous-line ()
  "Shifts current line to line up with previous line (msm)."
  (interactive)
  (let (c w)
    (setq w tab-width-msm)   ; tab width
    (save-excursion          ; get start col of previous line
      (forward-line -1)
      (while (looking-at "[ #]") (forward-char 1))
      (if (looking-at "\n") (setq c 0) (setq c (current-column)))
      )
    (beginning-of-line)
    (while (looking-at "[ #]") (forward-char 1))
    (delete-horizontal-space)
    (indent-to c) ))

(defun text-indent-line ()
  "Indents line in text mode (i.e. for shellscripts).
Tab stops are every tab-width-msm columns (msm)."
  (interactive)
  (let (c w)
    (setq w tab-width-msm)  ; tab width
    (beginning-of-line)
    (if (not (looking-at "@"))
        (progn
          (while (looking-at "[ #]") (forward-char 1))
          (setq c (* (1+ (/ (current-column) w)) w))
; with next line: first time always go to first tab stop
;         (if (not (string= last-command "text-indent-line")) (setq c w))
          (delete-horizontal-space)
          (indent-to c)
          ))))

; ------- math mode toggle -------------   

(setq math-already-defined nil)
(defun math-toggle () 
  "Toggles msm math mode. See help on function math-mode."
  (interactive)
  (if math-already-defined () 
    (load-file "~/emacs/math-mode.el") (setq math-already-defined t)) 
  (if (not overwrite-mode) 
      (if (string= major-mode "math-mode") (text-mode) (math-mode))
    (if (string= major-mode "math-mode") (text-mode) (math-mode))
    (overwrite-mode 1))  )

; ------- rectangle operations --------------

(defun save-rectangle (start end)
  "Save rectangle with corners at point and mark as if it was killed."
  (interactive "r")
  (setq killed-rectangle (extract-rectangle start end))
  (message "Rectangle saved"))

(defun show-saved-rectangle () (interactive)
  (pop-to-buffer "*Help*") (erase-buffer)
  (yank-rectangle) (goto-char (point-min)))

(defun help-rectangle-keys () (interactive) 
   (message "cmds:  kill  yank  delete  open  clear  save  type  rectangle"))

(global-set-key "ò" 'rectangle-prefix)  ; alt-r is prefix 
(setq rectangle-map (make-keymap))
(fset 'rectangle-prefix rectangle-map)

(define-key rectangle-map "ë" 'kill-rectangle)             ; alt-k
(define-key rectangle-map "ù" 'yank-rectangle)             ; alt-y
(define-key rectangle-map "ã" 'clear-rectangle)            ; alt-c
(define-key rectangle-map "ï" 'open-rectangle)             ; alt-o
(define-key rectangle-map "ä" 'delete-rectangle)           ; alt-d
(define-key rectangle-map "è" 'help-rectangle-keys)        ; alt-h
(define-key rectangle-map "ò" 'exchange-point-and-mark)    ; alt-r
(define-key rectangle-map "ô" 'show-saved-rectangle)       ; alt-t
(define-key rectangle-map "ó" 'save-rectangle)             ; alt-s


; ------- dired -------

(setq dired-load-hook 'msm-dired-init)

(defun msm-dired-init ()    ; key defs for dired-load-hook
  (define-key dired-mode-map ""   'dired-find-file)         ; RET
  (define-key dired-mode-map "[A" 'dired-previous-line)     ; Up
  (define-key dired-mode-map "[B" 'dired-next-line)         ; Down
  (define-key dired-mode-map "[D" 'beginning-of-line)       ; Left
  (define-key dired-mode-map "[C" 'dired-eol)               ; Right
  (define-key dired-mode-map " " 'dired-unflag) 
  (define-key dired-mode-map "d" 'dired-flag-file-deleted-msm) 
  (define-key dired-mode-map "u" 'dired-unflag-msm) 
  (define-key dired-mode-map "s" 'dired-sort) 
  (define-key dired-mode-map "a" 'dired-all-files) 
  (define-key dired-mode-map "z" 'dired-flag-empty-files)
)

(defun dired-summary ()
  (interactive)
  (message
   "d-el, u-ndel, x-ecute, a-ll, r-ename, c-opy, s-ort, z-eroflag, !-Do"))

(defun dirpat () 
  "Enters dired with pattern in env-var PATTERN, + means * (msm)."
  (interactive)
  (get-buffer-create "*Snot*")
  (set-buffer "*Snot*") (erase-buffer)
  (insert (substitute-in-file-name "$PATTERN") )
  (if (= (buffer-size) 0) (setq text "")
    (goto-char (point-min)) (replace-string "+" "*")
    (setq text (buffer-string)))
  (kill-buffer "*Snot*") (delete-other-windows)
  (setq dired-listing-switches "-la")
  (dired text)
)  

(defun fl (strn) "MSM start dired" (interactive "s    fl ")
  (setq dired-listing-switches "-la")
  (dired strn))

(defun dired-sort (strn) "MSM sort in dired" 
  (interactive "sSort by (n-ame, t-ime, s-ize, m-ode): ")
  (if (string= strn "t") (progn
      (setq dired-listing-switches "-lat")
      (dired dired-directory "-lat")
      ))
  (if (string= strn "n") (progn
      (setq dired-listing-switches "-la")
      (dired dired-directory)
      ))
  (if (string= strn "s") (progn
      (let ((buffer-read-only nil))
        (goto-char (point-min))
        (forward-line 1)
        (setq xx (point))
        (sort-numeric-fields -5 xx (point-max)) )
      ))
  (if (string= strn "m") (progn
      (let ((buffer-read-only nil))
        (goto-char (point-min))
        (forward-line 1)
        (setq xx (point))
        (sort-fields -1 xx (point-max)) )
      ))
  (goto-char (point-min))
)

(defun dired-all-files () (interactive)
  (setq dired-listing-switches "-Al")
  (dired dired-directory))

(defun dired-flag-file-deleted-msm (arg)
  (interactive "p")
  (dired-repeat-over-lines arg
    '(lambda ()
       (let ((buffer-read-only nil))
         (delete-char 1)
         (insert "D"))))
  (next-line -1)    ; don't move down after flagging
)

(defun dired-unflag-msm (arg)
  (interactive "p")
  (dired-repeat-over-lines arg
    '(lambda ()
       (let ((buffer-read-only nil))
         (delete-char 1)
         (insert " ")
         (forward-char -1))))
  (next-line -1)    ; don't move down after flagging
)

(defun dired-eol () (interactive)
  (dired-move-to-filename))

(defun dired-flag-empty-files ()
  "Flag for deletion files of length zero (msm)."
  (interactive)
  (save-excursion
   (let ((buffer-read-only nil) (num 0))
     (goto-char (point-min)) (forward-line 1)
     (while (not (eobp)) (and (not (looking-at "  d")) (not (eolp))
        (progn
          (beginning-of-line)
          (forward-sexp 5)
          (forward-word -1)
          (if (looking-at "0") 
              (progn (beginning-of-line)
                     (setq num (1+ num))
                     (delete-char 1)
                     (insert "D"))  )
          )
        )
        (forward-line 1))
     (message "Flagged: %d" num)
     )))

; ------- mail formatter -------

(defun mgetline (rxp start end)
  (goto-char start)
  (if (re-search-forward rxp end t)
      (buffer-substring (point) (eol-point))
    " " ))

(defun mgetname (longname)
  (setq pp (string-match "<" longname))
  (if pp (setq longname (substring longname (1+ pp))))
  (setq pp (string-match "[@%.-]" longname))
  (substring longname 0 pp ))

(defun mgetdate (longdate)
  (if (< (words longdate) 4) longdate
    (setq xday (word longdate 2))
    (setq xmon (word longdate 3))
    (setq pp (string-match ":" longdate))
    (setq dt (substring longdate 5 11))
    (setq tm (substring longdate (- pp 2) (+ pp 3 )))
    (if (string-match "[0123456789]" xday)
        (format "%s %2s  %s" xmon xday tm)
      (format "%s %2s  %s" xday xmon tm)
      )))

; ------- mm-clean-header
; Call when at start of header, removes junk lines
(defun mm-clean-header () (interactive)
  
  (setq kkk 0)
  (while (not (looking-at " *\n"))
    (if (not (or 
              (looking-at "Received:")
              (looking-at "Message-Id:")
              (looking-at "Sender:")
              (looking-at "Precedence:")
              (looking-at "Mmdf-Warning:")
              (looking-at "Reply-To:")
              (looking-at "In-Reply-:")
              (looking-at "References:")
              (looking-at "Sender:")
              (looking-at "Comments:")
              (looking-at "Priority:")
              (looking-at "Content-")
              (looking-at "X-")
              (looking-at "X400-")
              (looking-at "Mailer:")
              (looking-at "Mime-")
              (looking-at "Return-Path:")
              (looking-at "     ")
              (looking-at "\t")
              ))
        (forward-line 1)
      (progn
        (setq kkk 1)
        (setq p1 (point))
        (forward-line 1)
        (delete-region p1 (point))))
    )
  
  (save-excursion
    (forward-line 1)
    (if (looking-at "This is a multi-part") 
        (progn
          (setq p1 (point))
          (forward-line 5)
          (if (looking-at "Content-Transfer-Encoding") 
              (progn
                (forward-line 1)
                (delete-region p1 (point))
                )
            )
          )
      
      )
    )
  

  (if (= kkk 1) t nil)
  
  )



; ------- mm -------

(defun mm ()
  "Formats mbox file (msm)" (interactive)
  (setq p0 (point))
  (setq mtot 0) (setq mnew 0) (setq mgoto 0) (setq mclean 0)

  (while (re-search-forward "^From.*2001$" (point-max) t)
    (setq mtot (1+ mtot))
    (beginning-of-line)
    (save-excursion 
      (if (mm-clean-header) (setq mclean (1+ mclean))) )
  
    (save-excursion
      (search-forward " ") 
      (setq p1 (point))
      (search-forward " ")
      (setq xfr (mgetname (buffer-substring p1 (1- (point)))))
      (setq xdt (mgetdate (buffer-substring (point) (eol-point))))
      (forward-line 1)
      (setq xto " ") (setq xsb " ")
    
      (while (not (looking-at " *\n"))
        (if (looking-at "To:") 
            (save-excursion
              (search-forward " ")
              (setq xto (mgetname (buffer-substring (point) (eol-point))))
              ))
        (if (looking-at "Subject:") 
            (save-excursion
              (search-forward " ")
              (setq xsb (buffer-substring (point) (eol-point)))
              ))
        (forward-line 1)
        )
      (setq p2 (point))
      )        

    (save-excursion
      (forward-line -2)
      (if (looking-at "---") nil
        (forward-line 2)
        (if (= mgoto 0) (setq mgoto (point)))
        (insert (format "--- %8s > %-8s  %12s  %s\n\n" xfr xto xdt xsb))
        (setq mnew (1+ mnew))
        )
      )
    
    (goto-char p2)
    (if (= (mod mtot 5) 0) (message "entry %d ..." mtot))

    )
  
  (if (= mgoto 0) (goto-char p0)
    (goto-char mgoto) (recenter 0))

  (message "%d entries, %d new, %d cleaned " mtot mnew mclean)
)


(defun mg ()
  "Substitutes for weird german codes for Umlaute etc"
  (interactive)
  (setq case-replace nil)
  (save-excursion (replace-string "=E4" "ae"))
  (save-excursion (replace-string "=FC" "ue"))
  (save-excursion (replace-string "=F6" "oe"))
  (save-excursion (replace-string "=D6" "Oe"))
  (save-excursion (replace-string "=DF" "ss"))
  (save-excursion (replace-string "=DC" "Ue"))
  (save-excursion (replace-string "=C4" "Ae"))
  (save-excursion (replace-string "=91" "*"))
  (save-excursion (replace-string "=92" "*"))
  (save-excursion (replace-string "=E9" "e"))
  (save-excursion (replace-string " =\n" "\n"))
  (save-excursion (replace-string "=20" ""))
  (save-excursion (replace-string "ö" "oe"))
  (save-excursion (replace-string "Ö" "Oe"))
  (save-excursion (replace-string "Ä" "Ae"))
  (save-excursion (replace-string "Ü" "Ue"))
  (save-excursion (replace-string "ä" "ae"))
  (save-excursion (replace-string "ß" "ss"))
  (save-excursion (replace-string "ü" "ue"))
  (save-excursion (replace-string "é" "e"))
  (save-excursion (replace-string "´" "'"))
  (save-excursion (replace-string "’" "'"))
  (save-excursion (replace-string "„" "\""))
  (save-excursion (replace-string "“" "\""))
  (save-excursion (replace-string "iso-8859-1?Q?" ""))
  (save-excursion (replace-string "ISO-8859-1?Q?" ""))
  (save-excursion (replace-string "=?" ""))
)


(defun msplit (str)
  "Splits mail file by strings in header line"
  (interactive "s    msplit ")
  (msplit-kernel str 1)
)

(defun mget (str)
  "Extracts mail messages by strings in header line"
  (interactive "s    mget ")
  (msplit-kernel str nil)
)

(defun msplit-kernel (str kill-in-file)
  (setq rex "---.*\\(")
  (if (string= str "ABC")
      (setq str "abc walsh klab ceolas ' C ' majordom macaulay"))
  (setq str (concat str " "))
  (setq p1 0) (setq x 0)
  (while (string-match " " str p1)
    (setq p2 (match-beginning 0))
    (if (> p2 p1) 
        (progn 
          (setq x (1+ x))
          (setq ch (substring str p1 (1+ p1)))
          (if (string= ch "'") 
              (progn
                (setq p3 (match-beginning 0))
                (if (string-match "'" str p3)
                    (progn
                      (setq p1 (1+ p1))
                      (setq p2 (1- (match-end 0))))
                  (error "Quotes don't balance") )))
          (setq hhh (substring str p1 p2))
          (if (> x 1) (setq rex (concat rex "\\|")))
          (setq rex (concat rex hhh ))  ))
    (setq p1 (match-end 0))
    )
  (setq rex (concat rex "\\)"))
;  (error "<%s>" rex)
    
  (setq nowbuf (window-buffer))
  (switch-to-buffer "Extract") 
  (erase-buffer)
;  (set-visited-file-name "Extract")
  (switch-to-buffer nowbuf)
  (setq x 0)
  (goto-char (point-min))

  (while (re-search-forward rex nil t)
    (setq x (1+ x))
    (beginning-of-line) (setq p1 (point)) (forward-char 3)
    (search-forward "---" nil 1) (beginning-of-line) (setq p2 (point))

    (if kill-in-file (kill-region p1 p2)
      (copy-region-as-kill p1 p2))
    (save-excursion
      (set-buffer "Extract") 
      (goto-char (point-max))
      (yank)
      )
    (message "%d" x)
    )
  
  (switch-to-buffer "Extract") 
  (goto-char (point-min))
  (list-select "---")
  (message "Extracted %d for <%s>" x rex)
  
  )


