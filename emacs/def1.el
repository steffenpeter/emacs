; save some older stuff

(defun ggg () (interactive)
  (goto-bob) (replace-string "\341" "\\ss ")
  (goto-bob) (replace-string "\224" "\\\"o")
  (goto-bob) (replace-string "\201" "\\\"u")
  (goto-bob) (replace-string "\204" "\\\"a")
  (goto-bob) (replace-string "\232" "\\\"U")
)

(defun hhh () (interactive)
;  (goto-bob) (replace-string "" "\n")
  (goto-bob) (replace-string "" "")
  )

(defun iii () (interactive)
;  (goto-bob) (replace-regexp "\260" "$^\circ$")
  (goto-bob) (replace-string "\n\n" "\n")
  )

(defun rrr () (interactive)
; dont know why gymnastics needed... otherwise get All not all
  (goto-bob) (replace-string "00/" "SnOtX/") 
  (goto-bob) (replace-string "01/" "SnOtX/") 
  (goto-bob) (replace-string "02/" "SnOtX/") 
  (goto-bob) (replace-string "03/" "SnOtX/") 
  (goto-bob) (replace-string "04/" "SnOtX/") 
  (goto-bob) (replace-string "05/" "SnOtX/") 
  (goto-bob) (replace-string "06/" "SnOtX/") 
  (goto-bob) (replace-string "07/" "SnOtX/") 
  (goto-bob) (replace-string "08/" "SnOtX/") 
  (goto-bob) (replace-string "09/" "SnOtX/") 
  (goto-bob) (replace-string "SnOtX" "all") 

  )

(setq fstring1 "StArT")
(setq fstring2 "EnD")

(defun dlines () 
  "Deletes the lines between those identified by start and end strings (msm)"
  (interactive)
 (setq fstr1 (read-from-minibuffer 
     (format "dlines [%s] [%s]  From: " fstring1 fstring2)))
 (if (string= fstr1 "") nil
    (setq fstr2 (read-from-minibuffer 
     (format "dlines [%s] [%s]  To: " fstr1 fstring2)))
    (if (string= fstr2 "") (setq fstr2 fstring2))
    (setq fstring1 fstr1) (setq fstring2 fstr2))
;    (message "dlines [%s] [%s]" fstring1 fstring2) 
  (if (not (re-search-forward fstring1 (point-max) t)) 
           (message "First string not found: %s" fstring1)
     (setq p1 (bol-point)) (setq l1 (l-num))
     (if (not (re-search-forward fstring2 (point-max) t)) 
           (message "Second string not found: %s" fstring2)
        (setq p2 (bol-point)) (setq l2 (l-num))
        (delete-region p1 p2)
        (message "Deleted lines %d to %d (%d)" l1 l2 (- l2 l1))
     )
  )
)

(defun lc () "Alias for downcase-region." (interactive)
  (downcase-region (point) (mark)))

(defun find-file-prj () 
 "Find a file on directory ~/<prj>/f  (msm)"
 (interactive) 
 (setq dir (concat "~/" (substitute-in-file-name "$Z_prj") "/f"))
 (setq try (read-from-minibuffer (concat "File: " dir"/")))
 (setq trl "")
 (while (not (file-exists-p (concat dir "/" try)))
   (setq tra (file-name-completion try dir))
   (if (not tra) (setq try trl) (setq try tra) (setq trl tra))
   (setq try (read-from-minibuffer (concat "File: " dir"/") try)) ) 
 (find-file (concat dir "/" try))
)

;(defun x (strn) "MSM find file" (interactive "F    x ")
;  (msm-find-file strn))

(defun kill-emacs-query () (interactive)
  (if (yes-or-no-p "Kill emacs? ") (kill-emacs)) )

(defun es () "MSM find file <sub>" (interactive)
(msm-find-file (substitute-in-file-name "~/$Z_prj/$Z_work/$Z_sub.f")))

(defun em () "MSM find file <main>" (interactive)
(msm-find-file (substitute-in-file-name "~/$Z_prj/$Z_work/$Z_main.m.f")))

(defun ef () "MSM find file <file>" (interactive)
(msm-find-file (substitute-in-file-name "~/$Z_prj/$Z_work/$Z_file")))

