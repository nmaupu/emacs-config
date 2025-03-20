(defun re-seq (regexp string)
  "Get a list of all regexp matches in a string"
  (save-match-data
    (let ((pos 0)
          matches)
      (while (string-match regexp string pos)
        (push (match-string 0 string) matches)
        (setq pos (match-end 0)))
      matches)))

(defun get-hashes-from-region ()
  (interactive)
  (kill-new
   (string-join
    (delete-dups
     (re-seq "[0-9a-f]\\{32,40\\}" (buffer-substring-no-properties (region-beginning) (region-end))))
    " ")))

(map! :leader "kH" 'get-hashes-from-region)
