
; ------ make alt-shift map -------

(global-set-key "‡" 'alt-shift-prefix)               ; `
(setq alt-shift-map (make-keymap))
(fset 'alt-shift-prefix alt-shift-map)
(define-key alt-shift-map "‡" 'nop)                  ; `

; ----- key definitions using simple functions ------

(global-set-key "¨" 'goto-bol)                       ; ,  ("<")
(global-set-key "Æ" 'goto-eol)                       ; .  (">")

(define-key alt-shift-map "€" 'goto-bob)             ; [
(define-key alt-shift-map "›" 'goto-eob)             ; ]

; in connection with xterm translations in .Xdefaults
(global-set-key "OX" 'goto-bob)             ; [
(global-set-key "OY" 'goto-eob)             ; [
(global-set-key "OU" 'scroll-down)                     ; [
(global-set-key "OV" 'scroll-up)                       ; ]



(global-set-key "Ë" 'goto-bob)                       ; h
(global-set-key "Â" 'goto-eob)                       ; e

(global-set-key "ˆ" 'locate-key)                     ; v
(define-key alt-shift-map "ˆ"  'locate-bw-key)       ; v

(define-key alt-shift-map "Ô"  'overwrite-mode)      ; o
(define-key alt-shift-map "È"  'insert-file)         ; i 
(global-set-key "∂" 'kill-previous-line)             ; 6 ("^")
(global-set-key "†" 'forward-word)                   ; SPC
(global-set-key "Ó" 'backward-word)                  ; n
(define-key alt-shift-map "˘" 'yank-pop)             ; y

(global-set-key "π" 'start-kbd-macro)                ; 9 ("(")
(global-set-key "∞" 'end-kbd-macro  )                ; 0 (")")
(global-set-key "∑" 'call-last-kbd-macro)            ; 7 ("&")
(global-set-key "≤" 'goto-other-window)              ; 2 

(global-set-key "Ø" 'kill-this-word)                  ; /

(global-set-key            "·" 'list-buffers-briefly)       ; a
;(define-key c-mode-map     "·" 'list-buffers-briefly)       ; a
(define-key alt-shift-map "·" 'list-buffers-briefly-all)    ; a

(global-set-key "≠" 'previous-comment-line)                 ; -
(global-set-key "Ω" 'next-comment-line)                     ; =
(define-key alt-shift-map "Ω" 'last-comment-line)           ; =

(global-set-key "ç" 'point-to-top)                         ; RET
(define-key alt-shift-map "ç" 'point-to-top-save)          ; RET

; replaced by bookmark functions -- see fancy-keys
;|(global-set-key "[093q" 'j-to-register)                        ; j
;|(define-key alt-shift-map "[093q" 'p-to-register)              ; j
  
(define-key alt-shift-map "Ë"  'recover-point)             ; h

(global-set-key "à"  'kill-to-start-of-line)                ; BS


(global-set-key "Ò" 'multi-quit)                            ; q
(define-key emacs-lisp-mode-map "Ò" 'multi-quit)            ; q
;(define-key c-mode-map          "Ò" 'multi-quit)            ; q

(define-key alt-shift-map "Ì" 'kill-yank-region)            ; m
(define-key alt-shift-map "Â" 'load-emacs)                  ; e
(define-key alt-shift-map "€" 'msm-ftn-wcall)               ; (


(defun bind (arg) "bind command to a-t for testing"  
  (interactive "C    bind ")
  (global-set-key "Ù" arg))                              ; t 



; for aix, define Alt-right as right etc.
;(global-set-key "[169q" 'forward-char)
;(global-set-key "[160q" 'backward-char)
;(global-set-key "[166q" 'next-line)
;(global-set-key "[163q" 'previous-line)

; for aix, define Ctl-right as right etc.
;(global-set-key "[168q" 'forward-char)
;(global-set-key "[159q" 'backward-char)
;(global-set-key "[165q" 'next-line)
;(global-set-key "[162q" 'previous-line)

