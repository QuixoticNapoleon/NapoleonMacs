;; Dashboard - Startup screen
(use-package dashboard
	:config
	;; Use text banner from file
	(setq dashboard-startup-banner (expand-file-name "config/banner.txt" user-emacs-directory))
	(setq dashboard-banner-logo-title "In the Beginning was the Word, and the Word was with EMACS,\nand the Word was EMACS...")

	;; Customize the text banner face to make icon HUGE
	(set-face-attribute 'dashboard-text-banner nil
						:height 15.0
						:foreground "#8057b6")

	;; Customize the title face
	(set-face-attribute 'dashboard-banner-logo-title nil
						:height 1.2
						:foreground "#8affff"
						:weight 'bold)

	;; Center content
	(setq dashboard-center-content t)
	(setq dashboard-vertically-center-content t)

	;; Disable shortcut indicators
	(setq dashboard-show-shortcuts nil)

	;; Customize dashboard items
	(setq dashboard-items '((recents   . 5)
		(bookmarks . 5)
		(projects  . 5)
		(agenda    . 5)
		(registers . 5)))
	(setq dashboard-item-shortcuts '((recents   . "r")
		(bookmarks . "m")
		(projects  . "p")
		(agenda    . "a")
		(registers . "e")))

	;; Set up the startup hook
	(dashboard-setup-startup-hook))

(provide 'dashboard)
