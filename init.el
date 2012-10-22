(require 'package)
(add-to-list 'package-archives
             '("marmalade" . "http://marmalade-repo.org/packages/"))
(package-initialize)


(load-theme 'zenburn t)

(ido-mode 1)
(show-paren-mode 1)
;;(smart-tab-mode 1)

(tool-bar-mode -1) 
(menu-bar-mode -1)

;;(transient-mark-mode 0)


(fset 'yes-or-no-p 'y-or-n-p)


;;http://eschulte.me/emacs-starter-kit/starter-kit-bindings.html
(global-set-key (kbd "C-x \\") 'align-regexp)
(global-set-key (kbd "C-s") 'isearch-forward-regexp)
(global-set-key (kbd "\C-r") 'isearch-backward-regexp)
(global-set-key (kbd "C-M-s") 'isearch-forward)
(global-set-key (kbd "C-M-r") 'isearch-backward)

(require 'magit)
(global-set-key (kbd "C-x g") 'magit-status)

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
(add-hook 'emacs-lisp-mode-hook 'enable-paredit-mode)
(add-hook 'clojure-mode-hook 'paredit-mode)

(add-to-list 'auto-mode-alist '("\\.cljx\\'" . clojure-mode))

;;;;;;;;;;;
(add-hook 'clojure-mode-hook 'rainbow-delimiters-mode)

(add-hook 'org-mode-hook 'visual-line-mode)

;; cycle through buffers
(global-set-key (kbd "<C-tab>") 'bury-buffer)

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



;;;;;;my stuff;;;;
(global-set-key (kbd "C-c C-j") 'clojure-jack-in)
(global-set-key (kbd "C-c C-r") 'rename-buffer)


;;http://nex-3.com/posts/45-efficient-window-switching-in-emacs
;; (global-set-key [C-x-left] 'windmove-left)          ; move to left windnow
;; (global-set-key [C-x-right] 'windmove-right)        ; move to right window
;; (global-set-key [M-up] 'windmove-up)              ; move to upper window
;; (global-set-key [M-down] 'windmove-down)          ; move to downer window



;;yasnippet stuff from here: https://gist.github.com/1628240 
(add-to-list 'load-path
"~/.emacs.d/elpa/yasnippet-0.6.1/snippets")

(setq hippie-expand-try-functions-list
      '(yas/hippie-try-expand
        try-complete-file-name-partially
        try-expand-all-abbrevs
        try-expand-dabbrev
        try-expand-dabbrev-all-buffers
        try-expand-dabbrev-from-kill
        try-complete-lisp-symbol-partially
        try-complete-lisp-symbol))

(require 'yasnippet)
(setq yas/root-directory "~/.emacs.d/elpa/yasnippet-0.6.1/snippets")
(yas/load-directory yas/root-directory)

;; Helps when debugging which try-function expanded
(setq hippie-expand-verbose t)
(yas/global-mode 1)

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
(add-hook 'yas/minor-mode-hook
          (lambda () (define-key yas/minor-mode-map
                       (kbd "TAB") 'smart-tab))) ; was yas/expand



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