(defun msm-ftn-wcall () "Puts w(o..) around a variable." (interactive)
 (forward-sexp 1) 
 (backward-sexp 1) (insert-string "w(o")
 (forward-sexp 1)  (insert-string ")") )

; slow but interferes less with scrolling in next-line and previous-line:
(defun l-num () "Return current line number. " (interactive)
   (save-excursion 
     (beginning-of-line) (setq pp (point))
     (setq c 1) (goto-char (point-min))
     (while (< (point) pp) (forward-line 1) (setq c (1+ c)))
   ) c)

(defun top () "Toggle whether to move to top after search (msm)"
  (interactive)
  (if top (setq top nil) (setq top t))
  (if top (message "    top now ON") (message "    top now OFF"))
  )

(defun mk (strn) 
  "MSM Mark lines containing STRING; empty to un-mark." 
  (interactive "s    mk ")
  (setq l1 (line-num))            
(save-excursion
  (goto-char (point-min))
  (setq mkflag (looking-at "M:"))
  (if (string= strn "")              ; following removes marks 
    (if mkflag (progn 
      (while (< (point) (point-max))
       (delete-char 4) (search-forward "\n")) ))
  (setq i 0)                         ; following makes the marks
  (setq xx (search-forward strn (eol-point) t))
  (goto-char (point-min))
  (if mkflag (delete-char 4))
  (if (not xx) (insert "M: |")
     (insert "M:1|") (setq i 1))
  (search-forward "\n")
  (setq j 1)
  (while (< j l1)
     (setq j (1+ j)) (if mkflag (delete-char 4))
     (insert "   |") (search-forward "\n") )
  (while (< (point) (point-max))
    (setq xx (search-forward strn (eol-point) t))
    (goto-char (bol-point))
    (if mkflag (delete-char 4))
    (if (not xx) (insert "   |")
      (setq i (1+ i)) (setq xx (int-to-string i))
      (while (< (length xx) 3) (setq xx (concat xx " " )))
      (insert (concat xx "|")))
    (search-forward "\n")) 
  (message "    %d line(s) marked" i)
  (setq savestrn strn)
  )  ) ; end save-ex
)

(defun bind (arg) "bind command to a-t for testing" 
  (interactive "C    bind ")
  (global-set-key "[078q" arg))

; ------ motion, registers etc -----

(defun vr () "msm view register -- RET to quit" (interactive)
  (let ((tmp register-alist) (str "") (char))
    (while tmp
      (setq z (car tmp))
      (setq char (car z))
;  with next line: writes each one for one sec
;      (message "%c  %s " char (cdr z)) (sleep-for 1)
      (setq str (concat str (format "%c " char)))
      (setq tmp (cdr tmp)) 
      )
    (if (string= str "") (error "no registers defined"))
    (message "Select register: %s" str)
    (while (not (equal char ?\r))
      (setq char (read-char))
      (if (not (equal char ?\r)) 
          (let ((val (get-register char)))
            (if (markerp val) 
                (message "Select register: %s    %c is position %d in %s" 
                         str char 
                         (marker-position val) (marker-buffer val))
              (message "Select register: %s    %c is not a marker"
                       str char))
            )))
      (message "")
      ))

;|(defun next-comment-line () (interactive)
;|  (next-line 1) (re-search-forward "---" (point-max) 1) 
;|  (recenter 0))

;|(defun previous-comment-line () (interactive)
;|  (previous-line 1) (re-search-backward "---" (point-min) 1) 
;|  (recenter 0))

(defun next-search-line () (interactive)
  (next-line 1) (re-search-forward savestrn (point-max) 1) 
  (recenter 0))

(defun previous-search-line () (interactive)
  (previous-line 1) (re-search-backward savestrn (point-min) 1) 
  (recenter 0))

(defun last-search-line () (interactive)
  (goto-char (point-max)) (re-search-backward savestrn (point-min) 1) 
  (recenter 0))

(defun last-comment-line () (interactive)
  (goto-char (point-max)) (re-search-backward "---" (point-min) 1) 
  (recenter 0))

(defun buffer-list-only () (interactive)
  (list-buffers) (switch-to-buffer "*Buffer List*") 
  (delete-other-windows))

;|(defun kill-yank-region () (interactive)
;|  (copy-region-as-kill (point) (mark))
;|  (message "%d line(s) buffed" (count-lines (point) (mark)))
;|  )

