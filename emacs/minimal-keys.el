
; ----- minimal key definitions ------

(global-set-key (kbd "M-m") 'set-mark-command)                ; m
(global-set-key (kbd "M-k") 'kill-line)                     ; k
(global-set-key "ù" 'yank)                            ; y
(global-set-key (kbd "M-w") 'save-buffer)                     ; w
(global-set-key (kbd "M-b") 'switch-to-buffer)                ; b
(global-set-key (kbd "M-1") 'delete-other-windows)            ; 1
(global-set-key (kbd "M-u") 'advertised-undo)                 ; u
;(global-set-key "¬" 'beginning-of-line)               ; ,  ("<")
;(global-set-key "®" 'end-of-line)                     ; .  (">")
(global-set-key (kbd "M-x") 'execute-extended-command)        ; x

(global-set-key (kbd "M-s") 'replace-string)                  ; s
(define-key text-mode-map "ó" 'replace-string)        ; s

(global-set-key "Û" 'scroll-down)                     ; [
(global-set-key "Ý" 'scroll-up)                       ; ]
(global-set-key "ú" 'suspend-emacs)                   ; z 

(global-set-key (kbd "M-2") 'split-window-vertically)         ; 2
(global-set-key (kbd "M-g") 'find-file)                       ; g

(global-set-key (kbd "M-q") 'save-buffers-kill-emacs)         ; q
(define-key emacs-lisp-mode-map "ñ" 'save-buffers-kill-emacs)    ; q


; control codes for "cursor keys" on keyboard
(global-set-key "ì" 'backward-char)             ; l
(global-set-key "§" 'forward-char)              ; '
(global-set-key "ð" 'previous-line)             ; p
(global-set-key "»" 'next-line)                 ; ;






(global-set-key [27 down] (quote set-mark-command))
(global-set-key [27 up] (quote kill-yank-region))
(global-set-key [27 deletechar] (quote kill-region))
(global-set-key [27 insertchar] (quote yank))