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
;; (setq doom-theme 'doom-monokai-pro)
(setq doom-theme 'doom-palenight)
(doom-themes-org-config)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
;;(setq display-line-numbers-type t)
(setq display-line-numbers-type 'relative)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

(setq show-trailing-whitespace t)


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
(map! :nivem "C-<left>"  #'windmove-left)
(map! :nivem "C-<right>" #'windmove-right)
(map! :nivem "C-<up>"    #'windmove-up)
(map! :nivem "C-<down>"  #'windmove-down)

;; Resize windows
(map! :nivem "C-S-<left>"  #'evil-window-decrease-width)
(map! :nivem "C-S-<right>" #'evil-window-increase-width)
(map! :nivem "C-S-<up>"    #'evil-window-increase-height)
(map! :nivem "C-S-<down>"  #'evil-window-decrease-height)

; Save with C-s
(map! :ni "C-s" #'save-buffer)

(map! :nvm "-" 'dired-jump)

;; Navigate through workspaces
; previous ws
(map! "M-<left>" #'+workspace/switch-left)
; next ws
(map! "M-<right>" #'+workspace/switch-right)

(map! :map dired-mode-map
      :n "." #'dired-create-empty-file)

;; (when (display-graphic-p)
;;   (require 'all-the-icons))

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

;;(add-hook 'company-mode-hook 'company-box-mode)
;;(use-package! company-box
;;  :defer t
;;  :config
;;  (setq-hook! 'prog-mode-hook
;;    company-box-frame-top-margin 20)
;;  (setq-hook! 'text-mode-hook
;;    company-box-frame-top-margin 20)
;;)

;; Save with :w or :W for clumsy fingers
(evil-ex-define-cmd "W" #'evil-write)
(evil-ex-define-cmd "X" #'evil-save-and-quit)


;;(add-to-list 'company-backends 'company-shell)

;;(add-hook! 'after-init-hook #'global-flycheck-mode)

;;(setq lsp-disabled-clients '(tfls))

;; 'before save a file' hooks
(defun before-save-hook-custom ()
  (unless (eql (with-current-buffer (current-buffer) major-mode)
               'markdown-mode))
    (delete-trailing-whitespace)
    (doom/delete-trailing-newlines)
)

(defun before-save-hook-puppet ()
  (eql (with-current-buffer (current-buffer) major-mode)
       'puppet-mode)
       (delete-trailing-whitespace)
       (doom/delete-trailing-newlines)
       (puppet-align-block)
)

(defun before-save-hook-terraform ()
  (when (eq major-mode 'terraform-mode)
    (terraform-format-buffer))
)

(defun before-save-hook-go ()
  (when (eq major-mode 'go-mode)
    (gofmt))
)

(defun before-save-hook-jsonnet ()
  (when (eq major-mode 'jsonnet-mode)
    (jsonnet-reformat-buffer))
)

;(add-hook! 'before-save-hook #'before-save-hook-puppet)
(add-hook! 'before-save-hook #'before-save-hook-go)
(add-hook! 'before-save-hook #'before-save-hook-custom)
(add-hook! 'before-save-hook #'before-save-hook-terraform)
(add-hook! 'before-save-hook #'before-save-hook-jsonnet)

;; Avoid unwanted semgrep warning
(after! lsp-mode
  (defun ak-lsp-ignore-semgrep-rulesRefreshed (workspace notification)
    "Ignore semgrep/rulesRefreshed notification."
    (when (equal (gethash "method" notification) "semgrep/rulesRefreshed")
      (lsp--info "Ignored semgrep/rulesRefreshed notification")
      t)) ;; Return t to indicate the notification is handled
  (advice-add 'lsp--on-notification :before-until #'ak-lsp-ignore-semgrep-rulesRefreshed))

;; Display workspace name in modeline
(after! doom-modeline
  (setq! doom-modeline-persp-name t))

;; Show indicators in the left fringe
(after! flycheck
  (setq! flycheck-indication-mode 'left-fringe))

;;
;; vterm related configurations

;; Activate clickable url in vterm
(add-hook! 'vterm-mode-hook
  (goto-address-mode t))

;; Get C-c and ESC key working
(add-hook! 'vterm-mode-hook
  (unless evil-collection-vterm-send-escape-to-vterm-p
    (evil-collection-vterm-toggle-send-escape)))
(map! :after vterm
      :map vterm-mode-map
      :ni "C-c" #'vterm--self-insert)

;; popper is better popups
(use-package! popper
  :init
  (setq popper-reference-buffers
        '("\\*Messages\\*"
          "Output\\*$"
          "\\*Async Shell Command\\*"
          " log\\*$" ; dap console window
          help-mode
          compilation-mode))
  (popper-mode +1)
  (popper-echo-mode +1))
(map! :nivem "C-p"  #'popper-toggle)
(map! :nivem "M-p"  #'popper-cycle)
(map! :nivem "C-M-p"  #'popper-toggle-type)
;; Put the log message buffer at the bottom with a specific size
(add-to-list 'display-buffer-alist '(" log\\*" display-buffer-at-bottom (window-height . 0.2) (slot -1)))
(set-popup-rules!
  '(
    (" log\\*" :slot -1)
   )
)

;; Disabling buggy treemacs git mode
(after! treemacs
  (treemacs-git-mode -1)
)
;; Add a magit command to amend last commit and force push to the current branch
(defun git-amend-force-push ()
  "Git amend last commit and force push to pushremote"
  (interactive)
  (magit-stage-modified)
  (magit-commit-extend)
  (magit-push-current-to-pushremote "-f")
  (magit-mode-quit-window t)
)
(map! :map magit-mode-map
      :n "C-f" #'git-amend-force-push)

(after! jsonnet-mode
  (setq jsonnet-use-smie t)
  (setq jsonnet-command "jsonnet")
  ;; (setq jsonnet-library-search-directories (list (concat (projectile-project-root) "deploy/vendor")))
  ;; (setq jsonnet-library-search-directories (append (list (concat (projectile-project-root) "deploy/vendor")) (list (concat (projectile-project-root) "deploy"))))
  (setq jsonnet-library-search-directories '("/home/nmaupu/work/perso/gotomation/deploy/vendor" "/home/nmaupu/work/perso/gotomation/deploy"))
  (setq jsonnet-indent-level 2)
)

;;
;; loading extra configurations
(load! "misc/lsp.el")
(load! "misc/todos.el")
(load! "misc/jsonnet-language-server.el")
;; (load! "misc/org.el")

;; TODO Debug
;; https://discourse.doomemacs.org/t/permanently-display-workspaces-in-the-tab-bar/4088
;;(load! "misc/ws.el")
