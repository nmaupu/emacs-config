;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
;;(setq doom-theme 'doom-one)
(setq doom-font (font-spec :family "CommitMono Nerd Font Mono" :size 17)
      doom-variable-pitch-font (font-spec :family "CommitMono Nerd Font Mono" :size 17))
(setq doom-theme 'doom-palenight)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
;;(setq display-line-numbers-type t)
(setq display-line-numbers-type 'relative)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

;; Move around windows
(map! "C-<left>"  #'windmove-left)
(map! "C-<right>" #'windmove-right)
(map! "C-<up>"    #'windmove-up)
(map! "C-<down>"  #'windmove-down)

;; Resize windows
(map! "C-S-<left>"  #'evil-window-decrease-width)
(map! "C-S-<right>" #'evil-window-increase-width)
(map! "C-S-<up>"    #'evil-window-increase-height)
(map! "C-S-<down>"  #'evil-window-decrease-height)

(map! :nvm "-" 'dired-jump)

;; Navigate through workspaces
; previous ws
(map! "M-<left>" #'+workspace/switch-left)
; next ws
(map! "M-<right>" #'+workspace/switch-right)

(when (display-graphic-p)
  (require 'all-the-icons))

;; Open the shortcut menu quicker
(setq! which-key-idle-delay 0.3)

;; Selecting text put it in the PRIMARY clipboard
(setq! evil-visual-update-x-selection-p t)

;; Disable mouse entirely
;; (use-package! disable-mouse)
;; (global-disable-mouse-mode t)
;; (mapc #'disable-mouse-in-keymap
;;       (list evil-motion-state-map
;;             evil-normal-state-map
;;             evil-visual-state-map
;;             evil-insert-state-map))

(company-terraform-init)

(add-hook 'company-mode-hook 'company-box-mode)
(use-package! company-box
  :defer t
  :config
  (setq-hook! 'prog-mode-hook
    company-box-frame-top-margin 20)
  (setq-hook! 'text-mode-hook
    company-box-frame-top-margin 75)
)


;;(add-to-list 'company-backends 'company-shell)

;;(add-hook! 'after-init-hook #'global-flycheck-mode)

;; (setq lsp-disabled-clients '(tfls))

;; 'before save a file' hook
(defun before-save-hook-custom ()
  (unless (eql (with-current-buffer (current-buffer) major-mode)
               'markdown-mode)
    (delete-trailing-whitespace)
    (doom/delete-trailing-newlines)
    ))
(defun before-save-hook-puppet ()
  (eql (with-current-buffer (current-buffer) major-mode
                            'puppet-mode)
       (delete-trailing-whitespace)
       (doom/delete-trailing-newlines)
       (puppet-align-block)))
(defun before-save-hook-terraform ()
  (eql (with-current-buffer (current-buffer) major-mode
                            'terraform-mode)
       (delete-trailing-whitespace)
       (doom/delete-trailing-newlines)
       (terraform-format-buffer)))
(add-hook! 'before-save-hook #'before-save-hook-custom)
(add-hook! 'before-save-hook #'before-save-hook-custom)
(add-hook! 'before-save-hook #'before-save-hook-puppet)
(add-hook! 'before-save-hook #'before-save-hook-terraform)

;; Avoid unwanted semgrep warning
(after! lsp-mode
  (defun ak-lsp-ignore-semgrep-rulesRefreshed (workspace notification)
    "Ignore semgrep/rulesRefreshed notification."
    (when (equal (gethash "method" notification) "semgrep/rulesRefreshed")
      (lsp--info "Ignored semgrep/rulesRefreshed notification")
      t)) ;; Return t to indicate the notification is handled

  (advice-add 'lsp--on-notification :before-until #'ak-lsp-ignore-semgrep-rulesRefreshed))

(use-package use-package-hydra
  :ensure t)

;; Display workspace name in modeline
(after! doom-modeline
  (setq! doom-modeline-persp-name t))

;; Activate clickable url in vterm
(add-hook! 'vterm-mode-hook
  (goto-address-mode t))

(load! "lsp-go.el")

;; TODO Debug
;; https://discourse.doomemacs.org/t/permanently-display-workspaces-in-the-tab-bar/4088
;;(load! "ws.el")
