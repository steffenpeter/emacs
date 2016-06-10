

(setq default-major-mode 'text-mode)
(setq insert-default-directory nil)
(setq invoke-directory default-directory)  ; save first directory

; SPC functions like RET in minibuf
(define-key minibuffer-local-must-match-map " " 'minibuffer-complete-and-exit)

; ----------- variables to customize behavior ---------

(setq fortran-line-number-indent 2)       ; leave space for c 
(setq fortran-comment-indent-style nil)   ; dont touch comments
(setq fortran-continuation-indent 3)      ; FTN continuations
(setq fortran-do-indent 2)                ; indent of do blocks
(setq fortran-if-indent 2)                ; indent of if blocks
(setq c-argdecl-indent 0)              ; args for c function declaration
(setq sh-indentation 3)                ; tab in shellscript mode

(setq auto-save-interval 0)            ; no autosaving
(setq auto-save-default nil)
(setq make-backup-files nil)           ; make no backups

(setq-default indent-tabs-mode nil)    ; dont use tabs when indenting
(setq require-final-newline t)
(setq default-fill-column 72)
(setq default-case-fold-search 1)
(setq next-screen-context-lines 4)
(setq window-min-height 1)
(setq scroll-step 1)
(setq default-major-mode 'text-mode)
(setq insert-default-directory nil)
(put 'downcase-region 'disabled nil)

; ------ bookmarks -----
; must load bookmark here so my changes are effective
;(load "bookmark")
;(setq bookmark-file ".emacs-bkmrks")
;(setq bookmark-save-flag nil)          ; dont save unless told
;(setq bookmark-init nil)


; ------ hooks ------
;|(setq fortran-mode-hook
;|      '(lambda ()
;|         (load-file "~msm/emacs/fortran.el") ))

(add-hook 'tex-mode-hook 'tex-init-msm)
(add-hook 'c-mode-common-hook 'c-init-msm)
(add-hook 'c-mode-hook 'c-init-msm)
(add-hook 'c++-mode-hook 'c++-init-msm)
(add-hook 'nroff-mode-hook 'text-mode)


(defun c-init-msm ()    ; key defs for c mode hook
  (define-key c-mode-map     "á" 'list-buffers-briefly)     ; a
  (define-key c-mode-map     "ñ" 'multi-quit)               ; q
  (define-key c-mode-map     "ˆ" 'kill-to-start-of-line)    ; BS
  (define-key c-mode-map     "å" 'goto-eob)                 ; e
)

(defun c++-init-msm ()    ; key defs for c++ mode hook
  (define-key c++-mode-map     "á" 'list-buffers-briefly)     ; a
  (define-key c++-mode-map     "ñ" 'multi-quit)               ; q
  (define-key c++-mode-map     "ˆ" 'kill-to-start-of-line)    ; BS
  (define-key c++-mode-map     "å" 'goto-eob)                 ; e
)




; ------ load functions and keydefs ------  

(load-file "~/emacs/minimal-keys.el")


(load-file "~/emacs/simple-functions.el")
(load-file "~/emacs/simple-keys.el")

(load-file "~/emacs/fancy-functions.el")
(load-file "~/emacs/fancy-keys.el")

;;(load-file "~/emacs/def1.el")

(load-file "~/emacs/fortran.el")



(load-file "~/emacs/stp-options.el")




(put 'upcase-region 'disabled nil)


; ---- other stuff ----

(defun hhh () (interactive)
;  (goto-bob) (replace-string "" "\n")
;  (goto-bob) (replace-string "" "\n")
  (goto-bob) (replace-string "\n" "\n")
  )


;; ============================
;; End of Options Menu Settings


(setq load-path (cons (expand-file-name "~/emacs/vhdl") load-path))
;;;
;;; VHDL mode
;;;
(autoload 'vhdl-mode "vhdl-mode" "VHDL Mode" t)
(setq auto-mode-alist (cons '("\\.vhdl?\\'" . vhdl-mode) auto-mode-alist)) 
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(delete-key-deletes-forward t)
 '(show-paren-mode t)
 '(tool-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:foreground "gray85" :background "#000060"))))
 '(primary-selection ((t (:foreground "white" :background "#008080"))) t)
 '(zmacs-region ((t (:foreground "white" :background "#008080"))) t))
