

(defun space-line (ch) 
  "Spaces blank-delimited words to eol with seperator CH"
  (setq s1 (concat "^ \n" ch))
  (setq s2 (concat " " ch))
  (setq p0 (point))
  (while (not (looking-at "\n"))
    (skip-chars-forward s1 (eol-point)) 
    (if (looking-at "\n") nil
      (setq pp (point)) (skip-chars-forward s2 (eol-point)) 
      (delete-region pp (point)) 
      (if (not (looking-at "\n")) (insert ch))))
  (goto-char p0) (if (looking-at ch) (delete-char 1))
)


; ----------- comment out/in regions ------------------
(defun ftn-comment-region (pos1 pos2 arg)
  "MSM ftn-comment-region; puts c  at start of lines."
  (if (not (mark)) (message "Mark not set")
    (setq start (min pos1 pos2))
    (setq end   (+ (max pos1 pos2) 1))
    (if arg (progn (setq f "  +[^ \n]") (setq r "c "))
      (progn (setq f "[cC] ")     (setq r "  ")))
    (save-excursion
      (goto-char start) (setq n 0)
      (while (<= (point) end)
        (beginning-of-line)
        (if (looking-at f) 
            (progn (setq n (+ n 1)) (delete-char 2) (insert r)))
        (next-line 1)   
        (end-of-line)
        )
      )
    (if arg (message "commented %d" n)
      (message "un-commented %d" n))  ))

(defun ftn-comment-out () "msm comment out" (interactive)
  (ftn-comment-region (point) (mark) t))

(defun ftn-comment-in () "msm comment in" (interactive)
  (ftn-comment-region (point) (mark) nil))

; ----------- inp and utp ----------------------------
(defun inp (strn) "MSM fortran input" (interactive "s    inp ")
    (end-of-line)
    (insert "\n      write(6,*) 'enter " strn":'")
    (insert "\n      read (5,*)  " strn)
    (search-backward strn) (space-line ",")
    (search-backward strn) (space-line ",")
    (search-backward "write")
)

(defun utp (strn) "MSM fortran output" (interactive "s    utp ")
    (end-of-line)
    (insert "\n      " strn)
    (search-backward strn) (space-line ",")
    (backward-char 1)
    (setq fmt "")    
    (setq p1 (eol-point))
    (while (< (point) p1)
      (forward-char 1)
      (if (looking-at "[i-nI-N]") 
        (setq fmt (concat fmt ",i5"))
        (setq fmt (concat fmt ",f12.6")))
      (forward-word 1)
      (if (looking-at "(") (progn (forward-word 1) (forward-char 1)))
    )
  (setq lab (point))
  (while (> lab 999) (setq lab (- lab 200)))
  (while (< lab 700) (setq lab (+ lab 200)))
  (beginning-of-line) (skip-chars-forward " ")
  (insert-string "write(6," lab ") ")
  (end-of-line) (insert "\n" strn)
  (search-backward strn) (space-line ",")
  (insert-string "  " lab " format('")
  (end-of-line) (insert "='" fmt ")")
  (if (> (line-len) 70) (progn
    (beginning-of-line) (forward-char 72) (search-backward ",")
    (forward-char 1) (insert "\n     . ")))
  (search-backward "write")
)

