(add-to-list 'load-path "~/.emacs.d/el-get/el-get")

;; set to utf-8
(add-hook 'term-exec-hook
          (function
           (lambda ()
             (set-buffer-process-coding-system 'utf-8-unix 'utf-8-unix))))

(unless (require 'el-get nil t)
  (url-retrieve
   "https://github.com/dimitri/el-get/raw/master/el-get-install.el"
   (lambda (s)
     (end-of-buffer)
     (eval-print-last-sexp))))

;; now either el-get is `require'd already, or have been `load'ed by the
;; el-get installer.

;; set local recipes, el-get-sources should only accept PLIST element
(setq
 el-get-sources
 '((:name buffer-move			; have to add your own keys
	  :after (progn
		   (global-set-key (kbd "<C-S-up>")     'buf-move-up)
		   (global-set-key (kbd "<C-S-down>")   'buf-move-down)
		   (global-set-key (kbd "<C-S-left>")   'buf-move-left)
		   (global-set-key (kbd "<C-S-right>")  'buf-move-right)))

   (:name smex				; a better (ido like) M-x
	  :after (progn
		   (setq smex-save-file "~/.emacs.d/.smex-items")
		   (global-set-key (kbd "M-x") 'smex)
		   (global-set-key (kbd "M-X") 'smex-major-mode-commands)))

;;   (:name magit				; git meet emacs, and a binding
;;	  :after (progn
;;		   (global-set-key (kbd "C-x C-z") 'magit-status)))

   (:name goto-last-change		; move pointer back to last change
	  :after (progn
		   ;; when using AZERTY keyboard, consider C-x C-_
		   (global-set-key (kbd "C-x C-/") 'goto-last-change)))))

;; now set our own packages
(setq
 my:el-get-packages
 '(el-get				; el-get is self-hosting
   escreen            			; screen for emacs, C-\ C-h
   php-mode-improved			; if you're into php...
   switch-window			; takes over C-x o
   auto-complete			; complete as you type with overlays
   zencoding-mode			; http://www.emacswiki.org/emacs/ZenCoding
   color-theme		                ; nice looking emacs
   color-theme-tango))	                ; check out color-theme-solarized

;
;; Some recipes require extra tools to be installed
;;
;; Note: el-get-install requires git, so we know we have at least that.
;;
;;(when (el-get-executable-find "cvs")
;;  (add-to-list 'my:el-get-packages 'emacs-goodies-el)) ; the debian addons for emacs

;;(when (el-get-executable-find "svn")
;;  (loop for p in '(psvn    		; M-x svn-status
;;		   yasnippet		; powerful snippet mode
;;		   )
;;	do (add-to-list 'my:el-get-packages p)))

(setq my:el-get-packages
      (append my:el-get-packages
              (mapcar #'el-get-source-name el-get-sources)))

;; install new packages and init already installed packages
(el-get 'sync my:el-get-packages)



;; copied from MELPA
(require 'package) ;; You might already have this line
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))
(when (< emacs-major-version 24)
  ;; For important compatibility libraries like cl-lib
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))
(package-initialize) ;; You might already have this line

;; 2 indents for javascript
(setq js-indent-level 2)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(custom-enabled-themes (quote (tsdh-light)))
 '(package-selected-packages (quote (ctags-update auto-complete-exuberant-ctags))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; set font size to 10pt
(set-face-attribute 'default nil :height 100)

;; include ctags
(setq path-to-ctags "/usr/local/bin/ctags") ;; <- your ctags path here

(defun create-tags (dir-name)
    "Create tags file."
    (interactive "DDirectory: ")
    (shell-command
     (format "%s -f TAGS -e -R %s" path-to-ctags (directory-file-name dir-name)))
    )