;|(defun locate-key () (interactive)  ; find RE... put on ' key
;|  (setq strn (read-from-minibuffer "'"))
;|  (if (string= strn "") (setq strn savestrn))
;|  (let ((i 0))
;|    (setq i (1- (length strn)))
;|    (if (string= (substring strn i) "'") (setq strn (substring strn 0 i))))
;|  (setq savestrn strn)
;|  (if (re-search-forward savestrn (point-max) t) 
;|      (progn
;|        (if top (recenter 0))
;|        (message "Search successful: '%s'" savestrn))
;|    (error "Search failed: '%s'" savestrn ) ) )

;|(defun previous-search () (interactive)
;|  (if (re-search-backward savestrn (point-min) t) 
;|      (progn
;|        (if top (recenter 0))
;|        (message "Search successful: '%s'" savestrn))
;|    (error "Search failed: '%s'" savestrn ) ) )

;|(defun next-search () (interactive)
;|  (if (re-search-forward savestrn (point-max) t) 
;|      (progn
;|        (if top (recenter 0))
;|        (message "Search successful: '%s'" savestrn))
;|    (error "Search failed: '%s'" savestrn ) ) )


;|(defun show-savestrn () (interactive)
;|  (setq savestrn "---")
;|  (message "Search string set to %s" savestrn))

;|(defun kill-to-end-of-buffer () (interactive)
;|(save-excursion
;|   (setq p1 (point)) (end-of-buffer) (kill-region p1 (point))))

;|(defun goto-eob () (interactive) 
;|   (goto-char (point-max)) (recenter -1) )

;|(defun goto-bob () (interactive) (goto-char (point-min)))

;|(defun scroll-up-some () (interactive) (next-line 5) (scroll-up 5))
;|(defun scroll-dn-some () (interactive) (previous-line 5) (scroll-down 5))
;|(defun scroll-up-1 () (interactive) (next-line 1) (scroll-up 1))
;|(defun scroll-dn-1 () (interactive) (previous-line 1) (scroll-down 1))

;(defun load-emacs () (interactive) (load-file "~/.emacs"))


(defun mm1 () (interactive)
  (setq bbb (+ (/ (point) 512) 1))
  (setq iii (+ (* bbb 512) 1))
  (goto-char iii)
  (message "b%d  %d" bbb iii)
  )

(defun mm2 () (interactive)
  (setq bbb (/ (- (point) 2) 512))
  (setq iii (+ (* bbb 512) 1))
  (goto-char iii)
  (message "b%d  %d" bbb iii)
  )

