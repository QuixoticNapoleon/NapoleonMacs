;; Evil: Vim emulation layer
;; Must disable evil-want-keybinding before loading evil
;; This allows evil-collection to handle mode-specific keybindings
(setq evil-want-keybinding nil)

(use-package evil
	:init
	(setq evil-want-integration t)  ;; Required for evil-collection
	(setq evil-undo-system 'undo-redo)  ;; Use Emacs 28+ built-in undo-redo
	:config
	(evil-mode 1)

	;; Cursor shapes per evil state
	(setq evil-normal-state-cursor 'box
		  evil-motion-state-cursor 'box
		  evil-visual-state-cursor 'box
		  evil-insert-state-cursor 'bar
		  evil-replace-state-cursor 'hbar
		  evil-emacs-state-cursor  'hbar))

;; Terminal cursor shape support (GUI handles it natively)
(use-package evil-terminal-cursor-changer
	:if (not (display-graphic-p))
	:after evil
	:config
	(etcc-on))

(use-package evil-collection
	:after evil
	:straight (evil-collection :type git :host github :repo "emacs-evil/evil-collection"
							 :files (:defaults "modes"))
	:config
	(evil-collection-init))  ;; Provides Evil bindings for many Emacs modes
