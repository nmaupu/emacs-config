;;; misc/todos.el -*- lexical-binding: t; -*-

;; hl-todo custom faces and items
(after! hl-todo
  (defface my-TODO-face
    '((t :background "#3f8bae" :foreground "#ceeefd" :inherit (hl-todo)))
    "Face for highlighting the TODO keyword."
    :group 'hl-todo)
  (defface my-NOTE-face
    '((t :background "#026304" :foreground "#68fa6b" :inherit (hl-todo)))
    "Face for highlighting the NOTE keyword."
    :group 'hl-todo)
  (defface my-FIXME-face
    '((t :background "#f11c1c" :foreground "#fbbbbb" :inherit (hl-todo)))
    "Face for highlighting the FIXME keyword."
    :group 'hl-todo)
  (defface my-HACK-face
    '((t :background "#cc9a00" :foreground "#ffe080" :inherit (hl-todo)))
    "Face for highlighting the HACK keyword."
    :group 'hl-todo)
  (defface my-WARN-face
    '((t :background "#ff00c9" :foreground "#ff99e9" :inherit (hl-todo)))
    "Face for highlighting the WARN keyword."
    :group 'hl-todo)

  ;; remove existing todo:
  (setq! hl-todo-keyword-faces
         '(("TODO" . my-TODO-face)
           ("NOTE" . my-NOTE-face)
           ("FIXME" . my-FIXME-face)
           ("HACK" . my-HACK-face)
           ("WARN" . my-WARN-face)))
)
