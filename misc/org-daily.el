;;; misc/org-daily.el -*- lexical-binding: t; -*-
;;
;; Async daily generated from ~/org/TODO.org (+ TODO-old.org).
;;
;; - SPC m d w  (org)  -> "worked on it today": append <today> to the heading
;; - SPC m d y  (org)  -> same with the last working day (Friday on Monday)
;; - SPC n O           -> toggle TODO.org in a right-side popup
;; - SPC n T           -> add a TODO/STRT/DONE entry to TODO.org from anywhere
;; - SPC n D           -> build the async daily and copy it to the clipboard
;;     * yesterday: every heading dated with the last working day
;;     * today:     picked interactively among open TODO/STRT headings,
;;                  free text accepted (M-RET forces typed text if it
;;                  partially matches a candidate)
;;
;; Relies on `my/org-stamp-heading' from misc/org.el.

(declare-function my/org-stamp-heading "org" (done &optional time))

(defvar my/daily-done-label "-- done --"
  "Pseudo-candidate ending the \"today\" picker.")

(defun my/org-touch-heading ()
  "Mark the current heading as worked on today by appending <today>."
  (interactive)
  (my/org-stamp-heading t)
  (message "Stamped %s" (format-time-string "<%Y-%m-%d %a>")))

(defun my/org-touch-heading-yesterday ()
  "Mark the current heading as worked on the last working day."
  (interactive)
  (let ((time (date-to-time (concat (my/daily--last-working-day) " 12:00"))))
    (my/org-stamp-heading t time)
    (message "Stamped %s" (format-time-string "<%Y-%m-%d %a>" time))))

;;; Helpers

(defun my/daily--clean (s)
  "Strip timestamps, URLs, empty parens and extra spaces from S."
  (let ((s (org-link-display-format s)))
    (setq s (replace-regexp-in-string org-ts-regexp-both "" s)
          s (replace-regexp-in-string "https?://[^][ \t()<>]+" "" s)
          s (replace-regexp-in-string "([ \t]*)" "" s)
          s (replace-regexp-in-string "[ \t]+" " " s))
    (string-trim s)))

(defun my/daily--title ()
  (my/daily--clean (org-get-heading t t t t)))

(defun my/daily--label ()
  "\"Top-level parent: heading\" label for the heading at point."
  (let ((title (my/daily--title))
        (top (when (> (org-current-level) 1)
               (save-excursion
                 (while (org-up-heading-safe))
                 (my/daily--title)))))
    (if top (concat top ": " title) title)))

(defun my/daily--last-working-day (&optional now)
  "YYYY-MM-DD of the last working day before NOW (Friday on Sat/Sun/Mon)."
  (let* ((now (or now (current-time)))
         (back (pcase (string-to-number (format-time-string "%u" now))
                 (1 3) (7 2) (_ 1)))
         (d (decode-time now)))
    (format-time-string
     "%Y-%m-%d"
     (encode-time (list 0 0 12 (- (decoded-time-day d) back)
                        (decoded-time-month d) (decoded-time-year d)
                        nil -1 nil)))))

(defmacro my/daily--with-file (file &rest body)
  "Run BODY in FILE's buffer; kill the buffer afterwards if we opened it."
  (declare (indent 1))
  `(let* ((existing (find-buffer-visiting ,file))
          (buf (or existing (find-file-noselect ,file))))
     (unwind-protect
         (with-current-buffer buf
           (org-with-wide-buffer ,@body))
       (unless existing (kill-buffer buf)))))

(defun my/daily--files ()
  (seq-filter #'file-exists-p
              (list (expand-file-name "TODO.org" org-directory)
                    (expand-file-name "TODO-old.org" org-directory))))

;;; Yesterday

