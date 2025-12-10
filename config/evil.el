;; Evil: Vim emulation layer
;; Must disable evil-want-keybinding before loading evil
;; This allows evil-collection to handle mode-specific keybindings
(setq evil-want-keybinding nil)

(use-package evil
  :init
  (setq evil-want-integration t)  ;; Required for evil-collection
  (setq evil-undo-system 'undo-redo)  ;; Use Emacs 28+ built-in undo-redo
  :config
  (evil-mode 1))
  ;; Restore Emacs-style C-n/C-p in insert mode for line movement
  ;; (define-key evil-insert-state-map (kbd "C-n") 'next-line)
  ;; (define-key evil-insert-state-map (kbd "C-p") 'previous-line))

(use-package evil-collection
  :after evil
  :straight (evil-collection :type git :host github :repo "emacs-evil/evil-collection"
                              :files (:defaults "modes"))
  :config
  (evil-collection-init))  ;; Provides Evil bindings for many Emacs modes
