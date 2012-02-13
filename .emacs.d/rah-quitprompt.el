(defun ask-before-closing ()
  "Ask whether or not to close, and then close if y was pressed"
  (interactive)
  (if (y-or-n-p (format "Are you sure you want to exit Emacs? "))
		(if (y-or-n-p (format "Really? Won't somebody think of the buffers? "))	
      (if (< emacs-major-version 22)
          (save-buffers-kill-terminal)
        (save-buffers-kill-emacs))
      (message "Cancelled exit"))
	  (message "Cancalled exit"))
)

(global-set-key (kbd "C-x C-c") 'ask-before-closing)