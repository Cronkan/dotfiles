;;;;      ;;;;;
;;  ;;   ::    ; 
;;  ;;   ;;
;;;:  EMA::S   : 
;; ;;     ::::: O N F I G

;;ADDS
;;(add-to-list 'load-path "~/.emacs.d") 
;;(load "package")

;;(add-to-list 'package-archives
;;             '("melpa" . "http://melpa.milkbox.net/packages/") t)
(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
			 ("marmalade" . "http://marmalade-repo.org/packages/")
			 ("melpa" . "http://melpa.milkbox.net/packages/")))
;;Remove startup message and scratch
(setq inhibit-startup-message t) 
(setq initial-scratch-message "")
;;No new lines in buffer if its empty-
(setq next-line-add-newlines nil)

;;Highlights paranthesis near cursor
(require 'paren) (show-paren-mode t)
(set-face-background 'show-paren-match-face "#1f1f1f")
(set-face-foreground 'show-paren-match-face "#ff00ff")

;;tramp sudo
(set-default 'tramp-default-proxies-alist (quote ((".*" "\\`root\\'" "/ssh:%h:"))))

;;Set backup-folder
(setq backup-directory-alist
 '(("." . "~/.emacs.backups")))

;;TRAMP
(require 'tramp)
(setq tramp-default-method "scp")

(setq recentf-auto-cleanup 'never) 

;;COMPANY MODE
(add-hook 'after-init-hook 'global-company-mode)

;;COFFEESCRIPT
(set 'coffee-tab-width 4)


;;BREAK MODE
(setq type-break-mode t)

;;Set enable clipboard for global copy paste
(setq x-select-enable-clipboard t)
(setq interprogram-paste-function 'x-cut-buffer-or-selection-value)

;;Line number mode
(global-linum-mode t)

;;Auto-Update Buffers if changed
(global-auto-revert-mode t)
;;ORG-mode
(require 'org-install)

;;Set header to C++
(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))

;;Color theme	
	(require 'color-theme)
(color-theme-initialize)
(color-theme-calm-forest)
(add-to-list 'load-path "~/.emacs.d/themes")
;(require 'color-theme-dotshare)
;(color-theme-dotshare)
;;Auto complete - needs auto-complete-el (package-install with MELPA)
;;(require 'auto-complete-config)
;;(ac-config-default)

;;YAS - SNIPPET
(defun yas-mode-html ()
  (interactive)
  (yas-minor-mode)
  (yas-reload-all))
(add-hook 'html-mode-hook 'yas-mode-html)
(add-hook 'css-mode-hook 'yas-mode-html)

;;(add-to-list 'auto-mode-alist '("\\.css\\'" . yas-global-mode))
;;JS2-MODE - JAVASCRIPT
(defun yas-mode-js2 ()
  (interactive)
  (yas-minor-mode)
  (yas-reload-all))
(add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))
(add-to-list 'interpreter-mode-alist '("node" . js2-mode))
(add-hook 'js2-mode-hook 'yas-mode-js2)


;;IDO Mode
(setq ido-enable-flex-matching t)
(setq ido-everywhere t)
(ido-mode 1)

;; This is a way to hook tempo into cc-mode
(defvar c-tempo-tags nil
  "Tempo tags for C mode")
(defvar c++-tempo-tags nil
  "Tempo tags for C++ mode")
;;SHELL - Nopassword
(add-hook 'comint-output-filter-functions 'comint-watch-for-password-prompt)

;;SHELL - Buffer
(setq comint-buffer-maximum-size 10240)

;;SHELL - Behave like terminal!
(add-hook 'shell-mode-hook
	  '(lambda ()
             (local-set-key [home]        ; move to beginning of line, after prompt  
                            'comint-bol)
	     (local-set-key [up]          ; cycle backward through command history
                            '(lambda () (interactive)
                               (if (comint-after-pmark-p)
                                   (comint-previous-input 1)
                                 (previous-line 1))))
	     (local-set-key [down]        ; cycle forward through command history
                            '(lambda () (interactive)
                               (if (comint-after-pmark-p)
                                   (comint-next-input 1)
                                 (forward-line 1))))
             ))
;;FOKUSERA MINIBUFFER
(defun switch-to-minibuffer ()
  "Switch to minibuffer window."
  (interactive)
  (if (active-minibuffer-window)
      (select-window (active-minibuffer-window))
    (error "Minibuffer is not active")))



;; SÅ MAN SLIPPER ANVÄNDA SHIFT PÅ SIFFROR

(setq my-key-pairs
      '((?! ?1) (?@ ?2) (?# ?3) (?$ ?4) (?% ?5)
        (?& ?6) (?{ ?7) (?( ?8) (?) ?9) (?} ?0)
        (?- ?_) (?\" ?') (?{ ?[) (?} ?])         ; (?| ?\\)
        ))
        
(defun my-key-swap (key-pairs)
  (if (eq key-pairs nil)
      (message "Keyboard zapped!! Shift-F10 to restore!")
      (progn
        (keyboard-translate (caar key-pairs)  (cadar key-pairs)) 
        (keyboard-translate (cadar key-pairs) (caar key-pairs))
        (my-key-swap (cdr key-pairs))
        )
    ))

(defun my-key-restore (key-pairs)
  (if (eq key-pairs nil)
      (message "Keyboard restored!! F10 to Zap!")
      (progn
        (keyboard-translate (caar key-pairs)  (caar key-pairs))
        (keyboard-translate (cadar key-pairs) (cadar key-pairs))
        (my-key-restore (cdr key-pairs))
        )
    ))


;;; C-Mode Templates and C++-Mode Templates (uses C-Mode Templates also)
(require 'tempo)
(setq tempo-interactive t)

(add-hook 'c-mode-hook
          '(lambda ()
             (local-set-key [f11] 'tempo-complete-tag)
             (tempo-use-tag-list 'c-tempo-tags)
             ))
(add-hook 'c++-mode-hook
          '(lambda ()
             (local-set-key [f11] 'tempo-complete-tag)
             (tempo-use-tag-list 'c-tempo-tags)
             (tempo-use-tag-list 'c++-tempo-tags)
             ))

;;; Preprocessor Templates (appended to c-tempo-tags)

(tempo-define-template "c-include"
		       '("include <" r ".h>" > n
			 )
		       "include"
		       "Insert a #include <> statement"
		       'c-tempo-tags)

(tempo-define-template "c-ifdef"
		       '("ifdef " (p "ifdef-clause: " clause) > n> p n
			 "#else /* !(" (s clause) ") */" n> p n
			 "#endif /* " (s clause)" */" n>
			 )
		       "ifdef"
		       "Insert a #ifdef #else #endif statement"
		       'c-tempo-tags)

(tempo-define-template "c-ifndef"
		       '("ifndef " (p "ifndef-clause: " clause) > n
			 "#define " (s clause) n> p n
			 "#endif /* " (s clause)" */" n>
			 )
		       "ifndef"
		       "Insert a #ifndef #define #endif statement"
		       'c-tempo-tags)
;;; C-Mode Templates

(tempo-define-template "c-if"
		       '(> "if (" (p "if-clause: " clause) ")" n>
                           "{" > n>
                           > r n
                           "}" > n>
                           )
		       "if"
		       "Insert a C if statement"
		       'c-tempo-tags)

(tempo-define-template "c-else"
		       '(> "else" n>
                           "{" > n>
                           > r n
                           "}" > n>
                           )
		       "else"
		       "Insert a C else statement"
		       'c-tempo-tags)

(tempo-define-template "c-if-else"
		       '(> "if (" (p "if-clause: " clause) ")"  n>
                           "{" > n
                           > r n
                           "}" > n
                           "else" > n
                           "{" > n>
                           > r n
                           "}" > n>
                           )
		       "ifelse"
		       "Insert a C if else statement"
		       'c-tempo-tags)

(tempo-define-template "c-while"
		       '(> "while (" (p "while-clause: " clause) ")" >  n>
                           "{" > n
                           > r n
                           "}" > n>
                           )
		       "while"
		       "Insert a C while statement"
		       'c-tempo-tags)

(tempo-define-template "c-for"
		       '(> "for (" (p "for-clause: " clause) ")" >  n>
                           "{" > n
                           > r n
                           "}" > n>
                           )
		       "for"
		       "Insert a C for statement"
		       'c-tempo-tags)

(tempo-define-template "c-for-i"
		       '(> "for (" (p "variable: " var) " = 0; " (s var)
                           " < "(p "upper bound: " ub)"; " (s var) "++)" >  n>
                           "{" > n
                           > r n
                           "}" > n>
                           )
		       "fori"
		       "Insert a C for loop: for(x = 0; x < ..; x++)"
		       'c-tempo-tags)

(tempo-define-template "c-main"
		       '(> "int main(int argc, char *argv[])" >  n>
                           "{" > n>
                           > r n
                           > "return 0 ;" n>
                           > "}" > n>
                           )
		       "main"
		       "Insert a C main statement"
		       'c-tempo-tags)

(tempo-define-template "c-if-malloc"
		       '(> (p "variable: " var) " = ("
                           (p "type: " type) " *) malloc (sizeof(" (s type)
                           ") * " (p "nitems: " nitems) ") ;" n>
                           > "if (" (s var) " == NULL)" n>
                           > "error_exit (\"" (buffer-name) ": " r ": Failed to malloc() " (s var) " \") ;" n>
                           )
		       "ifmalloc"
		       "Insert a C if (malloc...) statement"
		       'c-tempo-tags)

(tempo-define-template "c-if-calloc"
		       '(> (p "variable: " var) " = ("
                           (p "type: " type) " *) calloc (sizeof(" (s type)
                           "), " (p "nitems: " nitems) ") ;" n>
                           > "if (" (s var) " == NULL)" n>
                           > "error_exit (\"" (buffer-name) ": " r ": Failed to calloc() " (s var) " \") ;" n>
                           )
		       "ifcalloc"
		       "Insert a C if (calloc...) statement"
		       'c-tempo-tags)

(tempo-define-template "c-switch"
		       '(> "switch (" (p "switch-condition: " clause) ")" n>
                           "{" >  n>
                           "case " (p "first value: ") ":" > n> p n
                           "break;" > n> p n
                           "default:" > n> p n
                           "break;" > n
                           "}" > n>
                           )
		       "switch"
		       "Insert a C switch statement"
		       'c-tempo-tags)

(tempo-define-template "c-case"
		       '(n "case " (p "value: ") ":" > n> p n
			   "break;" > n> p
			   )
		       "case"
		       "Insert a C case statement"
		       'c-tempo-tags)

(tempo-define-template "c++-class"
		       '("class " (p "classname: " class) p > n>
                         " {" > n
                         "public:" > n
                         "" > n
			 "protected:" > n
                         "" > n
			 "private:" > n
                         "" > n
			 "};" > n
			 )
		       "class"
		       "Insert a class skeleton"
		       'c++-tempo-tags)

;;HOTKEYS 

(global-set-key "\C-m"        'newline-and-indent)
(global-set-key [C-delete]    'kill-word)
(global-set-key [C-backspace] 'backward-kill-word)
(global-set-key [f1]          'find-file)
(global-set-key [f2]          'switch-to-buffer-other-window)
(global-set-key [S-f2]        'switch-to-buffer)
(global-set-key [f3]          'manual-entry)
(global-set-key [f4]          'shell)
(global-set-key [f5]          '(lambda () (interactive) (kill-buffer (current-buffer))))
(global-set-key [S-f7]        'compile)
(global-set-key [f7]          'next-error)
(global-set-key [C-f7]        'kill-compilation)
(global-set-key [f8]          'other-window)
(global-set-key [f9]          'save-buffer)
(global-set-key [f10]         '(lambda () (interactive) (my-key-swap    my-key-pairs)))
(global-set-key [S-f10]       '(lambda () (interactive) (my-key-restore my-key-pairs)))
(global-set-key [next]       'next-buffer)
(global-set-key [dead-acute]       'next-buffer)
(global-set-key [dead-diaeresis]          'other-window)
(global-set-key [home] 'switch-to-minibuffer)
(global-set-key (kbd "C-x C-a") (kbd "M-! terminator & RET"))
;;Allcaps
(global-set-key "\M-u"        '(lambda () (interactive) (backward-word 1) (upcase-word 1))) 


;;STARTUP

;;Split
;(split-window-horizontally) 

;;Fullscreen
(defun toggle-fullscreen ()
  (interactive)
  (x-send-client-message nil 0 nil "_NET_WM_STATE" 32
	    		 '(2 "_NET_WM_STATE_MAXIMIZED_VERT" 0))
  (x-send-client-message nil 0 nil "_NET_WM_STATE" 32
	    		 '(2 "_NET_WM_STATE_MAXIMIZED_HORZ" 0))
)
(toggle-fullscreen)
;;MISC
;(other-window 1)              ;; move to other window
;(shell)                       ;; start a shell
;(rename-buffer "shell-first") ;; rename it
;(other-window 1)

;;Font
(set-face-attribute 'default nil :height 90)

;;Remove toolbar and scrollbar menu-bar
(scroll-bar-mode 0)
(tool-bar-mode 0)
(menu-bar-mode 0)


;;Kanske.el
(define-generic-mode 'kanske-mode
  '("kse-mode")
  '("om" "annars" "annat" "slut" "medan" "ret" "och" "eller" "inte" "funk" )
  '(("sant\\|kanske\\|falskt"  . 'font-lock-variable-name-face)
    ("funk \\([^(]*\\)" . (1 font-lock-function-name-face))     ;;1 =  regex match
    ("\\!\\?.*$" . font-lock-comment-face)
    ("\\?\\![\n]*[^!?]+\\?\\!" . font-lock-comment-face)) 
  '("\\.kse$")
  nil
  "A mode for kse files."
  )
(global-set-key [f11] 'compile)
(add-hook 'kanske-mode-hook
          (lambda ()
            (set (make-local-variable 'compile-command)
                 (concat "ruby kanske.rb " buffer-file-name))))
(add-hook 'ruby-mode-hook
          (lambda ()
            (set (make-local-variable 'compile-command)
                 (concat "ruby " buffer-file-name))))


