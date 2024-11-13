;;; go.el -*- lexical-binding: t; -*-

;; Based on:
;; - https://apmattil.medium.com/debug-go-golang-with-emacs-fbf840c0aa56
;; - https://github.com/apmattil/.emacs/blob/master/.emacs

;; optional - provides fancy overlay information
;; https://ladicle.com/post/config/
(use-package lsp-ui
  :ensure t
  :after(lsp-mode)
  :commands lsp-ui-mode
  :config (progn
            ;; disable inline documentation
            (setq lsp-ui-sideline-enable nil)
            ;; disable showing docs on hover at the top of the window
            (setq lsp-ui-doc-enable nil)
            (setq lsp-ui-imenu-enable t)
            (setq lsp-ui-imenu-kind-position 'top)))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(inhibit-startup-screen t)
 '(lsp-ui-imenu-enable t)
 '(package-selected-packages
   '(treemacs dap-mode flycheck-golangci-lint projectile flx-ido yasnippet use-package lsp-ui go-mode flycheck company-lsp))
 '(tool-bar-mode nil))

;; use golangci
(use-package flycheck-golangci-lint
  :ensure t)

;; optional, provides snippets for method signature completion
(use-package yasnippet
  :ensure t)

(use-package lsp-mode
  :ensure t
  ;; uncomment to enable gopls http debug server
  ;; :custom (lsp-gopls-server-args '("-debug" "127.0.0.1:0"))
  :commands (lsp lsp-deferred)
  :hook (go-mode . lsp-deferred)
  :config (progn
            ;; use flycheck, not flymake
            (setq lsp-prefer-flymake nil)
            ;;(setq lsp-trace nil)
            (setq lsp-print-performance nil)
            (setq lsp-log-io nil)))

;; Go organize import
;; Make sure you don't have other goimports hooks enabled.
(add-hook 'go-mode-hook #'lsp-deferred)
(defun lsp-go-install-save-hooks ()
  (add-hook 'before-save-hook #'lsp-organize-imports t t))
(add-hook 'go-mode-ho(after! lsp-mode
                       (setq  lsp-go-analyses '((fieldalignment . t)
                                                (nilness . t)
                                                (shadow . t)
                                                (unusedparams . t)
                                                (unusedwrite . t)
                                                (useany . t)
                                                (unusedvariable . t)))))

;; Go debugger
(use-package! dap-mode
  :config
  (dap-mode 1)
  (setq! dap-print-io t)
  (require 'dap-hydra)
  (require 'dap-dlv-go)
  (use-package! dap-ui
    :ensure nil
    :config
    (dap-ui-mode 1)
    ))

;; optional package to get the error squiggles as you edit
(use-package flycheck
  :ensure t)

;; if you use company-mode for completion (otherwise, complete-at-point works out of the box):
(use-package company-lsp
  :ensure t
  ;;:after(company lsp-mode)
  :commands company-lsp)

(use-package hydra
  :ensure t
  :config
  (require 'hydra)
  (require 'dap-mode)
  (require 'dap-ui)
  :bind
  :init
  (add-hook! 'dap-stopped-hook
    (lambda (arg) (call-interactively #'hydra-go/body)))
  :hydra (hydra-go (:color pink :hint nil :foreign-keys run)
                   "
                     _n_: Next       _c_: Continue _g_: goroutines      _i_: break log
                     _s_: Step in    _o_: Step out _k_: break condition _h_: break hit condition
                     _Q_: Disconnect _q_: quit     _l_: locals
                   "
                   ("n" dap-next)
                   ("c" dap-continue)
                   ("s" dap-step-in)
                   ("o" dap-step-out)
                   ("g" dap-ui-sessions)
                   ("l" dap-ui-locals)
                   ("e" dap-eval-thing-at-point)
                   ("h" dap-breakpoint-hit-condition)
                   ("k" dap-breakpoint-condition)
                   ("i" dap-breakpoint-log-message)
                   ("q" nil "quit" :color blue)
                   ("Q" dap-disconnect :color red)))
