
(delete-selection-mode)
;|(load-file "~/emacs/pc-select.el")

(global-set-key [f5] 'compile)
(global-set-key [(control kp-add)] 'set-mark-command)
(global-set-key [(shift down)] 'set-mark-command)
(global-set-key [(shift up)] 'kill-yank-region)
(global-set-key [(control meta c)] 'comment-in)          
(global-set-key [(control meta g)] 'grep)                
(global-set-key [(meta delete)] 'kill-region)   ;cut






(custom-set-variables
 '(delete-key-deletes-forward t)
 '(line-number-mode t))

(custom-set-faces
 '(default ((t (:foreground "gray85" :background "#000060"))) t)
 '(primary-selection ((t (:foreground "white" :background "#008080"))) t)
 '(zmacs-region ((t (:foreground "white" :background "#008080"))) t))

(setq minibuffer-max-depth nil)



;--- apple command key
(global-set-key (kbd "s-x") 'execute-extended-command)        ; x
(global-set-key (kbd "s-<backspace>") 'kill-region)        ; x
(global-set-key (kbd "s-<kp-delete>") 'kill-region)        ; x
(global-set-key (kbd "s-\\") 'yank)        ; x

(global-set-key (kbd "s-<right>") 'move-end-of-line)
(global-set-key (kbd "s-<left>") 'beginning-of-line)
(global-set-key (kbd "<end>") 'move-end-of-line)
(global-set-key (kbd "<home>") 'beginning-of-line)

(setq scroll-error-top-bottom t)
;(global-set-key (kbd "s-<up>") 'scroll-down-command)
;(global-set-key (kbd "s-<down>") 'scroll-up-command)
(global-set-key (kbd "s-<up>") 'backward-paragraph)
(global-set-key (kbd "s-<down>") 'forward-paragraph)


(global-set-key (kbd "s-m") 'set-mark-command)                ; m
(global-set-key (kbd "s-k") 'kill-line)                     ; k

(load-file "emacs/redo.el")
(global-set-key (kbd "s-y") 'redo)                            ; y
(global-set-key (kbd "s-u") 'advertised-undo)                 ; u

(global-set-key (kbd "M-y") 'yank)                            ; y
(global-set-key (kbd "M-c") 'ns-copy-including-secondary)     ; c
(global-set-key (kbd "s-w") 'save-buffer)                     ; w
(global-set-key (kbd "s-W") 'write-file)                     ; W
(global-set-key (kbd "M-W") 'write-file)                     ; W
(global-set-key (kbd "s-b") 'switch-to-buffer)                ; b
(global-set-key (kbd "s-1") 'delete-other-windows)            ; 1

(global-set-key (kbd "s-s") 'replace-string)                  ; s

(global-set-key (kbd "s-2") 'split-window-vertically)         ; 2
(global-set-key (kbd "s-3") 'split-window-right)         ; 3
(global-set-key (kbd "s-g") 'find-file)                       ; g

(global-set-key (kbd "s-q") 'multi-quit)         ; q

(global-set-key (kbd "s-f") 'file-inform)                ; f
(global-set-key (kbd "s-8") 'goto-position)              ; 8 ("*")
(global-set-key (kbd "s-i") 'inform)                     ; i 

(global-set-key (kbd "s-g") 'find-file)                     ; g 
(global-set-key (kbd "s-o") 'list-select)                ; o

(global-set-key (kbd "s-9") 'start-kbd-macro)                ; 9 ("(")
(global-set-key (kbd "s-0") 'end-kbd-macro  )                ; 0 (")")
(global-set-key (kbd "s-7") 'call-last-kbd-macro)            ; 7 ("&")

(global-set-key (kbd "s-,") 'previous-comment-line)                 ; <
(global-set-key (kbd "s-.") 'next-comment-line)                     ; >

(setq ns-function-modifier 'hyper)  ; make Fn key do Hyper
(global-set-key (kbd "H-s") 'isearch-forward)                     ; s





(defun stp-comment () "comment/uncomment  (stp)"
(interactive)
(save-excursion (setq p1 (search-backward "/*" nil 0 nil)))
(save-excursion (setq p1t (search-backward "*/" nil 0 nil)))
(save-excursion (setq p2 (search-forward "*/" nil 0)))

(if (eq p1 nil) (setq p1 0))
(if (eq p2 nil) (setq p2 0))
(if (eq p1t nil) (setq p1t 0))

 (message "XXX   %d %d %d" p1 p1t p2)
(if (and (> p1 p1t) (> p2 p1))
    (progn
    (save-excursion
      (progn
      (search-backward "/*") (delete-char 2)
      (search-forward "*/")  (delete-char -2)
      )
      )
    )
  (
   if (use-region-p)
      (
       progn
        (setq p1 (region-beginning))
        (setq p2 (region-end))
                       
    (message "TT %d %d" (region-beginning) (region-end))
    (goto-char p2) (insert "*/")
    (goto-char p1) (insert "/*")
    )
    (
     progn
      (forward-paragraph)(insert "*/")
      (backward-paragraph)(insert "/*")
     )
    )
  )
)


(global-set-key (kbd "s-;") 'stp-comment)                     ; ;


(defun stp-go-to (char) "comment/uncomment  (stp)"
       (interactive "cjump to register:")
       (if (= char 13)(progn
                        (point-to-register ?~)
                        (jump-to-register ?0)
                        (set-register ?0 (get-register ?~))
                              )
         (
                                                 progn
       (point-to-register ?0)
       (jump-to-register char)
       ))
;       (message ?char)
       )

(defun stp-set-reg (char) "comment/uncomment  (stp)"
       (interactive "cstore to register:")
       (point-to-register char)
       )


(defun stp-go-begin () "go to begin of buffer and store current location in reg 0  (stp)"
  (interactive)
  (point-to-register ?0)
  (beginning-of-buffer)
  )

(defun stp-go-end () "go to end of buffer and store current location in reg 0  (stp)"
  (interactive)
  (point-to-register ?0)
  (end-of-buffer)
  )

(global-set-key (kbd "s-=") 'stp-set-reg)                 ; +
(global-set-key (kbd "s--") 'stp-go-to)                 ; +
(global-set-key (kbd "C-=") 'stp-set-reg)                 ; +
(global-set-key (kbd "C--") 'stp-go-to)                 ; +
(global-set-key (kbd "C-\\") (lambda () (interactive) (stp-set-reg ?0)))                     ; p

(global-set-key (kbd "C-<prior>") 'stp-go-begin)                     ; s
(global-set-key (kbd "C-<next>") 'stp-go-end)                     ; s
(global-set-key (kbd "C-<home>") 'stp-go-begin)                     ; s
(global-set-key (kbd "C-<end>") 'stp-go-end)                     ; s
(global-set-key (kbd "C-<return>") (lambda () (interactive) (stp-go-to 13)))                     ; s


(defun set-exec-path-from-shell-PATH ()
  (let ((path-from-shell 
      (replace-regexp-in-string "[[:space:]\n]*$" "" 
        (shell-command-to-string "$SHELL -l -c 'echo $PATH'"))))
    (setenv "PATH" path-from-shell)
    (setq exec-path (split-string path-from-shell path-separator))))
(when (equal system-type 'darwin) (set-exec-path-from-shell-PATH))
(set-exec-path-from-shell-PATH)

;(load-file "emacs/xcscope.el")