; ----------- pl: fortran-compare-call-args ----------
(defun pl () 
"   Compare arguments of a subroutine calls at mark and point (msm)"
   (interactive)
; setup: subroutine call at point
   (beginning-of-line)
   (fortran-next-statement) (fortran-previous-statement)
   (if (or (looking-at " +call +") (looking-at " +subroutine +"))
     (forward-sexp 1)) (skip-chars-forward " \t") (setq psav (point))
     (setq subnam (buffer-substring (point) 
         (progn (skip-chars-forward "a-z0-9_") (point))))
; list all args of sub call at mark
   (save-excursion
     (goto-char (mark))
     (beginning-of-line)
     (forward-sexp 2)
     (while (looking-at " ") (forward-char 1))
     (setq subrstrng (buffer-substring (+ 1 (point)) 
         (progn (forward-sexp) (- (point) 1))))
     (pop-to-buffer "*Compare*") (erase-buffer) 
     (insert subrstrng "\n")
     (goto-char (point-min)) (replace-string "     ." "")
     (goto-char (point-min))
     (while (< (point) (point-max))
       (forward-sexp) 
       (if (looking-at "(") (forward-sexp))
       (while (< (current-column) 15) (insert " "))
       (while (looking-at "[ \n\t,]") (delete-char 1)) (insert "\n"))
   )
; list all args of call at point
     (while (looking-at " ") (forward-char 1))
     (setq subrstrng (buffer-substring (+ 1 (point)) 
        (progn (forward-sexp) (- (point) 1))))
     (goto-char psav) (beginning-of-line) (skip-chars-forward " ")
     (setq strngsiz 1)
     (pop-to-buffer "*Compare*") (goto-char (point-min)) 
     (while (> strngsiz 0)
       (end-of-line) (setq thispt (point)) (insert subrstrng) 
       (setq endpt (point))
       (goto-char thispt) (forward-sexp) (if (looking-at " *(") (forward-sexp))
       (while (and (looking-at "[ \t,]") (> endpt (point)))
         (delete-char 1) (setq endpt (- endpt 1)))
       (if (and (looking-at "\n") (> endpt (point)))
           (progn (delete-char 7) (setq endpt (- endpt 7))
                  (while (and (looking-at "[ \t,]") (> endpt (point)))
                    (delete-char 1) (setq endpt (- endpt 1)))))
       (setq subrstrng (buffer-substring (point) endpt))
       (setq strngsiz (- endpt (point)))
       (delete-char (- endpt (point)))
       (next-line 1))
; add line numbers
     (goto-char (point-min)) (setq num 0)
     (while (< (point) (point-max))
        (beginning-of-line) (setq num (+ num 1)) (insert "  ")
        (if (< num 10)  (insert " "))
        (if (< num 100) (insert " "))
        (insert-string num "         ")
        (forward-line 1))
     (goto-char (point-min))
     (insert-string "    " subnam " (" num  ")\n")
     (insert "    ---------------------------------\n")
      (delete-other-windows)
      (goto-char (point-min))
)

; ----------- call ----------
(defun call (arg) 
"Insert call to subroutine NAME after point. Looks in FILE if specified.
First searches buffers, then directories def-dir,/<prj>/f,inv-dir (msm)."
  (interactive "s    call ")
  (if (string-match " " arg) (progn
    (setq nam (substring arg 0 (match-beginning 0)))
       (setq sub (substring arg (match-end 0))))
    (setq sub arg) (setq nam sub))
  (setq full (concat sub ".f")) 
  (setq dir nil)
  (if (get-buffer full) (setq dir "buffer")
    (if (file-exists-p (concat invoke-directory full))
        (setq dir invoke-directory))
    (setq dar (substitute-in-file-name "~/$Z_prj/f/"))
    (if (file-exists-p (concat dar full)) (setq dir dar))
    (if (file-exists-p (concat default-directory full))
        (setq dir default-directory)))
  (if (not dir) (message "Sub %s not found" sub)
    (save-excursion
       (if (string= dir "buffer") (set-buffer full) 
           (find-file (concat dir full)))
       (goto-char (point-min))
       (re-search-forward (concat "^ *subroutine " nam))
       (goto-char (bol-point))
       (setq psav (point)) (forward-sexp 3)
       (setq str (buffer-substring psav (point)))
       (if (not (string= dir "buffer")) (kill-buffer full)) )
    (save-excursion (end-of-line) (insert "\n" str))
    (search-forward "\n")
    (skip-chars-forward " ")
    (if (looking-at "subroutine") (progn
    (delete-char 10) (insert "call") (backward-char 4)))
    (message "Found in %s" dir)
  )
)

