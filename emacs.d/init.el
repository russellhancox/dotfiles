;;
;; init.el
;; Russell Hancox
;;
;; My Emacs startup/config file. Sets things just the way I like them..
;;

(message "* --[ Loading Emacs init file ]-- *")

(defvar section-load-libraries t)
(defvar section-basic t)
(defvar section-minibuffer t)
(defvar section-mark t)
(defvar section-killing t)
(defvar section-display t)
(defvar section-files t)
(defvar section-shell t)
(defvar section-other t)

;;----------------------------------------------------------------------------;;
;; 0. Environment (MANDATORY)
;;----------------------------------------------------------------------------;;
(message "0 Environment...")

;; Don't try and tell me about Emacs or show me a tutorial. I'm already using it
(setq inhibit-startup-screen t)
(setq inhibit-startup-message t)
(setq inhibit-startup-echo-area-message "rah")

(defmacro GNUEmacs (&rest body)
  "Check if running under GNUEmacs"
  (list 'if (string-match "GNU Emacs" (version))
        (cons 'progn body)))

(message "0 Environment... DONE")

;;----------------------------------------------------------------------------;;
;; 1. Load Libraries
;;----------------------------------------------------------------------------;;
(when section-load-libraries (message "1 Loading libraries...")

;; Set load-path
(add-to-list 'load-path "~/.emacs.d/")
(add-to-list 'load-path "~/.emacs.d/color-theme/")

;; Try to load modules without errors, saving failed loads to a list
(defvar missing-packages-list nil)
(defun try-require (feature)
  "Attempt to load a library or module. Return true if the library
given as argument is successfully loaded. If not, instead of an error,
just add the package to a list of missing packages."
  (condition-case err
      (progn
        (message "-> Checking for library '%s'..." feature)
        (if (stringp feature)
            (load-library feature)
          (require feature))
        (message "-> Checking for library '%s'... Found" feature))

    (file-error
     (progn
       (message "-> Checking for library '%s'... Missing" feature)
       (add-to-list 'missing-packages-list feature 'append))
     nil)))

(message "1 Loading Libraries... DONE"))

;;----------------------------------------------------------------------------;;
;; 2. Basic editing commands
;;----------------------------------------------------------------------------;;
(when section-basic (message "2 Basic Editing Commands...")

;; Use XEmacs goto-line shortcut
(GNUEmacs
 (global-set-key (kbd "M-g") 'goto-line))

;; Repeat last command to shell
(defun repeat-shell-command ()
  "Repeat most recently executed shell command."
  (interactive)
  (save-buffer)
  (or shell-command-history (error "Nothing to repeat."))
  (shell-command (car shell-command-history)))
(global-set-key (kbd "C-c j") 'repeat-shell-command)

;; Allow typing y/n instead of yes/no
(fset 'yes-or-no-p 'y-or-n-p)

;; Bind M-r and M-s to isearch-backward-regexp and isearch-forward-regexp
(global-set-key (kbd "M-s") 'isearch-foward-regexp)
(global-set-key (kbd "M-r") 'isearch-backward-regexp)

;; Alias rr to replace-regexp
(defalias 'rr 'replace-regexp)

;; Alias qrr to query-replace-regexp)
(defalias 'qrr 'query-replace-regexp)

;; 2 spaces instead of tabs
(setq-default indent-tabs-mode nil)
(setq indent-tabs-mode nil)
(setq-default tab-width 2)

(setq-default tab-stop-list 2)

(message "2 Basic Editing Commands... DONE"))

;;----------------------------------------------------------------------------;;
;; 3. Minibuffer
;;----------------------------------------------------------------------------;;
(when section-minibuffer (message "3 Minibuffer...")

;; Ignore case during file-name completion
(setq read-file-name-completion-ignore-case t)

;; Dim the ignored part of the filanem
(GNUEmacs
 (file-name-shadow-mode 1))

;; Resize the minibuffer vertically as necessary
(setq resize-mini-windows t)

;; Minibuffer completion incremental feedback
(GNUEmacs
 (icomplete-mode))

;; Ignore case when reading a buffer name
(setq read-buffer-completion-ignore-case t)

;; Do not consider case significant in completion
(setq completion-ignore-case t)

;; Switch C-x b from normal switch-to-buffer to iswitchb
(when (try-require 'iswitchb)
  (iswitchb-mode 1)
  (add-to-list 'iswitchb-buffer-ignore "^\\*"))

(message "3 Minibuffer... DONE"))

;;----------------------------------------------------------------------------;;
;; 4. The Mark and the Region...
;;----------------------------------------------------------------------------;;
(when section-mark (message "4 The Mark and the Region...")

(GNUEmacs
 (when window-system
   (transient-mark-mode 1)))

(message "4 The Mark and the Region... DONE"))

;;----------------------------------------------------------------------------;;
;; 5. Killing and Moving Text
;;----------------------------------------------------------------------------;;
(when section-killing (message "5 Killing and Moving Text...")

(defadvice kill-ring-save (before slickcopy activate compile)
  "When called interactively with no active region,
  copy the current line instead."
  (interactive
   (if mark-active (list (region-beginning) (regin-end))
     (list (line-beginning-position)
           (ling-beginning-position 2)))))

(defadvice kill-region (before slickcut activate compile)
  "When called interactively with no active region,
   kill the current line instead."
  (interactive
   (if mark-active (list (region-beginning) (region-end))
     (list (line-beginning-position)
           (ling-beginning-position 2)))))

(defadvice yank (after indent-region activate)
  "Auto-indent pasted code"
  (if (member major-mode
              '(emacs-lisp-mode scheme-mode lisp-mode c-mode c++-mode
                objc-mode latex-mode plain-tex-mode python-mode))
      (indent-region (region-beginning) (region-end) nil)))

(defadvice yank-pop (after indent-region activate)
  "Auto-indent pasted code"
  (if (member major-mode
              '(emacs-lisp-mode scheme-mode lisp-mode c-mode c++-mode
                objc-mode latex-mode plain-tex-mode python-mode))
      (indent-region (region-beginning) (region-end) nil)))

;; Bind C-w to kill previous word, rebind kill-region to C-x C-k
(global-set-key (kbd "C-w") 'backward-kill-word)
(global-set-key (kbd "C-x C-k") 'kill-region)

;; Bind M-k to kill-ring-save
(global-set-key (kbd "M-k") 'kill-ring-save)

(message "5 Killing and Moving Text... DONE"))

;;----------------------------------------------------------------------------;;
;; 6. The Display
;;----------------------------------------------------------------------------;;
(when section-display (message "6 The Display...")

;; Scroll line by line
(setq scroll-step 1)

;; Make a PgUp followed by PgDn return to the same point
(when (try-require 'pager)
  (global-set-key (kbd "<prior>") 'pager-page-up)
  (global-set-key (kbd "<next>") 'pager-page-down)
  (global-set-key (kbd "<M-up>") 'pager-row-up)
  (global-set-key (kbd "<M-down>") 'pager-row-down))

;; Highlight TODO/FIXME/BUG
(defun fontify-keywords ()
  (interactive)
  (font-lock-add-keywords nil
                          '(("\\<\\(FIXME\\|TODO\\|BUG\\):"
                             1 font-lock-warning-face prepend))))
(dolist (hook '(c-mode-common-hook
               cperl-mode-hook
               css-mode-hook
               emacs-lisp-mode-hook
               html-mode-hook
               makefile-mode-hook
               python-mode-hook
               sh-mode-hook
               shell-mode-hook))
  (add-hook hook 'fontify-keywords))

;; Highlight trailing whitespace in all modes
(setq-default show-trailing-whitespace t)

(defun my-delete-trailing-whitespace-and-untabify ()
  "Delete all the trailing white space and convert all
   tabs to multiple spaces across the current buffer"
  (interactive "*")
  (delete-trailing-whitespace)
  (untabify (point-min) (point-max)))

;; Visually indicate empty lines after the end of the buffer
(setq-default indicate-empty-lines t)

;; Show the line number in each mode line
(line-number-mode 1)

;; Show the column number in each mode line
(column-number-mode 1)

;; Use inactive face for mode-line in non-selected windows
(setq mode-line-in-non-selected-windows t)

;; Indicate file size
(size-indication-mode)

;; Include abbreviated file paths in mode line
(GNUEmacs
 (when (try-require 'mode-line)
   (mode-line-goggle-display nil)))

;; Convert DOS-to-UNIX line endings
(defun dos-to-unix ()
  "Convert to UNIX line endings"
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (while (search-forward "\r" nil t)
      (replace-match ""))))

; Convert UNIX-to-DOS line endings
(defun unix-to-dos ()
  "Convert to DOS line endings"
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (while (search-forward "\n" nil t)
      (replace-match "\r\n"))))

;; Highlight long lines
(custom-set-faces
 '(my-tab-face            ((((class color)) (:background "red"))) t)
 '(my-trailing-space-face ((((class color)) (:background "red"))) t)
 '(my-long-line-face      ((((class color)) (:background "blue"))) t))

(add-hook 'font-lock-mode-hook
          (function
           (lambda ()
             (setq font-lock-keywords
                   (append font-lock-keywords
                           '(("\t+" (0 'my-tab-face t))
                             ("^.\\{81,\\}$" (0 'my-long-line-face t))
                             ("[ \t]+$" (0 my-trailing-space-face t))))))))

;; See what I'm typing *immediately*
(setq echo-keystrokes 0.01)

;; Don't show me the menu-bar
(menu-bar-mode 0)

;; Highlight parenthesis
(show-paren-mode 1)

;; Line numbers
(when (try-require 'linum)
  (defvar linum-disabled-modes-list '(speedbar-mode
                                      eshell-mode
                                      wl-summary-mode
                                      compilation-mode
                                      org-mode
                                      text-mode
                                      dired-mode))
  (defun linum-on ()
    (unless (or (minibufferp) (member major-mode linum-disabled-modes-list)
                (string-match "*" (buffer-name)))
      (linum-mode t)))

  (global-linum-mode t)
  (setq linum-format "%4d "))

(message "6 The Display... DONE"))

;;----------------------------------------------------------------------------;;
;; 7. Files
;;----------------------------------------------------------------------------;;
(when section-files (message "7 Files...")

;; Make sure files always end with a final newline
(setq require-final-newline t)

;; If file has 'Time-Stamp: <>' occuring in first 8 lines, update it
(when (try-require 'time-stamp)

  ;; Format of the timestamp (YYYY-MM-DD HH:MM user@host)
  (setq time-stamp-format "%Y-%02m-%02d %02H:%02M %u@%s")

  ;; Update time stamps every time you save
  (add-hook 'write-file-hooks 'time-stamp))

;; Revert buffer
(defun my-revert-buffer ()
  "Unconditionally revert current buffer"
  (interactive)
  (flet ((yes-or-no-p (msg) t))
    (revert-buffer)))
(global-set-key (kbd "<C-f12>") 'my-revert-buffer)

; Put autosave files (ie #foo#) in one place, not scattered all over the place
(defvar autosave-dir "~/.emacs.d/autosaves/")
(make-directory autosave-dir t)

(defun auto-save-file-name-p (filename)
  (string-match "^#.*#$" (file-name-nondirectory filename)))

(defun make-auto-save-file-name ()
  (concat autosave-dir
          (if buffer-file-name
              (concat "#" (file-name-nondirectory buffer-file-name) "#")
            (expand-file-name
             (concat "#%" (buffer-name) "#")))))

;; Put backup files (ie foo~) in one place too
(defvar backup-dir "~/.emacs.d/backups/")
(setq backup-directory-alist (list (cons "." backup-dir)))

;; Always copy to create backup files (don't clobber symlinks)
(setq backup-by-copying t)

;; Make numeric backup versions
(setq version-control t)

;; Delete excess backup versions silently
(setq delete-old-versions t)

;; Default to unified diffs
(setq diff-switches "-u")

;; Setup a menu of recently opened files
(try-require 'recentf)
(eval-after-load "recentf"
  '(progn
     ;; File to save recent list info
     (setq recentf-save-file "~/.emacs.d/.recentf")

     ;; Maximum number of lines in the recentf menu
     (setq recentf-max-menu-items 30)

     ;; Toggle
     (recentf-mode 1)

     ;; Add key binding
     (global-set-key (kbd "C-x C-r") 'recentf-open-files)))

;; Show image files as images (not as semi-random bits)
(GNUEmacs (auto-image-file-mode 1))

;; Load python-mode for scons files
(add-to-list 'auto-mode-alist '("SConscript$" . python-mode))
(add-to-list 'auto-mode-alist '("SConstruct$" . python-mode))

(message "7 Files... DONE"))

;;----------------------------------------------------------------------------;;
;; 8. Shell
;;----------------------------------------------------------------------------;;
(when section-shell (message "8 Shell...")

(try-require 'shell)

;; Show me colour in my shell, dammit
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)

;; Load shell-toggle
(when (try-require 'rah-shell-toggle)
  (global-set-key (kbd "C-M-z") 'shell-toggle))

(message "8 Shell... DONE"))

;;----------------------------------------------------------------------------;;
;; 9. Other
;;----------------------------------------------------------------------------;;
(when section-other (message "9 Other...")

;; Load SPEEDBAR
(when (try-require 'speedbar)
  (speedbar 1)
  (global-set-key (kbd "C-M-s") 'speedbar))

;; Load windmove shortcuts
(windmove-default-keybindings)

;; Pierson color theme
(require 'color-theme)
(color-theme-initialize)
(color-theme-pierson)

(message "9 Other... DONE"))

(message "* --[ Loaded Emacs init file ]-- *")
