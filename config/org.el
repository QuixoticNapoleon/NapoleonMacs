;; Org Mode Configuration

;; =====================================
;; Core Org Settings
;; =====================================

(global-set-key (kbd "C-c a") 'org-agenda)
(global-set-key (kbd "C-c c") 'org-capture)

(setq org-directory "~/Notes")

;; Recursively find all .org files under ~/Notes
(setq org-agenda-files
	  (directory-files-recursively "~/Notes" "\\.org$"))

;; Open agenda in column view (table) by default
(setq org-agenda-view-columns-initially t)

;; TODO workflow states
(setq org-todo-keywords
	  '((sequence "TODO" "|" "DONE")))

;; Log timestamp when task is marked DONE
(setq org-log-done 'time)

;; =====================================
;; Deadline Tracker (auto-computed)
;; =====================================

(defun org-update-deadline-properties ()
  "Update DAYS and URGENCY properties for all entries with deadlines."
  (interactive)
  (org-map-entries
   (lambda ()
	 (let ((deadline (org-get-deadline-time (point)))
		   (done (org-entry-is-done-p)))
	   (when deadline
		 (if done
			 (progn
			   (org-set-property "DAYS" "0")
			   (org-set-property "URGENCY" "DONE"))
		   (let* ((days (- (time-to-days deadline) (time-to-days (current-time))))
				  (urgency (cond
							((< days 0) "OVERDUE")
							((<= days 7) "CLOSE")
							(t "OK"))))
			 (org-set-property "DAYS" (number-to-string days))
			 (org-set-property "URGENCY" urgency))))))
   "/TODO|DONE" 'file))

;; Auto-update when opening org files
(add-hook 'org-mode-hook
		  (lambda ()
			(when (and buffer-file-name
					   (string-match-p "tasks\\.org$" buffer-file-name))
			  (org-update-deadline-properties))))

;; =====================================
;; Org Super Agenda
;; =====================================

(use-package org-super-agenda
  :after org
  :config
  (org-super-agenda-mode 1))

;; =====================================
;; CalDAV Sync
;; =====================================

;; Load CalDAV credentials from gitignored file
(let ((caldav-secrets (expand-file-name "~/Notes/caldav.el")))
  (when (file-exists-p caldav-secrets)
	(load caldav-secrets)))

(use-package org-caldav
  :after org
  :config
  (setq org-caldav-inbox "~/Notes/caldav-inbox.org"
		org-caldav-files '("~/Notes/tasks.org")))

;; =====================================
;; Calendar Framework (calfw)
;; =====================================

(use-package calfw
  :demand t)

(use-package calfw-org
  :demand t
  :after calfw
)