(defun my/daily--dated-entries (date)
  "Entries (BEG END LABEL) of the current buffer whose heading has DATE."
  (let ((re (concat "[<[]" (regexp-quote date))))
    (delq nil
          (org-map-entries
           (lambda ()
             (when (string-match-p re (org-get-heading t t t t))
               (list (point)
                     (save-excursion (org-end-of-subtree t t))
                     (my/daily--label))))
           nil 'file))))

(defun my/daily--drop-covered-parents (entries)
  "Remove entries having one of their descendants in ENTRIES."
  (seq-remove (lambda (e)
                (seq-some (lambda (o) (and (> (car o) (car e))
                                           (< (car o) (cadr e))))
                          entries))
              entries))

(defun my/daily-yesterday-items (&optional date files)
  "Labels of headings dated DATE (default: last working day) in FILES."
  (let ((date (or date (my/daily--last-working-day))))
    (delete-dups
     (mapcan (lambda (f)
               (my/daily--with-file f
                 (mapcar #'caddr
                         (my/daily--drop-covered-parents
                          (my/daily--dated-entries date)))))
             (or files (my/daily--files))))))

;;; Today

(defun my/daily-today-candidates (&optional file)
  "Labels of open TODO/STRT headings of FILE, STRT first."
  (let (strt todo)
    (my/daily--with-file (or file (car (my/daily--files)))
      (org-map-entries
       (lambda ()
         (pcase (org-get-todo-state)
           ("STRT" (push (my/daily--label) strt))
           ("TODO" (push (my/daily--label) todo))))
       nil 'file))
    (delete-dups (append (nreverse strt) (nreverse todo)))))

(defun my/daily--ordered-table (cands)
  "Completion table over CANDS that keeps their order."
  (lambda (str pred action)
    (if (eq action 'metadata)
        '(metadata (display-sort-function . identity)
                   (cycle-sort-function . identity))
      (complete-with-action action cands str pred))))

(defun my/daily--pick-today (cands)
  "Pick items among CANDS (free text allowed) until `my/daily-done-label'."
  (let (picked choice)
    (while (progn
             (setq choice
                   (string-trim
                    (completing-read
                     (format "Today (%d picked): " (length picked))
                     (my/daily--ordered-table (cons my/daily-done-label cands))
                     nil nil nil t)))
             (not (member choice (list "" my/daily-done-label))))
      (push choice picked)
      (setq cands (delete choice cands)))
    (nreverse picked)))

;;; Output

(defun my/daily-format (yesterday today)
  (mapconcat #'identity
             (append '("Async daily" "What I did yesterday")
                     (mapcar (lambda (s) (concat "• " s)) yesterday)
                     '("What I expect to do today?")
                     (mapcar (lambda (s) (concat "• " s)) today))
             "\n"))

(defun my/org-async-daily ()
  "Build the async daily and copy it to the clipboard."
  (interactive)
  (require 'org)
  (let* ((yesterday (my/daily-yesterday-items))
         (today (my/daily--pick-today (my/daily-today-candidates))))
    (kill-new (my/daily-format yesterday today))
    (message "Async daily copied (%d yesterday, %d today)"
             (length yesterday) (length today))))

;;; Quick add

(defvar my/daily-top-level-label "-- top level --"
  "Pseudo-parent meaning \"add at the end of the file\".")

(defun my/daily--open-headings ()
  "Alist (LABEL . POS) of open TODO/STRT headings of the current buffer."
  (delq nil
        (org-map-entries
         (lambda ()
           (when (member (org-get-todo-state) '("TODO" "STRT"))
             (cons (my/daily--label) (point))))
         nil 'file)))

(defun my/org-quick-add ()
  "Add a TODO/STRT/DONE entry to ~/org/TODO.org without opening it.
STRT and DONE entries get today's date."
  (interactive)
  (require 'org)
  (let ((title (string-trim (read-string "New entry: ")))
        state where)
    (when (string-empty-p title) (user-error "Empty title"))
    (setq state (pcase (car (read-multiple-choice
                             "Status" '((?t "todo") (?s "started") (?d "done"))))
                  (?t "TODO") (?s "STRT") (?d "DONE")))
    (my/daily--with-file (expand-file-name "TODO.org" org-directory)
      (let* ((headings (my/daily--open-headings))
             (choice (completing-read
                      "Parent: "
                      (my/daily--ordered-table
                       (cons my/daily-top-level-label (mapcar #'car headings)))
                      nil t nil t my/daily-top-level-label))
             (parent (cdr (assoc choice headings)))
             (level 1))
        (if (not parent)
            (goto-char (point-max))
          (goto-char parent)
          (setq level (1+ (org-current-level))
                where choice)
          (org-end-of-subtree t t))
        (unless (bolp) (insert "\n"))
        (insert (make-string level ?*) " " state " " title "\n")
        (forward-line -1)
        (unless (equal state "TODO")
          (my/org-stamp-heading (equal state "DONE")))
        (save-buffer)))
    (message "Added %s %s%s" state title
             (if where (format " (under %s)" where) ""))))

;;; TODO.org as a popup (right side, 40%)
;; popper treats it as a popup via `popper-reference-buffers' (config.el),
;; Doom's popup rule below only decides where/how it's displayed.
;; :ttl nil  -> never kill the buffer when the popup closes
;; :quit nil -> ESC doesn't close it (only SPC n O does)
(set-popup-rule! "^TODO\\.org$"
  :side 'right :size 0.4 :select t :quit nil :ttl nil :modeline t)

(defun my/org-open-todo ()
  "Toggle ~/org/TODO.org in a right-side popup.
If it's displayed in a regular window instead, just select that window."
  (interactive)
  (let* ((file (expand-file-name "TODO.org" org-directory))
         (buf (find-buffer-visiting file))
         (win (and buf (get-buffer-window buf))))
    (cond ((and win (or (and (fboundp '+popup-window-p) (+popup-window-p win))
                        (and (fboundp 'popper-popup-p) (popper-popup-p buf))))
           (with-current-buffer buf (when (buffer-modified-p) (save-buffer)))
           (if (and (fboundp '+popup-window-p) (+popup-window-p win))
               (with-no-warnings (+popup/close win t))
             (delete-window win)))
          (win (select-window win))
          (t (pop-to-buffer (or buf (find-file-noselect file)))))))

(map! :after org
      :map org-mode-map
      :localleader
      (:prefix ("d" . "date/deadline")
       :desc "Worked on it today" "w" #'my/org-touch-heading
       :desc "Worked on it yesterday" "y" #'my/org-touch-heading-yesterday))

(map! :leader
      (:prefix "n"
       :desc "Async daily → clipboard" "D" #'my/org-async-daily
       :desc "Quick add TODO entry"     "T" #'my/org-quick-add
       :desc "Toggle TODO.org popup"    "O" #'my/org-open-todo))
