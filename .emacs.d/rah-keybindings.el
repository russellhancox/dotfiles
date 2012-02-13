; Bind C-x C-m to the same thing as M-x (which is harder to type)
(global-set-key "\C-x\C-m" 'execute-extended-command)

; Bind C-w to kill the last word typed, rebind kill-region to C-x C-k
(global-set-key "\C-w" 'backward-kill-word)
(global-set-key "\C-x\C-k" 'kill-region)

; Bind Alt-r and Alt-s to isearch-backward-regxp and isearch-forward-regexp respectively
(global-set-key "\M-s" 'isearch-forward-regexp)
(global-set-key "\M-r" 'isearch-backward-regexp)

; Bind C-M-z to shell
(global-set-key (kbd "C-M-z") 'shell-toggle)

; Bind C-M-c to compile
(global-set-key (kbd "C-M-c") 'compile)

; Bind the command rr  to replace-regexp, so can type M-x rr
; Bind the command grr to query-replace-regexp, so I can type M-x qrr
(defalias 'rr 'replace-regexp)
(defalias 'qrr 'query-replace-regexp)

; Make M-k kill-ring-save (that is, copy a line rather than kill it)
(global-set-key "\M-k" 'kill-ring-save)
