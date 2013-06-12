(require 'package)
(add-to-list 'package-archives
             '("marmalade" . "http://marmalade-repo.org/packages/"))

(add-to-list 'package-archives
  '("melpa" . "http://melpa.milkbox.net/packages/") t)

(package-initialize)


(load-theme 'zenburn t)

;;(load-theme 'solarized-light t)

;;(set-default-font "Inconsolata-12")
;;(set-face-attribute 'default nil :font "Inconsolata-12")

(if (fboundp 'menu-bar-mode) (menu-bar-mode -1))
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))


(ido-mode 1)
(show-paren-mode 1)
;;(smart-tab-mode 1)

;;(transient-mark-mode 0)


(fset 'yes-or-no-p 'y-or-n-p)

(electric-indent-mode +1)

;;http://eschulte.me/emacs-starter-kit/starter-kit-bindings.html
(global-set-key (kbd "C-x \\") 'align-regexp)
(global-set-key (kbd "C-s") 'isearch-forward-regexp)
(global-set-key (kbd "\C-r") 'isearch-backward-regexp)
(global-set-key (kbd "C-M-s") 'isearch-forward)
(global-set-key (kbd "C-M-r") 'isearch-backward)

(require 'magit)
(global-set-key (kbd "C-x g") 'magit-status)

(global-set-key (kbd "C-x M-f") 'ffip)


;;http://clojure.roboloco.net/?tag=paredit
;; Create backup files in .emacs-backup instead of everywhere
(defvar user-temporary-file-directory "~/.emacs-backup")
(make-directory user-temporary-file-directory t)
(setq backup-by-copying t)
(setq backup-directory-alist
`(("." . ,user-temporary-file-directory)
(,tramp-file-name-regexp nil)))
(setq auto-save-list-file-prefix
(concat user-temporary-file-directory ".auto-saves-"))
(setq auto-save-file-name-transforms
`((".*" ,user-temporary-file-directory t)))

(autoload 'idomenu "idomenu" nil t)

(require 'paredit)
(require 'rainbow-delimiters)
(require 'nrepl)
(add-hook 'emacs-lisp-mode-hook 'enable-paredit-mode)
(add-hook 'clojure-mode-hook 'paredit-mode)
;;(add-hook 'clojure-mode-hook 'hs-org/minor-mode)

(require 'expectations-mode)

(add-hook 'clojure-mode-hook 'clojure-test-mode)
(add-hook 'clojure-mode-hook 'nrepl-interaction-mode)
(setq nrepl-popup-stacktraces nil)
(add-hook 'nrepl-mode-hook 'paredit-mode)
(add-hook 'nrepl-mode-hook 'rainbow-delimiters-mode)


(add-to-list 'auto-mode-alist '("\\.cljx\\'" . clojure-mode))

;;;;;;;;;;;
(add-hook 'clojure-mode-hook 'rainbow-delimiters-mode)

(add-hook 'org-mode-hook 'visual-line-mode)

;; cycle through buffers
(global-set-key (kbd "<C-tab>") 'bury-buffer)


(add-to-list 'auto-mode-alist '("\\.php\\'" . php-mode))
(add-to-list 'auto-mode-alist '("\\.php\\'" . sgml-mode))

(add-hook 'php-mode-hook 'zencoding-mode)

(require 'php+-mode)
(php+-mode-setup)



;; ;;(add-to-list 'load-path "~/path-to/auto-complete")
;; ; Load the default configuration
;; (require 'auto-complete-config)
;; ; Make sure we can find the dictionaries
;; (add-to-list 'ac-dictionary-directories "~/emacs/auto-complete/dict")
;; ; Use dictionaries by default
;; (setq-default ac-sources (add-to-list 'ac-sources 'ac-source-dictionary))
;; (global-auto-complete-mode t)
;; ; Start auto-completion after 2 characters of a word
;; (setq ac-auto-start 2)
;; ; case sensitivity is important when finding matches
;; (setq ac-ignore-case nil)

;;doesn't work?
(eval-after-load "sgml-mode"
  '(progn
     (require 'tagedit)
     (tagedit-add-paredit-like-keybindings)
     (add-hook 'html-mode-hook (lambda () (tagedit-mode 1)))))


;; use hippie-expand instead of dabbrev
;;(define-key read-expression-map [(tab)] 'hippie-expand)
;; (yas/initialize)
;; (yas/load-directory "~/.emacs.d/elpa/yasnippet-0.6.1/snippets")

;; (add-to-list 'hippie-expand-try-functions-list 'yas/hippie-try-expand)

;; (add-to-list 'hippie-expand-try-functions-list 
;;          'yas/hippie-try-expand) 
;; (global-set-key (kbd "TAB") 'hippie-expand) 



;;http://stackoverflow.com/questions/3124844/what-are-your-favorite-global-key-bindings-in-emacs
(global-set-key (kbd "s-E")                       ;; .emacs
                (lambda()(interactive)(find-file "~/emacs/dot-emacs.el")))

;; macros
(global-set-key [f10]  'start-kbd-macro)
(global-set-key [f11]  'end-kbd-macro)
(global-set-key [f12]  'call-last-kbd-macro)

;; Font size
(define-key global-map (kbd "C-=") 'text-scale-increase)
(define-key global-map (kbd "C--") 'text-scale-decrease)

 (setq ido-enable-flex-matching t)
  (setq ido-everywhere t)
  (ido-mode 1)

;; Jump to a definition in the current file. (This is awesome.)
(global-set-key (kbd "C-x C-i") 'imenu)

;;shell is getting annoying i gotta get better at it outside 
;;of emacs before i have the need for usign emacs shell
;;(shell)

;;http://stackoverflow.com/questions/13002685/kill-previous-nrepl-sessions-when-nrepl-jack-in-called
;; (defun my-nrepl-jack-in ()
;;   (interactive)
;;   (dolist (buffer (buffer-list))
;;     (when (string-prefix-p "*nrepl" (buffer-name buffer))
;;       (kill-buffer buffer)))
;;   (nrepl-jack-in nil))

;; Disable prompt on killing buffer with a process
(setq kill-buffer-query-functions
      (remq 'process-kill-buffer-query-function
            kill-buffer-query-functions))

(defun nrepl-kill ()
  "Kill all nrepl buffers and processes"
  (interactive)
  (when (get-process "nrepl-server")
    (set-process-sentinel (get-process "nrepl-server")
                          (lambda (proc evt) t)))
  (dolist (buffer (buffer-list))
    (when (string-prefix-p "*nrepl" (buffer-name buffer))
      (kill-buffer buffer))))

(defun nrepl-me ()
  (interactive)
  (nrepl-kill)
  (nrepl-jack-in nil))

;;;;;;my stuff;;;;
(global-set-key (kbd "C-c C-j") 'nrepl-me)
(global-set-key (kbd "C-c C-r") 'rename-buffer)


;;http://nex-3.com/posts/45-efficient-window-switching-in-emacs
;; (global-set-key [C-x-left] 'windmove-left)          ; move to left windnow
;; (global-set-key [C-x-right] 'windmove-right)        ; move to right window
;; (global-set-key [M-up] 'windmove-up)              ; move to upper window
;; (global-set-key [M-down] 'windmove-down)          ; move to downer window



;;yasnippet stuff from here: https://gist.github.com/1628240 
;; (add-to-list 'load-path
;; "~/.emacs.d/elpa/yasnippet-0.6.1/snippets")

(setq hippie-expand-try-functions-list
      '(;;yas/hippie-try-expand
        try-complete-file-name-partially
        try-expand-all-abbrevs
        try-expand-dabbrev
        try-expand-dabbrev-all-buffers
        try-expand-dabbrev-from-kill
        try-complete-lisp-symbol-partially
        try-complete-lisp-symbol))

;;(require 'yasnippet)
;;(setq yas/root-directory "~/.emacs.d/elpa/yasnippet-0.6.1/snippets")
;;(yas/load-directory yas/root-directory)

;; Helps when debugging which try-function expanded
(setq hippie-expand-verbose t)
;;(yas/global-mode 1)

(defvar smart-tab-using-hippie-expand t
  "turn this on if you want to use hippie-expand completion.")

(defun smart-tab (prefix)
  "Needs `transient-mark-mode' to be on. This smart tab is
  minibuffer compliant: it acts as usual in the minibuffer.

  In all other buffers: if PREFIX is \\[universal-argument], calls
  `smart-indent'. Else if point is at the end of a symbol,
  expands it. Else calls `smart-indent'."
  (interactive "P")
  (labels ((smart-tab-must-expand (&optional prefix)
                                  (unless (or (consp prefix)
                                              mark-active)
                                    (looking-at "\\_>"))))
    (cond ((minibufferp)
           (minibuffer-complete))
          ((smart-tab-must-expand prefix)
           (if smart-tab-using-hippie-expand
               (hippie-expand prefix)
             (dabbrev-expand prefix)))
          ((smart-indent)))))

(defun smart-indent ()
  "Indents region if mark is active, or current line otherwise."
  (interactive)
  (if mark-active
    (indent-region (region-beginning)
                   (region-end))
    (indent-for-tab-command)))

;; Bind tab everywhere
(global-set-key (kbd "TAB") 'smart-tab)

;; Enables tab completion in the `eval-expression` minibuffer
(define-key read-expression-map [(tab)] 'hippie-expand)
(define-key read-expression-map [(shift tab)] 'unexpand)

;; Replace yasnippets's TAB
;; (add-hook 'yas/minor-mode-hook
;;           (lambda () (define-key yas/minor-mode-map
;;                        (kbd "TAB") 'smart-tab))) ; was yas/expand



 (setq swapping-buffer nil)
 (setq swapping-window nil)
 (defun swap-buffers-in-windows ()
   "Swap buffers between two windows"
   (interactive)
   (if (and swapping-window
            swapping-buffer)
       (let ((this-buffer (current-buffer))
             (this-window (selected-window)))
         (if (and (window-live-p swapping-window)
                  (buffer-live-p swapping-buffer))
             (progn (switch-to-buffer swapping-buffer)
                    (select-window swapping-window)
                    (switch-to-buffer this-buffer)
                    (select-window this-window)
                    (message "Swapped buffers."))
           (message "Old buffer/window killed.  Aborting."))
         (setq swapping-buffer nil)
         (setq swapping-window nil))
     (progn
       (setq swapping-buffer (current-buffer))
       (setq swapping-window (selected-window))
       (message "Buffer and window marked for swapping."))))
 (global-set-key (kbd "C-c p") 'swap-buffers-in-windows)


(setq erc-hide-list '("JOIN" "PART" "QUIT"))

;; (defun terminal-init-screen ()
;;   "Terminal initialization function for GNU screen."
;;   (when (boundp 'input-decode-map)
;;     (define-key input-decode-map "^[[1;5C" [(control right)])
;;     (define-key input-decode-map "^[[1;5D" [(control left)])))

;;stolen from comments here:
;;http://nex-3.com/posts/45-efficient-window-switching-in-emacs#comments

(if (not (display-graphic-p))
    (progn
      (defvar real-keyboard-keys
	'(("M-<up>"        . "\M-[1;3A")
	  ("M-<down>"      . "\M-[1;3B")
	  ("M-<right>"     . "\M-[1;3C")
	  ("M-<left>"      . "\M-[1;3D")
	  ("C-<return>"    . "\C-j")
	  ("C-<delete>"    . "\M-[3;5~")
	  ("C-<up>"        . "\M-[1;5A")
	  ("C-<down>"      . "\M-[1;5B")
	  ("C-<right>"     . "\M-[1;5C")
	  ("C-<left>"      . "\M-[1;5D"))
	"An assoc list of pretty key strings
and their terminal equivalents.")
        (defun key (desc)
    (or (and window-system (read-kbd-macro desc))
	(or (cdr (assoc desc real-keyboard-keys))
	    (read-kbd-macro desc))))
	(global-set-key (key "M-<left>") 'windmove-left)          ; move to left windnow
	(global-set-key (key "M-<right>") 'windmove-right)        ; move to right window
	(global-set-key (key "M-<up>") 'windmove-up)              ; move to upper window
	(global-set-key (key "M-<down>") 'windmove-down))
  
)

  (windmove-default-keybindings)
  (setq windmove-wrap-around t)

 

;; (require 'inline-string-rectangle)
;; (global-set-key (kbd "C-x r t") 'inline-string-rectangle)

;; (require 'mark-more-like-this)
;; (global-set-key (kbd "C-<") 'mark-previous-like-this)
;; (global-set-key (kbd "C->") 'mark-next-like-this)
;; (global-set-key (kbd "C-M-m") 'mark-more-like-this) ; like the other two, but takes an argument (negative is previous)
;; (global-set-key (kbd "C-*") 'mark-all-like-this)

;; (add-hook 'sgml-mode-hook
;; 	            (lambda ()
;; 		                  (require 'rename-sgml-tag)
;; 				              (define-key sgml-mode-map (kbd "C-c C-r") 'rename-sgml-tag)))

(fset 'next-double-newline
   (lambda (&optional arg) "Keyboard macro." (interactive "p") (kmacro-exec-ring-item (quote ("

" 0 "%d")) arg)))

(fset 'previous-double-newline
   (lambda (&optional arg) "Keyboard macro." (interactive "p") (kmacro-exec-ring-item (quote ("

[" 0 "%d")) arg)))


;; (key-chord-define-global "fg" 'forward-char)
;; (key-chord-define-global "fd" 'forward-char)

;; (key-chord-define-global "hm" 'next-double-newline)
;; (key-chord-define-global "hu" 'previous-double-newline)

;; (key-chord-mode)


(fset 'require-user-model
   "(require '[corr.models.user :as user])\C-m")

(smex-initialize)

(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "M-X") 'smex-major-mode-commands)
;; This is your old M-x.
(global-set-key (kbd "C-c C-c M-x") 'execute-extended-command)


;;
;; ace jump mode major function
;; 
(add-to-list 'load-path "/full/path/where/ace-jump-mode.el/in/")
(autoload
  'ace-jump-mode
  "ace-jump-mode"
  "Emacs quick move minor mode"
  t)
;; you can select the key you prefer to
(define-key global-map (kbd "C-c SPC") 'ace-jump-mode)



;; 
;; enable a more powerful jump back function from ace jump mode
;;
(autoload
  'ace-jump-mode-pop-mark
  "ace-jump-mode"
  "Ace jump back:-)"
  t)
(eval-after-load "ace-jump-mode"
  '(ace-jump-mode-enable-mark-sync))
(define-key global-map (kbd "C-x SPC") 'ace-jump-mode-pop-mark)




(defun my-html-mode-hook ()
  (setq tab-width 4)
  (setq indent-tabs-mode t)
  (define-key html-mode-map (kbd "<tab>") 'my-insert-tab)
  (define-key html-mode-map (kbd "C->") 'sgml-close-tag))

(defun my-insert-tab (&optional arg)
  (interactive "P")
  (insert-tab arg))

(add-hook 'html-mode-hook 'my-html-mode-hook)

(add-to-list 'auto-mode-alist '("\\.js$" . javascript-mode))

(setq js-indent-level 2)

;;(add-to-list 'load-path "~/.emacs.d/elpa/hideshow-org")

;;(require 'hideshow-org)


(if window-system
    (progn
      (global-unset-key "\C-x\C-z")
      (global-unset-key "\C-z"))) 

(require 'r-autoyas)
(add-hook 'ess-mode-hook 'r-autoyas-ess-activate)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(show-paren-mode t)
 '(tool-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Inconsolata" :foundry "unknown" :slant normal :weight normal :height 128 :width normal)))))
