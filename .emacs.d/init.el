;; No welcome screen or startup message
(setq inhibit-splash-screen 1)
(setq inhibit-startup-message 1)

;; Add load path
(add-to-list 'load-path "~/.emacs.d/")

;; Resize the minibuffer vertically as necessary
(setq resize-mini-windows 1)

;; Load sr-speedbar
(require 'sr-speedbar)
(setq sr-speedbar-auto-refresh 1)
(setq speedbar-show-unknown-files 1)
(fset 'rh-open-speedbar "\C-[xsr-speedbar-toggle\C-m\C-[xsr-speedbar-select-window\C-m")
(global-set-key (kbd "C-M-s") 'rh-open-speedbar)

;; Load python-mode for scons files
(add-to-list 'auto-mode-alist '("SConscript$" . python-mode))
(add-to-list 'auto-mode-alist '("SConstruct$" . python-mode))

;; 2 spaces instead of tabs
(setq indent-tabs-mode nil)
(setq-default tab-width 2)
(setq-default tab-stop-list 2)

;; Show me colour in my shell, dammit
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)

;; Shell toggle
(load "rah-shell-toggle")

;; Line numbers
(load "rah-linum")

;; My functions
(load "rah-functions")

;; My keyboard bindings
(load "rah-keybindings")

;; Autosave/Backup files
(load "rah-backupfiles")

;; Quit prompt
(load "rah-quitprompt")

; Switch C-x b from the normal switch-to-buffer to iswitchb
; Hide useless buffers..
(require 'iswitchb)
(iswitchb-mode 1)
(add-to-list 'iswitchb-buffer-ignore "^\\*")

;; Turn off menu bar
(menu-bar-mode 0)

;; Turn on parenthesis highlight
(show-paren-mode 1)

;; Show file size
(size-indication-mode)

;; Allow typing y/n instead of yes/no
(fset 'yes-or-no-p 'y-or-n-p)

;; Turn on column number in mode line
(column-number-mode 1)

;; Set wrapping at 80 chars
(set-default 'fill-column 80)