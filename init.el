;;; init.el --- Emacs configuration entry point -*- lexical-binding: t -*-

;; =====================================
;; 🚀 Performance Optimization
;; =====================================

;; Restore GC threshold after startup (maximized in early-init.el)
(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold (* 100 1024 1024))))

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
(use-package diminish)  ;; Hide/abbreviate minor modes
(use-package bind-key)  ;; Key binding utilities

;; =====================================
;; 🎨 UI & Visual Configuration
;; =====================================

;; Disable unnecessary UI elements
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(tooltip-mode -1)
(blink-cursor-mode -1)
(fringe-mode 0)

;; Disable startup messages and bell
(setq inhibit-startup-screen t
	inhibit-startup-message t
	inhibit-startup-echo-area-message t
	ring-bell-function 'ignore)

;; Configure line numbers with themed colors
(global-display-line-numbers-mode 1)
(setq display-line-numbers-type 'relative)  ;; Relative line numbers for Evil mode
(set-face-attribute 'line-number nil
					:foreground "#4fa8a8"   ;; Softer cyan for line numbers
					:background "#003636")
(set-face-attribute 'line-number-current-line nil
					:foreground "#8affff"   ;; Bright cyan for current line
					:background "#003636"
					:weight 'bold)
(set-face-attribute 'fringe nil :background "#003636")

;; Configure cursor and selection colors
(set-face-attribute 'cursor nil
					:background "#FFC600")  ;; Yellow/gold cursor
(set-face-attribute 'region nil
					:background "#395e5e"   ;; Dark teal selection
					:foreground 'unspecified)  ;; Keep text color unchanged

;; Configure mode-line colors
(set-face-attribute 'mode-line nil
					:background "#004344"   ;; Dark teal background
					:foreground "#8affff"   ;; Bright cyan text
					:box nil)			   ;; Remove border
(set-face-attribute 'mode-line-inactive nil
					:background "#003030"   ;; Darker background for inactive
					:foreground "#808080"   ;; Gray text for inactive
					:box nil)			   ;; Remove border

;; =====================================
;; 🔧 Editing Behavior
;; =====================================

;; Auto-pair parentheses, brackets, quotes, etc.
(electric-pair-mode 1)

;; Enable electric-indent for auto-indenting on RET
(electric-indent-mode 1)

;; Set tab-width to 4 globally (setq-default applies to all buffers)
(setq-default tab-width 4)

;; Use TAB characters when indenting
(setq-default indent-tabs-mode t)

;; =====================================
;; Whitespace Visualization (listchars)
;; =====================================

;; Show whitespace characters like Vim's listchars
(use-package whitespace
  :straight nil  ;; Built-in package
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
                      :background nil)
  (set-face-attribute 'whitespace-space nil
                      :foreground "#016868"
                      :background nil)
  (set-face-attribute 'whitespace-newline nil
                      :foreground "#016868"
                      :background nil)
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

;; (use-package ultra-scroll
;;   ;:vc (:url "https://github.com/jdtsmith/ultra-scroll") ; if desired (emacs>=v30)
;;   :init
;;   (setq scroll-conservatively 3 ; or whatever value you prefer, since v0.4
;;         scroll-margin 0)        ; important: scroll-margin>0 not yet supported
;;   :config
;;   (ultra-scroll-mode 1))

(pixel-scroll-precision-mode 1)
(setq scroll-conservatively 101
      scroll-margin 0
      scroll-preserve-screen-position t)


;; =====================================
;; 😈 eVIl Mode MWAHAHAHAHAHHA
;; =====================================

(load (expand-file-name "config/evil.el" user-emacs-directory))
