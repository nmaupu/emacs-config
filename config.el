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
;; (doom-themes-org-config)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
;;(setq display-line-numbers-type t)
(setq display-line-numbers-type 'relative)

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

(map! :after dired
      :map dired-mode-map
      :nv "." #'dired-create-empty-file)

(map! :after evil
      :mode dired-mode
      :nv "u" #'dired-unmark)

(map! :nv "C-d" (lambda()(interactive) (evil-scroll-down 0) (recenter)))
(map! :nv "C-u" (lambda()(interactive) (evil-scroll-up 0)   (recenter)))

;; Rebind C-c to copy to a specific register
(map! :after evil
      :v "C-c" #'copy-to-register)

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

;; (company-terraform-init)

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

;; Replace 'vterm-toggle' with 'vterm' as toggling has weird display bug sometimes under Guix
(map! :leader
      :desc "Open vterm" "o t" #'vterm)

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
(map! :nivem "C-p"   #'popper-toggle)
(map! :nivem "M-p"   #'popper-cycle)
(map! :nivem "C-M-p" #'popper-toggle-type)
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

;; Add shortcuts to magit help menu
;;(transient-insert-suffix 'magit-dispatch (kbd "h") '("p" "Pull" magit-pull))
;; Remove existing shortcut from magit help menu
;;(transient-remove-suffix 'magit-dispatch '("F"))

(after! jsonnet-mode
  (setq jsonnet-use-smie t)
  (setq jsonnet-command "jsonnet")
  ;; (setq jsonnet-library-search-directories (list (concat (projectile-project-root) "deploy/vendor")))
  ;; (setq jsonnet-library-search-directories (append (list (concat (projectile-project-root) "deploy/vendor")) (list (concat (projectile-project-root) "deploy"))))
  (setq jsonnet-library-search-directories '("/home/nmaupu/work/perso/gotomation/deploy/vendor" "/home/nmaupu/work/perso/gotomation/deploy"))
  (setq jsonnet-indent-level 2)
)

;; treesitter configuration

;;(setq treesit-language-source-alist
;;   '((bash "https://github.com/tree-sitter/tree-sitter-bash")
;;     (cmake "https://github.com/uyha/tree-sitter-cmake")
;;     (css "https://github.com/tree-sitter/tree-sitter-css")
;;     (elisp "https://github.com/Wilfred/tree-sitter-elisp")
;;     (go "https://github.com/tree-sitter/tree-sitter-go")
;;     (html "https://github.com/tree-sitter/tree-sitter-html")
;;     (javascript "https://github.com/tree-sitter/tree-sitter-javascript" "master" "src")
;;     (json "https://github.com/tree-sitter/tree-sitter-json")
;;     (make "https://github.com/alemuller/tree-sitter-make")
;;     (markdown "https://github.com/ikatyang/tree-sitter-markdown")
;;     (python "https://github.com/tree-sitter/tree-sitter-python")
;;     (toml "https://github.com/tree-sitter/tree-sitter-toml")
;;     (tsx "https://github.com/tree-sitter/tree-sitter-typescript" "master" "tsx/src")
;;     (typescript "https://github.com/tree-sitter/tree-sitter-typescript" "master" "typescript/src")
;;     (yaml "https://github.com/ikatyang/tree-sitter-yaml")))
;;(setq major-mode-remap-alist
;; '((yaml-mode . yaml-ts-mode)
;;   (bash-mode . bash-ts-mode)
;;   (js2-mode . js-ts-mode)
;;   (typescript-mode . typescript-ts-mode)
;;   (json-mode . json-ts-mode)
;;   (css-mode . css-ts-mode)
;;   (go-mode . go-ts-mode)
;;   (python-mode . python-ts-mode)))

;;
;; loading extra configurations
(load! "misc/lsp.el")
(load! "misc/todos.el")
(load! "misc/jsonnet-language-server.el")
(load! "misc/prod-cli.el")

;; TODO Debug
;; https://discourse.doomemacs.org/t/permanently-display-workspaces-in-the-tab-bar/4088
;;(load! "misc/ws.el")

; gptel
(gptel-make-gh-copilot "Copilot")
(setq gptel-model 'gpt-4o
      gptel-backend (gptel-make-gh-copilot "Copilot"))

; Fixing some highlight colors
(after! lsp-mode
  (custom-set-faces!
    '(lsp-face-highlight-textual
      :background "#ff79c6"
      :foreground "#1e1e1e"
      :weight bold)))

(after! paren
  (add-hook 'show-paren-mode-hook
            (lambda ()
              (when (facep 'show-paren-match)
                (set-face-attribute 'show-paren-match nil
                                    :foreground "#ffb6c1"
                                    :background "#d94fe6"
                                    :weight 'bold))))
  (setq show-paren-style 'mixed))

;; Enable clipboard access in terminal using xclip with yy
(unless (display-graphic-p)
  (setq x-select-enable-clipboard-manager t)
  (setq interprogram-cut-function
        (lambda (text &optional _)
          (when text
            (let ((process-connection-type nil))
              (let ((proc (start-process "xclip" "*Messages*" "xclip" "-selection" "clipboard")))
                (process-send-string proc text)
                (process-send-eof proc))))))
  (setq interprogram-paste-function
        (lambda ()
          (let ((xclip-output (shell-command-to-string "xclip -o -selection clipboard")))
            (unless (string= (car kill-ring) xclip-output)
              xclip-output)))))

;;
;; Force projectile to ignore home directory
(after! projectile
  (add-to-list 'projectile-ignored-projects "~/"))

;; Remove the home dir if it was mistakenly added
(after! lsp-mode
  (add-hook! 'go-mode-hook
    (when (member (expand-file-name "~") (lsp-session-folders (lsp-session)))
      (lsp-workspace-folders-remove (expand-file-name "~"))
      (lsp-workspace-folders-add (projectile-project-root)))))

;; lsp nix
(after! lsp-mode
  (use-package! lsp-nix
    :ensure lsp-mode
    :after (lsp-mode)
    :demand t
    :custom
    (lsp-nix-nil-formatter ["nixfmt"])))

(after! lsp-mode
  (use-package! nix-mode
    :hook (nix-mode . lsp-deferred)
    :ensure t))
