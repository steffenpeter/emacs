;;; delete-nl-spaces.el --- deleting needless spaces from buffers

;; Copyright (C) 2014 Emanuele Tomasi <targzeta@gmail.com>

;; This program is free software: you can redistribute it and/or
;; modify it under the terms of the GNU General Public License as
;; published by the Free Software Foundation, either version 3 of the
;; License, or (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;; General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program. If not, see <http://www.gnu.org/licenses/>.

;; This file is NOT part of GNU Emacs.

;; Author: Emanuele Tomasi <targzeta@gmail.com>
;; Version: 0.1
;; URL: https://github.com/targzeta/delete-nl-spaces
;; Maintainer: Emanuele Tomasi <targzeta@gmail.com>
;; Keywords: convenience, whitespace


;;; Commentary:
;; This minor mode, enabled by default on every new buffers, deletes
;; unnecessary spaces from a buffer before that it's saved to its file.
;;
;; When you visit a file, if its buffer is cleaned then this minor mode will
;; be enable, otherwise will be disable.
;;
;; You can clean a buffer also calling `delete-nl-spaces' interactive function.
;;
;; To use this program, copy this file in a directory which is in the Emacs
;; `load-path'. Then, execute the following code either directly or in your
;; .emacs file:
;;     ;; Deleting needless spaces before saving buffers.
;;     (require 'delete-nl-spaces)

;;; Code:

(define-minor-mode delete-nl-spaces-mode
  "Toggle deleting needless spaces (Delete Needless Spaces mode).
With a prefix argument ARG, enable Delete Needless Spaces mode if ARG is
positive, and disable it otherwise.  If called from Lisp, enable
the mode if ARG is omitted or nil.

If Delete Needless Spaces mode is enable, before a buffer is saved to its file:
- delete initial blank lines;
- change spaces on tabs or vice versa depending on `indent-tabs-mode';
- delete the trailing whitespaces and empty last lines;
- delete also latest blank line if `require-final-newline' is nil;"
  :init-value t
  :lighter " dns")

(defun delete-nl-spaces ()
  "Execute `delete-nl-spaces-mode'"
  (if delete-nl-spaces-mode
      (save-excursion
        ;; Delete initial blank lines
        (goto-char (point-min))
        (skip-chars-forward " \n\t")
        (skip-chars-backward " \t")
        (if (> (point) 0)
            (delete-char (- (- (point) 1))))

        ;; Change spaces on tabs or tabs on spaces
        (if indent-tabs-mode
            (tabify (point-min) (point-max))
          (untabify (point-min) (point-max)))

        ;; Delete the trailing whitespaces and all blank lines
        (delete-trailing-whitespace)

        ;; Delete the last blank line
        (if (not require-final-newline)
            (goto-char (point-max))
          (let ((trailnewlines (skip-chars-backward "\n\t")))
            (if (< trailnewlines 0)
                (delete-char trailnewlines)))))))

(defun delete-nl-spaces-find-file-hook ()
  "Disable `delete-nl-spaces-mode' if `delete-nl-spaces' has effect on
a buffer."
  (when (and (buffer-file-name) (file-exists-p (buffer-file-name)))
    (let ((buffer (current-buffer)))
      (with-temp-buffer
        (insert-buffer-substring buffer)
        (delete-nl-spaces)
        (when
            (not (= (compare-buffer-substrings buffer nil nil nil nil nil) 0))
          (set-buffer buffer)
          (delete-nl-spaces-mode -1)
          (message "delete-nl-spaces-mode disabed for %s"
                   (buffer-name buffer)))))))

(add-hook 'find-file-hook 'delete-nl-spaces-find-file-hook)
(add-hook 'before-save-hook 'delete-nl-spaces)

(provide 'delete-nl-spaces)

;;; delete-nl-spaces.el ends here


(global-set-key (kbd "<f11>") 'delete-nl-spaces)
