;; early-init.el --- Early initialization for fast startup -*- lexical-binding: t -*-

;; =====================================
;; 🚀 Performance Optimization
;; =====================================

;; Maximize GC threshold during startup (restored in init.el)
(setq gc-cons-threshold most-positive-fixnum)


;; =====================================
;; 🎨 Terafox Theme
;; =====================================

;; Add config directory to theme path
(add-to-list 'custom-theme-load-path (expand-file-name "themes" user-emacs-directory))
(load-theme 'terafox-emacs t)


;; =====================================
;; 🎨 UI Configuration (Pre-GUI Init)
;; =====================================

;; Configure frame appearance BEFORE GUI initializes
;; This prevents the white flash on startup
(setq default-frame-alist
	  '((font . "JetBrainsMono Nerd Font-10.5:weight=semi-bold:antialias=true:hinting=true:hintstyle=slight")
		(background-color . "#003636")	;; Dark cyan background
		(foreground-color . "#8affff")	;; Bright cyan text
		(alpha-background . 75)			 ;; 75% opacity (GUI only)
		(internal-border-width . 0)
		(vertical-scroll-bars . nil)
		(menu-bar-lines . 0)
		(tool-bar-lines . 0)))

;; Use system font rendering settings for better anti-aliasing
(setq-default font-use-system-font t)

;; Prevent package.el from loading (we use straight.el instead)
(setq package-enable-at-startup nil)
