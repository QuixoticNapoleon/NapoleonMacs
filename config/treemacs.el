;; Treemacs - Simple Configuration

(use-package treemacs
  :defer t
  :config
  (setq treemacs-width 35
		treemacs-width-is-initially-locked nil			   ;; Allow resizing
		treemacs-width-increment 1						   ;; Smooth resize
		treemacs-position 'left
		treemacs-show-hidden-files t
		; treemacs-indentation 1							 ;; Minimal indentation
		; treemacs-indentation-string " "					 ;; Just space, no lines

		;; Disable mouse Features
		treemacs-move-files-by-mouse-dragging nil		   ;; NO DRAGGING FILES!
		treemacs-recenter-after-file-follow nil				;; Prevent mouse issues
		treemacs-silent-filewatch t							;; Reduce mouse events
		treemacs-show-cursor nil)							;; Hide cursor in treemacs

  ;; Disable mouse in treemacs completely
  :hook
  (treemacs-mode . (lambda ()
					 ;; Disable all mouse button bindings
					 (define-key treemacs-mode-map [mouse-1] 'ignore)
					 (define-key treemacs-mode-map [mouse-2] 'ignore)
					 (define-key treemacs-mode-map [mouse-3] 'ignore)
					 (define-key treemacs-mode-map [drag-mouse-1] 'ignore)
					 (define-key treemacs-mode-map [down-mouse-1] 'ignore)
					 (define-key treemacs-mode-map [double-mouse-1] 'ignore)
					 (define-key treemacs-mode-map [triple-mouse-1] 'ignore)))
  :bind
  (:map global-map
		("M-0"		 . treemacs-select-window)
		("C-x t 1"	 . treemacs-delete-other-windows)
		("C-x t t"	 . treemacs)
		("C-x t d"	 . treemacs-select-directory)
		("C-x t B"	 . treemacs-bookmark)
		("C-x t C-t" . treemacs-find-file)
		("C-x t M-t" . treemacs-find-tag)))

;; Evil keybindings for treemacs
(use-package treemacs-evil
  :after (treemacs evil))

;; Beautiful icons for treemacs using nerd-icons
(use-package treemacs-nerd-icons
  :after treemacs
  :config
  ;; Reduce spacing between arrows and icons
  (setq treemacs-nerd-icons-tab (propertize " " :face 'treemacs-nerd-icons-file-face))
  (treemacs-load-theme "nerd-icons"))

;; Customize folder icon colors (for nerd-icons theme)
(with-eval-after-load 'treemacs-nerd-icons
  (set-face-attribute 'treemacs-nerd-icons-file-face nil
					  :foreground "#74c4c4"
					  :inherit 'unspecified))

;; Dired integration - adds nerd-icons to dired buffers
(use-package nerd-icons-dired
  :hook
  (dired-mode . nerd-icons-dired-mode))
