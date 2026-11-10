;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

(after! org
  (setq org-startup-indented t      ; enables org-indent-mode automatically
        org-hide-leading-stars t    ; hide extra stars before org-superstar runs
        org-ellipsis " ▾"))         ; nicer folding arrow

;;; TODO workflow
;; - STRT          -> appends today's <date> to the heading (unless it already has one)
;; - DONE/KILL     -> appends <date> (or " -> <date>" if a date is already there)
;; - ARCHIVE       -> same as DONE, then moves the subtree to TODO-old.org
;; - SPC m s D     -> archives every DONE/KILL entry of the file at once
(defvar my/org-stamped-done-states '("DONE" "KILL" "ARCHIVE")
  "TODO states that get a completion date appended to the heading.")

(defun my/org-todo-archive-file ()
  (expand-file-name "TODO-old.org" org-directory))

(after! org
  ;; Add ARCHIVE as an extra "done" state of the main TODO sequence.
  (unless (member "ARCHIVE(a)" (car org-todo-keywords))
    (setf (car org-todo-keywords)
          (append (car org-todo-keywords) '("ARCHIVE(a)"))))
  (setq org-archive-save-context-info nil ; no :ARCHIVE_TIME: etc. properties
        org-archive-reversed-order t))    ; newest archived entries on top

(defun my/org-stamp-heading (done)
  "Append today's active timestamp to the current heading title.
When DONE is nil (task started), only stamp if the title has no date yet.
When DONE is non-nil, stamp `<today>', or ` -> <today>' if the title
already has a date.  Never stamp twice the same day."
  (save-excursion
    (org-back-to-heading t)
    (when (and (looking-at org-complex-heading-regexp) (match-end 4))
      (let ((title (match-string-no-properties 4))
            (end (match-end 4))
            (today (format-time-string "<%Y-%m-%d %a>")))
        (cond ((string-search today title) nil)
              ((not (string-match-p org-ts-regexp title))
               (goto-char end) (insert today))
              (done (goto-char end) (insert " -> " today)))))))

(defun my/org-archive-at (marker)
  "Turn the ARCHIVE heading at MARKER into DONE and archive its subtree."
  (when (buffer-live-p (marker-buffer marker))
    (with-current-buffer (marker-buffer marker)
      (save-excursion
        (goto-char marker)
        (let ((org-after-todo-state-change-hook nil))
          (org-todo "DONE"))
        (org-archive-subtree))))
  (set-marker marker nil))

(defun my/org-todo-state-changed-h ()
  (let ((now-done (member org-state my/org-stamped-done-states))
        (was-done (member org-last-state my/org-stamped-done-states)))
    (cond ((equal org-state "STRT") (my/org-stamp-heading nil))
          ((and now-done (not was-done)) (my/org-stamp-heading t)))
    (when (equal org-state "ARCHIVE")
      ;; Deferred: archiving from inside `org-todo' would confuse it (and the
      ;; agenda) since the heading disappears from under its feet.
      (run-at-time 0 nil #'my/org-archive-at
                   (save-excursion (org-back-to-heading t) (point-marker))))))
(add-hook 'org-after-todo-state-change-hook #'my/org-todo-state-changed-h)

(defun my/org-todo-file-setup-h ()
  "Archive ~/org/TODO.org entries into ~/org/TODO-old.org."
  (when (and buffer-file-name
             (file-equal-p buffer-file-name
                           (expand-file-name "TODO.org" org-directory)))
    (setq-local org-archive-location (concat (my/org-todo-archive-file) "::"))))
(add-hook 'org-mode-hook #'my/org-todo-file-setup-h)

(defun my/org-subtree-has-open-todo-p ()
  "Non-nil if a heading below the current one is still open (TODO, STRT...)."
  (save-excursion
    (org-back-to-heading t)
    (let ((end (save-excursion (org-end-of-subtree t t))))
      (catch 'found
        (while (and (outline-next-heading) (< (point) end))
          (when (member (org-get-todo-state) org-not-done-keywords)
            (throw 'found t)))))))

(defun my/org-archive-all-done ()
  "Archive every DONE/KILL/ARCHIVE entry of the current file.
Entries that still contain open sub-tasks are left in place."
  (interactive)
  (let* ((match "/DONE|KILL|ARCHIVE")
         (n (length (delq nil (org-map-entries
                               (lambda () (not (my/org-subtree-has-open-todo-p)))
                               match 'file)))))
    (if (zerop n)
        (message "Nothing to archive")
      (when (y-or-n-p (format "Archive %d done entries? " n))
        (org-map-entries
         (lambda ()
           (unless (my/org-subtree-has-open-todo-p)
             (org-archive-subtree)
             (setq org-map-continue-from
                   (org-element-property :begin (org-element-at-point)))))
         match 'file)
        (message "Archived %d entries" n)))))

(map! :after org
      :map org-mode-map
      :localleader
      (:prefix ("s" . "tree/subtree")
       "D" #'my/org-archive-all-done))
;; Remap <left> and <right> only for org-tree-slide-mode
(map! :after org-tree-slide
      :map org-tree-slide-mode-map
      [remap evil-forward-char] #'org-tree-slide-move-next-tree)
(map! :after org-tree-slide
      :map org-tree-slide-mode-map
      [remap evil-backward-char] #'org-tree-slide-move-previous-tree)
(map! :after org-tree-slide
      :map org-tree-slide-mode-map
      [remap evil-record-macro] #'org-tree-slide-mode)
(setq! visual-fill-column-width 110
      visual-fill-column-center-text t)
(defun my/org-tree-slide-start()
  (visual-fill-column-mode 1)
  (visual-line-mode 1)
  (display-line-numbers-mode 0))
(defun my/org-tree-slide-stop()
  (visual-fill-column-mode 0)
  (visual-line-mode 0)
  (display-line-numbers-mode 1))
(add-hook! 'org-tree-slide-play-hook 'my/org-tree-slide-start)
(add-hook! 'org-tree-slide-stop-hook 'my/org-tree-slide-stop)
