(defun fn/reload-config ()
(interactive)
(org-babel-load-file
 (expand-file-name "config.org" user-emacs-directory)))

(setq org-src-tab-acts-natively t)

(setq
 user-full-name "Francis Murillo"
 user-mail-address "francisavmurillo@gmail.com")

(load "secret" t)

(unless (assoc-default "melpa" package-archives)
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/"))
  (add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/"))
  (add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
  (add-to-list 'package-archives '("melpa-stable" . "http://stable.melpa.org/packages/")))

(require 'use-package)
(setq use-package-verbose t)

(setq inhibit-startup-screen t)
(setq initial-scratch-message nil)

(set-language-environment "UTF-8")

(fset 'yes-or-no-p 'y-or-n-p)

(setq backup-directory-alist '(("." . "~/.emacs.d/backups")))

(setq delete-old-versions -1)
(setq version-conrol t)
(setq backup-by-copying t)
(setq vc-make-backup-files t)
;; FIXME: Hard coded path?
(setq auto-save-file-name-transforms '((".*" "~/.emacs.d/auto-save-list/" t)))

(savehist-mode 1)

(setq savehist-file (expand-file-name "savehist" user-emacs-directory))
(setq history-length t)
(setq history-delete-duplicates t)
(setq savehist-save-minibuffer-history 1)
(setq savehist-additional-variables
  '(kill-ring
    search-ring
    regexp-search-ring))

(tooltip-mode -1)
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)

(global-whitespace-mode t)
(global-auto-revert-mode t)
(global-visual-line-mode t)

(global-hl-line-mode t)

(set-frame-font "DejaVu Sans Mono-6" t t)

(unless (window-system) (load-theme 'tsdh-light))

(when (window-system) (load-theme 'tsdh-dark))

(global-set-key (kbd "RET") 'newline-and-indent)

(setq-default indent-tabs-mode nil)
(show-paren-mode t)
(add-hook 'before-save-hook 'delete-trailing-whitespace)

(setq search-whitespace-regexp ".*?")

(use-package winner
  :ensure t
  :config
  (winner-mode t))

(use-package ido
  :disabled t
  :defer t
  :ensure t
  :config
  (ido-mode t)
  (ido-everywhere t)
  (setq ido-enable-flex-matching 1)
  (setq ido-show-dot-for-dired 1)

  ;; vertical ido display is better, like my taskbar
  (use-package ido-vertical-mode
        :ensure t
        :defer t
        :config
        (ido-vertical-mode t)
        (setq ido-vertical-show-count t))

  ;; flex matching is a must
  (use-package flx-ido
        :ensure t
        :defer t
        :config
        (flx-ido-mode t)
        (setq ido-enable-flex-matching t)
        (setq ido-use-faces nil))

  ;; smex is a great addition as well
  (use-package smex
    :ensure t
    :defer t
    :bind (("M-x" . smex)
       ("C-c C-c M-x" . execute-extended-command))
    :config
    (smex-initialize))
  )

(use-package dired
  :config
  (setq dired-recursive-copies 'always)
  (require 'dired-x) ;; Allows multi open marked files
  (setq dired-dwim-target t))

(use-package smooth-scrolling
  :ensure t
  :config
  (require 'smooth-scrolling))

(use-package guru-mode
  :ensure t
  :config
  (guru-global-mode t)
)

(use-package nyan-mode
  :ensure t
  :config
  (nyan-mode t))

(use-package org
  :bind (("C-c l" . org-store-link)
         ("C-c a" . org-agenda))
  :config
  ;; Config
  (setq org-log-done 'time)

  ;; Setup
  (add-to-list 'org-modules 'org-drill)

  ;; Todo
  (setq org-todo-keywords
        '((sequence "INVESTIGATE(i)" "TODO(t)" "PENDING(p)" "|" "DONE(d)" "CANCELLED(c)")))

  ;; Capture
  (setq org-directory
        (expand-file-name "~/Fakespace/nobody-library"))
  (setq org-default-notes-file (concat org-directory "/capture.org")) ;; Personal org library

  (setq org-main-file (expand-file-name "main.org" org-directory))
  (setq org-review-file (expand-file-name "learning.org" org-directory))
  (setq org-todo-file (expand-file-name "todo.org" org-directory))
  (setq org-blog-file (expand-file-name "fnlog.org" org-directory))

  (define-key global-map "\C-cc" 'org-capture)  ;; Use suggested key binding
  (setq org-capture-templates
        (list
         (list "t" "Todo" 'entry
               (list 'file+headline org-todo-file "Todo")
               "* INVESTIGATE %?\n   %i\n  %a")
         (list "r" "Review/Remember" 'entry
               (list 'file+headline org-review-file "Learning Notes" "Review")
               "* %? :drill:\n  CREATED_ON: %T")))

  ;; Agenda
  (setq org-agenda-span 14) ;; Fortnight

  (setq org-planning-files
        (list
         org-main-file
         org-blog-file
         ))

  (setq org-task-files
        (list
         org-todo-file
         org-review-file))

  (setq org-agenda-files
        (append
         org-planning-files
         org-task-files))

  (setq org-refile-targets nil) ;; TODO: Make refile tagets

  ;; org-drill
  (require 'org-drill)
  (setq org-drill-scope
        (list org-review-file))

  ;; org-journal
  (use-package org-journal
    :ensure t
    :bind (("C-c e" . org-journal-new-entry)) ;; C-c j conflicts with normal org-mode
    :config
    (setq org-journal-dir
          (expand-file-name "diary" org-directory))
    ;; (setq org-agenda-file-regexp "\\`[^.].*\\.org'\\|[0-9]+")

    (setq org-journal-date-format "%Y-%b-%d %a") ;; YYYY-MMM-DD DAY
    (setq org-journal-time-format "%T ") ;; HH:MM:SS and the space is required

    (setq org-journal-file-format "%Y-%m-%d.journal.org.gpg") ;; Encryption via epa

    (defun fn/insert-private-file-headers ()
      (interactive)
      (insert "# -*- backup-inhibited t; auto-save-default nil; -*-\n"))

    (defun fn/insert-org-gpg-headers ()
      (interactive)
      (insert "# -*- epa-file-encrypt-to: (\"fnmurillo@yandex.com\") -*-\n")
      (fn/insert-private-file-headers))

    (defun fn/insert-org-journal-headers ()
      (interactive)
      (fn/insert-org-gpg-headers)

      (when (string-match "\\(20[0-9][0-9]\\)-\\([0-9][0-9]\\)-\\([0-9][0-9]\\)"
                          (buffer-name))
        (let ((year  (string-to-number (match-string 1 (buffer-name))))
              (month (string-to-number (match-string 2 (buffer-name))))
              (day   (string-to-number (match-string 3 (buffer-name))))
              (datim nil))
          (setq datim (encode-time 0 0 0 day month year))

          (insert (format-time-string
                   "#+TITLE: Journal Entry - %Y-%b-%d %a\n" datim))
          (insert (format-time-string
                   "* %Y-%b-%d %a" datim)))))

    (auto-insert-mode t)
    (setq auto-insert-query t) ;; Don't ask, just put it in there
    (add-hook 'find-file-hook 'auto-insert)

    (add-to-list 'auto-insert-alist '(".*\.org\.gpg$" . fn/insert-org-gpg-headers))
    (add-to-list 'auto-insert-alist '(".*\.private.org" . fn/insert-private-file-headers))
    (add-to-list 'auto-insert-alist '(".*\.journal.org.gpg" . fn/insert-org-journal-headers)))

  (require 'org-mobile)
  (setq org-mobile-directory
        (expand-file-name "mobile" org-directory))
  (setq org-mobile-inbox-for-pull
        (expand-file-name "mobile-pull" org-directory))
  (setq org-mobile-files
        (list org-review-file)))

(use-package projectile
  :ensure t
  :config
  (projectile-global-mode t)
  (setq projectile-indexing-method 'native)
  )

(use-package async
  :ensure t)

(use-package helm
  :ensure t
  :bind (("M-x" . helm-M-x)
         ("C-x C-f" . helm-find-files))
  :config
  (require 'helm-config)
  (setq helm-mode-fuzzy-match t)
  (setq helm-completion-in-region-fuzzy-match t)
  (helm-mode t))

(use-package helm-projectile
  :ensure t
  :config
  (setq projectile-completion-system 'helm)
  (helm-projectile-on))

(use-package helm-swoop
  :ensure t
  :bind (("M-i" . helm-swoop)
         ("C-c M-i" . helm-multi-swoop))
  :config
  (define-key helm-swoop-map (kbd "C-r") 'helm-previous-line)
  (define-key helm-swoop-map (kbd "C-s") 'helm-next-line)
  (define-key helm-multi-swoop-map (kbd "C-r") 'helm-previous-line)
  (define-key helm-multi-swoop-map (kbd "C-s") 'helm-next-line))

(use-package auto-complete
  :ensure t
  :config
  (require 'auto-complete-config)
  (ac-config-default)
  (global-auto-complete-mode)
  (setq popup-use-optimized-column-computation nil))

(use-package yasnippet
:ensure t
:defer t)

(use-package emmet-mode
  :ensure t
  :defer t)

(use-package flycheck
  :ensure t
  :defer t)

(use-package flyspell
  :ensure t)

(use-package js3-mode
  :ensure t
  :defer t)

(use-package sass-mode
  :ensure t
  :defer t
  :config
  ((add-to-list 'auto-mode-alist '("\\.sass\\'" . sass-mode))))

(use-package cedet
  :load-path "elisp/cedet/lisp"
  :defer t)

(use-package auto-compile
  :ensure t
  :defer t
  :config
  (auto-compile-on-load-mode)
  (auto-compile-on-save-mode))

(use-package twittering-mode
  :ensure t
  :defer t
  :init
  (setq twittering-auth-method 'oauth)
  (setq twittering-use-master-password t)
  :config
  (twittering-icon-mode t)
  (setq twittering-convert-fix-size 24))

(setq mail-authentication-file (expand-file-name ".authinfo.gpg"))

(setq gnus-select-method
      '(nnimap "imap.gmail.com"
               (nnimap-stream ssl)
               (nnimap-authinfo-file mail-authentication-file)))

(setq gnus-secondary-select-methods
      '((nnimap "imap.yandex.com"
                (nnimap-stream ssl)
                (nnimap-authinfo-file mail-authentication-file))))

(require 'epa-file)
(epa-file-enable)

(defun fn/backup-each-save-filter (filename)
  (let ((ignored-filenames
         '("\\.gpg$"))
        (matched-ignored-filename nil))
    (mapc
     (lambda (x)
       (when (string-match x filename)
         (setq matched-ignored-filename t)))
     ignored-filenames)
    (not matched-ignored-filename)))

(setq backup-each-save-filter-function 'fn/backup-each-save-filter)

(defun fn/load-projectile-hook ()
      (interactive)
      (mapcar (lambda (project)
       (setq fn/current-project (expand-file-name project))
       (load
        (expand-file-name ".projectile-hook" fn/current-project)
        t))
projectile-known-projects))


