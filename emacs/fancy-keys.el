
; ----- key definitions using fancy functions ------

(global-set-key "æ" 'file-inform)                ; f
(global-set-key "¸" 'goto-position)              ; 8 ("*")
(global-set-key "é" 'inform)                     ; i 
(define-key alt-shift-map "­" 'change-hyphens)   ; -
(global-set-key "µ" 'math-toggle)                ; 5 ("%")
(global-set-key "ã" 'comment-out)                ; c
(define-key alt-shift-map "ã" 'comment-in)       ; c

; for list-select
(global-set-key "ï" 'list-select)                ; o

(define-key occur-mode-map [(meta return)] 'goto-occur-line-keep)   ; \r = RET
(define-key occur-mode-map ""    'goto-occur-line)          ; \r = RET
(define-key occur-mode-map [(meta up)]  'occur-previous-key)    ; -
(define-key occur-mode-map [(meta down)] 'occur-next-key)        ; =

(define-key occur-mode-map (kbd "s-<return>") 'goto-occur-line-keep)   ; \r = RET
(define-key occur-mode-map (kbd "s-<up>")  'occur-previous-key)    ; -
(define-key occur-mode-map (kbd "s-<down>") 'occur-next-key)        ; =

(define-key alt-shift-map "ð" 'pl)                ; p

(define-key text-mode-map "\t"    'text-indent-line)        ; TAB
(define-key text-mode-map "‰" 'indent-to-previous-line)  ; M-TAB

(defun tex-init-msm () (interactive)
  (define-key tex-mode-map "\t" 'text-indent-line) 
  )


; ----- for bookmarks ----

;(global-set-key "ê" 'bookmark-map)   ; j is bookmark prefix

; duplicate existing keydefs so that alt key can be kept down
;(define-key bookmark-map "ä" 'bookmark-delete)      ; d
;(define-key bookmark-map "ê" 'bookmark-jumpc)       ; j
;(define-key bookmark-map "é" 'bookmark-insert)      ; i
;(define-key bookmark-map "æ" 'bookmark-locate)      ; f
;(define-key bookmark-map "ò" 'bookmark-rename)      ; r
;(define-key bookmark-map "í" 'bookmark-set)         ; m
;(define-key bookmark-map "ê" 'bookmark-jump)        ; j

; add some new functions

;(define-key bookmark-map "h"       'bookmark-help)       ; h
;(define-key bookmark-map "è" 'bookmark-help)       ; h

;(define-key bookmark-map "q"       'nop)       ; q
;(define-key bookmark-map "ñ" 'nop)       ; q

; Changes.  s=set, w=write locally, l= load locally
;(define-key bookmark-map "e"       'edit-init-bookmarks)   ; e
;(define-key bookmark-map "å" 'edit-init-bookmarks)   ; e


;(define-key bookmark-map "s"       'bookmark-set)          ; s
;(define-key bookmark-map "ó" 'bookmark-set)          ; s


;(define-key bookmark-map "w"       'bookmark-lsave)        ; w
;(define-key bookmark-map "÷" 'bookmark-lsave)        ; w
                                                        
;(define-key bookmark-map "l"       'bookmark-lload)        ; l
;(define-key bookmark-map "ì" 'bookmark-lload)        ; l


; keys in Bookmark list -- see edit-init-bookmarks in fancy-functions
