;; Completion Framework - Vertico + Consult + Marginalia + Orderless
;; Modern, minimal completion system based on Emacs' built-in completing-read

;; =====================================
;; Vertico - Vertical completion UI
;; =====================================
(use-package vertico
  :init
  (vertico-mode 1)
  :config
  ;; Cycle through candidates
  (setq vertico-cycle t)
  ;; Number of candidates to display
  (setq vertico-count 15))

;; =====================================
;; Orderless - Flexible completion style
;; =====================================
(use-package orderless
  :config
  ;; Use orderless for completion
  (setq completion-styles '(orderless basic)
		completion-category-defaults nil
		completion-category-overrides '((file (styles partial-completion)))))

;; =====================================
;; Marginalia - Rich annotations
;; =====================================
(use-package marginalia
  :init
  (marginalia-mode 1)
  :config
  ;; Bind in minibuffer to toggle annotations
  (define-key minibuffer-local-map (kbd "M-A") 'marginalia-cycle))

;; =====================================
;; Consult - Enhanced commands
;; =====================================
(use-package consult
  :bind
  (;; C-c bindings (mode-specific-map)
   ("C-c h" . consult-history)
   ("C-c m" . consult-mode-command)
   ("C-c k" . consult-kmacro)

   ;; C-x bindings (ctl-x-map)
   ("C-x M-:" . consult-complex-command)
   ("C-x b" . consult-buffer)				;; Replace switch-to-buffer
   ("C-x 4 b" . consult-buffer-other-window)
   ("C-x 5 b" . consult-buffer-other-frame)
   ("C-x r b" . consult-bookmark)

   ;; M-g bindings (goto-map)
   ("M-g e" . consult-compile-error)
   ("M-g f" . consult-flymake)
   ("M-g g" . consult-goto-line)
   ("M-g M-g" . consult-goto-line)
   ("M-g o" . consult-outline)
   ("M-g m" . consult-mark)
   ("M-g k" . consult-global-mark)
   ("M-g i" . consult-imenu)
   ("M-g I" . consult-imenu-multi)

   ;; M-s bindings (search-map)
   ("M-s d" . consult-find)
   ("M-s D" . consult-locate)
   ("M-s g" . consult-grep)
   ("M-s G" . consult-git-grep)
   ("M-s r" . consult-ripgrep)
   ("M-s l" . consult-line)
   ("M-s L" . consult-line-multi)
   ("M-s k" . consult-keep-lines)
   ("M-s u" . consult-focus-lines)

   ;; Isearch integration
   ("M-s e" . consult-isearch-history)
   :map isearch-mode-map
   ("M-e" . consult-isearch-history)
   ("M-s e" . consult-isearch-history)
   ("M-s l" . consult-line)
   ("M-s L" . consult-line-multi)

   ;; Minibuffer history
   :map minibuffer-local-map
   ("M-s" . consult-history)
   ("M-r" . consult-history))

  :config
  ;; Preview configuration
  (setq consult-preview-key 'any)			;; Preview as you type

  ;; Narrowing configuration
  (setq consult-narrow-key "<"))			;; Use < to narrow

;; =====================================
;; Embark - Actions on candidates
;; =====================================
(use-package embark
  :bind
  (("C-." . embark-act)			;; Pick an action using completion
   ("C-;" . embark-dwim)		;; Good alternative: M-.
   ("C-h B" . embark-bindings))	;; Alternative for `describe-bindings'
  :config
  ;; Hide the mode line of the Embark live/completions buffers
  (add-to-list 'display-buffer-alist
			   '("\\`\\*Embark Collect \\(Live\\|Completions\\)\\*"
				 nil
				 (window-parameters (mode-line-format . none)))))

;; Embark + Consult integration
(use-package embark-consult
  :after (embark consult)
  :hook
  (embark-collect-mode . consult-preview-at-point-mode))

(provide 'completion)
