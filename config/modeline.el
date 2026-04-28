;; DOOM Modeline

;; Nerd Icons configuration for modeline (nerd-icons loaded in init.el)
(with-eval-after-load 'nerd-icons
	;; Fix missing data symlink (straight.el doesn't create it automatically)
	(let ((data-link (expand-file-name "straight/build/nerd-icons/data" user-emacs-directory))
		(data-source (expand-file-name "straight/repos/nerd-icons/data" user-emacs-directory)))
	(unless (file-exists-p data-link)
	(when (file-exists-p data-source)
		(make-symbolic-link data-source data-link))))

;; Prevent icons from becoming bold in active modeline
(dolist (face (face-list))
	(when (string-prefix-p "nerd-icons-" (symbol-name face))
	  (set-face-attribute face nil :weight 'normal)))

;; Adjust icon scale to prevent cutoff
(setq nerd-icons-scale-factor 1.0))

;; Must be set before loading doom-modeline
(setq doom-modeline-support-imenu t)

(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1)
  :config
  (setq doom-modeline-height 20
		doom-modeline-bar-width 4
		doom-modeline-window-width-limit 85
		doom-modeline-spc-face-overrides (list :family (face-attribute 'fixed-pitch :family))
		doom-modeline-project-detection 'auto
		doom-modeline-buffer-file-name-style 'auto
		doom-modeline-icon t
		doom-modeline-major-mode-icon t
		doom-modeline-major-mode-color-icon t
		doom-modeline-buffer-state-icon t
		doom-modeline-buffer-modification-icon t
		doom-modeline-buffer-name t
		doom-modeline-highlight-modified-buffer-name t
		doom-modeline-position-column-line-format '("%l:%c")
		doom-modeline-minor-modes nil
		doom-modeline-selection-info t
		doom-modeline-vcs-icon t
		doom-modeline-vcs-max-length 15
		doom-modeline-check-icon t
		doom-modeline-project-name t
		doom-modeline-modal t
		doom-modeline-modal-icon t
		doom-modeline-modal-modern-icon t
		doom-modeline-github nil
		doom-modeline-mu4e nil
		doom-modeline-gnus nil
		doom-modeline-irc nil
		doom-modeline-battery nil
		doom-modeline-time nil
		doom-modeline-env-version nil
		doom-modeline-lsp nil))

;; Prevent evil state icons from being bold in active modeline
(with-eval-after-load 'doom-modeline
  (dolist (face '(doom-modeline-evil-emacs-state
				  doom-modeline-evil-insert-state
				  doom-modeline-evil-motion-state
				  doom-modeline-evil-normal-state
				  doom-modeline-evil-operator-state
				  doom-modeline-evil-visual-state
				  doom-modeline-evil-replace-state
				  doom-modeline-evil-user-state))
	(set-face-attribute face nil :weight 'normal)))
