;; Projectile - Project management

(use-package projectile
	:config
	;; Enable projectile globally
	(projectile-mode +1)
	
	;; Set project search path (where your projects live)
	(setq projectile-project-search-path '("~/projects" "~/.config"))
	
	;; Cache project files for better performance
	(setq projectile-enable-caching t)
	
	;; Keybindings
	:bind-keymap
	("C-c p" . projectile-command-map)
	
	:bind
	; (("C-c p f" . projectile-find-file)		;; Find file in project
	;  ("C-c p p" . projectile-switch-project)	;; Switch between projects
	;  ("C-c p s" . projectile-ripgrep)))		;; Search in project
	)

(provide 'projectile)
