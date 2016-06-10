
(setq defstrn "---")
(setq savestrn "---")
(setq top nil)
(setq tab-width-msm 3) 

; ----------- utilities  ------------------

(defun nop () (interactive) (message "Quit!"))

(defun eol-point (&optional count)
  "Return the point at the end of the current line."
  (save-excursion
    (end-of-line count)
    (point)))

(defun bol-point (&optional count)
  "Return the point at the beginning of the current line."
  (save-excursion
    (beginning-of-line count)
    (point)))

(defun kill-to-start-of-line () (interactive)
  (let ((beg (point))) (beginning-of-line) (kill-region beg (point))) )

(defun kill-previous-line () (interactive)
  (beginning-of-line) 
  (let ((beg (point))) 
    (forward-line -1)
    (kill-region beg (point))) )

(defun next-blank-line () (interactive) ; move point to blank line
  (re-search-forward "\n *\n" (point-max) 1)
  (forward-char -1) (beginning-of-line)
  )

(defun words (string)   ; returns number of words in string
  (setq string (concat string " "))
  (setq pp 0)         
  (setq num 0)        
  (setq pp (string-match "[^ ]" string pp))
  (while pp           
    (setq num (1+ num))
    (setq pp (string-match " "    string pp)) 
    (setq pp (string-match "[^ ]" string pp))
    )                 
  num )               
                      
(defun word (string n)   ; returns n'th word in string
  (setq string (concat string " "))
  (if (or (< n 1) (> n (words string))) ""
    (setq pp 0)         
    (setq num 0)        
    (while (< num n)    
      (setq num (1+ num))
      (setq qq (string-match "[^ ]" string pp))
      (setq pp (string-match " "    string qq)) 
      )                 
    (substring string qq pp) 
    )
  )

(defun line-num () "Return current line number." (interactive)
   (save-excursion
     (beginning-of-line) (1+ (count-lines 1 (point)))) )

(defun line-len () (interactive)
  (- (save-excursion (end-of-line) (point)) 
      (save-excursion (beginning-of-line) (point))))

(defun goto-bob () (interactive) 
  (goto-char (point-min)))

(defun goto-eob () (interactive) 
  (if (looking-at "\n") (message "AT END")) 
  (goto-char (point-max)) (recenter -1) )

(defun goto-bol () (interactive) 
  (beginning-of-line)
  )

(defun goto-eol () (interactive) 
  (end-of-line)
  )

(defun put-string (strn) 
"Inserts or overwrites STRN after point, depending on overwrite-mode (msm)."
  (if overwrite-mode (delete-char 
     (min (length strn) (- (eol-point) (point))) ))
  (insert strn) )

; ------- real functions -----

(defun point-to-top () (interactive)
  (beginning-of-line) (recenter 0)
  (point-to-register ?h))

(defun point-to-top-save () (interactive)
  (beginning-of-line)
  (point-to-register ?H) (recenter 0)
  (message "Point saved"))

(defun recover-point  () (interactive)
  (register-to-point ?H) (recenter 0)
  (delete-other-windows)
  (message "Return to saved position")
  )

(defun j-to-register () "MSM jump-to-register" 
  (interactive)
  (let ((tmp register-alist) (str "") (char))
    (while tmp
      (setq z (car tmp))
      (setq char (car z))
      (setq str (concat str (format "%c " char)))
      (setq tmp (cdr tmp)) 
      )
    (message "Select register: %s" str)
    (setq char (read-char))
    (if (not (equal char ?\r ))
        (if (jump-to-register char) (recenter 0))))
  )

(defun p-to-register (c) "MSM find file" 
  (interactive "cPoint to register: ")
  (if (equal c ?\r ) (nop)
    (point-to-register c) 
    (message "Saved in register %c" c))
  )

(defun last-comment-line () (interactive)
  (goto-char (point-max)) (re-search-backward "---" (point-min) 1) 
  (recenter 0))

(defun first-comment-line () (interactive)
  (goto-char (point-min)) (re-search-forward "---" (point-max) 1) 
  (recenter 0))

(defun kill-this-word () 
  "Kills the word containing the point (msm)"
  (interactive) 
  (forward-char -1)
  (forward-word 1) (forward-word -1) (kill-word 1) 
  (if (looking-at " ") (delete-char 1))
  )

(defun locate-key () (interactive)  ; find RE... put on ' key
  (if (string= (buffer-name) " *Minibuf-0*")
      (exit-minibuffer)
    (setq strn (read-from-minibuffer "'")))
  (if (string= strn "") (setq strn savestrn))
  (let ((i 0))
    (setq i (1- (length strn)))
    (if (string= (substring strn i) "'") (setq strn (substring strn 0 i))))
  (setq savestrn strn)
  (if (re-search-forward savestrn (point-max) t) 
      (message "Search successful: '%s'" savestrn)
    (error "Search failed: '%s'" savestrn ) ) 
  )