;(global-set-key "[168q" 'mm1)
;(global-set-key "[159q" 'mm2)

;|(defun kill-this-word () 
;|  "Kills the word containing the point (msm)"
;|  (interactive) 
;|  (forward-char -1)
;|  (forward-word 1) (forward-word -1) (kill-word 1) 
;  (if (looking-at " ") (delete-char 1))
;|  )

(defun space-line (ch) "Spaces blank-delimited words to eol with seperator CH"
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

(defun num (strn) "insert line numbers with increment INC  (msm)" 
  (interactive "s    num ")
; first code positive real as incr * 10^(-idig)
  (if (string= strn "") (setq strn "1"))
  (setq strn (substring strn (string-match "[^ ]" strn)))
  (setq strn (substring strn 0 (string-match " " strn)))
  (if (not (string-match "\\." strn)) (setq strn (concat strn ".")))
  (setq i (string-match "\\." strn))
  (setq aa (substring strn 0 i))
  (setq bb (substring strn (1+ i) ))
  (setq idig (length bb))
  (setq incr (string-to-int (concat aa bb)))
;  (message "strn=<%s> i=%d <%s> <%s> incr=%d idig=%d " strn i aa bb incr idig)
  (goto-char (point-min))
  (setq i 0)
  (while (< (point) (point-max))
    (setq i (+ i incr))
    (setq xx (int-to-string i))
    (while (<= (length xx) idig) (setq xx (concat "0" xx)))
    (while (< (length xx) 6)    (setq xx (concat " " xx)))
    (insert xx "  ") (backward-char 2)
    (if (> idig 0) (progn
      (backward-char idig) (insert ".")))
    (search-forward "\n") 
  )
) 

(defun ap () 
  "Append lines in region to buffer ap.ap   (msm)"
  (interactive)
  (save-excursion (goto-char (mark)) (setq l1 (line-num)))
  (setq head (concat (buffer-name) "  (" l1 " - " (line-num) ")"))  
  (setq head (read-from-minibuffer "Header: " head ))
  (setq apbuf (get-buffer-create "ap.ap"))
  (save-excursion
    (set-buffer apbuf)
    (setq buffer-file-name "ap.ap")
    (goto-char (point-max))
    (insert "\n========  " head "  ======== \n"))
  (delete-other-windows)
  (setq x1 (point)) (setq x2 (mark))
  (setq p1 (min x1 x2)) (setq p2 (max x1 x2))
  (save-excursion
    (goto-char p1) (setq p1 (bol-point))
    (goto-char p2) (setq p2 (eol-point)))
  (setq p2 (min (+ p2 1) (point-max)))
  (append-to-buffer "ap.ap" p1 p2))

(defun inform () "Inform on cursor position  (msm)."
  (interactive)
  (setq char (following-char))
  (setq lines (count-lines (point-min) (point-max)))
  (save-excursion
      (beginning-of-line)
      (setq line (1+ (count-lines 1 (point)))))
  (setq lines (count-lines 1 (point-max)))
  (message "Char: %-3s (%d O%o X%x)  %d of %d  line %d of %d  col %d of %d"
    (single-key-description char) char char char (point) (point-max)
    line lines (+ 1 (current-column)) (line-len))
  )

(defun emacs-inform ()  "Inform on editor... (msm)"
  (interactive)
  (message "inv-dir %s, def-dir %s" invoke-directory default-directory))

(defun file-inform () "Inform on current file  (msm)"
  (interactive)
  (save-excursion (goto-char (point-max)) (setq lines (- (l-num) 1)))
  (save-excursion 
   (goto-char (point-min)) (setq ml (line-len))
   (while (< (point) (point-max))
     (forward-line 1)
     (setq ml (max ml (line-len)))
  ))
  (if (= (point-max) 1) (setq saf "") (setq saf "s"))
  (if (= lines 1)       (setq suf "") (setq suf "s"))
  (message "%s  %d byte%s, %d line%s, recl %d"
    buffer-file-name (point-max) saf lines suf ml) )

;(defun jump-forward () "Move forward rapidly (msm)" (interactive)
; (if (looking-at "\n") (forward-char 1)
;   (goto-char (min (+ (point) 10) (eol-point))) ) )
;(defun jump-backward () "Move backward rapidly (msm)" (interactive)
; (if (= (point) (bol-point)) (forward-char -1)
;  (goto-char (max (- (point) 10) (bol-point)) )) )

(defun jump-up () (interactive) 
  (backward-paragraph)
  (recenter 0)
)

(defun jump-down () (interactive) 
  (forward-paragraph)
  (recenter 0)
)

(defun scr-left  () (interactive) 
  (scroll-left  20) (message "Scrolled by %d" (window-hscroll)))
(defun scr-right () (interactive) 
  (scroll-right  20) (message "Scrolled by %d" (window-hscroll)))

;(defun nop () (interactive) (message "nothing done"))

; ----------- fset's --------------------------
;|(fset 'ctrl-z "")
;|(fset 'kill-yank "")
;|(fset 'kill-previous-line "[160q [A")
;|(fset 'move-down-line "[160q")
;|(fset 'kill-to-start-of-line " [160q")

; ----------- dired modifications -----------

;|(defun msm-dired-init ()    ; key defs for dired-load-hook
;|  (define-key dired-mode-map ""   'dired-find-file)         ; RET
;|  (define-key dired-mode-map "[A" 'dired-previous-line)     ; Up
;|  (define-key dired-mode-map "[B" 'dired-next-line)         ; Down
;|  (define-key dired-mode-map "[D" 'beginning-of-line)       ; Left
;|  (define-key dired-mode-map "[C" 'dired-eol)               ; Right
;|  (define-key dired-mode-map " " 'dired-unflag) 
;|  (define-key dired-mode-map "d" 'dired-flag-file-deleted-msm) 
;|  (define-key dired-mode-map "u" 'dired-unflag-msm) 
;|  (define-key dired-mode-map "s" 'dired-sort) 
;|  (define-key dired-mode-map "a" 'dired-all-files) 
;|  (define-key dired-mode-map "z" 'dired-flag-empty-files)
;|  (define-key dired-mode-map "!" 'dired-apply-command)
;|)

;|(defun dired-summary ()
;|  (interactive)
;|  (message
;|   "d-el, u-ndel, x-ecute, a-ll, r-ename, c-opy, s-ort, z-eroflag, !-Do"))

;|(defun dirpat () 
;|  "Enters dired with pattern in env-var PATTERN, + means * (msm)."
;|  (interactive)
;|  (get-buffer-create "*Snot*")
;|  (set-buffer "*Snot*") (erase-buffer)
;|  (insert (substitute-in-file-name "$PATTERN") )
;|  (if (= (buffer-size) 0) (setq text "")
;|    (goto-char (point-min)) (replace-string "+" "*")
;|    (setq text (buffer-string)))
;|  (kill-buffer "*Snot*") (delete-other-windows)
;|  (setq dired-listing-switches "-la")
;|  (dired text)
;|)  

;|(defun fl (strn) "MSM start dired" (interactive "s    fl ")
;|  (setq dired-listing-switches "-la")
;|  (dired strn))

;|(defun dired-sort (strn) "MSM sort in dired" 
;|  (interactive "sSort by (n-ame, t-ime, s-ize, m-ode): ")
;|  (if (string= strn "t") (progn
;|      (setq dired-listing-switches "-lat")
;|      (dired dired-directory "-lat")
;|      ))
;|  (if (string= strn "n") (progn
;|      (setq dired-listing-switches "-la")
;|      (dired dired-directory)
;|      ))
;|  (if (string= strn "s") (progn
;|      (let ((buffer-read-only nil))
;|        (goto-char (point-min))
;|        (forward-line 1)
;|        (setq xx (point))
;|        (sort-numeric-fields -5 xx (point-max)) )
;|      ))
;|  (if (string= strn "m") (progn
;|      (let ((buffer-read-only nil))
;|        (goto-char (point-min))
;|        (forward-line 1)
;|        (setq xx (point))
;|        (sort-fields -1 xx (point-max)) )
;|      ))
;|  (goto-char (point-min))
;|)

;|(defun dired-all-files () (interactive)
;|  (setq dired-listing-switches "-Al")
;|  (dired dired-directory))

;|(defun dired-flag-file-deleted-msm (arg)
;|  (interactive "p")
;|  (dired-repeat-over-lines arg
;|    '(lambda ()
;|       (let ((buffer-read-only nil))
;|         (delete-char 1)
;|         (insert "D"))))
;|  (next-line -1)    ; don't move down after flagging
;|)

;|(defun dired-unflag-msm (arg)
;|  (interactive "p")
;|  (dired-repeat-over-lines arg
;|    '(lambda ()
;|       (let ((buffer-read-only nil))
;|         (delete-char 1)
;|         (insert " ")
;|         (forward-char -1))))
;|  (next-line -1)    ; don't move down after flagging
;|)

;|(defun dired-eol () (interactive)
;|  (dired-move-to-filename))

;|(defun dired-flag-empty-files ()
;|  "Flag for deletion files of length zero (msm)."
;|  (interactive)
;|  (save-excursion
;|   (let ((buffer-read-only nil) (num 0))
;|     (goto-char (point-min)) (forward-line 1)
;|     (while (not (eobp)) (and (not (looking-at "  d")) (not (eolp))
;|        (progn
;|          (beginning-of-line)
;|          (forward-sexp 5)
;|          (forward-word -1)
;|          (if (looking-at "0") 
;|              (progn (beginning-of-line)
;|                     (setq num (1+ num))
;|                     (delete-char 1)
;|                     (insert "D"))  )
;|          )
;|        )
;|        (forward-line 1))
;|     (message "Flagged: %d" num)
;|     )))

;|(defun dired-apply-command (cmd)
;|  "Apply command to file in current line (msm)."
;|  (interactive "sCommand: ")
;|  (setq file (dired-get-filename))
;|  (shell)
;|  (if (string= cmd "") nil 
;|    (insert cmd " " file)
;|    (shell-send-input) )
;|  )

