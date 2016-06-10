
; ----- key definitions using fancy functions ------

(global-set-key "�" 'file-inform)                ; f
(global-set-key "�" 'goto-position)              ; 8 ("*")
(global-set-key "�" 'inform)                     ; i 
(define-key alt-shift-map "�" 'change-hyphens)   ; -
(global-set-key "�" 'math-toggle)                ; 5 ("%")
(global-set-key "�" 'comment-out)                ; c
(define-key alt-shift-map "�" 'comment-in)       ; c

; for list-select
(global-set-key "�" 'list-select)                ; o

(define-key occur-mode-map [(meta return)] 'goto-occur-line-keep)   ; \r = RET
(define-key occur-mode-map ""    'goto-occur-line)          ; \r = RET
(define-key occur-mode-map [(meta up)]  'occur-previous-key)    ; -
(define-key occur-mode-map [(meta down)] 'occur-next-key)        ; =

(define-key occur-mode-map (kbd "s-<return>") 'goto-occur-line-keep)   ; \r = RET
(define-key occur-mode-map (kbd "s-<up>")  'occur-previous-key)    ; -
(define-key occur-mode-map (kbd "s-<down>") 'occur-next-key)        ; =

(define-key alt-shift-map "�" 'pl)                ; p

(define-key text-mode-map "\t"    'text-indent-line)        ; TAB
(define-key text-mode-map "�" 'indent-to-previous-line)  ; M-TAB

(defun tex-init-msm () (interactive)
  (define-key tex-mode-map "\t" 'text-indent-line) 
  )


; ----- for bookmarks ----

;(global-set-key "�" 'bookmark-map)   ; j is bookmark prefix

; duplicate existing keydefs so that alt key can be kept down
;(define-key bookmark-map "�" 'bookmark-delete)      ; d
;(define-key bookmark-map "�" 'bookmark-jumpc)       ; j
;(define-key bookmark-map "�" 'bookmark-insert)      ; i
;(define-key bookmark-map "�" 'bookmark-locate)      ; f
;(define-key bookmark-map "�" 'bookmark-rename)      ; r
;(define-key bookmark-map "�" 'bookmark-set)         ; m
;(define-key bookmark-map "�" 'bookmark-jump)        ; j

; add some new functions

;(define-key bookmark-map "h"       'bookmark-help)       ; h
;(define-key bookmark-map "�" 'bookmark-help)       ; h

;(define-key bookmark-map "q"       'nop)       ; q
;(define-key bookmark-map "�" 'nop)       ; q

; Changes.  s=set, w=write locally, l= load locally
;(define-key bookmark-map "e"       'edit-init-bookmarks)   ; e
;(define-key bookmark-map "�" 'edit-init-bookmarks)   ; e


;(define-key bookmark-map "s"       'bookmark-set)          ; s
;(define-key bookmark-map "�" 'bookmark-set)          ; s


;(define-key bookmark-map "w"       'bookmark-lsave)        ; w
;(define-key bookmark-map "�" 'bookmark-lsave)        ; w
                                                        
;(define-key bookmark-map "l"       'bookmark-lload)        ; l
;(define-key bookmark-map "�" 'bookmark-lload)        ; l


; keys in Bookmark list -- see edit-init-bookmarks in fancy-functions