(defun locate-bw-key () (interactive)  ; find RE... put on ' key
  (if (re-search-backward savestrn (point-min) t) 
      (message "Search successful: '%s'" savestrn)
    (error "Search failed: '%s'" savestrn ) ) )

(defun goto-other-window () (interactive)
  (if (< (count-windows) 2) (split-window-vertically))
  (other-window 1)
  )

(defun next-comment-line () (interactive)
  (let ((xx (point))) 
    (end-of-line)
    (if (search-forward "---" (point-max) 1) 
        (recenter 0)
      (goto-char xx)
      (error "End of buffer"))
    )
  )

(defun previous-comment-line () (interactive)
  (previous-line 1) (search-backward "---" (point-min) 1) 
  (recenter 0)
  )

(defun buffer-names-string (&optional arg) 
  "Returns string of buffer names. Optional ARG non-nil to get all (msm)"
  (setq text "")
  (let* ((buffers (buffer-list)))
    (while buffers
      (setq bnam (buffer-name (car buffers)))
      (setq mx (or
                (string-match "*Occur*"         bnam)
                (string-match "*scratch*"       bnam)
                (string-match "*Buffer List"    bnam)
                (string-match "*Completions*"   bnam)
                (string-match "*Help*"          bnam)
                (string-match "*Comm*"          bnam)
                (string-match "*Dele*"          bnam)
                (string-match "*pixmap"         bnam)
                (string-match "*Echo"           bnam)
                (string-match "*Minibuf"        bnam)
                (string-match "*Messages*"      bnam)))
      (if (or arg (not mx))
          (setq text (concat bnam " " text)))  
      (setq buffers (cdr buffers)) ))
  
  (if (> (length text) 70) 
      (progn
        (setq text (substring text -70))
        (setq text (concat ".. " text))))
  (if (string= text "") nil text)
  
  )
 
(defun multi-quit () "MSM multi-purpose quit." (interactive)
  (setq bnam (buffer-name)) (setq task "quit")
  (if (string= bnam "*Occur*")       (setq task "occ"))   ; decide task
  (if (string= bnam " *Minibuf-0*")  (setq task "mini"))
  (if (string= bnam " *Minibuf-1*")  (setq task "mini"))
  (if (string= bnam " *Minibuf-2*")  (setq task "mini"))
  (if (string= bnam "*Buffer List*") (setq task "bufl"))
  (if (get-buffer-window "*Help*")   (setq task "help"))
  (if (string= task "help") (progn
     (delete-other-windows) (kill-buffer "*Help*") ))
  (if (string= task "mini") (abort-recursive-edit))
  (if (string= task "bufl") (kill-buffer-list))
  (if (string= task "occ")  (kill-occur-buffer))
  (if (string= task "dir")  (switch-to-buffer "*Dir*"))
  (if (string= task "quit") (progn       ; here really kill the buffer
    (kill-buffer (buffer-name))
    (if (buffer-names-string) (message (buffer-names-string))
       (save-buffers-kill-emacs)) ))     ; exit if no more real buffers
)

(defun kill-buffer-list () (interactive) (kill-buffer "*Buffer List*"))

(defun list-buffers-briefly  () 
  "List important buffer names in minibuffer (msm)" (interactive) 
  (message (buffer-names-string )))

(defun list-buffers-briefly-all  () 
  "List all buffer names in minibuffer (msm)" (interactive) 
  (message (buffer-names-string  1)))

(defun kill-yank-region () (interactive)
  (copy-region-as-kill (point) (mark))
  (message "%d line(s) buffed" (count-lines (point) (mark))) )

(defun load-emacs () (interactive) (load-file "~/.emacs"))

(defun xnl () "Switch off final newline" 
  (interactive) 
  (setq require-final-newline nil)
  (message "require-final-newline now set to nil")
  )

(defun msm-ftn-wcall () "Puts w(o..) around a variable." (interactive)
 (forward-sexp 1) 
 (backward-sexp 1) (insert-string "w(o")
 (forward-sexp 1)  (insert-string ")") )

; move cursor and inform.. put on shift-arrows
(defun n-char-i () (interactive) (forward-char 1)  
  (if do-inform (inform)))
(defun p-char-i () (interactive) (backward-char 1) 
  (if do-inform (inform)))
(defun n-line-i () (interactive) (next-line 1)     
  (if do-inform (inform)))
(defun p-line-i () (interactive) (previous-line 1) 
  (if do-inform (inform)))

