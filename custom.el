(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("5f128efd37c6a87cd4ad8e8b7f2afaba425425524a68133ac0efd87291d05874" default))
 '(inhibit-startup-screen t)
 '(lsp-ui-imenu-enable t)
 '(package-selected-packages
   '(treemacs dap-mode flycheck-golangci-lint projectile flx-ido yasnippet use-package lsp-ui go-mode flycheck company-lsp))
 '(safe-local-variable-values
   '((geiser-guile-binary "guix" "repl")
     (geiser-insert-actual-lambda)
     (eval progn
      (require 'lisp-mode)
      (defun emacs27-lisp-fill-paragraph
          (&optional justify)
        (interactive "P")
        (or
         (fill-comment-paragraph justify)
         (let
             ((paragraph-start
               (concat paragraph-start "\\|\\s-*\\([(;\"]\\|\\s-:\\|`(\\|#'(\\)"))
              (paragraph-separate
               (concat paragraph-separate "\\|\\s-*\".*[,\\.]$"))
              (fill-column
               (if
                   (and
                    (integerp emacs-lisp-docstring-fill-column)
                    (derived-mode-p 'emacs-lisp-mode))
                   emacs-lisp-docstring-fill-column fill-column)))
           (fill-paragraph justify))
         t))
      (setq-local fill-paragraph-function #'emacs27-lisp-fill-paragraph))
     (eval modify-syntax-entry 43 "'")
     (eval modify-syntax-entry 36 "'")
     (eval modify-syntax-entry 126 "'")
     (geiser-repl-per-project-p . t)
     (eval with-eval-after-load 'yasnippet
      (let
          ((guix-yasnippets
            (expand-file-name "etc/snippets/yas"
                              (locate-dominating-file default-directory ".dir-locals.el"))))
        (unless
            (member guix-yasnippets yas-snippet-dirs)
          (add-to-list 'yas-snippet-dirs guix-yasnippets)
          (yas-reload-all))))
     (eval with-eval-after-load 'tempel
      (if
          (stringp tempel-path)
          (setq tempel-path
                (list tempel-path)))
      (let
          ((guix-tempel-snippets
            (concat
             (expand-file-name "etc/snippets/tempel"
                               (locate-dominating-file default-directory ".dir-locals.el"))
             "/*.eld")))
        (unless
            (member guix-tempel-snippets tempel-path)
          (add-to-list 'tempel-path guix-tempel-snippets))))
     (eval with-eval-after-load 'git-commit
      (add-to-list 'git-commit-trailers "Change-Id"))
     (eval setq-local guix-directory
      (locate-dominating-file default-directory ".dir-locals.el"))
     (eval add-to-list 'completion-ignored-extensions ".go")
     (vc-prepare-patches-separately)
     (diff-add-log-use-relative-names . t)
     (vc-git-annotate-switches . "-w")))
 '(tool-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(put 'scroll-left 'disabled nil)
