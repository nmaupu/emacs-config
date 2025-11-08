;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

(after! org
  (setq org-startup-indented t      ; enables org-indent-mode automatically
        org-hide-leading-stars t    ; hide extra stars before org-superstar runs
        org-ellipsis " ▾"))         ; nicer folding arrow
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