; ----------- tree ------------------
(defun tree ()
"Builds tree of calls and list of sub files, root=current file  (msm)."
  (interactive)
  (setq prog (buffer-name))
  (if (string-match "\\.f" prog)
    (setq prog (substring prog 0 (match-beginning 0) )))
  (setq treeb (concat prog ".tr"))
  (setq listb (concat prog ".fl"))
  (if (get-buffer treeb) (kill-buffer treeb))
  (if (get-buffer listb) (kill-buffer listb))
  (pop-to-buffer "*Tree*") (erase-buffer)
  (pop-to-buffer "*List*") (erase-buffer)
  (fortran-make-tree-kernel prog 0 prog nil)
  (switch-to-buffer "*List*") (goto-char (point-min))
  (rename-buffer listb) 
  (setq buffer-file-name (concat default-directory listb))
  (switch-to-buffer "*Tree*") (delete-other-windows)
  (prettify-tree) (goto-char (point-min)) 
  (rename-buffer treeb) 
  (setq buffer-file-name (concat default-directory treeb))
)

(defun fortran-make-tree-kernel (prog level msg kill-flag)
  (if (> level 10) (error "Depth gt %d" level))
  (setq prog (downcase prog))
  (set-buffer "*List*")  ; add name to list
  (goto-char (point-min))
  (setq new (not (re-search-forward (concat "^" prog) nil t)))
  (if new (progn (goto-char (point-max)) (insert prog "\n")) ) 
  (setq fname (concat prog ".f"))
  (setq go (file-exists-p fname))

  (setq suff " ")        ; set suffix for tree line
  (if (not go) (setq suff " /"))
  (if (not new) (setq suff " .."))

  (set-buffer "*Tree*")  ; add line to tree
  (setq levstr (int-to-string level))
  (insert levstr "    ")
  (setq cc 1) (while (< cc level) (setq cc (+ cc 1)) (insert "    "))
  (if (> level 0) (insert " `--"))
  (insert prog suff "\n") 

  (if (not new) (setq go nil))
  (if (string= prog "defrr")  (setq go nil))
  (if (string= prog "rlse")   (setq go nil))
  (if (string= prog "dpzero") (setq go nil))
  (if (string= prog "dpdump") (setq go nil))
  (if (string= prog "rx")     (setq go nil))
  (if (string= prog "tc")     (setq go nil))

  (if go (progn     ; call kernel recursively
   (message msg)
   (find-file (concat prog ".f")) (goto-char (point-min))
   (while (re-search-forward "^[^\*cC].* call " (point-max) t)
     (skip-chars-forward " ")
     (setq subnam (buffer-substring (point) (progn (forward-sexp 1) (point))))
     (save-excursion
       (previous-line 1) (setq sestr (concat "^[^c].* call *" subnam))
       (setq first (not (re-search-backward sestr (point-min) t))))
     (if first (progn
       (fortran-make-tree-kernel subnam (+ level 1) (concat msg " " subnam) t)
       (set-buffer (concat prog ".f")))))
   (if kill-flag (kill-buffer (concat prog ".f")))
  ))
)


(defun char-below ()  ; return char below point 
  (save-excursion
    (next-line 1)
    (if (= (point) (point-max)) ""
      (buffer-substring (point) (1+ (point)))))
  )


(defun prettify-tree () (interactive)  ; fix up format of tree 
  (message "Prettify ..") 
  (goto-char (point-max)) (insert "\n")

  (while (re-search-backward "[ `]" nil t)
    (progn 
      (setq c1 (char-below))
      (if (or (string= c1 "`") (string= c1 "|"))
          (progn (delete-char 1) (insert "|") (backward-char 1) )))
    )

  (message "done")
)


;(global-set-key "ô" 'prettify-tree)                       ; t
