;; Terafox-inspired theme for Emacs
;; Based on the Terafox colorscheme from nightfox.nvim

(deftheme terafox-emacs
  "A dark theme inspired by Terafox colorscheme")

;; Color palette - Terafox syntax with custom bg/fg
(let ((bg          "#003636")      ;; Keep your original dark teal bg
	  (fg          "#8affff")      ;; Keep original fg
	  ;; (bg-alt      "#002626")      ;; Darker variant
	  ;; (bg-alt      "#002323")      ;; Darker variant
	  (bg-alt      "#004344")      ;; Darker variant
	  (gray        "#2f3239")
	  ;; Terafox syntax colors from tmTheme
	  (keyword     "#ad5c7c")      ;; Mauve - keywords
	  (string      "#7aa4a1")      ;; Muted cyan - strings
	  (number      "#fda47f")      ;; Peachy orange - numbers/constants
	  (function    "#4d7d90")      ;; Steel blue - functions
	  (type        "#fda47f")      ;; Peachy orange - types
	  (builtin     "#e85c51")      ;; Coral red - built-ins
	  (variable    "#ad6771")      ;; Dusty mauve - variables
	  (operator    "#a1cdd8")      ;; Light cyan - operators
	  (comment     "#6a7c88")      ;; Dark gray - comments
	  (cursor      "#FFC600")      ;; Keep your yellow cursor
	  (selection   "#395e5e"))     ;; Keep your teal selection

  (custom-theme-set-faces
   'terafox-emacs

   ;; Base faces
   `(default ((t (:foreground ,fg :background ,bg))))
   `(cursor ((t (:background ,cursor))))
   `(region ((t (:background ,selection))))
   `(highlight ((t (:background ,bg-alt))))
   `(fringe ((t (:background ,bg))))
   `(vertical-border ((t (:foreground ,operator))))

   ;; Font lock (syntax highlighting)
   `(font-lock-builtin-face ((t (:foreground ,builtin))))
   `(font-lock-comment-face ((t (:foreground ,comment :slant italic))))
   `(font-lock-constant-face ((t (:foreground ,number))))
   `(font-lock-function-name-face ((t (:foreground ,function))))
   `(font-lock-keyword-face ((t (:foreground ,keyword))))
   `(font-lock-string-face ((t (:foreground ,string))))
   `(font-lock-type-face ((t (:foreground ,type))))
   `(font-lock-variable-name-face ((t (:foreground ,variable))))
   `(font-lock-warning-face ((t (:foreground ,builtin :weight bold))))

   ;; Completions
   `(completions-common-part ((t (:foreground ,operator))))
   `(completions-first-difference ((t (:foreground ,type :weight bold))))

   ;; Treemacs
   `(treemacs-directory-face ((t (:foreground "#74c4c4"))))
   `(treemacs-directory-collapsed-face ((t (:foreground "#74c4c4"))))
   `(treemacs-nerd-icons-file-face ((t (:foreground "#74c4c4"))))
   `(treemacs-nerd-icons-root-face ((t (:foreground ,fg :weight bold))))))

(provide-theme 'terafox-emacs)
