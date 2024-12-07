;;; go.el -*- lexical-binding: t; -*-

;; Based on:
;; - https://apmattil.medium.com/debug-go-golang-with-emacs-fbf840c0aa56
;; - https://github.com/apmattil/.emacs/blob/master/.emacs

;; optional - provides fancy overlay information
;; https://ladicle.com/post/config/
(use-package lsp-ui
  :after(lsp-mode)
  :commands lsp-ui-mode
  :config (progn
            ;; inline documentation
            (setq lsp-ui-sideline-enable t)
            ;; showing docs on hover at the top of the window
            (setq lsp-ui-doc-enable t)
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

(use-package lsp-mode
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

;; Make sure you don't have other goimports hooks enabled.
;; (add-hook 'go-mode-hook #'lsp-deferred)
;; (defun lsp-go-install-save-hooks ()
;;   (add-hook 'before-save-hook #'lsp-organize-imports t t))
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
    :config
    (dap-ui-mode 1)
  ))

;; if you use company-mode for completion (otherwise, complete-at-point works out of the box):
(use-package company-lsp
  :after(company lsp-mode)
  :commands company-lsp)

;; Locals vars are now visible and usable
(after! dap-ui
  (setq! dap-ui-variable-length 200))

;; Force refreshing treemacs panes
(lsp-treemacs-sync-mode 1)

;; Make debugger usable using emacs in console
(unless (display-graphic-p)
  (set-face-background 'dap-ui-marker-face "color-166") ; An orange background for the line to execute
  (set-face-attribute 'dap-ui-marker-face nil :inherit nil) ; Do not inherit other styles
  (set-face-background 'dap-ui-pending-breakpoint-face "blue") ; Blue background for breakpoints line
  (set-face-attribute 'dap-ui-verified-breakpoint-face nil :inherit 'dap-ui-pending-breakpoint-face)
)

;; Locals don't expand when doing dap-next, TODO debug
;; (defun next-expand()
;;   (interactive)
;;   (dap-next (dap--cur-session))
;;   (sleep-for 0.1)
;;   (dap-ui-locals))
(defun next-expand()
  (interactive)
  (dap-next (dap--cur-session)))

;; Shortcuts
(global-set-key [f5]  #'dap-continue)
(global-set-key [f9]  #'dap-breakpoint-toggle)
(global-set-key [f10] #'next-expand)
(global-set-key [f11] #'dap-step-in)
(global-set-key [f12] #'dap-step-out)

(map! :leader
      (
        :prefix ("d" . "DAP debugger menu")
        :desc "Start a new debug session" "d" #'dap-debug
        :desc "Next"                      "n" #'next-expand
        :desc "Continue"                  "c" #'dap-continue
        :desc "Step In"                   "s" #'dap-step-in
        :desc "Step Out"                  "o" #'dap-step-out
        :desc "Go routines"               "g" #'dap-ui-sessions
        :desc "Locals"                    "l" #'dap-ui-locals
        :desc "Eval things at point"      "e" #'dap-eval-thing-at-point
        :desc "Breakpoint hit condition"  "h" #'dap-breakpoint-hit-condition
        :desc "Breakpoint condition"      "k" #'dap-breakpoint-condition
        :desc "Breakpoint log message"    "i" #'dap-breakpoint-log-message
        :desc "Disconnect"                "Q" #'dap-disconnect
      )
)
