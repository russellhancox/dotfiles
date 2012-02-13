(require 'linum)

(defvar linum-disabled-modes-list '(speedbar-mode eshell-mode wl-summary-mode compilation-mode org-mode text-mode dired-mode))

(defun linum-on ()
  (unless (or (minibufferp) (member major-mode linum-disabled-modes-list) (string-match "*" (buffer-name)))
    (linum-mode 1)))

(global-linum-mode 1)
(setq linum-format "%4d ")
