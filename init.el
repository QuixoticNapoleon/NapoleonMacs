;;; init.el --- Emacs configuration entry point -*- lexical-binding: t -*-

;; =====================================
;; 📦 Package Management (straight.el)
;; =====================================

;; Only check for modifications when explicitly checking
(setq straight-check-for-modifications '(find-when-checking))

;; Bootstrap straight.el from XDG config directory
(defvar bootstrap-version)
(let* ((user-dir (file-name-as-directory
			(or (getenv "XDG_CONFIG_HOME") "~/.config/")))
		(emacs-dir (concat user-dir "emacs/"))
		(bootstrap-file
		(expand-file-name "straight/repos/straight.el/bootstrap.el" emacs-dir))
	(bootstrap-version 6))
(unless (file-exists-p bootstrap-file)
	(with-current-buffer
		(url-retrieve-synchronously
		 "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
		 'silent 'inhibit-cookies)
		(goto-char (point-max))
		(eval-print-last-sexp)))
(load bootstrap-file nil 'nomessage))

;; Freeze File
(setq straight-freeze-file (expand-file-name "versions.el" user-emacs-directory))

;; Integrate straight.el with use-package
(straight-use-package 'use-package)
(setq straight-use-package-by-default t)

;; Essential use-package utilities
(use-package diminish)	;; Hide/abbreviate minor modes

;; Nerd Icons - icon library (must be loaded early)
(use-package nerd-icons
  :if (display-graphic-p))

;; =====================================
;; 🎨 UI & Visual Configuration
;; =====================================

;; Disable UI elements not covered by early-init.el
(tooltip-mode -1)
(blink-cursor-mode -1)
(fringe-mode 0)

;; Disable startup messages and bell
(setq inhibit-startup-screen t
	inhibit-startup-message t
	inhibit-startup-echo-area-message t
	ring-bell-function 'ignore)

;; Configure line numbers with themed colors
;; Enable globally, then disable in specific modes
(global-display-line-numbers-mode 1)
(setq display-line-numbers-type 'relative)	;; Relative line numbers for Evil mode

;; Disable line numbers in special buffers
(dolist (mode '(org-mode-hook
                term-mode-hook
                shell-mode-hook
                eshell-mode-hook
                help-mode-hook
                dired-mode-hook))

  (add-hook mode (lambda () (display-line-numbers-mode 0))))
(set-face-attribute 'line-number nil
	:foreground "#4fa8a8"	;; Softer cyan for line numbers
	:background "#003636")
(set-face-attribute 'line-number-current-line nil
	:foreground "#8affff"	;; Bright cyan for current line
	:background "#003636"
	:weight 'bold)
(set-face-attribute 'fringe nil :background "#003636")

;; Configure cursor and selection colors
(set-face-attribute 'cursor nil
	:background "#FFC600")	;; Yellow/gold cursor
(set-face-attribute 'region nil
	:background "#395e5e"	;; Dark teal selection
	:foreground 'unspecified)  ;; Keep text color unchanged

;; Configure mode-line colors
(set-face-attribute 'mode-line nil
	:background "#004344"	;; Dark teal background
	:foreground "#8affff"	;; Bright cyan text
	:box nil)			   ;; Remove border
;;:box '(:line-width 3 :color "#004344"))  ;; Add padding for icons
(set-face-attribute 'mode-line-inactive nil
	:background "#003030"	;; Darker background for inactive
	:foreground "#808080"	;; Gray text for inactive
	:box nil)			   ;; Remove border

;; Configure window divider color (between buffers)
(set-face-attribute 'vertical-border nil
	:foreground "#74c4c4")	;; Window divider color

;; Configure internal border (gray bar around frame in GUI)
;; (set-face-attribute 'internal-border nil
;;					:background "#002323")

;; Configure header-line (bar at top of buffers like C-x C-b)
(set-face-attribute 'header-line nil
	:background "#002323"
	:foreground "#8affff"
	:box nil)

;; =====================================
;; 🔧 Editing Behavior
;; =====================================

;; Auto-pair parentheses, brackets, quotes, etc.
(electric-pair-mode 1)

;; Enable electric-indent for auto-indenting on RET
(electric-indent-mode 1)

;; =====================================
;; I LOVE TABS
;; =====================================

;; Global tab settings
(setq-default indent-tabs-mode t)  ;; Use tabs, not spaces
(setq-default tab-width 4)		   ;; Display tabs as 4 spaces wide
(setq-default tab-stop-list (number-sequence 4 200 4))	;; Tab stops every 4 spaces

;; Don't convert tabs to spaces when deleting
(setq backward-delete-char-untabify-method nil)

;; Enforce tabs in all major modes (many modes override indent-tabs-mode)
(defun enforce-tabs ()
	"Force use of tabs for indentation in all modes."
	(setq indent-tabs-mode t)
	(setq tab-width 4)
	;; Make TAB key insert a tab character instead of smart-indenting
	(local-set-key (kbd "TAB") 'tab-to-tab-stop))

;; Apply to all major modes
(add-hook 'prog-mode-hook 'enforce-tabs)
(add-hook 'text-mode-hook 'enforce-tabs)
(add-hook 'conf-mode-hook 'enforce-tabs)

;; Fallback indent offset
(setq-default standard-indent 4)
(setq-default lisp-indent-offset 4)
(setq-default sh-basic-offset 4)

;; Make sure electric-indent respects tabs
(setq electric-indent-inhibit nil)

;; Force conversion of spaces to tabs after indentation
(defun tabify-current-line ()
	"Convert leading spaces to tabs on the current line."
	(when indent-tabs-mode
	(save-excursion
		(beginning-of-line)
		(when (looking-at "[ \t]+")
		(tabify (point) (match-end 0))))))

;; Run after electric-indent
(add-hook 'post-self-insert-hook 'tabify-current-line)

;; =====================================
;; Whitespace Visualization (listchars)
;; =====================================

;; Show whitespace characters like Vim's listchars
(use-package whitespace
  :straight nil	 ;; Built-in package
  :hook (prog-mode . whitespace-mode)
  :config
  ;; What to visualize
  (setq whitespace-style '(face
						tabs
						spaces
						trailing
						space-mark
						tab-mark
						newline
						newline-mark))

  ;; Character mappings (like Vim listchars)
  (setq whitespace-display-mappings
		'(
		;; tab: show as "│»»»" (char 9 = tab)
		(tab-mark 9 [9474 187 187 187] [124 187 187 187])
		;; space: show as "·" (char 32 = space)
		(space-mark 32 [183] [46])
		;; newline: show as "↲" (char 10 = newline)
		(newline-mark 10 [8626 10] [182 10])
		;; non-breaking space: show as "␣"
		(space-mark 160 [9251] [95])))

  ;; Face colors for whitespace characters
(set-face-attribute 'whitespace-tab nil
					:foreground "#016868"
					:background "#003636")
(set-face-attribute 'whitespace-space nil
					:foreground "#016868"
					:background "#003636")
(set-face-attribute 'whitespace-newline nil
					:foreground "#016868"
					:background "#003636")
(set-face-attribute 'whitespace-trailing nil
					:foreground "#d2691e"
					:background "#003030"))

;; Toggle whitespace-mode with a keybinding
;; (global-set-key (kbd "C-c w") 'whitespace-mode)

;; =====================================
;; Ligatures
;; =====================================

;; Enable ligatures for JetBrains Mono
;; Uses composition-function-table for proper ligature rendering
(defconst jetbrains-mono-ligatures
	'("-->" "//" "/**" "/*" "*/" "<!--" ":=" "->>" "<<-" "->" "<-"
	"<=>" "==" "!=" "<=" ">=" "=:=" "!==" "&&" "||" "..." ".."
	"|||" "///" "&&&" "===" "++" "--" "=>" "|>" "<|" "||>" "<||"
	"|||>" "<|||" ">>" "<<" "::=" "|]" "[|" "{|" "|}"
	"[<" ">]" ":?>" ":?" "/=" "[||]" "!!" "?:" "?." "::"
	"+++" "??" "###" "##" ":::" "####" ".?" "?=" "=!=" "<|>"
	"<:" ":<" ":>" ">:" "<>" "***" ";;" "/==" ".=" ".-" "__"
	"=/=" "<-<" "<<<" ">>>" "<=<" "<<=" "<==" "<==>" "==>" "=>>"
	">=>" ">>=" ">>-" ">-" "<~>" "-<" "-<<" "=<<" "---" "<-|"
	"<=|" "/\\" "\\/" "|=>" "|~>" "<~~" "<~" "~~" "~~>" "~>"
	"<$>" "<$" "$>" "<+>" "<+" "+>" "<*>" "<*" "*>" "</>" "</" "/>"
	"<->" "..<" "~=" "~-" "-~" "~@" "^=" "-|" "_|_" "|-" "||-"
	"|=" "||=" "#{" "#[" "]#" "#(" "#?" "#_" "#_(" "#:" "#!" "#="
	"&="))

;; Sort ligatures by length (longest first) to ensure proper matching
(setq jetbrains-mono-ligatures
	(sort jetbrains-mono-ligatures
			(lambda (x y) (> (length x) (length y)))))

;; Register each ligature pattern in the composition function table
(dolist (ligature jetbrains-mono-ligatures)
	(let ((pattern (regexp-quote ligature))
			(first-char (aref ligature 0)))
		(set-char-table-range composition-function-table
							first-char
							(nconc (char-table-range composition-function-table first-char)
									 (list (vector pattern
												0
												'compose-gstring-for-graphic))))))

;; =====================================
;; Smooth Scrolling
;; =====================================

(pixel-scroll-precision-mode 1)
(setq scroll-conservatively 101
	  scroll-margin 0
	  scroll-preserve-screen-position t)


;; =====================================
;; 😈 eVIl Mode MWAHAHAHAHAHHA
;; =====================================

(load (expand-file-name "config/evil.el" user-emacs-directory))

;; =====================================
;; 🔫 DOOM Modeline
;; =====================================

(load (expand-file-name "config/modeline.el" user-emacs-directory))
