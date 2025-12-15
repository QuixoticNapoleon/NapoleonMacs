;; =====================================
;; Core Eshell Configuration
;; =====================================

;; Ensure eshell directory exists
(unless (file-directory-p (concat user-emacs-directory "eshell"))
  (make-directory (concat user-emacs-directory "eshell") t))

;; Scrolling behavior
(setq eshell-scroll-to-bottom-on-input 'all
      eshell-scroll-to-bottom-on-output 'all
      eshell-kill-processes-on-exit t
      eshell-hist-ignoredups t)

;; History settings
(setq eshell-history-size 100000
      eshell-history-file-name (concat user-emacs-directory "eshell/history")
      eshell-save-history-on-exit t)

;; Buffer naming
(setq eshell-buffer-maximum-lines 20000
      eshell-buffer-name "*eshell*")

;; Completion settings
(setq eshell-cmpl-cycle-completions nil
      eshell-cmpl-ignore-case t)

;; Visual commands (run in term mode instead of eshell)
(setq eshell-visual-commands '("vi" "vim" "nvim" "screen" "tmux" "top" "htop" "less" "more" "lynx" "ncftp" "mutt"))
(setq eshell-visual-subcommands '(("git" "log" "diff" "show")))

;; Optional: Hook to do extra setup when eshell starts
(add-hook 'eshell-first-time-mode-hook
          (lambda ()
            ;; any additional setup here
            ))

;; =====================================
;; xterm-color: Better ANSI Colors
;; =====================================

(use-package xterm-color
  :config
  ;; Preserve text properties before prompt
  (add-hook 'eshell-before-prompt-hook
            (lambda ()
              (setq xterm-color-preserve-properties t)))

  ;; Ensure hooks exist after Eshell is loaded
  (with-eval-after-load 'eshell
    ;; Replace default ansi-color with xterm-color
    (add-to-list 'eshell-preoutput-filter-functions 'xterm-color-filter)
    ;; Remove default ansi-color handler
    (setq eshell-output-filter-functions
          (remove 'eshell-handle-ansi-color eshell-output-filter-functions))))

;; =====================================
;; eshell-syntax-highlighting: Command Highlighting
;; =====================================

(use-package eshell-syntax-highlighting
  :after eshell
  :config
  ;; Enable syntax highlighting in all eshell buffers
  (eshell-syntax-highlighting-global-mode +1))

;; =====================================
;; esh-autosuggest: Fish-like Autosuggestions
;; =====================================

(use-package esh-autosuggest
  :hook (eshell-mode . esh-autosuggest-mode)
  :config
  ;; Use company for completions if available
  (setq esh-autosuggest-delay 0.5))

;; =====================================
;; eshell-prompt-extras: Enhanced Prompt
;; =====================================

(use-package eshell-prompt-extras
  :after eshell
  :config
  ;; Use epe-theme-lambda for a clean, informative prompt
  ;; Shows: user@host, git branch/status, python venv
  (setq eshell-highlight-prompt nil
        eshell-prompt-function 'epe-theme-lambda)

  ;; Prompt colors
  (set-face-attribute 'epe-pipeline-delimiter-face nil :foreground "#F3AB4D")
  (set-face-attribute 'epe-pipeline-user-face nil :foreground "#6BC0EE")
  (set-face-attribute 'epe-pipeline-host-face nil :foreground "#91F9E5")
  (set-face-attribute 'epe-dir-face nil :foreground "#8affff")
  (set-face-attribute 'epe-git-face nil :foreground "#FAF36F"))

;; =====================================
;; Eshell Aliases & Custom Functions
;; =====================================

(defun eshell/ll (&rest args)
  "ls -lh with optional arguments."
  (apply #'eshell/ls "-lh" args))

(defun eshell/l (&rest args)
  (apply #'eshell/ls "-lah" args))

(defun eshell/la (&rest args)
  "ls -lah (all files) with optional arguments."
  (apply #'eshell/ls "-lah" args))

(defun eshell/e (file)
  "Open FILE in Emacs."
  (find-file file))

(defun eshell/d (&optional dir)
  "Open dired in DIR (or current directory)."
  (dired (or dir ".")))

(defun eshell/take (dir)
  "Create directory DIR and cd into it."
  (make-directory dir t)
  (eshell/cd dir))

;; =====================================
;; Eshell Git Integration
;; =====================================

(defun eshell/gst ()
  "Git status."
  (magit-status))

(defun eshell/gd ()
  "Git diff."
  (magit-diff-unstaged))

(defun eshell/gds ()
  "Git diff staged."
  (magit-diff-staged))

;; =====================================
;; Multi-eshell: Manage Multiple Buffers
;; =====================================

(defvar eshell-buffer-index 1
  "Index for naming multiple eshell buffers.")

(defun eshell-new ()
  "Create a new eshell buffer."
  (interactive)
  (eshell t))

(defun eshell-here ()
  "Open eshell in current directory."
  (interactive)
  (let ((current-dir default-directory))
    (eshell)
    (unless (equal (eshell/pwd) current-dir)
      (eshell/cd current-dir)
      (eshell-send-input))))

;; =====================================
;; Keybindings
;; =====================================

(global-set-key (kbd "C-c e") 'eshell-new)
(global-set-key (kbd "C-c E") 'eshell-here)

;; Eshell-mode specific keybindings
(add-hook 'eshell-mode-hook
          (lambda ()
            ;; Company completion in eshell
            (company-mode +1)
            ;; Clear screen
            (define-key eshell-mode-map (kbd "C-l")
              (lambda ()
                (interactive)
                (eshell/clear 1)          ;; clear the buffer
                (eshell-emit-prompt)))    ;; insert a new prompt
            ;; History navigation
            (define-key eshell-mode-map (kbd "C-c C-l") 'eshell-list-history)
            ;; Emacs-style line navigation
            (define-key eshell-mode-map (kbd "C-a") 'eshell-bol)
            (define-key eshell-mode-map (kbd "C-e") 'end-of-line)))

;; =====================================
;; Evil Integration
;; =====================================

(with-eval-after-load 'evil
  ;; Start in insert mode (like terminal)
  (add-to-list 'evil-insert-state-modes 'eshell-mode)

  ;; Add eshell to evil-collection if available
  (with-eval-after-load 'evil-collection
    (evil-collection-eshell-setup)))

(provide 'config-eshell)
;;; eshell.el ends here

;; =====================================
;; Startup
;; =====================================

(defun my-eshell-startup-hook ()
  ;; clear banner
  (setq eshell-banner-message "")
  ;; run fastfetch
  (eshell-command "fastfetch"))

(add-hook 'eshell-first-time-mode-hook #'my-eshell-startup-hook)
