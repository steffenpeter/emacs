;; MSM math mode

(defvar math-mode-map nil "")
(if math-mode-map
    ()
  (setq math-mode-map (make-sparse-keymap))
  (define-key math-mode-map "x" 'mathm-get-x)
  (define-key math-mode-map "y" 'mathm-get-y)
  (define-key math-mode-map "f" 'mathm-set-format)
  (define-key math-mode-map "q" 'mathm-query)
  (define-key math-mode-map "+" 'mathm-add)
  (define-key math-mode-map "-" 'mathm-sub)
  (define-key math-mode-map "*" 'mathm-mul)
  (define-key math-mode-map "/" 'mathm-div)
  (define-key math-mode-map "\t" 'mathm-tab)
;  (define-key math-mode-map "[B" 'mathm-fwline)
;  (define-key math-mode-map "[A" 'mathm-bwline)
;  (define-key math-mode-map "[C" 'mathm-fwchar)
  (define-key math-mode-map "[166q" 'mathm-fwline)   ; alt-dn
  (define-key math-mode-map "[163q" 'mathm-bwline)   ; alt-up
  (define-key math-mode-map "m" 'set-mark-command)
  (define-key math-mode-map "c" 'mathm-col-prefix)
  (define-key math-mode-map "k" 'mathm-kol-prefix)
  (define-key math-mode-map "h" 'mathm-help)

  (setq mathm-col-map (make-sparse-keymap))
  (fset 'mathm-col-prefix mathm-col-map)
  (define-key mathm-col-map "+" 'mathm-col-add)
  (define-key mathm-col-map "-" 'mathm-col-sub)
  (define-key mathm-col-map "*" 'mathm-col-mul)
  (define-key mathm-col-map "/" 'mathm-col-div)
  (define-key mathm-col-map "." 'mathm-col-sp)
  (define-key mathm-col-map "s" 'mathm-col-sum)
  (define-key mathm-col-map "a" 'mathm-col-avg)
  (define-key mathm-col-map "c" 'mathm-col-copy)
  (define-key mathm-col-map "x" 'mathm-xcol)
  (define-key mathm-col-map "y" 'mathm-ycol)
  (define-key mathm-col-map "h" 'mathm-col-help)

  (setq mathm-kol-map (make-sparse-keymap))
  (fset 'mathm-kol-prefix mathm-kol-map)
  (define-key mathm-kol-map "r" 'mathm-get-k)
  (define-key mathm-kol-map "=" 'mathm-read-k)
  (define-key mathm-kol-map "q" 'mathm-show-k)
  (define-key mathm-kol-map "+" 'mathm-kol-add)
  (define-key mathm-kol-map "-" 'mathm-kol-sub)
  (define-key mathm-kol-map "*" 'mathm-kol-mul)
  (define-key mathm-kol-map "/" 'mathm-kol-div)
  (define-key mathm-kol-map "h" 'mathm-kol-help)
  )

(defun math-mode ()
"Major mode for doing math on numbers in the buffer (msm).
Keys  x and y read number at point into x or y register.
Key   q shows contents of x and y registers.
Key   f shows/sets the output format, eg. 8f or 10e or 7g.
Keys  +,-,*,/ evaluate and insert result z into buffer at point.
Key   c is prefix for binary column operations; c-h for help.
Key   k is prefix for operations with a column and a constant; k-h for help.
TAB   moves point around positions of last x,y,z.
Cursor keys are redefined to pad lines with spaces where needed."
  (interactive)
  (kill-all-local-variables)
  (use-local-map math-mode-map)
  (setq mode-name "Math")
  (setq major-mode 'math-mode)
  (run-hooks 'math-mode-hook)

  (make-local-variable 'xxx)
  (make-local-variable 'yyy)
  (make-local-variable 'last)
  (make-local-variable 'last-set)
  (make-local-variable 'px)
  (make-local-variable 'py)
  (make-local-variable 'pz)
  (make-local-variable 'nx)
  (make-local-variable 'ny)
  (make-local-variable 'k)
  (make-local-variable 'fmt)
  (make-local-variable 'xcol)
  (make-local-variable 'ycol)
  (make-local-variable 'isrow)
  (setq x "0" y "0" z "0" px 0 py 0 pz 0 last "x" last-set "y")
  (setq nx 0 ny 0 k "0")
  (setq fmt "10g" isrow nil)
  (setq float-output-format (concat "%." fmt))
)
                
; ------ defuns ------------
(defun mathm-help () (interactive)
  (message "x,y read; q shows; + - * / ops; c,k col-op prefixes; f format, m marks."))

(defun mathm-get () (interactive)
   (skip-chars-backward "^ \n\t") (setq p1 (point))
   (skip-chars-forward  "^ \n\t") (setq p2 (point))
   (buffer-substring p1 p2) )
     
(defun mathm-get-x () (interactive)
  (save-excursion 
    (point-to-register ?x)
    (setq px (point)) (setq x (mathm-get)) )
  (setq last "x") (message "x   %s" x) )

(defun mathm-get-y () (interactive)
  (save-excursion 
    (point-to-register ?y)
    (setq py (point)) (setq y (mathm-get)) )
  (setq last "y") (setq last-set "y") (message "y   %s" y) )

(defun mathm-query () (interactive)
  (message "x= %s   y= %s" x y) )
                                
(defun mathm-binop (function fsym) (interactive)
  (setq pz (point))       
  (point-to-register ?z)
  (setq float1 (string-to-number x))
  (setq float2 (string-to-number y))
  (setq z (number-to-string (funcall function float1 float2)))
  (put-string z) (goto-char pz) (setq last "z")
  (message "%s %s %s = %s" x fsym y z))

(defun mathm-add () (interactive) (mathm-binop '+ "+"))

(defun mathm-sub () (interactive) (mathm-binop '- "-"))

(defun mathm-mul () (interactive) (mathm-binop '* "*"))

(defun mathm-div () (interactive) (mathm-binop '/ "/"))

(defun mathm-tab () (interactive)
   (if (string= last "z") (progn
      (register-to-point ?x) (message "x") (setq last "x"))
     (if (string= last "x") (progn
        (register-to-point ?y) (message "y") (setq last "y"))
      (if (string= last "y") (progn
         (register-to-point ?z) (message "z") (setq last "z")))))
)

;(defun mathm-tab () (interactive)
;   (if (string= last "z") (progn
;      (goto-char px) (message "x  %s" x) (setq last "x"))
;     (if (string= last "x") (progn
;        (goto-char py) (message "y  %s" y) (setq last "y"))
;      (if (string= last "y") (progn
;         (goto-char pz) (message "z  %s" z) (setq last "z")))))
;)

(defun mathm-fwline () (interactive)
  (setq xxx (current-column))
  (next-line 1)
  (setq zzz (- xxx (current-column)))
  (if (> zzz 0) (progn 
     (insert-char ?\ zzz) 
     (message "padded" zzz)))
)
(defun mathm-bwline () (interactive)
  (setq xxx (current-column))
  (next-line -1)
  (setq zzz (- xxx (current-column)))
  (if (> zzz 0) (progn 
     (insert-char ?\ zzz) 
     (message "padded" zzz)))
)

(defun mathm-fwchar () (interactive)
  (if (or (looking-at "\n") (= (point) (point-max)))
    (progn (message "padded") (insert " "))
    (forward-char 1))
)


(defun mathm-set-format () (interactive)
  (setq xxx (read-from-minibuffer (format "Output format [%s]: " fmt)))
  (if (string-match "[^ ]+" xxx) 
      (progn
        (setq xxx (substring xxx (match-beginning 0) (match-end 0)))
        (if (string-match "[efg]" xxx) (setq fmt xxx)
          (setq fmt (concat xxx "g")))))
  (setq float-output-format (concat "%." fmt))
  (message "Output format: %s" fmt)
  )


; ------ column operations ----------
(defun mathm-col-add () (interactive) 
     (mathm-col-binop "+"))
(defun mathm-col-sub () (interactive) 
     (mathm-col-binop "-"))
(defun mathm-col-mul () (interactive) 
     (mathm-col-binop "*"))
(defun mathm-col-div () (interactive) 
     (mathm-col-binop "/"))
(defun mathm-col-sp () (interactive) 
     (mathm-col-binop "p"))
(defun mathm-col-help () (interactive) 
(message "c- x,y reads col X,Y; + - * / col ops; . sp; s sum; a avg; c copy."))

(defun mathm-kol-add () (interactive) 
     (mathm-col-monop "+"))
(defun mathm-kol-sub () (interactive) 
     (mathm-col-monop "-"))
(defun mathm-kol-mul () (interactive) 
     (mathm-col-monop "*"))
(defun mathm-kol-div () (interactive) 
     (mathm-col-monop "/"))
(defun mathm-col-sum () (interactive) 
     (mathm-col-monop "s"))
(defun mathm-col-avg () (interactive) 
     (mathm-col-monop "a"))
(defun mathm-col-copy () (interactive) 
     (mathm-col-monop "c"))
(defun mathm-kol-help () (interactive) 
 (message "k- r reads k; = sets k; q shows k; + - * / for k*X etc.") )

     
(defun mathm-get-k () (interactive)
  (save-excursion (setq k (mathm-get)) 
  (message "k   %s" k) ))
     
(defun mathm-read-k () (interactive)
  (setq k (read-from-minibuffer "k="))
  (message "k   %s" k) )
     
(defun mathm-show-k () (interactive)
  (message "k   %s" k) )

; ------ read x or y column/row -----

(defun mathm-xcol () (interactive)
  (setq qx (min (point) (mark))) (setq px qx) (setq last "x")
  (save-excursion (goto-char qx) (point-to-register ?x))
  (setq nx (count-lines (point) (mark)))
  (setq nw (words (buffer-substring (point) (mark))))
  (setq xcol nil)
  (setq i 0) (setq isrow nil)
  (if (> nx 1) 
      (progn
        (while (< i nx)
          (goto-char qx) (next-line i) (forward-word 1)
          (setq xcol (cons (mathm-get) xcol))
          (setq i (1+ i)) )
        (message "x column (%d)" nx) )
    (progn
      (goto-char qx) (setq nx (max nw 1)) (setq isrow t)
      (while (< i nx)
        (forward-word 1) 
        (setq xcol (cons (mathm-get) xcol)) 
        (setq i (1+ i)) ) )
    (message "x row (%d)" nx) ) )

(defun mathm-ycol () (interactive)
  (setq qy (min (point) (mark))) (setq py qy) (setq last "y")
  (save-excursion (goto-char qy) (point-to-register ?y))
  (setq ny (count-lines (point) (mark)))
  (setq nw (words (buffer-substring (point) (mark))))
  (setq ycol nil)
  (setq i 0) (setq isrow nil)
  (if (> ny 1) 
      (progn
        (while (< i ny)
          (goto-char qy) (next-line i) (forward-word 1)
          (setq ycol (cons (mathm-get) ycol))
          (setq i (1+ i)) )
        (message "y column (%d)" ny) )
    (progn
      (goto-char qy) (setq ny (max nw 1)) (setq isrow t)
      (while (< i ny)
        (forward-word 1)
        (setq ycol (cons (mathm-get) ycol))
        (setq i (1+ i)) ) )
    (message "y row (%d)" ny) ))

; ------ binary column operations -----
                              
(defun mathm-col-binop (fsym) (interactive)
  (setq qz (point)) (setq pz qz)
  (if (not (= nx ny)) (error "Unequal column heights: %d %d" nx ny))
  (setq i 0) (setq results nil) 
  (setq s (string-to-number "0"))
  (setq z (string-to-number "0"))
  (setq xxx xcol)
  (setq yyy ycol)
  (while xxx
    (setq str1 (car xxx)) (setq float1 (string-to-number str1))
    (setq str2 (car yyy)) (setq float2 (string-to-number str2))
    (if (string= fsym "p") (setq s (+ s (* float1 float2)))
      (if (string= fsym "+") (setq z (+ float1 float2))
        (if (string= fsym "-") (setq z (- float1 float2))
          (if (string= fsym "*") (setq z (* float1 float2))
            (if (string= fsym "/") (setq z (/ float1 float2))
              (error "mathm-col-binop: this cannot happen. fsym=%s" fsym))))))
    (setq results (cons (number-to-string z) results))
    (setq xxx (cdr xxx))
    (setq yyy (cdr yyy)) )
; now put result into file
  (goto-char qz) (point-to-register ?z) (setq last "z")
  (if (string= fsym "p") 
      (progn
        (setq s (number-to-string s))
        (put-string s) 
        (message "x1*y1 + ... + x%d*y%d = %s" nx nx s))
    (mathm-put-col results) 
    (message "X %s Y" fsym) )
  (goto-char qz)
  )

; ------ operations on x column -----
(defun mathm-col-monop (fsym) (interactive)
  (setq qz (point)) (setq pz qz)
  (setq float2 (string-to-number k))
  (setq i 0) (setq results nil) 
  (setq s (string-to-number "0"))
  (setq z (string-to-number "0"))
  (setq xxx xcol)
  (while xxx
    (setq str (car xxx))
    (setq float1 (string-to-number str))
    (if (string= fsym "s") (setq s (+ s float1))
      (if (string= fsym "a") (setq s (+ s float1))
        (if (string= fsym "+") (setq z (+ float1 float2))
          (if (string= fsym "-") (setq z (- float1 float2))
            (if (string= fsym "*") (setq z (* float1 float2))
              (if (string= fsym "/") (setq z (/ float1 float2))
                (if (string= fsym "c") (setq z float1)
                  (error "mathm-col-monop: this cannot happen. fsym=%s" fsym))))))))
    (setq results (cons (number-to-string z) results))
    (setq xxx (cdr xxx)))
; now put result into file
  (goto-char qz) (point-to-register ?z) (setq last "z")
  (if (string= fsym "s") 
      (progn
        (setq s (number-to-string s))
        (put-string s)
        (message "x1 + ... + x%d = %s" nx s))
  (if (string= fsym "a") 
      (progn
        (setq s (number-to-string (/ s nx)))
        (put-string s) 
        (message "avg(x1,...,x%d) = %s" nx s))
    (if (string= fsym "c") 
        (progn (mathm-put-col results) (message "Copied %d" nx))
      (mathm-put-col results) 
      (message "X %s %s  " fsym k) )))
  (goto-char qz)
  )


; ------ write column or row into file ---------
(defun mathm-put-col (res) (interactive)
  (if isrow 
      (progn
        (while res
          (setq z (car res))
          (put-string z) (put-string "  " )
          (setq res (cdr res))  ) )
    (progn
      (while res
        (setq z (car res))
        (save-excursion (put-string z) )
        (mathm-fwline)
        (setq res (cdr res))  ) ) ) )

