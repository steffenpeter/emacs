(defun get-char-type (ch)
  (setq ret (char-syntax ch))
  (if (eq ch ?_) (setq ret ?w))
  ret
  )

(defun stp-del-forward () "  (stp)"
       (interactive)

       (setq c1 (get-char-type (char-after (point))))

       (if (eq mark-active t)
           (progn
             (message "kill region")
             (kill-region (region-beginning) (region-end))
             )
         (progn
;           (if (or (char-equal c1 ?\s) (char-equal c1 ?>))
;               (progn
                 (while (char-equal c1 (get-char-type (char-after (point))))
                   (delete-forward-char 1)
                   )
                 )
;             (progn
;               (save-excursion
;                 (setq p0 (point))
;                 (ignore-errors (subword-right))
;                 (setq p1 (point))
;                 (ignore-errors (subword-left))
;                 (setq p2 (point))
;                 )
;               (if (> p2 p0) (setq p1 p2))
;               (kill-region p0 p1)
;               (message "kill   %d %d" p0 p1)
;               )
;             )
;           )
         )
       )

(defun stp-del-backward () "  (stp)"
       (interactive)

       (setq c1 (get-char-type (char-before (point))))

       (if (eq mark-active t)
           (progn
             (message "kill region")
             (kill-region (region-beginning) (region-end))
             )
         (progn
           (while (char-equal c1 (get-char-type (char-before (point))))
             (delete-backward-char 1)
             )
           )
         )
       )
