;; Magit - Simple Git interface for Emacs

(use-package magit
  :bind
  (("C-x g"   . magit-status)           ;; Open Magit status
   ("C-x M-g" . magit-dispatch)         ;; Magit command menu
   ("C-c M-g" . magit-file-dispatch)    ;; File-specific commands
   ("C-c g b" . magit-blame)            ;; Git blame for current file
   ("C-c g l" . magit-log-buffer-file)  ;; Log for current file
   ("C-c g d" . magit-diff-buffer-file));; Diff for current file
  :config
  ;; Section highlight (when cursor is on a section)
  (set-face-attribute 'magit-section-highlight nil
					  :background "#004344")

  ;; Section heading text color (like "Unstaged changes", "Staged changes", etc.)
  (set-face-attribute 'magit-section-heading nil
					  :foreground "#ffc600")

  ;; Diff hunk headers (the @@ lines)
  (set-face-attribute 'magit-diff-hunk-heading nil
					  :background "#002323"
					  :foreground "#8affff")
  (set-face-attribute 'magit-diff-hunk-heading-highlight nil
					  :background "#112b2b"
					  :foreground "#8affff")

 ;; Diff context lines (unchanged lines in diffs)
 (set-face-attribute 'magit-diff-context nil
					  :background "#003636")
  (set-face-attribute 'magit-diff-context-highlight nil
					  :background "#004344")

 ;; Show recent commits
 (setq magit-log-section-commit-count 10)

 ;; Customize section order - keep unstaged, staged, and recent commits at top
 (setq magit-status-sections-hook
		'(magit-insert-status-headers
		  magit-insert-staged-changes
		  magit-insert-unstaged-changes
		  magit-insert-recent-commits
		  magit-insert-untracked-files
		  magit-insert-stashes
		  magit-insert-unpulled-from-upstream
		  magit-insert-unpushed-to-upstream
		  magit-insert-merge-log
		  magit-insert-rebase-sequence
		  magit-insert-am-sequence
		  magit-insert-sequencer-sequence
		  magit-insert-bisect-output
		  magit-insert-bisect-rest
		  magit-insert-bisect-log)))
