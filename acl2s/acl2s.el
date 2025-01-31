;;; acl2s.el --- Basic Proof General instance for ACL2s

;; This file is part of Proof General.

;; Based on the acl2 configuration:

;; Portions © Copyright 1994-2012  David Aspinall and University of Edinburgh
;; Portions © Copyright 2003-2018  Free Software Foundation, Inc.
;; Portions © Copyright 2001-2017  Pierre Courtieu
;; Portions © Copyright 2010, 2016  Erik Martin-Dorel
;; Portions © Copyright 2011-2013, 2016-2017  Hendrik Tews
;; Portions © Copyright 2015-2017  Clément Pit-Claudel
;; Portions © Copyright 2021-* Jacob Chvatal

;; License:   GPL (GNU GENERAL PUBLIC LICENSE)

;; Author:    David Aspinall <David.Aspinall@ed.ac.uk>

;;; Commentary:
;;
;; Needs improvement!
;;
;; See the README file in this directory for information.

;;; Code:

(require 'proof-easy-config)            ; easy configure mechanism
(require 'proof-syntax)			; functions for making regexps

(add-to-list 'auto-mode-alist                ; ACL2 uses two file extensions
                                             ; Only grab .lisp extension after
             (cons "\\.lisp\\'" 'acl2-mode)) ; an acl2 file has been loaded

(proof-easy-config  'acl2s "ACL2s"
 proof-assistant-home-page "http://acl2s.ccs.neu.edu/acl2s/doc/"
 proof-prog-name		 "acl2s"

 proof-script-sexp-commands	 t
 proof-script-comment-start	";"

 proof-shell-annotated-prompt-regexp "ACL2s[ !]*>+"

 proof-save-command-regexp	 "(def\\w+\\s "
 proof-goal-command-regexp       "(def\\w+\\s "
 proof-save-with-hole-regexp     "(def\\w+[ \t\n]+\\(\\w+\\)"
 proof-save-with-hole-result	 1
 proof-shell-error-regexp
 "^Error: \\|Error in TOP-LEVEL: \\|\\*\\*\\*\\* FAILED \\*\\*\\*"
 proof-shell-interrupt-regexp    "Correctable error: Console interrupt."

 proof-shell-quit-cmd            ":q"	 ;; FIXME: followed by C-d.
 proof-shell-restart-cmd	 ":q\n:q\n:q\n(lp)\n"    ;; FIXME: maybe not?
 proof-info-command		 ":help"
 proof-undo-n-times-cmd		 ":ubt %s"  ;; shouldn't give errors
 proof-forget-id-command	 ":ubt %s"  ;; so use ubt not ubt!
 proof-context-command		 ":pbt :max"
 ;; proof-showproof-cmd		 ":pbt :here"

 proof-shell-truncate-before-error nil

 ;;
 ;; Syntax table entries for proof scripts  (FIXME: incomplete)
 ;;
 proof-script-syntax-table-entries
 '(?\[ "(]  "
   ?\] "([  "
   ?\( "()  "
   ?\) ")(  "
   ?.  "w   "
   ?_  "w   "
   ?-  "w   "
   ?>  "w   " ;; things treated as names can have > in them
   ?#  "'   "
   ?\' "'    "
   ?`  "'    "
   ?,  "'    "
   ?\| "."
   ?\; "<    "
   ?\n ">    "
   )

 ;; A tiny bit of syntax highlighting
 ;;
 proof-script-font-lock-keywords
 (append
  (list
   (proof-ids-to-regexp '("defthm" "defabbrev" "defaxiom" "defchoose"
			  "defcong" "defconst" "defdoc" "defequiv"
			  "defevaluator" "defpackage" "deflabel" "deftheory"
			  "implies" "equal" "and")))
  (if (boundp 'lisp-font-lock-keywords) ;; wins if font-lock is loaded
      lisp-font-lock-keywords))


 ;; End of easy config.
 )

;; Interrupts and errors enter another loop; break out of it
(add-hook
 'proof-shell-handle-error-or-interrupt-hook
 (lambda () (if (eq proof-shell-error-or-interrupt-seen 'interrupt)
		(proof-shell-insert ":q" nil))))



(warn "ACL2s Proof General is incomplete!  Please help improve it!
Please add improvements at https://github.com/ProofGeneral/PG")

(provide 'acl2s)
;;; acl2s.el ends here
