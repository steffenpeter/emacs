;: -*- emacs-lisp -*-
;:* $Id: c-and-java.el.html,v 1.1.1.1 2001/03/11 21:54:42 mwiehl Exp $
(add-hook 'c-mode-common-hook 'my-c-mode-common-hook)
;:*=======================
;:* c-mode customizations
;:  By VJ <vjoseph @ abraxis.com>
(defconst my-c-style
  '((c-tab-always-indent           . t)
    (c-comment-only-line-offset    . 0)
    (c-hanging-braces-alist        . ((substatement-open before after)
                                      (brace-list-open)))
    (c-hanging-colons-alist        . ((member-init-intro before)
                                      (inher-intro)
                                      (case-label after)
                                      (label after)
                                      (access-label after)))
    (c-cleanup-list                . (scope-operator
                                      empty-defun-braces
                                      defun-close-semi))
    (c-offsets-alist               . ((arglist-close       . c-lineup-arglist)
                                      (substatement-open   . 0)
                                      (case-label          . 4)
                                      (block-open          . 0)
                                      (knr-argdecl-intro   . -)))
    (c-echo-syntactic-information-p . t)
    ) 
  "My C Programming Style")
(defun my-c-mode-common-hook ()
  (c-add-style "PERSONAL" my-c-style t)
  (c-set-offset 'member-init-intro '++)
  (setq tab-width 4
        indent-tabs-mode nil)
  (c-toggle-auto-hungry-state 1)
  (c-auto-newline 0))
  ;:(define-key c-mode-map "\C-m" 'newline-and-indent))
(add-hook 'c-mode-common-hook 'my-c-mode-common-hook)
;:*=======================
;:* Overkill cc-mode font-lock-keywords file
;:  Chris Holt <xris @ migraine.stanford.edu>
; Why isn't this hook customizable? No one knows. 
;(add-hook 'font-lock-mode-hook 'turn-on-lazy-shot)
;: Change the modeline from " Font" to "", since it's obvious when it's on
;(defcustom font-lock-mode-string ""
;  "The string that will appear in the modeline when font-lock-mode is on."
;  :type 'string
;  :group 'font-lock)
;: And insert the string in minor-mode-alist
;(setcdr (cdr (cadr (assoc 'font-lock-mode minor-mode-alist))) 
;        'font-lock-mode-string)
;(load-library "keywords")


